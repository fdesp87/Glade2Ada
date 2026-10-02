------------------------------------------------------------------------------
--                 G L A D E    T O     A d a                               --
--                                                                          --
--                     Copyright (C) 2025 Juan L. Freniche                  --
--                                                                          --
-- This program is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. It is is distributed in the hope that it will be useful,        --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the file COPYING3.  If not, see <http://www.gnu.org/licenses/>.      --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
pragma Warnings (Off);
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
pragma Warnings (On);

with G2a.Build_Tree;
with GNAT.OS_Lib;

with Glade_Scanner;
with Glade_Scanner_Dfa;
with Glade_Scanner_Io; use Glade_Scanner_Io;
with Glade_Parser_Tokens;
with Glade_Parser_Goto;
with Glade_Parser_Shift_Reduce;

package body Glade_Parser is

   --  ----------------------------------------------------------------------
   --  Error reporting and recovery support
   --  ----------------------------------------------------------------------

   procedure Yyerror (S : String; Tk : Glade_Parser_Tokens.Token);
   procedure Yyerror (S : String; Tk : Glade_Parser_Tokens.Token) is
      The_Line : String (1 .. 1_024);
      Last     : Natural;
      Col      : constant Natural := Yy_Begin_Column;
      Lin      : constant Natural := Yy_Line_Number;
      Spaces   : constant String (1 .. Natural'Max (Col - 1, 0)) :=
        (others => ' ');
   begin
      Error_Count := Error_Count + 1;

      Put_Line
        (Standard_Error,
         "error (" & Error_Count'Image & " of" & Max_Errors'Image & "): " & S);
      Put_Line
        (Standard_Error,
         "  at line" & Lin'Image & ", column" & Col'Image & ", near token " &
         Tk'Image);

      Yy_Get_Token_Line (The_Line, Last);
      if Last > 0 then
         Put_Line (Standard_Error, "  " & The_Line (1 .. Last - 1));
         Put_Line (Standard_Error, "  " & Spaces & "^");
      end if;

      if Error_Count >= Max_Errors then
         Put_Line
           (Standard_Error,
            "Too many errors (" & Max_Errors'Image & ") -- aborting parse.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;
   end Yyerror;

   function Yylex return Glade_Parser_Tokens.Token;
   function Yylex return Glade_Parser_Tokens.Token is
      use Glade_Scanner_Dfa;
   begin
      Glade_Parser_Tokens.Yylval := To_Unbounded_String (Yytext);
      return Glade_Scanner.Yylex;
   end Yylex;

   pragma Style_Checks (Off);
   pragma Warnings (Off);

   procedure Yyparse is
      --  Rename User Defined Packages to Internal Names.
      package Yy_Goto_Tables renames Glade_Parser_Goto;
      package Yy_Shift_Reduce_Tables renames Glade_Parser_Shift_Reduce;
      package Yy_Tokens renames Glade_Parser_Tokens;

      use Yy_Tokens, Yy_Goto_Tables, Yy_Shift_Reduce_Tables;

      procedure Yyerrok;
      procedure Yyclearin;
      procedure Handle_Error;

      subtype Goto_Row is Yy_Goto_Tables.Row;
      subtype Reduce_Row is Yy_Shift_Reduce_Tables.Row;

      package Yy is

         --  the size of the value and state stacks
         --  Affects error 'Stack size exceeded on state_stack'
         Stack_Size : constant Natural := 8_192;

         --  subtype rule         is Natural;
         subtype Parse_State is Natural;
         --  subtype nonterminal  is Integer;

         --  encryption constants
         Default           : constant := -1;
         First_Shift_Entry : constant := 0;
         Accept_Code       : constant := -3_001;
         Error_Code        : constant := -3_000;

         --  stack data used by the parser
         Tos         : Natural := 0;
         Value_Stack : array (0 .. Stack_Size) of Yy_Tokens.Yystype;
         State_Stack : array (0 .. Stack_Size) of Parse_State;

         --  current input symbol and action the parser is on
         Action       : Integer;
         Rule_Id      : Rule;
         Input_Symbol : Yy_Tokens.Token := Error;

         --  error recovery flag
         Error_Flag : Natural := 0;
         --  indicates  3 - (number of valid shifts after an error occurs)

         Look_Ahead : Boolean := True;
         Index      : Reduce_Row;

         --  Is Debugging option on or off
         Debug : constant Boolean := False;
      end Yy;

      procedure Shift_Debug
        (State_Id : Yy.Parse_State; Lexeme : Yy_Tokens.Token);
      procedure Reduce_Debug (Rule_Id : Rule; State_Id : Yy.Parse_State);

      function Goto_State
        (State : Yy.Parse_State; Sym : Nonterminal) return Yy.Parse_State;

      function Parse_Action
        (State : Yy.Parse_State; T : Yy_Tokens.Token) return Integer;

      pragma Inline (Goto_State, Parse_Action);

      function Goto_State
        (State : Yy.Parse_State; Sym : Nonterminal) return Yy.Parse_State
      is
         Index : Goto_Row;
      begin
         Index := Goto_Offset (State);
         while Goto_Matrix (Index).Nonterm /= Sym loop
            Index := Index + 1;
         end loop;
         return Integer (Goto_Matrix (Index).Newstate);
      end Goto_State;

      function Parse_Action
        (State : Yy.Parse_State; T : Yy_Tokens.Token) return Integer
      is
         Index   : Reduce_Row;
         Tok_Pos : Integer;
         Default : constant Integer := -1;
      begin
         Tok_Pos := Yy_Tokens.Token'Pos (T);
         Index   := Shift_Reduce_Offset (State);
         while Integer (Shift_Reduce_Matrix (Index).T) /= Tok_Pos
           and then Integer (Shift_Reduce_Matrix (Index).T) /= Default
         loop
            Index := Index + 1;
         end loop;
         return Integer (Shift_Reduce_Matrix (Index).Act);
      end Parse_Action;

      --  error recovery stuff

      procedure Handle_Error is
         Temp_Action : Integer;
      begin

         if Yy.Error_Flag = 3 then --  no shift yet, clobber input.
            if Yy.Input_Symbol = Yy_Tokens.End_Of_Input then  -- don't discard,
               if Yy.Debug then
                  Ada.Text_IO.Put_Line
                    ("  -- Ayacc.YYParse: Can't discard END_OF_INPUT," &
                     " quiting...");
               end if;
               raise Yy_Tokens.Syntax_Error;
            end if;

            Yy.Look_Ahead := True;   --  get next token
            return;                  --  and try again...
         end if;

         if Yy.Error_Flag = 0 then --  brand new error
            Yyerror ("Syntax Error", Yy.Input_Symbol);
         end if;

         Yy.Error_Flag := 3;

         --  find state on stack where error is a valid shift --

         if Yy.Debug then
            Ada.Text_IO.Put_Line
              ("  -- Ayacc.YYParse: Looking for state with" &
               " error as valid shift");
         end if;

         loop
            if Yy.Debug then
               Ada.Text_IO.Put_Line
                 ("  -- Ayacc.YYParse: Examining State " &
                  Yy.Parse_State'Image (Yy.State_Stack (Yy.Tos)));
            end if;
            Temp_Action := Parse_Action (Yy.State_Stack (Yy.Tos), Error);

            if Temp_Action >= Yy.First_Shift_Entry then
               if Yy.Tos = Yy.Stack_Size then
                  Ada.Text_IO.Put_Line
                    ("  -- Ayacc.YYParse: Stack size exceeded on state_stack");
                  raise Yy_Tokens.Syntax_Error;
               end if;
               Yy.Tos                  := Yy.Tos + 1;
               Yy.State_Stack (Yy.Tos) := Temp_Action;
               exit;
            end if;

            if Yy.Tos /= 0 then
               Yy.Tos := Yy.Tos - 1;
            end if;

            if Yy.Tos = 0 then
               if Yy.Debug then
                  Ada.Text_IO.Put_Line
                    ("  -- Ayacc.YYParse: Error recovery popped entire stack, aborting...");
               end if;
               raise Yy_Tokens.Syntax_Error;
            end if;
         end loop;

         if Yy.Debug then
            Ada.Text_IO.Put_Line
              ("  -- Ayacc.YYParse: Shifted error token in state " &
               Yy.Parse_State'Image (Yy.State_Stack (Yy.Tos)));
         end if;

      end Handle_Error;

      --  print debugging information for a shift operation
      procedure Shift_Debug
        (State_Id : Yy.Parse_State; Lexeme : Yy_Tokens.Token)
      is
      begin
         Ada.Text_IO.Put_Line
           ("  -- Ayacc.YYParse: Shift " & Yy.Parse_State'Image (State_Id) &
            " on input symbol " & Yy_Tokens.Token'Image (Lexeme));
      end Shift_Debug;

      --  print debugging information for a reduce operation
      procedure Reduce_Debug (Rule_Id : Rule; State_Id : Yy.Parse_State) is
      begin
         Ada.Text_IO.Put_Line
           ("  -- Ayacc.YYParse: Reduce by rule " & Rule'Image (Rule_Id) &
            " goto state " & Yy.Parse_State'Image (State_Id));
      end Reduce_Debug;

      --  make the parser believe that 3 valid shifts have occured.
      --  used for error recovery.
      procedure Yyerrok is
      begin
         Yy.Error_Flag := 0;
      end Yyerrok;

      --  called to clear input symbol that caused an error.
      procedure Yyclearin is
      begin
         --  yy.input_symbol := YYLex;
         Yy.Look_Ahead := True;
      end Yyclearin;

   begin
      --  initialize by pushing state 0 and getting the first input symbol
      Yy.State_Stack (Yy.Tos) := 0;

      loop
         Yy.Index := Shift_Reduce_Offset (Yy.State_Stack (Yy.Tos));
         if Integer (Shift_Reduce_Matrix (Yy.Index).T) = Yy.Default then
            Yy.Action := Integer (Shift_Reduce_Matrix (Yy.Index).Act);
         else
            if Yy.Look_Ahead then
               Yy.Look_Ahead   := False;
               Yy.Input_Symbol := Yylex;
            end if;
            Yy.Action :=
              Parse_Action (Yy.State_Stack (Yy.Tos), Yy.Input_Symbol);
         end if;

         if Yy.Action >= Yy.First_Shift_Entry then  --  SHIFT

            if Yy.Debug then
               Shift_Debug (Yy.Action, Yy.Input_Symbol);
            end if;

            --  Enter new state
            if Yy.Tos = Yy.Stack_Size then
               Ada.Text_IO.Put_Line (" Stack size exceeded on state_stack");
               raise Yy_Tokens.Syntax_Error;
            end if;
            Yy.Tos                  := Yy.Tos + 1;
            Yy.State_Stack (Yy.Tos) := Yy.Action;
            Yy.Value_Stack (Yy.Tos) := Yylval;

            if Yy.Error_Flag > 0 then  --  indicate a valid shift
               Yy.Error_Flag := Yy.Error_Flag - 1;
            end if;

            --  Advance lookahead
            Yy.Look_Ahead := True;

         elsif Yy.Action = Yy.Error_Code then       -- ERROR
            Handle_Error;

         elsif Yy.Action = Yy.Accept_Code then
            if Yy.Debug then
               Ada.Text_IO.Put_Line
                 ("  --  Ayacc.YYParse: Accepting Grammar...");
            end if;
            exit;

         else --  Reduce Action

            --  Convert action into a rule
            Yy.Rule_Id := Rule (-1 * Yy.Action);

            --  Execute User Action
            --  user_action(yy.rule_id);
            case Yy.Rule_Id is
               --  pragma Style_Checks (Off);

               when 2 => -- #line 100

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("xml version=" &
                        To_String (Yy.Value_Stack (Yy.Tos - 3)) &
                        " encoding=" &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;

               when 5 => -- #line 110

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Generated with " &
                        To_String (Yy.Value_Stack (Yy.Tos - 2)) & " version " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;

               when 9 => -- #line 128

                  --  Recover at interface level after a serious error.
                  Yyerrok;

               when 10 => -- #line 135

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Opening interface");
                  end if;

               when 11 => -- #line 143

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Closing interface");
                  end if;

               when 15 => -- #line 156

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Requires " & To_String (Yy.Value_Stack (Yy.Tos - 3)) &
                        " version " & To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;

               when 16 => -- #line 164

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Local Interface Path " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;

               when 19 => -- #line 177

                  --  Recover from a malformed object and continue
                  --  with the next one.
                  Yyerrok;

               when 30 => -- #line 197

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       (To_String (Yy.Value_Stack (Yy.Tos - 3)) & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Create_Object
                    (To_String (Yy.Value_Stack (Yy.Tos - 3)),
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 31 => -- #line 204

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       (To_String (Yy.Value_Stack (Yy.Tos - 1)) & " (no id)");
                  end if;
                  G2a.Build_Tree.Create_Object
                    (To_String (Yy.Value_Stack (Yy.Tos - 1)), "");

               when 32 => -- #line 217

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Close current object");
                  end if;
                  G2a.Build_Tree.Close_Current_Object;

               when 33 => -- #line 224

            --  Recover by closing the current object after an error inside it.
                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Close current object (after error recovery)");
                  end if;
                  Yyerrok;
                  G2a.Build_Tree.Close_Current_Object;

               when 34 => -- #line 236

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       (To_String (Yy.Value_Stack (Yy.Tos - 3)) & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)) &
                        " (autocerrado)");
                  end if;
                  G2a.Build_Tree.Create_Object
                    (To_String (Yy.Value_Stack (Yy.Tos - 3)),
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  G2a.Build_Tree.Close_Current_Object;

               when 35 => -- #line 244

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       (To_String (Yy.Value_Stack (Yy.Tos - 1)) &
                        " (no id) (autocerrado)");
                  end if;
                  G2a.Build_Tree.Create_Object
                    (To_String (Yy.Value_Stack (Yy.Tos - 1)), "");
                  G2a.Build_Tree.Close_Current_Object;

               when 37 => -- #line 259

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("items start");
                  end if;
                  G2a.Build_Tree.Items_Start;

               when 38 => -- #line 267

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("items end");
                  end if;
                  G2a.Build_Tree.Items_End;

               when 39 => -- #line 274

                  Yyerrok;

               when 42 => -- #line 291

                  declare
                     Trans : constant String :=
                       To_String (Yy.Value_Stack (Yy.Tos - 5));
                     Ctx : constant String :=
                       To_String (Yy.Value_Stack (Yy.Tos - 4));
                     Comm : constant String :=
                       To_String (Yy.Value_Stack (Yy.Tos - 3));
                     Val : constant String :=
                       To_String (Yy.Value_Stack (Yy.Tos - 1));
                  begin
                     if Parser_Debug then
                        Ada.Text_IO.Put_Line
                          ("   Item " &
                           (if Trans /= "" then "translatable " & Trans & " "
                            else "") &
                           Val & " context " & Ctx & " comments " & Comm);
                     end if;
                     G2a.Build_Tree.Attach_Item
                       (Value    => Val, Translatable => Trans, Context => Ctx,
                        Comments => Comm);
                  end;

               when 43 => -- #line 311

                  Yyerrok;

               when 45 => -- #line 323

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("attributes");
                  end if;
                  G2a.Build_Tree.Attributes_Start;

               when 46 => -- #line 331

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("packing end");
                  end if;
                  G2a.Build_Tree.Attributes_End;

               when 47 => -- #line 339

                  --  Skip malformed attributes block.
                  Yyerrok;

               when 52 => -- #line 353

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("   Attribute (inline) " &
                        To_String (Yy.Value_Stack (Yy.Tos - 3)) & " = " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Attach_Attribute
                    (To_String (Yy.Value_Stack (Yy.Tos - 3)),
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 53 => -- #line 364

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("   Attribute (block) " &
                        To_String (Yy.Value_Stack (Yy.Tos - 3)) & " = " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Attach_Attribute
                    (To_String (Yy.Value_Stack (Yy.Tos - 3)),
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 55 => -- #line 377

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("""GtkFileFilter""" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Create_Object
                    ("""GtkFileFilter""",
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 56 => -- #line 387

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Close current object");
                  end if;
                  G2a.Build_Tree.Close_Current_Object;

               when 61 => -- #line 402

                  --  Skip a malformed mime-type entry.
                  Yyerrok;

               when 62 => -- #line 408

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("<mime-type>" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Attach_Mime_Type
                    (To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 67 => -- #line 423

                  --  Skip a malformed pattern entry.
                  Yyerrok;

               when 68 => -- #line 429

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("<pattern>" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Attach_Pattern
                    (To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 72 => -- #line 444

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("""GtkListStore""" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Create_Object
                    ("""GtkListStore""",
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  G2a.Build_Tree.Restart_Column_Number;
                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Close current object");
                  end if;
                  G2a.Build_Tree.Close_Current_Object;

               when 73 => -- #line 458

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("""GtkListStore""" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Create_Object
                    ("""GtkListStore""",
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  G2a.Build_Tree.Restart_Column_Number;

               when 74 => -- #line 468

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("""GtkTreeStore""" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Create_Object
                    ("""GtkTreeStore""",
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  G2a.Build_Tree.Restart_Column_Number;

               when 75 => -- #line 482

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Close current object");
                  end if;
                  G2a.Build_Tree.Close_Current_Object;

               when 76 => -- #line 494

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Close current object");
                  end if;
                  G2a.Build_Tree.Close_Current_Object;

               when 79 => -- #line 506

                  --  Skip a malformed column declaration and continue.
                  Yyerrok;

               when 85 => -- #line 514

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Column" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 2)) & " " &
                        "gfloat");
                  end if;
                  G2a.Build_Tree.Attach_Float_Column
                    (To_String (Yy.Value_Stack (Yy.Tos - 2)));

               when 86 => -- #line 522

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Column" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 2)) & " " &
                        "gint");
                  end if;
                  G2a.Build_Tree.Attach_Integer_Column
                    (To_String (Yy.Value_Stack (Yy.Tos - 2)));

               when 87 => -- #line 530

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Column" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 2)) & " " &
                        "gboolean");
                  end if;
                  G2a.Build_Tree.Attach_Boolean_Column
                    (To_String (Yy.Value_Stack (Yy.Tos - 2)));

               when 88 => -- #line 538

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Column" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 2)) & " " &
                        "gchararray");
                  end if;
                  G2a.Build_Tree.Attach_String_Column
                    (To_String (Yy.Value_Stack (Yy.Tos - 2)));

               when 89 => -- #line 546

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Column" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 2)) & " " &
                        "gtkbuttonboxstyle");
                  end if;
                  G2a.Build_Tree.Attach_Buttonbox_Column
                    (To_String (Yy.Value_Stack (Yy.Tos - 2)));

               when 91 => -- #line 557

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Data Start");
                  end if;
                  G2a.Build_Tree.Attach_Liststore_Data_Start;

               when 92 => -- #line 565

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Data end");
                  end if;
                  G2a.Build_Tree.Attach_Liststore_Data_End;

               when 93 => -- #line 572

                  --  Skip a malformed data block.
                  Yyerrok;

               when 96 => -- #line 581

                  --  Skip a malformed row and continue.
                  Yyerrok;

               when 97 => -- #line 591

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Column Data end");
                  end if;
                  G2a.Build_Tree.Attach_Liststore_Row_Data_End;

               when 98 => -- #line 598

                  --  Recover inside a single row.
                  Yyerrok;

               when 99 => -- #line 605

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Column Data for" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Attach_Liststore_Row_Data_Start
                    (To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 106 => -- #line 623

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Data" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 3)) & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)) &
                        " (self-closing)");
                  end if;
                  G2a.Build_Tree.Attach_Liststore_Row_Data
                    (To_String (Yy.Value_Stack (Yy.Tos - 3)), "");

               when 107 => -- #line 633

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Data" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 4)) & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 2)));
                  end if;
                  G2a.Build_Tree.Attach_Liststore_Row_Data
                    (To_String (Yy.Value_Stack (Yy.Tos - 4)), "");

               when 108 => -- #line 642

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Data" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 5)) & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 3)) & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Attach_Liststore_Row_Data
                    (To_String (Yy.Value_Stack (Yy.Tos - 5)),
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 109 => -- #line 650

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("Data" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 3)) & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Attach_Liststore_Row_Data
                    (To_String (Yy.Value_Stack (Yy.Tos - 3)),
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 111 => -- #line 664

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("""GtkSeparatorMenuItem""");
                  end if;
                  G2a.Build_Tree.Create_Object
                    ("""GtkSeparatorMenuItem""", "");

               when 112 => -- #line 673

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Close current object");
                  end if;
                  G2a.Build_Tree.Close_Current_Object;

               when 114 => -- #line 686

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("""GtkImage""");
                  end if;
                  G2a.Build_Tree.Create_Object ("""GtkImage""", "");

               when 115 => -- #line 695

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Close current object");
                  end if;
                  G2a.Build_Tree.Close_Current_Object;

               when 117 => -- #line 708

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("""GtkCellRendererText""" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Create_Object
                    ("""GtkCellRendererText""",
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 118 => -- #line 716

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Close current object");
                  end if;
                  G2a.Build_Tree.Close_Current_Object;

               when 120 => -- #line 726

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("""GtkCellRendererToggle""" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Create_Object
                    ("""GtkCellRendererToggle""",
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 121 => -- #line 737

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("Close current object");
                  end if;
                  G2a.Build_Tree.Close_Current_Object;

               when 122 => -- #line 749
                  Yyval := Yy.Value_Stack (Yy.Tos);

               when 123 => -- #line 751
                  Yyval := Ada.Strings.Unbounded.To_Unbounded_String ("");

               when 128 => -- #line 764

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("   Property" & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 3)) & " " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Attach_Property
                    (To_String (Yy.Value_Stack (Yy.Tos - 3)),
                     To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 129 => -- #line 774
                  Yyval := Null_Unbounded_String;

               when 130 => -- #line 775
                  Yyval := Yy.Value_Stack (Yy.Tos);

               when 131 => -- #line 779
                  Yyval := Null_Unbounded_String;

               when 132 => -- #line 780
                  Yyval := Yy.Value_Stack (Yy.Tos);

               when 133 => -- #line 784
                  Yyval := Null_Unbounded_String;

               when 134 => -- #line 785
                  Yyval := Yy.Value_Stack (Yy.Tos);

               when 135 => -- #line 791
                  Yyval := To_Unbounded_String ("""label""");

               when 136 => -- #line 792
                  Yyval := To_Unbounded_String ("""short-label""");

               when 137 => -- #line 793
                  Yyval := To_Unbounded_String ("""title""");

               when 138 => -- #line 794
                  Yyval := To_Unbounded_String ("""tearoff-title""");

               when 139 => -- #line 795
                  Yyval := To_Unbounded_String ("""text""");

               when 140 => -- #line 796
                  Yyval := To_Unbounded_String ("""tooltip""");

               when 141 => -- #line 797
                  Yyval := To_Unbounded_String ("""tooltip-text""");

               when 142 => -- #line 798
                  Yyval := To_Unbounded_String ("""tooltip-markup""");

               when 143 => -- #line 799
                  Yyval := To_Unbounded_String ("""placeholder-text""");

               when 144 => -- #line 800
                  Yyval :=
                    To_Unbounded_String ("""primary-icon-tooltip-text""");

               when 145 => -- #line 801
                  Yyval :=
                    To_Unbounded_String ("""primary-icon-tooltip-markup""");

               when 146 => -- #line 802
                  Yyval :=
                    To_Unbounded_String ("""secondary-icon-tooltip-text""");

               when 147 => -- #line 803
                  Yyval :=
                    To_Unbounded_String ("""secondary-icon-tooltip-markup""");

               when 148 => -- #line 814

                  declare
                     Name_Prop : constant String :=
                       To_String (Yy.Value_Stack (Yy.Tos - 6));
                     Trans : constant String :=
                       To_String (Yy.Value_Stack (Yy.Tos - 5));
                     Ctx : constant String :=
                       To_String (Yy.Value_Stack (Yy.Tos - 4));
                     Comm : constant String :=
                       To_String (Yy.Value_Stack (Yy.Tos - 3));
                     Val : constant String :=
                       To_String (Yy.Value_Stack (Yy.Tos - 1));
                  begin
                     if Parser_Debug then
                        Ada.Text_IO.Put_Line
                          ("   Property " & Name_Prop & " " &
                           (if Trans /= "" then "translatable " & Trans & " "
                            else "") &
                           Val & " context " & Ctx & " comments " & Comm);
                     end if;

                     G2a.Build_Tree.Attach_Translatable_String_Property
                       (Name => Name_Prop, Translatable => Trans, Value => Val,
                        Context => Ctx, Comments => Comm);
                  end;

               when 151 => -- #line 850

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line
                       ("   Signal " &
                        To_String (Yy.Value_Stack (Yy.Tos - 6)) &
                        ", handler " &
                        To_String (Yy.Value_Stack (Yy.Tos - 4)) & ", object " &
                        To_String (Yy.Value_Stack (Yy.Tos - 3)) & ", after " &
                        To_String (Yy.Value_Stack (Yy.Tos - 2)) & ", swap " &
                        To_String (Yy.Value_Stack (Yy.Tos - 1)));
                  end if;
                  G2a.Build_Tree.Attach_Signal
                    (Name      => To_String (Yy.Value_Stack (Yy.Tos - 6)),
                     Handler   => To_String (Yy.Value_Stack (Yy.Tos - 4)),
                     User_Data => To_String (Yy.Value_Stack (Yy.Tos - 3)),
                     After     => To_String (Yy.Value_Stack (Yy.Tos - 2)),
                     Swap      => To_String (Yy.Value_Stack (Yy.Tos - 1)));

               when 152 => -- #line 869
                  Yyval := Null_Unbounded_String;

               when 153 => -- #line 870
                  Yyval := Yy.Value_Stack (Yy.Tos);

               when 154 => -- #line 874
                  Yyval := Null_Unbounded_String;

               when 155 => -- #line 875
                  Yyval := Yy.Value_Stack (Yy.Tos);

               when 156 => -- #line 879
                  Yyval := Null_Unbounded_String;

               when 157 => -- #line 880
                  Yyval := Yy.Value_Stack (Yy.Tos);

               when 176 => -- #line 945

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("""GtkTreeSelection""");
                  end if;
                  G2a.Build_Tree.Create_Object ("""GtkTreeSelection""", "");

               when 179 => -- #line 961

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("packing");
                  end if;
                  G2a.Build_Tree.Packing_Start;

               when 180 => -- #line 969

                  if Parser_Debug then
                     Ada.Text_IO.Put_Line ("packing end");
                  end if;
                  G2a.Build_Tree.Packing_End;

               when 181 => -- #line 976

                  --  Skip a malformed packing block.
                  Yyerrok;

               when 184 => -- #line 985

                  --  Skip a malformed packing property.
                  Yyerrok;

               when 187 => -- #line 997

                  --  Skip a malformed action-widgets block.
                  Yyerrok;

               when 190 => -- #line 1005

                  --  Skip a malformed action entry.
                  Yyerrok;
                  --  pragma Style_Checks (On);

               when others =>
                  null;
            end case;

            --  Pop RHS states and goto next state
            Yy.Tos := Yy.Tos - Rule_Length (Yy.Rule_Id) + 1;
            if Yy.Tos > Yy.Stack_Size then
               Ada.Text_IO.Put_Line (" Stack size exceeded on state_stack");
               raise Yy_Tokens.Syntax_Error;
            end if;
            Yy.State_Stack (Yy.Tos) :=
              Goto_State
                (Yy.State_Stack (Yy.Tos - 1), Get_Lhs_Rule (Yy.Rule_Id));
            Yy.Value_Stack (Yy.Tos) := Yyval;
            if Yy.Debug then
               Reduce_Debug
                 (Yy.Rule_Id,
                  Goto_State
                    (Yy.State_Stack (Yy.Tos - 1), Get_Lhs_Rule (Yy.Rule_Id)));
            end if;

         end if;
      end loop;

   end Yyparse;
   pragma Warnings (On);
   pragma Style_Checks (On);

end Glade_Parser;

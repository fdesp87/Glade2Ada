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
with Glade_Parser;
with Glade_Scanner_Io;      use Glade_Scanner_Io;
with Glade_Parser_Tokens;
with Glade_Scanner;         use Glade_Scanner;
with Convert_States_To_Names;

with Ada.Command_Line;      use Ada.Command_Line;
with GNAT.Command_Line;     use GNAT.Command_Line;
with Ada.Calendar;
with GNAT.Calendar.Time_IO;
with GNAT.OS_Lib;
with GNAT.Strings;          use GNAT.Strings;
with Ada.Text_IO;
with Ada.Exceptions;

with G2a.Version;
with G2a.Symbol_Tables;
with G2a.Build_Tree;

with G2a.GObject; use G2a.GObject;
with G2a.Support; use G2a.Support;
with G2a.Emit_Ada;

procedure Glade2Ada is

   Status : Integer;

   Instant : constant String := GNAT.Calendar.Time_IO.Image
     (Ada.Calendar.Clock, GNAT.Calendar.Time_IO.ISO_Time);

   procedure Print_Help;
   procedure Print_Help is
   begin
      Ada.Text_IO.Put_Line ("usage: glade2ada [options] Path/Filename");
      Ada.Text_IO.Put_Line ("options:");
      Ada.Text_IO.Put_Line ("-l             produce a log file");
      Ada.Text_IO.Put_Line ("-n=lexfilename symbolic states, full path of lex filename");
      Ada.Text_IO.Put_Line ("-d             parser in debug mode");
      Ada.Text_IO.Put_Line ("-tpisa         produce a tree with objects," &
                            "               properties, items, attributes and signals");
      Ada.Text_IO.Put_Line ("-A=Adapath     produce Ada code under Adapath");
      Ada.Text_IO.Put_Line ("-m             produce Ada main/GPR/CSS");
      GNAT.OS_Lib.OS_Exit (0);
   end Print_Help;

begin

   if Argument_Count = 0 then
      Print_Help;
   end if;

   G2a.Symbol_Tables.Initialize;

   loop
      case Getopt ("h -help l n= d A= m t p i s a") is
      --  case Getopt ("tpis tpia tisa   tpisa") is
         when 'h' | '-' =>
            Print_Help;
         when 'l' =>
            G2a.Produce_Log  := True;
         when 't' =>
            G2a.Produce_Tree := True;
         when 'p' =>
            G2a.Produce_Tree := True;
            G2a.Produce_Properties := True;
         when  'i'  =>
            G2a.Produce_Tree := True;
            G2a.Produce_Items := True;
         when 's'  =>
            G2a.Produce_Tree := True;
            G2a.Produce_Signals := True;
         when 'a'  =>
            if Full_Switch = "a" then
               G2a.Produce_Tree := True;
               G2a.Produce_Attributes := True;
            end if;
         when 'A' =>
            if Parameter /= "" then
               G2a.Ada_Dir := new String'(Parameter);
            else
               Ada.Text_IO.Put_Line ("missing Ada Path");
               GNAT.OS_Lib.OS_Exit (1);
            end if;
         when 'n' =>
            Glade_Scanner.Scan_Debug := True;
            if Parameter /= "" then
               G2a.Lex_Full_Filename := new String'(Parameter);
            else
               Ada.Text_IO.Put_Line ("missing lex path filename");
               GNAT.OS_Lib.OS_Exit (1);
            end if;
         when 'd' =>
            Glade_Parser.Parser_Debug := True;
            if Parameter /= "" then
               G2a.Ada_Dir := new String'(Parameter);
            else
               Ada.Text_IO.Put_Line ("missing Ada Path");
               GNAT.OS_Lib.OS_Exit (1);
            end if;
         when 'm' =>
            G2a.Produce_Main := True;
         when ASCII.NUL =>
            G2a.Glade_Full_FileName := new String'(Get_Argument);
            exit;
         when others =>
            Print_Help;
            GNAT.OS_Lib.OS_Exit (1);
      end case;
   end loop;

   G2a.Non_Processed_Properties.Clear;

   if G2a.Produce_Log then
      Ada.Text_IO.Create (File => G2a.Log_File,
                          Mode => Ada.Text_IO.Out_File,
                          Name => G2a.Glade_Full_FileName.all & ".log");
      Ada.Text_IO.Put_Line (G2a.Log_File,
                            "Generating Log by g2a " & G2a.Version.Version
                            & " - " & Instant);
   end if;

   if Glade_Scanner.Scan_Debug then
      Convert_States_To_Names.Initialize (G2a.Lex_Full_Filename.all);
   end if;

   --  scanner and parser
   Open_Input (G2a.Glade_Full_FileName.all);
   Glade_Parser.Yyparse;
   Close_Input;

   if not G2a.Non_Processed_Properties.Is_Empty then
      Ada.Text_IO.Put_Line ("Non processed properties:");
      for P in G2a.Non_Processed_Properties.Iterate loop
         Ada.Text_IO.Put_Line ("   " & P.Element.Lineno'Image
                               & ": " & P.Element.Non_Processed_Property.all);
      end loop;
   end if;

   Renumber_Tree;
   if G2a.Produce_Tree then
      Ada.Text_IO.Create (File => G2a.Dump_File,
                          Mode => Ada.Text_IO.Out_File,
                          Name => G2a.Glade_Full_FileName.all & ".dump");
      Ada.Text_IO.Put_Line (G2a.Dump_File,
                            "Generating Dump by g2a " & G2a.Version.Version
                            & " - " & Instant);
      Dump_Tree;
      Ada.Text_IO.Put_Line (G2a.Dump_File,
                            "End Dump by g2a " & G2a.Version.Version);
      Ada.Text_IO.Close (G2a.Dump_File);
   end if;

   if G2a.Ada_Dir /= null then
      Status := G2a.Emit_Ada.Generate_Ada_Packages;
   end if;

   if G2a.Produce_Log then
      Ada.Text_IO.Put_Line (G2a.Log_File,
                            "End Log by g2a " & G2a.Version.Version);
      Ada.Text_IO.Close (G2a.Log_File);
   end if;

exception
   when Ada.Text_IO.Name_Error =>
      Ada.Text_IO.Put_Line ("Unknown file: " & Argument (Argument_Count));
   when E : G2a.Build_Tree.Unknown_Object =>
      Ada.Text_IO.Put_Line ("Unknown Object "
                            & Ada.Exceptions.Exception_Message (E));
      Set_Exit_Status (Failure);

   when Glade_Parser_Tokens.Syntax_Error => null;

   when GNAT.Command_Line.Invalid_Switch
      | GNAT.Command_Line.Invalid_Parameter =>
      Ada.Text_IO.Put_Line ("unrecognized option '-" & Full_Switch & "'");
      Set_Exit_Status (Failure);

end Glade2Ada;

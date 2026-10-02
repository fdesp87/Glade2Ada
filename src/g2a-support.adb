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

with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Strings.Fixed;       use Ada.Strings.Fixed;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Containers;
with GNATCOLL.Utils;

with G2a.GNode;               use G2a.GNode;
with G2a.GObject;             use G2a.GObject;
with G2a.GProperty;           use G2a.GProperty;
with G2a.GItem;               use G2a.GItem;
with G2a.GAttribute;          use G2a.GAttribute;
with G2a.GListcolumn;         use G2a.GListcolumn;
with G2a.GSignal;             use G2a.GSignal;
with G2a.GCellrenderer;       use G2a.GCellrenderer;
with G2a.GCellrenderertext;   use G2a.GCellrenderertext;
with G2a.GCellrenderertoggle; use G2a.GCellrenderertoggle;
with G2a.GLabel;              use G2a.GLabel;
with G2a.GListstore;          use G2a.GListstore;
with G2a.GTreestore;          use G2a.GTreestore;
with G2a.GComboboxtext;       use G2a.GComboboxtext;

package body G2a.Support is

   ---------------------------------------------------------------------------
   function Contains (Src : String; Part : String) return Boolean is
      Idx : Integer;
   begin
      if Src = "" then
         return False;
      end if;
      Idx := Index (Src, Part);
      if Idx not in Src'Range then
         return False;
      end if;
      return True;
   end Contains;

   ---------------------------------------------------------------------------
   function Extract (Src  : String;
                     Lead : String;
                     Tail : String) return String is
      Idx0, Idx1 : Integer;
   begin
      if Src = "" then
         return "";
      end if;
      if Lead = "" then
         Idx0 := Src'First;
      else
         Idx0 := Index (Src, Lead);
         if Idx0 not in Src'Range then
            return "";
         end if;
      end if;
      Idx0 := Idx0 + Lead'Length;
      if Tail = "" then
         Idx1 := Src'Last + 1;
      else
         Idx1 := Index (Src, Tail);
         if Idx1 not in Src'Range then
            return "";
         end if;
      end if;
      return Src (Idx0 .. Idx1 - 1);
   end Extract;

   -----------------------------------------------------------------------
   function Img (N : Integer) return String is
      K : constant String := N'Image;
   begin
      if N > 0 then
         return K (K'First + 1 .. K'Last);
      else
         return K;
      end if;
   end Img;

   -----------------------------------------------------------------------
   procedure Dump_Tree is
      use Ada.Containers;
      use Node_Tree_Pkg;

      function Sp (Level : Count_Type) return String;
      function Sp (Level : Count_Type) return String is
         Spaces : constant String (1 .. 3 * Integer (Level)) := (others => '.');
      begin
         return Spaces;
      end Sp;

      function Print_Tag (T : String) return String;
      function Print_Tag (T : String) return String is
         use Ada.Strings;
         use GNATCOLL.Utils;
         Idx_Last_Dot : constant Natural := Index (T, ".", T'Last, Backward);
         Idx_Block    : constant Natural := Index (T, "_BLOCK", T'First);
      begin
         return Capitalize (T (Idx_Last_Dot + 1 .. Idx_Block - 1));
      end Print_Tag;

      procedure Dump (R : Cursor);
      procedure Dump (R : Cursor) is
         Level : constant Count_Type := R.Depth - 1;
         Obj   : constant Object := Object (R.Element);

         procedure Dump_Attribute (Crs : in out Attribute_List_Pkg.Cursor);
         procedure Dump_Attribute (Crs : in out Attribute_List_Pkg.Cursor) is
            use type Attribute_List_Pkg.Cursor;
         begin
            while Crs /= Attribute_List_Pkg.No_Element loop
               Ada.Text_IO.Put (Dump_File,
                                Sp (Level) & "Attribute "
                                & Crs.Element.Name.all);
               if Crs.Element.Is_Integer then
                  Ada.Text_IO.Put_Line (Dump_File, " "
                                        & Crs.Element.Integer_Value'Image);
               else
                  Ada.Text_IO.Put_Line (Dump_File, " "
                                        & Crs.Element.String_Value.all);
               end if;
               Crs := Crs.Next;
            end loop;
         end Dump_Attribute;

      begin
         if Produce_Tree then
            Ada.Text_IO.New_Line (Dump_File);
            if Obj.ID.all /= "" then
               Ada.Text_IO.Put_Line (Dump_File, Sp (Level - 1)
                                     & Print_Tag (Obj'Tag.Expanded_Name)
                                     & " id=""" & Obj.ID.all & """"
                                     --  & ", Level" & Level'Image
                                     & ", Child#" & Obj.Child_Number'Image);
            else
               Ada.Text_IO.Put_Line (Dump_File, Sp (Level - 1)
                                     & Print_Tag (Obj'Tag.Expanded_Name)
                                     & " id=""" & """"
                                     --  & ", Level" & Level'Image
                                     & ", Child#" & Obj.Child_Number'Image);
            end if;
         end if;

         if Produce_Properties then
            declare
               Crs : Property_List_Pkg.Cursor;
               use type Property_List_Pkg.Cursor;
            begin
               Crs := Obj.Properties.First;
               while Crs /= Property_List_Pkg.No_Element loop
                  Ada.Text_IO.Put (Dump_File,
                                   Sp (Level) & "Property """
                                   & Crs.Element.Name.all & """");
                  case Crs.Element.Flavor is
                     when Unknown_Flavor =>
                        Ada.Text_IO.Put (Dump_File, " "
                                         & Crs.Element.Name.all);
                     when Is_String =>
                        Ada.Text_IO.Put (Dump_File, " "
                                         & Crs.Element.String_Value.all);
                        if Crs.Element.Text.Translatable then
                           Ada.Text_IO.Put (Dump_File, " " & "Translatable");
                        end if;
                        if Crs.Element.Text.Context /= null then
                           Ada.Text_IO.Put (Dump_File, " " & Crs.Element.Text.Context.all);
                        end if;
                        if Crs.Element.Text.Comments /= null then
                           Ada.Text_IO.Put (Dump_File, " " & Crs.Element.Text.Comments.all);
                        end if;
                        Ada.Text_IO.New_Line (Dump_File);
                     when Is_Identifier | Is_Gtk3_Enum =>
                        Ada.Text_IO.Put_Line (Dump_File, " "
                                              & Crs.Element.String_Value.all);
                     when Is_Integer =>
                        Ada.Text_IO.Put_Line (Dump_File, " "
                                              & Crs.Element.Integer_Value'Image);
                     when Is_Boolean =>
                        if Crs.Element.Boolean_Value then
                           Ada.Text_IO.Put_Line (Dump_File, " " & "True");
                        else
                           Ada.Text_IO.Put_Line (Dump_File, " " & "False");
                        end if;
                     when Is_Decimal =>
                        Ada.Text_IO.Put_Line (Dump_File, " "
                                              & Crs.Element.Decimal_Value'Image);
                  end case;
                  Crs := Crs.Next;
               end loop;
            end;
         end if;

         if Produce_Items then
            case Obj.Gtk_Class is
               when Gtk_List_Store =>
                  declare
                     Str : String (1 .. 3);
                     Crs : Listcolumn_List_Pkg.Cursor;
                     use type Listcolumn_List_Pkg.Cursor;
                  begin
                     Crs := Liststore (Obj).Columns.First;
                     while Crs /= Listcolumn_List_Pkg.No_Element loop
                        Ada.Integer_Text_IO.Put (Str,
                                                 Crs.Element.CNumber);
                        Ada.Text_IO.Put_Line (Dump_File,
                                              Sp (Level)
                                              & "[" & Str & "] "
                                              & "column-name " & Crs.Element.Name.all
                                              & " "
                                              & To_Lower (Crs.Element.CType'Image));
                        Crs := Crs.Next;
                     end loop;
                  end;
               when Gtk_Tree_Store =>
                  declare
                     Str : String (1 .. 3);
                     Crs : Listcolumn_List_Pkg.Cursor;
                     use type Listcolumn_List_Pkg.Cursor;
                  begin
                     Crs := Treestore (Obj).Columns.First;
                     while Crs /= Listcolumn_List_Pkg.No_Element loop
                        Ada.Integer_Text_IO.Put (Str,
                                                 Crs.Element.CNumber);
                        Ada.Text_IO.Put_Line (Dump_File,
                                              Sp (Level)
                                              & "[" & Str & "] "
                                              & "column-name " & Crs.Element.Name.all
                                              & " "
                                              & To_Lower (Crs.Element.CType'Image));
                        Crs := Crs.Next;
                     end loop;
                  end;
               when Gtk_Combo_Box_Text =>
                  declare
                     Crs : Item_List_Pkg.Cursor;
                     use type Item_List_Pkg.Cursor;
                  begin
                     Crs := Comboboxtext (Obj).List_Of_Items.First;
                     while Crs /= Item_List_Pkg.No_Element loop
                        Ada.Text_IO.Put (Dump_File,
                                         Sp (Level) & "Item """
                                         & Crs.Element.Value.all & """");
                        if Crs.Element.Translatable then
                           Ada.Text_IO.Put (Dump_File, " " & "Translatable");
                        end if;
                        if Crs.Element.Context /= null then
                           Ada.Text_IO.Put (Dump_File, " " & Crs.Element.Context.all);
                        end if;
                        if Crs.Element.Comments /= null then
                           Ada.Text_IO.Put (Dump_File, " " & Crs.Element.Comments.all);
                        end if;
                        Ada.Text_IO.New_Line (Dump_File);

                        Crs := Crs.Next;
                     end loop;
                  end;

               when others => null;
            end case;
         end if;

         if Produce_Attributes then
            declare
               Crs : Attribute_List_Pkg.Cursor;
            begin
               case Obj.Gtk_Class is
                  when Gtk_Cell_Renderer =>
                     Crs := Cellrenderer (Obj).Attributes.First;
                     Dump_Attribute (Crs);
                  when Gtk_Cell_Renderer_Text =>
                     Crs := Cellrenderertext (Obj).Attributes.First;
                     Dump_Attribute (Crs);
                  when Gtk_Cell_Renderer_Toggle =>
                     Crs := Cellrenderertoggle (Obj).Attributes.First;
                     Dump_Attribute (Crs);
                  when Gtk_Label =>
                     Crs := Label (Obj).Attributes.First;
                     Dump_Attribute (Crs);
                  when others => null;
               end case;
            end;
         end if;

         if Produce_Signals then
            declare
               Crs : Signal_List_Pkg.Cursor;
               use type Signal_List_Pkg.Cursor;
            begin
               Crs := Obj.Signals.First;
               while Crs /= Signal_List_Pkg.No_Element loop
                  Ada.Text_IO.Put_Line (Dump_File,
                     Sp (Level) & "Signal "
                     & """" & Crs.Element.Signal_Name.all & """ "
                     & Crs.Element.Handler.all & " "
                     & Crs.Element.User_Data.all & " "
                     & (if Crs.Element.Swap then "Swapped=""yes"" "
                                            else "Swapped=""no""")
                     & (if Crs.Element.After then " After=""yes"" "
                                          else " After=""no"""));
                  Crs := Crs.Next;
               end loop;
            end;
         end if;

         if Produce_Properties then --  for packing properties
            declare
               Crs : Property_List_Pkg.Cursor;
               use type Property_List_Pkg.Cursor;
            begin
               Crs := Obj.Packing_Properties.First;
               while Crs /= Property_List_Pkg.No_Element loop
                  Ada.Text_IO.Put (Dump_File,
                                   Sp (Level) & "Packing Property """
                                   & Crs.Element.Name.all & """");
                  case Crs.Element.Flavor is
                     when Unknown_Flavor =>
                        raise Program_Error with "Unknown flavor";
                     when Is_String =>
                        Ada.Text_IO.Put_Line (Dump_File, " "
                                              & Crs.Element.String_Value.all);
                     when Is_Identifier | Is_Gtk3_Enum =>
                        Ada.Text_IO.Put_Line (Dump_File, " "
                                              & Crs.Element.String_Value.all);
                     when Is_Integer =>
                        Ada.Text_IO.Put_Line (Dump_File, " "
                                              & Crs.Element.Integer_Value'Image);
                     when Is_Boolean =>
                        if Crs.Element.Boolean_Value then
                           Ada.Text_IO.Put_Line (Dump_File, " " & "True");
                        else
                           Ada.Text_IO.Put_Line (Dump_File, " " & "False");
                        end if;
                     when Is_Decimal =>
                        Ada.Text_IO.Put_Line (Dump_File, " "
                                              & Crs.Element.Decimal_Value'Image);
                  end case;
                  Crs := Crs.Next;
               end loop;
            end;
         end if;
      end Dump;

   begin
      Iterate (Dump'Access);
   end Dump_Tree;

   ---------------------------------------------------------------------------

   Log_Identation : Integer := -1;

   procedure Log (Oper         : Log_Operation;
                  Name         : String := "";
                  Id           : String := "";
                  CN           : Integer := 0;
                  Context      : String := "";
                  Comments     : String := "";
                  Translatable : Boolean := False) is

      function Sp (K : Integer) return String;
      function Sp (K : Integer) return String is
         Spaces : constant String (1 .. K * 3) := (others => '.');
      begin
         return Spaces;
      end Sp;
   begin
      case Oper is
         when Create_Object =>
            Log_Identation := Log_Identation + 1;
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation)
                                  & Name (Name'First + 1 .. Name'Last - 1)
                                  & " """ & Id & """");

         when Close_Object =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation)
                                  & "Closing"
                                  & " """ & Id & """");
            Log_Identation := Log_Identation - 1;
         when Attach_Signal =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "Signal " & Name
                                  & " " & Id);
         when Attach_String_Attribute | Attach_Integer_Attribute =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "Attribute " & Name
                                  & " " & Id);
         when Attach_Property_String =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "Property " & Name
                                  & " " & Id
                                  & (if Translatable then " " & "Translatable" else "")
                                  & (if Context /= "" then " " & Context else "")
                                  & (if Comments /= "" then " " & Comments else "")
                                 );
         when Attach_Property_Identifier |
              Attach_Property_Boolean |
              Attach_Property_Integer |
              Attach_Property_Decimal =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "Property " & Name
                                  & " " & Id);
         when Start_Packing =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "Packing");
            Log_Identation := Log_Identation + 1;
         when End_Packing =>
            Log_Identation := Log_Identation - 1;
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "End Packing");
         when Start_Attributes =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "Attributes");
            Log_Identation := Log_Identation + 1;
         when End_Attributes =>
            Log_Identation := Log_Identation - 1;
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "End Attributes");
         when Start_Items =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "Items");
            Log_Identation := Log_Identation + 1;
         when This_Item =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "Item " & Name
                                  & " " & Id
                                  & (if Translatable then " " & "Translatable" else "")
                                  & (if Context /= "" then " " & Context else "")
                                  & (if Comments /= "" then " " & Comments else "")
                                 );
         when End_Items =>
            Log_Identation := Log_Identation - 1;
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "End Items");
         when Attach_Column =>
            declare
               Str : String (1 .. 3);
            begin
               Ada.Integer_Text_IO.Put (Str, CN);
               Ada.Text_IO.Put_Line (Log_File,
                                     Sp (Log_Identation + 1)
                                     & "[" & Str & "] "
                                     & "column-name " & Name
                                     & " " & Id);
            end;
         when Attach_Additional_Information =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & Name
                                  & " """ & Id & """");
         when Attach_Mime_Type =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "Mime-type"
                                  & " " & Name);
         when Attach_Pattern =>
            Ada.Text_IO.Put_Line (Log_File,
                                  Sp (Log_Identation + 1)
                                  & "Pattern"
                                  & " " & Name);
      end case;
   end Log;

   ---------------------------------------------------------------------------
   procedure Log (Msg : String) is
   begin
      Ada.Text_IO. Put_Line (Log_File, Msg);
   end Log;

end G2a.Support;

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
with GNATCOLL.Utils;             use GNATCOLL.Utils;

with G2a.GNode;
with G2a.GObject;                use G2a.GObject;
with G2a.GTreeview;              use G2a.GTreeview;
with G2a.GTreeviewcolumn;        use G2a.GTreeviewcolumn;
with G2a.GListstore;             use G2a.GListstore;
with G2a.Support;                use G2a.Support;
with G2a.GWidget;                use G2a.GWidget;
with G2a.Symbol_Tables;

package body G2a.Emit_Ada.Object_Collection is

   package TIO renames Ada.Text_IO;

   use G2a.GNode.Node_Tree_Pkg;

   ---------------------------------------------------------------------------
   procedure Treeviewcolumn_Tooltip (Obj : Object);
   procedure Treeviewcolumn_Tooltip (Obj : Object) is
      Col : constant Treeviewcolumn := Treeviewcolumn (Parent (Obj));
      Tvw : constant Treeview := Treeview (Parent (Col));

      Lst_Name_List : constant String := "GtkListStore_"
                        & Tvw.ID.all & "_Additional_Information";
      Lst_Name_Tree : constant String := "GtkTreeStore_"
                        & Tvw.ID.all & "_Additional_Information";
      Lst : Liststore;
   begin
      Lst := Find_Liststore (Lst_Name_List);
      if Lst = null then
         Lst := Find_Liststore (Lst_Name_Tree);
      end if;
      if Lst = null then
         return;
      end if;
      declare
         Tip : constant String := The_Value (Lst, 1, Obj.ID.all);
      begin
         if Tip /= "" then
            TIO.Put_Line (Sp (6)
                          & "Btn := OC." & Col.ID.all
                          & ".Get_Button;");
            TIO.Put_Line (Sp (6)
                          & "Btn.Set_Tooltip_Text ("
                          & Quoted (Tip)
                          & ");");
         end if;
      end;
   end Treeviewcolumn_Tooltip;

   ---------------------------------------------------------------------------
   procedure Emit_Object_In_Spec (Position : Cursor);
   procedure Emit_Object_In_Spec (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);

      procedure Emit_General;
      procedure Emit_General is
      begin
         if Obj.ID /= null and then Obj.ID.all /= "" then
            TIO.Put_Line (Sp (6) & Obj.ID.all & " : "
                          & Symbol_Tables.To_Gtk (Obj.Gtk_Class) & ";");
         end if;
      end Emit_General;

   begin
      case Obj.Gtk_Class is
         when Gtk_Window =>
            TIO.New_Line;
            TIO.Put_Line (Sp (6) & Obj.ID.all & " : "
                          & "Gtk_Window" & ";");

         when Gtk_Dialog =>
            TIO.New_Line;
            TIO.Put_Line (Sp (6) & Obj.ID.all & " : "
                          & "Gtk_Dialog" & ";");

         when Gtk_Menu_Item | Gtk_Menu_Image_Item =>
            if not Is_Leaf (Position) then
               TIO.New_Line;
               TIO.Put_Line (Sp (6) & Obj.ID.all & "_Submenu" & " : "
                             & "Gtk_Menu" & ";");
            end if;

         when Gtk_Calendar =>
            Emit_General;
            if Starts_With (Obj.ID.all, "Date_Picker") and then
              Ends_With (Obj.ID.all, "_Calendar")
            then
               TIO.New_Line;
            end if;

         when Gtk_Aspect_Frame =>
            if Is_Time_Picker (Obj) then
               TIO.New_Line;
            end if;
            Emit_General;

         when Gtk_Image =>
            Emit_General;
            if Starts_With (Obj.ID.all, "Time_Picker") and then
              Ends_With (Obj.ID.all, "_Sec_Down_Img")
            then
               TIO.New_Line;
            end if;

         when Gtk_List_Store =>
            if (not Ends_With (Obj.ID.all, "_Additional_Information") and
                  not Ends_With (Obj.ID.all, "_Focus_List"))
            then
               Emit_General;
            end if;

         when Gtk_Box =>
            if Obj.ID /= null and then Obj.ID.all /= "" then
               TIO.New_Line;
               if Starts_With (Obj.ID.all, "Tabpage_") and then
                 Ends_With (Obj.ID.all, "_Box")
               then
                  TIO.Put_Line (Sp (6)
                                & Extract (Obj.ID.all, "", "_Box")
                                & " : Gtk_Widget" & ";");
                  TIO.Put_Line (Sp (6)
                                & Obj.ID.all
                                & " : Gtk_Box" & ";");
               else
                  Emit_General;
               end if;
            end if;

         when others =>
            if Obj.ID /= null and then Obj.ID.all /= "" then
               case Obj.Gtk_Class is
                  when Gtk_Menu_Bar | Gtk_Scrolled_Window | Gtk_ToolBar |
                       Gtk_Notebook | Gtk_Tree_View       | Gtk_Menu
                     =>  TIO.New_Line;
                  when others => null;
               end case;
               Emit_General;
            end if;
      end case;
   end Emit_Object_In_Spec;

   ---------------------------------------------------------------------------
   procedure Initialize_Object_In_Body (Position : Cursor);
   procedure Initialize_Object_In_Body (Position : Cursor) is
      Obj : constant Object  := Object (Position.Element);

      procedure Emit_General;
      procedure Emit_General is
      begin
         if Obj.ID /= null and then Obj.ID.all /= "" then
            TIO.Put_Line (Sp (6) & "OC." & Obj.ID.all & " :=");
            TIO.Put_Line (Sp (8) & G2a.Symbol_Tables.To_Gtk (Obj.Gtk_Class)
                          & " (Builder.Get_Object (");
            TIO.Put_Line (Sp (8) & Quoted (Obj.ID.all) & "));");
         end if;
      end Emit_General;

   begin
      case Obj.Gtk_Class is
         when Gtk_Window =>
            TIO.New_Line;
            Emit_General;

         when Gtk_Dialog =>
            TIO.New_Line;
            TIO.Put_Line (Sp (6) & "OC." & Obj.ID.all & " :=");
            TIO.Put_Line (Sp (8) & "Gtk_Dialog"
                          & " (Builder.Get_Object (");
            TIO.Put_Line (Sp (8) & Quoted (Obj.ID.all) & "));");

         when Gtk_Menu_Item | Gtk_Menu_Image_Item =>
            if not Is_Leaf (Position) then
               TIO.New_Line;
               TIO.Put_Line (Sp (6)
                             & "OC." & Obj.ID.all & "_Submenu" & " := "
                             & "Gtk_Menu"
                             & " (Builder.Get_Object (");
               TIO.Put_Line (Sp (8) & Quoted (Obj.ID.all & "_Submenu") & "));");
            end if;

         when Gtk_Calendar =>
            Emit_General;
            if Starts_With (Obj.ID.all, "Date_Picker") and then
              Ends_With (Obj.ID.all, "_Calendar")
            then
               TIO.New_Line;
            end if;

         when Gtk_Image =>
            Emit_General;
            if Starts_With (Obj.ID.all, "Time_Picker") and then
              Ends_With (Obj.ID.all, "_Sec_Down_Img")
            then
               TIO.New_Line;
            end if;

         when Gtk_Aspect_Frame =>
            if Is_Time_Picker (Obj) then
               TIO.New_Line;
            end if;
            Emit_General;

         when Gtk_List_Store =>
            if (not Ends_With (Obj.ID.all, "_Additional_Information") and
                  not Ends_With (Obj.ID.all, "_Focus_List"))
            then
               Emit_General;
            end if;

         when Gtk_Tree_View =>

            TIO.New_Line;
            Emit_General;

            TIO.Put_Line (Sp (6) & "Set_Activate_On_Single_Click");
            TIO.Put_Line (Sp (8) & "(OC." & Obj.ID.all & ", True);");

         when Gtk_Cell_Renderer_Text | Gtk_Cell_Renderer_Toggle =>
         --  when Gtk_Tree_View_Column =>
            Treeviewcolumn_Tooltip (Obj);
            Emit_General;

         when Gtk_Box =>
            if Obj.ID /= null and then Obj.ID.all /= "" then
               TIO.New_Line;
               if Starts_With (Obj.ID.all, "Tabpage_") and then
                 Ends_With (Obj.ID.all, "_Box")
               then
                  TIO.Put_Line (Sp (6) & "OC."
                                & Extract (Obj.ID.all, "", "_Box")
                                & " :=");
                  TIO.Put_Line (Sp (8) & "Gtk_Widget"
                                & " (Builder.Get_Object (");
                  TIO.Put_Line (Sp (8)
                                & Quoted (Extract (Obj.ID.all, "", "_Box"))
                                & "));");

                  TIO.Put_Line (Sp (6) & "OC."
                                & Obj.ID.all
                                & " :=");
                  TIO.Put_Line (Sp (8) & "Gtk_Box"
                                & " (Builder.Get_Object (");
                  TIO.Put_Line (Sp (8) & Quoted (Obj.ID.all) & "));");


               else
                  Emit_General;
               end if;
            end if;

         when Ada_Date_Picker =>
            Emit_General;
            if Obj.ID /= null and then Obj.ID.all /= "" then
               TIO.Put_Line (Sp (6) & "Gtk_Ada_Date_Picker.Initialize (OC."
                             & Obj.ID.all & ");");
            end if;

         when Ada_Time_Picker =>
            Emit_General;
            if Obj.ID /= null and then Obj.ID.all /= "" then
               TIO.Put_Line (Sp (6) & "Gtk_Ada_Time_Picker.Initialize (OC."
                             & Obj.ID.all & ");");
            end if;

         when others =>
            if Obj.ID /= null and then Obj.ID.all /= "" then
               case Obj.Gtk_Class is
                  when Gtk_Menu_Bar | Gtk_Scrolled_Window | Gtk_ToolBar |
                       Gtk_Notebook | Gtk_Menu
                     =>  TIO.New_Line;

                  when others => null;
               end case;
               Emit_General;
            end if;
      end case;
   end Initialize_Object_In_Body;

   ---------------------------------------------------------------------------
   procedure Set_TreeView_Styles (Position : Cursor);
   procedure Set_TreeView_Styles (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);
   begin
      if Obj.Gtk_Class /= Gtk_Tree_View then
         return;
      end if;
      declare
         Lst_Name_List : constant String :=
                 "GtkListStore_" & Obj.ID.all & "_Additional_Information";
         Lst_Name_Tree : constant String :=
                 "GtkTreeStore_" & Obj.ID.all & "_Additional_Information";
         Lst : Liststore;
      begin
         Lst := Find_Liststore (Lst_Name_List);
         if Lst = null then
            Lst := Find_Liststore (Lst_Name_Tree);
         end if;
         if Lst = null then
            return;
         end if;
         TIO.Put_Line (Sp (6) & "Set_Treeview_Style");
         TIO.Put_Line (Sp (8)
                       & "(Tree      => Me." & Obj.ID.all & ",");
         TIO.Put_Line (Sp (9)
                       & "Fgcolor    => "
                       & Quoted (The_Value (Lst, 6, "ALT_BG"))
                       & ",");
         TIO.Put_Line (Sp (9)
                       & "Bgcolor    => "
                       & Quoted (The_Value (Lst, 7, "ALT_BG"))
                       & ",");
         TIO.Put_Line (Sp (9)
                       & "SelFgcolor => "
                       & Quoted (The_Value (Lst, 8, "ALT_BG"))
                       & ",");
         TIO.Put_Line (Sp (9)
                       & "SelBgcolor => "
                       & Quoted (The_Value (Lst, 9, "ALT_BG"))
                       & ",");
         TIO.Put_Line (Sp (9)
                       & "Font_Name => "
                       & Quoted (The_Value (Lst, 11, "ALT_BG"))
                       & ",");
         TIO.Put_Line (Sp (9) & "Font_Weight => "
                       & Quoted (The_Value (Lst, 12, "ALT_BG"))
                       & ",");
         TIO.Put_Line (Sp (9) & "Font_Size => "
                       & The_Value (Lst, 13, "ALT_BG")
                       & ");");
      end;
   end Set_TreeView_Styles;

   ---------------------------------------------------------------------------
   procedure Emit_ALT_Color (Position : Cursor);
   procedure Emit_ALT_Color (Position : Cursor) is
      Obj : constant Object  := Object (Position.Element);
   begin
      if Obj.Gtk_Class = Gtk_Tree_View then
         declare
            Wdg : constant Treeview := Treeview (Obj);
            Lst_Name_List : constant String :=
                              "GtkListStore_"
                              & Obj.ID.all & "_Additional_Information";
            Lst_Name_Tree : constant String :=
                              "GtkTreeStore_"
                              & Obj.ID.all & "_Additional_Information";
            Lst : Liststore;
         begin
            Lst := Find_Liststore (Lst_Name_List);
            if Lst = null then
               Lst := Find_Liststore (Lst_Name_Tree);
            end if;
            if Lst = null then
               return;
            end if;
            if Wdg.Rules_Hint then
               TIO.Put_Line (Sp (3) & "ALT_Bg_"
                             & Obj.ID.all
                             & "_Color : constant String := "
                             & Quoted
                               (The_Value (Lst, 1, "ALT_BG"))
                             & ";");
            end if;
         end;
      end if;
   end Emit_ALT_Color;

   ---------------------------------------------------------------------------
   procedure Emit_Date_Picker_Methods_Spec (Position : Cursor);
   procedure Emit_Date_Picker_Methods_Spec (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);
   begin
      if Is_Date_Picker (Obj) then
         declare
            Name : constant String := Date_Picker_Name (Obj);
         begin
            TIO.Put_Line (Sp (3) & "function "
                          & Name
                          & "_Get_Date return String;");
            TIO.Put_Line (Sp (3) & "function "
                          & Name
                          & "_Set_Date (Some_Date : String) return Boolean;");
         end;
      end if;
   end Emit_Date_Picker_Methods_Spec;

   ---------------------------------------------------------------------------
   procedure Emit_Date_Picker_Methods_Body (Position : Cursor);
   procedure Emit_Date_Picker_Methods_Body (Position : Cursor) is
      Obj  : constant Object := Object (Position.Element);
   begin
      if Is_Date_Picker (Obj) then
         declare
            Name : constant String := Date_Picker_Name (Obj);
         begin
            TIO.New_Line;
            TIO.Put_Line (Sp (3) & "function "
                          & Name
                          & "_Get_Date return String is");
            TIO.Put_Line (Sp (6) & "TDate : String (1 .. 10) := ""0001-01-01"";");
            TIO.Put_Line (Sp (3) & "begin");
            TIO.Put_Line (Sp (6) & "if Me." & Name
                          & "_Year_Entry.Get_Text'Length = 1 then");
            TIO.Put_Line (Sp (9) & "TDate (4 .. 4) := Me." & Name
                          & "_Year_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "elsif Me." & Name
                          & "_Year_Entry.Get_Text'Length = 2 then");
            TIO.Put_Line (Sp (9) & "TDate (3 .. 4) := Me." & Name
                          & "_Year_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "elsif Me." & Name
                          & "_Year_Entry.Get_Text'Length = 3 then");
            TIO.Put_Line (Sp (9) & "TDate (2 .. 4) := Me." & Name
                          & "_Year_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "else");
            TIO.Put_Line (Sp (9) & "TDate (1 .. 4)  := Me." & Name
                          & "_Year_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.Put_Line (Sp (6) & "if Me." & Name
                          & "_Month_Entry.Get_Text'Length = 1 then");
            TIO.Put_Line (Sp (9) & "TDate (7 .. 7) := Me." & Name
                          & "_Month_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "else");
            TIO.Put_Line (Sp (9) & "TDate (6 .. 7) := Me." & Name
                          & "_Month_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.Put_Line (Sp (6) & "if Me." & Name
                          & "_Day_Entry.Get_Text'Length = 1 then");
            TIO.Put_Line (Sp (9) & "TDate (10 .. 10) := Me." & Name
                          & "_Day_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "else");
            TIO.Put_Line (Sp (9) & "TDate (9 .. 10) := Me." & Name
                          & "_Day_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.Put_Line (Sp (6) & "return TDate;");
            TIO.Put_Line (Sp (3) & "end " & Name & "_Get_Date;");

            TIO.New_Line;
            TIO.Put_Line (Sp (3) & "function "
                          & Name
                          & "_Set_Date (Some_Date : String) return Boolean is");
            TIO.Put_Line (Sp (6) & "S : constant Integer := Some_Date'First;");
            TIO.Put_Line (Sp (3) & "begin");
            TIO.Put_Line (Sp (6) & "if Some_Date'Length /= 10 then");
            TIO.Put_Line (Sp (9) & "return False;");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.Put_Line (Sp (6) & "Me." & Name
                          & "_Month_Entry.Set_Text (Some_Date (S + 5 .. S + 6));");
            TIO.Put_Line (Sp (6) & "Me." & Name
                          & "_Year_Entry.Set_Text (Some_Date (S .. S + 3));");
            TIO.Put_Line (Sp (6) & "Me." & Name
                          & "_Day_Entry.Set_Text (Some_Date (S + 8 .. S + 9));");
            TIO.Put_Line (Sp (6) & "return True;");
            TIO.Put_Line (Sp (3) & "exception");
            TIO.Put_Line (Sp (6) & "when others =>");
            TIO.Put_Line (Sp (9) & "return False;");
            TIO.Put_Line (Sp (3) & "end " & Name & "_Set_Date;");
         end;
      end if;
   end Emit_Date_Picker_Methods_Body;

   ---------------------------------------------------------------------------
   procedure Emit_Time_Picker_Methods_Spec (Position : Cursor);
   procedure Emit_Time_Picker_Methods_Spec (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);
   begin
      if Is_Time_Picker (Obj) then
         declare
            Name : constant String := Time_Picker_Name (Obj);
         begin
            TIO.Put_Line (Sp (3) & "function "
                          & Name
                          & "_Get_Time return String;");
            TIO.Put_Line (Sp (3) & "function "
                          & Name
                          & "_Set_Time (Some_Time : String) return Boolean;");
         end;
      end if;
   end Emit_Time_Picker_Methods_Spec;

   ---------------------------------------------------------------------------
   procedure Emit_Time_Picker_Methods_Body (Position : Cursor);
   procedure Emit_Time_Picker_Methods_Body (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);
   begin
      if Is_Time_Picker (Obj) then
         declare
            Name : constant String := Time_Picker_Name (Obj);
         begin
            TIO.New_Line;
            TIO.Put_Line (Sp (3) & "function " & Name
                          & "_Get_Time return String is");
            TIO.Put_Line (Sp (6) & "TTime : String (1 .. 8) := ""00:00:00"";");
            TIO.Put_Line (Sp (3) & "begin");
            TIO.Put_Line (Sp (6) & "if Me." & Name
                          & "_Hour_Entry.Get_Text'Length = 1 then");
            TIO.Put_Line (Sp (9) & "TTime (2 .. 2) := Me." & Name
                          & "_Hour_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "else");
            TIO.Put_Line (Sp (9) & "TTime (1 .. 2) := Me." & Name
                          & "_Hour_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.Put_Line (Sp (6) & "if Me." & Name
                          & "_Min_Entry.Get_Text'Length = 1 then");
            TIO.Put_Line (Sp (9) & "TTime (5 .. 5) := Me." & Name
                          & "_Min_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "else");
            TIO.Put_Line (Sp (9) & "TTime (4 .. 5) := Me." & Name
                          & "_Min_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.Put_Line (Sp (6) & "if Me." & Name
                          & "_Sec_Entry.Get_Text'Length = 1 then");
            TIO.Put_Line (Sp (9) & "TTime (8 .. 8) := Me." & Name
                          & "_Sec_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "else");
            TIO.Put_Line (Sp (9) & "TTime (7 .. 8) := Me." & Name
                          & "_Sec_Entry.Get_Text;");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.Put_Line (Sp (6) & "return TTime;");
            TIO.Put_Line (Sp (3) & "end " & Name & "_Get_Time;");

            TIO.New_Line;
            TIO.Put_Line (Sp (3) & "function " & Name
                          & "_Set_Time (Some_Time : String) return Boolean is");
            TIO.Put_Line (Sp (6) & "T : constant Integer := Some_Time'First;");
            TIO.Put_Line (Sp (6) & "H, M, S : Integer;");
            TIO.Put_Line (Sp (3) & "begin");
            TIO.Put_Line (Sp (6) & "if Some_Time'Length /= 8 then");
            TIO.Put_Line (Sp (9) & "return False;");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.Put_Line (Sp (6) & "if Some_Time (T + 2) /= ':' then");
            TIO.Put_Line (Sp (9) & "return False;");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.Put_Line (Sp (6) & "if Some_Time (T + 5) /= ':' then");
            TIO.Put_Line (Sp (9) & "return False;");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.Put_Line (Sp (6) & "begin");
            TIO.Put_Line (Sp (9) & "H := Integer'Value (Some_Time (T .. T + 1));");
            TIO.Put_Line (Sp (6) & "exception");
            TIO.Put_Line (Sp (9) & "when others =>");
            TIO.Put_Line (Sp (12) & "return False;");
            TIO.Put_Line (Sp (6) & "end;");
            TIO.Put_Line (Sp (6) & "begin");
            TIO.Put_Line (Sp (9) & "M := Integer'Value (Some_Time (T + 3 .. T + 4));");
            TIO.Put_Line (Sp (6) & "exception");
            TIO.Put_Line (Sp (9) & "when others =>");
            TIO.Put_Line (Sp (12) & "return False;");
            TIO.Put_Line (Sp (6) & "end;");
            TIO.Put_Line (Sp (6) & "begin");
            TIO.Put_Line (Sp (9) & "S := Integer'Value (Some_Time (T + 6 .. T + 7));");
            TIO.Put_Line (Sp (6) & "exception");
            TIO.Put_Line (Sp (9) & "when others =>");
            TIO.Put_Line (Sp (12) & "return False;");
            TIO.Put_Line (Sp (6) & "end;");
            TIO.Put_Line (Sp (6) & "if H in 0 .. 23 and then M in 0 .. 59 "
                          & "and then S in 0 .. 59 then");
            TIO.Put_Line (Sp (9) & "Me." & Name
                          & "_Hour_Entry.Set_Text (Some_Time (T .. T + 1));");
            TIO.Put_Line (Sp (9) & "Me." & Name
                          & "_Min_Entry.Set_Text (Some_Time (T + 3 .. T + 4));");
            TIO.Put_Line (Sp (9) & "Me." & Name
                          & "_Sec_Entry.Set_Text (Some_Time (T + 6 .. T + 7));");
            TIO.Put_Line (Sp (9) & "return True;");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.Put_Line (Sp (6) & "return False;");
            TIO.Put_Line (Sp (3) & "end " & Name & "_Set_Time;");
         end;
      end if;
   end Emit_Time_Picker_Methods_Body;

   ---------------------------------------------------------------------------
   procedure Emit_Spec (Capitalized_Filename : String);
   procedure Emit_Spec (Capitalized_Filename : String) is
   begin
      Log ("Generating Object Collection Spec...");
      Include_Banner;
      if Stat (Gtk_Window) > 0 then
         Emit_With_Use ("Gtk.Window");
      end if;
      if Stat (Gtk_Dialog) > 0 then
         Emit_With_Use ("Gtk.Dialog");
      end if;
      if Stat (Gtk_Fixed) > 0 then
         Emit_With_Use ("Gtk.Fixed");
      end if;
      if Stat (Gtk_Grid) > 0 then
         Emit_With_Use ("Gtk.Grid");
      end if;
      if Stat (Gtk_Alignment) > 0 then
         Emit_With_Use ("Gtk.Alignment");
      end if;
      if Stat (Gtk_File_Chooser_Dialog) > 0 then
         Emit_With_Use ("Gtk.File_Chooser_Dialog");
      end if;
      if Stat (Gtk_File_Filter) > 0 then
         Emit_With_Use ("Gtk.File_Filter");
      end if;
      if Stat (Gtk_Entry_Buffer) > 0 then
         Emit_With_Use ("Gtk.Entry_Buffer");
      end if;
      if Stat (Gtk_Image) > 0 then
         Emit_With_Use ("Gtk.Image");
      end if;
      if Stat (Gtk_List_Store) > 0 then
         Emit_With_Use ("Gtk.List_Store");
      end if;
      if Stat (Gtk_Tree_Store) > 0 then
         Emit_With_Use ("Gtk.Tree_Store");
      end if;
      if Stat (Gtk_Tree_Model_Filter) > 0 then
         Emit_With_Use ("Gtk.Tree_Model_Filter");
      end if;
      if Stat (Gtk_Tree_Model_Sort) > 0 then
         Emit_With_Use ("Gtk.Tree_Model_Sort");
      end if;

      if Stat (Gtk_File_Chooser_Button) > 0 then
         Emit_With_Use ("Gtk.File_Chooser_Button");
      end if;
      if Stat (Gtk_Aspect_Frame) > 0 then
         Emit_With_Use ("Gtk.Aspect_Frame");
      end if;
      if Stat (Gtk_Button) > 0 then
         Emit_With_Use ("Gtk.Button");
      end if;
      if Stat (Gtk_Label) > 0 then
         Emit_With_Use ("Gtk.Label");
      end if;
      if Stat (Gtk_Menu) > 0 then
         Emit_With_Use ("Gtk.Menu");
      end if;
      if Stat (Gtk_Menu_Bar) > 0 then
         Emit_With_Use ("Gtk.Menu_Bar");
      end if;
      if Stat (Gtk_Image_Menu_Item) > 0 then
         Emit_With_Use ("Gtk.Image_Menu_Item");
      end if;
      if Stat (Gtk_Separator_Menu_Item) > 0 then
         Emit_With_Use ("Gtk.Separator_Menu_Item");
      end if;
      if Stat (Gtk_ToolBar) > 0 then
         Emit_With_Use ("Gtk.Toolbar");
      end if;
      if Stat (Gtk_Tool_Item) > 0 then
         Emit_With_Use ("Gtk.Tool_Item");
      end if;
      if Stat (Gtk_Separator_Tool_Item) > 0 then
         Emit_With_Use ("Gtk.Separator_Tool_Item");
      end if;
      if Stat (Gtk_Notebook) > 0 then
         Emit_With_Use ("Gtk.Notebook");
         Emit_With_Use ("Gtk.Widget");
      end if;
      if Stat (Gtk_Scrolled_Window) > 0 then
         Emit_With_Use ("Gtk.Scrolled_Window");
      end if;
      if Stat (Gtk_Tree_View) > 0 then
         Emit_With_Use ("Gtk.Tree_View");
      end if;
      if Stat (Gtk_Tree_Selection) > 0 then
         Emit_With_Use ("Gtk.Tree_Selection");
      end if;
      if Stat (Gtk_Tree_View_Column) > 0 then
         Emit_With_Use ("Gtk.Tree_View_Column");
      end if;
      if Stat (Gtk_Entry) > 0 then
         Emit_With_Use ("Gtk.GEntry");
      end if;
      if Stat (Gtk_Combo_Box) > 0 then
         Emit_With_Use ("Gtk.Combo_Box");
      end if;
      if Stat (Gtk_Combo_Box_Text) > 0 then
         Emit_With_Use ("Gtk.Combo_Box_Text");
      end if;
      if Stat (Gtk_Box) > 0 then
         Emit_With_Use ("Gtk.Box");
      end if;
      if Stat (Gtk_Frame) > 0 then
         Emit_With_Use ("Gtk.Frame");
      end if;
      if Stat (Gtk_Cell_Renderer_Text) > 0 then
         Emit_With_Use ("Gtk.Cell_Renderer_Text");
      end if;
      if Stat (Gtk_Cell_Renderer_Toggle) > 0 then
         Emit_With_Use ("Gtk.Cell_Renderer_Toggle");
      end if;
      if Stat (Gtk_Calendar) > 0 then
         Emit_With_Use ("Gtk.Calendar");
      end if;
      if Stat (Gtk_Check_Button) > 0 then
         Emit_With_Use ("Gtk.Check_Button");
      end if;
      if Stat (Gtk_Radio_Button) > 0 then
         Emit_With_Use ("Gtk.Radio_Button");
      end if;
      if Stat (Gtk_Spin_Button) > 0 then
         Emit_With_Use ("Gtk.Spin_Button");
      end if;
      if Stat (Gtk_Color_Button) > 0 then
         Emit_With_Use ("Gtk.Color_Button");
      end if;
      if Stat (Gtk_Adjustment) > 0 then
         Emit_With_Use ("Gtk.Adjustment");
      end if;

      TIO.Put_Line ("with Glib;");
      Emit_With_Use ("Glib.Object");

      if Stat (Gtk_Tree_View) > 0
        and then
          Stat (Gtk_Cell_Renderer_Text) + Stat (Gtk_Cell_Renderer_Toggle) > 0
      then
         Emit_With_Use ("Gdk.RGBA");
         Emit_With_Use ("Gdk.Color");
         Emit_With_Use ("Gdk.Color.IHLS");
      end if;

      if Stat (Ada_Date_Picker) > 0 then
         Emit_With_Use ("Gtk_Date_Picker");
      end if;

      if Stat (Ada_Time_Picker) > 0 then
         Emit_With_Use ("Gtk_Time_Picker");
      end if;

      Emit_Package_Spec (Capitalized_Filename & "_Pkg.Object_Collection", True);
      TIO.Put_Line (Sp (3) & "type Widget_Collection_Record is new "
                    & "Glib.Object.GObject_Record with record");

      Iterate (Emit_Object_In_Spec'Access);

      TIO.Put_Line (Sp (3) & "end record;");
      TIO.New_Line;

      Iterate (Emit_ALT_Color'Access);
      TIO.New_Line;

      TIO.Put_Line (Sp (3) & "type Widget_Collection is access all "
                    & "Widget_Collection_Record'Class;");
      TIO.New_Line;
      TIO.Put_Line (Sp (3) & "procedure New_Widget_Collection ("
                    & "OC : out Widget_Collection);");
      TIO.Put_Line (Sp (3) & "procedure Initialize ("
                    & "OC : not null access Widget_Collection_Record'Class);");
      TIO.Put_Line (Sp (3) & "function New_Widget_Collection return "
                    & "Widget_Collection;");
      if Stat (Gtk_Tree_View) > 0
        and then
          Stat (Gtk_Cell_Renderer_Text) + Stat (Gtk_Cell_Renderer_Toggle) > 0
        and then Stat (Gtk_Tree_View_Column) > 0
      then
         TIO.New_Line;
         TIO.Put_Line (Sp (3) & "procedure Set_Treeview_Style");
         TIO.Put_Line (Sp (5) & "(Tree        : Gtk_Tree_View;");
         TIO.Put_Line (Sp (6) & "Bgcolor     : String := """";");
         TIO.Put_Line (Sp (6) & "Fgcolor     : String := """";");
         TIO.Put_Line (Sp (6) & "SelBgcolor  : String := """";");
         TIO.Put_Line (Sp (6) & "SelFgcolor  : String := """";");
         TIO.Put_Line (Sp (6) & "Font_Name   : String := """";");
         TIO.Put_Line (Sp (6) & "Font_Size   : Integer := 9;");
         TIO.Put_Line (Sp (6) & "Font_Weight : String := """");");
      end if;
      TIO.New_Line;
      TIO.Put_Line (Sp (3) & "Me : Widget_Collection;");

      if Have_Date_Pickers > 0 then
         TIO.New_Line;
         Iterate (Emit_Date_Picker_Methods_Spec'Access);
      end if;
      if Have_Time_Pickers > 0 then
         TIO.New_Line;
         Iterate (Emit_Time_Picker_Methods_Spec'Access);
      end if;

      if Stat (Gtk_Tree_View) > 0
        and then
          Stat (Gtk_Cell_Renderer_Text) + Stat (Gtk_Cell_Renderer_Toggle) > 0
      then
         TIO.New_Line;
         TIO.Put_Line (Sp (3) & "function Lighten "
                       & "(RGBA : Gdk_RGBA; By : Gdk_Luminance) "
                       & "return Gdk_RGBA;");
      end if;

      if Stat (Gtk_Tree_View) > 0
        and then Stat (Gtk_Tree_View_Column) > 0
      then
         TIO.New_Line;
         TIO.Put_Line (Sp (3) & "procedure Set_All_Treeviews_Styles;");
      end if;

      Emit_Package_End (Capitalized_Filename & "_Pkg.Object_Collection");

   end Emit_Spec;

   ---------------------------------------------------------------------------
   procedure Emit_Body (Capitalized_Filename : String);
   procedure Emit_Body (Capitalized_Filename : String) is
   begin
      Log ("Generating Object Collection Body...");
      Include_Banner;
      if Stat (Gtk_Tree_View) > 0
        and then Stat (Gtk_Cell_Renderer_Text) + Stat (Gtk_Cell_Renderer_Toggle) > 0
        and then Stat (Gtk_Tree_View_Column) > 0
      then
         if Stat (Gtk_Button) = 0 then
            Emit_With_Use ("Gtk.Button");
         end if;
         Emit_With_Use ("Gtk.Css_Provider");
         Emit_With_Use ("Gtk.Style_Context");
         Emit_With_Use ("Glib.Error");
         Emit_With_Use ("Gtk.Enums");
         Emit_With_Use ("Pango.Font");
         Emit_With_Use ("Pango.Enums");
      end if;
      if Have_Header_Column_Tooltips > 0 and then Stat (Gtk_Notebook) = 0 then
         Emit_With_Use ("Gtk.Widget");
      end if;
      Emit_Package_Body (Capitalized_Filename & "_Pkg.Object_Collection", True);
      TIO.Put_Line (Sp (3) & "procedure New_Widget_Collection ("
                    & "OC : out Widget_Collection) is");
      TIO.Put_Line (Sp (3) & "begin");
      TIO.Put_Line (Sp (6) & "OC := new Widget_Collection_Record;");
      TIO.Put_Line (Sp (6) & Capitalized_Filename & "_Pkg.Object_Collection."
                    & "Initialize (OC);");
      TIO.Put_Line (Sp (3) & "end New_Widget_Collection;");
      TIO.New_Line;
      TIO.Put_Line (Sp (3) & "procedure Initialize ("
                    & "OC : not null access Widget_Collection_Record'Class)");
      TIO.Put_Line (Sp (3) & " is");
      if Have_Header_Column_Tooltips > 0 then
         TIO.Put_Line (Sp (6) & "Btn : Gtk_Widget;");
      end if;
      TIO.Put_Line (Sp (3) & "begin");

      if No_Objects then
         TIO.Put_Line (Sp (6) & "null;");
      else
         Iterate (Initialize_Object_In_Body'Access);
      end if;

      TIO.Put_Line (Sp (3) & "end Initialize;");

      if Stat (Gtk_Tree_View) > 0
        and then
          Stat (Gtk_Cell_Renderer_Text) + Stat (Gtk_Cell_Renderer_Toggle) > 0
      then
         TIO.New_Line;
         TIO.Put_Line (Sp (3) & "function Lighten "
                       & "(RGBA : Gdk_RGBA; By : Gdk_Luminance) "
                       & "return Gdk_RGBA is");
         TIO.Put_Line (Sp (6) & "G : Gdk_Color;");
         TIO.Put_Line (Sp (6) & "R : Gdk_RGBA;");
         TIO.Put_Line (Sp (6) & "use Glib;");
         TIO.Put_Line (Sp (3) & "begin");
         TIO.Put_Line (Sp (6) & "--  convert to gdk_color");
         TIO.Put_Line (Sp (6) & "Set_Rgb (G,");
         TIO.Put_Line (Sp (15) & "Guint16 (256.0 * RGBA.Red) * 256,");
         TIO.Put_Line (Sp (15) & "Guint16 (256.0 * RGBA.Green) * 256,");
         TIO.Put_Line (Sp (15) & "Guint16 (256.0 * RGBA.Blue) * 256);");
         TIO.Put_Line (Sp (6) & "--  lighten it");
         TIO.Put_Line (Sp (6) & "G := Lighten (G, By);");
         TIO.Put_Line (Sp (6) & "--  convert back to RGBA");
         TIO.Put_Line (Sp (6) & "R := Gdk_RGBA'("
                       & "Gdouble (Red (G)) / (256.0 * 256.0),");
         TIO.Put_Line (Sp (21) & "Gdouble (Green (G)) /  (256.0 * 256.0),");
         TIO.Put_Line (Sp (21) & "Gdouble (Blue (G)) / (256.0 * 256.0),");
         TIO.Put_Line (Sp (21) & "RGBA.Alpha);");
         TIO.Put_Line (Sp (6) & "return R;");
         TIO.Put_Line (Sp (3) & "end Lighten;");
         TIO.New_Line;
         TIO.Put_Line (Sp (3) & "procedure Set_Treeview_Style");
         TIO.Put_Line (Sp (5) & "(Tree        : Gtk_Tree_View;");
         TIO.Put_Line (Sp (6) & "Bgcolor     : String := """";");
         TIO.Put_Line (Sp (6) & "Fgcolor     : String := """";");
         TIO.Put_Line (Sp (6) & "SelBgcolor  : String := """";");
         TIO.Put_Line (Sp (6) & "SelFgcolor  : String := """";");
         TIO.Put_Line (Sp (6) & "Font_Name   : String := """";");
         TIO.Put_Line (Sp (6) & "Font_Size   : Integer := 9;");
         TIO.Put_Line (Sp (6) & "Font_Weight : String := """")");
         TIO.Put_Line (Sp (3) & "is");
         TIO.Put_Line (Sp (6) & "RGBA_BgColor   : Gdk_RGBA;");
         TIO.Put_Line (Sp (6) & "RGBA_FgColor   : Gdk_RGBA;");
         TIO.Put_Line (Sp (6) & "RGBA_PLBgColor : Gdk_RGBA;");
         TIO.Put_Line (Sp (6) & "RGBA_PLFgColor : Gdk_RGBA;");
         TIO.Put_Line (Sp (6) & "BT     : Gtk_Button;");
         TIO.Put_Line (Sp (6) & "OK     : Boolean;");
         TIO.Put_Line (Sp (6) & "Col    : Gtk_Tree_View_Column;");
         TIO.Put_Line (Sp (6) & "NCols  : Glib.Guint;");
         TIO.Put_Line (Sp (6) & "use type Glib.Guint;");
         TIO.Put_Line (Sp (6) & "use Pango.Enums;");
         TIO.Put_Line (Sp (3) & "begin");

         TIO.Put_Line (Sp (6) & "--  parse input colors");
         TIO.Put_Line (Sp (6) & "if Bgcolor /= """" then");
         TIO.Put_Line (Sp (9) & "Parse (RGBA_BgColor, Bgcolor, OK);");
         TIO.Put_Line (Sp (9) & "if not OK then");
         TIO.Put_Line (Sp (12) & "return;");
         TIO.Put_Line (Sp (9) & "end if;");
         TIO.Put_Line (Sp (6) & "end if;");
         TIO.Put_Line (Sp (6) & "if Fgcolor /= """" then");
         TIO.Put_Line (Sp (9) & "Parse (RGBA_FgColor, Fgcolor, OK);");
         TIO.Put_Line (Sp (9) & "if not OK then");
         TIO.Put_Line (Sp (12) & "return;");
         TIO.Put_Line (Sp (9) & "end if;");
         TIO.Put_Line (Sp (6) & "end if;");
         TIO.Put_Line (Sp (6) & "--  RGBA_PLBgColor := "
                       & "Lighten (RGBA_BgColor, 6000);");
         TIO.Put_Line (Sp (6) & "--  RGBA_PLFgColor := "
                       & "Lighten """" (RGBA_FgColor, Gdk_Luminance'First);");
         TIO.Put_Line (Sp (6) & "if SelBgcolor /= """" then");
         TIO.Put_Line (Sp (9) & "Parse (RGBA_PLBgColor, SelBgcolor, OK);");
         TIO.Put_Line (Sp (9) & "if not OK then");
         TIO.Put_Line (Sp (12) & "return;");
         TIO.Put_Line (Sp (9) & "end if;");
         TIO.Put_Line (Sp (6) & "end if;");
         TIO.Put_Line (Sp (6) & "if SelFgcolor /= """" then");
         TIO.Put_Line (Sp (9) & "Parse (RGBA_PLFgColor, SelFgcolor, OK);");
         TIO.Put_Line (Sp (9) & "if not OK then");
         TIO.Put_Line (Sp (12) & "return;");
         TIO.Put_Line (Sp (9) & "end if;");
         TIO.Put_Line (Sp (6) & "end if;");
         TIO.Put_Line (Sp (6) & "NCols := Tree.Get_N_Columns;");
         TIO.Put_Line (Sp (6) & "for J in 0 .. NCols - 1 loop");
         TIO.Put_Line (Sp (9) & "Col := Tree.Get_Column (Glib.Gint (J));");
         TIO.Put_Line (Sp (9) & "BT := Gtk_Button (Col.Get_Button);");
         TIO.Put_Line (Sp (9) & "if Bgcolor /= """" then");
         TIO.Put_Line (Sp (12) & "BT.Override_Background_Color "
                       & "(Gtk_State_Flag_Normal,");
         TIO.Put_Line (Sp (42) & "RGBA_BgColor);");
         TIO.Put_Line (Sp (12) & "BT.Override_Background_Color "
                       & "(Gtk_State_Flag_Prelight, RGBA_PLBgColor);");
         TIO.Put_Line (Sp (9) & "end if;");
         TIO.Put_Line (Sp (9) & "if Fgcolor /= """" then");
         TIO.Put_Line (Sp (12) & "BT.Override_Color "
                       & "(Gtk_State_Flag_Normal, RGBA_FgColor);");
         TIO.Put_Line (Sp (12) & "BT.Override_Color "
                       & "(Gtk_State_Flag_Prelight, RGBA_PLFgColor);");
         TIO.Put_Line (Sp (9) & "end if;");

         TIO.Put_Line (Sp (9) & "if Font_Name /= """" then");
         TIO.Put_Line (Sp (12) & "BT.Override_Font");
         TIO.Put_Line (Sp (14) & "(To_Font_Description");
         TIO.Put_Line (Sp (17) & "(Family_Name => Font_Name,");
         TIO.Put_Line (Sp (18) & "Size => Glib.Gint (Font_Size),");
         TIO.Put_Line (Sp (18) & "Weight => (if Font_Weight = ""Bold""");
         TIO.Put_Line (Sp (29) & "then Pango_Weight_Bold");
         TIO.Put_Line (Sp (29) & "else Pango_Weight_Normal)));");
         TIO.Put_Line (Sp (9) & "end if;");
         TIO.Put_Line (Sp (6) & "end loop;");
         TIO.New_Line;
         TIO.Put_Line (Sp (6) & "declare");
         TIO.Put_Line (Sp (9) & "Error : aliased Glib.Error.GError;");
         TIO.Put_Line (Sp (9) & "CSS   : constant String := "
                       & """treeview.view#"""
                       & " & Tree.Get_Name");
         TIO.Put_Line (Sp (21) & "& "" :selected {background-color: """
                       & " & SelBgcolor & "";""");
         TIO.Put_Line (Sp (21) & "& "" color: """
                       & " & SelFgcolor & "";}"";");
         TIO.Put_Line (Sp (9) & "Provider" & " : "
                       & "constant Gtk_Css_Provider := "
                          & "Gtk_Css_Provider_New;");
         TIO.Put_Line (Sp (6) & "begin");
         TIO.Put_Line (Sp (9) & "OK := Provider.Load_From_Data ("
                       & "CSS, Error'Access);");
         TIO.Put_Line (Sp (9) & "Get_Style_Context ("
                       & "Tree" & ")"
                       & ".Add_Provider (+Provider, Glib.Guint'Last);");
         TIO.Put_Line (Sp (6) & "end;");
         TIO.Put_Line (Sp (3) & "end Set_Treeview_Style;");

         if Stat (Gtk_Tree_View) > 0
           and then Stat (Gtk_Tree_View_Column) > 0
         then
            TIO.New_Line;
            TIO.Put_Line (Sp (3) & "procedure Set_All_Treeviews_Styles is");
            TIO.Put_Line (Sp (3) & "begin");
            Iterate (Set_TreeView_Styles'Access);
            TIO.Put_Line (Sp (3) & "end Set_All_Treeviews_Styles;");
         end if;
      end if;

      TIO.New_Line;
      TIO.Put_Line (Sp (3) & "function New_Widget_Collection return "
                    & "Widget_Collection is");
      TIO.Put_Line (Sp (6) & "OC : constant Widget_Collection := "
                   & "new Widget_Collection_Record;");
      TIO.Put_Line (Sp (3) & "begin");
      TIO.Put_Line (Sp (6) & Capitalized_Filename & "_Pkg.Object_Collection."
                    & "Initialize (OC);");
      TIO.New_Line;
      TIO.Put_Line (Sp (6) & "return OC;");
      TIO.Put_Line (Sp (3) & "end New_Widget_Collection;");

      if Have_Date_Pickers > 0 then
         Iterate (Emit_Date_Picker_Methods_Body'Access);
      end if;
      if Have_Time_Pickers > 0 then
         Iterate (Emit_Time_Picker_Methods_Body'Access);
      end if;
      Emit_Package_End (Capitalized_Filename & "_Pkg.Object_Collection");
   end Emit_Body;

   ---------------------------------------------------------------------------
   procedure Emit (Capitalized_Filename : String) is
   begin
      Emit_Spec (Capitalized_Filename);
      Emit_Body  (Capitalized_Filename);
   end Emit;
end G2a.Emit_Ada.Object_Collection;

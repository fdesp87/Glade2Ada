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
with Ada.Calendar;

with G2a.GNode;
with G2a.GObject;                use G2a.GObject;
with G2a.GSignal;
with G2a.GWidget;                use G2a.GWidget;
with G2a.Support;                use G2a.Support;
with G2a.GRadiobutton;           use G2a.GRadiobutton;
with G2a.GListstore;             use G2a.GListstore;

package body G2a.Emit_Ada.Signals is

   package TIO renames Ada.Text_IO;

   use G2a.GNode.Node_Tree_Pkg;

   Has_Main_Window_Internal   : Boolean := False;
   With_Form_Closing_Internal : Boolean := False;

   ---------------------------------------------------------------------------
   procedure Emit_Signal_Specs_For_Top_Level (Position : Cursor);
   procedure Emit_Signal_Specs_For_Top_Level (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);

      use G2a.GSignal;
      use Signal_List_Pkg;
      Crs : Signal_List_Pkg.Cursor;
      TS  : Signal;
   begin

      if not (Obj.Gtk_Class = Gtk_Window or Obj.Gtk_Class = Gtk_Dialog)
      then
         return;
      end if;

      Crs := Obj.Signals.First;
      while Crs /= Signal_List_Pkg.No_Element loop
         TS := Crs.Element;
         if TS.Emit then
            if TS.Proc then
               TIO.Put_Line (Sp (3)
                             & "procedure "
                             & TS.Handler.all);
               TIO.Put_Line (Sp (5)
                             & "(B : access Gtkada_Builder_Record'Class);");
            else
               TIO.Put_Line (Sp (3)
                             & "function "
                             & TS.Handler.all);
               TIO.Put_Line (Sp (5)
                             & "(B : access Gtkada_Builder_Record'Class) "
                             & "return Boolean;");
            end if;
            TIO.New_Line;
         end if;

         Crs := Crs.Next;
      end loop;
   end Emit_Signal_Specs_For_Top_Level;

   ---------------------------------------------------------------------------
   procedure Emit_Signal_Specs_For_Widgets (Position : Cursor);
   procedure Emit_Signal_Specs_For_Widgets (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);

      use G2a.GSignal;
      use Signal_List_Pkg;
      Crs : Signal_List_Pkg.Cursor;
      TS  : Signal;
   begin
      if Obj.Gtk_Class = Gtk_Window or Obj.Gtk_Class = Gtk_Dialog then
         return;
      end if;

      Crs := Obj.Signals.First;
      while Crs /= Signal_List_Pkg.No_Element loop
         TS := Crs.Element;

         if TS.Emit then
            if TS.Proc then
               TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
               TIO.Put_Line (Sp (5)
                             & "(User_Data : access GObject_Record'Class);");
            else
               TIO.Put_Line (Sp (3) & "function " & TS.Handler.all);
               TIO.Put_Line (Sp (5)
                             & "(User_Data : access GObject_Record'Class) "
                             & "return Boolean;");
            end if;
            TIO.New_Line;
         end if;

         Crs := Crs.Next;
      end loop;
   end Emit_Signal_Specs_For_Widgets;

   ---------------------------------------------------------------------------
   procedure Emit_Time_Picker_CSS (Position : Cursor);
   procedure Emit_Time_Picker_CSS (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);
   begin
      if Is_Time_Picker (Obj) then
         declare
            Name : constant String := Time_Picker_Name (Obj);
         begin
            TIO.Put_Line (Sp (6) & Name & "_CSS" & " : "
                          & "constant String :=");
            TIO.Put_Line (Sp (9) & """button#" & Name & "_Hour_Button_Up,""");
            TIO.Put_Line (Sp (9) & "& ""button#" & Name & "_Hour_Button_Down,""");
            TIO.Put_Line (Sp (9) & "& ""button#" & Name & "_Min_Button_Up,""");
            TIO.Put_Line (Sp (9) & "& ""button#" & Name & "_Min_Button_Down,""");
            TIO.Put_Line (Sp (9) & "& ""button#" & Name & "_Sec_Button_Up,""");
            TIO.Put_Line (Sp (9) & "& ""button#" & Name & "_Sec_Button_Down {""");
            TIO.Put_Line (Sp (9) & "& ""    padding: 0px;""");
            TIO.Put_Line (Sp (9) & "& ""    margin: 0px;""");
            TIO.Put_Line (Sp (9) & "& ""    min-width: 0px;""");
            TIO.Put_Line (Sp (9) & "& ""    min-height: 0px;""");
            TIO.Put_Line (Sp (9) & "& ""}""");
            TIO.Put_Line (Sp (9) & "& ""entry#" & Name & "_Hour_Entry,""");
            TIO.Put_Line (Sp (9) & "& ""entry#" & Name & "_Min_Entry,""");
            TIO.Put_Line (Sp (9) & "& ""entry#" & Name & "_Sec_Entry {""");
            TIO.Put_Line (Sp (9) & "& ""    margin: 0px;""");
            TIO.Put_Line (Sp (9) & "& ""    min-width: 0px;""");
            TIO.Put_Line (Sp (9) & "& ""    min-height: 0px;""");
            TIO.Put_Line (Sp (9) & "& ""}"";");
            TIO.Put_Line (Sp (6) & Name & "_Provider" & " : "
                          & "constant Gtk_Css_Provider := "
                          & "Gtk_Css_Provider_New;");
            TIO.Put_Line (Sp (6) & "package FA is new Forall_User_Data "
                          & "(Gtk_Style_Provider);");
            TIO.Put_Line (Sp (6) & "procedure Apply_" & Name & "_Css");
            TIO.Put_Line (Sp (8) & "(Widget : not null access Gtk.Widget."
                          & "Gtk_Widget_Record'Class;");
            TIO.Put_Line (Sp (9) & "Provider : Gtk_Style_Provider);");
            TIO.Put_Line (Sp (6) & "procedure Apply_" & Name & "_Css");
            TIO.Put_Line (Sp (8) & "(Widget : not null access Gtk.Widget."
                          & "Gtk_Widget_Record'Class;");
            TIO.Put_Line (Sp (9) & "Provider : Gtk_Style_Provider) is");
            TIO.Put_Line (Sp (6) & "begin");
            TIO.Put_Line (Sp (9) & "Get_Style_Context (Widget).Add_Provider "
                          & "(Provider, Glib.Guint'Last);");
            TIO.Put_Line (Sp (9) & "if Widget.all in Gtk_Container_Record'Class "
                          & "then");
            TIO.Put_Line (Sp (12) & "declare");
            TIO.Put_Line (Sp (15) & "Container : constant Gtk_Container := "
                          & "Gtk_Container (Widget);");
            TIO.Put_Line (Sp (12) & "begin");
            TIO.Put_Line (Sp (15) & "FA.Forall (Container,");
            TIO.Put_Line (Sp (26) & "Apply_"
                          & Name
                          & "_Css'Unrestricted_Access, Provider);");
            TIO.Put_Line (Sp (12) & "end;");
            TIO.Put_Line (Sp (9) & "end if;");
            TIO.Put_Line (Sp (6) & "end Apply_" & Name & "_Css" & ";");
         end;
      end if;
   end Emit_Time_Picker_CSS;

   ---------------------------------------------------------------------------
   procedure Emit_Init_Date_Time_Pickers (Position : Cursor);
   procedure Emit_Init_Date_Time_Pickers (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);
   begin
      if Is_Date_Picker (Obj) then
         declare
            Name : constant String := Date_Picker_Name (Obj);
         begin
            TIO.Put_Line (Sp (6) & "Me."
                          & Name
                          & "_Calendar"
                          & ".Set_Visible (False);");
            TIO.Put_Line (Sp (6)
                          & Name
                          & "_Set_Entries;");
            return;
         end;
      end if;

      if Is_Time_Picker (Obj) then
         declare
            Name : constant String := Time_Picker_Name (Obj);
         begin
            TIO.Put_Line (Sp (6) & "if "
                          & Name & "_Provider" & "."
                          & "Load_From_Data ("
                          & Name & "_CSS" & ", "
                          & "Error'Access)");
            TIO.Put_Line (Sp (6) & "then");
            TIO.Put_Line (Sp (9) & "Apply_"
                          & Name & "_Css (Me."
                          & Obj.Parent.ID.all & ", "
                          & "+" & Name & "_Provider"
                          & ");");
            TIO.Put_Line (Sp (6) & "end if;");
            TIO.New_Line;
            TIO.Put_Line (Sp (6) & Name & "_Reset_Entries;");
         end;
      end if;
   end Emit_Init_Date_Time_Pickers;

   ---------------------------------------------------------------------------
   procedure Emit_Date_Time_Method_Specs (Position : Cursor);
   procedure Emit_Date_Time_Method_Specs (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);
   begin
      if Is_Date_Picker (Obj) then
         TIO.Put_Line (Sp (3) & "procedure "
                       & Date_Picker_Name (Obj)
                       & "_Set_Entries;");
         TIO.New_Line;
         return;
      end if;

      if Is_Time_Picker (Obj) then
         TIO.Put_Line (Sp (3) & "procedure "
                       & Time_Picker_Name (Obj)
                       & "_Reset_Entries;");
         TIO.New_Line;
      end if;
   end Emit_Date_Time_Method_Specs;

   ---------------------------------------------------------------------------
   procedure Emit_Signal_Bodies_For_Top_Level (Position : Cursor);
   procedure Emit_Signal_Bodies_For_Top_Level (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);

      use G2a.GSignal;
      use Signal_List_Pkg;
      Crs : Signal_List_Pkg.Cursor;
      TS  : Signal;
   begin
      if not (Obj.Gtk_Class = Gtk_Window or Obj.Gtk_Class = Gtk_Dialog) then
         return;
      end if;

      Crs := Obj.Signals.First;
      while Crs /= Signal_List_Pkg.No_Element loop
         TS := Crs.Element;

         if TS.Emit then
            if TS.Proc then
               TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
               TIO.Put_Line (Sp (5) & "(B : access Gtkada_Builder_Record'Class)"
                             & " is");
               TIO.Put_Line (Sp (6) & "pragma Unreferenced (B);");
               if TS.Signal_Name.all = "realize" then
                  if Have_Time_Pickers > 0 then
                     TIO.Put_Line (Sp (6) & "Error : aliased Glib.Error.GError;");
                     Iterate (Emit_Time_Picker_CSS'Access);
                  end if;
               end if;
               TIO.Put_Line (Sp (3) & "begin");
               TIO.Put_Line (Sp (6) & "null;");
               if TS.Signal_Name.all = "realize" then
                  if Have_Date_Pickers + Have_Time_Pickers > 0 then
                     Iterate (Emit_Init_Date_Time_Pickers'Access);
                     TIO.New_Line;
                  end if;
               end if;
               Insert_Your_Code (6, TS.Handler.all);
               TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
            else
               TIO.Put_Line (Sp (3) & "function " & TS.Handler.all);
               TIO.Put_Line (Sp (5) & "(B : access Gtkada_Builder_Record'Class)"
                             & " return Boolean is");
               TIO.Put_Line (Sp (6) & "pragma Unreferenced (B);");
               TIO.Put_Line (Sp (3) & "begin");
               Insert_Your_Code (6, TS.Handler.all);
               if With_Form_Closing_Internal
                 and then
                   TS.Handler.all =
                     "On_"
                     & Capitalize (Obj.ID.all) & "_Formclosing"
                 and then Has_Main_Window_Internal
               then
                  TIO.Put_Line (Sp (6) & "Gtk.Main.Main_Quit;");
               end if;
               TIO.Put_Line (Sp (6) & "return False; --  signal not processed");
               TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
            end if;
            TIO.New_Line;
         end if;

         Crs := Crs.Next;
      end loop;
   end Emit_Signal_Bodies_For_Top_Level;

   ---------------------------------------------------------------------------
   procedure Emit_Signal_Bodies_For_Widgets (Position : Cursor);
   procedure Emit_Signal_Bodies_For_Widgets (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);

      use G2a.GSignal;
      use Signal_List_Pkg;
      Crs : Signal_List_Pkg.Cursor;
      TS  : Signal;
   begin
      if Obj.Gtk_Class = Gtk_Window or Obj.Gtk_Class = Gtk_Dialog then
         return;
      end if;

      if Is_Date_Picker (Obj) then
         declare
            Name : constant String := Date_Picker_Name (Obj);
         begin
            TIO.Put_Line (Sp (3)
                          & Name
                          & "_Min_Date : constant Time := Time_Of ("
                          & Img (Ada.Calendar.Year_Number'First) & ", "
                          & Img (Ada.Calendar.Month_Number'First) & ", "
                          & Img (Ada.Calendar.Day_Number'First) & ");");
            TIO.Put_Line (Sp (3)
                          & Name
                          & "_Max_Date : constant Time := Time_Of ("
                          & Img (Ada.Calendar.Year_Number'Last) & ", "
                          & Img (Ada.Calendar.Month_Number'Last) & ", "
                          & Img (Ada.Calendar.Day_Number'Last) & ");");
            TIO.New_Line;
            TIO.Put_Line (Sp (3) & "procedure " & Name
                          & "_Set_Entries is");
            TIO.Put_Line (Sp (6) & "Year, Month, Day : Guint;");
            TIO.Put_Line (Sp (3) & "begin");
            TIO.Put_Line (Sp (6) & "Me." & Name
                          & "_Calendar.Get_Date (Year, Month, Day);");
            TIO.Put_Line (Sp (6) & "Me." & Name
                          & "_Day_Entry.Set_Text (Img (Day));");
            TIO.Put_Line (Sp (6) & "Me." & Name
                          & "_Month_Entry.Set_Text (Img (Month + 1));");
            TIO.Put_Line (Sp (6) & "Me." & Name
                          & "_Year_Entry.Set_Text (Img (Year));");
            TIO.Put_Line (Sp (3) & "end " & Name & "_Set_Entries;");
            TIO.New_Line;
            return;
         end;
      end if;

      if Is_Date_Picker_Calendar (Obj) then
         declare
            Name : constant String := Date_Picker_Name (Obj);
         begin

            Crs := Obj.Signals.First;
            while Crs /= Signal_List_Pkg.No_Element loop
               TS := Crs.Element;

               if Starts_With (TS.Handler.all, "On_Day_Selected_Double_Click") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (6) & "Me." & Name & "_Calendar"
                                & ".Set_Visible (False);");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Day_Selected") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Prev_Year") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Next_Year") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Prev_Month") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Next_Month") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;
               end if;

               Crs := Crs.Next;
            end loop;
            return;
         end;
      end if;

      if Is_Date_Picker_Button (Obj) then
         declare
            Name : constant String := Date_Picker_Name (Obj);
         begin
            Crs := Obj.Signals.First;
            while Crs /= Signal_List_Pkg.No_Element loop
               TS := Crs.Element;

               if Starts_With (TS.Handler.all, "On_Button_Clicked") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (6) & "Me."
                                & Name & "_Calendar"
                                & ".Set_Visible");
                  TIO.Put_Line (Sp (9) & "(not Me."
                                & Name & "_Calendar"
                                & ".Get_Visible);");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;
               end if;

               Crs := Crs.Next;
            end loop;
            return;
         end;
      end if;

      if Is_Date_Picker_Year_Entry (Obj) then
         declare
            Name : constant String := Date_Picker_Name (Obj);
         begin
            Crs := Obj.Signals.First;
            while Crs /= Signal_List_Pkg.No_Element loop
               TS := Crs.Element;

               if Starts_With (TS.Handler.all, "On_Entry_Year_Leavefocus") then
                  TIO.Put_Line (Sp (3) & "function " & TS.Handler.all);
                  TIO.Put_Line (Sp (5)
                                & "(User_Data : access GObject_Record'Class)"
                                & " return Boolean is");
                  TIO.Put_Line (Sp (6) & "--  pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "On_Entry_Year_Activate_"
                                & Name
                                & " (User_Data);");
                  TIO.Put_Line (Sp (6)
                                & "return False; --  signal not processed");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Entry_Year_Activate") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (6) & "Year_String : constant String := Me."
                                & Name & "_Year_Entry.Get_Text;");
                  TIO.Put_Line (Sp (6) & "New_Year  : Year_Number;");
                  TIO.Put_Line (Sp (6) & "Year_Old  : Guint;");
                  TIO.Put_Line (Sp (6) & "Month_Old : Guint;");
                  TIO.Put_Line (Sp (6) & "Day_Old   : Guint;");
                  TIO.Put_Line (Sp (6) & "New_Time  : Time;");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "begin");
                  TIO.Put_Line (Sp (9) & "New_Year := Year_Number'Value (Year_String);");
                  TIO.Put_Line (Sp (6) & "exception");
                  TIO.Put_Line (Sp (9) & "when Constraint_Error =>");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (6) & "end;");
                  TIO.Put_Line (Sp (6) & "Me." & Name
                                & "_Calendar.Get_Date " &
                                  "(Year_Old, Month_Old, Day_Old);");
                  TIO.Put_Line (Sp (6) & "begin");
                  TIO.Put_Line (Sp (9) & "New_Time := Time_Of "
                                & "(New_Year,");
                  TIO.Put_Line (Sp (30) & "Month_Number (Month_Old + 1),");
                  TIO.Put_Line (Sp (30) & "Day_Number (Day_Old));");
                  TIO.Put_Line (Sp (9) & "if New_Time < " &
                                  Name & "_Min_Date then");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (9) & "end if;");
                  TIO.Put_Line (Sp (9) & "if New_Time > "
                                & Name & "_Max_Date then");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (9) & "end if;");
                  TIO.Put_Line (Sp (9) & "Me."
                                & Name
                                & "_Calendar.Select_Month "
                                & "(Month_Old, Guint (New_Year));");
                  TIO.Put_Line (Sp (6) & "exception");
                  TIO.Put_Line (Sp (9) & "when Ada.Calendar.Time_Error =>");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (6) & "end;");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;
               end if;

               Crs := Crs.Next;
            end loop;
            return;
         end;
      end if;

      if Is_Date_Picker_Month_Entry (Obj) then
         declare
            Name : constant String := Date_Picker_Name (Obj);
         begin
            Crs := Obj.Signals.First;
            while Crs /= Signal_List_Pkg.No_Element loop
               TS := Crs.Element;

               if Starts_With (TS.Handler.all, "On_Entry_Month_Leavefocus") then
                  TIO.Put_Line (Sp (3) & "function " & TS.Handler.all);
                  TIO.Put_Line (Sp (5)
                                & "(User_Data : access GObject_Record'Class)"
                                & " return Boolean is");
                  TIO.Put_Line (Sp (6) & "--  pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "On_Entry_Month_Activate_"
                                & Name
                                & " (User_Data);");
                  TIO.Put_Line (Sp (6)
                                & "return False; --  signal not processed");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Entry_Month_Activate") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (6) & "Month_String : constant String := Me."
                                & Name & "_Month_Entry.Get_Text;");
                  TIO.Put_Line (Sp (6) & "New_Month  : Month_Number;");
                  TIO.Put_Line (Sp (6) & "Year_Old   : Guint;");
                  TIO.Put_Line (Sp (6) & "Month_Old  : Guint;");
                  TIO.Put_Line (Sp (6) & "Day_Old    : Guint;");
                  TIO.Put_Line (Sp (6) & "New_Time   : Time;");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "begin");
                  TIO.Put_Line (Sp (9) & "New_Month := Month_Number'Value (Month_String);");
                  TIO.Put_Line (Sp (6) & "exception");
                  TIO.Put_Line (Sp (9) & "when Constraint_Error =>");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (6) & "end;");
                  TIO.Put_Line (Sp (6) & "Me." & Name
                                & "_Calendar.Get_Date " &
                                  "(Year_Old, Month_Old, Day_Old);");
                  TIO.Put_Line (Sp (6) & "begin");
                  TIO.Put_Line (Sp (9) & "New_Time := Time_Of "
                                & "(Year_Number (Year_Old),");
                  TIO.Put_Line (Sp (30) & "New_Month,");
                  TIO.Put_Line (Sp (30) & "Day_Number (Day_Old));");
                  TIO.Put_Line (Sp (9) & "if New_Time < " &
                                  Name & "_Min_Date then");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (9) & "end if;");
                  TIO.Put_Line (Sp (9) & "if New_Time > "
                                & Name & "_Max_Date then");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (9) & "end if;");
                  TIO.Put_Line (Sp (9) & "Me."
                                & Name
                                & "_Calendar.Select_Month "
                                & "(Guint (New_Month - 1), Year_Old);");
                  TIO.Put_Line (Sp (6) & "exception");
                  TIO.Put_Line (Sp (9) & "when Ada.Calendar.Time_Error =>");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (6) & "end;");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;
               end if;

               Crs := Crs.Next;
            end loop;
            return;
         end;
      end if;

      if Is_Date_Picker_Day_Entry (Obj) then
         declare
            Name : constant String := Date_Picker_Name (Obj);
         begin
            Crs := Obj.Signals.First;
            while Crs /= Signal_List_Pkg.No_Element loop
               TS := Crs.Element;

               if Starts_With (TS.Handler.all, "On_Entry_Day_Leavefocus") then
                  TIO.Put_Line (Sp (3) & "function " & TS.Handler.all);
                  TIO.Put_Line (Sp (5)
                                & "(User_Data : access GObject_Record'Class)"
                                & " return Boolean is");
                  TIO.Put_Line (Sp (6) & "--  pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "On_Entry_Day_Activate_"
                                & Name
                                & " (User_Data);");
                  TIO.Put_Line (Sp (6)
                                & "return False; --  signal not processed");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Entry_Day_Activate") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (6) & "Day_String : constant String := Me."
                                & Name & "_Day_Entry.Get_Text;");
                  TIO.Put_Line (Sp (6) & "New_Day   : Day_Number;");
                  TIO.Put_Line (Sp (6) & "Year_Old  : Guint;");
                  TIO.Put_Line (Sp (6) & "Month_Old : Guint;");
                  TIO.Put_Line (Sp (6) & "Day_Old   : Guint;");
                  TIO.Put_Line (Sp (6) & "New_Time  : Time;");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "begin");
                  TIO.Put_Line (Sp (9) & "New_Day := Day_Number'Value (Day_String);");
                  TIO.Put_Line (Sp (6) & "exception");
                  TIO.Put_Line (Sp (9) & "when Constraint_Error =>");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (6) & "end;");
                  TIO.Put_Line (Sp (6) & "Me." & Name
                                & "_Calendar.Get_Date " &
                                  "(Year_Old, Month_Old, Day_Old);");
                  TIO.Put_Line (Sp (6) & "begin");
                  TIO.Put_Line (Sp (9) & "New_Time := Time_Of "
                                & "(Year_Number (Year_Old),");
                  TIO.Put_Line (Sp (30) & "Month_Number (Month_Old + 1),");
                  TIO.Put_Line (Sp (30) & "New_Day);");
                  TIO.Put_Line (Sp (9) & "if New_Time < " &
                                  Name & "_Min_Date then");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (9) & "end if;");
                  TIO.Put_Line (Sp (9) & "if New_Time > "
                                & Name & "_Max_Date then");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (9) & "end if;");
                  TIO.Put_Line (Sp (9) & "Me."
                                & Name
                                & "_Calendar.Select_Day (Guint (New_Day));");
                  TIO.Put_Line (Sp (6) & "exception");
                  TIO.Put_Line (Sp (9) & "when Ada.Calendar.Time_Error =>");
                  TIO.Put_Line (Sp (12) & Name & "_Set_Entries;");
                  TIO.Put_Line (Sp (12) & "return;");
                  TIO.Put_Line (Sp (6) & "end;");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;
               end if;

               Crs := Crs.Next;
            end loop;
            return;
         end;
      end if;

      if Is_Time_Picker (Obj) then
         declare
            Name : constant String := Time_Picker_Name (Obj);
         begin
            TIO.Put_Line (Sp (3)
                          & Name & "_Hour : Integer := 0;");
            TIO.Put_Line (Sp (3)
                          & Name & "_Min  : Integer := 0;");
            TIO.Put_Line (Sp (3)
                          & Name & "_Sec  : Integer := 0;");
            TIO.New_Line;
            TIO.Put_Line (Sp (3) & "procedure " & Name
                          & "_Reset_Entries is");
            TIO.Put_Line (Sp (6) & "Now : constant Ada.Calendar.Time := "
                          & "Ada.Calendar.Clock;");
            TIO.Put_Line (Sp (3) & "begin");
            TIO.Put_Line (Sp (6) & Name & "_Hour := "
                          & "GNAT.Calendar.Hour (Now);");
            TIO.Put_Line (Sp (6) & Name & "_Min  := "
                          & "GNAT.Calendar.Minute (Now);");
            TIO.Put_Line (Sp (6) & Name & "_Sec  := "
                          & "Integer (GNAT.Calendar.Second (Now));");
            TIO.New_Line;
            TIO.Put_Line (Sp (6) & "Me." & Name
                          & "_Hour_Entry.Set_Text (Img ("
                          & Name & "_Hour));");
            TIO.Put_Line (Sp (6) & "Me." & Name
                          & "_Min_Entry.Set_Text (Img ("
                          & Name & "_Min));");
            TIO.Put_Line (Sp (6) & "Me." & Name
                          & "_Sec_Entry.Set_Text (Img ("
                          & Name & "_Sec));");
            TIO.Put_Line (Sp (3) & "end " & Name
                          & "_Reset_Entries;");
            TIO.New_Line;
         end;
         return;
      end if;

      if Is_Time_Picker_Button (Obj) then
         declare
            Name : constant String := Time_Picker_Name (Obj);
         begin
            Crs := Obj.Signals.First;
            while Crs /= Signal_List_Pkg.No_Element loop
               TS := Crs.Element;

               if Starts_With (TS.Handler.all, "On_Sec_Button_Up_Clicked") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Sec := "
                                & Name & "_Sec + 1;");
                  TIO.Put_Line (Sp (6) & "if " & Name & "_Sec >= 60 then");
                  TIO.Put_Line (Sp (9) & Name & "_Sec := "
                                & Name & "_Sec - 60;");
                  TIO.Put_Line (Sp (6) & "end if;");
                  TIO.Put_Line (Sp (6) & "Me." & Name
                                & "_Sec_Entry.Set_Text (Img ("
                                & Name & "_Sec" & "));");
                  TIO.New_Line;
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");

               elsif Starts_With (TS.Handler.all, "On_Sec_Button_Down_Clicked") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Sec := "
                                & Name & "_Sec - 1;");
                  TIO.Put_Line (Sp (6) & "if " & Name & "_Sec < 0 then");
                  TIO.Put_Line (Sp (9) & Name & "_Sec := "
                                & Name & "_Sec + 60;");
                  TIO.Put_Line (Sp (6) & "end if;");
                  TIO.Put_Line (Sp (6) & "Me." & Name
                                & "_Sec_Entry.Set_Text (Img ("
                                & Name & "_Sec" & "));");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Min_Button_Up_Clicked") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Min := "
                                & Name & "_Min + 1;");
                  TIO.Put_Line (Sp (6) & "if " & Name & "_Min >= 60 then");
                  TIO.Put_Line (Sp (9) & Name & "_Min := "
                                & Name & "_Min - 60;");
                  TIO.Put_Line (Sp (6) & "end if;");
                  TIO.Put_Line (Sp (6) & "Me." & Name
                                & "_Min_Entry.Set_Text (Img ("
                                & Name & "_Min" & "));");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Min_Button_Down_Clicked") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Min := "
                                & Name & "_Min - 1;");
                  TIO.Put_Line (Sp (6) & "if " & Name & "_Min < 0 then");
                  TIO.Put_Line (Sp (9) & Name & "_Min := "
                                & Name & "_Min + 60;");
                  TIO.Put_Line (Sp (6) & "end if;");
                  TIO.Put_Line (Sp (6) & "Me." & Name
                                & "_Min_Entry.Set_Text (Img ("
                                & Name & "_Min" & "));");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Hour_Button_Up_Clicked") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Hour := "
                                & Name & "_Hour + 1;");
                  TIO.Put_Line (Sp (6) & "if " & Name & "_Hour >= 24 then");
                  TIO.Put_Line (Sp (9) & Name & "_Hour := "
                                & Name & "_Hour - 24;");
                  TIO.Put_Line (Sp (6) & "end if;");
                  TIO.Put_Line (Sp (6) & "Me." & Name
                                & "_Hour_Entry.Set_Text (Img ("
                                & Name & "_Hour" & "));");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Hour_Button_Down_Clicked") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & Name & "_Hour := "
                                & Name & "_Hour - 1;");
                  TIO.Put_Line (Sp (6) & "if " & Name & "_Hour < 0 then");
                  TIO.Put_Line (Sp (9) & Name & "_Hour := "
                                & Name & "_Hour + 24;");
                  TIO.Put_Line (Sp (6) & "end if;");
                  TIO.Put_Line (Sp (6) & "Me." & Name
                                & "_Hour_Entry.Set_Text (Img ("
                                & Name & "_Hour" & "));");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;
               end if;

               Crs := Crs.Next;
            end loop;
            return;
         end;
      end if;

      if Is_Time_Picker_Hour_Entry (Obj) then
         declare
            Name : constant String := Time_Picker_Name (Obj);
         begin

            Crs := Obj.Signals.First;
            while Crs /= Signal_List_Pkg.No_Element loop
               TS := Crs.Element;

               if Starts_With (TS.Handler.all, "On_Entry_Hour_Leavefocus") then
                  TIO.Put_Line (Sp (3) & "function " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " return Boolean is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (6) & "Hour_String : constant String := "
                                & "Me." & Name & "_Hour_Entry.Get_Text;");
                  TIO.Put_Line (Sp (6) & "Hour        : Integer;");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "begin");
                  TIO.Put_Line (Sp (9) & "Hour := Integer'Value (Hour_String);");
                  TIO.Put_Line (Sp (6) & "exception");
                  TIO.Put_Line (Sp (9) & "when Constraint_Error =>");
                  TIO.Put_Line (Sp (12) & "Me." & Name
                                & "_Hour_Entry.Set_Text (Img ("
                                & Name & "_Hour));");
                  TIO.Put_Line (Sp (12) & "return False;");
                  TIO.Put_Line (Sp (6) & "end;");
                  TIO.Put_Line (Sp (6) & "if Hour not in 0 .. 23 then");
                  TIO.Put_Line (Sp (9) & "Me." & Name
                                & "_Hour_Entry.Set_Text (Img ("
                                & Name & "_Hour));");
                  TIO.Put_Line (Sp (9) & "return False;");
                  TIO.Put_Line (Sp (6) & "end if;");
                  TIO.Put_Line (Sp (6) & Name & "_Hour := Hour;");
                  TIO.Put_Line (Sp (6) & "return False;  --  signal not processed");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Entry_Hour_Activate") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "--  pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (6) & "Temp : Boolean;");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "Temp := On_Entry_Hour_Leavefocus_"
                                & Name & " (User_Data);");
                  TIO.Put_Line (Sp (6) & "null;");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;
               end if;
               Crs := Crs.Next;
            end loop;
            return;
         end;
      end if;

      if Is_Time_Picker_Min_Entry (Obj) then
         declare
            Name : constant String := Time_Picker_Name (Obj);
         begin

            Crs := Obj.Signals.First;
            while Crs /= Signal_List_Pkg.No_Element loop
               TS := Crs.Element;

               if Starts_With (TS.Handler.all, "On_Entry_Min_Leavefocus") then
                  TIO.Put_Line (Sp (3) & "function " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " return Boolean is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (6) & "Min_String : constant String := "
                                & "Me." & Name & "_Min_Entry.Get_Text;");
                  TIO.Put_Line (Sp (6) & "Min        : Integer;");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "begin");
                  TIO.Put_Line (Sp (9) & "Min := Integer'Value (Min_String);");
                  TIO.Put_Line (Sp (6) & "exception");
                  TIO.Put_Line (Sp (9) & "when Constraint_Error =>");
                  TIO.Put_Line (Sp (12) & "Me." & Name
                                & "_Min_Entry.Set_Text (Img (" & Name & "_Min));");
                  TIO.Put_Line (Sp (12) & "return False;");
                  TIO.Put_Line (Sp (6) & "end;");
                  TIO.Put_Line (Sp (6) & "if Min not in 0 .. 59 then");
                  TIO.Put_Line (Sp (9) & "Me." & Name
                                & "_Min_Entry.Set_Text (Img ("
                                & Name & "_Min));");
                  TIO.Put_Line (Sp (9) & "return False;");
                  TIO.Put_Line (Sp (6) & "end if;");
                  TIO.Put_Line (Sp (6) & Name & "_Min := Min;");
                  TIO.Put_Line (Sp (6) & "return False;  --  signal not processed");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Entry_Min_Activate") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "--  pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (6) & "Temp : Boolean;");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "Temp := On_Entry_Min_Leavefocus_"
                                & Name & " (User_Data);");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;
               end if;

               Crs := Crs.Next;
            end loop;
            return;
         end;
      end if;

      if Is_Time_Picker_Sec_Entry (Obj) then
         declare
            Name : constant String := Time_Picker_Name (Obj);
         begin

            Crs := Obj.Signals.First;
            while Crs /= Signal_List_Pkg.No_Element loop
               TS := Crs.Element;

               if Starts_With (TS.Handler.all, "On_Entry_Sec_Leavefocus") then
                  TIO.Put_Line (Sp (3) & "function " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " return Boolean is");
                  TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (6) & "Sec_String : constant String := "
                                & "Me." & Name & "_Sec_Entry.Get_Text;");
                  TIO.Put_Line (Sp (6) & "Sec        : Integer;");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "begin");
                  TIO.Put_Line (Sp (9) & "Sec := Integer'Value (Sec_String);");
                  TIO.Put_Line (Sp (6) & "exception");
                  TIO.Put_Line (Sp (9) & "when Constraint_Error =>");
                  TIO.Put_Line (Sp (12) & "Me." & Name
                                & "_Sec_Entry.Set_Text (Img ("
                                & Name & "_Sec));");
                  TIO.Put_Line (Sp (12) & "return False;");
                  TIO.Put_Line (Sp (6) & "end;");
                  TIO.Put_Line (Sp (6) & "if Sec not in 0 .. 59 then");
                  TIO.Put_Line (Sp (9) & "Me." & Name
                                & "_Sec_Entry.Set_Text (Img ("
                                & Name & "_Sec));");
                  TIO.Put_Line (Sp (9) & "return False;");
                  TIO.Put_Line (Sp (6) & "end if;");
                  TIO.Put_Line (Sp (6) & Name & "_Sec := Sec;");
                  TIO.Put_Line (Sp (6) & "return False;  --  signal not processed");
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;

               elsif Starts_With (TS.Handler.all, "On_Entry_Sec_Activate") then
                  TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
                  TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                & " is");
                  TIO.Put_Line (Sp (6) & "--  pragma Unreferenced (User_Data);");
                  TIO.Put_Line (Sp (6) & "Temp : Boolean;");
                  TIO.Put_Line (Sp (3) & "begin");
                  TIO.Put_Line (Sp (6) & "Temp := On_Entry_Sec_Leavefocus_"
                                & Name & " (User_Data);");
                  Insert_Your_Code (6, TS.Handler.all);
                  TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  TIO.New_Line;
               end if;
               Crs := Crs.Next;
            end loop;
            return;
         end;
      end if;

      --  any other object
      Crs := Obj.Signals.First;
      while Crs /= Signal_List_Pkg.No_Element loop
         TS := Crs.Element;

         if TS.Emit then
            if TS.Signal_Name.all = "focus" then
               if Is_Widget (Obj) then
                  declare
                     Wdg : constant Widget := Widget (Position.Element);
                  begin
                     TIO.Put_Line (Sp (3) & "function " & TS.Handler.all);
                     TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                                   & " return Boolean is");
                     TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
                     TIO.Put_Line (Sp (3) & "begin");
                     if Wdg.Next_Focus = null then
                        TIO.Put_Line (Sp (6) & "null;");
                        Insert_Your_Code (6, TS.Handler.all);
                     else
                        Insert_Your_Code (6, TS.Handler.all);
                        TIO.Put_Line (Sp (6) & "Gtk.Widget.Grab_Focus");
                        TIO.Put_Line (Sp (8) & "(Gtk_Widget (Me."
                                      & Wdg.Next_Focus.ID.all
                                      & "));");
                     end if;
                     TIO.Put_Line (Sp (6) & "return True;  --  signal processed");
                     TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
                  end;
               end if;
            elsif TS.Proc then
               TIO.Put_Line (Sp (3) & "procedure " & TS.Handler.all);
               TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                             & " is");
               TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
               TIO.Put_Line (Sp (3) & "begin");
               TIO.Put_Line (Sp (6) & "null;");
               Insert_Your_Code (6, TS.Handler.all);
               TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
            else  --  TS.Proc is false
               TIO.Put_Line (Sp (3) & "function " & TS.Handler.all);
               TIO.Put_Line (Sp (5) & "(User_Data : access GObject_Record'Class)"
                             & " return Boolean is");
               TIO.Put_Line (Sp (6) & "pragma Unreferenced (User_Data);");
               TIO.Put_Line (Sp (3) & "begin");
               Insert_Your_Code (6, TS.Handler.all);
               TIO.Put_Line (Sp (6) & "return False; --  signal not processed");
               TIO.Put_Line (Sp (3) & "end " & TS.Handler.all & ";");
            end if;
            TIO.New_Line;
         end if;

         Crs := Crs.Next;
      end loop;
   end Emit_Signal_Bodies_For_Widgets;

   ---------------------------------------------------------------------------
   procedure Emit_Spec (Capitalized_Filename : String);
   procedure Emit_Spec (Capitalized_Filename : String) is
   begin

      Log ("Generating Signals Spec...");
      Include_Banner;
      if Have_Signal_Realize > 0 then
         Emit_With_Use ("Gtkada.Builder");
      end if;
      Emit_With_Use ("Glib.Object");
      Emit_Package_Spec (Capitalized_Filename & "_Pkg.Signals");
      Iterate (Emit_Signal_Specs_For_Top_Level'Access);
      Iterate (Emit_Signal_Specs_For_Widgets'Access);
      Emit_Package_End (Capitalized_Filename & "_Pkg.Signals", False);
   end Emit_Spec;

   ---------------------------------------------------------------------------
   procedure Emit_Body (Capitalized_Filename : String;
                        Gtk_Class            : GTK_Enum);
   procedure Emit_Body (Capitalized_Filename : String;
                        Gtk_Class            : GTK_Enum) is
   begin
      Log ("Generating Signals Bodies...");
      Include_Banner;
      if With_Form_Closing_Internal and then Has_Main_Window_Internal then
         TIO.Put_Line ("with Gtk.Main;");
      end if;

      if Gtk_Class = Gtk_Window or Gtk_Class = Gtk_Dialog then
         TIO.Put_Line ("with " & Capitalized_Filename & "_Pkg.Object_Collection;");
         TIO.Put_Line ("use " & Capitalized_Filename & "_Pkg.Object_Collection;");
         Emit_With_Use ("Gtk.Widget");
         if Have_Date_Pickers > 0 then
            Emit_With_Use ("Gtk.Calendar");
            Emit_With_Use ("Glib");
            Emit_With_Use ("Gtk.GEntry");
            Emit_With_Use ("Ada.Calendar");
            if Have_Time_Pickers > 0 then
               Emit_With_Use ("Glib.Error");
               Emit_With_Use ("Gtk.Container");
               Emit_With_Use ("GNAT.Calendar");
               Emit_With_Use ("Gtk.Css_Provider");
               Emit_With_Use ("Gtk.Style_Provider");
               Emit_With_Use ("Gtk.Style_Context");
            end if;
         elsif Have_Time_Pickers > 0 then
            Emit_With_Use ("Glib");
            Emit_With_Use ("Gtk.GEntry");
            Emit_With_Use ("Ada.Calendar");
            Emit_With_Use ("Glib.Error");
            Emit_With_Use ("Gtk.Container");
            Emit_With_Use ("GNAT.Calendar");
            Emit_With_Use ("Gtk.Css_Provider");
            Emit_With_Use ("Gtk.Style_Provider");
            Emit_With_Use ("Gtk.Style_Context");
         end if;
      end if;
      Emit_Package_Body (Capitalized_Filename & "_Pkg.Signals", True);
      if Have_Date_Pickers > 0 then
         TIO.Put_Line (Sp (3) &
                         "function Img (Value : Guint) return String;");
         TIO.Put_Line (Sp (3) &
                         "function Img (Value : Guint) return String is");
         TIO.Put_Line (Sp (6) & "Str : constant String := Value'Image;");
         TIO.Put_Line (Sp (3) & "begin");
         TIO.Put_Line (Sp (6) & "return Str (Str'First + 1 .. Str'Last);");
         TIO.Put_Line (Sp (3) & "end Img;");
         TIO.New_Line;
      end if;
      if Have_Time_Pickers > 0 then
         TIO.Put_Line (Sp (3) &
                         "function Img (Value : Integer) return String;");
         TIO.Put_Line (Sp (3) &
                         "function Img (Value : Integer) return String is");
         TIO.Put_Line (Sp (6) & "Str : constant String := Value'Image;");
         TIO.Put_Line (Sp (3) & "begin");
         TIO.Put_Line (Sp (6) & "return Str (Str'First + 1 .. Str'Last);");
         TIO.Put_Line (Sp (3) & "end Img;");
         TIO.New_Line;
      end if;
      Iterate (Emit_Date_Time_Method_Specs'Access);
      Iterate (Emit_Signal_Bodies_For_Top_Level'Access);
      Compute_Focus_List;
      Iterate (Emit_Signal_Bodies_For_Widgets'Access);
      Emit_Package_End (Capitalized_Filename & "_Pkg.Signals", False);
   end Emit_Body;

   ---------------------------------------------------------------------------
   procedure Emit (Capitalized_Filename : String;
                   With_Form_Closing    : Boolean;
                   Has_Main_Window      : Boolean;
                   Gtk_Class            : GTK_Enum) is
   begin
      Has_Main_Window_Internal   := Has_Main_Window;
      With_Form_Closing_Internal := With_Form_Closing;

      Emit_Spec (Capitalized_Filename);
      Emit_Body (Capitalized_Filename, Gtk_Class);
   end Emit;

end G2a.Emit_Ada.Signals;

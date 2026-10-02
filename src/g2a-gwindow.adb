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
with G2a.GObject;       use G2a.GObject;

package body G2a.GWindow is

   ----------------------------------------------------------------------
   procedure Get_New (Win : out Window;
                      ID  : String := "") is
   begin
      Win := new Window_Block'(Default_Window_Block);
      Win.ID := new String'(ID);
      Win.Gtk_Class := Gtk_Window;
      Insert_In_Object_Table (Object (Win));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Window_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Type_Property =>
            if P.String_Value.all = "popup" then
               OB.TopLevel := False;
            else
               OB.TopLevel := True;
            end if;
            return;
         when Attached_To_Property =>
            OB.Attached_To := P.String_Value;
            return;
         when Transient_For_Property =>
            OB.Transient_For := P.String_Value;
            return;
         when Title_Property =>
            OB.Title := P.String_Value;
            return;
         when Role_Property =>
            OB.Window_Role := P.String_Value;
            return;
         when Resizable_Property =>
            OB.Window_Flags (Resizable) := P.Boolean_Value;
            return;
         when Modal_Property =>
            OB.Window_Flags (Modal) := P.Boolean_Value;
            return;
         when Window_Position_Property =>
            OB.Window_Position := Convert_To_Window_Position (P.String_Value.all);
            return;
         when Default_Width_Property =>
            OB.Default_Width_Set := True;
            OB.Default_Width := P.Integer_Value;
            return;
         when Default_Height_Property =>
            OB.Default_Height_Set := True;
            OB.Default_Height := P.Integer_Value;
            return;
         when Destroy_With_Parent_Property =>
            OB.Window_Flags (Destroy_With_Parent) := P.Boolean_Value;
            return;
         when Hide_Titlebar_When_Maximized_Property =>
            OB.Hide_Titlebar := P.Boolean_Value;
            return;
         when Icon_Name_Property =>
            OB.Icon_Name := P.String_Value;
            return;
         when Icon_File_Property =>
            OB.Icon_File := P.String_Value;
            return;
         when Type_Hint_Property =>
            OB.Hint := Convert_To_Hint (P.String_Value.all);
            return;
         when Skip_Taskbar_Hint_Property =>
            OB.Window_Flags (Skip_Task_Bar) := P.Boolean_Value;
            return;
         when Skip_Pager_Hint_Property =>
            OB.Window_Flags (Skip_Pager) := P.Boolean_Value;
            return;
         when Urgency_Hint_Property =>
            OB.Window_Flags (Urgent) := P.Boolean_Value;
            return;
         when Accept_Focus_Property =>
            OB.Window_Flags (Accept_Focus) := P.Boolean_Value;
            return;
         when Focus_On_Map_Property =>
            OB.Window_Flags (Focus_On_Map) := P.Boolean_Value;
            return;
         when Decorated_Property =>
            OB.Decorated := P.Boolean_Value;
            return;
         when Deletable_Property =>
            OB.Window_Flags (Deletable) := P.Boolean_Value;
            return;
         when Gravity_Property =>
            OB.Window_Gravity := Convert_To_Window_Gravity (P.String_Value.all);
            return;
         when Has_Resize_Grip_Property =>
            OB.Window_Flags (Resize_Grip) := P.Boolean_Value;
            return;
         when Startup_ID_Property =>
            OB.Startup_ID := P.String_Value;
            return;
         when others => null;
      end case;

      --  call the parent to process parent's properties
      Widget_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GWindow;

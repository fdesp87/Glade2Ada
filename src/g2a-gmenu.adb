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
with G2a.GObject; use G2a.GObject;

package body G2a.GMenu is

   procedure Get_New (Mn : out Menu;
                      ID : String := "") is
   begin
      Mn := new Menu_Block'(Default_Menu_Block);
      Mn.ID := new String'(ID);
      Mn.Gtk_Class := Gtk_Menu;
      Insert_In_Object_Table (Object (Mn));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Menu_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Accel_Group_Property =>
            OB.Accel_Group := P.String_Value;
            return;
         when Accel_Path_Property =>
            OB.Accel_Path := P.String_Value;
            return;
         when Tearoff_State_Property =>
            OB.Tearoff_State := P.Boolean_Value;
            return;
         when Tearoff_Title_Property =>
            OB.Tearoff_Title := P.String_Value;
            return;
         when Reserve_Toggle_Size_Property =>
            OB.Reserve_Toggle_Size := P.Boolean_Value;
            return;
         when Rect_Anchor_Dx_Property =>
            OB.Rect_Anchor_Dx := P.Integer_Value;
            return;
         when Rect_Anchor_Dy_Property =>
            OB.Rect_Anchor_Dy := P.Integer_Value;
            return;
         when Menu_Type_Hint_Property =>
            OB.Menu_Type_Hint := Convert_To_Hint (P.String_Value.all);
            return;
         when Take_Focus_Property =>
            OB.Take_Focus := P.Boolean_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Menushell_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GMenu;

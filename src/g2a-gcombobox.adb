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

package body G2a.GCombobox is

   ----------------------------------------------------------------------
   procedure Get_New (Cbb : out Combobox;
                      ID  : String := "") is
   begin
      Cbb := new Combobox_Block'(Default_Combobox_Block);
      Cbb.ID := new String'(ID);
      Cbb.Gtk_Class := Gtk_Combo_Box;
      Insert_In_Object_Table (Object (Cbb));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Combobox_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Model_Property =>
            OB.Treemodel := P.String_Value;
            return;
         when Id_Column_Property =>
            OB.Id_Column := P.Integer_Value;
            return;
         when Active_Property =>
            OB.Active_Item := P.Integer_Value;
            return;
         when Active_ID_Property =>
            OB.Active_Id := P.String_Value;
            return;
         when Button_Sensitivity_Property =>
            OB.Button_Sensitivity := Convert_To_Button_Sensitivity (P.String_Value.all);
            return;
         when Has_Entry_Property =>
            OB.Has_Entry := P.Boolean_Value;
            return;
         when Has_Frame_Property =>
            OB.Draw_Frame_Around_Entry := P.Boolean_Value;
            return;
         when Entry_Text_Column_Property =>
            OB.Entry_Text_Column := P.Integer_Value;
            return;
         when Add_Tearoffs_Property =>
            OB.Tearoff_Menus := P.Boolean_Value;
            return;
         when Tearoff_Title_Property =>
            OB.Tearoff_Title := P.Text;
            return;
         when Focus_On_Click_Property =>
            OB.Focus_On_Click := P.Boolean_Value;
            return;
         when Popup_Fixed_Width_Property =>
            OB.Popup_Fixed_Width := P.Boolean_Value;
            return;
         when Wrap_Width_Property =>
            OB.Wrap_Width := P.Integer_Value;
            return;
         when Row_Span_Column_Property =>
            OB.Row_Span_Column := P.Integer_Value;
            return;
         when Column_Span_Column_Property =>
            OB.Column_Span_Column := P.Integer_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Bin_Block (OB).Process_Property (P);
   end Process_Property;


end G2a.GCombobox;

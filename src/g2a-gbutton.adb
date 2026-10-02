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

package body G2a.GButton is

   ----------------------------------------------------------------------
   procedure Get_New (But : out Button;
                      ID  : String := "") is
   begin
      But := new Button_Block'(Default_Button_Block);
      But.ID := new String'(ID);
      But.Gtk_Class := Gtk_Button;
      Insert_In_Object_Table (Object (But));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Button_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Focus_On_Click_Property =>
            OB.Focus_On_Click := P.Boolean_Value;
            return;
         when Xalign_Property =>
            OB.H_Child_Alignment := P.Decimal_Value;
            OB.With_H_Child_Alignment := True;
            return;
         when Yalign_Property =>
            OB.V_Child_Alignment := P.Decimal_Value;
            OB.With_V_Child_Alignment := True;
            return;
         when Use_Underline_Property =>
            OB.Use_Underline := P.Boolean_Value;
            return;
         when Use_Stock_Property =>
            OB.Use_Stock := P.Boolean_Value;
            return;
         when Relief_Property =>
            OB.Border_Relief := Convert_To_Border_Relief (P.String_Value.all);
            return;
         when Label_Property =>
            OB.Label_Name := P.String_Value;
            return;
         when Image_Position_Property =>
            OB.Image_Position := Convert_To_Position (P.String_Value.all);
            return;
         when Image_Property =>
            OB.Image := P.String_Value;
            return;
         when Always_Show_Image_Property =>
            OB.Always_Show_Image := P.Boolean_Value;
            return;
         when Action_Name_Property =>
            OB.Action.Action_Name := P.String_Value;
            return;
         when Related_Action_Property =>
            OB.Action.Related_Action := P.String_Value;
            return;
         when Use_Action_Appearance_Property =>
            OB.Action.Use_Action_Appearance_Marked := True;
            OB.Action.Use_Action_Appearance := P.Boolean_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Container_Block (OB).Process_Property (P);
   end Process_Property;
end G2a.GButton;

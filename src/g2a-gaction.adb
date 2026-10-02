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

package body G2a.GAction is

   procedure Get_New (AC : out Action;
                      ID : String := "") is
   begin
      AC := new Action_Block'(Default_Action_Block);
      AC.ID := new String'(ID);
      AC.Gtk_Class := Gtk_Action;
      Insert_In_Object_Table (Object (AC));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Action_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Label_Property =>
            OB.Label := P.Text;
            return;
         when Short_Label_Property =>
            OB.Short_Label := P.Text;
            return;
         when Tooltip_Property =>
            OB.Tooltip := P.Text;
            return;
         when Stock_ID_Property =>
            OB.Stock_Icon := P.String_Value;
            return;
         when Icon_Name_Property =>
            OB.Icon_Name := P.String_Value;
            return;
         when Visible_When_Horizontal_Property =>
            OB.Visible_When_Horizontal := P.Boolean_Value;
            return;
         when Visible_When_Vertical_Property =>
            OB.Visible_When_Vertical := P.Boolean_Value;
            return;
         when Visible_Overflown_Property =>
            OB.Visible_When_Overflown := P.Boolean_Value;
            return;
         when Is_Important_Property =>
            OB.Is_Important := P.Boolean_Value;
            return;
         when Hide_If_Empty_Property =>
            OB.Hide_If_Empty := P.Boolean_Value;
            return;
         when Sensitive_Property =>
            OB.Sensitive := P.Boolean_Value;
            return;
         when Visible_Property =>
            OB.Visible := P.Boolean_Value;
            return;
         when Always_Show_Image_Property =>
            OB.Always_Show_Image := P.Boolean_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Object_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GAction;

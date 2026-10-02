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

package body G2a.GTreeview is

   procedure Get_New (Tv : out Treeview;
                      ID : String := "") is
   begin
      Tv := new Treeview_Block'(Default_Treeview_Block);
      Tv.ID := new String'(ID);
      Tv.Gtk_Class := Gtk_Tree_View;
      Insert_In_Object_Table (Object (Tv));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Treeview_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Model_Property =>
            OB.Model := P.String_Value;
            return;
         when Rules_Hint_Property =>
            OB.Rules_Hint := P.Boolean_Value;
            return;
         when Expander_Column_Property =>
            OB.Expander_Column := P.String_Value;
            return;
         when Fixed_Height_Mode_Property =>
            OB.Fixed_Height_Mode := P.Boolean_Value;
            return;
         when Ubuntu_Almost_Fixed_Height_Mode_Property =>
            OB.Private_Ubuntu_Extension := P.Boolean_Value;
            return;
         when Level_Indentation_Property =>
            OB.Level_Indentation := P.Integer_Value;
            return;
         when Rubber_Banding_Property =>
            OB.Rubber_Banding := P.Boolean_Value;
            return;
         when Enable_Grid_Lines_Property =>
            OB.Enable_Grid_Lines := Convert_To_Enable_Grid_Lines (P.String_Value.all);
            return;
         when Activate_On_Single_Click_Property =>
            OB.Single_Click_Activate := P.Boolean_Value;
            return;
         when Hadjustment_Property =>
            OB.Hadjustment := P.String_Value;
            return;
         when Vadjustment_Property =>
            OB.Vadjustment := P.String_Value;
            return;
         when HScroll_Policy_Property =>
            OB.Scrolling_H_Policy := Convert_To_Treeview_Scrolling_Policy (P.String_Value.all);
            return;
         when VScroll_Policy_Property =>
            OB.Scrolling_V_Policy := Convert_To_Treeview_Scrolling_Policy (P.String_Value.all);
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Container_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GTreeview;

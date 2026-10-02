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

package body G2a.GTreeviewcolumn is

   procedure Get_New (Tc : out Treeviewcolumn;
                      ID : String := "") is
   begin
      Tc := new Treeviewcolumn_Block'(Default_Treeviewcolumn_Block);
      Tc.ID := new String'(ID);
      Tc.Gtk_Class := Gtk_Tree_View_Column;
      Insert_In_Object_Table (Object (Tc));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Treeviewcolumn_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Resizable_Property =>
            OB.Resizable := P.Boolean_Value;
            return;
         when Spacing_Property =>
            OB.Spacing := P.Integer_Value;
            return;
         when Sizing_Property =>
            if P.String_Value.all = "fixed" then
               OB.Sizing := Fixed_Column;
            elsif P.String_Value.all = "autosize" then
               OB.Sizing := Autosize_Column;
            elsif P.String_Value.all = "grow-oly" then
               OB.Sizing := Grow_Only_Column;
            end if;
            return;
         when Min_Width_Property =>
            OB.Min_Width := P.Integer_Value;
            return;
         when Max_Width_Property =>
            OB.Max_Width := P.Integer_Value;
            return;
         when Title_Property =>
            OB.Title := P.String_Value;
            return;
         when Clickable_Property =>
            OB.Clickable := P.Boolean_Value;
            return;
         --  when Widget_Property =>         --  unknown
         --     OB.Widget := P.String_Value;
         --     return;
         when Alignment_Property =>
            OB.Alignment := P.Decimal_Value;
            return;
         when Reorderable_Property =>
            OB.Reorderable := P.Boolean_Value;
            return;
         when Sort_Indicator_Property =>
            OB.Sort_Indicator := P.Boolean_Value;
            return;
         when Sort_Order_Property =>
            if P.String_Value.all = "ascending" then
               OB.Sort_Order := Ascending;
            else
               OB.Sort_Order := Descending;
            end if;
            return;
         when Sort_Column_Id_Property =>
            OB.Sort_Column_Id := P.Integer_Value;
            return;
         when Expand_Property =>
            OB.Expand := P.Boolean_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Object_Block (OB).Process_Property (P);
   end Process_Property;


end G2a.GTreeviewcolumn;

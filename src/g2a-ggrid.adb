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

package body G2a.GGrid is

   procedure Get_New (Bx : out Grid;
                      ID : String := "") is
   begin
      Bx := new Grid_Block'(Default_Grid_Block);
      Bx.ID := new String'(ID);
      Bx.Gtk_Class := Gtk_Grid;
      Bx.Row_Count := 0;
      Bx.Col_Count := 0;
      Insert_In_Object_Table (Object (Bx));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Grid_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Orientation_Property =>
            OB.Orientation := Convert_To_Orientation (P.String_Value.all);
            return;
         when Row_Spacing_Property =>
            OB.Row_Spacing := P.Integer_Value;
            return;
         when Row_Homogeneous_Property =>
            OB.Row_Homogeneous := P.Boolean_Value;
            return;
         when Column_Spacing_Property =>
            OB.Col_Spacing := P.Integer_Value;
            return;
         when Column_Homogeneous_Property =>
            OB.Col_Homogeneous := P.Boolean_Value;
            return;
         when Baseline_Row_Property =>
            OB.Baseline_Row := P.Integer_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Container_Block (OB).Process_Property (P);
   end Process_Property;
end G2a.GGrid;

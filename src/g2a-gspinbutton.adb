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

package body G2a.GSpinbutton is

   ----------------------------------------------------------------------
   procedure Get_New (Spb : out Spinbutton;
                      ID  : String := "") is
   begin
      Spb := new Spinbutton_Block'(Default_Spinbutton_Block);
      Spb.ID := new String'(ID);
      Spb.Gtk_Class := Gtk_Spin_Button;
      Insert_In_Object_Table (Object (Spb));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Spinbutton_Block;
                                          P  : Property) is
   begin
      case P.Prop is
         when Adjustment_Property =>
            OB.Adjustment := P.String_Value;
            return;
         when Climb_Rate_Property =>
            OB.Climb_Rate := P.Decimal_Value;
            return;
         when Numeric_Property =>
            OB.Is_Numeric := P.Boolean_Value;
            return;
         when Orientation_Property =>
            OB.Orientation := Convert_To_Orientation (P.String_Value.all);
            return;
         when Snap_To_Ticks_Property =>
            OB.Snap_To_Ticks := P.Boolean_Value;
            return;
         when The_Digits_Property =>
            OB.Num_Decimals := P.Integer_Value;
            return;
         when Update_Policy_Property =>
            OB.Update_Policy := Convert_To_Update_Policy (P.String_Value.all);
            return;
         when Value_Property =>
            OB.Value := P.Decimal_Value;
            return;
         when Wrap_Property =>
            OB.Wrap := P.Boolean_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Entry_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GSpinbutton;

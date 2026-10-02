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

package body G2a.GAdjustment is

   procedure Get_New (Ad : out Adjustment;
                      ID : String := "") is
   begin
      Ad := new Adjustment_Block'(Default_Adjustment_Block);
      Ad.ID := new String'(ID);
      Ad.Gtk_Class := Gtk_Adjustment;
      Insert_In_Object_Table (Object (Ad));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Adjustment_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Lower_Property =>
            OB.Lower := Long_Float (P.Decimal_Value);
            return;
         when Page_Increment_Property =>
            OB.Page_Increment := Long_Float (P.Decimal_Value);
            return;
         when Page_Size_Property =>
            OB.Page_Size := Long_Float (P.Decimal_Value);
            return;
         when Step_Increment_Property =>
            OB.Step_Increment := Long_Float (P.Decimal_Value);
            return;
         when Upper_Property =>
            OB.Upper := Long_Float (P.Decimal_Value);
            return;
         when Value_Property =>
            OB.Value := Long_Float (P.Decimal_Value);
            return;
         when others => null;
      end case;

      --  call the parent to process parent's properties
      Object_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GAdjustment;

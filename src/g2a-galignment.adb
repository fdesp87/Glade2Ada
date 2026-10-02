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

package body G2a.GAlignment is

   procedure Get_New (Al : out Alignment;
                      ID : String := "") is
   begin
      Al := new Alignment_Block'(Default_Alignment_Block);
      Al.ID := new String'(ID);
      Al.Gtk_Class := Gtk_Alignment;
      Insert_In_Object_Table (Object (Al));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Alignment_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Xalign_Property =>
            OB.H_Alignment := P.Decimal_Value;
            return;
         when Yalign_Property =>
            OB.V_Alignment := P.Decimal_Value;
            return;
         when Xscale_Property =>
            OB.H_Scale := P.Decimal_Value;
            return;
         when Yscale_Property =>
            OB.V_Scale := P.Decimal_Value;
            return;
         when Top_Padding_Property =>
            OB.Top_Padding := P.Integer_Value;
            return;
         when Bottom_Padding_Property =>
            OB.Bottom_Padding := P.Integer_Value;
            return;
         when Left_Padding_Property =>
            OB.Left_Padding := P.Integer_Value;
            return;
         when Right_Padding_Property =>
            OB.Right_Padding := P.Integer_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Bin_Block (OB).Process_Property (P);
   end Process_Property;
end G2a.GAlignment;

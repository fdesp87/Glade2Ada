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

package body G2a.GFrame is

   procedure Get_New (Fr : out Frame;
                      ID : String := "") is
   begin
      Fr := new Frame_Block'(Default_Frame_Block);
      Fr.ID := new String'(ID);
      Fr.Gtk_Class := Gtk_Frame;
      Insert_In_Object_Table (Object (Fr));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Frame_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Label_Xalign_Property =>
            OB.Label_X_Align := P.Decimal_Value;
            return;
         when Label_Yalign_Property =>
            OB.Label_Y_Align := P.Decimal_Value;
            return;
         when Shadow_Type_Property =>
            OB.Frame_Shadow := Convert_To_Shadow_Type (P.String_Value.all);
            return;
         when others => null;
      end case;

      --  call the parent to process parent's properties
      Bin_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GFrame;

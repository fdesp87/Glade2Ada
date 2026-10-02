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

package body G2a.GAspectframe is

   procedure Get_New (Afr : out Aspectframe;
                      ID  : String := "") is
   begin
      Afr := new Aspectframe_Block'(Default_Aspectframe_Block);
      Afr.ID := new String'(ID);
      Afr.Gtk_Class := Gtk_Aspect_Frame;
      Insert_In_Object_Table (Object (Afr));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Aspectframe_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Ratio_Property =>
            OB.Ratio := P.Decimal_Value;
            return;
         when Obey_Child_Property =>
            OB.Obey_Child := P.Boolean_Value;
            return;
         when Xalign_Property =>
            OB.H_Alignment := P.Decimal_Value;
            return;
         when Yalign_Property =>
            OB.V_Alignment := P.Decimal_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Frame_Block (OB).Process_Property (P);
   end Process_Property;
end G2a.GAspectframe;

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

package body G2a.GPopover is

   procedure Get_New (B : out Popover;
                      ID  : String := "") is
   begin
      B := new Popover_Block'(Default_Popover_Block);
      B.ID := new String'(ID);
      B.Gtk_Class := Gtk_Popover;
      Insert_In_Object_Table (Object (B));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Popover_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Relative_To_Property =>
            OB.Relative_To := P.String_Value;
            return;
         when Position_Property =>
            OB.Position := Convert_To_Popover_Position (P.String_Value.all);
            return;
         when Modal_Property =>
            OB.Modal := P.Boolean_Value;
            return;
         when Transitions_Enabled_Property =>
            OB.Transitions_Enabled := P.Boolean_Value;
            return;
         when Constrain_To_Property =>
            OB.Constrain_To := Convert_To_Constrain_To (P.String_Value.all);
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Bin_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GPopover;

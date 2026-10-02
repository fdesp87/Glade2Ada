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

package body G2a.GEntrybuffer is

   ----------------------------------------------------------------------
   procedure Get_New (Ebf : out Entrybuffer;
                      ID  : String := "") is
   begin
      Ebf := new Entrybuffer_Block'(Default_Entrybuffer_Block);
      Ebf.ID := new String'(ID);
      Ebf.Gtk_Class := Gtk_Entry_Buffer;
      Insert_In_Object_Table (Object (Ebf));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Entrybuffer_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Max_Length_Property =>
            OB.Maximun_Length := P.Integer_Value;
            return;
         when Text_Property =>
            OB.Text := P.Text;
            return;
         when others => null;
      end case;

      --  call the parent to process parent's properties
      Object_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GEntrybuffer;

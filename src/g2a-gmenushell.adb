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

package body G2a.GMenushell is

   procedure Get_New (Ms : out Menushell;
                      ID : String := "") is
   begin
      Ms := new Menushell_Block'(Default_Menushell_Block);
      Ms.ID := new String'(ID);
      Ms.Gtk_Class := Gtk_Menu_Shell;
      Insert_In_Object_Table (Object (Ms));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Menushell_Block;
                                          P  : Property) is
   begin
      --  process its properties

      --  call the parent to process parent's properties
      Container_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GMenushell;

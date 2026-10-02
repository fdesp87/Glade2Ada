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
with G2a.GObject;       use G2a.GObject;

package body G2a.GSeparatormenuitem is

   procedure Get_New (Smi : out Separatormenuitem;
                      ID  : String := "") is
   begin
      Smi := new Separatormenuitem_Block'(Default_Separatormenuitem_Block);
      Smi.ID := new String'(ID);
      Smi.Gtk_Class := Gtk_Separator_Menu_Item;
      Insert_In_Object_Table (Object (Smi));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Separatormenuitem_Block;
                                          P  : Property) is
   begin
      --  process its properties

      --  call the parent to process parent's properties
      Menuitem_Block (OB).Process_Property (P);
   end Process_Property;
end G2a.GSeparatormenuitem;

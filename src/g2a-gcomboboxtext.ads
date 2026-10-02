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

with G2a.GCombobox;    use G2a.GCombobox;
with G2a.GProperty;    use G2a.GProperty;
with G2a.GItem;        use G2a.GItem;

package G2a.GComboboxtext is

   type Comboboxtext_Block is new Combobox_Block with record
      List_Of_Items : Item_List;
   end record;
   type Comboboxtext is access all Comboboxtext_Block'Class;

   procedure Get_New (Cbt : out Comboboxtext;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Comboboxtext_Block;
                                          P  : Property);

   Default_Comboboxtext_Block : constant
     Comboboxtext_Block :=
       (Default_Combobox_Block with
        List_Of_Items => Empty_Item_List);

end G2a.GComboboxtext;

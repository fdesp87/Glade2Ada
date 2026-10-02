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

with Ada.Containers.Doubly_Linked_Lists;

package G2a.GItem is

   type Item_Block is record
      Value        : String_Access;
      Translatable : Boolean;
      Context      : String_Access;
      Comments     : String_Access;
   end record;
   type Item is access Item_Block;

   package Item_List_Pkg is new Ada.Containers.Doubly_Linked_Lists
     (Element_Type => Item,
      "="          => "=");

   subtype Item_List is Item_List_Pkg.List;
   Empty_Item_List : constant Item_List := Item_List_Pkg.Empty_List;

   procedure Get_New (It           : out Item;
                      Value        : String;
                      Translatable : Boolean;
                      Context      : String;
                      Comments     : String);

   Default_Translatable : constant Boolean := True;

   Default_Item_Block : constant Item_Block :=
                          (Value        => null,
                           Translatable => Default_Translatable,
                           Context      => null,
                           Comments     => null);

end G2a.GItem;

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
with Ada.Unchecked_Deallocation;

package G2a.GProperty is

   type Text_Block is record
      Text         : String_Access;
      Translatable : Boolean;
      Context      : String_Access;
      Comments     : String_Access;
   end record;

   Default_Text_Block : constant Text_Block := (Text         => null,
                                                Translatable => False,
                                                Context      => null,
                                                Comments     => null);

   type Property_Block is record
      Prop             : Property_Enum;
      Name             : String_Access;
      Flavor           : Property_Flavor_Enum;
      String_Value     : String_Access;
      Text             : Text_Block;
      Integer_Value    : Integer;
      Boolean_Value    : Boolean;
      Decimal_Value    : Float;
   end record;
   type Property is access Property_Block;

   procedure Free is new Ada.Unchecked_Deallocation
     (Object => Property_Block, Name => Property);

   Default_Property_Block : constant Property_Block :=
                              (Prop             => Unknown_Property,
                               Name             => null,
                               Flavor           => Unknown_Flavor,
                               String_Value     => null,
                               Text             => Default_Text_Block,
                               Integer_Value    => 0,
                               Boolean_Value    => False,
                               Decimal_Value    => 0.0);

   package Property_List_Pkg is new Ada.Containers.Doubly_Linked_Lists
     (Element_Type => Property,
      "="          => "=");
   use Property_List_Pkg;

   subtype Property_List is List;

   Empty_Property_List : constant Property_List := Property_List_Pkg.Empty_List;

   procedure Get_New (P    : out Property;
                      Name : String);

   Unknown_Property : exception;
end G2a.GProperty;

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

with G2a.GObject;       use G2a.GObject;
with G2a.GProperty;     use G2a.GProperty;

package G2a.GFilefilter is

   package Mime_Types_List_Pkg is new Ada.Containers.Doubly_Linked_Lists
     (Element_Type => String_Access,
      "="          => "=");
   subtype Mime_Types_List is Mime_Types_List_Pkg.List;
   Empty_Mime_Types_List : constant Mime_Types_List := Mime_Types_List_Pkg.Empty_List;

   package Pattern_List_Pkg is new Ada.Containers.Doubly_Linked_Lists
     (Element_Type => String_Access,
      "="          => "=");
   subtype Pattern_List is Pattern_List_Pkg.List;
   Empty_Pattern_List : constant Pattern_List := Pattern_List_Pkg.Empty_List;

   type Filefilter_Block is new Object_Block with record
      Mime_Types : Mime_Types_List;
      Patterns   : Pattern_List;
   end record;
   type Filefilter is access all Filefilter_Block'Class;

   procedure Get_New (Flf  : out Filefilter;
                      ID   : String := "");

   overriding procedure Process_Property (OB : in out Filefilter_Block;
                                          P  : Property);

   Default_Filefilter_Block : constant Filefilter_Block :=
                            (Default_Object_Block with
                             Mime_Types => Empty_Mime_Types_List,
                             Patterns   => Empty_Pattern_List);

end G2a.GFilefilter;

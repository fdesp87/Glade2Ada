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

package G2a.GListcolumn is

   type Listcolumn_Type is (Gchararray, Gboolean, Gbuttonboxstyle,
                            Gfloat, Gint);

   type Listcolumn_Block is record
      Name    : String_Access;
      CType   : Listcolumn_Type;
      CNumber : Integer;
   end record;

   type Listcolumn is access Listcolumn_Block;

   package Listcolumn_List_Pkg is new Ada.Containers.Doubly_Linked_Lists
     (Element_Type => Listcolumn,
      "="          => "=");

   subtype Listcolumn_List is Listcolumn_List_Pkg.List;

   Empty_Listcolumn_List : constant Listcolumn_List := Listcolumn_List_Pkg.Empty_List;

   procedure Get_New (P    : out Listcolumn;
                      Name : String);

   Default_Listcolumn_Block : constant Listcolumn_Block :=
                                (Name    => null,
                                 CType   => Gchararray,
                                 CNumber => -1);

   Unknown_Listcolumn_Type : exception;

end G2a.GListcolumn;

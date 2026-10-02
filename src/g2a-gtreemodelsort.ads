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

with G2a.GTreemodel;       use G2a.GTreemodel;
with G2a.GProperty;        use G2a.GProperty;

package G2a.GTreemodelsort is

   type Treemodelsort_Block is new Treemodel_Block with record
      Model : String_Access; --  points to a Treemodelfilter
   end record;

   type Treemodelsort is access all Treemodelsort_Block'Class;

   procedure Get_New (Tms : out Treemodelsort;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Treemodelsort_Block;
                                          P  : Property);

   Default_Treemodelsort_Block : constant Treemodelsort_Block :=
                                   (Default_Treemodel_Block with
                                    Model => null);

end G2a.GTreemodelsort;

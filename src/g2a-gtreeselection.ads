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

with G2a.GObject;         use G2a.GObject;
with G2a.GProperty;       use G2a.GProperty;
with G2a.GEnumerations;   use G2a.GEnumerations;

package G2a.GTreeselection is

   type Treeselection_Block is new Object_Block with record
      Selection_Mode : Selection_Mode_Enum;
   end record;

   type Treeselection is access all Treeselection_Block'Class;

   procedure Get_New (Ts : out Treeselection;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Treeselection_Block;
                                          P  : Property);


   Default_Treeselection_Block : constant Treeselection_Block :=
     (Default_Object_Block with
      Selection_Mode => Default_Selection_Mode);

end G2a.GTreeselection;

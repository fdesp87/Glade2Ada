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

with G2a.GContainer;      use G2a.GContainer;
with G2a.GProperty;       use G2a.GProperty;
with G2a.GEnumerations;   use G2a.GEnumerations;

package G2a.GGrid is

   type Grid_Block is new Container_Block with record
      Orientation       : Orientation_Enum;
      Baseline_Row      : Natural;
      Row_Spacing       : Natural;
      Row_Count         : Natural;
      Row_Homogeneous   : Boolean;
      Col_Spacing       : Natural;
      Col_Count         : Natural;
      Col_Homogeneous   : Boolean;
   end record;
   type Grid is access all Grid_Block'Class;

   procedure Get_New (Bx :  out Grid;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Grid_Block;
                                          P  : Property);

   Default_Baseline_Row     : constant Natural := 0;
   Default_Row_Spacing      : constant Natural := 0;
   Default_Row_Count        : constant Natural := 3;
   Default_Row_Homogeneous  : constant Boolean := False;
   Default_Col_Spacing      : constant Natural := 0;
   Default_Col_Count        : constant Natural := 3;
   Default_Col_Homogeneous  : constant Boolean := False;

   Default_Grid_Block : constant Grid_Block :=
                         (Default_Container_Block with
                          Orientation     => Default_Orientation,
                          Baseline_Row    => Default_Baseline_Row,
                          Row_Spacing     => Default_Row_Spacing,
                          Row_Count       => Default_Row_Count,
                          Row_Homogeneous => Default_Row_Homogeneous,
                          Col_Spacing     => Default_Col_Spacing,
                          Col_Count       => Default_Col_Count,
                          Col_Homogeneous => Default_Col_Homogeneous);
end G2a.GGrid;

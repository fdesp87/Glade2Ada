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

package G2a.GBox is

   type Box_Block is new Container_Block with record
      Orientation       : Orientation_Enum;
      Spacing           : Natural;
      Baseline_Position : Baseline_Position_Enum;
      Num_Of_Items      : Positive;
      Homogeneous       : Boolean;
      Add_Center_Child  : Boolean;
   end record;
   type Box is access all Box_Block'Class;

   procedure Get_New (Bx :  out Box;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Box_Block;
                                          P  : Property);

   Default_Spacing           : constant Natural := 0;
   Default_Numb_Of_Items     : constant Natural := 3;
   Default_Homogeneous       : constant Boolean := False;
   Default_Add_Center_Child  : constant Boolean := False;

   Default_Box_Block : constant Box_Block :=
                         (Default_Container_Block with
                          Orientation       => Default_Orientation,
                          Spacing           => Default_Spacing,
                          Baseline_Position => Default_Baseline_Position,
                          Num_Of_Items      => Default_Numb_Of_Items,
                          Homogeneous       => Default_Homogeneous,
                          Add_Center_Child  => Default_Add_Center_Child);

end G2a.GBox;

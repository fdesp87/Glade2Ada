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

with G2a.GBin;          use G2a.GBin;
with G2a.GProperty;     use G2a.GProperty;

package G2a.GAlignment is

   type Alignment_Block is new Bin_Block with record
      H_Alignment    : Float;
      V_Alignment    : Float;
      H_Scale        : Float;
      V_Scale        : Float;
      Top_Padding    : Integer;
      Bottom_Padding : Integer;
      Left_Padding   : Integer;
      Right_Padding  : Integer;
   end record;

   type Alignment is access all Alignment_Block'Class;

   procedure Get_New (Al : out Alignment;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Alignment_Block;
                                          P  : Property);

   Default_H_Alignment    : constant Float := 0.5;
   Default_V_Alignment    : constant Float := 0.5;
   Default_H_Scale        : constant Float := 1.0;
   Default_V_Scale        : constant Float := 1.0;
   Default_Top_Padding    : constant Integer := 0;
   Default_Bottom_Padding : constant Integer := 0;
   Default_Left_Padding   : constant Integer := 0;
   Default_Right_Padding  : constant Integer := 0;

   Default_Alignment_Block : constant Alignment_Block :=
      (Default_Bin_Block with
       H_Alignment    => Default_H_Alignment,
       V_Alignment    => Default_V_Alignment,
       H_Scale        => Default_H_Scale,
       V_Scale        => Default_V_Scale,
       Top_Padding    => Default_Top_Padding,
       Bottom_Padding => Default_Bottom_Padding,
       Left_Padding   => Default_Left_Padding,
       Right_Padding  => Default_Right_Padding);

end G2a.GAlignment;

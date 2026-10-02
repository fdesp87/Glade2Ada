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

with G2a.GObject;       use G2a.GObject;
with G2a.GProperty;     use G2a.GProperty;

package G2a.GAdjustment is

   type Adjustment_Block is new Object_Block with record
      Num_Decimals   : Integer;
      Lower          : Long_Float;
      Page_Increment : Long_Float;
      Page_Size      : Long_Float;
      Step_Increment : Long_Float;
      Upper          : Long_Float;
      Value          : Long_Float;
   end record;

   type Adjustment is access all Adjustment_Block'Class;

   procedure Get_New (Ad : out Adjustment;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Adjustment_Block;
                                          P  : Property);

   Default_Num_Decimals   : constant Integer    := 2;
   Default_Lower          : constant Long_Float := 0.0;
   Default_Page_Increment : constant Long_Float := 0.0;
   Default_Page_Size      : constant Long_Float := 0.0;
   Default_Step_Increment : constant Long_Float := 0.0;
   Default_Upper          : constant Long_Float := 0.0;
   Default_Value          : constant Long_Float := 0.0;

   Default_Adjustment_Block : constant Adjustment_Block :=
      (Default_Object_Block with
       Num_Decimals   => Default_Num_Decimals,
       Lower          => Default_Lower,
       Page_Increment => Default_Page_Increment,
       Page_Size      => Default_Page_Size,
       Step_Increment => Default_Step_Increment,
       Upper          => Default_Upper,
       Value          => Default_Value);

end G2a.GAdjustment;

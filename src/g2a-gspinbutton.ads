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

with G2a.GEntry;        use G2a.GEntry;
with G2a.GProperty;     use G2a.GProperty;
with G2a.GEnumerations; use G2a.GEnumerations;

package G2a.GSpinbutton is

   type Spinbutton_Block is new Entry_Block with record
      Adjustment    : String_Access;
      Value         : Float;
      Num_Decimals  : Natural;
      Climb_Rate    : Float;
      Orientation   : Orientation_Enum;
      Update_Policy : Update_Policy_Enum;
      Is_Numeric    : Boolean;
      Wrap          : Boolean;
      Snap_To_Ticks : Boolean;
   end record;
   type Spinbutton is access all Spinbutton_Block'Class;

   procedure Get_New (Spb : out Spinbutton;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Spinbutton_Block;
                                          P  : Property);


   Default_Value         : constant Float := 0.0;
   Default_Num_Decimals  : constant Natural := 0;
   Default_Climb_Rate    : constant Float := 0.0;
   Default_Is_Numeric    : constant Boolean := False;
   Default_Wrap          : constant Boolean := False;
   Default_Snap_To_Ticks : constant Boolean := False;

   Default_Spinbutton_Block : constant
     Spinbutton_Block :=
       (Default_Entry_Block with
        Adjustment    => null,
        Value         => Default_Value,
        Num_Decimals  => Default_Num_Decimals,
        Climb_Rate    => Default_Climb_Rate,
        Orientation   => Default_Orientation,
        Update_Policy => Default_Update_Policy,
        Is_Numeric    => Default_Is_Numeric,
        Wrap          => Default_Wrap,
        Snap_To_Ticks => Default_Snap_To_Ticks);
end G2a.GSpinbutton;

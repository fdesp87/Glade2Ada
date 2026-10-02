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

with G2a.GBin;            use G2a.GBin;
with G2a.GProperty;       use G2a.GProperty;
with G2a.GEnumerations;   use G2a.GEnumerations;

package G2a.GPopover is

   type Popover_Block is new Bin_Block with record
      Composite           : Boolean;
      Relative_To         : String_Access;
      Modal               : Boolean;
      Constrain_To        : Popover_Constrain_To_Enum;
      Transitions_Enabled : Boolean;
      Position            : Popover_Position_Enum;
   end record;

   type Popover is access all Popover_Block'Class;

   Default_Composite           : constant Boolean := False;
   Default_Modal               : constant Boolean := True;
   Default_Transitions_Enabled : constant Boolean := True;

   procedure Get_New (B  : out Popover;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Popover_Block;
                                          P  : Property);

   Default_Popover_Block : constant Popover_Block :=
                             (Default_Bin_Block with
                              Composite           => Default_Composite,
                              Relative_To         => null,
                              Modal               => Default_Modal,
                              Constrain_To        => Default_Constrain_To,
                              Transitions_Enabled => Default_Transitions_Enabled,
                              Position            => Default_Popover_Position);

end G2a.GPopover;

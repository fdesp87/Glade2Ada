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

with G2a.GButton;       use G2a.GButton;
with G2a.GProperty;     use G2a.GProperty;

package G2a.GTogglebutton is

   type Togglebutton_Block is new Button_Block with record
      Active         : Boolean;
      Inconsistent   : Boolean;
      Draw_Indicator : Boolean;
   end record;
   type Togglebutton is access all Togglebutton_Block'Class;

   procedure Get_New (Tbt : out Togglebutton;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Togglebutton_Block;
                                          P  : Property);

   Default_Active         : constant Boolean := False;
   Default_Inconsistent   : constant Boolean := False;
   Default_Draw_Indicator : constant Boolean := False;

   Default_Togglebutton_Block : constant Togglebutton_Block :=
       (Default_Button_Block
        with
        Active         => Default_Active,
        Inconsistent   => Default_Inconsistent,
        Draw_Indicator => Default_Draw_Indicator);

end G2a.GTogglebutton;

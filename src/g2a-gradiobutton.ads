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

package G2a.GRadiobutton is

   type Radiobutton_Block is new Button_Block with record
      Inconsistent   : Boolean;
      Draw_Indicator : Boolean;
      Active         : Boolean;
      Group          : access Radiobutton_Block;
   end record;
   type Radiobutton is access all Radiobutton_Block'Class;

   procedure Get_New (Rbt : out Radiobutton;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Radiobutton_Block;
                                          P  : Property);

   Default_Inconsistent   : constant Boolean := False;
   Default_Draw_Indicator : constant Boolean := False;
   Default_Active         : constant Boolean := False;

   Default_Radiobutton_Block : constant Radiobutton_Block :=
                                 (Default_Button_Block with
                                  Inconsistent   => Default_Inconsistent,
                                  Draw_Indicator => Default_Draw_Indicator,
                                  Active         => Default_Active,
                                  Group          => null);

end G2a.GRadiobutton;

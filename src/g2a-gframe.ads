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
with G2a.GEnumerations; use G2a.GEnumerations;

package G2a.GFrame is

   type Frame_Block is new Bin_Block with record
      Label_X_Align : Float;
      Label_Y_Align : Float;
      Frame_Shadow  : Shadow_Type_Enum;
   end record;

   type Frame is access all Frame_Block'Class;

   procedure Get_New (Fr : out Frame;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Frame_Block;
                                          P  : Property);

   Default_Label_X_Align : constant Float := 0.0;
   Default_Label_Y_Align : constant Float := 0.5;

   Default_Frame_Block : constant Frame_Block :=
     (Default_Bin_Block with
      Label_X_Align => Default_Label_X_Align,
      Label_Y_Align => Default_Label_Y_Align,
      Frame_Shadow  => Default_Shadow_Type);

end G2a.GFrame;

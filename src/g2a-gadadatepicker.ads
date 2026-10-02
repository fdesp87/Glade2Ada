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

with G2a.GFrame;        use G2a.GFrame;
with G2a.GProperty;     use G2a.GProperty;

package G2a.GAdadatepicker is

   type Adadatepicker_Block is new Frame_Block with record
      Min_Date : String_Access;
      Max_Date : String_Access;
   end record;

   type Adadatepicker is access all Adadatepicker_Block'Class;

   procedure Get_New (Afr : out Adadatepicker;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Adadatepicker_Block;
                                          P  : Property);


   Default_Adadatepicker_Block : constant Adadatepicker_Block :=
     (Default_Frame_Block with
      Min_Date => null,
      Max_Date => null);

end G2a.GAdadatepicker;

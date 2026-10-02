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

with G2a.GBox;          use G2a.GBox;
with G2a.GProperty;     use G2a.GProperty;
with G2a.GEnumerations; use G2a.GEnumerations;

package G2a.GButtonbox is

   type Buttonbox_Block is new Box_Block with record
      Layout_Style : Layout_Style_Enum;
   end record;
   type Buttonbox is access all Buttonbox_Block'Class;

   procedure Get_New (Bbx : out Buttonbox;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Buttonbox_Block;
                                          P  : Property);

   Default_Buttonbox_Block : constant Buttonbox_Block :=
                               (Default_Box_Block with
                                Layout_Style => Default_Layout_Style
                               );

end G2a.GButtonbox;

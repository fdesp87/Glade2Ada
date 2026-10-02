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

with G2a.GMenu;         use G2a.GMenu;
with G2a.GProperty;     use G2a.GProperty;
with G2a.GEnumerations; use G2a.GEnumerations;

package G2a.GMenubar is

   type Menubar_Block is new Menu_Block with record
      Pack_Direction       : Pack_Direction_Enum;
      Child_Pack_Direction : Pack_Direction_Enum;
   end record;

   type Menubar is access all Menubar_Block'Class;

   procedure Get_New (Mb : out Menubar;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Menubar_Block;
                                          P  : Property);

   Default_Menubar_Block          : constant Menubar_Block :=
      (Default_Menu_Block with
       Pack_Direction       => Default_Pack_Direction,
       Child_Pack_Direction => Default_Pack_Direction);

end G2a.GMenubar;

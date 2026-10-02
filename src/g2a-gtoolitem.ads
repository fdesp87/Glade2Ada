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

with G2a.GMenuitem;      use G2a.GMenuitem;
with G2a.GProperty;      use G2a.GProperty;

package G2a.GToolitem is

   type Toolitem_Block is new Menuitem_Block with record
      Draw                    : Boolean;
      Visible_When_Vertical   : Boolean;
      Visible_When_Horizontal : Boolean;
      Is_Important            : Boolean;
   end record;

   type Toolitem is access all Toolitem_Block'Class;

   procedure Get_New (Ti : out Toolitem;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Toolitem_Block;
                                          P  : Property);

   Default_Draw                    : constant Boolean := True;
   Default_Visible_When_Horizontal : constant Boolean := True;
   Default_Visible_When_Vertical   : constant Boolean := True;
   Default_Is_Important            : constant Boolean := False;

   Default_Toolitem_Block : constant Toolitem_Block :=
       (Default_Menuitem_Block with
        Draw                    => Default_Draw,
        Visible_When_Horizontal => Default_Visible_When_Horizontal,
        Visible_When_Vertical   => Default_Visible_When_Vertical,
        Is_Important            => Default_Is_Important);

end G2a.GToolitem;

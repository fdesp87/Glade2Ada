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

with G2a.GContainer;      use G2a.GContainer;
with G2a.GProperty;       use G2a.GProperty;
with G2a.GEnumerations;   use G2a.GEnumerations;

package G2a.GToolbar is

   type Toolbar_Block is new Container_Block with record
      Use_Tool_Bar_Style : Boolean;
      Toolbar_Style      : Toolbar_Enum;
      Use_Icon_Size      : Boolean;
      Icon_Size          : Icon_Size_Enum;
      Show_Arrow         : Boolean;
      Orientation        : Orientation_Enum;
   end record;

   type Toolbar is access all Toolbar_Block'Class;

   procedure Get_New (Tb : out Toolbar;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Toolbar_Block;
                                          P  : Property);

   Default_Use_Tool_Bar_Style : constant Boolean := True;
   Default_Use_Icon_Size      : constant Boolean := False;
   Default_Icon_Size          : constant Icon_Size_Enum := Large_Toolbar;
   Default_Show_Arrow         : constant Boolean := True;

   Default_Toolbar_Block : constant Toolbar_Block :=
     (Default_Container_Block with
      Use_Tool_Bar_Style => Default_Use_Tool_Bar_Style,
      Toolbar_Style      => Default_Toolbar_Style,
      Use_Icon_Size      => Default_Use_Icon_Size,
      Icon_Size          => Default_Icon_Size,
      Show_Arrow         => Default_Show_Arrow,
      Orientation        => Default_Orientation);

end G2a.GToolbar;

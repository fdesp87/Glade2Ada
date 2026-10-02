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

with G2a.GMenushell;      use G2a.GMenushell;
with G2a.GProperty;       use G2a.GProperty;
with G2a.GEnumerations;   use G2a.GEnumerations;

package G2a.GMenu is

   type Anchor_Hints_Enum is (Flip_Vertically, Slide_Horizontally,
                              Slide_Vertically, Resize_Horizontally,
                              Resize_Vertically, Flip_Both_Sides,
                              Slide_Both_Sides, Resize_Both_Sides);
   type Anchor_Hints_Array is array (Anchor_Hints_Enum) of Boolean;

   type Menu_Block is new Menushell_Block with record
      Accel_Group         : String_Access;
      Accel_Path          : String_Access;
      Tearoff_State       : Boolean;
      Tearoff_Title       : String_Access;
      Reserve_Toggle_Size : Boolean;
      Anchor_Hints        : Anchor_Hints_Array;
      Rect_Anchor_Dx      : Integer;
      Rect_Anchor_Dy      : Integer;
      Menu_Type_Hint      : Hint_Enum;
      Take_Focus          : Boolean;
   end record;

   type Menu is access all Menu_Block'Class;

   procedure Get_New (Mn : out Menu;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Menu_Block;
                                          P  : Property);

   Default_Tearoff_State       : constant Boolean := False;
   Default_Reserve_Toggle_Size : constant Boolean := True;
   Default_Anchor_Hints        : constant Anchor_Hints_Array := (others => True);
   Default_Rect_Anchor_Dx      : constant Integer := 0;
   Default_Rect_Anchor_Dy      : constant Integer := 0;
   Default_Menu_Type_Hint      : constant Hint_Enum := Popup_Menu;
   Default_Take_Focus          : constant Boolean := True;

   Default_Menu_Block          : constant Menu_Block :=
      (Default_Menushell_Block with
       Accel_Group         => null,
       Accel_Path          => null,
       Tearoff_State       => Default_Tearoff_State,
       Tearoff_Title       => null,
       Reserve_Toggle_Size => Default_Reserve_Toggle_Size,
       Anchor_Hints        => Default_Anchor_Hints,
       Rect_Anchor_Dx      => Default_Rect_Anchor_Dx,
       Rect_Anchor_Dy      => Default_Rect_Anchor_Dy,
       Menu_Type_Hint      => Default_Menu_Type_Hint,
       Take_Focus          => Default_Take_Focus);

end G2a.GMenu;

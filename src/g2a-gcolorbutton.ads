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

package G2a.GColorButton is

   type Colorbutton_Block is new Button_Block with record
      Alpha        : Integer;
      Color        : String_Access;
      Rgba         : String_Access;
      Show_Editor  : Boolean;
      Dialog_Title : String_Access;
      Use_Alpha    : Boolean;
   end record;
   type Colorbutton is access all Colorbutton_Block'Class;

   procedure Get_New (But : out Colorbutton;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Colorbutton_Block;
                                          P  : Property);

   Default_Alpha        : constant Integer := 65535;
   Default_Color        : constant String_Access := null;
   Default_Rgba         : constant String_Access := null;
   Default_Show_Editor  : constant Boolean := True;
   Default_Dialog_Title : constant String_Access := null;
   Default_Use_Alpha    : constant Boolean := True;

   Default_Colorbutton_Block : constant Colorbutton_Block :=
                                 (Default_Button_Block with
                                  Alpha        => Default_Alpha,
                                  Color        => Default_Color,
                                  Rgba         => Default_Rgba,
                                  Show_Editor  => Default_Show_Editor,
                                  Dialog_Title => Default_Dialog_Title,
                                  Use_Alpha    => Default_Use_Alpha);

end G2a.GColorButton;

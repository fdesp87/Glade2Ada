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

with G2a.GWidget;        use G2a.GWidget;
with G2a.GProperty;      use G2a.GProperty;
with G2a.GEnumerations;  use G2a.GEnumerations;

package G2a.GImage is

   type Image_Block is new Widget_Block with record
      Stock_Id         : String_Access;
      Icon_Name        : String_Access;
      Use_Fallback     : Boolean;
      Resource_Name    : String_Access;
      File_Name        : String_Access;
      Icon_Size        : Icon_Size_Enum;
      Pixel_Size       : Integer;
      Xpad             : Integer;
      Ypad             : Integer;
      Xalign           : Float;
      Yalign           : Float;
      With_Xpad        : Boolean;
      With_Ypad        : Boolean;
      With_Xalign      : Boolean;
      With_Yalign      : Boolean;
   end record;

   type Image is access all Image_Block'Class;

   overriding procedure Process_Property (OB : in out Image_Block;
                                          P  : Property);

   procedure Get_New (Img : out Image;
                      ID  : String := "");

   Default_Icon_Size    : constant Icon_Size_Enum := Button_Size;
   Default_Use_Fallback : constant Boolean := False;
   Default_Pixel_Size   : constant Integer := -1;
   Default_Xpad         : constant Integer := 0;
   Default_Ypad         : constant Integer := 0;
   Default_Xalign       : constant Float   := 0.5;
   Default_Yalign       : constant Float   := 0.5;

   Default_Image_Block : constant Image_Block :=
     (Default_Widget_Block with
      Stock_Id         => null,
      Icon_Name        => null,
      Use_Fallback     => Default_Use_Fallback,
      Resource_Name    => null,
      File_Name        => null,
      Icon_Size        => Default_Icon_Size,
      Pixel_Size       => Default_Pixel_Size,
      Xpad             => Default_Xpad,
      Ypad             => Default_Ypad,
      Xalign           => Default_Xalign,
      Yalign           => Default_Yalign,
      With_Xpad        => False,
      With_Ypad        => False,
      With_Xalign      => False,
      With_Yalign      => False
     );

end G2a.GImage;

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

package G2a.GImagemenuitem is

   type Imagemenuitemcontent_Enum is (Stock_Button, Custom_Label_And_Image);

   type Imagemenuitem_Block is new Menuitem_Block with record
      Always_Show_Image            : Boolean;
      Image_Content                : Imagemenuitemcontent_Enum;
      Stock_Item                   : String_Access;
      Label                        : Text_Block;
      The_Image                    : String_Access;
   end record;

   type Imagemenuitem is access all Imagemenuitem_Block'Class;

   procedure Get_New (Mi : out Imagemenuitem;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Imagemenuitem_Block;
                                          P  : Property);

   Default_Always_Show_Image            : constant Boolean := False;
   Default_Image_Content                : constant Imagemenuitemcontent_Enum := Custom_Label_And_Image;

   Default_Imagemenuitem_Block : constant Imagemenuitem_Block :=
      (Default_Menuitem_Block with
       Always_Show_Image            => Default_Always_Show_Image,
       Image_Content                => Default_Image_Content,
       Stock_Item                   => null,
       Label                        => Default_Text_Block,
       The_Image                    => null);

end G2a.GImagemenuitem;

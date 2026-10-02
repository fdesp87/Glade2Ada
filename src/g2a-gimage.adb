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
with G2a.GObject; use G2a.GObject;

package body G2a.GImage is

   procedure Get_New (Img : out Image;
                      ID  : String := "") is
   begin
      Img := new Image_Block'(Default_Image_Block);
      Img.ID := new String'(ID);
      Img.Gtk_Class := Gtk_Image;
      Insert_In_Object_Table (Object (Img));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Image_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Xpad_Property =>
            OB.Xpad := P.Integer_Value;
            OB.With_Xpad := True;
            return;
         when Ypad_Property =>
            OB.Ypad := P.Integer_Value;
            OB.With_Ypad := True;
            return;
         when Xalign_Property =>
            OB.Xalign := P.Decimal_Value;
            OB.With_Xalign := True;
            return;
         when Yalign_Property =>
            OB.Yalign := P.Decimal_Value;
            OB.With_Yalign := True;
            return;
         when Pixel_Size_Property =>
            OB.Pixel_Size := P.Integer_Value;
            return;
         when Use_Fallback_Property =>
            OB.Use_Fallback := P.Boolean_Value;
            return;
         when Icon_Size_Property =>
            OB.Icon_Size := Convert_To_Icon_Size (P.Integer_Value);
            return;
         when Stock_Property =>
            OB.Stock_Id := P.String_Value;
            return;
         when Icon_Name_Property =>
            OB.Icon_Name := P.String_Value;
            return;
         when Resource_Property =>
            OB.Resource_Name := P.String_Value;
            return;
         when Pixbuf_Property =>
            OB.File_Name := P.String_Value;
            return;
         when others => null;
      end case;

      --  call the parent to process parent's properties
      Widget_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GImage;

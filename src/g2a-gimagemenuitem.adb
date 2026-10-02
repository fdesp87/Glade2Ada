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

package body G2a.GImagemenuitem is

   procedure Get_New (Mi : out Imagemenuitem;
                      ID : String := "") is
   begin
      Mi := new Imagemenuitem_Block'(Default_Imagemenuitem_Block);
      Mi.ID := new String'(ID);
      Mi.Gtk_Class := Gtk_Image_Menu_Item;
      Insert_In_Object_Table (Object (Mi));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Imagemenuitem_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Always_Show_Image_Property =>
            OB.Always_Show_Image := P.Boolean_Value;
            return;
         when Label_Property =>
            OB.Label := P.Text;
            return;
         when Use_Stock_Property =>
            OB.Image_Content := Stock_Button;
            OB.Stock_Item := P.String_Value;
            return;
         when Image_Property =>
            OB.Image_Content := Custom_Label_And_Image;
            OB.The_Image := P.String_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Menuitem_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GImagemenuitem;

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

package body G2a.GCellrenderertext is

   procedure Get_New (Cr : out Cellrenderertext;
                      ID : String := "") is
   begin
      Cr := new Cellrenderertext_Block'(Default_Cellrenderertext_Block);
      Cr.ID := new String'(ID);
      Cr.Gtk_Class := Gtk_Cell_Renderer_Text;
      Insert_In_Object_Table (Object (Cr));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Cellrenderertext_Block;
                                          P  : Property) is
   begin
      --  process its properties
      null;

      --  call the parent to process parent's properties
      Cellrenderer_Block (OB).Process_Property (P);
   end Process_Property;

   ----------------------------------------------------------------------
   overriding procedure Process_Attribute (OB : in out Cellrenderertext_Block;
                                           A  : Attribute) is
   begin
      case A.Attr is
         when Text_Columm_Attribute =>
            OB.Text_Columm := A.Integer_Value;
            return;
         when Markup_Column_Attribute =>
            OB.Markup_Column := A.Integer_Value;
            return;
         when Single_Paragraph_Mode_Column_Attribute =>
            OB.Single_Paragraph_Mode_Column := A.Integer_Value;
            return;
         when Width_Chars_Column_Attribute =>
            OB.Width_Chars_Column := A.Integer_Value;
            return;
         when Max_Width_Chars_Attribute =>
            OB.Max_Width_Chars := A.Integer_Value;
            return;
         when Wrap_Width_Mode_Column_Attribute =>
            OB.Wrap_Width_Mode_Column := A.Integer_Value;
            return;
         when Alignment_Column_Attribute =>
            OB.Alignment_Column := A.Integer_Value;
            return;
         when Placeholder_Text_Column_Attribute =>
            OB.Placeholder_Text_Column := A.Integer_Value;
            return;
         when Background_Attribute =>
            OB.Background_Color_Name_Column := A.Integer_Value;
            return;
         when Foreground_Attribute =>
            OB.Foreground_Color_Name_Column := A.Integer_Value;
            return;
         when Background_Color_Mode_Column_Attribute =>
            OB.Background_Color_Mode_Column := A.Integer_Value;
            return;
         when Foreground_Color_Mode_Column_Attribute =>
            OB.Foreground_Color_Mode_Column := A.Integer_Value;
            return;
         when Background_Color_RGBA_Column_Attribute =>
            OB.Background_Color_RGBA_Column := A.Integer_Value;
            return;
         when Foreground_Color_RGBA_Column_Attribute =>
            OB.Foreground_Color_RGBA_Column := A.Integer_Value;
            return;
         when Font_Column_Attribute =>
            OB.Font_Column := A.Integer_Value;
            return;
         when Font_Family_Column_Attribute =>
            OB.Font_Family_Column := A.Integer_Value;
            return;
         when Variant_Attribute =>
            OB.Font_Variant_Column := A.Integer_Value;
            return;
         when Weight_Attribute =>
            OB.Font_Weight_Column := A.Integer_Value;
            return;
         when Stretch_Attribute =>
            OB.Font_Strech_Column := A.Integer_Value;
            return;
         when Size_Attribute =>
            OB.Font_Size_Column := A.Integer_Value;
            return;
         when Font_Points_Column_Attribute =>
            OB.Font_Points_Column := A.Integer_Value;
            return;
            --  Font_Scale_Column_Attribute =>
         when Editable_Column_Attribute =>
            OB.Editable_Column := A.Integer_Value;
            return;
         when Strikethrough_Attribute =>
            OB.Strikethrough_Column := A.Integer_Value;
            return;
         when Underline_Attribute =>
            OB.Underline_Column := A.Integer_Value;
            return;
         when Rise_Column_Attribute =>
            OB.Rise_Column := A.Integer_Value;
            return;
         when Language_Column_Attribute =>
            OB.Language_Column := A.Integer_Value;
            return;
         when Ellipsize_Column_Attribute =>
            OB.Ellipsize_Column := A.Integer_Value;
            return;
         when Wrap_Mode_Column_Attribute =>
            OB.Wrap_Mode_Column := A.Integer_Value;
            return;
         when others => null;
      end case;

      Cellrenderer_Block (OB).Process_Attribute (A);
   end Process_Attribute;

end G2a.GCellrenderertext;

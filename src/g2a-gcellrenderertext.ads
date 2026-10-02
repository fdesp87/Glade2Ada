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

with G2a.GCellrenderer; use G2a.GCellrenderer;
with G2a.GProperty;     use G2a.GProperty;
with G2a.GAttribute;   use G2a.GAttribute;

package G2a.GCellrenderertext is

   type Cellrenderertext_Block is new Cellrenderer_Block with record
      Text_Columm                  : Integer := -1;
      Markup_Column                : Integer := -1;
      Single_Paragraph_Mode_Column : Integer := -1;
      Width_Chars_Column           : Integer := -1;
      Max_Width_Chars              : Integer := -1;
      Wrap_Width_Mode_Column       : Integer := -1;
      Alignment_Column             : Integer := -1;
      Placeholder_Text_Column      : Integer := -1;
      Background_Color_Name_Column : Integer := -1;
      Foreground_Color_Name_Column : Integer := -1;
      Background_Color_Mode_Column : Integer := -1;
      Foreground_Color_Mode_Column : Integer := -1;
      Background_Color_RGBA_Column : Integer := -1;
      Foreground_Color_RGBA_Column : Integer := -1;
      Font_Column                  : Integer := -1;
      Font_Family_Column           : Integer := -1;
      Font_Variant_Column          : Integer := -1;
      Font_Weight_Column           : Integer := -1;
      Font_Strech_Column           : Integer := -1;
      Font_Size_Column             : Integer := -1;
      Font_Points_Column           : Integer := -1;
      Font_Scale_Column            : Integer := -1;
      Editable_Column              : Integer := -1;
      Strikethrough_Column         : Integer := -1;
      Underline_Column             : Integer := -1;
      Rise_Column                  : Integer := -1;
      Language_Column              : Integer := -1;
      Ellipsize_Column             : Integer := -1;
      Wrap_Mode_Column             : Integer := -1;
   end record;

   type Cellrenderertext is access all Cellrenderertext_Block'Class;

   procedure Get_New (Cr : out Cellrenderertext;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Cellrenderertext_Block;
                                          P  : Property);

   overriding procedure Process_Attribute (OB : in out Cellrenderertext_Block;
                                           A  : Attribute);

   Default_Cellrenderertext_Block : constant Cellrenderertext_Block :=
                                      (Default_Cellrenderer_Block with
                                      others => -1);

end G2a.GCellrenderertext;

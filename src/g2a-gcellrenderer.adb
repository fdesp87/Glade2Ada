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

package body G2a.GCellrenderer is

   procedure Get_New (Cr : out Cellrenderer;
                      ID : String := "") is
   begin
      Cr := new Cellrenderer_Block'(Default_Cellrenderer_Block);
      Cr.ID := new String'(ID);
      Cr.Gtk_Class := Gtk_Cell_Renderer_Text;
      Insert_In_Object_Table (Object (Cr));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Cellrenderer_Block;
                                          P  : Property) is
   begin
      --  process its properties

      --  call the parent to process parent's properties
      Object_Block (OB).Process_Property (P);
   end Process_Property;

   ----------------------------------------------------------------------
   procedure Process_Attribute (OB : in out Cellrenderer_Block;
                                A  : Attribute) is
   begin
      case A.Attr is
         when Visible_Column_Attribute =>
            OB.Visible_Column := A.Integer_Value;
         when Sensitive_Column_Attribute =>
            OB.Sensitive_Column := A.Integer_Value;
         when H_Align_Column_Attribute =>
            OB.H_Align_Column := A.Integer_Value;
         when V_Align_Column_Attribute =>
            OB.V_Align_Column := A.Integer_Value;
         when H_Padding_Column_Attribute =>
            OB.H_Padding_Column := A.Integer_Value;
         when V_Padding_Column_Attribute =>
            OB.V_Padding_Column := A.Integer_Value;
         when Width_Column_Attribute =>
            OB.Width_Column := A.Integer_Value;
         when Height_Column_Attribute =>
            OB.Height_Column := A.Integer_Value;
         when Cell_Bg_Color_Name_Column_Attribute =>
            OB.Cell_Bg_Color_Name_Column := A.Integer_Value;
         when Cell_Bg_Color_Attribute =>
            OB.Cell_Bg_Color_Column := A.Integer_Value;
         when Cell_Bg_RGBA_Color_Attribute =>
            OB.Cell_Bg_RGBA_Color_Column := A.Integer_Value;
         when Font_Style_Column_Attribute =>
            OB.Font_Style_Column := A.Integer_Value;
         when others => null;
      end case;
   end Process_Attribute;

end G2a.GCellrenderer;

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

with G2a.GObject;      use G2a.GObject;
with G2a.GAttribute;   use G2a.GAttribute;
with G2a.GProperty;    use G2a.GProperty;

package G2a.GCellrenderer is

   type Cellrenderer_Block is new Object_Block with record
      Attributes                : Attribute_List;
      Visible_Column            : Integer := -1;
      Sensitive_Column          : Integer := -1;
      H_Align_Column            : Integer := -1;
      V_Align_Column            : Integer := -1;
      H_Padding_Column          : Integer := -1;
      V_Padding_Column          : Integer := -1;
      Width_Column              : Integer := -1;
      Height_Column             : Integer := -1;
      Cell_Bg_Color_Name_Column : Integer := -1;
      Cell_Bg_Color_Column      : Integer := -1;
      Cell_Bg_RGBA_Color_Column : Integer := -1;
      Font_Style_Column         : Integer := -1;
   end record;

   type Cellrenderer is access all Cellrenderer_Block'Class;

   procedure Get_New (Cr : out Cellrenderer;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Cellrenderer_Block;
                                          P  : Property);

   procedure Process_Attribute (OB : in out Cellrenderer_Block;
                                A  : Attribute);

   Default_Cellrenderer_Block : constant Cellrenderer_Block :=
                                  (Default_Object_Block with
                                   Attributes => Empty_Attribute_List,
                                   others => -1);

end G2a.GCellrenderer;

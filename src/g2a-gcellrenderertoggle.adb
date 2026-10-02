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

package body G2a.GCellrenderertoggle is

   procedure Get_New (Cr : out Cellrenderertoggle;
                      ID : String := "") is
   begin
      Cr := new Cellrenderertoggle_Block'(Default_Cellrenderertoggle_Block);
      Cr.ID := new String'(ID);
      Cr.Gtk_Class := Gtk_Cell_Renderer_Toggle;
      Insert_In_Object_Table (Object (Cr));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Cellrenderertoggle_Block;
                                          P  : Property) is
   begin
      --  process its properties
      null;

      --  call the parent to process parent's properties
      Cellrenderer_Block (OB).Process_Property (P);
   end Process_Property;

   ----------------------------------------------------------------------
   overriding procedure Process_Attribute (OB : in out Cellrenderertoggle_Block;
                                           A  : Attribute) is
   begin
      case A.Attr is
         when Activatable_Column_Attribute =>
            OB.Activatable_Column := A.Integer_Value;
            return;
         when Toggle_State_Column_Attribute =>
            OB.Toggle_State_Column := A.Integer_Value;
            return;
         when Radio_State_Column_Attribute =>
            OB.Radio_State_Column := A.Integer_Value;
            return;
         when Inconsistent_State_Column_Attribute =>
            OB.Inconsistent_State_Column := A.Integer_Value;
            return;
         when Indicator_Size_Column_Attribute =>
            OB.Indicator_Size_Column := A.Integer_Value;
            return;
         when others => null;
      end case;

      Cellrenderer_Block (OB).Process_Attribute (A);
   end Process_Attribute;

end G2a.GCellrenderertoggle;

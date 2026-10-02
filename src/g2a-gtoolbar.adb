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
with G2a.GObject;       use G2a.GObject;

package body G2a.GToolbar is

   procedure Get_New (Tb : out Toolbar;
                      ID : String := "") is
   begin
      Tb := new Toolbar_Block'(Default_Toolbar_Block);
      Tb.ID := new String'(ID);
      Tb.Gtk_Class := Gtk_ToolBar;
      Insert_In_Object_Table (Object (Tb));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Toolbar_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Toolbar_Style_Property =>
            OB.Use_Tool_Bar_Style := True;
            OB.Toolbar_Style := Convert_To_Toolbar_Enum (P.String_Value.all);
            return;
         when Icon_Size_Property =>
            OB.Use_Icon_Size := True;
            OB.Icon_Size := Convert_To_Icon_Size (P.Integer_Value);
            return;
         when Show_Arrow_Property =>
            OB.Show_Arrow := P.Boolean_Value;
            return;
         when Orientation_Property =>
            OB.Orientation := Convert_To_Orientation (P.String_Value.all);
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Container_Block (OB).Process_Property (P);
   end Process_Property;


end G2a.GToolbar;

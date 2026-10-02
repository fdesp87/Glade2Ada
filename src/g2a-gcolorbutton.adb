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

package body G2a.GColorButton is

   ----------------------------------------------------------------------
   procedure Get_New (But : out Colorbutton;
                      ID  : String := "") is
   begin
      But := new Colorbutton_Block'(Default_Colorbutton_Block);
      But.ID := new String'(ID);
      But.Gtk_Class := Gtk_Color_Button;
      Insert_In_Object_Table (Object (But));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Colorbutton_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Alpha_Property =>
            OB.Alpha := P.Integer_Value;
            return;
         when Color_Property =>
            OB.Color := P.String_Value;
            return;
         when Rgba_Property =>
            OB.Rgba := P.String_Value;
            return;
         when Show_Editor_Property =>
            OB.Show_Editor := P.Boolean_Value;
            return;
         when Title_Property =>
            OB.Dialog_Title := P.String_Value;
            return;
         when Use_Alpha_Property =>
            OB.Use_Alpha := P.Boolean_Value;
            return;
         when others => null;
      end case;

      --  call the parent to process parent's properties
      Button_Block (OB).Process_Property (P);
   end Process_Property;
end G2a.GColorButton;

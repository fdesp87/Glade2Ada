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

package body G2a.GFilechooserbutton is

   ----------------------------------------------------------------------
   procedure Get_New (Fcb : out Filechooserbutton;
                      ID  : String := "") is
   begin
      Fcb := new Filechooserbutton_Block'(Default_Filechooserbutton_Block);
      Fcb.ID := new String'(ID);
      Fcb.Gtk_Class := Gtk_File_Chooser_Button;
      Insert_In_Object_Table (Object (Fcb));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Filechooserbutton_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Title_Property =>
            OB.The_Title := P.Text;
            return;
         when Dialog_Property =>
            OB.The_Dialog := P.String_Value;
            return;
         when Focus_On_Click_Property =>
            OB.Focus_On_Click := P.Boolean_Value;
            return;
         when Width_Chars_Property =>
            OB.Width_In_Characters := P.Integer_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Filechooserdialog_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GFilechooserbutton;

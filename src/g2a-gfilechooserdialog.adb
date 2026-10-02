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

with G2a.GObject;        use G2a.GObject;

package body G2a.GFilechooserdialog is

   ----------------------------------------------------------------------
   procedure Get_New (Fcd : out Filechooserdialog;
                      ID  : String := "") is
   begin
      Fcd := new Filechooserdialog_Block'(Default_Filechooserdialog_Block);
      Fcd.Hint := Dialog_Window;
      Fcd.ID := new String'(ID);
      Fcd.Gtk_Class := Gtk_File_Chooser_Dialog;
      Insert_In_Object_Table (Object (Fcd));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Filechooserdialog_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Action_Property =>
            OB.Action := Convert_To_Action (P.String_Value.all);
            return;
         when Create_Folders_Property =>
            OB.Allow_Folder_Creation := P.Boolean_Value;
            return;
         when Overwrite_Confirmation_Property =>
            OB.Overwrite_Confirmation := P.Boolean_Value;
            return;
         when Filter_Property =>
            OB.Filter := P.String_Value;
            return;
         when Local_Only_Property =>
            OB.Local_Only := P.Boolean_Value;
            return;
         when Use_Preview_Label_Property =>
            OB.Use_Preview_Label := P.Boolean_Value;
            return;
         when Show_Hidden_Property =>
            OB.Show_Hidden := P.Boolean_Value;
            return;
         when Preview_Widget_Active_Property =>
            OB.Preview_Widget_Active := P.Boolean_Value;
            return;
         when Preview_Widget_Property =>
            OB.Preview_Widget := P.String_Value;
            return;
         when Extra_Widget_Property =>
            OB.Extra_Widget := P.String_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Dialog_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GFilechooserdialog;

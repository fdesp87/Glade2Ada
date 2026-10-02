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

package body G2a.GMenuitem is

   procedure Get_New (Mi : out Menuitem;
                      ID : String := "") is
   begin
      Mi := new Menuitem_Block'(Default_Menuitem_Block);
      Mi.ID := new String'(ID);
      Mi.Gtk_Class := Gtk_Menu_Item;
      Insert_In_Object_Table (Object (Mi));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Menuitem_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Right_Justified_Property =>
            OB.Right_Justified := P.Boolean_Value;
            return;
         when Use_Underline_Property =>
            OB.Use_Underline := P.Boolean_Value;
            return;
         when Accel_Path_Property =>
            OB.Accel_Path := P.String_Value;
            return;
         when Label_Property =>
            OB.The_Label := P.Text;
            return;
         when Action_Name_Property =>
            OB.Action.Action_Name := P.String_Value;
            return;
         when Related_Action_Property =>
            OB.Action.Related_Action := P.String_Value;
            return;
         when Use_Action_Appearance_Property =>
            OB.Action.Use_Action_Appearance_Marked := True;
            OB.Action.Use_Action_Appearance := P.Boolean_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Bin_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GMenuitem;

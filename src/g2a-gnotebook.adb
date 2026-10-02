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

package body G2a.GNotebook is

   procedure Get_New (Nb : out Notebook;
                      ID : String := "") is
   begin
      Nb := new Notebook_Block'(Default_Notebook_Block);
      Nb.ID := new String'(ID);
      Nb.Gtk_Class := Gtk_Notebook;
      Insert_In_Object_Table (Object (Nb));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Notebook_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Show_Tabs_Property =>
            OB.Show_Tabs := P.Boolean_Value;
            return;
         when Show_Border_Property =>
            OB.Show_Border := P.Boolean_Value;
            return;
         when Scrollable_Property =>
            OB.Scrollable := P.Boolean_Value;
            return;
         when Enable_Popup_Property =>
            OB.Enable_Popup := P.Boolean_Value;
            return;
         when Group_Name_Property =>
            OB.Group_Name := P.String_Value;
            return;
         when Tab_Position_Property =>
            OB.Tab_Position := Convert_To_Position (P.String_Value.all);
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Container_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GNotebook;

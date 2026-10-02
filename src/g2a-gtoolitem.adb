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

package body G2a.GToolitem is

   procedure Get_New (Ti : out Toolitem;
                      ID : String := "") is
   begin
      Ti := new Toolitem_Block'(Default_Toolitem_Block);
      Ti.ID := new String'(ID);
      Ti.Gtk_Class := Gtk_Tool_Item;
      Insert_In_Object_Table (Object (Ti));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Toolitem_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Draw_Property =>
            OB.Draw := P.Boolean_Value;
            return;
         when Visible_When_Horizontal_Property =>
            OB.Visible_When_Horizontal := P.Boolean_Value;
            return;
         when Visible_When_Vertical_Property =>
            OB.Visible_When_Vertical := P.Boolean_Value;
            return;
         when Is_Important_Property =>
            OB.Is_Important := P.Boolean_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Menuitem_Block (OB).Process_Property (P);
   end Process_Property;


end G2a.GToolitem;

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

package body G2a.GScrolledwindow is

   procedure Get_New (Sw : out Scrolledwindow;
                      ID : String := "") is
   begin
      Sw := new Scrolledwindow_Block'(Default_Scrolledwindow_Block);
      Sw.ID := new String'(ID);
      Sw.Gtk_Class := Gtk_Scrolled_Window;
      Insert_In_Object_Table (Object (Sw));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Scrolledwindow_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Hscrollbar_Policy_Property =>
            OB.H_Scrollbar_Policy := Convert_To_Scrollbar_Policy (P.String_Value.all);
            return;
         when VScrollbar_Policy_Property =>
            OB.V_Scrollbar_Policy := Convert_To_Scrollbar_Policy (P.String_Value.all);
            return;
         when Window_Placement_Property =>
            OB.Window_Placement := Convert_To_Placement (P.String_Value.all);
            return;
         when Window_Placement_Set_Property =>
            OB.Window_Placement_Set := P.Boolean_Value;
            return;
         when Shadow_Type_Property =>
            OB.Shadow := Convert_To_Shadow_Type (P.String_Value.all);
            return;
         when Min_Content_Height_Property =>
            OB.Min_Content_Height := P.Integer_Value;
            return;
         when Min_Content_Width_Property =>
            OB.Min_Content_Width := P.Integer_Value;
            return;
         when Max_Content_Height_Property =>
            OB.Max_Content_Height := P.Integer_Value;
            return;
         when Max_Content_Width_Property =>
            OB.Max_Content_Width := P.Integer_Value;
            return;
         when Kinetic_Scrolling_Property =>
            OB.Kinetic_Scrolling := P.Boolean_Value;
            return;
         when Overlay_Scrolling_Property =>
            OB.Overlay_Scrolling := P.Boolean_Value;
            return;
         when Propagate_Natural_Height_Property =>
            OB.Propagate_Natural_Height := P.Boolean_Value;
            return;
         when Propagate_Natural_Width_Property =>
            OB.Propagate_Natural_Width := P.Boolean_Value;
            return;

         when others => null;
      end case;

      --  call the parent to process parent's properties
      Bin_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GScrolledwindow;

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

package body G2a.GLabel is

   procedure Get_New (Lab : out Label;
                      ID  : String := "") is
   begin
      Lab := new Label_Block'(Default_Label_Block);
      Lab.ID := new String'(ID);
      Lab.Gtk_Class := Gtk_Label;
      Insert_In_Object_Table (Object (Lab));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Label_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Xpad_Property =>
            OB.Xpad := P.Integer_Value;
            OB.With_Xpad := True;
            return;
         when Ypad_Property =>
            OB.Ypad := P.Integer_Value;
            OB.With_Ypad := True;
            return;
         when Label_Property =>
            OB.Text := P.Text;
            return;
         when Use_Underline_Property =>
            OB.Use_Underline := P.Boolean_Value;
            return;
         when Justify_Property =>
            OB.Justification := Convert_To_Justification (P.String_Value.all);
            return;
         when Wrap_Property =>
            OB.Automatic_Wrap := P.Boolean_Value;
            if OB.Automatic_Wrap then
               OB.Wrap_Only_On_New_Line := False;
               OB.Never_Wrap := False;
            end if;
            return;
         when Wrap_Mode_Property =>
            OB.Wrap_Mode := Convert_To_Wrap_Mode (P.String_Value.all);
            return;
         when Selectable_Property =>
            OB.Selectable := P.Boolean_Value;
            return;
         when Pattern_Property =>
            OB.Pattern := P.String_Value;
            return;
         when Mnemonic_Property =>
            OB.Mnemonic_Widget := P.String_Value;
            return;
         when Ellipsize_Property =>
            OB.Ellipsize := Convert_To_Ellipsize (P.String_Value.all);
            return;
         when Width_Chars_Property =>
            OB.Width_In_Characters := P.Integer_Value;
            return;
         when Angle_Property =>
            OB.Angle := P.Decimal_Value;
            return;
         when Max_Width_Chars_Property =>
            OB.Max_Width_In_Characters := P.Integer_Value;
            return;
         when Use_Markup_Property =>
            OB.Use_Markup := P.Boolean_Value;
            return;
         when Track_Links_Property =>
            OB.Track_Visited_Links := P.Boolean_Value;
            return;
         when Lines_Property =>
            OB.Ellipsize_Wrap_Lines := P.Integer_Value;
            return;
         when Xalign_Property =>
            OB.Xalign := P.Decimal_Value;
            OB.With_Xalign := True;
            return;
         when Yalign_Property =>
            OB.Yalign := P.Decimal_Value;
            OB.With_Yalign := True;
            return;
         when others => null;
      end case;

      --  call the parent to process parent's properties
      Misc_Record_Block (OB).Process_Property (P);
   end Process_Property;

   ----------------------------------------------------------------------
   procedure Process_Attribute (OB  : in out Label_Block;
                                Att : Attribute) is
   begin
      null;
   end Process_Attribute;

end G2a.GLabel;

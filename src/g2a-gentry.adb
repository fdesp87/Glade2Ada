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

package body G2a.GEntry is

   ----------------------------------------------------------------------
   procedure Get_New (Ent : out Entry_Ptr;
                      ID  : String := "") is
   begin
      Ent := new Entry_Block'(Default_Entry_Block);
      Ent.ID := new String'(ID);
      Ent.Gtk_Class := Gtk_Entry;
      Insert_In_Object_Table (Object (Ent));
   end Get_New;

   ----------------------------------------------------------------------
   function To_Input_Hints (S : String) return Input_Hints_Array;
   function To_Input_Hints (S : String) return Input_Hints_Array is
      pragma Unreferenced (S);
   begin
      return Default_Inputs_Hint; --  pending
   end To_Input_Hints;

   overriding procedure Process_Property (OB : in out Entry_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Placeholder_Text_Property =>
            OB.Placeholdertext := P.Text;
            return;
         when Text_Property =>
            OB.Text := P.Text;
            return;
         when Buffer_Property =>
            OB.Text_Buffer := P.String_Value;
            return;
         when Editable_Property =>
            OB.Editable := P.Boolean_Value;
            return;
         when Max_Length_Property =>
            OB.Maximun_Length := P.Integer_Value;
            return;
         when Visibility_Property =>
            OB.Visibility := P.Boolean_Value;
            return;
         when Has_Frame_Property =>
            OB.Has_Frame := P.Boolean_Value;
            return;
         when Invisible_Char_Property =>
            OB.Invisible_Character_Flag := P.Boolean_Value;
            OB.Invisible_Character := P.String_Value.all (P.String_Value.all'First);
            return;
         when Activates_Default_Property =>
            OB.Activates_Default := P.Boolean_Value;
            return;
         when Width_Chars_Property =>
            OB.Width_In_Chars := P.Integer_Value;
            return;
         when Max_Width_Chars_Property =>
            OB.Max_Width_In_Characters := P.Integer_Value;
            return;
         when Xalign_Property =>
            OB.H_Alignment := P.Decimal_Value;
            return;
         when Truncate_Multiline_Property =>
            OB.Truncate_Multiline := P.Boolean_Value;
            return;
         when Shadow_Type_Property =>
            OB.Shadow_Type := Convert_To_Shadow_Type (P.String_Value.all);
            return;
         when Overwrite_Mode_Property =>
            OB.Overwrite_Mode := P.Boolean_Value;
            return;
         when Caps_Lock_Warning_Property =>
            OB.Caps_Lock_Warning := P.Boolean_Value;
            return;
         when Progress_Fraction_Property =>
            OB.Progress_Fraction := P.Decimal_Value;
            return;
         when Progress_Pulse_Step_Property =>
            OB.Progress_Pulse_Step := P.Decimal_Value;
            return;
         when Input_Purpose_Property =>
            OB.Input_Purpose := Convert_To_Input_Purpose (P.String_Value.all);
            return;
         when Input_Hints_Property =>
            OB.Inputs_Hint := To_Input_Hints (P.String_Value.all);
            return;
         when Populate_All_Property =>
            OB.Populate_All := P.Boolean_Value;
            return;
         when Show_Emoji_Icon_Property =>
            OB.Emoji_Icon := P.Boolean_Value;
            return;
         when Enable_Emoji_Completion_Property =>
            OB.Enable_Emoji_Completion := P.Boolean_Value;
            return;
         when Primary_Icon_Stock_Property =>
            OB.Primary_Stock_Icon := P.String_Value;
            return;
         when Primary_Icon_Activatable_Property =>
            OB.Primary_Icon_Activatable := P.Boolean_Value;
            return;
         when Primary_Icon_Sensitivity_Property =>
            OB.Primary_Icon_Sensitive := P.Boolean_Value;
            return;
         when Primary_Icon_Name_Property =>
            OB.Primary_Icon_Name := P.String_Value;
            return;
         when Primary_Icon_Pixbuf_Property =>
            OB.Primary_Icon_Pixbuf := P.String_Value;
            return;
         when Primary_Icon_Tooltip_Text =>
            OB.Primary_Icon_Tooltip.Custom_Tooltip     := False;
            OB.Primary_Icon_Tooltip.Use_Markup_Tooltip := False;
            OB.Primary_Icon_Tooltip.Text               := P.Text;
            return;
         when Primary_Icon_Tooltip_Markup =>
            OB.Primary_Icon_Tooltip.Custom_Tooltip     := False;
            OB.Primary_Icon_Tooltip.Use_Markup_Tooltip := True;
            OB.Primary_Icon_Tooltip.Text               := P.Text;
            return;
         when Secondary_Icon_Stock_Property =>
            OB.Secondary_Stock_Icon := P.String_Value;
            return;
         when Secondary_Icon_Activatable_Property =>
            OB.Secondary_Icon_Activatable := P.Boolean_Value;
            return;
         when Secondary_Icon_Sensitivity_Property =>
            OB.Secondary_Icon_Sensitive := P.Boolean_Value;
            return;
         when Secondary_Icon_Name_Property =>
            OB.Secondary_Icon_Name := P.String_Value;
            return;
         when Secondary_Icon_Pixbuf_Property =>
            OB.Secondary_Icon_Pixbuf := P.String_Value;
            return;
         when Secondary_Icon_Tooltip_Text =>
            OB.Secondary_Icon_Tooltip.Custom_Tooltip     := False;
            OB.Secondary_Icon_Tooltip.Use_Markup_Tooltip := False;
            OB.Secondary_Icon_Tooltip.Text               := P.Text;
         when Secondary_Icon_Tooltip_Markup =>
            OB.Secondary_Icon_Tooltip.Custom_Tooltip     := False;
            OB.Secondary_Icon_Tooltip.Use_Markup_Tooltip := True;
            OB.Secondary_Icon_Tooltip.Text               := P.Text;
            return;
         when others => null;
      end case;

      --  call the parent to process parent's properties
      Widget_Block (OB).Process_Property (P);
   end Process_Property;

end G2a.GEntry;

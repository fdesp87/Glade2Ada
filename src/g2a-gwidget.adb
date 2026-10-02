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

package body G2a.GWidget is

   ----------------------------------------------------------------------
   procedure Get_New (Wdg : out Widget;
                      ID  : String := "") is
   begin
      Wdg := new Widget_Block'(Default_Widget_Block);
      Wdg.ID := new String'(ID);
      Wdg.Gtk_Class := Gtk_Widget;
      Insert_In_Object_Table (Object (Wdg));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Widget_Block;
                                          P  : Property) is
   begin
      --  process its properties
      case P.Prop is
         when Name_Property =>
            OB.Name := P.String_Value;
            return;
         when Events_Property =>
            OB.Events := P.String_Value;
            return;
         when Has_Tooltip_Property =>
            OB.Tooltip.Custom_Tooltip := P.Boolean_Value;
            return;
         when Tooltip_Text_Property =>
            OB.Tooltip.Text := P.Text;
            return;
         when Tooltip_Markup_Property =>
            OB.Tooltip.Use_Markup_Tooltip := P.Boolean_Value;
            OB.Tooltip.Text := P.Text;
            return;
         when Width_Request_Property =>
            OB.Width_Requested := True;
            OB.Width_Request := P.Integer_Value;
            return;
         when Height_Request_Property =>
            OB.Height_Requested := True;
            OB.Height_Request := P.Integer_Value;
            return;
         when Halign_Property =>
            OB.H_Align := Convert_To_Alignment (P.String_Value.all);
            return;
         when Valign_Property =>
            OB.V_Align := Convert_To_Alignment (P.String_Value.all);
            return;
         when Margin_Left_Property =>
            OB.Margins (Left_Margin) := P.Integer_Value;
            return;
         when Margin_Right_Property =>
            OB.Margins (Right_Margin) := P.Integer_Value;
            return;
         when Margin_Start_Property =>
            OB.Margins (Start_Margin) := P.Integer_Value;
            return;
         when Margin_End_Property =>
            OB.Margins (End_Margin) := P.Integer_Value;
            return;
         when Margin_Top_Property =>
            OB.Margins (Top_Margin) := P.Integer_Value;
            return;
         when Margin_Bottom_Property =>
            OB.Margins (Bottom_Margin) := P.Integer_Value;
            return;
         when Hexpand_Property =>
            OB.H_Expand := P.Boolean_Value;
            OB.H_Expand_Flag := True;
            return;
         when Vexpand_Property =>
            OB.V_Expand := P.Boolean_Value;
            OB.V_Expand_Flag := True;
            return;
         when Border_Width_Property =>
            OB.Border_Width_Requested := True;
            OB.Border_Width := P.Integer_Value;
            return;
         when Opacity_Property =>
            OB.Opacity := P.Decimal_Value;
            return;
         when Visible_Property =>
            OB.Widget_Flags (Visible) := P.Boolean_Value;
            return;
         when Can_Focus_Property =>
            OB.Widget_Flags (Can_Focus) :=  P.Boolean_Value;
            return;
         when Can_Default_Property =>
            OB.Widget_Flags (Can_Default) :=  P.Boolean_Value;
            return;
         when App_Paintable_Property =>
            OB.Widget_Flags (App_Paintable) :=  P.Boolean_Value;
            return;
         when No_Show_All_Property =>
            OB.Widget_Flags (No_Show_All) :=  P.Boolean_Value;
            return;
         when Has_Focus_Property =>
            OB.Widget_Flags (Has_Focus) :=  P.Boolean_Value;
            return;
         when Has_Default_Property =>
            OB.Widget_Flags (Has_Default) :=  P.Boolean_Value;
            return;
         when Double_Buffered_Property =>
            OB.Widget_Flags (Double_Buffered) :=  P.Boolean_Value;
            return;
         when Sensitive_Property =>
            OB.Widget_Flags (Sensitive) :=  P.Boolean_Value;
            return;
         when Is_Focus_Property =>
            OB.Widget_Flags (Is_Focus) :=  P.Boolean_Value;
            return;
         when Receives_Default_Property =>
            OB.Widget_Flags (Receives_Default) :=  P.Boolean_Value;
            return;
         when others => null;
      end case;

      --  call the parent to process parent's properties
      Object_Block (OB).Process_Property (P);
   end Process_Property;

   ----------------------------------------------------------------------
   function Is_Widget (Obj : not null Object) return Boolean is
   begin
      return Obj.all in Widget_Block'Class;
   end Is_Widget;

   ----------------------------------------------------------------------
   Focus_Chain : Widget := null;
   Last_Chain  : Widget := null;

   procedure Insert_In_Focus_Chain (Wdg : Widget) is
   begin
      if Focus_Chain = null then
         Focus_Chain    := Wdg;
         Last_Chain     := Wdg;
         Wdg.Next_Focus := Focus_Chain;
      else
         Last_Chain.Next_Focus := Wdg;
         Last_Chain := Wdg;
         Wdg.Next_Focus := Focus_Chain;
      end if;
   end Insert_In_Focus_Chain;

end G2a.GWidget;

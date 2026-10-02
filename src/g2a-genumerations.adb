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
with Ada.Text_IO;
with Glade_Scanner_Io;

package body G2a.GEnumerations is

   ---------------------------------------------------------------------------
   --  popover
   function Convert_To_Constrain_To (S : String) return Popover_Constrain_To_Enum is
   begin
      if S = "none" then
         return No_Constrain;
      elsif S = "Window" then
         return Constrain_To_Window;
      else
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Constrain_To;
      end if;
   end Convert_To_Constrain_To;

   ---------------------------------------------------------------------------
   --  popover
   package Popover_Position_Enum_IO is new Ada.Text_IO.Enumeration_IO (Popover_Position_Enum);
   function Convert_To_Popover_Position (S : String) return Popover_Position_Enum is
      H : Popover_Position_Enum;
      L : Positive;
   begin
      Popover_Position_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Popover_Position;
   end Convert_To_Popover_Position;

   ----------------------------------------------------------------------
   --  combobox
   function Convert_To_Button_Sensitivity (S : String) return Button_Sensitivity_Enum is
   begin
      if S = "automatic" then
         return Automatic;
      elsif S = "on" then
         return On;
      elsif S = "off" then
         return Off;
      else
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Button_Sensitivity;
      end if;
   end Convert_To_Button_Sensitivity;

   ----------------------------------------------------------------------
   --  Menubar
   function Convert_To_Pack_Direction (S : String) return Pack_Direction_Enum is
   begin
      if S = "rtl" then
         return Right_To_Left;
      elsif S = "btt" then
         return Bottom_To_Top;
      elsif S = "ttb" then
         return Top_To_Bottom;
      elsif S = "ltr" then
         return Left_To_Right;
      else
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Pack_Direction;
      end if;
   end Convert_To_Pack_Direction;

   ----------------------------------------------------------------------
   --  filechooserdialog
   function Convert_To_Action (S : String) return Action_Enum is
   begin
      if S = "select-folder" then
         return Select_Folder;
      elsif S = "open-folder" then
         return Open_File;
      else
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Action;
      end if;
   end Convert_To_Action;

   ----------------------------------------------------------------------
   --  treeview
   package Enable_Grid_Lines_Enum_IO is new Ada.Text_IO.Enumeration_IO (Enable_Grid_Lines_Enum);
   function Convert_To_Enable_Grid_Lines (S : String) return Enable_Grid_Lines_Enum is
      H : Enable_Grid_Lines_Enum;
      L : Positive;
   begin
      Enable_Grid_Lines_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Enable_Grid_Lines;
   end Convert_To_Enable_Grid_Lines;

   ----------------------------------------------------------------------
   --  treeview
   function Convert_To_Treeview_Scrolling_Policy (S : String) return Treeview_Scrolling_Policy_Enum is
   begin
      if S = "natural" then
         return Natural_Scroll;
      elsif S = "minimum" then
         return Minimum_Scroll;
      else
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Treeview_Scrolling_Policy;
      end if;
   end Convert_To_Treeview_Scrolling_Policy;

   ----------------------------------------------------------------------
   --  scrolledwindow
   function Convert_To_Placement (S : String) return Scrolledwindow_Placement_Enum is
   begin
      if S = "top-left" then
         return Top_Left;
      elsif S = "bottom-left" then
         return Bottom_Left;
      elsif S = "top-right" then
         return Top_Right;
      elsif S = "bottom-right" then
         return Bottom_Right;
      else
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Window_Placement;
      end if;
   end Convert_To_Placement;

   ----------------------------------------------------------------------
   --  scrolledwindow
   package Scrollbar_Policy_Enum_IO is new
     Ada.Text_IO.Enumeration_IO (Scrollbar_Policy_Enum);
   function Convert_To_Scrollbar_Policy (S : String) return Scrollbar_Policy_Enum is
      H : Scrollbar_Policy_Enum;
      L : Positive;
   begin
      Scrollbar_Policy_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Scrollbar_Policy;
   end Convert_To_Scrollbar_Policy;

   ----------------------------------------------------------------------
   --  entry
   package Input_Purpose_Enum_IO is new Ada.Text_IO.Enumeration_IO (Input_Purpose_Enum);
   function Convert_To_Input_Purpose (S : String) return Input_Purpose_Enum is
      H : Input_Purpose_Enum;
      L : Positive;
   begin
      if S = "free-form" then
         return Free_Form;
      elsif S = "digits" or else S = "only-digits" then
         return Only_Digits;
      end if;
      Input_Purpose_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Input_Purpose;
   end Convert_To_Input_Purpose;

   ----------------------------------------------------------------------
   --  buttonbox
   package Layout_Style_Enum_IO is new Ada.Text_IO.Enumeration_IO (Layout_Style_Enum);
   function Convert_To_Layout_Style (S : String) return Layout_Style_Enum is
      H : Layout_Style_Enum;
      L : Positive;
   begin
      if S = "end" then
         return To_End;
      end if;
      Layout_Style_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Layout_Style;
   end Convert_To_Layout_Style;

   ----------------------------------------------------------------------
   --  box
   package Baseline_Position_Enum_IO is new Ada.Text_IO.Enumeration_IO (Baseline_Position_Enum);
   function Convert_To_Baseline (S : String) return Baseline_Position_Enum is
      H : Baseline_Position_Enum;
      L : Positive;
   begin
      Baseline_Position_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Baseline_Position;
   end Convert_To_Baseline;

   ----------------------------------------------------------------------
   --  label
   package Ellipsize_Enum_IO is new Ada.Text_IO.Enumeration_IO (Ellipsize_Enum);
   function Convert_To_Ellipsize (S : String) return Ellipsize_Enum is
      H : Ellipsize_Enum;
      L : Positive;
   begin
      if S = "end" then
         return End_Direction;
      end if;
      Ellipsize_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Ellipsize;
   end Convert_To_Ellipsize;

   ----------------------------------------------------------------------
   --  label
   package Justification_Enum_IO is new Ada.Text_IO.Enumeration_IO (Justification_Enum);
   function Convert_To_Justification (S : String) return Justification_Enum is
      H : Justification_Enum;
      L : Positive;
   begin
      Justification_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Justification;
   end Convert_To_Justification;

   ----------------------------------------------------------------------
   --  label
   package Wrap_Mode_Enum_IO is new Ada.Text_IO.Enumeration_IO (Wrap_Mode_Enum);
   function Convert_To_Wrap_Mode (S : String) return Wrap_Mode_Enum is
      H : Wrap_Mode_Enum;
      L : Positive;
   begin
      if S = "word-char" then
         return Sentence_Wrap;
      end if;
      Wrap_Mode_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Wrap_Mode;
   end Convert_To_Wrap_Mode;

   ----------------------------------------------------------------------
   --  widget
   package Alignment_Enum_IO is new Ada.Text_IO.Enumeration_IO (Alignment_Enum);
   function Convert_To_Alignment (S : String) return Alignment_Enum is
      H : Alignment_Enum;
      L : Positive;
   begin
      if S = "end" then
         return End_Align;
      end if;
      Alignment_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Alignment;
   end Convert_To_Alignment;

   ----------------------------------------------------------------------
   --  window
   package Window_Position_Enum_IO is
     new Ada.Text_IO.Enumeration_IO (Window_Position_Enum);
   function Convert_To_Window_Position (S : String) return Window_Position_Enum is
      H : Window_Position_Enum;
      L : Positive;
   begin
      if S = "center-on_parent" then
         return Center_On_Parent;
      elsif S = "center-always" then
         return Always_Center;
      end if;
      Window_Position_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Window_Position;
   end Convert_To_Window_Position;

   ----------------------------------------------------------------------
   --  window
   package Window_Gravity_Enum_IO is
     new Ada.Text_IO.Enumeration_IO (Window_Gravity_Enum);
   function Convert_To_Window_Gravity (S : String) return Window_Gravity_Enum is
      H : Window_Gravity_Enum;
      L : Positive;
   begin
      if S = "north-east" then
         return North_East;
      elsif S = "nort-west" then
         return North_West;
      elsif S = "south-east" then
         return South_East;
      elsif S = "south-west" then
         return South_West;
      end if;
      Window_Gravity_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Window_Gravity;
   end Convert_To_Window_Gravity;

   ---------------------------------------------------------------------------
   --  treeselection
   package Selection_Mode_Enum_IO is new Ada.Text_IO.Enumeration_IO (Selection_Mode_Enum);
   function Convert_To_Selection_Mode (S : String) return Selection_Mode_Enum is
      H : Selection_Mode_Enum;
      L : Positive;
   begin
      Selection_Mode_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Selection_Mode;
   end Convert_To_Selection_Mode;

   ---------------------------------------------------------------------------
   --  frame, scrolled_window
   function Convert_To_Shadow_Type (S : String) return Shadow_Type_Enum is
   begin
      if S = "etched-out" then
         return Etched_Out;
      elsif S = "etched-in" then
         return Etched_In;
      elsif S = "in" then
         return In_Shadow;
      elsif S = "out" then
         return Out_Shadow;
      else
         Ada.Text_IO.Put_Line ("Line"
                               & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Shadow_Type;
      end if;
   end Convert_To_Shadow_Type;

   ---------------------------------------------------------------------------
   --  window, menu
   package Hint_Enum_IO is new Ada.Text_IO.Enumeration_IO (Hint_Enum);
   function Convert_To_Hint (S : String) return Hint_Enum is
      H : Hint_Enum;
      L : Positive;
   begin
      if S = "dropdown-menu" then
         return Drop_Down_Menu;
      elsif S = "dnd" then
         return Drag_And_Drop;
      elsif S = "splashscreen" then
         return Splash_Screen;
      elsif S = "toolbar" then
         return Toolbar_Hint;
      elsif S = "menu" then
         return Menu_Hint;
      elsif S = "dialog" then
         return Dialog_Window;
      elsif S = "popup-menu" then
         return Popup_Menu;
      end if;
      Hint_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Hint;
   end Convert_To_Hint;

   ---------------------------------------------------------------------------
   --  image, toolbar
   function Convert_To_Icon_Size (S : Integer) return Icon_Size_Enum is
   begin
      return Icon_Size_Enum'Val (S);
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S'Image);
         return Default_Icon_Size;
   end Convert_To_Icon_Size;

   ---------------------------------------------------------------------------
   --  toolbar, spinbutton
   package Orientation_Enum_IO is new Ada.Text_IO.Enumeration_IO (Orientation_Enum);
   function Convert_To_Orientation (S : String) return Orientation_Enum is
      H : Orientation_Enum;
      L : Positive;
   begin
      Orientation_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Orientation;
   end Convert_To_Orientation;

   ---------------------------------------------------------------------------
   --  notebook
   package Position_Enum_IO is new Ada.Text_IO.Enumeration_IO (Position_Enum);
   function Convert_To_Position (S : String) return Position_Enum is
      H : Position_Enum;
      L : Positive;
   begin
      Position_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Position;
   end Convert_To_Position;

   ---------------------------------------------------------------------------
   --  button
   package Border_Relief_Enum_IO is
     new Ada.Text_IO.Enumeration_IO (Border_Relief_Enum);
   function Convert_To_Border_Relief (S : String) return Border_Relief_Enum is
      H : Border_Relief_Enum;
      L : Positive;
   begin
      Border_Relief_Enum_IO.Get (S, H, L);
      return H;
   exception
      when Ada.Text_IO.Data_Error =>
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Border_Relief;
   end Convert_To_Border_Relief;

   ---------------------------------------------------------------------------
   --  spinbutton
   function Convert_To_Update_Policy (S : String) return Update_Policy_Enum is
   begin
      if S = "if-valid" then
         return If_Valid;
      elsif S = "always" then
         return Default_Update_Policy;
      else
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown enumeration component " & S);
         return Default_Update_Policy;
      end if;
   end Convert_To_Update_Policy;

   ---------------------------------------------------------------------------
   --  toolbar
   function Convert_To_Toolbar_Enum (S : String) return Toolbar_Enum is
   begin
      if S = "both" then
         return Text_Below_Icons;
      elsif S = "icons" then
         return Icons_Only;
      elsif S = "text" then
         return Text_Only;
      elsif S = "both-horiz" then
         return Text_Below_Icons;
      end if;
      raise Program_Error;
   end Convert_To_Toolbar_Enum;

end G2a.GEnumerations;

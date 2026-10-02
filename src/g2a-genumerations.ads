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

package G2a.GEnumerations is

   --  popover
   type Popover_Constrain_To_Enum is (No_Constrain, Constrain_To_Window);
   Default_Constrain_To : constant Popover_Constrain_To_Enum := Constrain_To_Window;
   function Convert_To_Constrain_To (S : String) return Popover_Constrain_To_Enum;

   --  popover
   type Popover_Position_Enum is (Left, Right, Top, Bottom);
   function Convert_To_Popover_Position (S : String) return Popover_Position_Enum;
   Default_Popover_Position : Popover_Position_Enum := Top;

   --  combobox
   type Button_Sensitivity_Enum is (Automatic, On, Off);
   Default_Button_Sensitivity : constant Button_Sensitivity_Enum := Automatic;
   function Convert_To_Button_Sensitivity (S : String) return Button_Sensitivity_Enum;

   --  Menubar
   type Pack_Direction_Enum is (Left_To_Right, Right_To_Left,
                                Top_To_Bottom, Bottom_To_Top);
   Default_Pack_Direction : constant Pack_Direction_Enum := Left_To_Right;
   function Convert_To_Pack_Direction (S : String) return Pack_Direction_Enum;

   --  filechooserdialog
   type Action_Enum is (Open_File, Select_Folder);
   Default_Action  : constant Action_Enum := Open_File;
   function Convert_To_Action (S : String) return Action_Enum;

   --  treeview
   type Enable_Grid_Lines_Enum is (None, Horizontal, Vertical, Both);
   Default_Enable_Grid_Lines : constant Enable_Grid_Lines_Enum := None;
   function Convert_To_Enable_Grid_Lines (S : String) return Enable_Grid_Lines_Enum;

   --  treeview
   type Treeview_Scrolling_Policy_Enum is (Minimum_Scroll, Natural_Scroll);
   Default_Treeview_Scrolling_Policy : constant Treeview_Scrolling_Policy_Enum := Minimum_Scroll;
   function Convert_To_Treeview_Scrolling_Policy (S : String) return Treeview_Scrolling_Policy_Enum;

   --  scrolledwindow
   type Scrolledwindow_Placement_Enum is (Top_Left, Bottom_Left,
                                          Top_Right, Bottom_Right);
   Default_Window_Placement : constant Scrolledwindow_Placement_Enum := Top_Left;
   function Convert_To_Placement (S : String) return Scrolledwindow_Placement_Enum;

   --  scrolledwindow
   type Scrollbar_Policy_Enum is (Always, Automatic, Never, External);
   Default_Scrollbar_Policy : constant Scrollbar_Policy_Enum := Automatic;
   function Convert_To_Scrollbar_Policy (S : String) return Scrollbar_Policy_Enum;

   --  entry
   type Input_Purpose_Enum is (Free_Form, Alpha, Only_Digits, Number, Phone,
                               URL, Email, Name, Password, Pin, Terminal);
   Default_Input_Purpose : constant Input_Purpose_Enum := Free_Form;
   function Convert_To_Input_Purpose (S : String) return Input_Purpose_Enum;

   --  buttonbox
   type Layout_Style_Enum is (Spread, Edge, Start, To_End, Center, Span);
   Default_Layout_Style : constant Layout_Style_Enum := Edge;
   function Convert_To_Layout_Style (S : String) return Layout_Style_Enum;

   --  box
   type Baseline_Position_Enum is (Top, Center, Bottom);
   Default_Baseline_Position : Baseline_Position_Enum := Center;
   function Convert_To_Baseline (S : String) return Baseline_Position_Enum;

   --  label
   type Ellipsize_Enum is (None, Start, Middle, End_Direction);
   Default_Ellipsize : constant Ellipsize_Enum := None;
   function Convert_To_Ellipsize (S : String) return Ellipsize_Enum;

   --  label
   type Justification_Enum is (Left, Right, Center, Fill);
   Default_Justification : constant Justification_Enum := Left;
   function Convert_To_Justification (S : String) return Justification_Enum;

   --  label
   type Wrap_Mode_Enum is (Word_Wrap, Char_Wrap, Sentence_Wrap);
   Default_Wrap_Mode : constant Wrap_Mode_Enum := Word_Wrap;
   function Convert_To_Wrap_Mode (S : String) return Wrap_Mode_Enum;

   --  widget
   type Alignment_Enum is (Fill, Start, End_Align, Center, Baseline);
   Default_Alignment : constant Alignment_Enum := Fill;
   function Convert_To_Alignment (S : String) return Alignment_Enum;

   --  window
   type Window_Position_Enum is (None, Center, Mouse,
                                 Always_Center, Center_On_Parent);
   Default_Window_Position : constant Window_Position_Enum := None;
   function Convert_To_Window_Position (S : String) return Window_Position_Enum;

   --  window
   type Window_Gravity_Enum is (North_West, North, North_East,
                                West, Center, East,
                                South_West, South, South_East,
                                Static);
   Default_Window_Gravity : constant Window_Gravity_Enum := North_West;
   function Convert_To_Window_Gravity (S : String) return Window_Gravity_Enum;

   --  treeselection
   type Selection_Mode_Enum is (None, Single, Browse, Multiple);
   function Convert_To_Selection_Mode (S : String) return Selection_Mode_Enum;
   Default_Selection_Mode : constant Selection_Mode_Enum := Single;

   --  frame, scrolled_window
   type Shadow_Type_Enum is (None,
                             In_Shadow, Out_Shadow,
                             Etched_In, Etched_Out);
   function Convert_To_Shadow_Type (S : String) return Shadow_Type_Enum;
   Default_Shadow_Type : constant Shadow_Type_Enum := Etched_In;

   --  window, menu
   type Hint_Enum is (Normal, Dialog_Window, Menu_Hint,
                      Toolbar_Hint, Splash_Screen,
                      Utility, Dock, Desktop, Drop_Down_Menu, Popup_Menu,
                      Tooltip, Notification, Combo, Drag_And_Drop);
   function Convert_To_Hint (S : String) return Hint_Enum;
   Default_Hint : constant Hint_Enum := Normal;

   --  image, toolbar
   type Icon_Size_Enum is (Invalid, Menu_Size, Small_Toolbar, Large_Toolbar,
                           Button_Size, Drag_And_Drop, Dialog_Size);
   function Convert_To_Icon_Size (S : Integer) return Icon_Size_Enum;
   Default_Icon_Size : constant Icon_Size_Enum := Button_Size;

   --  toolbar, spinbutton
   type Orientation_Enum is (Horizontal, Vertical);
   function Convert_To_Orientation (S : String) return Orientation_Enum;
   Default_Orientation : constant Orientation_Enum := Horizontal;

   --  notebook
   type Position_Enum is (Left, Right, Top, Bottom);
   function Convert_To_Position (S : String) return Position_Enum;
   Default_Position : Position_Enum := Left;

   --  button
   type Border_Relief_Enum is (Normal, Half, None);
   function Convert_To_Border_Relief (S : String) return Border_Relief_Enum;
   Default_Border_Relief : Border_Relief_Enum := Normal;

   --  spinbutton
   type Update_Policy_Enum is (Always, If_Valid);
   function Convert_To_Update_Policy (S : String) return Update_Policy_Enum;
   Default_Update_Policy : Update_Policy_Enum := Always;

   --  toolbar
   type Toolbar_Enum is (Icons_Only, Text_Only,
                         Text_Below_Icons, Text_Beside_Icons);
   function Convert_To_Toolbar_Enum (S : String) return Toolbar_Enum;
   Default_Toolbar_Style : constant Toolbar_Enum := Icons_Only;

end G2a.GEnumerations;

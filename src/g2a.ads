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
with Ada.Containers.Vectors;
with GNAT.Strings; use GNAT.Strings;
with Ada.Unchecked_Deallocation;
with Ada.Text_IO;

package G2a is

   pragma Elaborate_Body;

   Produce_Log         : Boolean := False;
   Produce_Tree        : Boolean := False;
   Produce_Signals     : Boolean := False;
   Produce_Attributes  : Boolean := False;
   Produce_Items       : Boolean := False;
   Produce_Properties  : Boolean := False;
   Produce_Main        : Boolean := False;
   Ada_Dir             : String_Access := null;
   Lex_Full_Filename   : String_Access := null;
   Log_File            : Ada.Text_IO.File_Type;
   Dump_File           : Ada.Text_IO.File_Type;
   Glade_Full_FileName : String_Access := null;

   type GTK_Enum is
     (No_Node,              Gtk_Object,              Gtk_Widget,
      Gtk_Miscelaneous,     Gtk_Container,           Gtk_Bin,

      --  top level
      Gtk_Window,            Gtk_Dialog,             Gtk_File_Chooser_Dialog,
      Gtk_File_Filter,       Gtk_Entry_Buffer,       Gtk_List_Store,
      Gtk_Tree_Store,        Gtk_Tree_Model,         Gtk_Tree_Model_Sort,
      Gtk_Tree_Model_Filter, Gtk_Image,              Gtk_Adjustment,

      --  Containers
      Gtk_Action_Bar,      Gtk_Action,
      Gtk_Alignment,       Gtk_Aspect_Frame,         Gtk_Grid,
      Gtk_Box,             Gtk_Button_Box,           Gtk_Combo_Box,
      Gtk_Expander,        Gtk_Event_Box,            Gtk_Fixed,
      Gtk_Flow_Box,        Gtk_Frame,                Gtk_Header_Bar,
      Gtk_Layout,          Gtk_List_Box,             Gtk_Menu_Bar,
      Gtk_Notebook,        Gtk_Overlay,              Gtk_Paned,
      Gtk_Popover,         Gtk_Popover_Menu,         Gtk_Revealer,
      Gtk_Scrolled_Window, Gtk_Search_Bar,           Gtk_Separator_Tool_Item,
      Gtk_Stack,           Gtk_Status_Bar,           Gtk_ToolBar,
      Gtk_Tool_Item,       Gtk_Tool_Palette,         Gtk_Viewport,

      --  controls
      Gtk_Button,          Gtk_Check_Button,         Gtk_Color_Button,
      Gtk_Combo_Box_Text,  Gtk_Entry,           Gtk_File_Chooser_Button,
      Gtk_Radio_Button,    Gtk_Spin_Button,          Gtk_Toggle_Button,

      --  display
      Gtk_Calendar,        Gtk_Label,                 Gtk_Tree_View,

      --  menu
      Gtk_Menu,            Gtk_Menu_Image_Item,       Gtk_Menu_Item,
      Gtk_Image_Menu_Item, Gtk_Menu_Normal_Item,      Gtk_Menu_Shell,
      Gtk_Submenu,         Gtk_Separator_Menu_Item,

      --  auxiliary
      Gtk_Cell_Renderer,   Gtk_Cell_Renderer_Text,    Gtk_Cell_Renderer_Toggle,
      Gtk_NotebookTabPage, Gtk_TabChild,              Gtk_Accel_Group,
      Gtk_Tree_Selection,  Gtk_Tree_View_Column,

      --  for dialogs
      Internal_Child_VBox, Internal_Child_Action_Area, Action_Widgets,

      --  Ada widgets
      Ada_Date_Picker,     Ada_Time_Picker);

   --  properties
   type Property_Flavor_Enum is (Unknown_Flavor, Is_Gtk3_Enum,
                                 Is_String, Is_Identifier, Is_Boolean,
                                 Is_Integer, Is_Decimal);

   type Property_Enum is
     (Unknown_Property,
      Accel_Group_Property,
      Accel_Path_Property,
      Accept_Focus_Property,
      Action_Property,
      Action_Name_Property,
      Activates_Default_Property,
      Activate_On_Single_Click_Property,
      Active_Property,
      Active_ID_Property,
      Add_Tearoffs_Property,
      Adjustment_Property,
      Alpha_Property,
      Alignment_Property,
      Always_Show_Image_Property,
      Angle_Property,
      App_Paintable_Property,
      Attached_To_Property,
      Baseline_Position_Property,
      Baseline_Row_Property,
      Border_Width_Property,
      Bottom_Padding_Property,
      Browse_Property,
      Buffer_Property,
      Button_Sensitivity_Property,
      Can_Default_Property,
      Can_Focus_Property,
      Caps_Lock_Warning_Property,
      Child_Pack_Direction_Property,
      Child_Model_Property,
      Clickable_Property,
      Climb_Rate_Property,
      Color_Property,
      Column_Spacing_Property,
      Column_Span_Column_Property,
      Column_Homogeneous_Property,
      Constrain_To_Property,
      Create_Folders_Property,
      Day_Property,
      Decorated_Property,
      Deletable_Property,
      Default_Width_Property,
      Default_Height_Property,
      Destroy_With_Parent_Property,
      Detail_Height_Rows,
      Detail_Width_Chars,
      Dialog_Property,
      Double_Buffered_Property,
      Draw_Property,
      Draw_Indicator_Property,
      Editable_Property,
      Ellipsize_Property,
      Enable_Emoji_Completion_Property,
      Enable_Grid_Lines_Property,
      Enable_Popup_Property,
      Entry_Text_Column_Property,
      Events_Property,
      Expand_Property,
      Expander_Column_Property,
      Extra_Widget_Property,
      Fill_Property,
      Filter_Property,
      Fixed_Height_Mode_Property,
      Fixed_Width_Property,
      Focus_On_Click_Property,
      Focus_On_Map_Property,
      Gravity_Property,
      Group_Property,
      Group_Name_Property,
      Hadjustment_Property,
      Halign_Property,
      Has_Default_Property,
      Has_Entry_Property,
      Has_Focus_Property,
      Has_Frame_Property,
      Has_Resize_Grip_Property,
      Has_Tooltip_Property,
      Hscrollbar_Policy_Property,
      HScroll_Policy_Property,
      Height_Property,
      Height_Request_Property,
      Hexpand_Property,
      Hide_If_Empty_Property,
      Hide_Titlebar_When_Maximized_Property,
      Homogeneous_Property,
      Icon_File_Property,
      Icon_Size_Property,
      Icon_Name_Property,
      Id_Column_Property,
      Image_Property,
      Image_Position_Property,
      Inconsistent_Property,
      Input_Hints_Property,
      Input_Purpose_Property,
      Invisible_Char_Property,
      Is_Focus_Property,
      Is_Important_Property,
      Justify_Property,
      Kinetic_Scrolling_Property,
      Label_Property,
      Label_Xalign_Property,
      Label_Yalign_Property,
      Layout_Style_Property,
      Left_Attach_Property,
      Left_Padding_Property,
      Level_Indentation_Property,
      Lines_Property,
      Local_Only_Property,
      Lower_Property,
      Margin_Left_Property,
      Margin_Right_Property,
      Margin_Start_Property,
      Margin_End_Property,
      Margin_Top_Property,
      Margin_Bottom_Property,
      Max_Content_Height_Property,
      Max_Content_Width_Property,
      Max_Date_Property,
      Max_Length_Property,
      Max_Width_Chars_Property,
      Max_Width_Property,
      Menu_Type_Hint_Property,
      Min_Content_Height_Property,
      Min_Content_Width_Property,
      Min_Date_Property,
      Min_Width_Property,
      Mnemonic_Property,
      Modal_Property,
      Mode_Property,
      Model_Property,
      Month_Property,
      Name_Property,
      No_Month_Change_Property,
      No_Show_All_Property,
      Non_Homogeneous_Property,
      Numeric_Property,
      Obey_Child_Property,
      Opacity_Property,
      Orientation_Property,
      Overlay_Scrolling_Property,
      Overwrite_Confirmation_Property,
      Overwrite_Mode_Property,
      Pack_Type_Property,
      Pack_Direction_Property,
      Padding_Property,
      Page_Increment_Property,
      Page_Size_Property,
      Pattern_Property,
      Placeholder_Text_Property,
      Pixbuf_Property,
      Pixel_Size_Property,
      Popup_Fixed_Width_Property,
      Populate_All_Property,
      Position_Property,
      Preview_Widget_Property,
      Preview_Widget_Active_Property,
      Primary_Icon_Activatable_Property,
      Primary_Icon_Name_Property,
      Primary_Icon_Pixbuf_Property,
      Primary_Icon_Sensitivity_Property,
      Primary_Icon_Stock_Property,
      Primary_Icon_Tooltip_Markup,
      Primary_Icon_Tooltip_Text,
      Progress_Fraction_Property,
      Progress_Pulse_Step_Property,
      Propagate_Natural_Width_Property,
      Propagate_Natural_Height_Property,
      Ratio_Property,
      Receives_Default_Property,
      Rect_Anchor_Dx_Property,
      Rect_Anchor_Dy_Property,
      Related_Action_Property,
      Relative_To_Property,
      Relief_Property,
      Reserve_Toggle_Size_Property,
      Resizable_Property,
      Resource_Property,
      Reorderable_Property,
      Rgba_Property,
      Right_Justified_Property,
      Right_Padding_Property,
      Role_Property,
      Row_Span_Column_Property,
      Row_Spacing_Property,
      Row_Homogeneous_Property,
      Rubber_Banding_Property,
      Rules_Hint_Property,
      Scrollable_Property,
      Secondary_Property,
      Secondary_Icon_Activatable_Property,
      Secondary_Icon_Name_Property,
      Secondary_Icon_Pixbuf_Property,
      Secondary_Icon_Sensitivity_Property,
      Secondary_Icon_Stock_Property,
      Secondary_Icon_Tooltip_Markup,
      Secondary_Icon_Tooltip_Text,
      Selectable_Property,
      Sensitive_Property,
      Shadow_Type_Property,
      Short_Label_Property,
      Show_Arrow_Property,
      Show_Border_Property,
      Show_Day_Names_Property,
      Show_Details_Property,
      Show_Editor_Property,
      Show_Emoji_Icon_Property,
      Show_Heading_Property,
      Show_Hidden_Property,
      Show_Tabs_Property,
      Show_Week_Numbers_Property,
      Sizing_Property,
      Skip_Pager_Hint_Property,
      Skip_Taskbar_Hint_Property,
      Snap_To_Ticks_Property,
      Sort_Column_Id_Property,
      Sort_Indicator_Property,
      Sort_Order_Property,
      Spacing_Property,
      Startup_ID_Property,
      Step_Increment_Property,
      Stock_Property,
      Stock_ID_Property,
      Tab_Fill_Property,
      Tab_Position_Property,
      Take_Focus_Property,
      Tearoff_Title_Property,
      Tearoff_State_Property,
      Text_Property,
      The_Digits_Property,
      Time_Zone_Property,
      Title_Property,
      Toolbar_Style_Property,
      Tooltip_Property,
      Tooltip_Markup_Property,
      Tooltip_Text_Property,
      Top_Attach_Property,
      Top_Padding_Property,
      Track_Links_Property,
      Transient_For_Property,
      Transitions_Enabled_Property,
      Truncate_Multiline_Property,
      Type_Property,
      Type_Hint_Property,
      Ubuntu_Almost_Fixed_Height_Mode_Property,
      Update_Policy_Property,
      Upper_Property,
      Urgency_Hint_Property,
      Use_Alpha_Property,
      Use_Action_Appearance_Property,
      Use_Fallback_Property,
      Use_Markup_Property,
      Use_Preview_Label_Property,
      Use_Stock_Property,
      Use_Underline_Property,
      Vadjustment_Property,
      Valign_Property,
      Value_Property,
      Vexpand_Property,
      Visibility_Property,
      Visible_Property,
      Visible_When_Horizontal_Property,
      Visible_When_Vertical_Property,
      Visible_Overflown_Property,
      VScrollbar_Policy_Property,
      VScroll_Policy_Property,
      Wrap_Property,
      Wrap_Mode_Property,
      Wrap_Width_Property,
      Width_Chars_Property,
      Width_Property,
      Width_Request_Property,
      Window_Placement_Set_Property,
      Window_Placement_Property,
      Window_Position_Property,
      X_Property,
      Xalign_Property,
      Xscale_Property,
      Xpad_Property,
      Yalign_Property,
      Year_Property,
      Ypad_Property,
      Yscale_Property,
      Y_Property);

   --  attibutes
   type Attribute_Flavor_Enum is (Unknown_Flavor, Is_String, Is_Integer);

   type Attribute_Enum is
     (Unknown_Attribute,
      --  label
      Font_Desc_Attribute,
      Style_Attribute,
      Weight_Attribute,
      Variant_Attribute,
      Stretch_Attribute,
      Scale_Attribute,
      Underline_Attribute,
      Strikethrough_Attribute,
      Foreground_Attribute,
      Background_Attribute,
      Underline_Color_Attribute,
      Strikethrough_Color_Attribute,
      Gravity_Attribute,
      Gravity_Hint_Attribute,
      Size_Attribute,
      Absolute_Size_Attribute,
      --  cellrenderer
      Visible_Column_Attribute,
      Sensitive_Column_Attribute,
      H_Align_Column_Attribute,
      V_Align_Column_Attribute,
      H_Padding_Column_Attribute,
      V_Padding_Column_Attribute,
      Width_Column_Attribute,
      Height_Column_Attribute,
      Cell_Bg_Color_Name_Column_Attribute,
      Cell_Bg_Color_Attribute,
      Cell_Bg_RGBA_Color_Attribute,
      Font_Style_Column_Attribute,

      --  cellrenderertext
      Text_Columm_Attribute,
      Markup_Column_Attribute,
      Single_Paragraph_Mode_Column_Attribute,
      Width_Chars_Column_Attribute,
      Max_Width_Chars_Attribute,
      Wrap_Width_Mode_Column_Attribute,
      Alignment_Column_Attribute,
      Placeholder_Text_Column_Attribute,
      --  Background_Color_Name_Column_Attribute = Foreground_Attribute
      --  Foreground_Color_Name_Column_Attribute = Background_Attribute
      Background_Color_Mode_Column_Attribute,
      Foreground_Color_Mode_Column_Attribute,
      Background_Color_RGBA_Column_Attribute,
      Foreground_Color_RGBA_Column_Attribute,
      Font_Column_Attribute,
      Font_Family_Column_Attribute,
      --  Font_Variant_Column_Attribute = Variant
      --  Font_Weight_Column_Attribute = Weight
      --  Font_Stretch_Column_Attribute = Stretch
      --  Font_Size_Column_Attribute = Size
      Font_Points_Column_Attribute,
      --  Font_Scale_Column_Attribute = Scale
      Editable_Column_Attribute,
      --  Strikethrough_Column_Attribute = Strikethrough
      --  Underline_Column_Attribute = underline
      Rise_Column_Attribute,
      Language_Column_Attribute,
      Ellipsize_Column_Attribute,
      Wrap_Mode_Column_Attribute,

      --  cellrenderertoggle
      Activatable_Column_Attribute,
      Toggle_State_Column_Attribute,
      Radio_State_Column_Attribute,
      Inconsistent_State_Column_Attribute,
      Indicator_Size_Column_Attribute);

   procedure Free is new Ada.Unchecked_Deallocation
     (Object => String, Name => String_Access);

   --------------------------------------------------------------------------
   --  contents
   Stat : array (GTK_Enum) of Integer := (others => 0);
   Have_Signals                : Integer := 0;
   Have_Signal_Realize         : Integer := 0;
   Have_Stores                 : Integer := 0;
   Have_Date_Pickers           : Integer := 0;
   Have_Time_Pickers           : Integer := 0;
   Have_Font_Underline         : Integer := 0;
   Have_Header_Column_Tooltips : Integer := 0;

   --------------------------------------------------------------------------
   type Action_Block is record
      With_Related_Action          : Boolean;
      Related_Action               : String_Access;
      Use_Action_Appearance        : Boolean;
      Use_Action_Appearance_Marked : Boolean;
      Action_Name                  : String_Access;
      Action_Target                : String_Access;
   end record;
   Default_With_Related_Action         : constant Boolean := False;
   Default_With_User_Action_Appearance : constant Boolean := False;
   Default_Action_Appearance_Marked    : constant Boolean := True;
   Default_Action_Block : constant Action_Block :=
                            (With_Related_Action          => Default_With_Related_Action,
                             Related_Action               => null,
                             Use_Action_Appearance        => Default_With_User_Action_Appearance,
                             Use_Action_Appearance_Marked => Default_Action_Appearance_Marked,
                             Action_Name                  => null,
                             Action_Target                => null);

   --------------------------------------------------------------------------
   type Non_Processed_Property_Block is record
      Lineno                 : Natural;
      Non_Processed_Property : String_Access;
   end record;
   package String_Vectors is new Ada.Containers.Vectors (Positive,
                                                         Non_Processed_Property_Block);
   Non_Processed_Properties : String_Vectors.Vector;

end G2a;

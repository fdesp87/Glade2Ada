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

with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Indefinite_Hashed_Sets;
with Ada.Strings.Hash;
with GNATCOLL.Utils;             use GNATCOLL.Utils;
with Ada.Text_IO;

with Glade_Scanner_Io;

package body G2a.Symbol_Tables is

   --------------------------------------------------------------------------
   -- Common --
   --------------------------------------------------------------------------

   function Hash (Str : String) return Ada.Containers.Hash_Type;
   function Hash (Str : String) return Ada.Containers.Hash_Type is
   begin
      return Ada.Strings.Hash (Str);
   end Hash;
   function Key_Equal (Key1, Key2 : String) return Boolean;
   function Key_Equal (Key1, Key2 : String) return Boolean is
   begin
      return Key1 = Key2;
   end Key_Equal;

   --------------------------------------------------------------------------
   -- Node Map --
   --------------------------------------------------------------------------

   package Node_Map is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => GTK_Enum,
      Hash            => Hash,
      Equivalent_Keys => Key_Equal,
      "="             => "=");

   Node_Symbol_Table : Node_Map.Map;

   procedure Initialize_Node_Symbol_Table;
   procedure Initialize_Node_Symbol_Table is
      Nst : Node_Map.Map renames Node_Symbol_Table;
   begin
      --  toplevel
      Nst.Insert ("GtkWindow", Gtk_Window);
      Nst.Insert ("GtkDialog", Gtk_Dialog);
      Nst.Insert ("GtkFileChooserDialog", Gtk_File_Chooser_Dialog);
      Nst.Insert ("GtkFileFilter", Gtk_File_Filter);
      Nst.Insert ("GtkEntryBuffer", Gtk_Entry_Buffer);
      Nst.Insert ("GtkListStore", Gtk_List_Store);
      Nst.Insert ("GtkTreeStore", Gtk_Tree_Store);
      Nst.Insert ("GtkTreeModelSort", Gtk_Tree_Model_Sort);
      Nst.Insert ("GtkTreeModelFilter", Gtk_Tree_Model_Filter);
      Nst.Insert ("GtkImage", Gtk_Image);
      Nst.Insert ("GtkAdjustment", Gtk_Adjustment);
      Nst.Insert ("GtkAccelGroup", Gtk_Accel_Group);
      --  Containers
      Nst.Insert ("GtkBox", Gtk_Box);
      Nst.Insert ("GtkGrid", Gtk_Grid);
      Nst.Insert ("GtkNotebook", Gtk_Notebook);
      Nst.Insert ("GtkTreeSelection", Gtk_Tree_Selection);
      Nst.Insert ("GtkCellRenderer", Gtk_Cell_Renderer);
      Nst.Insert ("GtkCellRendererText", Gtk_Cell_Renderer_Text);
      Nst.Insert ("GtkCellRendererToggle", Gtk_Cell_Renderer_Toggle);
      Nst.Insert ("GtkTreeViewColumn", Gtk_Tree_View_Column);
      Nst.Insert ("GtkFrame", Gtk_Frame);
      Nst.Insert ("GtkAspectFrame", Gtk_Aspect_Frame);
      Nst.Insert ("GtkListBox", Gtk_List_Box);
      Nst.Insert ("GtkFlowBox", Gtk_Flow_Box);
      Nst.Insert ("GtkOverlay", Gtk_Overlay);
      Nst.Insert ("GtkMenuBar", Gtk_Menu_Bar);
      Nst.Insert ("GtkToolbar", Gtk_ToolBar);
      Nst.Insert ("GtkToolItem", Gtk_Tool_Item);
      Nst.Insert ("GtkSeparatorToolItem", Gtk_Separator_Tool_Item);
      Nst.Insert ("GtkStatusbar", Gtk_Status_Bar);
      Nst.Insert ("GtkToolPalette", Gtk_Tool_Palette);
      Nst.Insert ("GtkPaned", Gtk_Paned);
      Nst.Insert ("GtkButtonBox", Gtk_Button_Box);
      Nst.Insert ("GtkLayout", Gtk_Layout);
      Nst.Insert ("GtkFixed", Gtk_Fixed);
      Nst.Insert ("GtkEventBox", Gtk_Event_Box);
      Nst.Insert ("GtkExpander", Gtk_Expander);
      Nst.Insert ("GtkViewport", Gtk_Viewport);
      Nst.Insert ("GtkScrolledWindow", Gtk_Scrolled_Window);
      Nst.Insert ("GtkAlignment", Gtk_Alignment);
      Nst.Insert ("GtkRevealer", Gtk_Revealer);
      Nst.Insert ("GtkSearchBar", Gtk_Search_Bar);
      Nst.Insert ("GtkHeaderBar", Gtk_Header_Bar);
      Nst.Insert ("GtkStack", Gtk_Stack);
      Nst.Insert ("GtkPopover", Gtk_Popover);
      Nst.Insert ("GtkActionBar", Gtk_Action_Bar);
      Nst.Insert ("GtkAction", Gtk_Action);
      --  controls
      Nst.Insert ("GtkEntry", Gtk_Entry);
      Nst.Insert ("GtkButton", Gtk_Button);
      Nst.Insert ("GtkSpinButton", Gtk_Spin_Button);
      Nst.Insert ("GtkToggleButton", Gtk_Toggle_Button);
      Nst.Insert ("GtkCheckButton", Gtk_Check_Button);
      Nst.Insert ("GtkColorButton", Gtk_Color_Button);
      Nst.Insert ("GtkRadioButton", Gtk_Radio_Button);
      Nst.Insert ("GtkComboBox", Gtk_Combo_Box);
      Nst.Insert ("GtkComboBoxText", Gtk_Combo_Box_Text);
      Nst.Insert ("GtkFileChooserButton", Gtk_File_Chooser_Button);
      --  display
      Nst.Insert ("GtkLabel", Gtk_Label);
      Nst.Insert ("GtkTreeView", Gtk_Tree_View);
      Nst.Insert ("GtkCalendar", Gtk_Calendar);
      --  auxiliary
      Nst.Insert ("GtkTabChild", Gtk_TabChild);
      Nst.Insert ("GtkMenu", Gtk_Menu);
      Nst.Insert ("GtkSubmenu", Gtk_Submenu);
      Nst.Insert ("GtkMenuNormalItem", Gtk_Menu_Normal_Item);
      Nst.Insert ("GtkSeparatorMenuItem", Gtk_Separator_Menu_Item);
      Nst.Insert ("GtkMenuItem", Gtk_Menu_Item);
      Nst.Insert ("GtkImageMenuItem", Gtk_Image_Menu_Item);
      --  for dialogs
      Nst.Insert ("Internal_Child_VBox", Internal_Child_VBox);
      Nst.Insert ("Internal_Child_Action_Area", Internal_Child_Action_Area);
      Nst.Insert ("Action_Widgets", Action_Widgets);
      --  Ada widgets
      Nst.Insert ("AdaDatePicker", Ada_Date_Picker);
      Nst.Insert ("AdaTimePicker", Ada_Time_Picker);

      null;
   end Initialize_Node_Symbol_Table;

   --------------------------------------------------------------------------
   function Get_Node_Type (Obj : String) return GTK_Enum is
      use Node_Map;
      Crs  : Cursor;
      Obj0 : constant String := Obj (Obj'First + 1 .. Obj'Last - 1);
   begin
      Crs := Node_Symbol_Table.Find (Obj0);
      if Crs = No_Element then
         return No_Node;
      else
         return Crs.Element;
      end if;
   end Get_Node_Type;

   --------------------------------------------------------------------------
   function To_Gtk (N : GTK_Enum) return String is
   begin
      return Capitalize (N'Image);
   end To_Gtk;

   --------------------------------------------------------------------------
   -- Signals --
   --------------------------------------------------------------------------
   package Signal_Map is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Boolean,
      Hash            => Hash,
      Equivalent_Keys => Key_Equal,
      "="             => "=");

   Signal_Symbol_Table : Signal_Map.Map;

   procedure Initialize_Signal_Symbol_Table;
   procedure Initialize_Signal_Symbol_Table is
      Wst : Signal_Map.Map renames Signal_Symbol_Table;
   begin
      --  gobject
      Wst.Insert ("notify", True);

      --  gtkentrybuffer
      Wst.Insert ("deleted-text", True);
      Wst.Insert ("inserted-text", True);

      --  gtkfilechooser
      Wst.Insert ("confirm-overwrite", True);
      Wst.Insert ("current-folder-changed", True);
      Wst.Insert ("file-activated", True);
      Wst.Insert ("selection-changed", True);
      Wst.Insert ("update-preview", True);

      --  gtkdialog
      Wst.Insert ("close", True);
      Wst.Insert ("response", True);

      --  gtkwindow
      Wst.Insert ("activate-default", True);
      Wst.Insert ("activate-focus", True);
      Wst.Insert ("enable-debugging", True);
      Wst.Insert ("keys-changed", True);
      Wst.Insert ("set-focus", True);

      --  gtkcontainer
      Wst.Insert ("add", True);
      Wst.Insert ("check-resize", True);
      Wst.Insert ("remove", True);
      Wst.Insert ("set-focus-child", True);

      --  gtkwidget
      Wst.Insert ("accel-closures-changed", True);
      Wst.Insert ("button-press-event", False);
      Wst.Insert ("button-release-event", False);
      Wst.Insert ("can-activate-accel", False);
      Wst.Insert ("child-notify", True);
      Wst.Insert ("composite-changed", True);
      Wst.Insert ("configure-event", False);
      Wst.Insert ("damage-event", False);
      Wst.Insert ("delete-event", False);
      Wst.Insert ("destroy", True);
      Wst.Insert ("destroy-event", True);
      Wst.Insert ("direction-changed", False);
      Wst.Insert ("drag-begin", True);
      Wst.Insert ("drag-data-delete", True);
      Wst.Insert ("drag-data-get", True);
      Wst.Insert ("drag-data-received", True);
      Wst.Insert ("drag-drop", True);
      Wst.Insert ("drag-end", True);
      Wst.Insert ("drag-failed", False);
      Wst.Insert ("drag-leave", True);
      Wst.Insert ("drag-motion", False);
      Wst.Insert ("draw", False);
      Wst.Insert ("enter-notify-event", False);
      Wst.Insert ("event", False);
      Wst.Insert ("event-after", True);
      Wst.Insert ("focus", False);
      Wst.Insert ("focus-in-event", False);
      Wst.Insert ("focus-out-event", False);
      Wst.Insert ("grab-broken-event", False);
      Wst.Insert ("grab-focus", True);
      Wst.Insert ("grab-notify", True);
      Wst.Insert ("hide", True);
      Wst.Insert ("hierarchy-changed", True);
      Wst.Insert ("key-press-event", False);
      Wst.Insert ("key-release-event", False);
      Wst.Insert ("keynav-failed", False);
      Wst.Insert ("leave-notify-event", False);
      Wst.Insert ("map", True);
      Wst.Insert ("map-event", False);
      Wst.Insert ("mnemonic-activate", False);
      Wst.Insert ("motion-notify-event", False);
      Wst.Insert ("move-focus", True);
      Wst.Insert ("parent-set", True);
      Wst.Insert ("popup-menu", False);
      Wst.Insert ("property-notify-event", False);
      Wst.Insert ("proximity-in-event", False);
      Wst.Insert ("proximity-out-event", False);
      Wst.Insert ("query-tooltip", False);
      Wst.Insert ("realize", True);
      Wst.Insert ("screen-changed", True);
      Wst.Insert ("scroll-event", False);
      Wst.Insert ("selection-clear-event", False);
      Wst.Insert ("selection-get", True);
      Wst.Insert ("selection-notify-event", False);
      Wst.Insert ("selection-received", True);
      Wst.Insert ("selection-request-event", False);
      Wst.Insert ("show", True);
      Wst.Insert ("show-help", True);
      Wst.Insert ("size-allocate", True);
      Wst.Insert ("state-changed", True);
      Wst.Insert ("state-flags-changed", True);
      Wst.Insert ("style-set", True);
      Wst.Insert ("style-updated", True);
      Wst.Insert ("touch-event", False);
      Wst.Insert ("unmap", True);
      Wst.Insert ("unmap-event", False);
      Wst.Insert ("unrealize", True);
      Wst.Insert ("visibility-notify-event", False);
      Wst.Insert ("window-state-event", False);

      --  gtkbutton
      Wst.Insert ("activate", True);
      Wst.Insert ("clicked", True);
      Wst.Insert ("enter", True);
      Wst.Insert ("leave", True);
      Wst.Insert ("pressed", True);
      Wst.Insert ("released", True);

      --  gtktogglebutton
      Wst.Insert ("toggled", True);

      --  gtkradiobutton
      Wst.Insert ("group-changed", True);

      --  gtkentry
      --  Wst.Insert ("activate", True);
      Wst.Insert ("backspace", True);
      Wst.Insert ("copy-clipboard", True);
      Wst.Insert ("cut-clipboard", True);
      Wst.Insert ("delete-from-cursor", True);
      Wst.Insert ("icon-press", True);
      Wst.Insert ("icon-release", True);
      Wst.Insert ("insert-at-cursor", True);
      Wst.Insert ("insert-emoji", True);
      Wst.Insert ("move-cursor", True);
      Wst.Insert ("paste-clipboard", True);
      Wst.Insert ("populate-popup", True);
      Wst.Insert ("preedit-changed", True);
      Wst.Insert ("toggle-overwrite", True);

      --  gtklabel
      Wst.Insert ("activate-current-link", True);
      Wst.Insert ("activate-link", False);
      --  Wst.Insert ("copy-clipboard", True);
      --  Wst.Insert ("move-cursor", True);
      --  Wst.Insert ("populate-popup", True);

      --  gtkcomboboxtext
      Wst.Insert ("changed", True);
      Wst.Insert ("format-entry-text", False);  --  char*
      Wst.Insert ("move-active", True);
      Wst.Insert ("popdown", False);
      Wst.Insert ("popup", True);

      --  gtkfilechooserbutton
      Wst.Insert ("file-set", True);

      --  gtktreemodel
      Wst.Insert ("row-changed", True);
      Wst.Insert ("row-deleted", True);
      Wst.Insert ("row-has-child-toggled", True);
      Wst.Insert ("row-inserted", True);
      Wst.Insert ("row-reordered", True);

      --  gtksortable
      Wst.Insert ("sort-column-changed", True);

      --  gtktreeview
      Wst.Insert ("columns-changed", True);
      Wst.Insert ("cursor-changed", True);
      Wst.Insert ("expand-collapse-cursor-row", False);
      --  Wst.Insert ("move-cursor", False);
      Wst.Insert ("row-activated", True);
      Wst.Insert ("row-collapsed", True);
      Wst.Insert ("row-expanded", True);
      Wst.Insert ("select-all", False);
      Wst.Insert ("select-cursor-parent", False);
      Wst.Insert ("select-cursor-row", False);
      Wst.Insert ("start-interactive-search", False);
      Wst.Insert ("test-collapse-row", False);
      Wst.Insert ("test-expand-row", False);
      Wst.Insert ("toggle-cursor-row", False);
      Wst.Insert ("unselect-all", True);

      --  gtknotebook
      Wst.Insert ("change-current-page", False);
      Wst.Insert ("create-window", False); --  return gtknotebook:
      Wst.Insert ("focus-tab", False);
      Wst.Insert ("move-focus-out", True);
      Wst.Insert ("page-added", True);
      Wst.Insert ("page-removed", True);
      Wst.Insert ("page-reordered", True);
      Wst.Insert ("reorder-tab", False);
      Wst.Insert ("select-page", False);
      Wst.Insert ("switch-page", True);

      --  gtktoolbar
      Wst.Insert ("focus-home-or-end", False);
      Wst.Insert ("orientation-changed", True);
      Wst.Insert ("popup-context-menu", False);
      Wst.Insert ("style-changed", True);

      --  gtktoolitem
      Wst.Insert ("create-menu-proxy", False);
      Wst.Insert ("toolbar-reconfigured", True);

      --  gtkscrolledwindow
      Wst.Insert ("edge-overshot", True);
      Wst.Insert ("edge-reached", True);
      --  Wst.Insert ("move-focus-out", True);
      Wst.Insert ("scroll-child", False);

      --  gtktreeselection
      --  Wst.Insert ("changed", True);

      --  gtktreeviewcolumn
      --  Wst.Insert ("clicked", True);

      --  gtkcellrenderer
      Wst.Insert ("editing-canceled", True);
      Wst.Insert ("editing-started", True);

      --  gtkcellrenderertext
      Wst.Insert ("edited", True);

      --  gtkcellrenderertoggle
      --  Wst.Insert ("toggled", True);

      --  gtkcalendar
      Wst.Insert ("day-selected", True);
      Wst.Insert ("day-selected-double-click", True);
      Wst.Insert ("month-changed", True);
      Wst.Insert ("next-month", True);
      Wst.Insert ("next-year", True);
      Wst.Insert ("prev-month", True);
      Wst.Insert ("prev-year", True);

      --  gtkmenushell
      Wst.Insert ("activate-current", True);
      Wst.Insert ("cancel", True);
      Wst.Insert ("cycle-focus", True);
      Wst.Insert ("deactivate", True);
      Wst.Insert ("insert", True);
      Wst.Insert ("move-current", True);
      Wst.Insert ("move-selected", False);
      Wst.Insert ("selection-done", True);

      --  gtkmenu
      Wst.Insert ("move-scroll", True);
      Wst.Insert ("popped-up", True);

      --  gtkmenuitem
      --  Wst.Insert ("activate", True);
      Wst.Insert ("activate-item", True);
      Wst.Insert ("deselect", True);
      Wst.Insert ("select", True);
      Wst.Insert ("toggle-size-allocate", True);
      Wst.Insert ("toggle-size-request", True);

      Wst.Insert ("value-changed", True);
      Wst.Insert ("begin-print", True);
      Wst.Insert ("print-page", True);
      Wst.Insert ("editing-done", True);
      Wst.Insert ("DoWork", True);
      Wst.Insert ("ProgressChanged", True);
      Wst.Insert ("RunWorkerCompleted", True);
   end Initialize_Signal_Symbol_Table;

   function Get_Signal (Sgn : String) return Triboolean is
      use Signal_Map;
      Crs  : Cursor;
      Sgn0 : constant String := Sgn (Sgn'First + 1 .. Sgn'Last - 1);
   begin
      Crs := Signal_Symbol_Table.Find (Sgn0);
      if Crs = No_Element then
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown signal " & Sgn);
         return Indeterminate;
      else
         return To_TriBoolean (Crs.Element);
      end if;
   end Get_Signal;

   --------------------------------------------------------------------------
   -- Property --
   --------------------------------------------------------------------------
   type Property_Semantic_Block is record
      The_Property : Property_Enum;
      The_Flavor   : Property_Flavor_Enum;
   end record;

   package Property_Map is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Property_Semantic_Block,
      Hash            => Hash,
      Equivalent_Keys => Key_Equal,
      "="             => "=");

   Property_Symbol_Table : Property_Map.Map;

   procedure Initialize_Property_Symbol_Table;
   procedure Initialize_Property_Symbol_Table is
      Wst : Property_Map.Map renames Property_Symbol_Table;
   begin
      Wst.Insert ("accel-path", (Accel_Path_Property, Is_String));
      Wst.Insert ("accel-group", (Accel_Group_Property, Is_Identifier));
      Wst.Insert ("accept-focus", (Accept_Focus_Property, Is_Boolean));
      Wst.Insert ("action", (Action_Property, Is_Gtk3_Enum));
      Wst.Insert ("action-name", (Action_Name_Property, Is_String));
      Wst.Insert ("activates-default", (Activates_Default_Property, Is_Boolean));
      Wst.Insert ("activate-on-single-click", (Activate_On_Single_Click_Property, Is_Boolean));
      Wst.Insert ("active", (Active_Property, Is_Boolean));
      Wst.Insert ("active-id", (Active_ID_Property, Is_String));
      Wst.Insert ("add-tearoffs", (Add_Tearoffs_Property, Is_Boolean));
      Wst.Insert ("adjustment", (Adjustment_Property, Is_Identifier));
      Wst.Insert ("alpha", (Alpha_Property, Is_Integer));
      Wst.Insert ("alignment", (Alignment_Property, Is_Decimal));
      Wst.Insert ("always-show-image", (Always_Show_Image_Property, Is_Boolean));
      Wst.Insert ("angle", (Angle_Property, Is_Decimal));
      Wst.Insert ("app-paintable", (App_Paintable_Property, Is_Boolean));
      Wst.Insert ("attached-to", (Attached_To_Property, Is_Identifier));
      Wst.Insert ("baseline-position", (Baseline_Position_Property, Is_Gtk3_Enum));
      Wst.Insert ("baseline-row", (Baseline_Row_Property, Is_Integer));
      Wst.Insert ("bottom-padding", (Bottom_Padding_Property, Is_Integer));
      Wst.Insert ("border-width", (Border_Width_Property, Is_Integer));
      Wst.Insert ("browse", (Browse_Property, Is_Boolean));
      Wst.Insert ("button-sensitivity", (Button_Sensitivity_Property, Is_Gtk3_Enum));
      Wst.Insert ("buffer", (Buffer_Property, Is_Identifier));
      Wst.Insert ("can-default", (Can_Default_Property, Is_Boolean));
      Wst.Insert ("can-focus", (Can_Focus_Property, Is_Boolean));
      Wst.Insert ("caps-lock-warning", (Caps_Lock_Warning_Property, Is_Boolean));
      Wst.Insert ("child-pack-direction", (Child_Pack_Direction_Property, Is_Gtk3_Enum));
      Wst.Insert ("child-model", (Child_Model_Property, Is_Identifier));
      Wst.Insert ("clickable", (Clickable_Property, Is_Boolean));
      Wst.Insert ("climb-rate", (Climb_Rate_Property, Is_Decimal));
      Wst.Insert ("color", (Color_Property, Is_String));
      Wst.Insert ("column-span-column", (Column_Span_Column_Property, Is_Integer));
      Wst.Insert ("column-spacing", (Column_Spacing_Property, Is_Integer));
      Wst.Insert ("column-homogeneous", (Column_Homogeneous_Property, Is_Boolean));
      Wst.Insert ("constrain-to", (Constrain_To_Property, Is_Gtk3_Enum));
      Wst.Insert ("create-folders", (Create_Folders_Property, Is_Boolean));
      Wst.Insert ("day", (Day_Property, Is_Integer));
      Wst.Insert ("decorated", (Decorated_Property, Is_Boolean));
      Wst.Insert ("deletable", (Deletable_Property, Is_Boolean));
      Wst.Insert ("detail-height-rows", (Detail_Height_Rows, Is_Integer));
      Wst.Insert ("detail-width-chars", (Detail_Width_Chars, Is_Integer));
      Wst.Insert ("dialog", (Dialog_Property, Is_Identifier));
      Wst.Insert ("default-width", (Default_Width_Property, Is_Integer));
      Wst.Insert ("default-height", (Default_Height_Property, Is_Integer));
      Wst.Insert ("destroy-with-parent", (Destroy_With_Parent_Property, Is_Boolean));
      Wst.Insert ("double-buffered", (Double_Buffered_Property, Is_Boolean));
      Wst.Insert ("draw", (Draw_Property, Is_Boolean));
      Wst.Insert ("draw-indicator", (Draw_Indicator_Property, Is_Boolean));
      Wst.Insert ("editable", (Editable_Property, Is_Boolean));
      Wst.Insert ("ellipsize", (Ellipsize_Property, Is_Gtk3_Enum));
      Wst.Insert ("enable-emoji-completion", (Enable_Emoji_Completion_Property, Is_Boolean));
      Wst.Insert ("enable-grid-lines", (Enable_Grid_Lines_Property, Is_Gtk3_Enum));
      Wst.Insert ("enable-popup", (Enable_Popup_Property, Is_Boolean));
      Wst.Insert ("entry-text-column", (Entry_Text_Column_Property, Is_Integer));
      Wst.Insert ("events", (Events_Property, Is_String));
      Wst.Insert ("expand", (Expand_Property, Is_Boolean));
      Wst.Insert ("expander-column", (Expander_Column_Property, Is_Identifier));
      Wst.Insert ("extra-widget", (Extra_Widget_Property, Is_Identifier));
      Wst.Insert ("fill", (Fill_Property, Is_Boolean));
      Wst.Insert ("filter", (Filter_Property, Is_Identifier));
      Wst.Insert ("fixed-height-mode", (Fixed_Height_Mode_Property, Is_Boolean));
      Wst.Insert ("fixed-width", (Fixed_Width_Property, Is_Boolean));
      Wst.Insert ("focus-on-click", (Focus_On_Click_Property, Is_Boolean));
      Wst.Insert ("focus-on-map", (Focus_On_Map_Property, Is_Boolean));
      Wst.Insert ("gravity", (Gravity_Property, Is_Gtk3_Enum));
      Wst.Insert ("group", (Group_Property, Is_Identifier));
      Wst.Insert ("group-name", (Group_Name_Property, Is_Identifier));
      Wst.Insert ("hadjustment", (Hadjustment_Property, Is_Gtk3_Enum));
      Wst.Insert ("halign", (Halign_Property, Is_Gtk3_Enum));
      Wst.Insert ("has-default", (Has_Default_Property, Is_Boolean));
      Wst.Insert ("has-entry", (Has_Entry_Property, Is_Boolean));
      Wst.Insert ("has-focus", (Has_Focus_Property, Is_Boolean));
      Wst.Insert ("has-frame", (Has_Frame_Property, Is_Boolean));
      Wst.Insert ("has-resize-grip", (Has_Resize_Grip_Property, Is_Boolean));
      Wst.Insert ("has-tooltip", (Has_Tooltip_Property, Is_Boolean));
      Wst.Insert ("height", (Height_Property, Is_Integer));
      Wst.Insert ("height-request", (Height_Request_Property, Is_Integer));
      Wst.Insert ("hexpand", (Hexpand_Property, Is_Boolean));
      Wst.Insert ("hide-titlebar-when-maximized", (Hide_Titlebar_When_Maximized_Property, Is_Boolean));
      Wst.Insert ("hide-if-empty", (Hide_If_Empty_Property, Is_Boolean));
      Wst.Insert ("homogeneous", (Homogeneous_Property, Is_Boolean));
      Wst.Insert ("hscroll-policy", (HScroll_Policy_Property, Is_Gtk3_Enum));
      Wst.Insert ("hscrollbar-policy", (Hscrollbar_Policy_Property, Is_Gtk3_Enum));
      Wst.Insert ("icon-name", (Icon_Name_Property, Is_String));
      Wst.Insert ("icon", (Icon_File_Property, Is_String));
      Wst.Insert ("icon_size", (Icon_Size_Property, Is_Integer));
      Wst.Insert ("id-column", (Id_Column_Property, Is_Integer));
      Wst.Insert ("image", (Image_Property, Is_Identifier));
      Wst.Insert ("image-position", (Image_Position_Property, Is_Gtk3_Enum));
      Wst.Insert ("inconsistent", (Inconsistent_Property, Is_Boolean));
      Wst.Insert ("input-hints", (Input_Hints_Property, Is_String));
      Wst.Insert ("input-purpose", (Input_Purpose_Property, Is_Gtk3_Enum));
      Wst.Insert ("invisible-char", (Invisible_Char_Property, Is_String));
      Wst.Insert ("is-focus", (Is_Focus_Property, Is_Boolean));
      Wst.Insert ("is-important", (Is_Important_Property, Is_Boolean));
      Wst.Insert ("justify", (Justify_Property, Is_Gtk3_Enum));
      Wst.Insert ("kinetic-scrolling", (Kinetic_Scrolling_Property, Is_Boolean));
      Wst.Insert ("label", (Label_Property, Is_String));
      Wst.Insert ("label-xalign", (Label_Xalign_Property, Is_Decimal));
      Wst.Insert ("label-yalign", (Label_Yalign_Property, Is_Decimal));
      Wst.Insert ("layout-style", (Layout_Style_Property, Is_Gtk3_Enum));
      Wst.Insert ("left-attach", (Left_Attach_Property, Is_Integer));
      Wst.Insert ("left-padding", (Left_Padding_Property, Is_Integer));
      Wst.Insert ("level-indentation", (Level_Indentation_Property, Is_Integer));
      Wst.Insert ("lines", (Lines_Property, Is_Integer));
      Wst.Insert ("local-only", (Local_Only_Property, Is_Boolean));
      Wst.Insert ("lower", (Lower_Property, Is_Integer));
      Wst.Insert ("margin-left", (Margin_Left_Property, Is_Integer));
      Wst.Insert ("margin-right", (Margin_Right_Property, Is_Integer));
      Wst.Insert ("margin-start", (Margin_Start_Property, Is_Integer));
      Wst.Insert ("margin-end", (Margin_End_Property, Is_Integer));
      Wst.Insert ("margin-top", (Margin_Top_Property, Is_Integer));
      Wst.Insert ("margin-bottom", (Margin_Bottom_Property, Is_Integer));
      Wst.Insert ("max-date", (Max_Date_Property, Is_String));
      Wst.Insert ("max-length", (Max_Length_Property, Is_Integer));
      Wst.Insert ("max-width-chars", (Max_Width_Chars_Property, Is_Integer));
      Wst.Insert ("max-width", (Max_Width_Property, Is_Integer));
      Wst.Insert ("menu-type-hint", (Menu_Type_Hint_Property, Is_Gtk3_Enum));
      Wst.Insert ("min-date", (Min_Date_Property, Is_String));
      Wst.Insert ("min-width", (Min_Width_Property, Is_Integer));
      Wst.Insert ("max-content-height", (Max_Content_Height_Property, Is_Integer));
      Wst.Insert ("max-content-width", (Max_Content_Width_Property, Is_Integer));
      Wst.Insert ("min-content-height", (Min_Content_Height_Property, Is_Integer));
      Wst.Insert ("min-content-width", (Min_Content_Width_Property, Is_Integer));
      Wst.Insert ("mnemonic-widget", (Mnemonic_Property, Is_Identifier));
      Wst.Insert ("modal", (Modal_Property, Is_Boolean));
      Wst.Insert ("mode", (Mode_Property, Is_Gtk3_Enum));
      Wst.Insert ("model", (Model_Property, Is_Identifier));
      Wst.Insert ("month", (Month_Property, Is_Integer));
      Wst.Insert ("name", (Name_Property, Is_Identifier));
      Wst.Insert ("no-month-change", (No_Month_Change_Property, Is_Boolean));
      Wst.Insert ("no-show-all", (No_Show_All_Property, Is_Boolean));
      Wst.Insert ("non-homogeneous", (Non_Homogeneous_Property, Is_Boolean));
      Wst.Insert ("numeric", (Numeric_Property, Is_Boolean));
      Wst.Insert ("opacity", (Opacity_Property, Is_Decimal));
      Wst.Insert ("obey-child", (Obey_Child_Property, Is_Boolean));
      Wst.Insert ("orientation", (Orientation_Property, Is_Gtk3_Enum));
      Wst.Insert ("overlay-scrolling", (Overlay_Scrolling_Property, Is_Boolean));
      Wst.Insert ("do-overwrite-confirmation", (Overwrite_Confirmation_Property, Is_Boolean));
      Wst.Insert ("overwrite-mode", (Overwrite_Mode_Property, Is_Boolean));
      Wst.Insert ("placeholder-text", (Placeholder_Text_Property, Is_String));
      Wst.Insert ("pack-direction", (Pack_Direction_Property, Is_Gtk3_Enum));
      Wst.Insert ("pack-type", (Pack_Type_Property, Is_Gtk3_Enum));
      Wst.Insert ("padding", (Padding_Property, Is_Integer));
      Wst.Insert ("page-increment", (Page_Increment_Property, Is_Decimal));
      Wst.Insert ("page-size", (Page_Size_Property, Is_Decimal));
      Wst.Insert ("pattern", (Pattern_Property, Is_String));
      Wst.Insert ("position", (Position_Property, Is_Integer));
      Wst.Insert ("popup-fixed-width", (Popup_Fixed_Width_Property, Is_Boolean));
      Wst.Insert ("populate-all", (Populate_All_Property, Is_Boolean));
      Wst.Insert ("preview-widget", (Preview_Widget_Property, Is_Identifier));
      Wst.Insert ("preview-widget-active", (Preview_Widget_Active_Property, Is_Boolean));
      Wst.Insert ("primary-icon-activatable", (Primary_Icon_Activatable_Property, Is_Boolean));
      Wst.Insert ("primary-icon-name", (Primary_Icon_Name_Property, Is_String));
      Wst.Insert ("primary-icon-pixbuf", (Primary_Icon_Pixbuf_Property, Is_String));
      Wst.Insert ("primary-icon-sensitive", (Primary_Icon_Sensitivity_Property, Is_Boolean));
      Wst.Insert ("primary-icon-stock", (Primary_Icon_Stock_Property, Is_String));
      Wst.Insert ("primary-icon-tooltip-markup", (Primary_Icon_Tooltip_Markup, Is_String));
      Wst.Insert ("primary-icon-tooltip-text", (Primary_Icon_Tooltip_Text, Is_String));
      Wst.Insert ("progress-fraction", (Progress_Fraction_Property, Is_Decimal));
      Wst.Insert ("progress-pulse-step", (Progress_Pulse_Step_Property, Is_Decimal));
      Wst.Insert ("propagate-natural-width", (Propagate_Natural_Width_Property, Is_Boolean));
      Wst.Insert ("propagate-natural-height", (Propagate_Natural_Height_Property, Is_Boolean));
      Wst.Insert ("pixbuf", (Pixbuf_Property, Is_String));
      Wst.Insert ("pixel-size", (Pixel_Size_Property, Is_Integer));
      Wst.Insert ("ratio", (Ratio_Property, Is_Decimal));
      Wst.Insert ("receives-default", (Receives_Default_Property, Is_Boolean));
      Wst.Insert ("rect-anchor-dx", (Rect_Anchor_Dx_Property, Is_Integer));
      Wst.Insert ("rect-anchor-dy", (Rect_Anchor_Dy_Property, Is_Integer));
      Wst.Insert ("related-action", (Related_Action_Property, Is_Identifier));
      Wst.Insert ("relative-to", (Relative_To_Property, Is_Identifier));
      Wst.Insert ("relief", (Relief_Property, Is_Gtk3_Enum));
      Wst.Insert ("reorderable", (Reorderable_Property, Is_Boolean));
      Wst.Insert ("reserve-toggle-size", (Reserve_Toggle_Size_Property, Is_Boolean));
      Wst.Insert ("resizable", (Resizable_Property, Is_Boolean));
      Wst.Insert ("resource", (Resource_Property, Is_String));
      Wst.Insert ("rgba", (Rgba_Property, Is_String));
      Wst.Insert ("right-justified", (Right_Justified_Property, Is_Boolean));
      Wst.Insert ("right-padding", (Right_Padding_Property, Is_Integer));
      Wst.Insert ("role", (Role_Property, Is_String));
      Wst.Insert ("row-span-column", (Row_Span_Column_Property, Is_Integer));
      Wst.Insert ("row-spacing", (Row_Spacing_Property, Is_Integer));
      Wst.Insert ("row-homogeneous", (Row_Homogeneous_Property, Is_Boolean));
      Wst.Insert ("rubber-banding", (Rubber_Banding_Property, Is_Boolean));
      Wst.Insert ("rules-hint", (Rules_Hint_Property, Is_Boolean));
      Wst.Insert ("short-label", (Short_Label_Property, Is_String));
      Wst.Insert ("show-arrow", (Show_Arrow_Property, Is_Boolean));
      Wst.Insert ("show-border", (Show_Border_Property, Is_Boolean));
      Wst.Insert ("show-day-names", (Show_Day_Names_Property, Is_Boolean));
      Wst.Insert ("show-details", (Show_Details_Property, Is_Boolean));
      Wst.Insert ("show-editor", (Show_Editor_Property, Is_Boolean));
      Wst.Insert ("show-emoji-icon", (Show_Emoji_Icon_Property, Is_Boolean));
      Wst.Insert ("show-heading", (Show_Heading_Property, Is_Boolean));
      Wst.Insert ("show-hidden", (Show_Hidden_Property, Is_Boolean));
      Wst.Insert ("show-tabs", (Show_Tabs_Property, Is_Boolean));
      Wst.Insert ("show-week-numbers", (Show_Week_Numbers_Property, Is_Boolean));
      Wst.Insert ("shadow-type", (Shadow_Type_Property, Is_Gtk3_Enum));
      Wst.Insert ("scrollable", (Scrollable_Property, Is_Boolean));
      Wst.Insert ("secondary", (Secondary_Property, Is_Boolean));
      Wst.Insert ("secondary-icon-activatable", (Secondary_Icon_Activatable_Property, Is_Boolean));
      Wst.Insert ("secondary-icon-name", (Secondary_Icon_Name_Property, Is_String));
      Wst.Insert ("secondary-icon-pixbuf", (Secondary_Icon_Pixbuf_Property, Is_String));
      Wst.Insert ("secondary-icon-sensitive", (Secondary_Icon_Sensitivity_Property, Is_Boolean));
      Wst.Insert ("secondary-icon-stock", (Secondary_Icon_Stock_Property, Is_String));
      Wst.Insert ("secondary-icon-tooltip-markup", (Secondary_Icon_Tooltip_Markup, Is_String));
      Wst.Insert ("secondary-icon-tooltip-text", (Secondary_Icon_Tooltip_Text, Is_String));
      Wst.Insert ("selectable", (Selectable_Property, Is_Boolean));
      Wst.Insert ("sensitive", (Sensitive_Property, Is_Boolean));
      Wst.Insert ("sizing", (Sizing_Property, Is_String));
      Wst.Insert ("skip-pager-hint", (Skip_Pager_Hint_Property, Is_Boolean));
      Wst.Insert ("skip-taskbar-hint", (Skip_Taskbar_Hint_Property, Is_Boolean));
      Wst.Insert ("snap_to_ticks", (Snap_To_Ticks_Property, Is_Boolean));
      Wst.Insert ("sort-column-id", (Sort_Column_Id_Property, Is_Integer));
      Wst.Insert ("sort-indicator", (Sort_Indicator_Property, Is_Boolean));
      Wst.Insert ("sort-order", (Sort_Order_Property, Is_String));
      Wst.Insert ("spacing", (Spacing_Property, Is_Integer));
      Wst.Insert ("startup-id", (Startup_ID_Property, Is_String));
      Wst.Insert ("step-increment", (Step_Increment_Property, Is_Decimal));
      Wst.Insert ("stock", (Stock_Property, Is_String));
      Wst.Insert ("stock-id", (Stock_ID_Property, Is_String));
      Wst.Insert ("tab-fill", (Tab_Fill_Property, Is_Boolean));
      Wst.Insert ("tab-pos", (Tab_Position_Property, Is_Gtk3_Enum));
      Wst.Insert ("take-focus", (Take_Focus_Property, Is_Boolean));
      Wst.Insert ("tearoff-title", (Tearoff_Title_Property, Is_String));
      Wst.Insert ("tearoff-state", (Tearoff_State_Property, Is_Boolean));
      Wst.Insert ("text", (Text_Property, Is_String));
      Wst.Insert ("time-zone", (Time_Zone_Property, Is_String));
      Wst.Insert ("title", (Title_Property, Is_String));
      Wst.Insert ("the_digits", (The_Digits_Property, Is_Integer));
      Wst.Insert ("toolbar-style", (Toolbar_Style_Property, Is_Gtk3_Enum));
      Wst.Insert ("tooltip", (Tooltip_Property, Is_String));
      Wst.Insert ("tooltip-markup", (Tooltip_Markup_Property, Is_String));
      Wst.Insert ("tooltip-text", (Tooltip_Text_Property, Is_String));
      Wst.Insert ("top-attach", (Top_Attach_Property, Is_Integer));
      Wst.Insert ("top-padding", (Top_Padding_Property, Is_Integer));
      Wst.Insert ("track-visited-links", (Track_Links_Property, Is_Boolean));
      Wst.Insert ("transitions-enabled", (Transitions_Enabled_Property, Is_Boolean));
      Wst.Insert ("transient-for", (Transient_For_Property, Is_Identifier));
      Wst.Insert ("truncate-multiline", (Truncate_Multiline_Property, Is_Boolean));
      Wst.Insert ("type", (Type_Property, Is_Identifier));
      Wst.Insert ("type-hint", (Type_Hint_Property, Is_Gtk3_Enum));
      Wst.Insert ("ubuntu-almost-fixed-height-mode", (Ubuntu_Almost_Fixed_Height_Mode_Property, Is_Boolean));
      Wst.Insert ("update-policy", (Update_Policy_Property, Is_Gtk3_Enum));
      Wst.Insert ("upper", (Upper_Property, Is_Decimal));
      Wst.Insert ("urgency-hint", (Urgency_Hint_Property, Is_Boolean));
      Wst.Insert ("use-alpha", (Use_Alpha_Property, Is_Boolean));
      Wst.Insert ("use-action-appearance", (Use_Action_Appearance_Property, Is_Boolean));
      Wst.Insert ("use-fallback", (Use_Fallback_Property, Is_Boolean));
      Wst.Insert ("use-markup", (Use_Markup_Property, Is_Boolean));
      Wst.Insert ("use-preview-label", (Use_Preview_Label_Property, Is_Boolean));
      Wst.Insert ("use-stock", (Use_Stock_Property, Is_Boolean));
      Wst.Insert ("use-underline", (Use_Underline_Property, Is_Boolean));
      Wst.Insert ("vadjustment", (Vadjustment_Property, Is_Gtk3_Enum));
      Wst.Insert ("valign", (Valign_Property, Is_Gtk3_Enum));
      Wst.Insert ("value", (Value_Property, Is_Decimal));
      Wst.Insert ("vexpand", (Vexpand_Property, Is_Boolean));
      Wst.Insert ("visibility", (Visibility_Property, Is_Boolean));
      Wst.Insert ("visible", (Visible_Property, Is_Boolean));
      Wst.Insert ("visible-horizontal", (Visible_When_Horizontal_Property, Is_Boolean));
      Wst.Insert ("visible-vertical", (Visible_When_Vertical_Property, Is_Boolean));
      Wst.Insert ("visible-overflown", (Visible_Overflown_Property, Is_Boolean));
      Wst.Insert ("vscroll-policy", (VScroll_Policy_Property, Is_Gtk3_Enum));
      Wst.Insert ("vscrollbar-policy", (VScrollbar_Policy_Property, Is_Gtk3_Enum));
      Wst.Insert ("wrap", (Wrap_Property, Is_Boolean)); --
      Wst.Insert ("wrap-mode", (Wrap_Mode_Property, Is_Gtk3_Enum));
      Wst.Insert ("wrap-width", (Wrap_Width_Property, Is_Integer));
      Wst.Insert ("width", (Width_Property, Is_Integer));
      Wst.Insert ("width-chars", (Width_Chars_Property, Is_Integer));
      Wst.Insert ("width-request", (Width_Request_Property, Is_Integer));
      Wst.Insert ("window-position", (Window_Position_Property, Is_Gtk3_Enum));
      Wst.Insert ("window-placement", (Window_Placement_Property, Is_Gtk3_Enum));
      Wst.Insert ("window-placement-set", (Window_Placement_Set_Property, Is_Boolean));
      Wst.Insert ("x", (X_Property, Is_Integer));
      Wst.Insert ("xalign", (Xalign_Property, Is_Decimal));
      Wst.Insert ("xpad", (Xpad_Property, Is_Integer));
      Wst.Insert ("xscale", (Xscale_Property, Is_Decimal));
      Wst.Insert ("y", (Y_Property, Is_Integer));
      Wst.Insert ("yalign", (Yalign_Property, Is_Decimal));
      Wst.Insert ("year", (Year_Property, Is_Integer));
      Wst.Insert ("ypad", (Ypad_Property, Is_Integer));
      Wst.Insert ("yscale", (Yscale_Property, Is_Decimal));
   end Initialize_Property_Symbol_Table;

   procedure Get_Property (S : String;
                           P : Property) is
      use Property_Map;
      Crs  : Cursor;
   begin
      Crs := Property_Symbol_Table.Find (S);
      if Crs = No_Element then
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown property " & S);
         --  Free (P.Name);
         --  P.all  := Default_Property_Block;
         --  P.Name := new String'(S);
      else
         P.Prop   := Crs.Element.The_Property;
         P.Flavor := Crs.Element.The_Flavor;
      end if;
   end Get_Property;

   --------------------------------------------------------------------------
   -- Attribute  --
   --------------------------------------------------------------------------

   package Attribute_Map is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Attribute_Enum,
      Hash            => Hash,
      Equivalent_Keys => Key_Equal,
      "="             => "=");

   Attribute_Symbol_Table : Attribute_Map.Map;

   procedure Initialize_Attribute_Symbol_Table;
   procedure Initialize_Attribute_Symbol_Table is
      Wst : Attribute_Map.Map renames Attribute_Symbol_Table;
   begin
      --  label
      Wst.Insert ("font-desc", Font_Desc_Attribute);
      Wst.Insert ("style", Style_Attribute);
      Wst.Insert ("weight", Weight_Attribute);
      Wst.Insert ("variant", Variant_Attribute);
      Wst.Insert ("stretch", Stretch_Attribute);
      Wst.Insert ("scale", Scale_Attribute);
      Wst.Insert ("underline", Underline_Attribute);
      Wst.Insert ("strikethrough", Strikethrough_Attribute);
      Wst.Insert ("foreground", Foreground_Attribute);
      Wst.Insert ("background", Background_Attribute);
      Wst.Insert ("underline-color", Underline_Color_Attribute);
      Wst.Insert ("strikethrough-color", Strikethrough_Color_Attribute);
      Wst.Insert ("gravity", Gravity_Attribute);
      Wst.Insert ("gravity-hint", Gravity_Hint_Attribute);
      Wst.Insert ("size", Size_Attribute);
      Wst.Insert ("absolute-size", Absolute_Size_Attribute);
      --  cellrenderer
      Wst.Insert ("visible", Visible_Column_Attribute);
      Wst.Insert ("sensitive", Sensitive_Column_Attribute);
      Wst.Insert ("xalign", H_Align_Column_Attribute);
      Wst.Insert ("yalign", V_Align_Column_Attribute);
      Wst.Insert ("xpad", H_Padding_Column_Attribute);
      Wst.Insert ("ypad", V_Padding_Column_Attribute);
      Wst.Insert ("width", Width_Column_Attribute);
      Wst.Insert ("height", Height_Column_Attribute);
      Wst.Insert ("cell-background", Cell_Bg_Color_Name_Column_Attribute);
      Wst.Insert ("cell-background-gdk", Cell_Bg_Color_Attribute);
      Wst.Insert ("cell-background-rgba", Cell_Bg_RGBA_Color_Attribute);
      Wst.Insert ("font-style", Font_Style_Column_Attribute);
      --  cellrenderertext
      Wst.Insert ("text", Text_Columm_Attribute);
      Wst.Insert ("markup", Markup_Column_Attribute);
      Wst.Insert ("single-paragraph-mode", Single_Paragraph_Mode_Column_Attribute);
      Wst.Insert ("width-chars", Width_Chars_Column_Attribute);
      Wst.Insert ("max-width-chars", Max_Width_Chars_Attribute);
      Wst.Insert ("wrap-width", Wrap_Width_Mode_Column_Attribute);
      Wst.Insert ("alignment", Alignment_Column_Attribute);
      Wst.Insert ("placeholder-text", Placeholder_Text_Column_Attribute);
      --  Wst.Insert ("background", Background_Color_Name_Column_Attribute);
      --  Wst.Insert ("foreground", Foreground_Color_Name_Column_Attribute);
      Wst.Insert ("foreground-gdk", Foreground_Color_Mode_Column_Attribute);
      Wst.Insert ("background-gdk", Background_Color_Mode_Column_Attribute);
      Wst.Insert ("background-rgba", Background_Color_RGBA_Column_Attribute);
      Wst.Insert ("foreground-rgba", Foreground_Color_RGBA_Column_Attribute);
      Wst.Insert ("font", Font_Column_Attribute);
      Wst.Insert ("family", Font_Family_Column_Attribute);
      --  Wst.Insert ("variant", Font_Variant_Column_Attribute);
      --  Wst.Insert ("weight", Font_Weight_Column_Attribute);
      --  Wst.Insert ("stretch", Font_Strech_Column_Attribute);
      --  Wst.Insert ("size", Font_Size_Column_Attribute);
      Wst.Insert ("size-points", Font_Points_Column_Attribute);
      --  Wst.Insert ("scale", Font_Scale_Column_Attribute);
      Wst.Insert ("editable", Editable_Column_Attribute);
      --  Wst.Insert ("strikethrough", Strikethrough_Column_Attribute);
      --  Wst.Insert ("underline", Underline_Column_Attribute);
      Wst.Insert ("rise", Rise_Column_Attribute);
      Wst.Insert ("language", Language_Column_Attribute);
      Wst.Insert ("ellipsize", Ellipsize_Column_Attribute);
      Wst.Insert ("wrap-mode", Wrap_Mode_Column_Attribute);
   --  cellrenderertoggle
      Wst.Insert ("activatable", Activatable_Column_Attribute);
      Wst.Insert ("active", Toggle_State_Column_Attribute);
      Wst.Insert ("radio", Radio_State_Column_Attribute);
      Wst.Insert ("inconsistent", Inconsistent_State_Column_Attribute);
      Wst.Insert ("indicator-size", Indicator_Size_Column_Attribute);
   end Initialize_Attribute_Symbol_Table;

   function Is_Integer_Attribute (Attr : Attribute_Enum) return Boolean;
   function Is_Integer_Attribute (Attr : Attribute_Enum) return Boolean is
   begin
      case Attr is
         --  Pango / Font Metrics
         when Weight_Attribute                 |
              Size_Attribute                   |
              Absolute_Size_Attribute          |
              Font_Points_Column_Attribute     |
              Rise_Column_Attribute            |

            --  Metrics / Dimensions
              H_Padding_Column_Attribute       |
              V_Padding_Column_Attribute       |
              Width_Column_Attribute           |
              Height_Column_Attribute          |
              Width_Chars_Column_Attribute     |
              Max_Width_Chars_Attribute        |
              Wrap_Width_Mode_Column_Attribute |
              Indicator_Size_Column_Attribute  |

            --  Column Mapping Indices
              Visible_Column_Attribute         |
              Sensitive_Column_Attribute       |
              Text_Columm_Attribute            |
              Markup_Column_Attribute          |
              Editable_Column_Attribute        |
              Activatable_Column_Attribute     |
              Toggle_State_Column_Attribute    |
              Radio_State_Column_Attribute     |
              Inconsistent_State_Column_Attribute =>
            return True;

         when others =>
            return False;
      end case;
   end Is_Integer_Attribute;

   procedure Get_Attribute (S : String; Att : Attribute) is
      use Attribute_Map;
      Crs : Cursor;
   begin
      Crs := Attribute_Symbol_Table.Find (S);
      if Crs = No_Element then
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": Unknown attribute " & S);
         Att.Attr := Unknown_Attribute;
         Att.Is_Integer := False;
      else
         Att.Attr := Crs.Element;
         Att.Is_Integer := Is_Integer_Attribute (Crs.Element);
      end if;
   end Get_Attribute;

   --------------------------------------------------------------------------
   -- Handlers  --
   --------------------------------------------------------------------------
   package Handler_Set is new Ada.Containers.Indefinite_Hashed_Sets
     (Element_Type        => String,
      Hash                => Hash,
      Equivalent_Elements => Key_Equal,
      "="                 => "=");

   Handler_Symbol_Table : Handler_Set.Set;

   function Insert_Handler (H : String) return Boolean is
   begin
      Handler_Symbol_Table.Insert (H);
      return True;
   exception
         when Constraint_Error => return False;
   end Insert_Handler;

   --------------------------------------------------------------------------
   -- Initialize  --
   --------------------------------------------------------------------------

   procedure Initialize is
   begin
      Initialize_Node_Symbol_Table;
      Initialize_Signal_Symbol_Table;
      Initialize_Property_Symbol_Table;
      Initialize_Attribute_Symbol_Table;
   end Initialize;

end G2a.Symbol_Tables;

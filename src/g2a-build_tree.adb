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

with GNATCOLL.Utils;
with GNATCOLL.Tribooleans;
with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Strings.Fixed;
with GNAT.OS_Lib;
with GNAT.Regpat;      use GNAT.Regpat;

with Glade_Scanner_Io;

with G2a.Symbol_Tables; use G2a.Symbol_Tables;
with G2a.GSignal;       use G2a.GSignal;
with G2a.GAttribute;    use G2a.GAttribute;
with G2a.GItem;         use G2a.GItem;
with G2a.GProperty;     use G2a.GProperty;
with G2a.GListcolumn;   use G2a.GListcolumn;
with G2a.Support;       use G2a.Support;
with G2a.GWidget;       use G2a.GWidget;

with G2a.GAdadatepicker;      use G2a.GAdadatepicker;
with G2a.GAdatimepicker;      use G2a.GAdatimepicker;
with G2a.GAction;             use G2a.GAction;
with G2a.GAccel_Group;        use G2a.GAccel_Group;
with G2a.GCheckbutton;        use G2a.GCheckbutton;
with G2a.GTogglebutton;       use G2a.GTogglebutton;
with G2a.GAlignment;          use G2a.GAlignment;
with G2a.GTreeviewcolumn;     use G2a.GTreeviewcolumn;
with G2a.GCellrenderer;       use G2a.GCellrenderer;
with G2a.GCellrenderertext;   use G2a.GCellrenderertext;
with G2a.GCellrenderertoggle; use G2a.GCellrenderertoggle;
with G2a.GTreeselection;      use G2a.GTreeselection;
with G2a.GTreeview;           use G2a.GTreeview;
with G2a.GScrolledwindow;     use G2a.GScrolledwindow;
with G2a.GNotebook;           use G2a.GNotebook;
with G2a.GSeparatortoolitem;  use G2a.GSeparatortoolitem;
with G2a.GToolitem;           use G2a.GToolitem;
with G2a.GToolbar;            use G2a.GToolbar;
with G2a.GSeparatormenuitem;  use G2a.GSeparatormenuitem;
with G2a.GImagemenuitem;      use G2a.GImagemenuitem;
with G2a.GMenubar;            use G2a.GMenubar;
with G2a.GMenu;               use G2a.GMenu;
with G2a.GMenuitem;           use G2a.GMenuitem;
with G2a.GRadiobutton;        use G2a.GRadiobutton;
with G2a.GCalendar;           use G2a.GCalendar;
with G2a.GAspectframe;        use G2a.GAspectframe;
with G2a.GFrame;              use G2a.GFrame;
with G2a.GWindow;             use G2a.GWindow;
with G2a.GTreemodelfilter;    use G2a.GTreemodelfilter;
with G2a.GTreemodelsort;      use G2a.GTreemodelsort;
with G2a.GTreestore;          use G2a.GTreestore;
with G2a.GListstore;          use G2a.GListstore;
with G2a.GImage;              use G2a.GImage;
with G2a.GBox;                use G2a.GBox;
with G2a.GComboboxtext;       use G2a.GComboboxtext;
with G2a.GCombobox;           use G2a.GCombobox;
with G2a.GFilechooserbutton;  use G2a.GFilechooserbutton;
with G2a.GLabel;              use G2a.GLabel;
with G2a.GEntry;              use G2a.GEntry;
with G2a.GFixed;              use G2a.GFixed;
with G2a.GFilechooserdialog;  use G2a.GFilechooserdialog;
with G2a.GButtonbox;          use G2a.GButtonbox;
with G2a.GButton;             use G2a.GButton;
with G2a.GFilefilter;         use G2a.GFilefilter;
with G2a.GEntrybuffer;        use G2a.GEntrybuffer;
with G2a.GDialog;             use G2a.GDialog;
with G2a.GObject;             use G2a.GObject;
with G2a.GSpinbutton;         use G2a.GSpinbutton;
with G2a.GAdjustment;         use G2a.GAdjustment;
with G2a.GColorButton;        use G2a.GColorButton;
with G2a.GGrid;               use G2a.GGrid;
with G2a.GPopover;            use G2a.GPopover;

package body G2a.Build_Tree is

   Packing_Activated : Boolean := False;
   Just_Closed_Child : Object  := null;

   Column_Number     : Integer := 0;
   HT                : Additional_Info;
   Identifier_Regexp : constant Pattern_Matcher := Compile ("^[a-zA-Z][a-zA-Z0-9_]*$");
   Pattern_Regexp    : constant Pattern_Matcher := Compile ("^[ _]+$");
   Integer_Regexp    : constant Pattern_Matcher := Compile ("^[+-]?[0-9]+$");
   Decimal_Regexp    : constant Pattern_Matcher :=
                         Compile ("^[+-]?[0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?$");
   Gtk3_Enum_Regexp  : constant Pattern_Matcher :=
                         Compile ("^[a-zA-Z][a-zA-Z0-9]*([_-][a-zA-Z0-9]+)*$");

   Wrong_Glade_File : exception;

   ---------------------------------------------------------------------------
   function Unquote (S : String) return String;
   function Unquote (S : String) return String is
   begin
      if S'Length > 2 then
         if S (S'First) = '"' and then S (S'Last) = '"' then
            return S (S'First + 1 .. S'Last - 1);
         else
            return S;
         end if;
      elsif S'Length = 2 then
         if S = """""" then
            return "";
         else
            return S;
         end if;
      else
         return S;
      end if;
   end Unquote;

   ---------------------------------------------------------------------------
   --  OBJECTS
   ---------------------------------------------------------------------------
   procedure Create_Object (GtkObjName : String; Idq : String) is
      ID : constant String := Unquote (Idq);
      N  : constant GTK_Enum := Get_Node_Type (GtkObjName);

      Act : Action;
      Acg : Accel_Group;
      Al  : Alignment;
      Afr : Aspectframe;
      Bx  : Box;
      But : Button;
      Bbx : Buttonbox;
      Cal : Calendar;
      Cbb : Combobox;
      Cbt : Comboboxtext;
      Kbt : Checkbutton;
      Cr  : Cellrenderertext;
      Crt : Cellrenderertoggle;
      Dlg : Dialog;
      Ebf : Entrybuffer;
      Ent : Entry_Ptr;
      Fcb : Filechooserbutton;
      Flf : Filefilter;
      Fcd : Filechooserdialog;
      Fxd : Fixed;
      Fr  : Frame;
      Img : Image;
      Imi : Imagemenuitem;
      Lab : Label;
      Lst : Liststore;
      Mn  : Menu;
      Mb  : Menubar;
      Mi  : Menuitem;
      Nb  : Notebook;
      Rbt : Radiobutton;
      Sw  : Scrolledwindow;
      Sti : Separatortoolitem;
      Smi : Separatormenuitem;
      Tgb : Togglebutton;
      Tb  : Toolbar;
      Ti  : Toolitem;
      Tmf : Treemodelfilter;
      Tms : Treemodelsort;
      Ts  : Treeselection;
      Tst : Treestore;
      Tv  : Treeview;
      Tc  : Treeviewcolumn;
      Win : Window;
      Spb : Spinbutton;
      Adj : Adjustment;
      Cbn : Colorbutton;
      Grd : Grid;
      Pov : Popover;
      Dtp : Adadatepicker;
      Tmp : Adatimepicker;

   begin

      if Produce_Log then
         Log (Create_Object, GtkObjName, ID);
      end if;
      if Idq = "" then
         if N = Gtk_Separator_Menu_Item then
            Stat (N) := Stat (N) + 1;
         end if;
      elsif N = Gtk_List_Store then
         if (not GNATCOLL.Utils.Ends_With (ID, "_Additional_Information")
             and not GNATCOLL.Utils.Ends_With (ID, "_Focus_List"))
         then
            Stat (N) := Stat (N) + 1;
         end if;
      else
         Stat (N) := Stat (N) + 1;
      end if;

      case N is
         when No_Node                  =>
            Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                                  & ": unknown object " & GtkObjName);
            GNAT.OS_Lib.OS_Exit (1);

         when Gtk_Accel_Group          =>
            Acg.Get_New (ID);
            Set_Parent (Acg, Current_Object);
            Set_Current_Object (Acg);

         when Gtk_Action               =>
            Act.Get_New (ID);
            Set_Parent (Act, Current_Object);
            Set_Current_Object (Act);

         when Gtk_Entry_Buffer         =>
            Ebf.Get_New (ID);
            Set_Parent (Ebf, Current_Object);
            Set_Current_Object (Ebf);

         when Gtk_File_Filter          =>
            Flf.Get_New (ID);
            Set_Parent (Flf, Current_Object);
            Set_Current_Object (Flf);

         when Gtk_Dialog               =>
            Dlg.Get_New (ID);
            Set_Parent (Dlg, Current_Object);
            Set_Current_Object (Dlg);

         when Gtk_Button               =>
            But.Get_New (ID);
            Set_Parent (But, Current_Object);
            Set_Current_Object (But);

         when Gtk_Button_Box           =>
            Bbx.Get_New (ID);
            Set_Parent (Bbx, Current_Object);
            Set_Current_Object (Bbx);

         when Gtk_File_Chooser_Dialog  =>
            Fcd.Get_New (ID);
            Set_Parent (Fcd, Current_Object);
            Set_Current_Object (Fcd);

         when Gtk_Fixed                =>
            Fxd.Get_New (ID);
            Set_Parent (Fxd, Current_Object);
            Set_Current_Object (Fxd);

         when Gtk_Entry                =>
            Ent.Get_New (ID);
            Set_Parent (Ent, Current_Object);
            Set_Current_Object (Ent);

         when Gtk_Label                =>
            Lab.Get_New (ID);
            Set_Parent (Lab, Current_Object);
            Set_Current_Object (Lab);

         when Gtk_File_Chooser_Button  =>
            Fcb.Get_New (ID);
            Set_Parent (Fcb, Current_Object);
            Set_Current_Object (Fcb);

         when Gtk_Combo_Box            =>
            Cbb.Get_New (ID);
            Set_Parent (Cbb, Current_Object);
            Set_Current_Object (Cbb);

         when Gtk_Combo_Box_Text       =>
            Cbt.Get_New (ID);
            Set_Parent (Cbt, Current_Object);
            Set_Current_Object (Cbt);

         when Gtk_Box                  =>
            Bx.Get_New (ID);
            Set_Parent (Bx, Current_Object);
            Set_Current_Object (Bx);

         when Gtk_Image                =>
            if ID = "" then
               Img.Get_New ("Gtk_Image_" & Current_Object.ID.all);
            else
               Img.Get_New (ID);
            end if;
            Set_Parent (Img, Current_Object);
            Set_Current_Object (Img);

         when Gtk_List_Store           =>
            Lst.Get_New (ID);
            Set_Parent (Lst, Current_Object);
            Set_Current_Object (Lst);
            Have_Stores := Have_Stores + 1;

         when Gtk_Tree_Store           =>
            Tst.Get_New (ID);
            Set_Parent (Tst, Current_Object);
            Set_Current_Object (Tst);
            Have_Stores := Have_Stores + 1;

         when Gtk_Tree_Model_Sort      =>
            Tms.Get_New (ID);
            Set_Parent (Tms, Current_Object);
            Set_Current_Object (Tms);

         when Gtk_Tree_Model_Filter    =>
            Tmf.Get_New (ID);
            Set_Parent (Tmf, Current_Object);
            Set_Current_Object (Tmf);

         when Gtk_Window               =>
            Win.Get_New (ID);
            Set_Parent (Win, Current_Object);
            Set_Current_Object (Win);

         when Gtk_Frame                =>
            Fr.Get_New (ID);
            Set_Parent (Fr, Current_Object);
            Set_Current_Object (Fr);

         when Gtk_Aspect_Frame         =>
            Afr.Get_New (ID);
            Set_Parent (Afr, Current_Object);
            Set_Current_Object (Afr);
            if GNATCOLL.Utils.Starts_With (ID, "Time_Picker") then
               Have_Time_Pickers := Have_Time_Pickers + 1;
            end if;

         when Gtk_Calendar             =>
            Cal.Get_New (ID);
            Set_Parent (Cal, Current_Object);
            Set_Current_Object (Cal);
            if GNATCOLL.Utils.Starts_With (ID, "Date_Picker") then
               Have_Date_Pickers := Have_Date_Pickers + 1;
            end if;

         when Gtk_Radio_Button         =>
            Rbt.Get_New (ID);
            Set_Parent (Rbt, Current_Object);
            Set_Current_Object (Rbt);

         when Gtk_Menu                 =>
            Mn.Get_New (ID);
            Set_Parent (Mn, Current_Object);
            Set_Current_Object (Mn);

         when Gtk_Menu_Bar             =>
            Mb.Get_New (ID);
            Set_Parent (Mb, Current_Object);
            Set_Current_Object (Mb);

         when Gtk_Menu_Item            =>
            Mi.Get_New (ID);
            Set_Parent (Mi, Current_Object);
            Set_Current_Object (Mi);

         when Gtk_Image_Menu_Item      =>
            Imi.Get_New (ID);
            Set_Parent (Imi, Current_Object);
            Set_Current_Object (Imi);

         when Gtk_Separator_Menu_Item  =>
            if ID = "" then
               Smi.Get_New
                 ("Gtk_Separator_Menu_Item"
                  & Ada.Strings.Fixed.Trim
                      (Stat (Gtk_Separator_Menu_Item)'Image,
                       Ada.Strings.Both));
            else
               Smi.Get_New (ID);
            end if;
            Set_Parent (Smi, Current_Object);
            Set_Current_Object (Smi);

         when Gtk_ToolBar              =>
            Tb.Get_New (ID);
            Set_Parent (Tb, Current_Object);
            Set_Current_Object (Tb);

         when Gtk_Tool_Item            =>
            Ti.Get_New (ID);
            Set_Parent (Ti, Current_Object);
            Set_Current_Object (Ti);

         when Gtk_Separator_Tool_Item  =>
            if ID = "" then
               Sti.Get_New
                 ("Gtk_Separator_Tool_Item"
                  & Ada.Strings.Fixed.Trim
                      (Stat (Gtk_Separator_Tool_Item)'Image,
                       Ada.Strings.Both));
            else
               Sti.Get_New (ID);
            end if;
            Set_Parent (Sti, Current_Object);
            Set_Current_Object (Sti);

         when Gtk_Notebook             =>
            Nb.Get_New (ID);
            Set_Parent (Nb, Current_Object);
            Set_Current_Object (Nb);

         when Gtk_Scrolled_Window      =>
            Sw.Get_New (ID);
            Set_Parent (Sw, Current_Object);
            Set_Current_Object (Sw);

         when Gtk_Tree_View            =>
            Tv.Get_New (ID);
            Set_Parent (Tv, Current_Object);
            Set_Current_Object (Tv);

         when Gtk_Tree_Selection       =>
            Ts.Get_New (ID);
            Set_Parent (Ts, Current_Object);
            Set_Current_Object (Ts);

         when Gtk_Cell_Renderer_Text   =>
            Cr.Get_New (ID);
            Set_Parent (Cr, Current_Object);
            Set_Current_Object (Cr);
            Stat (Gtk_Cell_Renderer) := Stat (Gtk_Cell_Renderer) + 1;

         when Gtk_Cell_Renderer_Toggle =>
            Crt.Get_New (ID);
            Set_Parent (Crt, Current_Object);
            Set_Current_Object (Crt);
            Stat (Gtk_Cell_Renderer) := Stat (Gtk_Cell_Renderer) + 1;

         when Gtk_Tree_View_Column     =>
            Tc.Get_New (ID);
            Set_Parent (Tc, Current_Object);
            Set_Current_Object (Tc);

         when Gtk_Alignment            =>
            Al.Get_New (ID);
            Set_Parent (Al, Current_Object);
            Set_Current_Object (Al);

         when Gtk_Toggle_Button        =>
            Tgb.Get_New (ID);
            Set_Parent (Tgb, Current_Object);
            Set_Current_Object (Tgb);

         when Gtk_Check_Button         =>
            Kbt.Get_New (ID);
            Set_Parent (Kbt, Current_Object);
            Set_Current_Object (Kbt);

         when Gtk_Spin_Button          =>
            Spb.Get_New (ID);
            Set_Parent (Spb, Current_Object);
            Set_Current_Object (Spb);

         when Gtk_Color_Button         =>
            Cbn.Get_New (ID);
            Set_Parent (Cbn, Current_Object);
            Set_Current_Object (Cbn);

         when Gtk_Adjustment           =>
            Adj.Get_New (ID);
            Set_Parent (Adj, Current_Object);
            Set_Current_Object (Adj);

         when Gtk_Grid                 =>
            Grd.Get_New (ID);
            Set_Parent (Grd, Current_Object);
            Set_Current_Object (Grd);

         when Gtk_Popover             =>
            Pov.Get_New (ID);
            Set_Parent (Pov, Current_Object);
            Set_Current_Object (Pov);

         when Ada_Date_Picker         =>
            Dtp.Get_New (ID);
            Set_Parent (Dtp, Current_Object);
            Set_Current_Object (Dtp);

         when Ada_Time_Picker         =>
            Tmp.Get_New (ID);
            Set_Parent (Tmp, Current_Object);
            Set_Current_Object (Tmp);

         when others                   =>
            if Stat (N) = 1 then
               Ada.Text_IO.Put_Line (N'Image & " not Implemented");
               GNAT.OS_Lib.OS_Exit (1);
            end if;
      end case;
   end Create_Object;

   ---------------------------------------------------------------------------
   procedure Close_Current_Object is
      P  : access Object_Block'Class;
      Ob : constant Object := Current_Object;
   begin

      if Produce_Log then
         if Ob /= null and then Ob.ID /= null then
            Log (Close_Object, "", Ob.ID.all);
         else
            Log (Close_Object, "", "");
         end if;
      end if;
      Just_Closed_Child := Ob;
      P := Current_Object_Parent;
      Set_Current_Object (P);

   exception
      when Constraint_Error =>
         null;
   end Close_Current_Object;

   ---------------------------------------------------------------------------
   --  SIGNALS
   ---------------------------------------------------------------------------
   procedure Attach_Signal
     (Name      : String;
      Handler   : String;
      User_Data : String;
      Swap      : String;
      After     : String)
   is
      Obj : constant Object := Current_Object;
      S   : Signal;
      use GNATCOLL.Tribooleans;
   begin
      if Obj = null then
         return;
      end if;
      if Produce_Log then
         Log (Attach_Signal, Name, Handler);
      end if;
      S.Get_New
        (Signal_Name => Unquote (Name),
         Handler     => Unquote (Handler),
         User_Data   => Unquote (User_Data),
         Swap        => (if Swap = "yes" then True else False),
         After       => (if After = "yes" then True else False),
         Proc        => To_Boolean (Get_Signal (Name)));
      Obj.Signals.Append (S);
      Have_Signals := Have_Signals + 1;
      if Name = "realize" then
         Have_Signal_Realize := Have_Signal_Realize + 1;
      end if;
   end Attach_Signal;

   ---------------------------------------------------------------------------
   --  ATTRIBUTES
   ---------------------------------------------------------------------------
   procedure Attributes_Start is
   begin
      if Produce_Log then
         Log (Start_Attributes, "", "");
      end if;
   end Attributes_Start;

   ---------------------------------------------------------------------------
   procedure Attributes_End is
   begin
      if Produce_Log then
         Log (End_Attributes, "", "");
      end if;
   end Attributes_End;

   ---------------------------------------------------------------------------
   procedure Append_Attribute (Att : Attribute);
   procedure Append_Attribute (Att : Attribute) is
   begin
      if Current_Object.Gtk_Class = Gtk_Cell_Renderer then
         declare
            Obj : constant Cellrenderer := Cellrenderer (Current_Object);
         begin
            Obj.Attributes.Append (Att);
            Obj.Process_Attribute (Att);
         end;
      elsif Current_Object.Gtk_Class = Gtk_Cell_Renderer_Text then
         declare
            Obj : constant Cellrenderertext :=
              Cellrenderertext (Current_Object);
         begin
            Obj.Attributes.Append (Att);
            Obj.Process_Attribute (Att);
         end;
      elsif Current_Object.Gtk_Class = Gtk_Cell_Renderer_Toggle then
         declare
            Obj : constant Cellrenderertoggle :=
              Cellrenderertoggle (Current_Object);
         begin
            Obj.Attributes.Append (Att);
            Obj.Process_Attribute (Att);
         end;
      elsif Current_Object.Gtk_Class = Gtk_Label then
         declare
            Obj : constant Label := Label (Current_Object);
         begin
            Obj.Attributes.Append (Att);
            Obj.Process_Attribute (Att);
         end;
      end if;
   end Append_Attribute;

   ---------------------------------------------------------------------------
   procedure Attach_Attribute (Name : String; Value : String) is
      Att       : Attribute;
      Unq_Name  : constant String := Unquote (Name);
      Unq_Value : constant String := Unquote (Value);
   begin
      if Produce_Log then
         Log (Attach_String_Attribute, Unq_Name, Unq_Value);
      end if;

      Att.Get_New (Unq_Name);

      Get_Attribute (Att.Name.all, Att);
      if Current_Object.Gtk_Class = Gtk_Label then
         if Unq_Name = "weight" then
            Att.Is_Integer := False;
         end if;
      end if;

      if Att.Is_Integer then
         if Match (Integer_Regexp, Unq_Value) then
            Att.Integer_Value := Integer'Value (Unq_Value);
         else
            Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                                  & ": Attribute '" & Unq_Name
                                  & "' must be an integer, got: '" & Unq_Value & "'");
            GNAT.OS_Lib.OS_Exit (1);
         end if;
      else
         Att.String_Value := new String'(Unq_Value);
      end if;

      Append_Attribute (Att);

      if Att.Name.all = "underline" then
         Have_Font_Underline := Have_Font_Underline + 1;
      end if;
   end Attach_Attribute;

   ---------------------------------------------------------------------------
   --  PROPERTIES
   ---------------------------------------------------------------------------
   procedure Process_Packing_Properties (Prop : Property);
   procedure Process_Packing_Properties (Prop : Property) is
      Aux_Grid : Grid;
   begin
      --  Current_Object.Packing_Properties.Append (Prop);
      Just_Closed_Child.Packing_Properties.Append (Prop);
      if Prop.Prop = Left_Attach_Property then
         if Current_Object.Gtk_Class = Gtk_Grid then
            Aux_Grid := Grid (Current_Object);
            Aux_Grid.Col_Count := Integer'Max (Prop.Integer_Value, Aux_Grid.Col_Count);
         end if;
      end if;
      if Prop.Prop = Top_Attach_Property then
         if Current_Object.Gtk_Class = Gtk_Grid then
            Aux_Grid := Grid (Current_Object);
            Aux_Grid.Row_Count := Integer'Max (Prop.Integer_Value, Aux_Grid.Row_Count);
         end if;
      end if;
   end Process_Packing_Properties;

   ---------------------------------------------------------------------------
   procedure Attach_Property (Name : String; Value : String) is
      Prop        : Property;
      True_Value  : Boolean;
      False_Value : Boolean;
      Unq_Value   : constant String := Unquote (Value);
      Unq_Name    : constant String := Unquote (Name);
   begin
      if Unq_Name = "action" then
         True_Value := True;
      end if;
      Prop.Get_New (Unq_Name);
      Get_Property (Prop.Name.all, Prop);

      if Current_Object.Gtk_Class = Gtk_Combo_Box or else
        Current_Object.Gtk_Class = Gtk_Combo_Box_Text
      then
         if Unq_Name = "active" then
            Prop.Flavor := Is_Integer;
         end if;
      elsif Current_Object.Gtk_Class = Gtk_Popover then
         if Unq_Name = "position" then
            Prop.Flavor := Is_Gtk3_Enum;
         end if;
      end if;

      case Prop.Flavor is
         when Is_Boolean =>
            True_Value := (Unq_Value = "yes"
                           or else Unq_Value = "Yes"
                           or else Unq_Value = "true"
                           or else Unq_Value = "True");
            if not True_Value then
               False_Value := (Unq_Value = "no"
                               or else Unq_Value = "No"
                               or else Unq_Value = "false"
                               or else Unq_Value = "False");
               if not False_Value then
                  Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                                        & ": " & Name & ": Wrong flavor ("
                                        & Prop.Flavor'Image
                                        & "), must be boolean");
                  GNAT.OS_Lib.OS_Exit (1);
               end if;
            end if;
            if Produce_Log then
               Log (Attach_Property_Boolean, Name, Value);
            end if;
            Prop.Boolean_Value := True_Value;

         when Is_Gtk3_Enum =>
            if Match (Gtk3_Enum_Regexp, Unq_Value) then
               if Produce_Log then
                  Log (Attach_Property_Identifier, Name, Value);
               end if;
               Prop.String_Value := new String'(Unq_Value);
               Prop.Text.Text := Prop.String_Value;
            else
               Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                                     & ": " & Name & ": value must be a Gtk3 option");
               GNAT.OS_Lib.OS_Exit (1);
            end if;

         when Is_Identifier =>
            if Match (Identifier_Regexp, Unq_Value) then
               if Produce_Log then
                  Log (Attach_Property_Identifier, Name, Value);
               end if;
               Prop.String_Value := new String'(Unq_Value);
               Prop.Text.Text := Prop.String_Value;
            else
               Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                                     & ": " & Name & ": value must be an identifier");
               GNAT.OS_Lib.OS_Exit (1);
            end if;

         when Is_Integer =>
            if Match (Integer_Regexp, Unq_Value) then
               if Produce_Log then
                  Log (Attach_Property_Integer, Name, Value);
               end if;
               Prop.Integer_Value := Integer'Value (Unq_Value);
            else
               Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                                     & ": " & Name & ": value must be an integer");
               GNAT.OS_Lib.OS_Exit (1);
            end if;

         when Is_Decimal =>
            if Match (Decimal_Regexp, Unq_Value) then
               if Produce_Log then
                  Log (Attach_Property_Decimal, Name, Value);
               end if;
               Prop.Decimal_Value := Float'Value (Unq_Value);
            else
               Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                                     & ": " & Name & ": value must be a decimal");
               GNAT.OS_Lib.OS_Exit (1);
            end if;

         when Is_String =>
            if Unq_Name = "pattern" then
               if not Match (Pattern_Regexp, Unq_Value) then
                  Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                                        & ": " & Name & ": value must be " & "[ _]+");
                  GNAT.OS_Lib.OS_Exit (1);
               end if;
            end if;
            if Produce_Log then
               Log (Attach_Property_String, Name, Value);
            end if;
            Prop.String_Value := new String'(Unq_Value);
            Prop.Text.Text := Prop.String_Value;

         when Unknown_Flavor =>
            null;
      end case;

      Prop.Text.Translatable := False;
      Prop.Text.Context := null;
      Prop.Text.Comments := null;

      if Packing_Activated then
         Process_Packing_Properties (Prop);
      else
         Current_Object.Properties.Append (Prop);
         Current_Object.Process_Property (Prop);
      end if;
   end Attach_Property;

   ---------------------------------------------------------------------------
   procedure Attach_Translatable_String_Property
     (Name         : String;
      Translatable : String;
      Value        : String;
      Context      : String := "";
      Comments     : String := "")
   is
      Prop      : Property;
      Unq_Trans : constant String := Unquote (Translatable);
      Trans     : constant Boolean :=
        (Unq_Trans = "yes"
         or else Unq_Trans = "Yes"
         or else Unq_Trans = "true"
         or else Unq_Trans = "True");
   begin
      if Produce_Log then
         Log
           (Attach_Property_String, Name, Value, 0, Context, Comments, Trans);
      end if;

      Prop.Get_New (Unquote (Name));
      Get_Property (Prop.Name.all, Prop);
      if Prop.Flavor /= Is_String then
         Ada.Text_IO.Put_Line ("Line" & Glade_Scanner_Io.Yy_Line_Number'Image
                               & ": " & Name & ": Wrong flavor ("
                               & Prop.Flavor'Image
                               & "), must be string");
         GNAT.OS_Lib.OS_Exit (1);
      end if;
      Prop.String_Value := new String'(Unquote (Value));
      Prop.Text.Text := Prop.String_Value;
      Prop.Text.Translatable := Trans;

      if Context /= "" then
         Prop.Text.Context := new String'(Unquote (Context));
      end if;
      if Comments /= "" then
         Prop.Text.Comments := new String'(Unquote (Comments));
      end if;

      if Packing_Activated then
         Process_Packing_Properties (Prop);
      else
         Current_Object.Properties.Append (Prop);
         Current_Object.Process_Property (Prop);
      end if;
   end Attach_Translatable_String_Property;

   ---------------------------------------------------------------------------
   --  ITEMS (for combobox)
   ---------------------------------------------------------------------------
   procedure Items_Start is
   begin
      if Produce_Log then
         Log (Start_Items, "", "");
      end if;
   end Items_Start;

   procedure Items_End is
   begin
      if Produce_Log then
         Log (End_Items, "", "");
      end if;
   end Items_End;

   procedure Attach_Item (Translatable : String;
                          Value        : String;
                          Context      : String := "";
                          Comments     : String := "") is
      Unq_Trans : constant String := Unquote (Translatable);
      Trans     : constant Boolean :=
                    (Unq_Trans = "yes"
                     or else Unq_Trans = "Yes"
                     or else Unq_Trans = "true"
                     or else Unq_Trans = "True");
   begin
      if Current_Object.Gtk_Class /= Gtk_Combo_Box_Text then
         Ada.Text_IO.Put_Line
           ("Widget "
            & Current_Object.ID.all
            & ": must be a comboboxtext to support items");
         raise Wrong_Glade_File;
      end if;

      if Produce_Log then
         Log (Oper         => This_Item,
              Name         => "",
              Id           => Value,
              CN           => 0,
              Context      => Context,
              Comments     => Comments,
              Translatable => Trans);
      end if;

      declare
         It : G2a.GItem.Item;
      begin
         G2a.GItem.Get_New (It, Value, Trans, Context, Comments);
         Comboboxtext (Current_Object).List_Of_Items.Append (It);
      end;
   end Attach_Item;

   ---------------------------------------------------------------------------
   --  COLUMNS
   ---------------------------------------------------------------------------
   procedure Append_Column (Col : Listcolumn);
   procedure Append_Column (Col : Listcolumn) is
   begin
      if Current_Object.Gtk_Class = Gtk_List_Store then
         declare
            Obj : constant Liststore := Liststore (Current_Object);
         begin
            Obj.Columns.Append (Col);
         end;
      elsif Current_Object.Gtk_Class = Gtk_Tree_Store then
         declare
            Obj : constant Treestore := Treestore (Current_Object);
         begin
            Obj.Columns.Append (Col);
         end;
      else
         Ada.Text_IO.Put_Line
           ("Widget "
            & Current_Object.ID.all
            & ": must be a list or treestore to support columns");
         raise Wrong_Glade_File;
      end if;
   end Append_Column;

   ---------------------------------------------------------------------------
   procedure Attach_Integer_Column (Name : String) is
      Col : Listcolumn;
   begin
      Col.Get_New (Name);
      Col.CType := Gint;
      Col.CNumber := Column_Number;
      if Produce_Log then
         Log (Attach_Column, Name, "float", Column_Number);
      end if;
      Column_Number := Column_Number + 1;
      Append_Column (Col);
   end Attach_Integer_Column;

   ---------------------------------------------------------------------------
   procedure Attach_Float_Column (Name : String) is
      Col : Listcolumn;
   begin
      Col.Get_New (Name);
      Col.CType := Gfloat;
      Col.CNumber := Column_Number;
      if Produce_Log then
         Log (Attach_Column, Name, "float", Column_Number);
      end if;
      Column_Number := Column_Number + 1;
      Append_Column (Col);
   end Attach_Float_Column;

   ---------------------------------------------------------------------------
   procedure Attach_Boolean_Column (Name : String) is
      Col : Listcolumn;
   begin
      Col.Get_New (Name);
      Col.CType := Gboolean;
      Col.CNumber := Column_Number;
      if Produce_Log then
         Log (Attach_Column, Name, "boolean", Column_Number);
      end if;
      Column_Number := Column_Number + 1;
      Append_Column (Col);
   end Attach_Boolean_Column;

   ---------------------------------------------------------------------------
   procedure Attach_String_Column (Name : String) is
      Col : Listcolumn;
   begin
      Col.Get_New (Name);
      Col.CType := Gchararray;
      Col.CNumber := Column_Number;
      if Produce_Log then
         Log (Attach_Column, Name, "chararray", Column_Number);
      end if;
      Column_Number := Column_Number + 1;
      Append_Column (Col);
   end Attach_String_Column;

   ---------------------------------------------------------------------------
   procedure Attach_Buttonbox_Column (Name : String) is
      Col : Listcolumn;
   begin
      Col.Get_New (Name);
      Col.CType := Gbuttonboxstyle;
      Col.CNumber := Column_Number;
      if Produce_Log then
         Log (Attach_Column, Name, "buttonbox", Column_Number);
      end if;
      Column_Number := Column_Number + 1;
      Append_Column (Col);
   end Attach_Buttonbox_Column;

   ---------------------------------------------------------------------------
   procedure Restart_Column_Number is
   begin
      Column_Number := 0;
   end Restart_Column_Number;

   ---------------------------------------------------------------------------
   --  LISTSTORES
   ---------------------------------------------------------------------------
   procedure Attach_Liststore_Data_Start is
      use GNATCOLL.Utils;
   begin
      if Current_Object.Gtk_Class = Gtk_List_Store
        and then Ends_With (Current_Object.ID.all, "_Focus_List")
      then
         Set_Liststore_Focus (Liststore (Current_Object));
      end if;
   end Attach_Liststore_Data_Start;

   ---------------------------------------------------------------------------
   procedure Attach_Liststore_Row_Data_Start (Col_Name : String) is
      use GNATCOLL.Utils;
   begin
      if Current_Object.Gtk_Class /= Gtk_List_Store then
         Ada.Text_IO.Put_Line
           ("Widget "
            & Current_Object.ID.all
            & ": must be a liststore to support data");
         raise Wrong_Glade_File;
      end if;

      if (not Ends_With (Current_Object.ID.all, "_Additional_Information"))
        and (not Ends_With (Current_Object.ID.all, "_Focus_List"))
      then
         Ada.Text_IO.Put_Line
           ("Widget "
            & Current_Object.ID.all
            & ": ID should end "
            & """_Additional_Information"""
            & " or "
            & """_Focus_List""");
         raise Wrong_Glade_File;
      end if;

      HT := new Additional_Info_Block;
      HT.Lst_Name := Current_Object.ID;
      HT.Name := new String'(Col_Name);
      if Produce_Log then
         Log (Attach_Additional_Information, HT.Name.all, "");
      end if;
   end Attach_Liststore_Row_Data_Start;

   ---------------------------------------------------------------------------
   procedure Attach_Liststore_Row_Data (Col_Number : String; Col_Data : String)
   is
      Number : Integer;
      Last   : Positive;
      use Ada.Strings.Fixed;
   begin
      Ada.Integer_Text_IO.Get (Col_Number, Number, Last);
      case Number is
         when 0      =>
            null;  --  already done

         when 1      =>
            HT.Aux := new String'(Col_Data);
            if HT.Name.all = "ALT_BG" then
               if Produce_Log then
                  Log
                    (Attach_Additional_Information,
                     HT.Name.all,
                     "ALT_BG " & Col_Data);
               end if;
            else
               Have_Header_Column_Tooltips := Have_Header_Column_Tooltips + 1;
               if Produce_Log then
                  Log
                    (Attach_Additional_Information,
                     HT.Name.all,
                     "tooltip=" & Col_Data);
               end if;
            end if;

         when 2      =>
            if Index (Col_Data, ".") not in Col_Data'Range then
               HT.Xalign := new String'(Col_Data & ".0");
               if Produce_Log then
                  Log
                    (Attach_Additional_Information,
                     HT.Name.all,
                     "xalign " & Col_Data & ".0");
               end if;
            else
               HT.Xalign := new String'(Col_Data);
               if Produce_Log then
                  Log
                    (Attach_Additional_Information,
                     HT.Name.all,
                     "xalign " & Col_Data);
               end if;
            end if;

         when 3      =>
            if Index (Col_Data, ".") not in Col_Data'Range then
               HT.Yalign := new String'(Col_Data & ".0");
               if Produce_Log then
                  Log
                    (Attach_Additional_Information,
                     HT.Name.all,
                     "yalign " & Col_Data & ".0");
               end if;
            else
               HT.Yalign := new String'(Col_Data);
               if Produce_Log then
                  Log
                    (Attach_Additional_Information,
                     HT.Name.all,
                     "yalign " & Col_Data);
               end if;
            end if;

         when 4      =>
            HT.Xpad := new String'(Col_Data);
            if Produce_Log then
               Log
                 (Attach_Additional_Information,
                  HT.Name.all,
                  "xpad " & Col_Data);
            end if;

         when 5      =>
            HT.Ypad := new String'(Col_Data);
            if Produce_Log then
               Log
                 (Attach_Additional_Information,
                  HT.Name.all,
                  "ypad " & Col_Data);
            end if;

         when 6      =>
            HT.Foreground := new String'(Col_Data);
            if Produce_Log then
               Log
                 (Attach_Additional_Information,
                  HT.Name.all,
                  "foreground " & Col_Data);
            end if;

         when 7      =>
            HT.Background := new String'(Col_Data);
            if Produce_Log then
               Log
                 (Attach_Additional_Information,
                  HT.Name.all,
                  "background " & Col_Data);
            end if;

         when 8      =>
            HT.Selforeground := new String'(Col_Data);
            if Produce_Log then
               Log
                 (Attach_Additional_Information,
                  HT.Name.all,
                  "selforeground " & Col_Data);
            end if;

         when 9      =>
            HT.Selbackground := new String'(Col_Data);
            if Produce_Log then
               Log
                 (Attach_Additional_Information,
                  HT.Name.all,
                  "selbackground " & Col_Data);
            end if;

         when 10     =>
            if Col_Data = "True" then
               HT.Underline := new String'("Pango_Underline_Single");
            else
               HT.Underline := new String'("Pango_Underline_None");
            end if;
            if Produce_Log then
               Log
                 (Attach_Additional_Information,
                  HT.Name.all,
                  "underline " & Col_Data);
            end if;

         when 11     =>
            HT.Font_Name := new String'(Col_Data);
            if Produce_Log then
               Log
                 (Attach_Additional_Information,
                  HT.Name.all,
                  "font_name " & Col_Data);
            end if;

         when 12     =>
            HT.Font_Weight := new String'(Col_Data);
            if Produce_Log then
               Log
                 (Attach_Additional_Information,
                  HT.Name.all,
                  "font_weight " & Col_Data);
            end if;

         when 13     =>
            HT.Font_Size := new String'(Col_Data);
            if Produce_Log then
               Log
                 (Attach_Additional_Information,
                  HT.Name.all,
                  "font size " & Col_Data);
            end if;

         when others =>
            null;
      end case;
   end Attach_Liststore_Row_Data;

   ---------------------------------------------------------------------------
   procedure Attach_Liststore_Row_Data_End is
   begin
      Liststore (Current_Object).Data.Append (HT);
   end Attach_Liststore_Row_Data_End;

   ---------------------------------------------------------------------------
   procedure Attach_Liststore_Data_End is
   begin
      null;
   end Attach_Liststore_Data_End;

   ---------------------------------------------------------------------------
   --  PACKING
   ---------------------------------------------------------------------------
   procedure Packing_Start is
   begin
      if Produce_Log then
         Log (Start_Packing, "", "");
      end if;
      Packing_Activated := True;
   end Packing_Start;

   ---------------------------------------------------------------------------
   procedure Packing_End is
   begin
      if Produce_Log then
         Log (End_Packing, "", "");
      end if;
      Packing_Activated := False;
   end Packing_End;

   ---------------------------------------------------------------------------
   --  MIME TYPES AND PATTERNS
   ---------------------------------------------------------------------------
   procedure Attach_Mime_Type (Name : String) is
   begin
      if Current_Object.Gtk_Class /= Gtk_File_Filter then
         return;
      end if;
      if Produce_Log then
         Log (Attach_Mime_Type, Name);
      end if;
      Filefilter (Current_Object).Mime_Types.Append (new String'(Name));
   end Attach_Mime_Type;

   ---------------------------------------------------------------------------
   procedure Attach_Pattern (Name : String) is
   begin
      if Current_Object.Gtk_Class /= Gtk_File_Filter then
         return;
      end if;
      if Produce_Log then
         Log (Attach_Pattern, Name);
      end if;
      Filefilter (Current_Object).Patterns.Append (new String'(Name));
   end Attach_Pattern;

end G2a.Build_Tree;

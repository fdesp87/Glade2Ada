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
with Ada.Characters.Handling;    use Ada.Characters.Handling;

with G2a.Support;                use G2a.Support;

package body G2a.Emit_Ada.Main_Window is

   package TIO renames Ada.Text_IO;

   ---------------------------------------------------------------------------
   procedure Emit_Main_Package (Capitalized_Filename : String) is
   begin
      Log ("Generating Main Package...");
      Include_Banner;
      Emit_With_Use ("Gtkada.Builder");
      Emit_Package_Spec (Capitalized_Filename & "_Pkg");
      TIO.Put_Line (Sp (3) & "Builder : Gtkada_Builder;");
      Emit_Package_End (Capitalized_Filename & "_Pkg");
   end Emit_Main_Package;

   ---------------------------------------------------------------------------
   procedure Emit_Main_Program (Capitalized_Filename : String) is
   begin
      Log ("Generating Main Program...");
      Include_Banner;
      TIO.Put_Line ("with Gtk.Main;");
      TIO.Put_Line ("with " & Capitalized_Filename & "_Pkg.Main_Windows;");
      if Stat (Ada_Date_Picker) + Stat (Ada_Time_Picker) > 0 then
         Emit_Without_Use ("Glib");
      end if;
      if Stat (Ada_Date_Picker) > 0 then
         Emit_Without_Use ("Gtk_Ada_Date_Picker");
      end if;
      if Stat (Ada_Time_Picker) > 0 then
         Emit_Without_Use ("Gtk_Ada_Time_Picker");
      end if;
      Insert_Your_Code (0, Capitalized_Filename);
      TIO.New_Line;
      TIO.Put_Line ("procedure " & Capitalized_Filename & " is");
      if Stat (Ada_Date_Picker) > 0 then
         TIO.Put_Line (Sp (3) & "Date_GType : GType;");
      end if;
      if Stat (Ada_Time_Picker) > 0 then
         TIO.Put_Line (Sp (3) & "Time_GType : GType;");
      end if;
      TIO.Put_Line ("begin");
      TIO.New_Line;
      Insert_Your_Code (3, Capitalized_Filename);
      TIO.Put_Line (Sp (3) & "Gtk.Main.Init;");
      if Stat (Ada_Date_Picker) > 0 then
         TIO.Put_Line (Sp (3) & "Date_GType := Gtk_Ada_Date_Picker.Get_Type;");
      end if;
      if Stat (Ada_Time_Picker) > 0 then
         TIO.Put_Line (Sp (3) & "Time_GType := Gtk_Ada_Time_Picker.Get_Type;");
      end if;
      Insert_Your_Code (3, Capitalized_Filename);
      TIO.Put_Line (Sp (3) & Capitalized_Filename & "_Pkg.Main_Windows.Initialize;");
      TIO.Put_Line (Sp (3) & "Gtk.Main.Main;");
      Insert_Your_Code (3, Capitalized_Filename);
      Emit_Package_End (Capitalized_Filename);
   end Emit_Main_Program;

   ---------------------------------------------------------------------------
   procedure Emit_Main_Window (Capitalized_Filename : String;
                               Has_Main_Window      : Boolean;
                               Window_Name          : String) is
   begin
      Log ("Generating Main Window...");
      Include_Banner;
      if Has_Main_Window then
         Emit_Package_Spec (Capitalized_Filename & "_Pkg.Main_Windows");
         TIO.Put_Line (Sp (3) & "procedure Initialize;");
      else
         Emit_With_Use ("Gtk.Window");
         Emit_Package_Spec (Capitalized_Filename & "_Pkg.Main_Windows");
         TIO.Put_Line (Sp (3) & "procedure Initialize "
                       & "(Parent : access Gtk_Window_Record'Class);");
      end if;
      Emit_Package_End (Capitalized_Filename & "_Pkg.Main_Windows");

      Include_Banner;
      Emit_With_Use (Capitalized_Filename & "_Pkg.Object_Collection");
      if Have_Signals > 0 then
         Emit_With_Use (Capitalized_Filename & "_Pkg.Register_Signals");
      end if;
      if Stat (Gtk_Cell_Renderer) > 0 then
         Emit_With_Use (Capitalized_Filename & "_Pkg.Cell_Renderers");
      end if;
      Emit_With_Use ("Ada.Text_IO");
      TIO.Put_Line ("with Gtk.Main;");
      if Has_Main_Window then
         Emit_With_Use ("Gtk.Style_Provider");
         Emit_With_Use ("Gtkada.Style");
      end if;
      Emit_With_Use ("Gtk.Widget");
      Emit_With_Use ("Gtkada.Builder");
      Emit_With_Use ("Gtk.Dialog");
      Emit_With_Use ("Gtkada.Dialogs");
      TIO.Put_Line ("with Glib;");
      Emit_With_Use ("Glib.Object");
      Emit_With_Use ("Glib.Error");

      Emit_Package_Body (Capitalized_Filename & "_Pkg.Main_Windows", True);
      TIO.Put_Line (Sp (3) & "Glade_Filename : constant String :=");
      TIO.Put_Line (Sp (6) & Quoted (G2a.Glade_Full_FileName.all) & ";");
      TIO.New_Line;
      TIO.Put_Line (Sp (3) & "procedure Report_Glade_Error (Err : GError);");
      TIO.Put_Line (Sp (3) & "procedure Report_Glade_Error (Err : GError) is");
      TIO.Put_Line (Sp (6) & "Dialog : Gtk_Dialog;");
      TIO.Put_Line (Sp (6) & "Resp   : Gtk_Response_Type;");
      TIO.Put_Line (Sp (3) & "begin");
      TIO.Put_Line (Sp (6) & "Dialog := Create_Gtk_Dialog");
      TIO.Put_Line (Sp (8) & "(Msg         => "
                    & Quoted ("Error [Create_Builder]: ")
                    & " & Get_Message (Err),");
      TIO.Put_Line (Sp (8) & " Dialog_Type => Error,");
      TIO.Put_Line (Sp (8) & " Title       => "
                    & Quoted ("Glade Error") & ");");
      TIO.Put_Line (Sp (6) & "Dialog.Show_All;");
      TIO.Put_Line (Sp (6) & "Resp := Dialog.Run;");
      TIO.Put_Line (Sp (6) & "Dialog.Destroy;");
      TIO.Put_Line (Sp (3) & "end Report_Glade_Error;");
      TIO.New_Line;
      if Has_Main_Window then
         TIO.Put_Line (Sp (3) & "procedure Initialize is");
      else
         TIO.Put_Line (Sp (3) & "procedure Initialize "
                       & "(Parent : access Gtk_Window_Record'Class) is");
      end if;
      TIO.Put_Line (Sp (6) & "Error : aliased GError;");
      TIO.Put_Line (Sp (6) & "use Glib;");
      TIO.Put_Line (Sp (3) & "begin");
      TIO.New_Line;
      TIO.Put_Line (Sp (6) & "--  create a builder");
      TIO.Put_Line (Sp (6) & "if Builder /= null then");
      TIO.Put_Line (Sp (9) & "Unref (Builder);");
      TIO.Put_Line (Sp (6) & "end if;");

      TIO.Put_Line (Sp (6) & "Gtk_New (Builder);");
      TIO.New_Line;
      TIO.Put_Line (Sp (6) & "--  read the glade");
      TIO.Put_Line (Sp (6) & "if Add_From_File (Builder, "
                    & "Glade_Filename, "
                    & "Error'Access) = 0 then");
      TIO.Put_Line (Sp (9) & "Put_Line (""Error [Create_Builder]: "" & "
                    & "Get_Message (Error));");
      TIO.Put_Line (Sp (9) & "Report_Glade_Error (Error);");
      TIO.Put_Line (Sp (9) & "Error_Free (Error);");
      TIO.Put_Line (Sp (9) & "Gtk.Main.Main_Quit;");
      TIO.Put_Line (Sp (6) & "end if;");
      TIO.New_Line;
      if Has_Main_Window then
         TIO.Put_Line (Sp (6) & "--  load the css");
         TIO.Put_Line (Sp (6) & "Load_Css_File");
         TIO.Put_Line (Sp (8)
                       & "("
                       & Quoted (Ada_Dir.all & "/"
                         & To_Lower (Capitalized_Filename)
                         & ".css") & ",");
         TIO.Put_Line (Sp (9) & "Ada.Text_IO.Put_Line'Access,");
         TIO.Put_Line (Sp (9)
                       & "Priority_User);"
                       & " --  Priority_User is important!!!");
         TIO.New_Line;
      end if;
      TIO.Put_Line (Sp (6) & "--  Initialize Widgets_Collection");
      TIO.Put_Line (Sp (6) & "Me := "
                    & Capitalized_Filename & "_Pkg.Object_Collection."
                    & "New_Widget_Collection;");
      if Stat (Gtk_Cell_Renderer) > 0 then
         TIO.New_Line;
         TIO.Put_Line (Sp (6) & "--  Initialize Cell Renderers");
         TIO.Put_Line (Sp (6) & Capitalized_Filename & "_Pkg.Cell_Renderers.Initialize;");
      end if;
      if Have_Signals > 0 then
         TIO.New_Line;
         TIO.Put_Line (Sp (6) & "--  Register signal handlers");
         TIO.Put_Line (Sp (6) & "Register_Signals.Register (Builder);");
      end if;
      TIO.New_Line;
      TIO.Put_Line (Sp (6) & "Builder.Do_Connect;");
      Insert_Your_Code (6, "Initialize");
      TIO.Put_Line (Sp (6) & "--  display");
      if not Has_Main_Window then
         TIO.Put_Line (Sp (6) & "Gtk_Window");
         TIO.Put_Line (Sp (8) & "(Builder.Get_Object ("
                       & Quoted (Window_Name)
                       & ")).Set_Transient_For (Parent);");
      end if;
      TIO.Put_Line (Sp (6) & "Gtk_Widget");
      TIO.Put_Line (Sp (8) & "(Builder.Get_Object ("
                    & Quoted (Window_Name)
                    & ")).Show_All;");
      TIO.New_Line;
      if Stat (Gtk_Tree_View) > 0
        and then
          Stat (Gtk_Cell_Renderer_Text) + Stat (Gtk_Cell_Renderer_Toggle) > 0
        and then Stat (Gtk_Tree_View_Column) > 0
      then
         TIO.Put_Line (Sp (6) & "--  eventually set treeviews styles");
         TIO.Put_Line (Sp (6) & "Set_All_Treeviews_Styles;");
         TIO.New_Line;
      end if;
      TIO.Put_Line (Sp (3) & "end Initialize;");
      Emit_Package_End (Capitalized_Filename & "_Pkg.Main_Windows");
   end Emit_Main_Window;

end G2a.Emit_Ada.Main_Window;

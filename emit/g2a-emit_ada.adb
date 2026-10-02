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
with Ada.Directories;            use Ada.Directories;
with GNATCOLL.Utils;             use GNATCOLL.Utils;

with G2a.GNode;
with G2a.Backups;                use G2a.Backups;
with G2a.Support;                use G2a.Support;
with G2a.Version;
with G2a.GWindow;                use G2a.GWindow;
with G2a.GRadiobutton;           use G2a.GRadiobutton;
with G2a.GWidget;                use G2a.GWidget;
with G2a.GSignal;

with G2a.Emit_Ada.Cell_Renderers;    use G2a.Emit_Ada.Cell_Renderers;
with G2a.Emit_Ada.Gpr_Css;           use G2a.Emit_Ada.Gpr_Css;
with G2a.Emit_Ada.Main_Window;       use G2a.Emit_Ada.Main_Window;
with G2a.Emit_Ada.Object_Collection; use G2a.Emit_Ada.Object_Collection;
with G2a.Emit_Ada.Register_Signals;  use G2a.Emit_Ada.Register_Signals;
with G2a.Emit_Ada.Signals;           use G2a.Emit_Ada.Signals;
with G2a.Emit_Ada.Store_Enum;        use G2a.Emit_Ada.Store_Enum;

package body G2a.Emit_Ada is
   package TIO renames Ada.Text_IO;

   use G2a.GNode.Node_Tree_Pkg;

   Max_Gen            : Integer := 1;
   AdaFile            : TIO.File_Type;
   Has_Main_Window    : Boolean := False;
   With_Form_Closing  : Boolean := False;
   TWin               : Window  := null;

   ---------------------------------------------------------------------------
   function Sp (N : Integer) return String is
   begin
      if N > 0 then
         return (1 .. N => ' ');
      else
         return "";
      end if;
   end Sp;

   ---------------------------------------------------------------------------
   procedure Insert_Your_Code (Spaces : Integer;
                               Marker : String) is
   begin
      TIO.Put_Line (Sp (Spaces) & "--  INSERT YOUR CODE HERE"
                    & " [" & Marker & "]");
      TIO.Put_Line (Sp (Spaces) & "--  END OF INSERT YOUR CODE"
                    & " [" & Marker & "]");
   end Insert_Your_Code;

   ---------------------------------------------------------------------------
   procedure Include_Banner is
      --  version'lenght = 5
   begin
      TIO.New_Line;
      TIO.Put_Line ("--------------------------------------");
      TIO.Put_Line ("--  generated with glade2ada " & G2a.Version.Version & "  --");
      TIO.Put_Line ("--------------------------------------");
      TIO.New_Line;
   end Include_Banner;

   ---------------------------------------------------------------------------
   function Quoted (M : String) return String is
   begin
      return """" & M & """";
   end Quoted;

   ---------------------------------------------------------------------------
   procedure Emit_Package_Spec (Pkgname : String;
                                Prev_Line : Boolean := True) is
   begin
      Insert_Your_Code (0, Pkgname);
      if Prev_Line then
         TIO.New_Line;
      end if;
      TIO.Put_Line ("package " & Pkgname & " is");
      TIO.New_Line;
   end Emit_Package_Spec;

   ---------------------------------------------------------------------------
   procedure Emit_Package_Body (Pkgname  : String;
                                Prev_Line : Boolean := True) is
   begin
      Insert_Your_Code (0, Pkgname);
      if Prev_Line then
         TIO.New_Line;
      end if;
      TIO.Put_Line ("package body " & Pkgname & " is");
      TIO.New_Line;
   end Emit_Package_Body;

   ---------------------------------------------------------------------------
   procedure Emit_Package_End (Pkgname  : String;
                               Prev_Line : Boolean := True) is
   begin
      if Prev_Line then
         TIO.New_Line;
      end if;
      TIO.Put_Line ("end " & Pkgname & ";");
   end Emit_Package_End;

   ---------------------------------------------------------------------------
   procedure Emit_With_Use (Pkg : String) is
   begin
      TIO.Put_Line ("with " & Pkg & ";" & " use " & Pkg & ";");
   end Emit_With_Use;

   ---------------------------------------------------------------------------
   procedure Emit_Without_Use (Pkg : String) is
   begin
      TIO.Put_Line ("with " & Pkg & ";");
   end Emit_Without_Use;

   ---------------------------------------------------------------------------
   function Date_Picker_Name (Obj : not null Object) return String is
   begin
      case Obj.Gtk_Class is
         when Gtk_Box =>
            return Extract (Obj.ID.all, "", "_Vbox");
         when Gtk_Button =>
               return Extract (Obj.ID.all, "", "_Button");
         when Gtk_Calendar =>
               return Extract (Obj.ID.all, "", "_Calendar");
         when Gtk_Entry =>
            if Ends_With (Obj.ID.all, "_Year_Entry") then
               return Extract (Obj.ID.all, "", "_Year_Entry");
            elsif Ends_With (Obj.ID.all, "_Month_Entry") then
               return Extract (Obj.ID.all, "", "_Month_Entry");
            elsif Ends_With (Obj.ID.all, "_Day_Entry") then
               return Extract (Obj.ID.all, "", "_Day_Entry");
            else
               raise Program_Error with "Wrong date picker entry name";
            end if;
         when others =>
            return Obj.ID.all;
      end case;
   end Date_Picker_Name;

   ---------------------------------------------------------------------------
   function Is_Date_Picker (Obj : not null Object) return Boolean is
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         if Obj.Gtk_Class = Gtk_Box and then
           Starts_With (Obj.ID.all, "Date_Picker") and then
           Ends_With (Obj.ID.all, "_Vbox")
         then
            return True;
         end if;
      end if;
      return False;
   end Is_Date_Picker;

   ---------------------------------------------------------------------------
   function Is_Date_Picker_Calendar (Obj : not null Object) return Boolean is
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         if Obj.Gtk_Class = Gtk_Calendar and then
           Starts_With (Obj.ID.all, "Date_Picker") and then
           Ends_With (Obj.ID.all, "_Calendar")
         then
            return True;
         end if;
      end if;
      return False;
   end Is_Date_Picker_Calendar;

   ---------------------------------------------------------------------------
   function Is_Date_Picker_Button (Obj : not null Object) return Boolean is
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         if Obj.Gtk_Class = Gtk_Button and then
           Starts_With (Obj.ID.all, "Date_Picker") and then
           Ends_With (Obj.ID.all, "_Button")
         then
            return True;
         end if;
      end if;
      return False;
   end Is_Date_Picker_Button;

   ---------------------------------------------------------------------------
   function Is_Date_Picker_Year_Entry (Obj : not null Object) return Boolean is
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         if Obj.Gtk_Class = Gtk_Entry and then
           Starts_With (Obj.ID.all, "Date_Picker") and then
           Ends_With (Obj.ID.all, "_Year_Entry")
         then
            return True;
         end if;
      end if;
      return False;
   end Is_Date_Picker_Year_Entry;

   ---------------------------------------------------------------------------
   function Is_Date_Picker_Month_Entry (Obj : not null Object) return Boolean is
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         if Obj.Gtk_Class = Gtk_Entry and then
           Starts_With (Obj.ID.all, "Date_Picker") and then
           Ends_With (Obj.ID.all, "_Month_Entry")
         then
            return True;
         end if;
      end if;
      return False;
   end Is_Date_Picker_Month_Entry;

   ---------------------------------------------------------------------------
   function Is_Date_Picker_Day_Entry (Obj : not null Object) return Boolean is
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         if Obj.Gtk_Class = Gtk_Entry and then
           Starts_With (Obj.ID.all, "Date_Picker") and then
           Ends_With (Obj.ID.all, "_Day_Entry")
         then
            return True;
         end if;
      end if;
      return False;
   end Is_Date_Picker_Day_Entry;

   ---------------------------------------------------------------------------
   function Is_Time_Picker (Obj : not null Object) return Boolean is
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         if Obj.Gtk_Class = Gtk_Aspect_Frame and then
           Starts_With (Obj.ID.all, "Time_Picker") and then
           Ends_With (Obj.ID.all, "_AspectFrame")
         then
            return True;
         end if;
      end if;
      return False;
   end Is_Time_Picker;

   ---------------------------------------------------------------------------
   function Is_Time_Picker_Button (Obj : not null Object) return Boolean is
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         if Obj.Gtk_Class = Gtk_Button and then
           Starts_With (Obj.ID.all, "Time_Picker") and then
           Contains (Obj.ID.all, "_Button_")
         then
            return True;
         end if;
      end if;
      return False;
   end Is_Time_Picker_Button;

   ---------------------------------------------------------------------------
   function Is_Time_Picker_Hour_Entry (Obj : not null Object) return Boolean is
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         if Obj.Gtk_Class = Gtk_Entry and then
           Starts_With (Obj.ID.all, "Time_Picker") and then
           Ends_With (Obj.ID.all, "_Hour_Entry")
         then
            return True;
         end if;
      end if;
      return False;
   end Is_Time_Picker_Hour_Entry;

   ---------------------------------------------------------------------------
   function Is_Time_Picker_Min_Entry (Obj : not null Object) return Boolean is
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         if Obj.Gtk_Class = Gtk_Entry and then
           Starts_With (Obj.ID.all, "Time_Picker") and then
           Ends_With (Obj.ID.all, "_Min_Entry")
         then
            return True;
         end if;
      end if;
      return False;
   end Is_Time_Picker_Min_Entry;

   ---------------------------------------------------------------------------
   function Is_Time_Picker_Sec_Entry (Obj : not null Object) return Boolean is
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         if Obj.Gtk_Class = Gtk_Entry and then
           Starts_With (Obj.ID.all, "Time_Picker") and then
           Ends_With (Obj.ID.all, "_Sec_Entry")
         then
            return True;
         end if;
      end if;
      return False;
   end Is_Time_Picker_Sec_Entry;

   ---------------------------------------------------------------------------
   function Time_Picker_Name (Obj : not null Object) return String is
   begin
      case Obj.Gtk_Class is
         when Gtk_Aspect_Frame =>
            return Extract (Obj.ID.all, "", "_AspectFrame");
         when Gtk_Button =>
            if Ends_With (Obj.ID.all, "_Hour_Button_Up") then
               return Extract (Obj.ID.all, "", "_Hour_Button_Up");
            elsif Ends_With (Obj.ID.all, "_Hour_Button_Down") then
               return Extract (Obj.ID.all, "", "_Hour_Button_Down");
            elsif Ends_With (Obj.ID.all, "_Min_Button_Up") then
               return Extract (Obj.ID.all, "", "_Min_Button_Up");
            elsif Ends_With (Obj.ID.all, "_Min_Button_Down") then
               return Extract (Obj.ID.all, "", "_Min_Button_Down");
            elsif Ends_With (Obj.ID.all, "_Sec_Button_Up") then
               return Extract (Obj.ID.all, "", "_Sec_Button_Up");
            elsif Ends_With (Obj.ID.all, "_Sec_Button_Down") then
               return Extract (Obj.ID.all, "", "_Sec_Button_Down");
            else
               raise Program_Error with "wrong time picker button";
            end if;
         when Gtk_Entry =>
            if Ends_With (Obj.ID.all, "_Hour_Entry") then
               return Extract (Obj.ID.all, "", "_Hour_Entry");
            elsif Ends_With (Obj.ID.all, "_Min_Entry") then
               return Extract (Obj.ID.all, "", "_Min_Entry");
            elsif Ends_With (Obj.ID.all, "_Sec_Entry") then
               return Extract (Obj.ID.all, "", "_Sec_Entry");
            else
               raise Program_Error with "Wrong time picker entry name";
            end if;
         when others =>
            return Obj.ID.all;
      end case;
   end Time_Picker_Name;

   ---------------------------------------------------------------------------
   procedure Set_Main_Window_And_Form_Closing;
   procedure Set_Main_Window_And_Form_Closing is

      procedure Process (Position : Cursor);
      procedure Process (Position : Cursor) is
         Obj : constant Object := Object (Position.Element);
         Crs : G2a.GSignal.Signal_List_Pkg.Cursor;
         use type G2a.GSignal.Signal_List_Pkg.Cursor;
      begin
         if Obj.Gtk_Class = Gtk_Window then
            Has_Main_Window  := G2a.Produce_Main;
            if TWin = null then
               TWin := Window (Obj);
            end if;
         elsif Obj.Gtk_Class = Gtk_Dialog then
            Has_Main_Window  := G2a.Produce_Main;
            if TWin = null then
               TWin := Window (Obj);
            end if;
         end if;

         if Obj.Gtk_Class = Gtk_Window or Obj.Gtk_Class = Gtk_Dialog then
            Crs := Obj.Signals.First;
            while Crs /= G2a.GSignal.Signal_List_Pkg.No_Element loop
               if Ends_With (Crs.Element.Handler.all,
                             "_Formclosing")
               then
                  With_Form_Closing := True;
                  exit;
               end if;
               Crs := Crs.Next;
            end loop;
         end if;
      end Process;

   begin
      Iterate (Process'Access);
   end Set_Main_Window_And_Form_Closing;

   ---------------------------------------------------------------------------
   function Generate_Ada_Packages return Integer is
      Status   : Integer;
      Filename : constant String :=
                   Base_Name (Simple_Name (Glade_Full_FileName.all));
   begin

      Set_Main_Window_And_Form_Closing;
      if TWin = null then
         TIO.Put_Line ("No main window or dialog Found");
         return -1;
      end if;

      Generate_Backups (Ada_Dir.all, To_Lower (Filename),
                        G2a.Produce_Main, Max_Gen);

      Log ("");
      Log ("Generating Ada files...");

      begin
         TIO.Create (File => AdaFile,
                     Mode => TIO.Out_File,
                     Name => Ada_Dir.all & "/" & Filename & ".TempAda");
      exception
         when others =>
            TIO.Put_Line ("Could'nt create temporal file "
                          & Ada_Dir.all & "/" & Filename & ".TempAda");
            return -1;
      end;
      TIO.Set_Output (AdaFile);
      --  NO TEXT_IO UNTIL RESET  --

      if G2a.Produce_Main then
         Log ("Generating main Ada program...");
         Emit_Main_Program (Capitalize (Filename));
      end if;
      Emit_Main_Package (Capitalize (Filename));
      Emit_Main_Window (Capitalize (Filename),
                        Has_Main_Window,
                        (if TWin.Name /= null then TWin.Name.all else TWin.ID.all));
      if Has_Main_Window then
         Gpr_Css.CSS (Ada_Dir.all, To_Lower (Filename));
      end if;
      Object_Collection.Emit (Capitalize (Filename));
      if Have_Signals > 0 then
         Signals.Emit (Capitalize (Filename),
                       With_Form_Closing, Has_Main_Window,
                       TWin.Gtk_Class);
         Register_Signals.Emit (Capitalize (Filename));
      end if;
      if Stat (Gtk_Cell_Renderer) > 0 then
         Cell_Renderers.Emit (Capitalize (Filename));
      end if;
      if Stat (Gtk_List_Store) + Stat (Gtk_Tree_Store) > 0 then
         Store_Enum.Emit (Capitalize (Filename));
      end if;
      TIO.Set_Output (TIO.Standard_Output);
      --  TIO RESETTED

      TIO.Close (AdaFile);

      if G2a.Produce_Main then
         Gpr_Css.GPR (Ada_Dir.all, To_Lower (Filename));
      end if;

      Log ("End of Generating Ada files...");

      Log ("");
      Status := Perform_Chop (Ada_Dir.all, Filename);
      if Status = 0 then
         Delete_File (Ada_Dir.all & "/" & Filename & ".TempAda");
         Log ("Deleting " & Ada_Dir.all & "/" & Filename & ".TempAda");

         Status := Generate_Diffs (Ada_Dir.all,
                                   To_Lower (Filename),
                                   G2a.Produce_Main,
                                   Max_Gen);
      else
         TIO.Put_Line ("Error in temporal Ada file "
                       & Ada_Dir.all & "/" & Filename & ".TempAda");
      end if;
      return Status;
   end Generate_Ada_Packages;

end G2a.Emit_Ada;

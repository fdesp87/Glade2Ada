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
with Ada.Directories;            use Ada.Directories;
with GNATCOLL.Arg_Lists;         use GNATCOLL.Arg_Lists;
with GNAT.OS_Lib;                use GNAT.OS_Lib;
with GNAT.Expect;                use GNAT.Expect;
with GNATCOLL.Utils;             use GNATCOLL.Utils;

with G2a.Support;                use G2a.Support;

package body G2a.Backups is

   package TIO renames Ada.Text_IO;

   --------------------
   --  Perform_Chop  --
   --------------------

   function Perform_Chop (Ada_Path  : String;
                          Filename  : String) return Integer is
      Status : aliased Integer;
      Args   : Argument_List (1 .. 4);
   begin
      Args (1) := new String'("-v");
      --  Args (1) := new String'("-q");
      Args (2) := new String'("-w");
      Args (3) := new String'(Ada_Path & "/" & Filename & ".TempAda");
      Args (4) := new String'(Ada_Path);
      declare
         Output : constant String := Get_Command_Output
           (Command    => "/opt/GNAT/15.1.0-2/bin/gnatchop",
            Arguments  => Args,
            Input      => "",
            Status     => Status'Access,
            Err_To_Out => True);
      begin
         if Output /= "" then
            Log (Output);
         end if;

         if Status /= 0 then
            Log ("FAILED to execute command: "
                   & "gnatchop "
                   & Argument_List_To_String (Args));
         end if;
         Free (Args);
         return Status;
      exception
         when Invalid_Process =>
            Free (Args);
            TIO.Put_Line ("FAILED to spawn gnatchop");
            return -1;
      end;
   end Perform_Chop;

   ---------------------
   --  Perform Patch  --
   ---------------------

   --  function Perform_Patch (The_Path          : String;
   --                          Filename_With_Ext : String) return Integer is
   --     Status    : aliased Integer;
   --     Args      : Argument_List (1 .. 3);
   --  begin
   --     Args (1) := new String'("--verbose");
   --     --  Args (1) := new String'("-s");
   --     Args (2) := new String'(The_Path & "/" & Filename_With_Ext);
   --     Args (3) := new String'(Args (2).all & ".patch");
   --        Log ("patch " & Args (1).all
   --               & " " & Args (2).all
   --               & " " & Args (3).all);
   --     declare
   --        Output : constant String := Get_Command_Output
   --          (Command    => "/usr/bin/patch",
   --           Arguments  => Args,
   --           Input      => "",
   --           Status     => Status'Access,
   --           Err_To_Out => True);
   --     begin
   --        if Status /= 0 then
   --           Log ("FAILED to execute command: "
   --                  & "/usr/bin/patch "
   --                  & Argument_List_To_String (Args)
   --                  & " status " & Img (Status));
   --        else
   --           Log (Sp (3) & "patched " & Output);
   --        end if;
   --        Free (Args);
   --        return Status;
   --     exception
   --        when Invalid_Process =>
   --           Free (Args);
   --           Log ("FAILED to spawn patch");
   --           return -1;
   --     end;
   --  end Perform_Patch;

   --------------------
   --  Perform Diff  --
   --------------------

   function Perform_Diff (The_Path          : String;
                          Filename_With_Ext : String;
                          Max_Gen           : Integer) return Integer;

   function Perform_Diff (The_Path          : String;
                          Filename_With_Ext : String;
                          Max_Gen           : Integer) return Integer is
      Status    : aliased Integer;
      Args      : Argument_List (1 .. 2);
      PatchFile : TIO.File_Type;
   begin
      Args (1) := new String'(The_Path & "/" & Filename_With_Ext);
      Args (2) := new String'(Args (1).all & "~" & Img (Max_Gen));
      Log ("diff " & Args (1).all & " " & Args (2).all);
      declare
         Output : constant String := Get_Command_Output
           (Command    => "/usr/bin/diff",
            Arguments  => Args,
            Input      => "",
            Status     => Status'Access,
            Err_To_Out => True);
      begin
         case Status is
            when 0 =>
               Log ("  files identical, no patching");
            when 1 =>
               if Output /= "" then
                  TIO.Create (File => PatchFile,
                              Mode => TIO.Out_File,
                              Name => The_Path & "/"
                              & Filename_With_Ext & ".patch");
                  TIO.Put (PatchFile, Output);
                  TIO.Close (PatchFile);
                  --  Status := Perform_Patch (The_Path, Filename_With_Ext);
                  Log ("Patch file generated. Review the patch and use"
                         & " it to recover changes");
                  Log ("");
               end if;
            when 2 =>
               Log ("FAILED To Execute Command: "
                      & "/usr/bin/diff "
                      & Argument_List_To_String (Args)
                      & " status " & Img (Status));
            when others =>
               Log ("FAILED To Execute Command: "
                      & "/usr/bin/diff "
                      & Argument_List_To_String (Args)
                      & " status " & Img (Status));
         end case;
         Free (Args);

         return Status;

      exception
         when Invalid_Process =>
            Free (Args);
            Log ("FAILED to spawn patch");
            return -1;
      end;
   end Perform_Diff;

   -------------------
   --  Get_Max_Gen  --
   -------------------

   procedure Get_Max_Gen (Gen_Filename : String;
                          The_Max_Gen  : in out Integer);
   procedure Get_Max_Gen (Gen_Filename : String;
                          The_Max_Gen  : in out Integer) is
      Gen : Integer := The_Max_Gen - 1;
   begin
      loop
         Gen := Gen + 1;
         exit when not Exists (Gen_Filename & "~" & Img (Gen));
      end loop;
      The_Max_Gen := Integer'Max (The_Max_Gen, Gen);
   end Get_Max_Gen;

   -------------------
   --  Make_Backup  --
   -------------------

   procedure Make_Backup (Result            : out Integer;
                          Complete_Filename : String;
                          Max_Gen           : Integer;
                          Use_Log           : Boolean := True);

   procedure Make_Backup (Result            : out Integer;
                          Complete_Filename : String;
                          Max_Gen           : Integer;
                          Use_Log           : Boolean := True) is
   begin
      if Exists (Complete_Filename) then
         Rename (Complete_Filename,
                 Complete_Filename & "~" & Img (Max_Gen));
         if Use_Log then
            Log (Complete_Filename
                   & " renamed to "
                   & Complete_Filename & "~" & Img (Max_Gen));
         end if;
         Result := 1;
      else
         Result := 0;
      end if;
   end Make_Backup;

   ------------------------
   --  Generate Backups  --
   ------------------------

   procedure Generate_Backups (The_Path     : String;
                               Filename     : String;
                               Main_Program : Boolean;
                               Max_Gen      : in out Integer) is
      Result : Integer;
   begin
      Log ("");
      Log ("Generating Ada backups...");

      if Main_Program then
         Get_Max_Gen (The_Path & "/" & Filename & ".gpr", Max_Gen);
         Get_Max_Gen (The_Path & "/" & Filename & ".adb", Max_Gen);
         Get_Max_Gen (The_Path & "/" & Filename & ".css", Max_Gen);
      end if;
      Get_Max_Gen (The_Path & "/" & Filename & "_pkg.ads", Max_Gen);
      Get_Max_Gen (The_Path & "/" & Filename & "_pkg-main_windows.ads", Max_Gen);
      Get_Max_Gen (The_Path & "/" & Filename & "_pkg-main_windows.adb", Max_Gen);
      Get_Max_Gen (The_Path & "/" & Filename & "_pkg-object_collection.ads", Max_Gen);
      Get_Max_Gen (The_Path & "/" & Filename & "_pkg-object_collection.adb", Max_Gen);
      if Have_Signals > 0 then
         Get_Max_Gen (The_Path & "/" & Filename & "_pkg-register_signals.ads", Max_Gen);
         Get_Max_Gen (The_Path & "/" & Filename & "_pkg-register_signals.adb", Max_Gen);
         Get_Max_Gen (The_Path & "/" & Filename & "_pkg-signals.ads", Max_Gen);
         Get_Max_Gen (The_Path & "/" & Filename & "_pkg-signals.adb", Max_Gen);
      end if;
      if Have_Stores > 0 then
         Get_Max_Gen (The_Path & "/" & Filename & "_pkg-stores_enum.ads", Max_Gen);
         Get_Max_Gen (The_Path & "/" & Filename & "_pkg-cell_renderers.ads", Max_Gen);
         Get_Max_Gen (The_Path & "/" & Filename & "_pkg-cell_renderers.adb", Max_Gen);
      end if;

      if Main_Program then
         Make_Backup (Result, The_Path & "/" & Filename & ".gpr", Max_Gen);
         Make_Backup (Result, The_Path & "/" & Filename & ".adb", Max_Gen);
         Make_Backup (Result, The_Path & "/" & Filename & ".css", Max_Gen);
      end if;
      Make_Backup (Result, The_Path & "/" & Filename & "_pkg.ads", Max_Gen);
      Make_Backup (Result, The_Path & "/" & Filename & "_pkg-main_windows.ads", Max_Gen);
      Make_Backup (Result, The_Path & "/" & Filename & "_pkg-main_windows.adb", Max_Gen);
      Make_Backup (Result, The_Path & "/" & Filename & "_pkg-object_collection.ads", Max_Gen);
      Make_Backup (Result, The_Path & "/" & Filename & "_pkg-object_collection.adb", Max_Gen);
      if Have_Signals > 0 then
         Make_Backup (Result, The_Path & "/" & Filename & "_pkg-register_signals.ads", Max_Gen);
         Make_Backup (Result, The_Path & "/" & Filename & "_pkg-register_signals.adb", Max_Gen);
         Make_Backup (Result, The_Path & "/" & Filename & "_pkg-signals.ads", Max_Gen);
         Make_Backup (Result, The_Path & "/" & Filename & "_pkg-signals.adb", Max_Gen);
      end if;
      if Have_Stores > 0 then
         Make_Backup (Result, The_Path & "/" & Filename & "_pkg-stores_enum.ads", Max_Gen);
         Make_Backup (Result, The_Path & "/" & Filename & "_pkg-cell_renderers.ads", Max_Gen);
         Make_Backup (Result, The_Path & "/" & Filename & "_pkg-cell_renderers.adb", Max_Gen);
      end if;

      Log ("End of Generating Ada backups");

   exception
      when Name_Error =>
         TIO.Put_Line ("Cannot rename old generated files");
   end Generate_Backups;

   ----------------------
   --  Generate Diffs  --
   ----------------------

   function Generate_Diffs (The_Path       : String;
                            Lower_Filename : String;
                            Main_Program   : Boolean;
                            Max_Gen        : Integer) return Integer is
      Status : Integer;
   begin
      Log ("");
      Log ("Obtaining diffs");

      if Main_Program then
         Status := Perform_Diff (The_Path,
                                 Lower_Filename
                                 & ".gpr",
                                 Max_Gen);
         if Status in 0 .. 2 then
            Status := Perform_Diff (The_Path,
                                    Lower_Filename
                                    & ".adb",
                                    Max_Gen);
         end if;
         if Status in 0 .. 2 then
            Status := Perform_Diff (The_Path,
                                    Lower_Filename
                                    & ".css",
                                    Max_Gen);
         end if;
      end if;
      if Status in 0 .. 2 then
         Status := Perform_Diff (The_Path,
                                 Lower_Filename
                                 & "_pkg.ads",
                                 Max_Gen);
      end if;
      if Status in 0 .. 2 then
         Status := Perform_Diff (The_Path,
                                 Lower_Filename
                                 & "_pkg-main_windows.ads",
                                 Max_Gen);
      end if;
      if Status in 0 .. 2 then
         Status := Perform_Diff (The_Path,
                                 Lower_Filename
                                 & "_pkg-main_windows.adb",
                                 Max_Gen);
      end if;
      if Status in 0 .. 2 then
         Status := Perform_Diff (The_Path,
                                 Lower_Filename
                                 & "_pkg-object_collection.ads",
                                 Max_Gen);
      end if;
      if Status in 0 .. 2 then
         Status := Perform_Diff (The_Path,
                                 Lower_Filename
                                 & "_pkg-object_collection.adb",
                                 Max_Gen);
      end if;
      if Status in 0 .. 2 then
         Status := Perform_Diff (The_Path,
                                 Lower_Filename
                                 & "_pkg-register_signals.ads",
                                 Max_Gen);
      end if;
      if Status in 0 .. 2 then
         Status := Perform_Diff (The_Path,
                                 Lower_Filename
                                 & "_pkg-register_signals.adb",
                                 Max_Gen);
      end if;
      if Status in 0 .. 2 then
         Status := Perform_Diff (The_Path,
                                 Lower_Filename
                                 & "_pkg-signals.ads",
                                 Max_Gen);
      end if;
      if Status in 0 .. 2 then
         Status := Perform_Diff (The_Path,
                                 Lower_Filename
                                 & "_pkg-signals.adb",
                                 Max_Gen);
      end if;
      if Status in 0 .. 2 then
         if Have_Stores > 0 then
            Status := Perform_Diff (The_Path,
                                    Lower_Filename
                                    & "_pkg-stores_enum.ads",
                                    Max_Gen);
            if Status in 0 .. 2 then
               Status := Perform_Diff (The_Path,
                                       Lower_Filename
                                       & "_pkg-cell_renderers.ads",
                                       Max_Gen);
            end if;
            if Status in 0 .. 2 then
               Status := Perform_Diff (The_Path,
                                       Lower_Filename
                                       & "_pkg-cell_renderers.adb",
                                       Max_Gen);
            end if;
         end if;
      end if;
      Log ("End of obtaining diffs");
      return Status;
   end Generate_Diffs;

end G2a.Backups;

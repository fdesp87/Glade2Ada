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

with G2a.GNode;
with G2a.GObject;                use G2a.GObject;
with G2a.GSignal;
with G2a.Support;                use G2a.Support;

package body G2a.Emit_Ada.Register_Signals is

   package TIO renames Ada.Text_IO;

   use G2a.GNode.Node_Tree_Pkg;

   ---------------------------------------------------------------------------
   procedure Emit_Register_All_Signals_For_Windows (Position : Cursor);
   procedure Emit_Register_All_Signals_For_Windows (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);

      use G2a.GSignal;
      use Signal_List_Pkg;
      Crs : Signal_List_Pkg.Cursor;
      TS  : Signal;
   begin
      if not (Obj.Gtk_Class = Gtk_Window or Obj.Gtk_Class = Gtk_Dialog) then
         return;
      end if;

      Crs := Obj.Signals.First;
      while Crs /= Signal_List_Pkg.No_Element loop
         TS := Crs.Element;

         TIO.Put_Line (Sp (6) & "Register_Handler");
         TIO.Put_Line (Sp (9) & "(Builder      => Builder,");
         TIO.Put_Line (Sp (10) & "Handler_Name =>");
         TIO.Put_Line (Sp (13) & Quoted (TS.Handler.all) & ",");
         TIO.Put_Line (Sp (10) & "Handler      =>");
         TIO.Put_Line (Sp (13) & TS.Handler.all & "'Access);");

         Crs := Crs.Next;
         TIO.New_Line;
      end loop;
   end Emit_Register_All_Signals_For_Windows;

   ---------------------------------------------------------------------------
   procedure Emit_Register_All_Signals_For_Widgets (Position : Cursor);
   procedure Emit_Register_All_Signals_For_Widgets (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);

      use G2a.GSignal;
      use Signal_List_Pkg;
      Crs : Signal_List_Pkg.Cursor;
      TS  : Signal;
   begin
      if Obj.Gtk_Class = Gtk_Window or Obj.Gtk_Class = Gtk_Dialog then
         return;
      end if;

      Crs := Obj.Signals.First;
      while Crs /= Signal_List_Pkg.No_Element loop
         TS := Crs.Element;
         if TS.Emit then
            TIO.Put_Line (Sp (6) & "Register_Handler");
            TIO.Put_Line (Sp (9) & "(Builder      => Builder,");
            TIO.Put_Line (Sp (10) & "Handler_Name =>");
            TIO.Put_Line (Sp (13) & Quoted (TS.Handler.all) & ",");
            TIO.Put_Line (Sp (10) & "Handler      =>");
            TIO.Put_Line (Sp (13) & TS.Handler.all & "'Access);");
            TIO.New_Line;
         end if;
         Crs := Crs.Next;
      end loop;
   end Emit_Register_All_Signals_For_Widgets;

   ---------------------------------------------------------------------------
   procedure Emit (Capitalized_Filename : String) is
   begin
      Log ("Generating Register of Signals...");
      Include_Banner;
      Emit_With_Use ("Gtkada.Builder");
      Emit_Package_Spec (Capitalized_Filename & "_Pkg.Register_Signals");
      TIO.Put_Line (Sp (3) & "procedure Register"
                    & " (Builder : Gtkada.Builder.Gtkada_Builder);");
      Emit_Package_End (Capitalized_Filename & "_Pkg.Register_Signals");

      Include_Banner;
      Emit_With_Use (Capitalized_Filename & "_Pkg.Signals");
      Emit_Package_Body (Capitalized_Filename & "_Pkg.Register_Signals", True);
      TIO.Put_Line (Sp (3) & "procedure Register"
                    & " (Builder : Gtkada.Builder.Gtkada_Builder) is");
      TIO.Put_Line (Sp (3) & "begin");
      Iterate (Emit_Register_All_Signals_For_Windows'Access);
      Iterate (Emit_Register_All_Signals_For_Widgets'Access);
      TIO.Put_Line (Sp (3) & "end Register;");
      Emit_Package_End (Capitalized_Filename & "_Pkg.Register_Signals");
   end Emit;

end G2a.Emit_Ada.Register_Signals;

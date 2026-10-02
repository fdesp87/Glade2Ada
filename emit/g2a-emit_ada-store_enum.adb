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
with GNATCOLL.Utils;             use GNATCOLL.Utils;

with G2a.GNode;
with G2a.GObject;                use G2a.GObject;
with G2a.GListcolumn;
with G2a.GListstore;             use G2a.GListstore;
with G2a.GTreestore;             use G2a.GTreestore;
with G2a.Support;                use G2a.Support;

package body G2a.Emit_Ada.Store_Enum is

   package TIO renames Ada.Text_IO;

   use G2a.GNode.Node_Tree_Pkg;

   ---------------------------------------------------------------------------
   procedure Process_Store (Position : Cursor);
   procedure Process_Store (Position : Cursor) is
      Obj : constant Object := Object (Position.Element);

      use G2a.GListcolumn;
      use Listcolumn_List_Pkg;
      Crs : Listcolumn_List_Pkg.Cursor;
      Col : Listcolumn;
      Emitted : Boolean := False;
   begin
      if Obj.Gtk_Class = Gtk_List_Store and then
        (not Ends_With (Obj.ID.all, "_Additional_Information") and
             not Ends_With (Obj.ID.all, "_Focus_List"))
      then
         Crs := Liststore (Obj).Columns.First;
         if Crs /= Listcolumn_List_Pkg.No_Element then
            Emitted := True;
            Col := Crs.Element;
            TIO.New_Line;
            TIO.Put_Line (Sp (3) & "type "
                          & Liststore (Obj).ID.all & "_Enum" & " is");
            TIO.Put (Sp (5) & "(" & Col.Name.all);
            Crs := Crs.Next;
         end if;

         while Crs /= Listcolumn_List_Pkg.No_Element loop
            Col := Crs.Element;
            TIO.Put_Line (",");
            TIO.Put (Sp (6) & Col.Name.all);
            Crs := Crs.Next;
         end loop;

      elsif Obj.Gtk_Class = Gtk_Tree_Store then
         Crs := Treestore (Obj).Columns.First;
         if Crs /= Listcolumn_List_Pkg.No_Element then
            Emitted := True;
            Col := Crs.Element;
            TIO.New_Line;
            TIO.Put_Line (Sp (3) & "type "
                          & Treestore (Obj).ID.all & "_Enum" & " is");
            TIO.Put (Sp (5) & "(" & Col.Name.all);
            Crs := Crs.Next;
         end if;

         while Crs /= Listcolumn_List_Pkg.No_Element loop
            Col := Crs.Element;
            TIO.Put_Line (",");
            TIO.Put (Sp (6) & Col.Name.all);
            Crs := Crs.Next;
         end loop;

      else
         return;
      end if;

      if Emitted then
         TIO.Put_Line (");");
         TIO.New_Line;
         TIO.Put_Line (Sp (3) & "function ""+"" (X : "
                       & Obj.ID.all & "_Enum" & ")");
         TIO.Put_Line (Sp (16) & "return Gint is");
         TIO.Put_Line (Sp (5) & "("
                       & Obj.ID.all & "_Enum"
                       & "'Pos (X));");
      else
         TIO.Put_Line (Sp (3) & "--  empty");
      end if;
   end Process_Store;

   ---------------------------------------------------------------------------
   procedure Emit (Capitalized_Filename : String) is
   begin
      Log ("Generating Stores Enum...");

      Include_Banner;
      Emit_With_Use ("Glib");
      Emit_Package_Spec (Capitalized_Filename & "_Pkg.Stores_Enum");

      Iterate (Process_Store'Access);

      Emit_Package_End (Capitalized_Filename & "_Pkg.Stores_Enum");
   end Emit;


end G2a.Emit_Ada.Store_Enum;

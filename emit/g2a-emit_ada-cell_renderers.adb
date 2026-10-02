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
with G2a.GTreeview;              use G2a.GTreeview;
with G2a.GTreeviewcolumn;        use G2a.GTreeviewcolumn;
with G2a.GListstore;             use G2a.GListstore;
with G2a.Support;                use G2a.Support;

package body G2a.Emit_Ada.Cell_Renderers is

   package TIO renames Ada.Text_IO;

   use G2a.GNode.Node_Tree_Pkg;

   ---------------------------------------------------------------------------
   procedure Process_Cell_Renderer (Position : Cursor);
   procedure Process_Cell_Renderer (Position : Cursor) is
      Obj : constant Object  := Object (Position.Element);
   begin
      case Obj.Gtk_Class is
         when Gtk_Cell_Renderer_Text | Gtk_Cell_Renderer_Toggle =>
            null;
         when others =>
            return;
      end case;

      declare
         Col : constant Treeviewcolumn := Treeviewcolumn (Parent (Obj));
         Tvw : constant Treeview := Treeview (Parent (Col));
         Lst_Name_List : constant String := "GtkListStore_"
                           & Tvw.ID.all & "_Additional_Information";
         Lst_Name_Tree : constant String := "GtkTreeStore_"
                           & Tvw.ID.all & "_Additional_Information";
         Lst : Liststore;
      begin
         Lst := Find_Liststore (Lst_Name_List);
         if Lst = null then
            Lst := Find_Liststore (Lst_Name_Tree);
         end if;
         if Lst = null then
            return;
         end if;
         TIO.New_Line;
         TIO.Put_Line (Sp (6) & "Set_Property (Me."
                       & Obj.ID.all & ", "
                       & "Xalign_Property, "
                       & The_Value (Lst, 2, Obj.ID.all)
                       & ");");
         TIO.Put_Line (Sp (6) & "Set_Property (Me."
                       & Obj.ID.all & ", "
                       & "Yalign_Property, "
                       & The_Value (Lst, 3, Obj.ID.all)
                       & ");");
         TIO.Put_Line (Sp (6) & "Set_Property (Me."
                       & Obj.ID.all & ", "
                       & "Xpad_Property, "
                       & The_Value (Lst, 4, Obj.ID.all)
                       & ");");
         TIO.Put_Line (Sp (6) & "Set_Property (Me."
                       & Obj.ID.all & ", "
                       & "Ypad_Property, "
                       & The_Value (Lst, 5, Obj.ID.all)
                       & ");");
         if Obj.Gtk_Class = Gtk_Cell_Renderer_Text then
            TIO.Put_Line (Sp (6) & "Set_Property (Me."
                          & Obj.ID.all & ", "
                          & "Foreground_Property, "
                          & Quoted (The_Value (Lst, 6, Obj.ID.all))
                          & ");");
            TIO.Put_Line (Sp (6) & "Set_Property (Me."
                          & Obj.ID.all & ", "
                          & "Background_Property, "
                          & Quoted (The_Value (Lst, 7, Obj.ID.all))
                          & ");");
            --  TIO.Put_Line (Sp (6) & "Set_Property (Me."
            --                & Obj.ID.all & ", "
            --                & "Selected_Background_Property, "
            --                & Quoted (The_Value (Lst, 8, Obj.ID.all))
            --                & ");");
            --  TIO.Put_Line (Sp (6) & "Set_Property (Me."
            --                & Obj.ID.all & ", "
            --                & "Selected_Foreground_Property, "
            --                & Quoted (The_Value (Lst, 9, Obj.ID.all))
            --                & ");");
            TIO.Put_Line (Sp (6) & "Set_Property (Me."
                          & Obj.ID.all & ", "
                          & "Underline_Property, "
                          & The_Value (Lst, 10, Obj.ID.all)
                          & ");");
            TIO.Put_Line (Sp (6) & "Set_Property (Me."
                          & Obj.ID.all & ", "
                          & "Font_Desc_Property,");
            TIO.Put_Line (Sp (20) & "To_Font_Description");
            TIO.Put_Line (Sp (22)
                          & "(Family_Name => "
                          & Quoted (The_Value (Lst, 11, Obj.ID.all))
                          & ",");
            TIO.Put_Line (Sp (23)
                          & "Weight => Pango_Weight_"
                          & The_Value (Lst, 12, Obj.ID.all)
                          & ",");
            TIO.Put_Line (Sp (23)
                          & "Size => "
                          & The_Value (Lst, 13, Obj.ID.all)
                          & "));");
         end if;
      end;
   end Process_Cell_Renderer;

   ---------------------------------------------------------------------------
   procedure Emit (Capitalized_Filename : String) is
   begin
      Log ("Generating Cell Renderers...");
      Include_Banner;
      Emit_Package_Spec (Capitalized_Filename & "_Pkg.Cell_Renderers");
      TIO.Put_Line (Sp (3) & "procedure Initialize;");
      Emit_Package_End (Capitalized_Filename & "_Pkg.Cell_Renderers");

      Include_Banner;
      Emit_With_Use (Capitalized_Filename & "_Pkg.Object_Collection");
      Emit_With_Use ("Gtk.Cell_Renderer");
      Emit_With_Use ("Gtk.Cell_Renderer_Text");
      Emit_With_Use ("Glib.Properties");
      Emit_With_Use ("Gtk.Tree_View_Column");
      Emit_With_Use ("Pango.Enums");
      Emit_With_Use ("Pango.Font");

      Emit_Package_Body (Capitalized_Filename & "_Pkg.Cell_Renderers", True);
      TIO.Put_Line (Sp (3) & "procedure Initialize is");
      TIO.Put_Line (Sp (3) & "begin");
      TIO.Put_Line (Sp (6) & "null; --  if no cell renderers are generated");
      Iterate (Process_Cell_Renderer'Access);
      TIO.Put_Line (Sp (3) & "end Initialize;");
      Emit_Package_End (Capitalized_Filename & "_Pkg.Cell_Renderers");
   end Emit;

end G2a.Emit_Ada.Cell_Renderers;

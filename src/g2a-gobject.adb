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
with Glade_Scanner_Io;
with Ada.Containers;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Hash;

package body G2a.GObject is

   ----------------------------------------------------------------------
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

   ----------------------------------------------------------------------
   package Object_Map is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Object,
      Hash            => Hash,
      Equivalent_Keys => Key_Equal,
      "="             => "=");

   Object_Table : Object_Map.Map;

   ----------------------------------------------------------------------
   procedure Insert_In_Object_Table (Obj : Object) is
      Temp_Obj : Object;
   begin
      if Obj.ID /= null and then Obj.ID.all /= "" then
         Temp_Obj := Get_Object_By_ID (Obj.ID.all);
         if Temp_Obj = null then
            Object_Table.Insert (Obj.ID.all, Obj);
         end if;
      end if;
   end Insert_In_Object_Table;

   ----------------------------------------------------------------------
   function Get_Object_By_ID (ID : String) return access Object_Block'Class is
      use type Object_Map.Cursor;
      Crs : Object_Map.Cursor;
   begin
      Crs := Object_Table.Find (ID);
      if Crs = Object_Map.No_Element then
         return null;
      else
         return Crs.Element;
      end if;
   end Get_Object_By_ID;

   ----------------------------------------------------------------------
   procedure Get_New (Obj    : out Object;
                      ID     : String := "") is
   begin
      Obj := new Object_Block'(Default_Object_Block);
      Obj.ID := new String'(ID);
      Obj.Gtk_Class := Gtk_Object;
      Obj.Insert_In_Object_Table;
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Object_Block;
                                          P  : Property) is
      pragma Unreferenced (OB);
   begin
      G2a.Non_Processed_Properties.Append
        (Non_Processed_Property_Block'(Glade_Scanner_Io.Yy_Line_Number, P.Name));
   end Process_Property;

   ----------------------------------------------------------------------
   T : Tree := Empty_Tree;
   Cursor_T    : constant Cursor := T.Root;
   Curr_Cursor : Cursor := No_Element;

   ----------------------------------------------------------------------
   function No_Objects return Boolean is
   begin
      return T.Is_Empty;
   end No_Objects;

   ----------------------------------------------------------------------
   function Current_Object_Parent return access Object_Block'Class is
      Parent_Cursor : Cursor;
   begin
      Parent_Cursor := Curr_Cursor.Parent;
      if Parent_Cursor = Cursor_T then
         return null;
      else
         return Object (Parent_Cursor.Element);
      end if;
   end Current_Object_Parent;

   ----------------------------------------------------------------------
   function Parent (Obj : not null access Object_Block'Class)
                    return not null access Object_Block'Class is

   begin
      return Object (Obj.The_Cursor.Parent.Element);
   end Parent;

   ----------------------------------------------------------------------
   function Current_Object return access Object_Block'Class is
   begin
      if Curr_Cursor = No_Element then
         return null;
      else
         return Object (Curr_Cursor.Element);
      end if;
   end Current_Object;

   ----------------------------------------------------------------------
   procedure Set_Current_Object (Obj : access Object_Block'Class) is
   begin
      if Obj = null then
         Curr_Cursor := No_Element;
      else
         Curr_Cursor := Obj.The_Cursor;
      end if;
   end Set_Current_Object;

   ----------------------------------------------------------------------
   procedure Set_Parent (Obj    : not null access Object_Block'Class;
                         Parent : Object := null) is
   begin
      if Parent = null then
         T.Insert_Child (Parent    => Cursor_T,
                         Before    => No_Element,
                         New_Item  => Node (Obj),
                         Position  => Obj.The_Cursor);
      else
         T.Insert_Child (Parent    => Parent.The_Cursor,
                         Before    => No_Element,
                         New_Item  => Node (Obj),
                         Position  => Obj.The_Cursor);
      end if;
   end Set_Parent;

   ----------------------------------------------------------------------
   procedure Renumber_Tree is
      use Ada.Containers;

      Counter    : Integer := -1;
      Prev_Level : Count_Type := 0;

      procedure Renumber_Child (R : Cursor);
      procedure Renumber_Child (R : Cursor) is
      begin
         if Prev_Level < R.Depth then
            Prev_Level := R.Depth;
            Counter := -1;
         elsif Prev_Level > R.Depth then
            Prev_Level := R.Depth;
            Counter := Object (R.Previous_Sibling.Element).Child_Number;
         end if;
         Counter := Counter + 1;
         Object (R.Element).Child_Number := Counter;
      end Renumber_Child;

   begin
      T.Iterate (Renumber_Child'Access);
   end Renumber_Tree;

   ----------------------------------------------------------------------
   procedure Iterate (Process : not null access procedure (Position : Cursor)) is
   begin
      T.Iterate (Process);
   end Iterate;

   ----------------------------------------------------------------------
   procedure Iterate_Subtree (From    : Cursor;
                              Process : not null access
                                procedure (Position : Cursor)) is
   begin
      null;
      --  T.Iterate_Subtree (From, Process);
   end Iterate_Subtree;

end G2a.GObject;

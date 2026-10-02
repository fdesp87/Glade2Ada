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

with G2a.GNode;                     use G2a.GNode;
with G2a.GSignal;                   use G2a.GSignal;
with G2a.GProperty;                 use G2a.GProperty;

package G2a.GObject is

   use Node_Tree_Pkg;

   type Object_Block is new Node_Block with record
      Gtk_Class          : GTK_Enum;
      The_Cursor         : Cursor;
      ID                 : String_Access;
      Child_Number       : Natural := 0;
      Properties         : Property_List;
      Signals            : Signal_List;
      Packing_Properties : Property_List;
   end record;
   type Object is access all Object_Block'Class;

   procedure Get_New (Obj    : out Object;
                      ID     : String := "");

   overriding procedure Process_Property (OB : in out Object_Block;
                                          P  : Property);

   procedure Set_Parent (Obj    : not null access Object_Block'Class;
                         Parent : Object := null);

   function Parent (Obj : not null access Object_Block'Class)
                    return not null access Object_Block'Class;

   procedure Renumber_Tree;

   procedure Iterate (Process : not null access procedure (Position : Cursor));
   procedure Iterate_Subtree
     (From : Cursor; Process : not null access procedure (Position : Cursor));

   Unsupported_Signal  : exception;
   Unspecified_Handler : exception;

   Default_Object_Block : constant Object_Block :=
                            (Gtk_Class          => Gtk_Object,
                             The_Cursor         => No_Element,
                             ID                 => null,
                             Child_Number       => 0,
                             Properties         => Empty_Property_List,
                             Signals            => Empty_Signal_List,
                             Packing_Properties => Empty_Property_List);

   function No_Objects return Boolean;
   function Current_Object return access Object_Block'Class;
   procedure Set_Current_Object (Obj : access Object_Block'Class);
   function Current_Object_Parent return access Object_Block'Class;

   procedure Insert_In_Object_Table (Obj : Object);
   function Get_Object_By_ID (ID : String) return access Object_Block'Class;

end G2a.GObject;

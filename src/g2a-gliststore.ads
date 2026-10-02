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

with Ada.Containers.Doubly_Linked_Lists;

with G2a.GTreemodel;      use G2a.GTreemodel;
with G2a.GListcolumn;     use G2a.GListcolumn;
with G2a.GProperty;       use G2a.GProperty;

package G2a.GListstore is

   type Additional_Info_Block is record
      Lst_Name      : String_Access;
      Name          : String_Access;
      Aux           : String_Access;
      Xalign        : String_Access;
      Yalign        : String_Access;
      Xpad          : String_Access;
      Ypad          : String_Access;
      Foreground    : String_Access;
      Background    : String_Access;
      Selforeground : String_Access;
      Selbackground : String_Access;
      Underline     : String_Access;
      Font_Name     : String_Access;
      Font_Weight   : String_Access;
      Font_Size     : String_Access;
   end record;
   type Additional_Info is access Additional_Info_Block;

   package String_Access_List_Pkg is new Ada.Containers.Doubly_Linked_Lists
     (Element_Type => Additional_Info,
      "="          => "=");

   subtype String_Access_List is String_Access_List_Pkg.List;

   Empty_String_Access_List : constant String_Access_List :=
                                String_Access_List_Pkg.Empty_List;

   type Liststore_Block is new Treemodel_Block with record
      Columns : Listcolumn_List;
      Data    : String_Access_List;
   end record;

   --  Note:
   --  As it is not possible to define tooltips and other properties
   --  for treeview columns in glade, the adopted solution was to create
   --  (in glade) a new liststore with several columns: first one is for
   --  the treeview column name and sucessive column will contain the
   --  tooltip text and other properties.

   type Liststore is access all Liststore_Block'Class;

   procedure Get_New (Lst : out Liststore;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Liststore_Block;
                                          P  : Property);

   Default_Liststore_Block : constant Liststore_Block :=
                               (Default_Treemodel_Block with
                                Columns => Empty_Listcolumn_List,
                                Data    => Empty_String_Access_List);

   function Find_Liststore (Lst_Name : String) return Liststore;

   function The_Value (Lst  : Liststore;
                       Slot : Natural;
                       Name : String) return String;

   procedure Set_Liststore_Focus (Lst : not null Liststore);
   procedure Compute_Focus_List;
   Only_One_Liststore_Focus_Allowed : exception;
end G2a.GListstore;

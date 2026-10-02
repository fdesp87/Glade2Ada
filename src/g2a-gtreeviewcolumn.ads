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

with G2a.GObject;        use G2a.GObject;
with G2a.GProperty;      use G2a.GProperty;

package G2a.GTreeviewcolumn is

   type Sizing_Enum is (Grow_Only_Column,
                        Autosize_Column,
                        Fixed_Column);
   type Sort_Order_Enum is (Ascending, Descending);

   type Treeviewcolumn_Block is new Object_Block with record
      Resizable                 : Boolean;
      Spacing                   : Natural;
      Sizing                    : Sizing_Enum;
      Fixed_Width               : Integer;
      Min_Width                 : Integer;
      Max_Width                 : Integer;
      Title                     : String_Access;
      Clickable                 : Boolean;
      Widget                    : String_Access;
      Alignment                 : Float; --  of the title
      Reorderable               : Boolean;
      Sort_Indicator            : Boolean;
      Sort_Order                : Sort_Order_Enum;
      Sort_Column_Id            : Integer;
      Expand                    : Boolean;
   end record;

   type Treeviewcolumn is access all Treeviewcolumn_Block'Class;

   procedure Get_New (Tc : out Treeviewcolumn;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Treeviewcolumn_Block;
                                          P  : Property);

   Default_Resizable      : constant Boolean := False;
   Default_Spacing        : constant Natural := 0;
   Default_Sizing         : constant Sizing_Enum := Fixed_Column;
   Default_Fixed_Width    : constant Integer := -1;
   Default_Min_Width      : constant Integer := -1;
   Default_Max_Width      : constant Integer := -1;
   Default_Clickable      : constant Boolean := False;
   Default_Alignment      : constant Float := 0.0;
   Default_Reorderable    : constant Boolean := False;
   Default_Sort_Indicator : constant Boolean := False;
   Default_Sort_Order     : constant Sort_Order_Enum := Ascending;
   Default_Sort_Column_Id : constant Integer := -1;
   Default_Expand         : constant Boolean := False;

   Default_Treeviewcolumn_Block : constant Treeviewcolumn_Block :=
     (Default_Object_Block with
      Resizable      => Default_Resizable,
      Spacing        => Default_Spacing,
      Sizing         => Default_Sizing,
      Fixed_Width    => Default_Fixed_Width,
      Min_Width      => Default_Min_Width,
      Max_Width      => Default_Max_Width,
      Title          => null,
      Clickable      => Default_Clickable,
      Widget         => null,
      Alignment      => Default_Alignment,
      Reorderable    => Default_Reorderable,
      Sort_Indicator => Default_Sort_Indicator,
      Sort_Order     => Default_Sort_Order,
      Sort_Column_Id => Default_Sort_Column_Id,
      Expand         => Default_Expand);

end G2a.GTreeviewcolumn;

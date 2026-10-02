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

with G2a.GContainer;      use G2a.GContainer;
with G2a.GProperty;       use G2a.GProperty;
with G2a.GEnumerations;   use G2a.GEnumerations;

package G2a.GTreeview is

   type Treeview_Block is new Container_Block with record
      Private_Ubuntu_Extension : Boolean;
      Model                    : String_Access; --  point to a treeviewmodel
      Level_Indentation        : Natural;
      Tooltip_Column           : Integer;
      Enable_Grid_Lines        : Enable_Grid_Lines_Enum;
      Enable_Search            : Boolean;
      Search_Column            : Integer;
      Show_Expanders           : Boolean;
      Expander_Column          : String_Access;
      Headers_Visible          : Boolean;
      Headers_Clickable        : Boolean;
      Reorderable              : Boolean;
      Fixed_Height_Mode        : Boolean;
      Rules_Hint               : Boolean;
      Enable_Tree_Lines        : Boolean;
      Hover_Selection          : Boolean;
      Hover_Expand             : Boolean;
      Rubber_Banding           : Boolean;
      Single_Click_Activate    : Boolean;
      Scrolling_Horizontal     : String_Access; --  pending
      Scrolling_Vertical       : String_Access; --  pending
      Scrolling_H_Policy       : Treeview_Scrolling_Policy_Enum;
      Scrolling_V_Policy       : Treeview_Scrolling_Policy_Enum;
      Hadjustment              : String_Access;
      Vadjustment              : String_Access;
   end record;

   type Treeview is access all Treeview_Block'Class;

   procedure Get_New (Tv : out Treeview;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Treeview_Block;
                                          P  : Property);

   Default_Private_Ubuntu_Extension : constant Boolean := False;
   Default_Level_Indentation        : constant Natural := 0;
   Default_Tooltip_Column           : constant Integer := -1;
   Default_Enable_Search            : constant Boolean := True;
   Default_Search_Column            : constant Integer := -1;
   Default_Show_Expanders           : constant Boolean := True;
   Default_Headers_Visible          : constant Boolean := True;
   Default_Headers_Clickable        : constant Boolean := True;
   Default_Reorderable              : constant Boolean := False;
   Default_Fixed_Height_Mode        : constant Boolean := False;
   Default_Rules_Hint               : constant Boolean := False;
   Default_Enable_Tree_Lines        : constant Boolean := False;
   Default_Hover_Selection          : constant Boolean := False;
   Default_Hover_Expand             : constant Boolean := False;
   Default_Rubber_Banding           : constant Boolean := False;
   Default_Single_Click_Activate    : constant Boolean := False;
   Default_Scrolling_Horizontal     : constant String_Access := null;
   Default_Scrolling_Vertical       : constant String_Access := null;

   Default_Treeview_Block : constant Treeview_Block :=
     (Default_Container_Block with
      Private_Ubuntu_Extension => Default_Private_Ubuntu_Extension,
      Model                    => null,
      Level_Indentation        => Default_Level_Indentation,
      Tooltip_Column           => Default_Tooltip_Column,
      Enable_Grid_Lines        => Default_Enable_Grid_Lines,
      Enable_Search            => Default_Enable_Search,
      Search_Column            => Default_Search_Column,
      Show_Expanders           => Default_Show_Expanders,
      Expander_Column          => null,
      Headers_Visible          => Default_Headers_Visible,
      Headers_Clickable        => Default_Headers_Clickable,
      Reorderable              => Default_Reorderable,
      Fixed_Height_Mode        => Default_Fixed_Height_Mode,
      Rules_Hint               => Default_Rules_Hint,
      Enable_Tree_Lines        => Default_Enable_Tree_Lines,
      Hover_Selection          => Default_Hover_Selection,
      Hover_Expand             => Default_Hover_Selection,
      Rubber_Banding           => Default_Hover_Expand,
      Single_Click_Activate    => Default_Single_Click_Activate,
      Scrolling_Horizontal     => null,
      Scrolling_Vertical       => null,
      Scrolling_H_Policy       => Default_Treeview_Scrolling_Policy,
      Scrolling_V_Policy       => Default_Treeview_Scrolling_Policy,
      Hadjustment              => null,
      Vadjustment              => null);

end G2a.GTreeview;

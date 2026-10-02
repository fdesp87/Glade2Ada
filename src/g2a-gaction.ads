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
with G2a.GWidget;       use G2a.GWidget;
with G2a.GObject;       use G2a.GObject;
with G2a.GProperty;     use G2a.GProperty;

package G2a.GAction is

   type Action_Block is new Object_Block with record
      Label                   : Text_Block;
      Short_Label             : Text_Block;
      Stock_Icon              : String_Access;
      Icon_Name               : String_Access;
      Accelerator             : String_Access;
      Tooltip                 : Text_Block;
      Visible                 : Boolean;
      Always_Show_Image       : Boolean;
      Sensitive               : Boolean;
      Hide_If_Empty           : Boolean;
      Visible_When_Vertical   : Boolean;
      Visible_When_Horizontal : Boolean;
      Visible_When_Overflown  : Boolean;
      Is_Important            : Boolean;
   end record;

   type Action is access all Action_Block'Class;

   procedure Get_New (AC : out Action;
                      ID : String := "");

   overriding procedure Process_Property (OB : in out Action_Block;
                                          P  : Property);

      Default_Label                   : constant Text_Block := Default_Text_Block;
      Default_Short_Label             : constant Text_Block := Default_Text_Block;
      Default_Tooltip                 : constant Text_Block := Default_Text_Block;
      Default_Visible                 : constant Boolean := True;
      Default_Always_Show_Image       : constant Boolean := False;
      Default_Sensitive               : constant Boolean := True;
      Default_Hide_If_Empty           : constant Boolean := True;
      Default_Visible_When_Vertical   : constant Boolean := True;
      Default_Visible_When_Horizontal : constant Boolean := True;
      Default_Visible_When_Overflown  : constant Boolean := True;
      Default_Is_Important            : constant Boolean := False;

   Default_Action_Block : constant Action_Block :=
      (Default_Object_Block with
       Label                   => Default_Label,
       Short_Label             => Default_Short_Label,
       Stock_Icon              => null,
       Icon_Name               => null,
       Accelerator             => null,
       Tooltip                 => Default_Text_Block,
       Visible                 => Default_Visible,
       Always_Show_Image       => Default_Always_Show_Image,
       Sensitive               => Default_Sensitive,
       Hide_If_Empty           => Default_Hide_If_Empty,
       Visible_When_Vertical   => Default_Visible_When_Vertical,
       Visible_When_Horizontal => Default_Visible_When_Horizontal,
       Visible_When_Overflown  => Default_Visible_When_Overflown,
       Is_Important            => Default_Is_Important);

end G2a.GAction;

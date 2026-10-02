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

with G2a.GBin;          use G2a.GBin;
with G2a.GWidget;       use G2a.GWidget;
with G2a.GProperty;     use G2a.GProperty;
with G2a.GEnumerations; use G2a.GEnumerations;

package G2a.GWindow is

   type Window_Flags_Enum is (Deletable, Resizable, Urgent, Accept_Focus,
                              Destroy_With_Parent, Resize_Grip,
                              Skip_Task_Bar, Focus_On_Map,
                              Modal, Skip_Pager);

   type Window_Flags_Array is array (Window_Flags_Enum) of Boolean;

   type Window_Block is new Bin_Block with record
      TopLevel                : Boolean;  --  else popup
      Hint                    : Hint_Enum;
      Window_Position         : Window_Position_Enum;
      Window_Gravity          : Window_Gravity_Enum;
      Accel_Groups            : Integer;  --  pending
      Transient_For           : String_Access;
      Attached_To             : String_Access;
      Window_Role             : String_Access;
      Startup_ID              : String_Access;
      Client_Side_Decorations : Boolean;
      Title                   : String_Access;
      Decorated               : Boolean;
      Hide_Titlebar           : Boolean;  --  during maximization
      Icon_Name               : String_Access;
      Icon_File               : String_Access;
      Default_Width_Set       : Boolean;
      Default_Height_Set      : Boolean;
      Default_Width           : Natural;
      Default_Height          : Natural;
      Window_Flags            : Window_Flags_Array;
   end record;
   type Window is access all Window_Block'Class;

   procedure Get_New (Win : out Window;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Window_Block;
                                          P  : Property);

   Default_Default_Width_Set               : Boolean := False;
   Default_Default_Height_Set              : Boolean := False;
   Default_Default_Width                   : Natural := 440;
   Default_Default_Height                  : Natural := 250;
   Default_Window_Flag_Deletable           : constant Boolean := True;
   Default_Window_Flag_Resizable           : constant Boolean := True;
   Default_Window_Flag_Urgent              : constant Boolean := False;
   Default_Window_Flag_Accept_Focus        : constant Boolean := True;
   Default_Window_Flag_Destroy_With_Parent : constant Boolean := False;
   Default_Window_Flag_Resize_Grip         : constant Boolean := False;
   Default_Window_Flag_Skip_Task_Bar       : constant Boolean := False;
   Default_Window_Flag_Focus_On_Map        : constant Boolean := True;
   Default_Window_Flag_Modal               : constant Boolean := False;
   Default_Window_Flag_Skip_Pager          : constant Boolean := False;
   Default_Window_Flags : constant Window_Flags_Array :=
      (Deletable           => Default_Window_Flag_Deletable,
       Resizable           => Default_Window_Flag_Resizable,
       Urgent              => Default_Window_Flag_Urgent,
       Accept_Focus        => Default_Window_Flag_Accept_Focus,
       Destroy_With_Parent => Default_Window_Flag_Destroy_With_Parent,
       Resize_Grip         => Default_Window_Flag_Resize_Grip,
       Skip_Task_Bar       => Default_Window_Flag_Skip_Task_Bar,
       Focus_On_Map        => Default_Window_Flag_Focus_On_Map,
       Modal               => Default_Window_Flag_Modal,
       Skip_Pager          => Default_Window_Flag_Skip_Pager);
   Default_Window_Block : constant Window_Block :=
                            (Default_Bin_Block with
                             TopLevel                => True,  --  else popup
                             Hint                    => Default_Hint,
                             Window_Position         => Default_Window_Position,
                             Window_Gravity          => Default_Window_Gravity,
                             Accel_Groups            => 0,  --  pending
                             Transient_For           => null,
                             Attached_To             => null,
                             Window_Role             => null,
                             Startup_ID              => null,
                             Client_Side_Decorations => False,
                             Title                   => null,
                             Decorated               => False,
                             Hide_Titlebar           => False,  --  during maximization
                             Icon_Name               => null,
                             Icon_File               => null,
                             Default_Width_Set       => Default_Default_Width_Set,
                             Default_Height_Set      => Default_Default_Height_Set,
                             Default_Width           => Default_Default_Width,
                             Default_Height          => Default_Default_Height,
                             Window_Flags            => Default_Window_Flags);

end G2a.GWindow;

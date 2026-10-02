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
with G2a.GProperty;     use G2a.GProperty;

package G2a.GCalendar is

   type Calendar_Block is new Widget_Block with record
      Year                : Natural;
      Month               : Natural;
      Day                 : Natural;
      Show_Heading        : Boolean;
      Show_Day_Names      : Boolean;
      No_Month_Change     : Boolean;
      Show_Week_Numbers   : Boolean;
      Show_Details        : Boolean;
      Details_Width       : Natural;
      Details_Height      : Natural;
   end record;

   type Calendar is access all Calendar_Block'Class;

   procedure Get_New (Cal : out Calendar;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Calendar_Block;
                                          P  : Property);

   Default_Year              : Natural := 0;
   Default_Month             : Natural := 0;
   Default_Day               : Natural := 0;
   Default_Show_Heading      : Boolean := True;
   Default_Show_Day_Names    : Boolean := True;
   Default_No_Month_Change   : Boolean := False;
   Default_Show_Week_Numbers : Boolean := False;
   Default_Show_Details      : Boolean := True;
   Default_Details_Width     : Natural := 0;
   Default_Details_Height    : Natural := 0;

   Default_Calendar_Block : constant Calendar_Block :=
     (Default_Widget_Block with
      Year                => Default_Year,
      Month               => Default_Month,
      Day                 => Default_Day,
      Show_Heading        => Default_Show_Heading,
      Show_Day_Names      => Default_Show_Day_Names,
      No_Month_Change     => Default_No_Month_Change,
      Show_Week_Numbers   => Default_Show_Week_Numbers,
      Show_Details        => Default_Show_Details,
      Details_Width       => Default_Details_Width,
      Details_Height      => Default_Details_Height);

end G2a.GCalendar;

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

package G2a.GSignal is

   Default_Swap  : constant Boolean := False;
   Default_After : constant Boolean := False;

   type Signal_Block is record
      Signal_Name : String_Access;  --  gtk name
      Handler     : String_Access;
      User_Data   : String_Access;
      Swap        : Boolean;
      After       : Boolean;
      Proc        : Boolean; --  false means function
      Emit        : Boolean; --  only emit the first occurrence
   end record;
   type Signal is access Signal_Block;

   Default_Signal_Block : constant Signal_Block :=
                            (Signal_Name => null,
                             Handler     => null,
                             User_Data   => null,
                             Swap        => Default_Swap,
                             After       => Default_After,
                             Proc        => True,
                             Emit        => True);

   package Signal_List_Pkg is new Ada.Containers.Doubly_Linked_Lists
     (Element_Type => Signal,
      "="          => "=");
   use Signal_List_Pkg;

   subtype Signal_List is List;

   Empty_Signal_List : constant Signal_List := Signal_List_Pkg.Empty_List;

   procedure Get_New (S           : out Signal;
                      Signal_Name : String;
                      Handler     : String;
                      User_Data   : String  := "";
                      Swap        : Boolean := Default_Swap;
                      After       : Boolean := Default_After;
                      Proc        : Boolean := True);

   Unknown_Signal  : exception;
   Unnamed_Handler : exception;
end G2a.GSignal;

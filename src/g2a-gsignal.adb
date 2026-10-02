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
with G2a.Symbol_Tables;  use G2a.Symbol_Tables;
with GNATCOLL.Utils;     use  GNATCOLL.Utils;

package body G2a.GSignal is

   ---------------------------------------------------------------------------

   procedure Get_New (S           : out Signal;
                      Signal_Name : String;
                      Handler     : String;
                      User_Data   : String  := "";
                      Swap        : Boolean := Default_Swap;
                      After       : Boolean := Default_After;
                      Proc        : Boolean := True) is
   begin
      S := new Signal_Block'(Default_Signal_Block);
      S.Signal_Name := new String'(Signal_Name);
      S.Handler     := new String'(Capitalize (Handler));
      S.User_Data   := new String'(Capitalize (User_Data));
      S.Swap        := Swap;
      S.After       := After;
      S.Proc        := Proc;
      S.Emit        := Insert_Handler (Handler);

   end Get_New;

end G2a.GSignal;

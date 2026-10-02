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

package G2a.Support is

   procedure Dump_Tree;

   type Log_Operation is (Create_Object, Close_Object,
                          Attach_Signal,
                          Attach_Integer_Attribute,
                          Attach_String_Attribute,
                          Attach_Property_Identifier,
                          Attach_Property_String,
                          Attach_Property_Integer,
                          Attach_Property_Boolean,
                          Attach_Property_Decimal,
                          Attach_Column,
                          Attach_Additional_Information,
                          Attach_Mime_Type,
                          Attach_Pattern,
                          Start_Packing,
                          End_Packing,
                          Start_Attributes,
                          End_Attributes,
                          Start_Items,
                          This_Item,
                          End_Items);

   procedure Log (Oper         : Log_Operation;
                  Name         : String := "";
                  Id           : String := "";
                  CN           : Integer := 0;
                  Context      : String := "";
                  Comments     : String := "";
                  Translatable : Boolean := False);

   procedure Log (Msg : String);

   function Img (N : Integer) return String;

   function Extract (Src  : String;
                     Lead : String;
                     Tail : String) return String;

   function Contains (Src : String; Part : String) return Boolean;

end G2a.Support;

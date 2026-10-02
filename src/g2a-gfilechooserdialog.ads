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

with G2a.GDialog;       use G2a.GDialog;
with G2a.GProperty;     use G2a.GProperty;
with G2a.GEnumerations; use G2a.GEnumerations;

package G2a.GFilechooserdialog is

   type Filechooserdialog_Block is new Dialog_Block with record
      Action                       : Action_Enum;
      Filter                       : String_Access;
      Preview_Widget               : String_Access;
      Preview_Widget_Active        : Boolean;
      Use_Preview_Label            : Boolean;
      Extra_Widget                 : String_Access;
      Select_Multiple              : Boolean;
      Allow_Folder_Creation        : Boolean;
      Show_Hidden                  : Boolean;
      Overwrite_Confirmation       : Boolean;
      Local_Only                   : Boolean;
   end record;

   type Filechooserdialog is access all Filechooserdialog_Block'Class;

   procedure Get_New (Fcd : out Filechooserdialog;
                      ID  : String := "");

   overriding procedure Process_Property (OB : in out Filechooserdialog_Block;
                                          P  : Property);

   Default_Preview_Widget_Active        : constant Boolean := True;
   Default_Use_Preview_Label            : constant Boolean := True;
   Default_Select_Multiple              : constant Boolean := False;
   Default_Allow_Folder_Creation        : constant Boolean := True;
   Default_Show_Hidden                  : constant Boolean := False;
   Default_Overwrite_Confirmation       : constant Boolean := False;
   Default_Local_Only                   : constant Boolean := True;

   Default_Filechooserdialog_Block : constant
     Filechooserdialog_Block :=
       (Default_Dialog_Block with
        Action                       => Default_Action,
        Filter                       => null,
        Preview_Widget               => null,
        Preview_Widget_Active        => Default_Preview_Widget_Active,
        Use_Preview_Label            => Default_Use_Preview_Label,
        Extra_Widget                 => null,
        Select_Multiple              => Default_Select_Multiple,
        Allow_Folder_Creation        => Default_Allow_Folder_Creation,
        Show_Hidden                  => Default_Show_Hidden,
        Overwrite_Confirmation       => Default_Overwrite_Confirmation,
        Local_Only                   => Default_Local_Only);

end G2a.GFilechooserdialog;

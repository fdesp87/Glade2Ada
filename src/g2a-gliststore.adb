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

with G2a.GWidget;     use G2a.GWidget;
with G2a.GObject;     use G2a.GObject;
with Ada.Text_IO;

package body G2a.GListstore is

   procedure Get_New (Lst : out Liststore;
                      ID  : String := "") is
   begin
      Lst := new Liststore_Block'(Default_Liststore_Block);
      Lst.ID := new String'(ID);
      Lst.Gtk_Class := Gtk_List_Store;
      Insert_In_Object_Table (Object (Lst));
   end Get_New;

   ----------------------------------------------------------------------
   overriding procedure Process_Property (OB : in out Liststore_Block;
                                          P  : Property) is
   begin
      --  process its properties
      null;

      --  call the parent to process parent's properties
      Treemodel_Block (OB).Process_Property (P);
   end Process_Property;

   ----------------------------------------------------------------------
   function Find_Liststore (Lst_Name : String) return Liststore is
      Lst : Liststore := null;
   begin
      if Lst_Name = "" then
         return null;
      end if;
      Lst := Liststore (Get_Object_By_ID (Lst_Name));
      return Lst;
   end Find_Liststore;

   ----------------------------------------------------------------------
   function The_Value (Lst  : Liststore;
                       Slot : Natural;
                       Name : String) return String is

      use String_Access_List_Pkg;
      Crs : Cursor;
   begin
      if Lst = null then
         return "";
      end if;
      Crs := Lst.Data.First;
      while Crs /= No_Element loop
         declare
            HT : constant Additional_Info := Crs.Element;
         begin
            if HT.Name.all = Name then
               case Slot is
                  when 0 => return Name;
                  when 1 => return HT.Aux.all;
                  when 2 => return HT.Xalign.all;
                  when 3 => return HT.Yalign.all;
                  when 4 => return HT.Xpad.all;
                  when 5 => return HT.Ypad.all;
                  when 6 => return HT.Foreground.all;
                  when 7 => return HT.Background.all;
                  when 8 => return HT.Selforeground.all;
                  when 9 => return HT.Selbackground.all;
                  when 10 => return HT.Underline.all;
                  when 11 => return HT.Font_Name.all;
                  when 12 => return HT.Font_Weight.all;
                  when 13 => return HT.Font_Size.all;
                  when others => return "";
               end case;
            end if;
         end;
         Crs.Next;
      end loop;
      return "";
   exception
      when others =>
         Ada.Text_IO.Put_Line (Lst.ID.all & ", Slot= " & Slot'Image & ", Name=" & Name);
         raise;
   end The_Value;

   ----------------------------------------------------------------------
   Liststore_Focus : Liststore := null;

   procedure Set_Liststore_Focus (Lst : not null Liststore) is
   begin
      if Liststore_Focus /= null then
         raise Only_One_Liststore_Focus_Allowed;
      end if;
      Liststore_Focus := Lst;
   end Set_Liststore_Focus;

   ----------------------------------------------------------------------
   procedure Compute_Focus_List is
      use String_Access_List_Pkg;
      Crs : Cursor;
      Obj : Object;
   begin
      if Liststore_Focus = null then
         return;
      end if;
      Crs := Liststore_Focus.Data.First;
      while Crs /= No_Element loop
         Obj := Get_Object_By_ID (Crs.Element.Name.all);
         if Obj /= null and then Is_Widget (Obj) then
            Insert_In_Focus_Chain (Widget (Obj));
         end if;
         Crs.Next;
      end loop;
   end Compute_Focus_List;

end G2a.GListstore;

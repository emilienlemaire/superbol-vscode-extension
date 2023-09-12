(**************************************************************************)
(*                                                                        *)
(*  Copyright (c) 2021-2023 OCamlPro SAS                                  *)
(*                                                                        *)
(*  All rights reserved.                                                  *)
(*  This file is distributed under the terms of the                       *)
(*  OCAMLPRO-NON-COMMERCIAL license.                                      *)
(*                                                                        *)
(**************************************************************************)

(** Some utilities to log preprocessing events. *)

open Cobol_common.Srcloc.TYPES

module TYPES = struct
  type log_entry =
    | FileCopy of
        {
          copyloc: srcloc;
          status: copy_event_status;
        }
    | Replacement of
        {
          matched_loc: srcloc;
          replacement_text: Text.text;
        }

  and copy_event_status =
    | CopyDone of string
    | CyclicCopy of string
    | MissingCopy of Copybook.lib_not_found_info

  type log = log_entry list
end
include TYPES

(* --- *)

let empty = []
let append =
  List.cons
let copy_done ~loc ~filename : log -> log =
  List.cons @@ FileCopy { copyloc = loc; status = CopyDone filename }
let cyclic_copy ~loc ~filename : log -> log =
  List.cons @@ FileCopy { copyloc = loc; status = CyclicCopy filename }
let missing_copy ~loc ~info : log -> log =
  List.cons @@ FileCopy { copyloc = loc; status = MissingCopy info }

(* --- *)

let events: log -> log_entry list = List.rev

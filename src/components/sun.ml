open Component_defs
open System_defs

type tag += Power of sun | Hope of sun | Wisdom of sun | Eternal of sun

let sun (x, y, width, height, typ) =
  let e = new sun () in
  if typ = 0 then ( (* Eternal sun *)
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set (let Global.{textures; _} = Global.get () in textures.(13));
    e#tag#set (Eternal e);
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t));
  )
  else if typ = 1 then ( (* Hope fragment *)
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set (let Global.{textures; _} = Global.get () in textures.(14));
    e#tag#set (Hope e);
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t));
  )
  else if typ = 2 then ( (* Power fragment *)
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set (let Global.{textures; _} = Global.get () in textures.(15));
    e#tag#set (Power e);
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t));
  )
  else if typ = 3 then ( (* Wisdom fragment *)
    e#position#set Vector.{x = float x; y = float y};
    e#box#set Rect.{width; height};
    e#texture#set (let Global.{textures; _} = Global.get () in textures.(16));
    e#tag#set (Wisdom e);
    Draw_system.(register (e :> t));
    Collision_system.(register (e :> t));
  );
  e
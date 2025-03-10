open Component_defs
open System_defs

type tag += PlayerProjectile of projectile

let projectile (x, y, width, height, direction) =
  let e = new projectile () in
  e#texture#set Texture.purple;
  e#position#set Vector.{x; y};
  e#tag#set (PlayerProjectile e);
  e#box#set Rect.{width; height};
  let dir = [| Cst.up_projectile; Cst.down_projectile; Cst.right_projectile; Cst.left_projectile |] in
  e#velocity#set dir.(direction);
  e#resolve#set (fun n t ->
    match t#tag#get with
    | Barrier.Barrier w ->
      Draw_system.(unregister (e :> t));
      Collision_system.(unregister (e :> t));
      Move_system.(unregister (e :> t));
      Gravitate_system.(unregister (e :> t));

    | Threat.Spike s ->
      Draw_system.(unregister (s :> t));
      Collision_system.(unregister (s :> t))

    | _ -> ()
  );
  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  e
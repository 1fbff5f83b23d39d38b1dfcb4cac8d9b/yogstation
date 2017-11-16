/* Table Frames
 * Contains:
 *		Frames
 *		Wooden Frames
 */


/*
 * Normal Frames
 */

/obj/structure/table_frame
	name = "table frame"
	desc = "Four metal legs with four framing rods for a table. You could easily pass through this."
	icon = 'icons/obj/structures.dmi'
	icon_state = "table_frame"
	density = 0
	anchored = 0
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER
	var/framestack = /obj/item/stack/rods
	var/framestackamount = 2

/obj/structure/table_frame/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/wrench))
		to_chat(user, "<span class='notice'>You start disassembling [src]...</span>")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 30/I.toolspeed, target = src))
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			for(var/i = 1, i <= framestackamount, i++)
				new framestack(get_turf(src))
			qdel(src)

	else if(istype(I, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/S = I
		var/tobuild = null
		if(istype(I, /obj/item/stack/sheet/plasteel))
			tobuild = /obj/structure/table/reinforced
		else if(istype(I, /obj/item/stack/sheet/metal))
			tobuild = /obj/structure/table
		else if(istype(I, /obj/item/stack/sheet/glass))
			tobuild = /obj/structure/table/glass
		else if(istype(I, /obj/item/stack/sheet/mineral/silver))
			tobuild = /obj/structure/table/optable
		else
			to_chat(user, "<span class='warning'>You can't build a table using [S]!</span>")
			return
		if(S.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one [S] sheet to do this!</span>")
			return
		for(var/atom/A in get_turf(src))
			if(A.density)
				to_chat(user, "<span class='warning'>You can't build a table here, something is in the way!</span>")
				return
		to_chat(user, "<span class='notice'>You start adding [S] to [src]...</span>")
		if(!(do_after(user, 50, target = src) && S.use(1)))
			return
		new tobuild(src.loc)
		qdel(src)
	else
		return ..()

/obj/structure/table_frame/narsie_act()
	if(prob(20))
		new /obj/structure/table_frame/wood(src.loc)
		qdel(src)

/obj/structure/table_frame/ratvar_act()
	new /obj/structure/table_frame/brass(src.loc)
	qdel(src)

/*
 * Wooden Frames
 */

/obj/structure/table_frame/wood
	name = "wooden table frame"
	desc = "Four wooden legs with four framing wooden rods for a wooden table. You could easily pass through this."
	icon_state = "wood_frame"
	framestack = /obj/item/stack/sheet/mineral/wood
	framestackamount = 2
	burn_state = FLAMMABLE

/obj/structure/table_frame/wood/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/sheet/mineral/wood/W = I
		if(W.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one wood sheet to do this!</span>")
			return
		to_chat(user, "<span class='notice'>You start adding [W] to [src]...</span>")
		if(do_after(user, 20, target = src))
			W.use(1)
			new /obj/structure/table/wood(src.loc)
			qdel(src)
		return
	else if(istype(I, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = I
		if(C.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one carpet sheet to do this!</span>")
			return
		to_chat(user, "<span class='notice'>You start adding [C] to [src]...</span>")
		if(do_after(user, 20, target = src))
			C.use(1)
			new /obj/structure/table/wood/poker(src.loc)
			qdel(src)
	else
		return ..()

/obj/structure/table_frame/brass
	name = "brass table frame"
	desc = "Four pieces of brass arranged in a square. It's slightly warm to the touch."
	icon_state = "brass_frame"
	framestackamount = 0

/obj/structure/table_frame/brass/narsie_act()
	..()
	if(src) //do we still exist?
		var/previouscolor = color
		color = "#960000"
		animate(src, color = previouscolor, time = 8)

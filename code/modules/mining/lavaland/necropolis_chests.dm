//The chests dropped by mob spawner tendrils. Also contains associated loot.

/obj/structure/closet/crate/necropolis
	name = "necropolis chest"
	desc = "It's watching you closely."
	icon_state = "necrocrate"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/structure/closet/crate/necropolis/tendril
	desc = "It's watching you suspiciously."

/obj/structure/closet/crate/necropolis/tendril/New()
	..()
	var/loot = rand(1,24)
	switch(loot)
		if(1)
			new /obj/item/device/shared_storage/red(src)
		if(2)
			new /obj/item/clothing/suit/space/hardsuit/cult(src)
		if(3)
			new /obj/item/device/necromantic_stone/lesser(src)
		if(4)
			new /obj/item/weapon/katana/cursed(src)
		if(5)
			new /obj/item/clothing/glasses/godeye(src)
		if(6)
			new /obj/item/weapon/reagent_containers/glass/bottle/potion/flight(src)
		if(7)
			new /obj/item/weapon/pickaxe/drill/jackhammer(src)
		if(8)
			new /obj/item/weapon/melee/cultblade/dagger(src)
			new /obj/item/weapon/restraints/legcuffs/bola/cult(src)
			new /obj/item/weapon/bedsheet/cult(src)
			new /obj/item/clothing/suit/magusred(src)
			new /obj/item/clothing/head/magus(src)
		if(9)
			new /obj/item/weapon/rune_scimmy(src)
		if(10)
			new /obj/item/ship_in_a_bottle(src)
		if(11)
			new /obj/item/clothing/suit/space/hardsuit/ert/paranormal/beserker(src)
		if(12)
			new /obj/item/weapon/nullrod/scythe/talking(src)
			new /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater/godblood(src)
		if(13)
			new /obj/item/weapon/reagent_containers/glass/bottle/self_fill(src)
		if(14)
			new /obj/item/weapon/guardiancreator(src)
		if(15)
			new /obj/item/device/warp_cube/red(src)
		if(16)
			new /obj/item/device/wisp_lantern(src)
		if(17)
			new /obj/item/borg/upgrade/modkit/aoe/turfs/andmobs(src)
		if(18)
			new /obj/item/weapon/gun/magic/hook(src)
		if(19)
			new /obj/item/voodoo(src)
		if(20)
			new /obj/item/weapon/melee/energy/sword/pirate(src)
			new /obj/item/clothing/suit/space/pirate(src)
			new /obj/item/clothing/head/helmet/space/pirate(src)
		if(21)
			new /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater/hell(src)
			new /obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor(src)
		if(22)
			new /obj/item/weapon/spellbook/oneuse/summonitem(src)
		if(23)
			new /obj/item/organ/heart/cursed/wizard(src)


//Spooky special loot

/obj/item/device/wisp_lantern
	name = "spooky lantern"
	desc = "This lantern gives off no light, but is home to a friendly wisp."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "lantern-blue"
	var/obj/effect/wisp/wisp

/obj/item/device/wisp_lantern/attack_self(mob/user)
	if(!wisp)
		to_chat(user, "<span class='warning'>The wisp has gone missing!</span>")
		return
	if(wisp.loc == src)
		to_chat(user, "<span class='notice'>You release the wisp. It begins to bob around your head.</span>")
		user.sight |= SEE_MOBS
		icon_state = "lantern"
		wisp.orbit(user, 20)
		feedback_add_details("wisp_lantern","F") // freed

	else
		to_chat(user, "<span class='notice'>You return the wisp to the lantern.</span>")

		if(wisp.orbiting)
			var/atom/A = wisp.orbiting.orbiting
			if(isliving(A))
				var/mob/living/M = A
				M.sight &= ~SEE_MOBS
				to_chat(M, "<span class='notice'>Your vision returns to normal.</span>")

		wisp.stop_orbit()
		wisp.loc = src
		icon_state = "lantern-blue"
		feedback_add_details("wisp_lantern","R") // returned

/obj/item/device/wisp_lantern/New()
	..()
	wisp = new(src)

/obj/item/device/wisp_lantern/Destroy()
	if(wisp)
		if(wisp.loc == src)
			qdel(wisp)
		else
			wisp.visible_message("<span class='notice'>[wisp] has a sad feeling for a moment, then it passes.</span>")
	..()

//Wisp Lantern
/obj/effect/wisp
	name = "friendly wisp"
	desc = "Happy to light your way."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "orb"
	luminosity = 9
	layer = ABOVE_ALL_MOB_LAYER
	burn_state = LAVA_PROOF

/obj/item/device/warp_cube
	name = "blue cube"
	desc = "A mysterious blue cube."
	icon = 'icons/obj/lavaland/artefacts.dmi'
	icon_state = "blue_cube"
	var/obj/item/device/warp_cube/linked


//Red/Blue Cubes

/obj/item/device/warp_cube/attack_self(mob/user)
	if(!linked)
		to_chat(user, "[src] fizzles uselessly.")
		return
	new /obj/effect/particle_effect/smoke(user.loc)
	user.forceMove(get_turf(linked))
	feedback_add_details("warp_cube","[src.type]")
	new /obj/effect/particle_effect/smoke(user.loc)

/obj/item/device/warp_cube/red
	name = "red cube"
	desc = "A mysterious red cube."
	icon_state = "red_cube"

/obj/item/device/warp_cube/red/New()
	..()
	if(!linked)
		var/obj/item/device/warp_cube/blue = new(src.loc)
		linked = blue
		blue.linked = src

//Meat Hook
/obj/item/weapon/gun/magic/hook
	name = "meat hook"
	desc = "Mid or feed."
	ammo_type = /obj/item/ammo_casing/magic/hook
	icon_state = "hook"
	item_state = "chain"
	fire_sound = 'sound/weapons/meathook_fire.ogg'
	max_charges = 1
	flags = NOBLUDGEON
	force = 18

/obj/item/ammo_casing/magic/hook
	name = "hook"
	desc = "a hook."
	projectile_type = /obj/item/projectile/hook
	caliber = "hook"
	icon_state = "hook"

/obj/item/projectile/hook
	name = "hook"
	icon_state = "hook"
	icon = 'icons/obj/lavaland/artefacts.dmi'
	pass_flags = PASSTABLE
	damage = 25
	armour_penetration = 100
	damage_type = BRUTE
	hitsound = 'sound/effects/get_over_here.ogg'
	weaken = 3
	var/chain

/obj/item/projectile/hook/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "chain", time = INFINITY, maxdistance = INFINITY)
	..()
<<<<<<< HEAD
	//TODO: root the firer until the chain returns
=======
	var/obj/item/projectile/hook/P = BB
	spawn(1)
		P.chain = P.Beam(user,icon_state="chain",icon = 'icons/obj/lavaland/artefacts.dmi',time=1000, maxdistance = 30,alphafade=0)
>>>>>>> 28ddabeef062fb57d651603d8047812b7521a8ee

/obj/item/projectile/hook/on_hit(atom/target)
	. = ..()
	if(istype(target, /atom/movable))
		var/atom/movable/A = target
		if(A.anchored)
			return
		A.visible_message("<span class='danger'>[A] is snagged by [firer]'s hook!</span>")
		new /datum/forced_movement(A, get_turf(firer), 5, TRUE)
		//TODO: keep the chain beamed to A
		//TODO: needs a callback to delete the chain

/obj/item/projectile/hook/Destroy()
	qdel(chain)
	return ..()


//Immortality Talisman
/obj/item/device/immortality_talisman
	name = "Immortality Talisman"
	desc = "A dread talisman that can render you completely invulnerable."
	icon = 'icons/obj/lavaland/artefacts.dmi'
	icon_state = "talisman"
	actions_types = list(/datum/action/item_action/immortality)
	var/cooldown = 0

/datum/action/item_action/immortality
	name = "Immortality"

/obj/item/device/immortality_talisman/Destroy(force)
	if(force)
		. = ..()
	else
		return QDEL_HINT_LETMELIVE

/obj/item/device/immortality_talisman/attack_self(mob/user)
	if(cooldown < world.time)
		feedback_add_details("immortality_talisman","U") // usage
		cooldown = world.time + 600
		user.visible_message("<span class='danger'>[user] vanishes from reality, leaving a a hole in [user.p_their()] place!</span>")
		var/obj/effect/immortality_talisman/Z = new(get_turf(src.loc))
		Z.name = "hole in reality"
		Z.desc = "It's shaped an awful lot like [user.name]."
		Z.setDir(user.dir)
		user.forceMove(Z)
		user.notransform = 1
		user.status_flags |= GODMODE
		spawn(100)
			user.status_flags -= GODMODE
			user.notransform = 0
			user.forceMove(get_turf(Z))
			user.visible_message("<span class='danger'>[user] pops back into reality!</span>")
			Z.can_destroy = TRUE
			qdel(Z)

/obj/effect/immortality_talisman
	icon_state = "blank"
	icon = 'icons/effects/effects.dmi'
	var/can_destroy = FALSE

/obj/effect/immortality_talisman/attackby()
	return

/obj/effect/immortality_talisman/ex_act()
	return

/obj/effect/immortality_talisman/singularity_pull()
	return 0

/obj/effect/immortality_talisman/Destroy(force)
	if(!can_destroy && !force)
		return QDEL_HINT_LETMELIVE
	else
		. = ..()


//Shared Bag

//Internal

/obj/item/weapon/storage/backpack/shared
	name = "paradox bag"
	desc = "Somehow, it's in two places at once."
	max_combined_w_class = 60
	max_w_class = WEIGHT_CLASS_NORMAL


//External

/obj/item/device/shared_storage
	name = "paradox bag"
	desc = "Somehow, it's in two places at once."
	icon = 'icons/obj/storage.dmi'
	icon_state = "cultpack"
	slot_flags = SLOT_BACK
	var/obj/item/weapon/storage/backpack/shared/bag


/obj/item/device/shared_storage/red
	name = "paradox bag"
	desc = "Somehow, it's in two places at once."

/obj/item/device/shared_storage/red/New()
	..()
	if(!bag)
		var/obj/item/weapon/storage/backpack/shared/S = new(src)
		var/obj/item/device/shared_storage/blue = new(src.loc)

		src.bag = S
		blue.bag = S


/obj/item/device/shared_storage/attackby(obj/item/W, mob/user, params)
	if(bag)
		bag.loc = user
		bag.attackby(W, user, params)


/obj/item/device/shared_storage/attack_hand(mob/living/carbon/user)
	if(!iscarbon(user))
		return
	if(loc == user && user.back && user.back == src)
		if(bag)
			bag.loc = user
			bag.attack_hand(user)
	else
		..()


/obj/item/device/shared_storage/MouseDrop(atom/over_object)
	if(iscarbon(usr) || isdrone(usr))
		var/mob/M = usr

		if(!over_object)
			return

		if (istype(usr.loc,/obj/mecha))
			return

		if(!M.incapacitated())
			playsound(loc, "rustle", 50, 1, -5)


			if(istype(over_object, /obj/screen/inventory/hand))
				var/obj/screen/inventory/hand/H = over_object
				M.putItemFromInventoryInHandIfPossible(src, H.held_index)

			add_fingerprint(usr)


//Boat

/obj/vehicle/lavaboat
	name = "lava boat"
	desc = "A boat used for traversing lava."
	icon_state = "goliath_boat"
	icon = 'icons/obj/lavaland/dragonboat.dmi'
	resistance_flags = LAVA_PROOF | FIRE_PROOF

/obj/vehicle/lavaboat/buckle_mob(mob/living/M, force = 0, check_loc = 1)
	. = ..()
	riding_datum = new/datum/riding/boat

/obj/item/weapon/oar
	name = "oar"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "oar"
	item_state = "oar"
	desc = "Not to be confused with the kind Research hassles you for."
	force = 12
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = LAVA_PROOF | FIRE_PROOF

/datum/crafting_recipe/oar
	name = "goliath bone oar"
	result = /obj/item/weapon/oar
	reqs = list(/obj/item/stack/sheet/bone = 2)
	time = 15
	category = CAT_PRIMAL

/datum/crafting_recipe/boat
	name = "goliath hide boat"
	result = /obj/vehicle/lavaboat
	reqs = list(/obj/item/stack/sheet/animalhide/goliath_hide = 3)
	time = 50
	category = CAT_PRIMAL

//Dragon Boat


/obj/item/ship_in_a_bottle
	name = "ship in a bottle"
	desc = "A tiny ship inside a bottle."
	icon = 'icons/obj/lavaland/artefacts.dmi'
	icon_state = "ship_bottle"

/obj/item/ship_in_a_bottle/attack_self(mob/user)
	to_chat(user, "You're not sure how they get the ships in these things, but you're pretty sure you know how to get it out.")
	playsound(user.loc, 'sound/effects/Glassbr1.ogg', 100, 1)
	new /obj/vehicle/lavaboat/dragon(get_turf(src))
	qdel(src)

/obj/vehicle/lavaboat/dragon
	name = "mysterious boat"
	desc = "This boat moves where you will it, without the need for an oar."
	icon_state = "dragon_boat"

/obj/vehicle/lavaboat/dragon/buckle_mob(mob/living/M, force = 0, check_loc = 1)
	..()
	riding_datum = new/datum/riding/boat/dragon

//Potion of Flight
/obj/item/weapon/reagent_containers/glass/bottle/potion
	icon = 'icons/obj/lavaland/artefacts.dmi'
	icon_state = "potionflask"
	w_class = 2
	var/used = FALSE

/obj/item/weapon/wingpotion/attack_self(mob/living/M)
	if(used)
		M << "<span class='notice'>The flask is empty, what a shame.</span>"
	else
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			CHECK_DNA_AND_SPECIES(C)
			if(C.wear_mask)
				C << "<span class='notice'>It's pretty hard to drink something with a mask on!</span>"
			else
				if(!ishumanbasic(C)) //implying xenoshumans are holy
					C << "<span class='notice'>You down the elixir, noting nothing else but a terrible aftertaste.</span>"
				else
					C << "<span class='userdanger'>You down the elixir, a terrible pain travels down your back as wings burst out!</span>"
					C.set_species(/datum/species/angel)
					playsound(loc, 'sound/items/poster_ripped.ogg', 50, 1, -1)
					C.adjustBruteLoss(20)
					C.emote("scream")
				playsound(loc, 'sound/items/drink.ogg', 50, 1, -1)
				src.used = TRUE

/obj/item/weapon/reagent_containers/glass/bottle/potion/flight
	name = "strange elixir"
	desc = "A flask with an almost-holy aura emitting from it. The label on the bottle says: 'erqo'hyy tvi'rf lbh jv'atf'."
	list_reagents = list("flightpotion" = 5)

/obj/item/weapon/reagent_containers/glass/bottle/potion/update_icon()
	if(reagents.total_volume)
		icon_state = "potionflask"
	else
		icon_state = "potionflask_empty"

/datum/reagent/flightpotion
	name = "Flight Potion"
	id = "flightpotion"
	description = "Strange mutagenic compound of unknown origins."
	reagent_state = LIQUID
	color = "#FFEBEB"

/datum/reagent/flightpotion/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(M) && M.stat != DEAD)
		if(!ishumanbasic(M) || reac_volume < 5) // implying xenohumans are holy
			if(method == INGEST && show_message)
				to_chat(M, "<span class='notice'><i>You feel nothing but a terrible aftertaste.</i></span>")
			return ..()

		to_chat(M, "<span class='userdanger'>A terrible pain travels down your back as wings burst out!</span>")
		M.set_species(/datum/species/angel)
		playsound(M.loc, 'sound/items/poster_ripped.ogg', 50, 1, -1)
		M.adjustBruteLoss(20)
		M.emote("scream")
	..()


///Bosses




//Dragon

/obj/structure/closet/crate/necropolis/dragon
	name = "dragon chest"

/obj/structure/closet/crate/necropolis/dragon/New()
	new /obj/item/weapon/dragons_blood(src)

/obj/item/weapon/melee/ghost_sword
	name = "\improper spectral blade"
	desc = "A rusted and dulled blade. It doesn't look like it'd do much damage. It glows weakly."
	icon_state = "spectral"
	item_state = "spectral"
	flags = CONDUCT
	sharpness = IS_SHARP
	w_class = WEIGHT_CLASS_BULKY
	force = 1
	throwforce = 1
	hitsound = 'sound/effects/ghost2.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "rended")
	var/summon_cooldown = 0
	var/list/mob/dead/observer/spirits

/obj/item/weapon/melee/ghost_sword/New()
	..()
	spirits = list()
	START_PROCESSING(SSobj, src)
	GLOB.poi_list |= src

/obj/item/weapon/melee/ghost_sword/Destroy()
	for(var/mob/dead/observer/G in spirits)
		G.invisibility = GLOB.observer_default_invisibility
	spirits.Cut()
	STOP_PROCESSING(SSobj, src)
	GLOB.poi_list -= src
	. = ..()

/obj/item/weapon/melee/ghost_sword/attack_self(mob/user)
	if(summon_cooldown > world.time)
		to_chat(user, "You just recently called out for aid. You don't want to annoy the spirits.")
		return
	to_chat(user, "You call out for aid, attempting to summon spirits to your side.")

	notify_ghosts("[user] is raising [user.p_their()] [src], calling for your help!",
		enter_link="<a href=?src=\ref[src];orbit=1>(Click to help)</a>",
		source = user, action=NOTIFY_ORBIT)

	summon_cooldown = world.time + 600

/obj/item/weapon/melee/ghost_sword/Topic(href, href_list)
	if(href_list["orbit"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.ManualFollow(src)

/obj/item/weapon/melee/ghost_sword/process()
	ghost_check()

/obj/item/weapon/melee/ghost_sword/proc/ghost_check()
	var/ghost_counter = 0
	var/turf/T = get_turf(src)
	var/list/contents = T.GetAllContents()
	var/mob/dead/observer/current_spirits = list()
	var/list/orbiters = list()
	for(var/thing in contents)
		var/atom/A = thing
		if (A.orbiters)
			orbiters += A.orbiters

	for(var/thing in orbiters)
		var/datum/orbit/O = thing
		if (isobserver(O.orbiter))
			var/mob/dead/observer/G = O.orbiter
			ghost_counter++
			G.invisibility = 0
			current_spirits |= G

	for(var/mob/dead/observer/G in spirits - current_spirits)
		G.invisibility = GLOB.observer_default_invisibility

	spirits = current_spirits

	return ghost_counter

/obj/item/weapon/melee/ghost_sword/attack(mob/living/target, mob/living/carbon/human/user)
	force = 0
	var/ghost_counter = ghost_check()

	force = Clamp((ghost_counter * 4), 0, 75)
	user.visible_message("<span class='danger'>[user] strikes with the force of [ghost_counter] vengeful spirits!</span>")
	..()

/obj/item/weapon/melee/ghost_sword/hit_reaction(mob/living/carbon/human/owner, attack_text, final_block_chance, damage, attack_type)
	var/ghost_counter = ghost_check()
	final_block_chance += Clamp((ghost_counter * 5), 0, 75)
	owner.visible_message("<span class='danger'>[owner] is protected by a ring of [ghost_counter] ghosts!</span>")
	return ..()

//Blood

/obj/item/weapon/dragons_blood
	name = "bottle of dragons blood"
	desc = "You're not actually going to drink this, are you?"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "vial"

/obj/item/weapon/dragons_blood/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return

	var/mob/living/carbon/human/H = user
	user << "<span class='danger'>You feel like you could walk straight through lava now.</span>"
	H.weather_immunities |= "lava"

	playsound(user.loc,'sound/items/drink.ogg', rand(10,50), 1)
	qdel(src)

/datum/disease/transformation/dragon
	name = "dragon transformation"
	cure_text = "nothing"
	cures = list("adminordrazine")
	agent = "dragon's blood"
	desc = "What do dragons have to do with Space Station 13?"
	stage_prob = 20
	severity = BIOHAZARD
	visibility_flags = 0
	stage1	= list("Your bones ache.")
	stage2	= list("Your skin feels scaley.")
	stage3	= list("<span class='danger'>You have an overwhelming urge to terrorize some peasants.</span>", "<span class='danger'>Your teeth feel sharper.</span>")
	stage4	= list("<span class='danger'>Your blood burns.</span>")
	stage5	= list("<span class='danger'>You're a fucking dragon. However, any previous allegiances you held still apply. It'd be incredibly rude to eat your still human friends for no reason.</span>")
	new_form = /mob/living/simple_animal/hostile/megafauna/dragon/lesser


//Lava Staff

/obj/item/weapon/lava_staff
	name = "staff of lava"
	desc = "The ability to fill the emergency shuttle with lava. What more could you want out of life?"
	icon_state = "staffofstorms"
	item_state = "staffofstorms"
	icon = 'icons/obj/guns/magic.dmi'
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	force = 25
	damtype = BURN
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	hitsound = 'sound/weapons/sear.ogg'
	var/turf_type = /turf/open/floor/plating/lava/smooth
	var/transform_string = "lava"
	var/reset_turf_type = /turf/open/floor/plating/asteroid/basalt
	var/reset_string = "basalt"
	var/create_cooldown = 100
	var/create_delay = 30
	var/reset_cooldown = 50
	var/timer = 0
	var/banned_turfs

/obj/item/weapon/lava_staff/New()
	. = ..()
	banned_turfs = typecacheof(list(/turf/open/space/transit, /turf/closed))

/obj/item/weapon/lava_staff/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	if(timer > world.time)
		return

	if(is_type_in_typecache(target, banned_turfs))
		return

	if(target in view(user.client.view, get_turf(user)))

		var/turf/open/T = get_turf(target)
		if(!istype(T))
			return
		if(!istype(T, turf_type))
			var/obj/effect/overlay/temp/lavastaff/L = new /obj/effect/overlay/temp/lavastaff(T)
			L.alpha = 0
			animate(L, alpha = 255, time = create_delay)
			user.visible_message("<span class='danger'>[user] points [src] at [T]!</span>")
			timer = world.time + create_delay + 1
			if(do_after(user, create_delay, target = T))
				var/old_name = T.name
				if(T.TerraformTurf(turf_type))
					user.visible_message("<span class='danger'>[user] turns \the [old_name] into [transform_string]!</span>")
					message_admins("[key_name_admin(user)] fired the lava staff at [get_area(target)]. [ADMIN_COORDJMP(T)]")
					log_game("[key_name(user)] fired the lava staff at [get_area(target)] [COORD(T)].")
					timer = world.time + create_cooldown
					playsound(T,'sound/magic/Fireball.ogg', 200, 1)
			else
				timer = world.time
			qdel(L)
		else
			var/old_name = T.name
			if(T.TerraformTurf(reset_turf_type))
				user.visible_message("<span class='danger'>[user] turns \the [old_name] into [reset_string]!</span>")
				timer = world.time + reset_cooldown
				playsound(T,'sound/magic/Fireball.ogg', 200, 1)

/obj/effect/overlay/temp/lavastaff
	icon_state = "lavastaff_warn"
	duration = 50

//Runite Scimitar

/obj/item/weapon/rune_scimmy
	name = "rune scimitar"
	desc = "A curved sword smelted from an unknown metal. Looking at it gives you the otherworldly urge to pawn it off for '30k,' whatever that means."
	icon = 'icons/obj/lavaland/artefacts.dmi'
	icon_state = "rune_scimmy"
	force = 25
	damtype = BRUTE
	sharpness = IS_SHARP
	hitsound = 'sound/weapons/rs_slash.ogg'
	attack_verb = list("slashed","pk'd","atk'd")

///Bubblegum

/obj/item/mayhem
	name = "mayhem in a bottle"
	desc = "A magically infused bottle of blood, the scent of which will drive anyone nearby into a murderous frenzy."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "vial"

/obj/item/mayhem/attack_self(mob/user)
	for(var/mob/living/carbon/human/H in range(7,user))
		spawn()
			var/obj/effect/mine/pickup/bloodbath/B = new(H)
			B.mineEffect(H)
	to_chat(user, "<span class='notice'>You shatter the bottle!</span>")
	playsound(user.loc, 'sound/effects/Glassbr1.ogg', 100, 1)
	qdel(src)

/obj/structure/closet/crate/necropolis/bubblegum
	name = "bubblegum chest"

/obj/structure/closet/crate/necropolis/bubblegum/New()
	..()
	var/loot = rand(1,3)
	switch(loot)
		if(1)
			new /obj/item/weapon/antag_spawner/slaughter_demon(src)
		if(2)
			new /obj/item/bloodvial/bloodcrawl(src)
		if(3)
			new /obj/item/bloodvial/saw(src)

/obj/item/blood_contract
	name = "blood contract"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"
	color = "#FF0000"
	desc = "Mark your target for death. "
	var/used = FALSE

/obj/item/blood_contract/attack_self(mob/user)
	if(used)
		return
	used = TRUE
	var/choice = input(user,"Who do you want dead?","Choose Your Victim") as null|anything in GLOB.player_list

	if(!(isliving(choice)))
		to_chat(user, "[choice] is already dead!")
		used = FALSE
		return
	if(choice == user)
		to_chat(user, "You feel like writing your own name into a cursed death warrant would be unwise.")
		used = FALSE
		return
	else

		var/mob/living/L = choice

		message_admins("<span class='adminnotice'>[L] has been marked for death!</span>")

		var/datum/objective/survive/survive = new
		survive.owner = L.mind
		L.mind.objectives += survive
		to_chat(L, "<span class='userdanger'>You've been marked for death! Don't let the demons get you!</span>")
		L.add_atom_colour("#FF0000", ADMIN_COLOUR_PRIORITY)
		spawn()
			var/obj/effect/mine/pickup/bloodbath/B = new(L)
			B.mineEffect(L)

		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H == L)
				continue
			to_chat(H, "<span class='userdanger'>You have an overwhelming desire to kill [L]. [L.p_they(TRUE)] [L.p_have()] been marked red! Go kill [L.p_them()]!</span>")
			H.put_in_hands_or_del(new /obj/item/weapon/kitchen/knife/butcher(H))

	qdel(src)

/obj/item/bloodvial//parent typing for identical looking loot
	name = "vial of blood" //aestetically identical to the demon spawner
	desc = "A magically infused bottle of blood, distilled from countless murder victims. Used in unholy rituals to attract horrifying creatures."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "vial"
	var/waiting = FALSE


/obj/item/bloodvial/bloodcrawl

/obj/item/bloodvial/bloodcrawl/attack_self(mob/living/carbon/user)
	if(waiting)
		return
	if(user.z != ZLEVEL_STATION) //so you can't see if it's demon spawner on lavaland
		user << "<span class='notice'>You should probably wait until you reach the station.</span>"
		return
	user << "<span class='notice'>You start working up the nerve to shatter the bottle...</span>"
	waiting = TRUE
	sleep(50)
	waiting = FALSE
	if(user.bloodcrawl == BLOODCRAWL || user.bloodcrawl == BLOODCRAWL_EAT)
		user <<"<span class='warning'>You break [src], but nothing happens.../span>"
		qdel(src)
		return
	user <<"<span class='warning'>You break [src], feeling immense power overcome you.../span>"
	user.bloodcrawl = BLOODCRAWL
	playsound(user.loc, 'sound/effects/Glassbr1.ogg', 100, 1)
	qdel(src)

/obj/item/bloodvial/saw

/obj/item/bloodvial/saw/attack_self(mob/living/carbon/user)
	if(user.z != ZLEVEL_STATION) //so you can't see if it's demon spawner on lavaland
		user << "<span class='notice'>You should probably wait until you reach the station.</span>"
		return
	playsound(user.loc, 'sound/effects/Glassbr1.ogg', 100, 1)
	user.unEquip(src)
	var/obj/item/weapon/chainsaw_bubblegum/C = new
	user.put_in_active_hand(C)
	qdel(src)


/obj/item/weapon/chainsaw_bubblegum
	name = "demonic chainsaw"
	desc = "You almost regret picking this up."
	force = 28
	icon_state = "chainsaw_on"
	item_state = "mounted_chainsaw"
	w_class = 5
	flags = NODROP | ABSTRACT
	sharpness = IS_SHARP
	attack_verb = list("sawed", "torn", "cut", "chopped", "diced","eviscerated")
	hitsound = 'sound/weapons/chainsawhit.ogg'
	armour_penetration = 30
	color = "#FF0000"
	block_chance = 30
	var/recalled = FALSE

/obj/item/weapon/chainsaw_bubblegum/equipped(mob/living/user)
	..()
	for(var/obj/effect/proc_holder/spell/targeted/summonsaw/spell in user.mind.spell_list)
		user.mind.RemoveSpell(spell)//removes summon spell if they got it before
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/summonsaw(src))

/obj/item/weapon/chainsaw_bubblegum/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is feeding \himself to \the [src.name]! It looks like \he's trying to join Bubblegum!</span>")
	visible_message("<span class='warning'><b>[src] devours [user]!</b></span>")
	playsound(user.loc, 'sound/magic/Demon_consume.ogg', 100, 1)
	qdel(user)

/obj/item/weapon/chainsaw_bubblegum/afterattack(mob/living/target, mob/living/user)
	..()
	if(ishuman(target))
		if(target.stat != DEAD)
			user.adjustBruteLoss(-(force / 2))
			user << "<span class='notice'>[src] absorbs the strength of [target] and rejuvenates you!</span>"

/obj/effect/proc_holder/spell/targeted/summonsaw
	name = "Summon Chainsaw"
	desc = "Summon Bubblegum's Chainsaw."
	action_icon_state = "bloodcrawl"
	charge_max = 10
	clothes_req = 0
	range = -1
	level_max = 0
	include_user = 1


/obj/effect/proc_holder/spell/targeted/summonsaw/cast(mob/living/carbon/human/user)
	if(locate(/obj/item/weapon/chainsaw_bubblegum) in user)
		var/obj/item/weapon/chainsaw_bubblegum/S = locate(/obj/item/weapon/chainsaw_bubblegum)
		if(S.recalled == FALSE)
			S.flags &= ~NODROP
			user.unEquip(S)
			S.loc = user
			user.visible_message("<span class='warning'><b>[S] assimilates itself into [usr]'s body!</b></span>")
			playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 100, 1, -1)
			S.recalled = TRUE
		else
			S.flags |= NODROP
			user.put_in_active_hand(S)
			user.visible_message("<span class='warning'><b>[user]'s arm is suddenly engulfed in blood, which molds itself into [S]!</b></span>")
			playsound(get_turf(user), 'sound/magic/exit_blood.ogg', 100, 1, -1)
			playsound(get_turf(user),'sound/effects/splat.ogg', 100, 1, -1)
			S.recalled = FALSE
	else
		user.mind.RemoveSpell(src)

//Hierophant
/obj/item/weapon/hierophant_club
	name = "hierophant club"
	desc = "The strange technology of this large club allows various nigh-magical feats. It used to beat you, but now you can set the beat."
	icon_state = "hierophant_club_ready_beacon"
	item_state = "hierophant_club_ready_beacon"
	icon = 'icons/obj/lavaland/artefacts.dmi'
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	force = 15
	hitsound = 'sound/weapons/sonic_jackhammer.ogg'
	actions_types = list(/datum/action/item_action/vortex_recall, /datum/action/item_action/toggle_unfriendly_fire)
	var/cooldown_time = 20 //how long the cooldown between non-melee ranged attacks is
	var/chaser_cooldown = 81 //how long the cooldown between firing chasers at mobs is
	var/chaser_timer = 0 //what our current chaser cooldown is
	var/chaser_speed = 0.8 //how fast our chasers are
	var/timer = 0 //what our current cooldown is
	var/blast_range = 13 //how long the cardinal blast's walls are
	var/obj/effect/hierophant/beacon //the associated beacon we teleport to
	var/teleporting = FALSE //if we ARE teleporting
	var/friendly_fire_check = FALSE //if the blasts we make will consider our faction against the faction of hit targets

/obj/item/weapon/hierophant_club/examine(mob/user)
	..()
	to_chat(user, "<span class='hierophant_warning'>The[beacon ? " beacon is not currently":"re is a beacon"] attached.</span>")

/obj/item/weapon/hierophant_club/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	var/turf/T = get_turf(target)
	if(!T || timer > world.time)
		return
	calculate_anger_mod(user)
	timer = world.time + CLICK_CD_MELEE //by default, melee attacks only cause melee blasts, and have an accordingly short cooldown
	if(proximity_flag)
		INVOKE_ASYNC(src, .proc/aoe_burst, T, user)
		add_logs(user, target, "fired 3x3 blast at", src)
	else
		if(ismineralturf(target) && get_dist(user, target) < 6) //target is minerals, we can hit it(even if we can't see it)
			INVOKE_ASYNC(src, .proc/cardinal_blasts, T, user)
			timer = world.time + cooldown_time
		else if(target in view(5, get_turf(user))) //if the target is in view, hit it
			timer = world.time + cooldown_time
			if(isliving(target) && chaser_timer <= world.time) //living and chasers off cooldown? fire one!
				chaser_timer = world.time + chaser_cooldown
				new /obj/effect/overlay/temp/hierophant/chaser(get_turf(user), user, target, chaser_speed, friendly_fire_check)
				add_logs(user, target, "fired a chaser at", src)
			else
				INVOKE_ASYNC(src, .proc/cardinal_blasts, T, user) //otherwise, just do cardinal blast
				add_logs(user, target, "fired cardinal blast at", src)
		else
			to_chat(user, "<span class='warning'>That target is out of range!</span>" )
			timer = world.time
	INVOKE_ASYNC(src, .proc/prepare_icon_update)

/obj/item/weapon/hierophant_club/proc/calculate_anger_mod(mob/user) //we get stronger as the user loses health
	chaser_cooldown = initial(chaser_cooldown)
	cooldown_time = initial(cooldown_time)
	chaser_speed = initial(chaser_speed)
	blast_range = initial(blast_range)
	if(isliving(user))
		var/mob/living/L = user
		var/health_percent = L.health / L.maxHealth
		chaser_cooldown += round(health_percent * 20) //two tenths of a second for each missing 10% of health
		cooldown_time += round(health_percent * 10) //one tenth of a second for each missing 10% of health
		chaser_speed = max(chaser_speed + health_percent, 0.5) //one tenth of a second faster for each missing 10% of health
		blast_range -= round(health_percent * 10) //one additional range for each missing 10% of health

/obj/item/weapon/hierophant_club/update_icon()
	icon_state = "hierophant_club[timer <= world.time ? "_ready":""][(beacon && !QDELETED(beacon)) ? "":"_beacon"]"
	item_state = icon_state
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
		M.update_inv_back()

/obj/item/weapon/hierophant_club/proc/prepare_icon_update()
	update_icon()
	sleep(timer - world.time)
	update_icon()

/obj/item/weapon/hierophant_club/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/toggle_unfriendly_fire)) //toggle friendly fire...
		friendly_fire_check = !friendly_fire_check
		to_chat(user, "<span class='warning'>You toggle friendly fire [friendly_fire_check ? "off":"on"]!</span>")
		return
	if(timer > world.time)
		return
	if(!user.is_holding(src)) //you need to hold the staff to teleport
		to_chat(user, "<span class='warning'>You need to hold the club in your hands to [beacon ? "teleport with it":"detach the beacon"]!</span>")
		return
	if(!beacon || QDELETED(beacon))
		if(isturf(user.loc))
			user.visible_message("<span class='hierophant_warning'>[user] starts fiddling with [src]'s pommel...</span>", \
			"<span class='notice'>You start detaching the hierophant beacon...</span>")
			timer = world.time + 51
			INVOKE_ASYNC(src, .proc/prepare_icon_update)
			if(do_after(user, 50, target = user) && !beacon)
				var/turf/T = get_turf(user)
				playsound(T,'sound/magic/Blind.ogg', 200, 1, -4)
				new /obj/effect/overlay/temp/hierophant/telegraph/teleport(T, user)
				beacon = new/obj/effect/hierophant(T)
				user.update_action_buttons_icon()
				user.visible_message("<span class='hierophant_warning'>[user] places a strange machine beneath [user.p_their()] feet!</span>", \
				"<span class='hierophant'>You detach the hierophant beacon, allowing you to teleport yourself and any allies to it at any time!</span>\n\
				<span class='notice'>You can remove the beacon to place it again by striking it with the club.</span>")
			else
				timer = world.time
				INVOKE_ASYNC(src, .proc/prepare_icon_update)
		else
			to_chat(user, "<span class='warning'>You need to be on solid ground to detach the beacon!</span>")
		return
	if(get_dist(user, beacon) <= 2) //beacon too close abort
		to_chat(user, "<span class='warning'>You are too close to the beacon to teleport to it!</span>")
		return
	if(is_blocked_turf(get_turf(beacon), TRUE))
		to_chat(user, "<span class='warning'>The beacon is blocked by something, preventing teleportation!</span>")
		return
	if(!isturf(user.loc))
		to_chat(user, "<span class='warning'>You don't have enough space to teleport from here!</span>")
		return
	teleporting = TRUE //start channel
	user.update_action_buttons_icon()
	user.visible_message("<span class='hierophant_warning'>[user] starts to glow faintly...</span>")
	timer = world.time + 50
	INVOKE_ASYNC(src, .proc/prepare_icon_update)
	beacon.icon_state = "hierophant_tele_on"
	var/obj/effect/overlay/temp/hierophant/telegraph/edge/TE1 = new /obj/effect/overlay/temp/hierophant/telegraph/edge(user.loc)
	var/obj/effect/overlay/temp/hierophant/telegraph/edge/TE2 = new /obj/effect/overlay/temp/hierophant/telegraph/edge(beacon.loc)
	if(do_after(user, 40, target = user) && user && beacon)
		var/turf/T = get_turf(beacon)
		var/turf/source = get_turf(user)
		if(is_blocked_turf(T, TRUE))
			teleporting = FALSE
			to_chat(user, "<span class='warning'>The beacon is blocked by something, preventing teleportation!</span>")
			user.update_action_buttons_icon()
			timer = world.time
			INVOKE_ASYNC(src, .proc/prepare_icon_update)
			beacon.icon_state = "hierophant_tele_off"
			return
		new /obj/effect/overlay/temp/hierophant/telegraph(T, user)
		new /obj/effect/overlay/temp/hierophant/telegraph(source, user)
		playsound(T,'sound/magic/Wand_Teleport.ogg', 200, 1)
		playsound(source,'sound/machines/AirlockOpen.ogg', 200, 1)
		if(!do_after(user, 3, target = user) || !user || !beacon || QDELETED(beacon)) //no walking away shitlord
			teleporting = FALSE
			if(user)
				user.update_action_buttons_icon()
			timer = world.time
			INVOKE_ASYNC(src, .proc/prepare_icon_update)
			if(beacon)
				beacon.icon_state = "hierophant_tele_off"
			return
		if(is_blocked_turf(T, TRUE))
			teleporting = FALSE
			to_chat(user, "<span class='warning'>The beacon is blocked by something, preventing teleportation!</span>")
			user.update_action_buttons_icon()
			timer = world.time
			INVOKE_ASYNC(src, .proc/prepare_icon_update)
			beacon.icon_state = "hierophant_tele_off"
			return
		add_logs(user, beacon, "teleported self from ([source.x],[source.y],[source.z]) to")
		new /obj/effect/overlay/temp/hierophant/telegraph/teleport(T, user)
		new /obj/effect/overlay/temp/hierophant/telegraph/teleport(source, user)
		for(var/t in RANGE_TURFS(1, T))
			var/obj/effect/overlay/temp/hierophant/blast/B = new /obj/effect/overlay/temp/hierophant/blast(t, user, TRUE) //blasts produced will not hurt allies
			B.damage = 30
		for(var/t in RANGE_TURFS(1, source))
			var/obj/effect/overlay/temp/hierophant/blast/B = new /obj/effect/overlay/temp/hierophant/blast(t, user, TRUE) //but absolutely will hurt enemies
			B.damage = 30
		for(var/mob/living/L in range(1, source))
			INVOKE_ASYNC(src, .proc/teleport_mob, source, L, T, user) //regardless, take all mobs near us along
		sleep(6) //at this point the blasts detonate
		if(beacon)
			beacon.icon_state = "hierophant_tele_off"
	else
		qdel(TE1)
		qdel(TE2)
		timer = world.time
		INVOKE_ASYNC(src, .proc/prepare_icon_update)
	if(beacon)
		beacon.icon_state = "hierophant_tele_off"
	teleporting = FALSE
	if(user)
		user.update_action_buttons_icon()

/obj/item/weapon/hierophant_club/proc/teleport_mob(turf/source, mob/M, turf/target, mob/user)
	var/turf/turf_to_teleport_to = get_step(target, get_dir(source, M)) //get position relative to caster
	if(!turf_to_teleport_to || is_blocked_turf(turf_to_teleport_to, TRUE))
		return
	animate(M, alpha = 0, time = 2, easing = EASE_OUT) //fade out
	sleep(1)
	if(!M)
		return
	M.visible_message("<span class='hierophant_warning'>[M] fades out!</span>")
	sleep(2)
	if(!M)
		return
	M.forceMove(turf_to_teleport_to)
	sleep(1)
	if(!M)
		return
	animate(M, alpha = 255, time = 2, easing = EASE_IN) //fade IN
	sleep(1)
	if(!M)
		return
	M.visible_message("<span class='hierophant_warning'>[M] fades in!</span>")
	if(user != M)
		add_logs(user, M, "teleported", null, "from ([source.x],[source.y],[source.z])")

/obj/item/weapon/hierophant_club/proc/cardinal_blasts(turf/T, mob/living/user) //fire cardinal cross blasts with a delay
	if(!T)
		return
	new /obj/effect/overlay/temp/hierophant/telegraph/cardinal(T, user)
	playsound(T,'sound/effects/bin_close.ogg', 200, 1)
	sleep(2)
	new /obj/effect/overlay/temp/hierophant/blast(T, user, friendly_fire_check)
	for(var/d in GLOB.cardinal)
		INVOKE_ASYNC(src, .proc/blast_wall, T, d, user)

/obj/item/weapon/hierophant_club/proc/blast_wall(turf/T, dir, mob/living/user) //make a wall of blasts blast_range tiles long
	if(!T)
		return
	var/range = blast_range
	var/turf/previousturf = T
	var/turf/J = get_step(previousturf, dir)
	for(var/i in 1 to range)
		if(!J)
			return
		new /obj/effect/overlay/temp/hierophant/blast(J, user, friendly_fire_check)
		previousturf = J
		J = get_step(previousturf, dir)

/obj/item/weapon/hierophant_club/proc/aoe_burst(turf/T, mob/living/user) //make a 3x3 blast around a target
	if(!T)
		return
	new /obj/effect/overlay/temp/hierophant/telegraph(T, user)
	playsound(T,'sound/effects/bin_close.ogg', 200, 1)
	sleep(2)
	for(var/t in RANGE_TURFS(1, T))
		new /obj/effect/overlay/temp/hierophant/blast(t, user, friendly_fire_check)

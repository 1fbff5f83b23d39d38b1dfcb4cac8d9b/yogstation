/turf
	//used for temperature calculations
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1
	var/temperature_archived

	//list of open turfs adjacent to us
	var/list/atmos_adjacent_turfs = list()
	//bitfield of dirs in which we are superconducitng
	var/atmos_supeconductivity = 0

	//used to determine whether we should archive
	var/archived_cycle = 0
	var/current_cycle = 0

	//used for mapping and for breathing while in walls (because that's a thing that needs to be accounted for...)
	//string parsed by /datum/gas/proc/copy_from_turf
	var/initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	//approximation of MOLES_O2STANDARD and MOLES_N2STANDARD pending byond allowing constant expressions to be embedded in constant strings
	// If someone will place 0 of some gas there, SHIT WILL BREAK. Do not do that.

/turf/open
	//used for spacewind
	var/pressure_difference = 0
	var/pressure_direction = 0

	var/datum/excited_group/excited_group
	var/excited = 0
	var/recently_active = 0
	var/datum/gas_mixture/air

	var/obj/effect/hotspot/active_hotspot
	var/atmos_cooldown  = 0
	var/planetary_atmos = FALSE //air will revert to initial_gas_mix over time

	var/list/atmos_overlay_types = list() //gas IDs of current active gas overlays

/turf/open/New()
	..()
	if(!blocks_air)
		air = new
		air.copy_from_turf(src)

/turf/open/Destroy()
	if(active_hotspot)
		qdel(active_hotspot)
		active_hotspot = null
	// Adds the adjacent turfs to the current atmos processing
	for(var/T in atmos_adjacent_turfs)
		SSair.add_to_active(T)
	return ..()

/////////////////GAS MIXTURE PROCS///////////////////

/turf/open/assume_air(datum/gas_mixture/giver) //use this for machines to adjust air
	if(!giver)
		return 0
	air.merge(giver)
	update_visuals()
	return 1

/turf/open/remove_air(amount)
	var/datum/gas_mixture/ours = return_air()
	var/datum/gas_mixture/removed = ours.remove(amount)
	update_visuals()
	return removed

/turf/open/proc/copy_air_with_tile(turf/open/T)
	if(istype(T))
		air.copy_from(T.air)

/turf/open/proc/copy_air(datum/gas_mixture/copy)
	if(copy)
		air.copy_from(copy)

/turf/return_air()
	var/datum/gas_mixture/GM = new
	GM.copy_from_turf(src)
	return GM

/turf/open/return_air()
	return air

/turf/temperature_expose()
	if(temperature > heat_capacity)
		to_be_destroyed = 1

/turf/proc/archive()
	temperature_archived = temperature

/turf/open/archive()
	air.archive()
	archived_cycle = SSair.times_fired
	..()

/////////////////////////GAS OVERLAYS//////////////////////////////

/turf/open/proc/update_visuals()
	var/list/new_overlay_types = tile_graphic()

	for(var/overlay in atmos_overlay_types-new_overlay_types) //doesn't remove overlays that would only be added
		overlays -= overlay
		atmos_overlay_types -= overlay

	for(var/overlay in new_overlay_types-atmos_overlay_types) //doesn't add overlays that already exist
		overlays += overlay

	atmos_overlay_types = new_overlay_types

/turf/open/proc/tile_graphic()
	. = new /list
	if(!air) //Tiles that block atmos don't have this var instantiated
		return
	var/list/gases = air.gases
	for(var/id in gases)
		var/gas = gases[id]
		if(gas[GAS_META][META_GAS_OVERLAY] && gas[MOLES] > gas[GAS_META][META_GAS_MOLES_VISIBLE])
			. += gas[GAS_META][META_GAS_OVERLAY]

/////////////////////////////SIMULATION///////////////////////////////////

/turf/proc/process_cell(fire_count)
	SSair.remove_from_active(src)

/turf/open/process_cell(fire_count)
	if(archived_cycle < fire_count) //archive self if not already done
		archive()

	current_cycle = fire_count
	var/remove = 1 //set by non simulated turfs who are sharing with this turf

	//cache for sanic speed
	var/list/adjacent_turfs = atmos_adjacent_turfs
	var/datum/excited_group/our_excited_group = excited_group
	var/adjacent_turfs_length = adjacent_turfs.len
	atmos_cooldown++
	if (planetary_atmos)
		adjacent_turfs_length++

	for(var/t in adjacent_turfs)
		var/turf/open/enemy_tile = t

		if(fire_count > enemy_tile.current_cycle)
			enemy_tile.archive()

		/******************* GROUP HANDLING START *****************************************************************/

			if(enemy_tile.excited)
				//cache for sanic speed
				var/datum/excited_group/enemy_excited_group = enemy_tile.excited_group
				if(our_excited_group)
					if(enemy_excited_group)
						if(our_excited_group != enemy_excited_group)
							//combine groups (this also handles updating the excited_group var of all involved turfs)
							our_excited_group.merge_groups(enemy_excited_group)
							our_excited_group = excited_group //update our cache
						share_air(enemy_tile, fire_count, adjacent_turfs_length) //share
					else
						if((recently_active == 1 && enemy_tile.recently_active == 1) || air.compare(enemy_tile.air))
							our_excited_group.add_turf(enemy_tile) //add enemy to our group
							share_air(enemy_tile, fire_count, adjacent_turfs_length) //share
				else
					if(enemy_excited_group)
						if((recently_active == 1 && enemy_tile.recently_active == 1) || air.compare(enemy_tile.air))
							enemy_excited_group.add_turf(src) //join self to enemy group
							our_excited_group = excited_group //update our cache
							share_air(enemy_tile, fire_count, adjacent_turfs_length) //share
					else
						if((recently_active == 1 && enemy_tile.recently_active == 1) || air.compare(enemy_tile.air))
							var/datum/excited_group/EG = new //generate new group
							EG.add_turf(src)
							EG.add_turf(enemy_tile)
							our_excited_group = excited_group //update our cache
							share_air(enemy_tile, fire_count, adjacent_turfs_length) //share
			else
				if(air.compare(enemy_tile.air)) //compare if
					SSair.add_to_active(enemy_tile) //excite enemy
					if(our_excited_group)
						excited_group.add_turf(enemy_tile) //add enemy to group
					else
						var/datum/excited_group/EG = new //generate new group
						EG.add_turf(src)
						EG.add_turf(enemy_tile)
						our_excited_group = excited_group //update our cache
					share_air(enemy_tile, fire_count, adjacent_turfs_length) //share

		/******************* GROUP HANDLING FINISH *********************************************************************/

	if (planetary_atmos) //share our air with the "atmosphere" "above" the turf
		var/datum/gas_mixture/G = new
		G.copy_from_turf(src)
		G.archive()
		if(air.compare(G))
			if(!our_excited_group)
				var/datum/excited_group/EG = new
				EG.add_turf(src)
				our_excited_group = excited_group
			air.share(G, adjacent_turfs_length)
			last_share_check()

	air.react()

	update_visuals()

	if(air.temperature > FIRE_MINIMUM_TEMPERATURE_TO_EXIST)
		hotspot_expose(air.temperature, CELL_VOLUME)
		for(var/atom/movable/item in src)
			item.temperature_expose(air, air.temperature, CELL_VOLUME)
		temperature_expose(air, air.temperature, CELL_VOLUME)

		if(air.temperature > MINIMUM_TEMPERATURE_START_SUPERCONDUCTION)
			if(consider_superconductivity(starting = 1))
				remove = 0

	if (atmos_cooldown > EXCITED_GROUP_DISMANTLE_CYCLES*2)
		SSair.remove_from_active(src)
	if(!our_excited_group && remove == 1)
		SSair.remove_from_active(src)


/turf/open/proc/share_air(turf/open/T, fire_count, adjacent_turfs_length)
	if(T.current_cycle < fire_count)
		var/difference = air.share(T.air, adjacent_turfs_length)
		if(difference)
			if(difference > 0)
				consider_pressure_difference(T, difference)
			else
				T.consider_pressure_difference(src, -difference)
		last_share_check()

//////////////////////////SPACEWIND/////////////////////////////

/turf/open/proc/consider_pressure_difference(turf/T, difference)
	SSair.high_pressure_delta |= src
	if(difference > pressure_difference)
		pressure_direction = get_dir(src, T)
		pressure_difference = difference

/turf/open/proc/last_share_check()
	if(air.last_share > MINIMUM_AIR_TO_SUSPEND)
		excited_group.reset_cooldowns()
		atmos_cooldown = 0
	else if(air.last_share > MINIMUM_MOLES_DELTA_TO_MOVE)
		excited_group.dismantle_cooldown = 0
		atmos_cooldown = 0

/turf/open/proc/high_pressure_movements()
	for(var/atom/movable/M in src)
		M.experience_pressure_difference(pressure_difference, pressure_direction)

/atom/movable/var/pressure_resistance = 5
/atom/movable/var/last_high_pressure_movement_air_cycle = 0
/atom/movable/proc/experience_pressure_difference(pressure_difference, direction)
	set waitfor = 0
	. = 0
	if(!anchored && !pulledby)
		. = 1
		if(pressure_difference > pressure_resistance && last_high_pressure_movement_air_cycle < SSair.times_fired)
			last_high_pressure_movement_air_cycle = SSair.times_fired
			step(src, direction)

///////////////////////////EXCITED GROUPS/////////////////////////////

/datum/excited_group
	var/list/turf_list = list()
	var/breakdown_cooldown = 0
	var/dismantle_cooldown = 0

/datum/excited_group/New()
	SSair.excited_groups += src

/datum/excited_group/proc/add_turf(turf/open/T)
	turf_list += T
	T.excited_group = src
	T.recently_active = 1
	reset_cooldowns()

/datum/excited_group/proc/merge_groups(datum/excited_group/E)
	if(turf_list.len > E.turf_list.len)
		SSair.excited_groups -= E
		for(var/t in E.turf_list)
			var/turf/open/T = t
			T.excited_group = src
			turf_list += T
			reset_cooldowns()
	else
		SSair.excited_groups -= src
		for(var/t in turf_list)
			var/turf/open/T = t
			T.excited_group = E
			E.turf_list += T
			E.reset_cooldowns()

/datum/excited_group/proc/reset_cooldowns()
	breakdown_cooldown = 0
	dismantle_cooldown = 0

//argument is so world start can clear out any turf differences quickly.
/datum/excited_group/proc/self_breakdown(space_is_all_consuming = 0)
	var/datum/gas_mixture/A = new

	//make local for sanic speed
	var/list/A_gases = A.gases
	var/list/turf_list = src.turf_list
	var/turflen = turf_list.len
	var/space_in_group = 0

	for(var/t in turf_list)
		var/turf/open/T = t
		if (space_is_all_consuming && !space_in_group && istype(T.air, /datum/gas_mixture/space))
			space_in_group = 1
			qdel(A)
			A = new/datum/gas_mixture/space()
		A.merge(T.air)

	for(var/id in A_gases)
		A_gases[id][MOLES] = A_gases[id][MOLES]/turflen

	for(var/t in turf_list)
		var/turf/open/T = t
		T.air.copy_from(A)
		T.atmos_cooldown = 0
		T.update_visuals()

	breakdown_cooldown = 0

/datum/excited_group/proc/dismantle()
	for(var/t in turf_list)
		var/turf/open/T = t
		T.excited = 0
		T.recently_active = 0
		T.excited_group = null
		SSair.active_turfs -= T
	garbage_collect()

/datum/excited_group/proc/garbage_collect()
	for(var/t in turf_list)
		var/turf/open/T = t
		T.excited_group = null
	turf_list.Cut()
	SSair.excited_groups -= src

////////////////////////SUPERCONDUCTIVITY/////////////////////////////
/turf/proc/conductivity_directions()
	if(archived_cycle < SSair.times_fired)
		archive()
	return NORTH|SOUTH|EAST|WEST

/turf/open/conductivity_directions()
	if(blocks_air)
		return ..()
	for(var/direction in cardinal)
		var/turf/T = get_step(src, direction)
		if(!(T in atmos_adjacent_turfs) && !(atmos_supeconductivity & direction))
			. |= direction

/turf/proc/neighbor_conduct_with_src(turf/open/other)
	if(!other.blocks_air) //Open but neighbor is solid
		other.temperature_share_open_to_solid(src)
	else //Both tiles are solid
		other.share_temperature_mutual_solid(src, thermal_conductivity)
	temperature_expose(null, temperature, null)

/turf/open/neighbor_conduct_with_src(turf/other)
	if(blocks_air)
		..()
		return

	if(!other.blocks_air) //Both tiles are open
		var/turf/open/T = other
		T.air.temperature_share(air, WINDOW_HEAT_TRANSFER_COEFFICIENT)
	else //Solid but neighbor is open
		temperature_share_open_to_solid(other)
	SSair.add_to_active(src, 0)

/turf/proc/super_conduct()
	var/conductivity_directions = conductivity_directions()

	if(conductivity_directions)
		//Conduct with tiles around me
		for(var/direction in cardinal)
			if(conductivity_directions & direction)
				var/turf/neighbor = get_step(src,direction)

				if(!neighbor.thermal_conductivity)
					continue

				if(neighbor.archived_cycle < SSair.times_fired)
					neighbor.archive()

				neighbor.neighbor_conduct_with_src(src)

				neighbor.consider_superconductivity()

	radiate_to_spess()

	finish_superconduction()

/turf/proc/finish_superconduction(temp = temperature)
	//Make sure still hot enough to continue conducting heat
	if(temp < MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION)
		SSair.active_super_conductivity -= src
		return 0

/turf/open/finish_superconduction()
	//Conduct with air on my tile if I have it
	if(!blocks_air)
		temperature = air.temperature_share(null, thermal_conductivity, temperature, heat_capacity)
	..((blocks_air ? temperature : air.temperature))

/turf/proc/consider_superconductivity()
	if(!thermal_conductivity)
		return 0

	SSair.active_super_conductivity |= src
	return 1

/turf/open/consider_superconductivity(starting)
	if(air.temperature < (starting?MINIMUM_TEMPERATURE_START_SUPERCONDUCTION:MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION))
		return 0
	if(air.heat_capacity() < M_CELL_WITH_RATIO) // Was: MOLES_CELLSTANDARD*0.1*0.05 Since there are no variables here we can make this a constant.
		return 0
	return ..()

/turf/closed/consider_superconductivity(starting)
	if(temperature < (starting?MINIMUM_TEMPERATURE_START_SUPERCONDUCTION:MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION))
		return 0
	return ..()

/turf/proc/radiate_to_spess() //Radiate excess tile heat to space
	if(temperature > T0C) //Considering 0 degC as te break even point for radiation in and out
		var/delta_temperature = (temperature_archived - TCMB) //hardcoded space temperature
		if((heat_capacity > 0) && (abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER))

			var/heat = thermal_conductivity*delta_temperature* \
				(heat_capacity*700000/(heat_capacity+700000)) //700000 is the heat_capacity from a space turf, hardcoded here
			temperature -= heat/heat_capacity

/turf/open/proc/temperature_share_open_to_solid(turf/sharer)
	sharer.temperature = air.temperature_share(null, sharer.thermal_conductivity, sharer.temperature, sharer.heat_capacity)

/turf/proc/share_temperature_mutual_solid(turf/sharer, conduction_coefficient) //to be understood
	var/delta_temperature = (temperature_archived - sharer.temperature_archived)
	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER && heat_capacity && sharer.heat_capacity)

		var/heat = conduction_coefficient*delta_temperature* \
			(heat_capacity*sharer.heat_capacity/(heat_capacity+sharer.heat_capacity))

		temperature -= heat/heat_capacity
		sharer.temperature += heat/sharer.heat_capacity

/datum/pai/software
	var/name = "Prototype Software"
	var/description = "The basic software upon which all else is based."
	var/category = "" //for listing categories in pAI interface
	var/sid = "software" //marker used inside Topic, set to a single word based on the software

	var/ram = 0 //amount of ram resource required by the pAI to use this

/datum/pai/software/proc/action_use(mob/user, var/args)
	//thrown when the user accesses the software via the side menu once they've purchased it
	return

/datum/pai/software/proc/action_purchased(mob/user)
	//thrown when the user purchases the software for the first time
	return

/datum/pai/software/proc/action_menu(mob/user)
	//return the required HTML that will be shown in the menu for the user
	return
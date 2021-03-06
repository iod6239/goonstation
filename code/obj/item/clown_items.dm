/*
CONTAINS:
BANANA PEEL
BIKE HORN
HARMONICA
VUVUZELA

*/

/obj/item/bananapeel
	name = "Banana Peel"
	desc = "A peel from a banana."
	icon = 'icons/obj/items.dmi'
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = 1.0
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	stamina_damage = 5
	stamina_cost = 5
	stamina_crit_chance = 5
	event_handler_flags = USE_HASENTERED | USE_FLUID_ENTER

	var/mob/living/carbon/human/last_touched

/obj/item/bananapeel/attack_hand(var/mob/user)
	last_touched = user
	..()

/obj/item/bananapeel/HasEntered(AM as mob|obj)
	if(istype(src.loc, /turf/space))
		return
	if (iscarbon(AM))
		var/mob/M =	AM
		if (!M.can_slip())
			return
		M.pulling = null
		boutput(M, "<span style=\"color:blue\">You slipped on the banana peel!</span>")
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.sims)
				H.sims.affectMotive("fun", -10)
				if (H == last_touched)
					H.sims.affectMotive("fun", -10)
		if (istype(last_touched) && (last_touched in viewers(src)) && last_touched != M)
			if (last_touched.sims)
				last_touched.sims.affectMotive("fun", 10)
		playsound(src.loc, "sound/misc/slip.ogg", 50, 1, -3)
		if(M.bioHolder.HasEffect("clumsy"))
			M.changeStatus("stunned", 80)
			M.changeStatus("weakened", 5 SECONDS)
		else
			M.changeStatus("weakened", 2 SECONDS)
		M.force_laydown_standup()

/obj/item/canned_laughter
	name = "Canned laughter"
	icon = 'icons/obj/can.dmi'
	icon_state = "cola-5"
	desc = "All of the rewards of making a good joke with none of the effort! In a can!"
	var/opened = 0

	attack_self(mob/user as mob)
		..()
		if(src.opened)
			boutput(user,"The can has already been opened!")
			return
		opened = 1
		icon_state = "crushed-5"
		playsound(user.loc, "sound/items/can_open.ogg", 50, 0)

		SPAWN_DBG(5)
			// Wow your joke sucks
			if(prob(5))
				playsound(user.loc,"sound/misc/laughter/boo.ogg",50,0)
			else
				playsound(user.loc,"sound/misc/laughter/laughtrack[pick("1","2","3","4")].ogg",50,0)

/obj/item/storage/box/box_o_laughs
	name = "Box o' Laughs"
	icon_state = "laughbox"
	desc = "A pack of canned laughter."
	spawn_contents = list(/obj/item/canned_laughter = 7)

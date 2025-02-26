//cleansed 9/15/2012 17:48

/*
CONTAINS:
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO
ROLLING PAPER
VAPES
BONGS

CIGARETTE PACKETS ARE IN FANCY.DM
*/

///////////
//MATCHES//
///////////
/obj/item/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	w_class = WEIGHT_CLASS_TINY
	heat = 1000
	grind_results = list(/datum/reagent/phosphorus = 2)
	hitsound = "swing_hit"

/obj/item/match/process()
	smoketime--
	if(smoketime < 1)
		matchburnout()
	else
		open_flame(heat)

/obj/item/match/fire_act(exposed_temperature, exposed_volume)
	matchignite()

/obj/item/match/proc/matchignite()
	if(!lit && !burnt)
		lit = TRUE
		icon_state = "match_lit"
		damtype = "fire"
		force = 3
		hitsound = 'fallout/sound/f13items/matchstick_lit.ogg' // seem damtype sound overrides in /obj/item parent despite that it shouldnt.
		inhand_icon_state = "cigon"
		name = "lit match"
		desc = "A match. This one is lit."
		attack_verb_simple = list("burnt","singed")
		START_PROCESSING(SSobj, src)
		update_icon()

/obj/item/match/proc/matchburnout()
	if(lit)
		lit = FALSE
		burnt = TRUE
		damtype = "brute"
		force = initial(force)
		icon_state = "match_burnt"
		inhand_icon_state = "cigoff"
		name = "burnt match"
		desc = "A match. This one has seen better days."
		attack_verb_simple = list("flicked")
		STOP_PROCESSING(SSobj, src)

/obj/item/match/dropped(mob/user)
	matchburnout()
	. = ..()

/obj/item/match/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!isliving(M))
		return
	if(lit && M.ignite_mob())
		message_admins("[ADMIN_LOOKUPFLW(user)] set [key_name_admin(M)] on fire with [src] at [AREACOORD(user)]")
		log_game("[key_name(user)] set [key_name(M)] on fire with [src] at [AREACOORD(user)]")
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M)
	if(lit && cig && user.a_intent == INTENT_HELP)
		if(cig.lit)
			to_chat(user, span_notice("[cig] is already lit."))
		if(M == user)
			cig.attackby(src, user)
		else
			cig.light(span_notice("[user] holds [src] out for [M], and lights [cig]."))
	else
		..()

/obj/item/match/get_temperature()
	return lit * heat

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	inhand_icon_state = "cigoff"
	w_class = WEIGHT_CLASS_TINY
	body_parts_covered = null
	grind_results = list()
	var/type_butt = /obj/item/cigbutt
	var/lastHolder = null
	heat = 1000

/obj/item/clothing/mask/cigarette/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is huffing [src] as quickly as [user.p_they()] can! It looks like [user.p_theyre()] trying to give [user.p_them()]self cancer."))
	return (TOXLOSS|OXYLOSS)

/obj/item/clothing/mask/cigarette/attackby(obj/item/W, mob/user, params)
	if(!lit && smoketime > 0)
		var/lighting_text = W.ignition_effect(src, user)
		if(lighting_text)
			light(lighting_text)
	else
		return ..()

/obj/item/clothing/mask/cigarette/afterattack(obj/item/reagent_containers/glass/glass, mob/user, proximity)
	. = ..()
	if(!proximity || lit) //can't dip if cigarette is lit (it will heat the reagents in the glass instead)
		return
	if(istype(glass))	//you can dip cigarettes into beakers
		if(glass.reagents.trans_to(src, chem_volume, log = "cigar fill: dip cigarette"))	//if reagents were transfered, show the message
			to_chat(user, span_notice("You dip \the [src] into \the [glass]."))
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, span_notice("[glass] is empty."))
			else
				to_chat(user, span_notice("[src] is full."))


/obj/item/clothing/mask/cigarette/attack_self(mob/user)
	if(lit)
		user.visible_message(span_notice("[user] calmly drops and treads on \the [src], putting it out instantly."))
		new type_butt(user.loc)
		new /obj/effect/decal/cleanable/ash(user.loc)
		qdel(src)
	. = ..()

/obj/item/clothing/mask/cigarette/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M))
		return ..()
	if(M.on_fire && !lit)
		light(span_notice("[user] lights [src] with [M]'s burning body. What a cold-blooded badass."))
		return
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M)
	if(lit && cig && user.a_intent == INTENT_HELP)
		if(cig.lit)
			to_chat(user, span_notice("The [cig.name] is already lit."))
		if(M == user)
			cig.attackby(src, user)
		else
			cig.light(span_notice("[user] holds the [name] out for [M], and lights [M.p_their()] [cig.name]."))
	else
		return ..()

/obj/item/clothing/mask/cigarette/fire_act(exposed_temperature, exposed_volume)
	light()

/obj/item/clothing/mask/cigarette/get_temperature()
	return lit * heat

// Cigarette brands.

/obj/item/clothing/mask/cigarette/space_cigarette
	desc = "A Space Cigarette brand cigarette."

/obj/item/clothing/mask/cigarette/dromedary
	desc = "A DromedaryCo brand cigarette."

/obj/item/clothing/mask/cigarette/uplift
	desc = "An Uplift Smooth brand cigarette."
	list_reagents = list(/datum/reagent/drug/nicotine = 12.5, /datum/reagent/consumable/menthol = 7.5)

/obj/item/clothing/mask/cigarette/robust
	desc = "A Robust brand cigarette."

/obj/item/clothing/mask/cigarette/robustgold
	desc = "A Robust Gold brand cigarette."
	list_reagents = list(/datum/reagent/drug/nicotine = 29, /datum/reagent/gold = 1)

/obj/item/clothing/mask/cigarette/carp
	desc = "A Carp Classic brand cigarette."

/obj/item/clothing/mask/cigarette/syndicate
	desc = "An unknown brand cigarette."
	list_reagents = list(/datum/reagent/drug/nicotine = 15, /datum/reagent/medicine/omnizine = 15)

/obj/item/clothing/mask/cigarette/shadyjims
	desc = "A Shady Jim's Super Slims cigarette."
	list_reagents = list(/datum/reagent/drug/nicotine = 15, /datum/reagent/toxin/lipolicide = 4, /datum/reagent/ammonia = 2, /datum/reagent/toxin/plantbgone = 1, /datum/reagent/toxin = 1.5)

/obj/item/clothing/mask/cigarette/xeno
	desc = "A Xeno Filtered brand cigarette."
	list_reagents = list (/datum/reagent/drug/nicotine = 20, /datum/reagent/medicine/regen_jelly = 15, /datum/reagent/drug/krokodil = 4)

/obj/item/clothing/mask/cigarette/bigboss
	name = "Big Boss Cigarette"
	desc = "A Big Boss brand cigarette."
	list_reagents = list(/datum/reagent/drug/nicotine = 15, /datum/reagent/medicine/synaptizine = 5)

/obj/item/clothing/mask/cigarette/pyramid
	name = "Pyramid Smokes Cigarette"
	desc = "A Pyramid brand cigarette."
	list_reagents = list(/datum/reagent/drug/nicotine = 15, /datum/reagent/gold = 3)

/obj/item/clothing/mask/cigarette/greytort
	name = "Grey Tortoise Cigarette"
	desc = "A Grey Tortoise brand cigarette."
	list_reagents = list(/datum/reagent/drug/nicotine = 15, /datum/reagent/medicine/omnizine = 5)

// Rollies.

/obj/item/clothing/mask/cigarette/rollie
	name = "rollie"
	desc = "A roll of dried plant matter wrapped in thin paper."
	icon_state = "spliffoff"
	icon_on = "spliffon"
	icon_off = "spliffoff"
	type_butt = /obj/item/cigbutt/roach
	throw_speed = 0.5
	inhand_icon_state = "spliffoff"
	smoketime = 180
	chem_volume = 50
	list_reagents = null

/obj/item/clothing/mask/cigarette/rollie/New()
	..()
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)

/obj/item/clothing/mask/cigarette/rollie/nicotine
	list_reagents = list(/datum/reagent/drug/nicotine = 15)

/obj/item/clothing/mask/cigarette/rollie/trippy
	list_reagents = list(/datum/reagent/drug/nicotine = 15, /datum/reagent/drug/mushroomhallucinogen = 35)
	starts_lit = TRUE

/obj/item/clothing/mask/cigarette/rollie/cannabis
	list_reagents = list(/datum/reagent/drug/space_drugs = 15, /datum/reagent/toxin/lipolicide = 35)

/obj/item/clothing/mask/cigarette/rollie/mindbreaker
	list_reagents = list(/datum/reagent/toxin/mindbreaker = 35, /datum/reagent/toxin/lipolicide = 15)

/obj/item/cigbutt/roach
	name = "roach"
	desc = "A manky old roach, or for non-stoners, a used rollup."
	icon_state = "roach"

/obj/item/cigbutt/roach/New()
	..()
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)


////////////
// CIGARS //
////////////
/obj/item/clothing/mask/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff" //make sure to add positional sprites in icons/obj/cigarettes.dmi if you add more.
	type_butt = /obj/item/cigbutt/cigarbutt
	throw_speed = 0.5
	inhand_icon_state = "cigaroff"
	smoketime = 1500
	chem_volume = 40

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 2000
	chem_volume = 80

/obj/item/clothing/mask/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 7200
	chem_volume = 50

/obj/item/clothing/mask/cigarette/cigar/ncr
	name = "California Slim cigar"
	desc = "A hand rolled cigar made from sun-kissed California tobacco."
	icon_state = "cigar3off"
	icon_on = "cigar3on"
	icon_off = "cigar3off"
	smoketime = 4500
	chem_volume = 75

/obj/item/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigbutt"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	grind_results = list(/datum/reagent/carbon = 2)

/obj/item/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/cigarette/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Probably made of meerschaum or something."
	icon_state = "pipeoff"
	inhand_icon_state = "pipeoff"
	icon_on = "pipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	smoketime = 0
	chem_volume = 100
	list_reagents = null

/obj/item/clothing/mask/cigarette/pipe/Initialize()
	. = ..()
	name = "empty [initial(name)]"

/obj/item/clothing/mask/cigarette/pipe/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/clothing/mask/cigarette/pipe/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		new /obj/effect/decal/cleanable/ash(location)
		if(ismob(loc))
			var/mob/living/M = loc
			to_chat(M, span_notice("Your [name] goes out."))
			lit = 0
			icon_state = icon_off
			inhand_icon_state = icon_off
			M.update_inv_wear_mask()
			packeditem = 0
			name = "empty [initial(name)]"
		STOP_PROCESSING(SSobj, src)
		return
	open_flame()
	if(reagents && reagents.total_volume)	//	check if it has any reagents at all
		handle_reagents()


/obj/item/clothing/mask/cigarette/pipe/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/food/grown))
		var/obj/item/food/grown/G = O
		if(!packeditem)
			if(G.dry == 1)
				to_chat(user, span_notice("You stuff [O] into [src]."))
				smoketime = 400
				packeditem = 1
				name = "[O.name]-packed [initial(name)]"
				if(O.reagents)
					O.reagents.trans_to(src, O.reagents.total_volume, log = "cigar fill: pipe pack")
				qdel(O)
			else
				to_chat(user, span_warning("It has to be dried first!"))
		else
			to_chat(user, span_warning("It is already packed!"))
	else
		var/lighting_text = O.ignition_effect(src,user)
		if(lighting_text)
			if(smoketime > 0)
				light(lighting_text)
			else
				to_chat(user, span_warning("There is nothing to smoke!"))
		else
			return ..()

/obj/item/clothing/mask/cigarette/pipe/attack_self(mob/user)
	var/turf/location = get_turf(user)
	if(lit)
		user.visible_message(span_notice("[user] puts out [src]."), span_notice("You put out [src]."))
		lit = 0
		icon_state = icon_off
		inhand_icon_state = icon_off
		STOP_PROCESSING(SSobj, src)
		return
	if(!lit && smoketime > 0)
		to_chat(user, span_notice("You empty [src] onto [location]."))
		new /obj/effect/decal/cleanable/ash(location)
		packeditem = 0
		smoketime = 0
		reagents.clear_reagents()
		name = "empty [initial(name)]"
	return

/obj/item/clothing/mask/cigarette/pipe/cobpipe
	name = "corn cob pipe"
	desc = "Traditional way to enjoy some tobacco in peace."
	icon_state = "cobpipeoff"
	inhand_icon_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	icon_off = "cobpipeoff"
	smoketime = 0


/////////
//ZIPPO//
/////////
/obj/item/lighter
	name = "zippo lighter"
	desc = "The zippo."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "zippo"
	inhand_icon_state = "zippo"
	w_class = WEIGHT_CLASS_TINY
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 0.6
	light_color = LIGHT_COLOR_FIRE
	light_on = FALSE
	overlay_list = list(
		"plain",
		"dame",
		"thirteen",
		"snake"
		)
	heat = 1500
	resistance_flags = FIRE_PROOF
	grind_results = list(/datum/reagent/iron = 1, /datum/reagent/fuel = 5, /datum/reagent/oil = 5)
	custom_price = PRICE_ALMOST_CHEAP

/obj/item/lighter/Initialize()
	. = ..()
	if(!overlay_state)
		overlay_state = pick(overlay_list)
	update_icon()

/obj/item/lighter/suicide_act(mob/living/carbon/user)
	if (lit)
		user.visible_message(span_suicide("[user] begins holding \the [src]'s flame up to [user.p_their()] face! It looks like [user.p_theyre()] trying to commit suicide!"))
		playsound(src, 'sound/items/welder.ogg', 50, 1)
		return FIRELOSS
	else
		user.visible_message(span_suicide("[user] begins whacking [user.p_them()]self with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
		return BRUTELOSS

/obj/item/lighter/update_icon_state()
	icon_state = "[initial(icon_state)][lit ? "-on" : ""]"

/obj/item/lighter/update_overlays()
	. = ..()
	var/mutable_appearance/lighter_overlay = mutable_appearance(icon,"lighter_overlay_[overlay_state][lit ? "-on" : ""]")
	. += lighter_overlay

/obj/item/lighter/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		. = span_rose("With a single flick of [user.p_their()] wrist, [user] smoothly lights [A] with [src]. Damn [user.p_theyre()] cool.")

/obj/item/lighter/proc/set_lit(new_lit)
	lit = new_lit
	if(lit)
		force = 5
		damtype = "fire"
		hitsound = 'sound/items/welder.ogg'
		attack_verb_simple = list("burnt", "singed")
		START_PROCESSING(SSobj, src)
	else
		hitsound = "swing_hit"
		force = 0
		attack_verb_simple = null //human_defense.dm takes care of it
		STOP_PROCESSING(SSobj, src)
	set_light_on(lit)
	update_icon()

/obj/item/lighter/attack_self(mob/living/user)
	if(user.is_holding(src))
		if(!lit)
			set_lit(TRUE)
			if(fancy)
				user.visible_message("Without even breaking stride, [user] flips open and lights [src] in one smooth movement.", span_notice("Without even breaking stride, you flip open and light [src] in one smooth movement."))
			else
				var/prot = FALSE
				var/mob/living/carbon/human/H = user

				if(istype(H) && H.gloves)
					var/obj/item/clothing/gloves/G = H.gloves
					if(G.max_heat_protection_temperature)
						prot = (G.max_heat_protection_temperature > 360)
				else
					prot = TRUE

				if(prot || prob(75))
					user.visible_message("After a few attempts, [user] manages to light [src].", span_notice("After a few attempts, you manage to light [src]."))
				else
					var/hitzone = user.held_index_to_dir(user.active_hand_index) == "r" ? BODY_ZONE_PRECISE_R_HAND : BODY_ZONE_PRECISE_L_HAND
					user.apply_damage(5, BURN, hitzone)
					user.visible_message(span_warning("After a few attempts, [user] manages to light [src] - however, [user.p_they()] burn [user.p_their()] finger in the process."), span_warning("You burn yourself while lighting the lighter!"))
					SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "burnt_thumb", /datum/mood_event/burnt_thumb)

		else
			set_lit(FALSE)
			if(fancy)
				user.visible_message("You hear a quiet click, as [user] shuts off [src] without even looking at what [user.p_theyre()] doing. Wow.", span_notice("You quietly shut off [src] without even looking at what you're doing. Wow."))
			else
				user.visible_message("[user] quietly shuts off [src].", span_notice("You quietly shut off [src]."))
	else
		. = ..()

/obj/item/lighter/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(lit && M.ignite_mob())
		message_admins("[ADMIN_LOOKUPFLW(user)] set [key_name_admin(M)] on fire with [src] at [AREACOORD(user)]")
		log_game("[key_name(user)] set [key_name(M)] on fire with [src] at [AREACOORD(user)]")
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M)
	if(lit && cig && user.a_intent == INTENT_HELP)
		if(cig.lit)
			to_chat(user, span_notice("The [cig.name] is already lit."))
		if(M == user)
			cig.attackby(src, user)
		else
			if(fancy)
				cig.light(span_rose("[user] whips the [name] out and holds it for [M]. [user.p_their(TRUE)] arm is as steady as the unflickering flame [user.p_they()] light[user.p_s()] \the [cig] with."))
			else
				cig.light(span_notice("[user] holds the [name] out for [M], and lights [M.p_their()] [cig.name]."))
	else
		..()

/obj/item/lighter/process()
	open_flame()

/obj/item/lighter/get_temperature()
	return lit * heat


/obj/item/lighter/greyscale
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon_state = "lighter"
	fancy = FALSE
	custom_price = PRICE_CHEAP_AS_FREE
	overlay_list = list(
		"transp",
		"tall",
		"matte",
		"zoppo" //u cant stoppo th zoppo
		)

/obj/item/lighter/greyscale/Initialize()
	. = ..()
	if(!lighter_color)
		lighter_color = pick(color_list)
	update_icon()

/obj/item/lighter/greyscale/update_icon_state()
	icon_state = "[initial(icon_state)][lit ? "-on" : ""]"

/obj/item/lighter/greyscale/update_overlays()
	. = ..()
	var/mutable_appearance/lighter_overlay = mutable_appearance(icon,"lighter_overlay_[overlay_state][lit ? "-on" : ""]")
	lighter_overlay.color = lighter_color
	. += lighter_overlay

/obj/item/lighter/greyscale/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		. = span_notice("After some fiddling, [user] manages to light [A] with [src].")


/obj/item/lighter/slime
	name = "slime zippo"
	desc = "A specialty zippo made from slimes and industry. Has a much hotter flame than normal."
	icon_state = "slighter"
	heat = 3000 //Blue flame!
	light_color = LIGHT_COLOR_CYAN
	overlay_state = "slime"
	grind_results = list(/datum/reagent/iron = 1, /datum/reagent/fuel = 5, /datum/reagent/medicine/pyroxadone = 5)

/obj/item/lighter/fusion
	name = "fusion zippo"
	desc = "A specialty zippo made from a microfusion cell and dedication. Has a much hotter flame than normal."
	icon_state = "slighter"
	heat = 3500
	light_color = LIGHT_COLOR_CYAN
	grind_results = list(/datum/reagent/iron = 1, /datum/reagent/fuel = 5, /datum/reagent/uranium/radium = 5)

///////////
//ROLLING//
///////////
/obj/item/rollingpaper
	name = "rolling paper"
	desc = "A thin piece of paper used to make fine smokeables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper"
	w_class = WEIGHT_CLASS_TINY

/obj/item/rollingpaper/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(istype(target, /obj/item/food/grown))
		var/obj/item/food/grown/O = target
		if(O.dry)
			var/obj/item/clothing/mask/cigarette/rollie/R = new /obj/item/clothing/mask/cigarette/rollie(user.loc)
			R.chem_volume = target.reagents.total_volume
			target.reagents.trans_to(R, R.chem_volume, log = "cigar fill: rolling paper afterattack")
			qdel(target)
			qdel(src)
			user.put_in_active_hand(R)
			to_chat(user, span_notice("You roll the [target.name] into a rolling paper."))
			R.desc = "Dried [target.name] rolled up in a thin piece of paper."
		else
			to_chat(user, span_warning("You need to dry this first!"))

///////////////
//VAPE NATION//
///////////////
/obj/item/clothing/mask/vape
	name = "\improper E-Cigarette"
	desc = "A classy and highly sophisticated electronic cigarette, for classy and dignified gentlemen. A warning label reads \"Warning: Do not fill with flammable materials.\""//<<< i'd vape to that.
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "black_vape"
	inhand_icon_state = "black_vape"
	w_class = WEIGHT_CLASS_TINY
	var/vapetime = FALSE //this so it won't puff out clouds every tick

/obj/item/clothing/mask/vape/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is puffin hard on dat vape, [user.p_they()] trying to join the vape life on a whole notha plane!"))//it doesn't give you cancer, it is cancer
	return (TOXLOSS|OXYLOSS)

/obj/item/clothing/mask/vape/emag_act(mob/user)// I WON'T REGRET WRITTING THIS, SURLY.
	. = ..()
	if(!screw)
		to_chat(user, span_notice("You need to open the cap to do that."))
		return
	if(obj_flags & EMAGGED)
		to_chat(user, span_warning("[src] is already emagged!"))
		return
	cut_overlays()
	obj_flags |= EMAGGED
	super = FALSE
	to_chat(user, span_warning("You maximize the voltage of [src]."))
	add_overlay("vapeopen_high")
	var/datum/effect_system/spark_spread/sp = new /datum/effect_system/spark_spread //for effect
	sp.set_up(5, 1, src)
	sp.start()
	return TRUE

/obj/item/clothing/mask/vape/attack_self(mob/user)
	if(reagents.total_volume > 0)
		to_chat(user, span_notice("You empty [src] of all reagents."))
		reagents.clear_reagents()

///////////////
/////BONGS/////
///////////////

/obj/item/bong
	name = "bong"
	desc = "A water bong used for smoking dried plants."
	icon = 'fallout/icons/obj/bongs.dmi'
	icon_state = null
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_NORMAL
	light_system = MOVABLE_LIGHT
	light_range = 2
	light_power = 0.6
	light_color = "#FFCC66"
	light_on = FALSE
	var/icon_off = "bong"
	var/icon_on = "bong_lit"
	var/chem_volume = 100
	var/last_used_time //for cooldown
	var/firecharges = 0 //used for counting how many hits can be taken before the flame goes out
	var/list/list_reagents = list() //For the base reagents bongs could get


/obj/item/bong/Initialize()
	. = ..()
	create_reagents(chem_volume, NO_REACT) // so it doesn't react until you light it
	reagents.add_reagent_list(list_reagents)
	icon_state = icon_off

/obj/item/bong/attackby(obj/item/O, mob/user, params)
	. = ..()
	//If we're using a dried plant..
	if(istype(O,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/DP = O
		if (DP.dry)
			//Nothing if our bong is full
			if (reagents.holder_full())
				user.show_message(span_notice("The bowl is full!"), MSG_VISUAL)
				return

			//Transfer reagents and remove the plant
			user.show_message(span_notice("You stuff the [DP] into the [src]'s bowl."), MSG_VISUAL)
			DP.reagents.trans_to(src, 100, log = "cigar fill: bong")
			qdel(DP)
			return
		else
			user.show_message(span_warning("[DP] must be dried first!"), MSG_VISUAL)
			return

	if (O.get_temperature() <= 500)
		return
	if (reagents && reagents.total_volume) //if there's stuff in the bong
		var/lighting_text = O.ignition_effect(src, user)
		if(lighting_text)
			//Logic regarding igniting it on
			if (firecharges == 0)
				user.show_message(span_notice("You light the [src] with the [O]!"), MSG_VISUAL)
				bongturnon()
			else
				user.show_message(span_notice("You rekindle [src]'s flame with the [O]!"), MSG_VISUAL)

			firecharges = 1
			return
	else
		user.show_message("<span warning='notice'>There's nothing to light up in the bowl.</span>", MSG_VISUAL)
		return

/obj/item/bong/CtrlShiftClick(mob/user) //empty reagents on alt click
	..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return

	if (reagents && reagents.total_volume)
		user.show_message(span_notice("You empty the [src]."), MSG_VISUAL)
		reagents.clear_reagents()
		if(firecharges)
			firecharges = 0
			bongturnoff()
	else
		user.show_message(span_notice("The [src] is already empty."), MSG_VISUAL)

/obj/item/bong/AltClick(mob/user)
	..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return

	if(firecharges)
		firecharges = 0
		bongturnoff()
		user.show_message(span_notice("You quench the flame."), MSG_VISUAL)
		return TRUE

/obj/item/bong/examine(mob/user)
	. = ..()
	if(!reagents.total_volume)
		. += span_notice("The bowl is empty.")
	else if (reagents.total_volume > 80)
		. += span_notice("The bowl is filled to the brim.")
	else if (reagents.total_volume > 40)
		. += span_notice("The bowl has plenty weed in it.")
	else
		. += span_notice("The bowl has some weed in it.")

	. += span_notice("Ctrl+Shift-click to empty.")
	. += span_notice("Alt-click to extinguish.")

/obj/item/bong/ignition_effect(atom/A, mob/user)
	if(firecharges)
		. = span_notice("[user] lights [A] off of the [src].")
	else
		. = ""

/obj/item/bong/attack(mob/living/carbon/M, mob/living/carbon/user, obj/target)
	//if it's lit up, some stuff in the bowl and the user is a target, and we're not on cooldown

	if (M != user)
		return ..()

	if(user.is_mouth_covered(head_only = 1))
		to_chat(user, span_warning("Remove your headgear first."))
		return ..()

	if(user.is_mouth_covered(mask_only = 1))
		to_chat(user, span_warning("Remove your mask first."))
		return ..()

	if (!reagents.total_volume)
		to_chat(user, span_warning("There's nothing in the bowl."))
		return ..()

	if (!firecharges)
		to_chat(user, span_warning("You have to light it up first."))
		return ..()

	if (last_used_time + 30 >= world.time)
		return ..()
	var/hit_strength
	var/noise
	var/hittext = ""
	//if the intent is help then you take a small hit, else a big one
	if (user.a_intent == INTENT_HARM)
		hit_strength = 2
		noise = 100
		hittext = "big hit"
	else
		hit_strength = 1
		noise = 70
		hittext = "hit"
	//bubbling sound
	playsound(user.loc,'fallout/sound/effects/bonghit.ogg', noise, 1)

	last_used_time = world.time

	//message
	user.visible_message(span_notice("[user] begins to take a [hittext] from the [src]!"), \
								span_notice("You begin to take a [hittext] from [src]."))

	//we take a hit here, after an uninterrupted delay
	if(!do_after(user, 25, target = user))
		return
	if (!(reagents && reagents.total_volume))
		return

	var/fraction = 12 * hit_strength

	var/datum/effect_system/smoke_spread/chem/smoke_machine/s = new
	s.set_up(reagents, hit_strength, 18, user.loc)
	s.start()

	reagents.reaction(user, INGEST, fraction)
	if(!reagents.trans_to(user, fraction))
		reagents.remove_any(fraction)

	if (hit_strength == 2 && prob(15))
		user.emote("cough")
		user.adjustOxyLoss(15)

	user.visible_message(span_notice("[user] takes a [hittext] from the [src]!"), \
							span_notice("You take a [hittext] from [src]."))

	firecharges = firecharges - 1
	if (!firecharges)
		bongturnoff()
	if (!reagents.total_volume)
		firecharges = 0
		bongturnoff()


/obj/item/bong/proc/bongturnon()
	icon_state = icon_on
	set_light_on(TRUE)

/obj/item/bong/proc/bongturnoff()
	icon_state = icon_off
	set_light_on(FALSE)


/obj/item/bong/coconut
	name = "coconut bong"
	icon_off = "coconut_bong"
	icon_on = "coconut_bong_lit"
	desc = "A water bong used for smoking dried plants. This one's made out of a coconut and some bamboo."

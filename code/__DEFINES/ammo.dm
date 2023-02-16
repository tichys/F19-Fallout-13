/*ALL DEFINES RELATED TO AMMO GO HERE*/

//Caliber defines
#define CALIBER_22LR ".22LR rounds"
#define CALIBER_5MM "5mm rounds"
#define CALIBER_556 "5.56mm / .223 rounds"
#define CALIBER_762 "7.62mm / .308 rounds"
#define CALIBER_9MM "9mm rounds"
#define CALIBER_10MM "10mm rounds"
#define CALIBER_14MM "14mm rounds"
#define CALIBER_38 ".38 special rounds"
#define CALIBER_357 ".357 magnum rounds"
#define CALIBER_44 ".44 magnum rounds"
#define CALIBER_45LC ".45 LC rounds"
#define CALIBER_45ACP ".45 ACP rounds"
#define CALIBER_4570 ".45-70 rounds"
#define CALIBER_50MG ".50MG rounds"
#define CALIBER_2MM "2mmEC gauss slugs"
#define CALIBER_SHOTGUN "12 gauge shells"
#define CALIBER_CASELESS "4.73mm caseless"
#define CALIBER_75 ".75 gyrojets"
#define CALIBER_195 "1.95mm rounds"
#define CALIBER_712 "7.12mm rounds"
#define CALIBER_40MM "40mm rounds"
#define CALIBER_MAGNETIC "magnetic rounds"
#define CALIBER_MAGNETIC_HYPER "hypermagnetic rounds"
#define CALIBER_MUSKET_BALL "musket balls"
#define CALIBER_MUSKET_LASER "laser musket packs"
#define CALIBER_MUSKET_PLASMA "plasma musket packs"
#define CALIBER_NEEDLE "needles"
#define CALIBER_ROCKET "rockets"
#define CALIBER_SPEAR "speargun rounds"
#define CALIBER_LASERGATLING "laser gatling charges"
#define CALIBER_LASER "oldlasers"
#define CALIBER_MWS "mwses"
#define CALIBER_ARROW "arrows"
#define CALIBER_FUEL "flamer fuel"
#define CALIBER_FOAM "foam darts"
#define CALIBER_ANY "anything even remotely ammolike"

GLOBAL_LIST_INIT(pipe_rifle_valid_calibers, list(
	CALIBER_10MM,
	CALIBER_14MM,
	CALIBER_357,
	CALIBER_44))

GLOBAL_LIST_INIT(zipgun_valid_calibers, list(
	CALIBER_22LR,
	CALIBER_9MM,
	CALIBER_10MM,
	CALIBER_38,
	CALIBER_45LC,
	CALIBER_45ACP))

GLOBAL_LIST_INIT(hobo_gun_mag_fluff, list(
	"prefix" = list("bullet","casing","cartridge","shell"),
	"suffix" = list("chamber","holder","slot","hole","thing","pit"),
	"postfix" = list("-thingy","-majig","...?"," assembly")
))
#define MAGAZINE_CALIBER_CHANGE_STEP_0 0 // use screwdriver to get to step 1
#define MAGAZINE_CALIBER_CHANGE_STEP_1 1 // used a screwdriver on it, ready for a metal part
#define MAGAZINE_CALIBER_CHANGE_STEP_2 2 // used a metal part on it, ready for welding
#define MAGAZINE_CALIBER_CHANGE_STEP_3 3 // used a welder on it, ready for a new casing

/// Material costs cus fuckin hell this shit's out of hand!
#define MATS_AMMO_GLOBAL_MULT 5

/// Bullet~
#define MATS_AMMO_BULLET_BASE (10 * MATS_AMMO_GLOBAL_MULT)

#define MATS_PISTOL_SMALL_BULLET (MATS_AMMO_BULLET_BASE * 0.5)
#define MATS_PISTOL_MEDIUM_BULLET (MATS_AMMO_BULLET_BASE * 1)
#define MATS_PISTOL_HEAVY_BULLET (MATS_AMMO_BULLET_BASE * 2)
#define MATS_RIFLE_SMALL_BULLET (MATS_AMMO_BULLET_BASE * 1)
#define MATS_RIFLE_MEDIUM_BULLET (MATS_AMMO_BULLET_BASE * 2)
#define MATS_RIFLE_HEAVY_BULLET (MATS_AMMO_BULLET_BASE * 3)
#define MATS_SHOTGUN_BULLET (MATS_AMMO_BULLET_BASE * 4)
#define MATS_GRENADE_BULLET (MATS_AMMO_BULLET_BASE * 20)
#define MATS_ROCKET_BULLET (MATS_AMMO_BULLET_BASE * 1)
#define MATS_GAUSS_BULLET (MATS_AMMO_BULLET_BASE * 100)

/// Powder~
#define MATS_AMMO_POWDER_BASE (10 * MATS_AMMO_GLOBAL_MULT)
#define MATS_AMMO_POWDER_HANDLOAD_MULT 0.5
#define MATS_AMMO_POWDER_MATCH_MULT 3

#define MATS_PISTOL_SMALL_POWDER (MATS_AMMO_POWDER_BASE * 0.5)
#define MATS_PISTOL_MEDIUM_POWDER (MATS_AMMO_POWDER_BASE * 1)
#define MATS_PISTOL_HEAVY_POWDER (MATS_AMMO_POWDER_BASE * 2)
#define MATS_RIFLE_SMALL_POWDER (MATS_AMMO_POWDER_BASE * 1)
#define MATS_RIFLE_MEDIUM_POWDER (MATS_AMMO_POWDER_BASE * 2)
#define MATS_RIFLE_HEAVY_POWDER (MATS_AMMO_POWDER_BASE * 3)
#define MATS_SHOTGUN_POWDER (MATS_AMMO_POWDER_BASE * 3)
#define MATS_GRENADE_POWDER (MATS_AMMO_POWDER_BASE * 20)
#define MATS_ROCKET_POWDER (MATS_AMMO_POWDER_BASE * 1000)
#define MATS_GAUSS_POWDER 0

/// Casing~
#define MATS_CASING_BASE (30 * MATS_AMMO_GLOBAL_MULT)

#define MATS_PISTOL_SMALL_CASING (MATS_CASING_BASE * 0.5)
#define MATS_PISTOL_MEDIUM_CASING (MATS_CASING_BASE * 1)
#define MATS_PISTOL_HEAVY_CASING (MATS_CASING_BASE * 1)
#define MATS_RIFLE_SMALL_CASING (MATS_CASING_BASE * 1)
#define MATS_RIFLE_MEDIUM_CASING (MATS_CASING_BASE * 2)
#define MATS_RIFLE_HEAVY_CASING (MATS_CASING_BASE * 3)
#define MATS_SHOTGUN_CASING (MATS_CASING_BASE * 4)
#define MATS_GRENADE_CASING (MATS_CASING_BASE * 20)
#define MATS_ROCKET_CASING (MATS_CASING_BASE * 200)
#define MATS_GAUSS_CASING 0

/// Ammo boxes
#define MATS_BOX_BASE 1000

#define MATS_PISTOL_SMALL_BOX (MATS_BOX_BASE * 0.5)
#define MATS_PISTOL_MEDIUM_BOX (MATS_BOX_BASE * 1)
#define MATS_PISTOL_HEAVY_BOX (MATS_BOX_BASE * 1)
#define MATS_RIFLE_SMALL_BOX (MATS_BOX_BASE * 1)
#define MATS_RIFLE_MEDIUM_BOX (MATS_BOX_BASE * 2)
#define MATS_RIFLE_HEAVY_BOX (MATS_BOX_BASE * 3)
#define MATS_SHOTGUN_BOX (MATS_BOX_BASE * 4)

/// Magazines!
#define MATS_MAGAZINE_BASE 4000

#define MATS_SMALL_PISTOL_MAGAZINE (MATS_MAGAZINE_BASE * 0.5)
#define MATS_MEDIUM_PISTOL_MAGAZINE (MATS_MAGAZINE_BASE * 1)
#define MATS_HEAVY_PISTOL_MAGAZINE (MATS_MAGAZINE_BASE * 1)
#define MATS_PISTOL_SPEEDLOADER (MATS_MAGAZINE_BASE * 0.5)
#define MATS_TUBE (MATS_MAGAZINE_BASE * 1)
#define MATS_STRIPPER (MATS_MAGAZINE_BASE * 0.5)

#define MATS_SMG (MATS_MAGAZINE_BASE * 4)
#define MATS_SMG_EXTENDED (MATS_MAGAZINE_BASE * 8)

#define MATS_LIGHT_SMALL_RIFLE_MAGAZINE (MATS_MAGAZINE_BASE * 1)
#define MATS_LIGHT_RIFLE_MAGAZINE (MATS_MAGAZINE_BASE * 2)
#define MATS_LIGHT_LARGE_RIFLE_MAGAZINE (MATS_MAGAZINE_BASE * 4)
#define MATS_LIGHT_EXTENDED_RIFLE_MAGAZINE (MATS_MAGAZINE_BASE * 6)
#define MATS_LIGHT_BRICK_RIFLE_MAGAZINE (MATS_MAGAZINE_BASE * 8)
#define MATS_LIGHT_MEGA_CAN_MAGAZINE (MATS_MAGAZINE_BASE * 16)

#define MATS_MEDIUM_SMALL_RIFLE_MAGAZINE (MATS_MAGAZINE_BASE * 2)
#define MATS_MEDIUM_RIFLE_MAGAZINE (MATS_MAGAZINE_BASE * 4)
#define MATS_MEDIUM_EXTENDED_RIFLE_MAGAZINE (MATS_MAGAZINE_BASE * 8)
#define MATS_MEDIUM_BELT_MAGAZINE (MATS_MAGAZINE_BASE * 16)

#define MATS_SHOTGUN_MAGAZINE (MATS_MAGAZINE_BASE * 8)

#define MATS_MISC (MATS_MAGAZINE_BASE * 8)

/// Multiplier for ammolathes
#define MATS_AMMO_GLOBAL_COST_MULT 1
#define MATS_AMMO_METAL_COST_MULT (1 * MATS_AMMO_GLOBAL_COST_MULT)
#define MATS_AMMO_POWDER_COST_MULT (1 * MATS_AMMO_GLOBAL_COST_MULT)

GLOBAL_LIST_INIT(ammo_material_multipliers, list(
	/datum/material/iron = MATS_AMMO_METAL_COST_MULT,
	/datum/material/blackpowder = MATS_AMMO_POWDER_COST_MULT
))

/// Just so I dont have to do bespoke shit for deducting powder and bullet costs
#define BULLET_IS_LIGHT_PISTOL "light_pistol"
#define BULLET_IS_MEDIUM_PISTOL "medium_pistol"
#define BULLET_IS_HEAVY_PISTOL "heavy_pistol"
#define BULLET_IS_LIGHT_RIFLE "light_rifle"
#define BULLET_IS_MEDIUM_RIFLE "medium_rifle"
#define BULLET_IS_HEAVY_RIFLE "heavy_rifle"
#define BULLET_IS_SHOTGUN "shotgun_shell"
#define BULLET_IS_GRENADE "grenade_shell"
#define BULLET_IS_GAUSS "gauss_thing"


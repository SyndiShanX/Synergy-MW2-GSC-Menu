#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init() {
	level initial_precache();
	level thread player_connect();
	level thread create_rainbow_color();

	level.originalCallbackPlayerDamage = level.callbackPlayerDamage; //doktorSAS - Retropack
	level.callbackPlayerDamage = ::player_damage_callback; // Retropack
	level.rankedmatch = 1; // Retropack

	level thread session_expired();
}

initial_precache() {
	precacheshader("hud_arrow_right");
}

initial_variable() {
	self.menu = [];
	self.cursor = [];
	self.slider = [];
	self.previous = [];
	self.previous_option = undefined;

	self.font = "default";
	self.font_scale = 0.9;
	self.option_limit = 6;
	self.option_spacing = 16;
	self.x_offset = 175;
	self.y_offset = 160;
	self.width = -20;
	self.interaction_enabled = true;
	self.description_enabled = true;
	self.randomizing_enabled = true;
	self.scrolling_buffer = 3;

	self set_menu();
	self set_title();

	self.menu_color_red = 255;
	self.menu_color_green = 255;
	self.menu_color_blue = 255;
	self.color_theme = "rainbow";

	self.syn["visions"][0] = strTok("ac130;ac130_inverted;aftermath;airplane;airport;airport_death;airport_exterior;airport_green;airport_intro;airport_stairs;ambush;armada;armada_water;bigcity_destroyed;blackout;blackout_nvg;bog;boneyard;bridge;cargoship;cheat_bw;cheat_bw_contrast;cheat_bw_invert;cheat_chaplinnight;cheat_contrast;cheat_invert;cheat_invert_contrast;cliffhanger;dcemp;dcemp_emp;default;default_night;default_night_mp;end_game;introscreen;mp_afghan;mpnuke;mpnuke_aftermath;mpoutro;near_death;near_death_mp;thermal_mp", ";");
	self.syn["visions"][1] = strTok("AC-130;AC-130 inverted;Aftermath;Airplane;Airport;Airport Death;Airport Exterior;Airport Green;Airport Intro;Airport Stairs;Ambush;Armada;Armada Water;Big City Destroyed;Blackout;Blackout Nvg;Bog;Boneyard;Bridge;Cargo Ship;Cheat BW;Cheat BW Contrast;Cheat BW Invert;Cheat Chaplin Night;Cheat Contrast;Cheat Invert;Cheat Invert Contrast;Cliff Hanger;DC;DC EMP;Default;Default Night;Default Night MP;End Game;Intro Screen;MP Afghan;MP Nuke;MP Nuke Aftermath;MP Outro;Near Death;Near Death MP;Thermal MP", ";");

	self.syn["weapons"]["category"][0] = strTok("assault_rifles;sub_machine_guns;light_machine_guns;sniper_rifles;machine_pistols;shotguns;pistols;launchers;extras", ";");
	self.syn["weapons"]["category"][1] = strTok("Assault Rifles;Sub Machine Guns;Light Machine Guns;Sniper Rifles;Machine Pistols;Shotguns;Pistols;Launchers;Extras", ";");

	// Weapon IDs
	self.syn["weapons"]["assault_rifles"][0] =     strTok("m4;famas;scar;tavor;fal;m16;masada;fn2000;ak47;ak47classic", ";");
	self.syn["weapons"]["sub_machine_guns"][0] =   strTok("mp5k;ump45;kriss;p90;uzi;ak74u;peacekeeper", ";");
	self.syn["weapons"]["light_machine_guns"][0] = strTok("sa80;rpd;mg4;aug;m240", ";");
	self.syn["weapons"]["sniper_rifles"][0] =      strTok("cheytac;barrett;wa2000;m21;m40a3;dragunov", ";");
	self.syn["weapons"]["machine_pistols"][0] =    strTok("pp2000;glock;beretta393;tmp", ";");
	self.syn["weapons"]["shotguns"][0] =           strTok("spas12;aa12;striker;ranger;m1014;model1887", ";");
	self.syn["weapons"]["pistols"][0] =            strTok("usp;coltanaconda;beretta;deserteagle;deserteaglegold", ";");
	self.syn["weapons"]["launchers"][0] =          strTok("at4;m79;stinger;javelin;rpg", ";");
	self.syn["weapons"]["extras"][0] =             strTok("riotshield;defaultweapon;frag_grenade;semtex;throwingknife;claymore;c4;flash_grenade;concussion_grenade;smoke_grenade", ";");

	// Weapon Names
	self.syn["weapons"]["assault_rifles"][1] =     strTok("M4A1;Famas;Scar-H;Tar-21;FAL;M16A4;ACR;F2000;AK-47;AK-47 Classic", ";");
	self.syn["weapons"]["sub_machine_guns"][1] =   strTok("MP5K;UMP45;Vector;P90;Mini-Uzi;AK-74u;Peacekeeper", ";");
	self.syn["weapons"]["light_machine_guns"][1] = strTok("L86 LSW;RPD;MG4;AUG HBAR;M240", ";");
	self.syn["weapons"]["sniper_rifles"][1] =      strTok("Intervention;Barrett .50cal;WA2000;M21 EBR;M40A3;Dragunov", ";");
	self.syn["weapons"]["machine_pistols"][1] =    strTok("PP2000;G18;M93 Raffica;TMP", ";");
	self.syn["weapons"]["shotguns"][1] =           strTok("SPAS-12;AA-12;Striker;Ranger;M1014;Model 1887", ";");
	self.syn["weapons"]["pistols"][1] =            strTok("USP .45;.44 Magnum;M9;Desert Eagle;Gold Desert Eagle", ";");
	self.syn["weapons"]["launchers"][1] =          strTok("AT4-HS;Thumper;Stinger;Javelin;RPG-7", ";");
	self.syn["weapons"]["extras"][1] =             strTok("Riot Shield;Default Weapon;Frag Grenade;Semtex;Throwing Knife;Claymore;C4;Flash Grenade;Stun Grenade;Smoke Grenade", ";");

	// Attachments
	self.syn["attachments"][0] = strTok("reflex;eotech;acog;thermal;grip;gl;shotgun;tactical;heartbeat;silencer;xmags;rof;akimbo;fmj", ";");
	self.syn["attachments"][1] = strTok("Reflex Sight;Holographic Sight;Acog Scope;Thermal Scope;Grip;Grenade Launcher;Shotgun;Tactical Knife;Heartbeat Sensor;Silencer;Extended Mags;Rapid Fire;Akimbo;FMJ", ";");

	// Perks
	self.syn["perks"][0] = strTok("specialty_marathon;specialty_fastreload;specialty_scavenger;specialty_bling;specialty_ONEMANARMY;specialty_bulletdamage;specialty_lightweight;specialty_hardline;specialty_coldblooded;specialty_explosivedamage;specialty_extendedmelee;specialty_bulletaccuracy;specialty_localjammer;specialty_NINJA;specialty_detectexplosive;specialty_heartbreaker", ";");
	self.syn["perks"][1] = strTok("Marathon;Slight of Hand;Scavenger;Bling;One Man Army;Stopping Power;Lightweight;Hardline;Cold-Blooded;Danger Close;Commando;Steady Aim;Scrambler;Ninja;SitRep;Last Stand", ";");

	self.syn["death_streaks"][0] = strTok("specialty_copycat;specialty_combathigh;specialty_MARTYRDOM;specialty_finalstand", ";");
	self.syn["death_streaks"][1] = strTok("Copycat;Painkiller;Martyrdom;Finalstand", ";");

	// Killstreaks
	self.syn["killstreaks"][0] = strTok("uav;airdrop;counter_uav;sentry;airdrop_sentry_minigun;predator_missile;precision_airstrike;harrier_airstrike;helicopter;airdrop_mega;helicopter_flares;stealth_airstrike;helicopter_minigun;ac130;emp;nuke", ";");
	self.syn["killstreaks"][1] = strTok("UAV;Care Package;Counter-UAV;Sentry Gun;Sentry Gun Care Package;Predator Missile;Precision Airstrike;Harrier Strike;Attack Helicopter;Emergency Airdrop;Pave Low;Stealth Bomber;Chopper Gunner;AC-130;EMP;Nuke", ";");
	self.syn["killstreaks"][2] = strTok("3;4;4;5;5;5;6;7;7;8;9;9;11;11;15;25", ";");
}

initial_observer() {
	level endon("game_ended");
	self endon("disconnect");

	while(self has_access()) {
		if(!self in_menu()) {
			if(self adsButtonPressed() && self meleeButtonPressed()) {
				if(self.interaction_enabled) {
					self playSoundToPlayer("mp_killstreak_radar", self);
				}

				close_controls_menu();
				self open_menu();

				while(self adsButtonPressed() && self meleeButtonPressed()) {
					wait 0.2;
				}
			}
		} else {
			menu = self get_menu();
			cursor = self get_cursor();
			if(self meleeButtonPressed()) {
				if(self.interaction_enabled) {
					self playSoundToPlayer("copycat_steal_class", self);
				}

				if(isDefined(self.previous[(self.previous.size - 1)])) {
					self new_menu();
				} else {
					self close_menu();
				}

				while(self meleeButtonPressed()) {
					wait 0.2;
				}
			} else if(self adsButtonPressed() && !self attackButtonPressed() || self attackButtonPressed() && !self adsButtonPressed()) {
				if(isDefined(self.structure) && self.structure.size >= 2) {
					if(self.interaction_enabled) {
						self playSoundToPlayer("mouse_over", self);
					}

					scrolling = set_variable(self attackButtonPressed(), 1, -1);

					self set_cursor((cursor + scrolling));
					self update_scrolling(scrolling);
				}

				wait (0.05 * self.scrolling_buffer);
			} else if(self fragButtonPressed() && !self secondaryOffhandButtonPressed() || !self fragButtonPressed() && self secondaryOffhandButtonPressed()) {
				if(isDefined(self.structure[cursor].array) || isDefined(self.structure[cursor].increment)) {
					if(self.interaction_enabled) {
						self playSoundToPlayer("ui_mp_suitcasebomb_timer", self);
					}

					scrolling = set_variable(self secondaryOffhandButtonPressed(), 1, -1);

					self update_slider(scrolling);
					self update_progression();
				}

				wait (0.05 * self.scrolling_buffer);
			} else if(self useButtonPressed()) {
				if(isDefined(self.structure[cursor]) && isDefined(self.structure[cursor].command)) {
					if(self.interaction_enabled) {
						self playSoundToPlayer("mouse_click", self);
					}

					if(self.structure[cursor].command == ::new_menu) {
						self.previous_option = self.structure[cursor].text;
					}

					if(isDefined(self.structure[cursor].array) || isDefined(self.structure[cursor].increment)) {
						if(isDefined(self.structure[cursor].array)) {
							cursor_selected = set_variable(isDefined(self.structure[cursor].array), self.structure[cursor].array[self.slider[(menu + "_" + cursor)]], self.slider[(menu + "_" + cursor)]);
						} else {
							cursor_selected = self.slider[(menu + "_" + cursor)];
						}
						self thread execute_function(self.structure[cursor].command, cursor_selected, self.structure[cursor].parameter_1, self.structure[cursor].parameter_2);
					} else {
						self thread execute_function(self.structure[cursor].command, self.structure[cursor].parameter_1, self.structure[cursor].parameter_2);
					}

					if(isDefined(self.structure[cursor]) && isDefined(self.structure[cursor].toggle)) {
						self update_display();
					}
				}

				while(self useButtonPressed()) {
					wait 0.1;
				}
			}
		}
		wait 0.05;
	}
}

event_system() {
	level endon("game_ended");
	self endon("disconnect");

	for(;;) {
		event_name = self waittill_any_return("spawned_player", "player_downed", "death", "joined_spectators");
		switch (event_name) {
			case "spawned_player":
				self.spawn_origin = self.origin;
				self.spawn_angles = self.angles;
				if(!isDefined(self.finalized) && self has_access()) {
					self.finalized = true;

					level.player_out_of_playable_area_monitor = false;
					self notify("stop_player_out_of_playable_area_monitor");

					if(self isHost()) {
						self freezeControls(false);
					}

					self initial_variable();
					self thread initial_observer();

					self.controls["title"] = self create_text("Controls", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 99), (self.y_offset + 4), self.color_theme, 1, 10);
					self.controls["separator"][0] = self create_shader("white", "TOP_LEFT", "TOPCENTER", 181, (self.y_offset + 7.5), 37, 1, self.color_theme, 1, 10);
					self.controls["separator"][1] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", 399, (self.y_offset + 7.5), 37, 1, self.color_theme, 1, 10);
					self.controls["border"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, (self.y_offset - 1), (self.width + 250), 97, self.color_theme, 1, 1);
					self.controls["background"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 1), self.y_offset, (self.width + 248), 95, (0.075, 0.075, 0.075), 1, 2);
					self.controls["foreground"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 1), (self.y_offset + 16), (self.width + 248), 79, (0.1, 0.1, 0.1), 1, 3);

					self.controls["text"][0] = self create_text("Open: ^3[{+speed_throw}] ^7and ^3[{+melee}]", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 4), (self.y_offset + 20), (0.75, 0.75, 0.75), 1, 10);
					self.controls["text"][1] = self create_text("Scroll: ^3[{+speed_throw}] ^7and ^3[{+attack}]", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 4), (self.y_offset + 40), (0.75, 0.75, 0.75), 1, 10);
					self.controls["text"][2] = self create_text("Select: ^3[{+activate}] ^7Back: ^3[{+melee}]", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 4), (self.y_offset + 60), (0.75, 0.75, 0.75), 1, 10);
					self.controls["text"][3] = self create_text("Sliders: ^3[{+smoke}] ^7and ^3[{+frag}]", self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 4), (self.y_offset + 80), (0.75, 0.75, 0.75), 1, 10);

					wait 8;

					close_controls_menu();
				}
				break;
			default:
				if(!self has_access()) {
					continue;
				}

				if(self in_menu()) {
					self close_menu();
				}
				break;
		}
	}
}

session_expired() {
	level waittill("game_ended");
	level endon("game_ended");

	foreach(index, player in level.players) {
		if(!player has_access()) {
			continue;
		}

		if(player in_menu()) {
			player close_menu();
		}
	}
}

player_connect() {
	level endon("game_ended");

	for(;;) {
		level waittill("connected",player);
		player.access = set_variable(player isHost(), "Host",  "None");
		player thread event_system();
	}
}

player_disconnect() {
	[[level.player_disconnect]]();
}

player_damage_callback(inflictor, attacker, damage, flags, death_reason, weapon, point, direction, hit_location, time_offset) {
	self endon("disconnect");

	if(isDefined(self.god_mode) && self.god_mode) {
		return;
	}

	[[level.originalCallbackPlayerDamage]](inflictor, attacker, damage, flags, death_reason, weapon, point, direction, hit_location, time_offset);
}

player_downed(einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration) {
	self notify("player_downed");
	[[level.player_downed]](einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration);
}

// Utilities

in_array(array, item) {
	if(!isDefined(array) || !isArray(array)) {
		return;
	}

	for(a = 0; a < array.size; a++) {
		if(array[a] == item) {
			return true;
		}
	}

	return false;
}

auto_archive() {
	if(!isDefined(self.element_result)) {
		self.element_result = 0;
	}

	if(!isAlive(self) || self.element_result > 22) {
		return true;
	}

	return false;
}

create_rainbow_color() {
	x = 0; y = 0;
	r = 0; g = 0; b = 0;
	level.rainbow_color = (0, 0, 0);

	level endon("game_ended");

	while(true) {
		if(y >= 0 && y < 258) {
			r = 255;
			g = 0;
			b = x;
		} else if(y >= 258 && y < 516) {
			r = 255 - x;
			g = 0;
			b = 255;
		} else if(y >= 516 && y < 774) {
			r = 0;
			g = x;
			b = 255;
		} else if(y >= 774 && y < 1032) {
			r = 0;
			g = 255;
			b = 255 - x;
		} else if(y >= 1032 && y < 1290) {
			r = x;
			g = 255;
			b = 0;
		} else if(y >= 1290 && y < 1545) {
			r = 255;
			g = 255 - x;
			b = 0;
		}

		x += 3;
		if(x > 255) {
			x = 0;
		}

		y += 3;
		if(y > 1545) {
			y = 0;
		}

		level.rainbow_color = (r/255, g/255, b/255);
		wait .05;
	}
}

start_rainbow() {
	level endon("game_ended");

	while(isDefined(self)) {
		self fadeOverTime(.05);
		self.color = level.rainbow_color;
		wait .05;
	}
}

create_text(text, font, font_scale, align_x, align_y, x_offset, y_offset, color, alpha, z_index, hide_when_in_menu) {
	textElement = self createFontString(font, font_scale);
	textElement setPoint(align_x, align_y, x_offset, y_offset);

	textElement.alpha = alpha;
	textElement.sort = z_index;
	textElement.anchor = self;
	textElement.archived = self auto_archive();

	if(isDefined(hide_when_in_menu)) {
		textElement.hideWhenInMenu = hide_when_in_menu;
	} else {
		textElement.hideWhenInMenu = true;
	}

	if(strIsNumber(color[0]) || color != "rainbow") {
		textElement.color = color;
	} else {
		textElement.color = level.rainbow_color;
		textElement thread start_rainbow();
	}

	if(isDefined(text)) {
		if(strIsNumber(text)) {
			textElement setValue(text);
		} else {
			textElement set_text(text);
		}
	}

	self.element_result++;
	return textElement;
}

create_shader(shader, align_x, align_y, x_offset, y_offset, width, height, color, alpha, z_index, hide_when_in_menu) {
	shaderElement = newClientHudElem(self);
	shaderElement.elemType = "icon";
	shaderElement.children = [];
	shaderElement.alpha = alpha;
	shaderElement.sort = z_index;
	shaderElement.anchor = self;
	shaderElement.archived = self auto_archive();

	if(isDefined(hide_when_in_menu)) {
		shaderElement.hideWhenInMenu = hide_when_in_menu;
	} else {
		shaderElement.hideWhenInMenu = true;
	}

	if(strIsNumber(color[0]) || color != "rainbow") {
		shaderElement.color = color;
	} else {
		shaderElement.color = level.rainbow_color;
		shaderElement thread start_rainbow();
	}

	shaderElement setParent(level.uiParent);
	shaderElement setPoint(align_x, align_y, x_offset, y_offset);

	shaderElement set_shader(shader, width, height);

	self.element_result++;
	return shaderElement;
}

set_text(text) {
	if(!isDefined(self) || !isDefined(text)) {
		return;
	}

	self.text = text;
	self setText(text);
}

set_shader(shader, width, height) {
	if(!isDefined(self)) {
		return;
	}

	if(!isDefined(shader)) {
		if(!isDefined(self.shader)) {
			return;
		}

		shader = self.shader;
	}

	if(!isDefined(width)) {
		if(!isDefined(self.width)) {
			return;
		}

		width = self.width;
	}

	if(!isDefined(height)) {
		if(!isDefined(self.height)) {
			return;
		}

		height = self.height;
	}

	self.shader = shader;
	self.width = width;
	self.height = height;
	self setShader(shader, width, height);
}

clean_text(text) {
	if(!isDefined(text) || text == "") {
		return;
	}

	if(text[0] == toUpper(text[0])) {
		if(isSubStr(text, " ") && !isSubStr(text, "_")) {
			return text;
		}
	}

	text = strTok(toLower(text), "_");
	new_string = "";
	for(a = 0; a < text.size; a++) {
		illegal = strTok("player;weapon;wpn;viewmodel;camo", ";");
		replacement = " ";
		if(in_array(illegal, text[a])) {
			for(b = 0; b < text[a].size; b++) {
				if(b != 0) {
					new_string += text[a][b];
				} else {
					new_string += toUpper(text[a][b]);
				}
			}

			if(a != (text.size - 1)) {
				new_string += replacement;
			}
		}
	}

	return new_string;
}

clean_name(name) {
	if(!isDefined(name) || name == "") {
		return;
	}

	illegal = strTok("^A;^B;^F;^H;^I;^0;^1;^2;^3;^4;^5;^6;^7;^8;^9;^:", ";");
	new_string = "";
	for(a = 0; a < name.size; a++) {
		if(a < (name.size - 1)) {
			if(in_array(illegal, (name[a] + name[(a + 1)]))) {
				a += 2;
				if(a >= name.size) {
					break;
				}
			}
		}

		if(isDefined(name[a]) && a < name.size) {
			new_string += name[a];
		}
	}

	return new_string;
}

destroy_element() {
	if(!isDefined(self)) {
		return;
	}

	self destroy();
	if(isDefined(self.anchor)) {
		self.anchor.element_result--;
	}
}

destroy_all(array) {
	if(!isDefined(array) || !isArray(array)) {
		return;
	}

	keys = getarraykeys(array);
	for(a = 0; a < keys.size; a++) {
		if(isArray(array[keys[a]])) {
			foreach(index, value in array[keys[a]]) {
				if(isDefined(value)) {
					value destroy_element();
				}
			}
		} else {
			if(isDefined(array[keys[a]])) {
				array[keys[a]] destroy_element();
			}
		}
	}
}

destroy_option() {
	element = strTok("text;submenu;toggle;slider", ";");
	for(a = 0; a < element.size; a++) {
		if(isDefined(self.menu[element[a]]) && self.menu[element[a]].size) {
			destroy_all(self.menu[element[a]]);
		}

		self.menu[element[a]] = [];
	}
}

get_name() {
	name = self.name;
	if(name[0] != "[") {
		return name;
	}

	for(a = (name.size - 1); a >= 0; a--) {
		if(name[a] == "]") {
			break;
		}
	}

	return getSubStr(name, (a + 1));
}

has_access() {
	return isDefined(self.access) && self.access != "None";
}

calculate_distance(origin, destination, velocity) {
	return (distance(origin, destination) / velocity);
}

// Structure

set_menu(menu) {
	self.current_menu = set_variable(isDefined(menu), menu, "Synergy");
}

get_menu() {
	if(!isDefined(self.current_menu)) {
		self set_menu();
	}

	return self.current_menu;
}

set_title(title) {
	self.current_title = set_variable(isDefined(title), title, self get_menu());
}

get_title() {
	if(!isDefined(self.current_title)) {
		self set_title();
	}

	return self.current_title;
}

set_cursor(index) {
	self.cursor[self get_menu()] = set_variable(isDefined(index) && strIsNumber(index), index, 0);
}

get_cursor() {
	if(!isDefined(self.cursor[self get_menu()])) {
		self set_cursor();
	}

	return self.cursor[self get_menu()];
}

get_description() {
	return self.structure[self get_cursor()].description;
}

set_state(state) {
	self.in_menu = set_variable(isDefined(state) && state < 2, state, false);
}

in_menu() {
	return isDefined(self.in_menu) && self.in_menu;
}

set_locked(state) {
	self.is_locked = set_variable(isDefined(state) && state < 2, state, false);
}

is_locked() {
	return isDefined(self.is_locked) && self.is_locked;
}

empty_option() {
	option = strTok("Nothing To See Here!;Quiet Here, Isn't It?;Oops, Nothing Here Yet!;Bit Empty, Don't You Think?", ";");
	return option[randomInt(option.size)];
}

empty_function() {}

empty_array() {
	return [];
}

execute_function(command, parameter_1, parameter_2, parameter_3) {
	self endon("disconnect");

	if(!isDefined(command)) {
		return;
	}

	if(isDefined(parameter_3)) {
		return self thread[[command]](parameter_1, parameter_2, parameter_3);
	}

	if(isDefined(parameter_2)) {
		return self thread[[command]](parameter_1, parameter_2);
	}

	if(isDefined(parameter_1)) {
		return self thread[[command]](parameter_1);
	}

	self thread[[command]]();
}

add_menu(title, menu_size, extra) {
	self.structure = [];
	self set_title(title);

	if(!isDefined(self get_cursor())) {
		self set_cursor();
	}

	if(isDefined(self.menu["title"])) {
		if(isDefined(extra)) {
			self.menu["title"].x = (self.x_offset + 106) - menu_size - extra;
		} else {
			if(menu_size <= 7) {
				self.menu["title"].x = (self.x_offset + 106) - menu_size;
			} else {
				self.menu["title"].x = (self.x_offset + 106) - (menu_size * 1.4);
			}
		}
	}
}

add_option(text, description, command, parameter_1, parameter_2) {
	option = spawnStruct();
	option.text = text;
	option.description = description;
	if(isDefined(command)) {
		option.command = command;
	} else {
		option.command = ::empty_function;
	}
	option.parameter_1 = parameter_1;
	option.parameter_2 = parameter_2;

	self.structure[self.structure.size] = option;
}

add_toggle(text, description, command, variable, parameter_1, parameter_2) {
	option = spawnStruct();
	option.text = text;
	option.description = description;
	if(isDefined(command)) {
		option.command = command;
	} else {
		option.command = ::empty_function;
	}
	option.toggle = isDefined(variable) && variable;
	option.parameter_1 = parameter_1;
	option.parameter_2 = parameter_2;

	self.structure[self.structure.size] = option;
}

add_array(text, description, command, array, parameter_1, parameter_2) {
	option = spawnStruct();
	option.text = text;
	option.description = description;
	if(isDefined(command)) {
		option.command = command;
	} else {
		option.command = ::empty_function;
	}
	if(isDefined(array)) {
		option.array = array;
	} else {
		option.array = ::empty_array;
	}
	option.parameter_1 = parameter_1;
	option.parameter_2 = parameter_2;

	self.structure[self.structure.size] = option;
}

add_increment(text, description, command, start, minimum, maximum, increment, parameter_1, parameter_2) {
	option = spawnStruct();
	option.text = text;
	option.description = description;
	if(isDefined(command)) {
		option.command = command;
	} else {
		option.command = ::empty_function;
	}
	if(strIsNumber(start)) {
		option.start = start;
	} else {
		option.start = 0;
	}
	if(strIsNumber(minimum)) {
		option.minimum = minimum;
	} else {
		option.minimum = 0;
	}
	if(strIsNumber(maximum)) {
		option.maximum = maximum;
	} else {
		option.maximum = 10;
	}
	if(strIsNumber(increment)) {
		option.increment = increment;
	} else {
		option.increment = 1;
	}
	option.parameter_1 = parameter_1;
	option.parameter_2 = parameter_2;

	self.structure[self.structure.size] = option;
}

new_menu(menu) {
	if(!isDefined(menu)) {
		menu = self.previous[(self.previous.size - 1)];
		self.previous[(self.previous.size - 1)] = undefined;
	} else {
		if(self get_menu() == "All Players") {
			player = level.players[self get_cursor()];
			self.selected_player = player;
		}

		self.previous[self.previous.size] = self get_menu();
	}

	self set_menu(menu);
	self update_display();
}

// Custom Structure

open_menu() {
	self.menu["border"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", self.x_offset, (self.y_offset - 1), (self.width + 250), 34, self.color_theme, 1, 1);
	self.menu["background"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 1), self.y_offset, (self.width + 248), 32, (0.075, 0.075, 0.075), 1, 2);
	self.menu["foreground"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 1), (self.y_offset + 16), (self.width + 248), 16, (0.1, 0.1, 0.1), 1, 3);
	self.menu["cursor"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 1), (self.y_offset + 16), (self.width + 243), 16, (0.15, 0.15, 0.15), 1, 4);
	self.menu["scrollbar"] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + (self.menu["background"].width + 1)), (self.y_offset + 16), 4, 16, (0.25, 0.25, 0.25), 1, 4);

	self set_state(true);
	self update_display();
}

close_menu() {
	self notify("menu_ended");
	self set_state(false);
	self destroy_option();
	self destroy_all(self.menu);
}

display_title(title) {
	title = set_variable(isDefined(title), title, self get_title());
	if(!isDefined(self.menu["title"])) {
		self.menu["title"] = self create_text(title, self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 99), (self.y_offset + 4), self.color_theme, 1, 10);
		self.menu["separator"][0] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 6), (self.y_offset + 7.5), int((self.menu["cursor"].width / 6)), 1, self.color_theme, 1, 10);
		self.menu["separator"][1] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + (self.menu["cursor"].width - 2) + 3), (self.y_offset + 7.5), int((self.menu["cursor"].width / 6)), 1, self.color_theme, 1, 10);
	} else {
		self.menu["title"] set_text(title);
	}
}

display_description(description) {
	description = set_variable(isDefined(description), description, self get_description());
	if(isDefined(self.menu["description"]) && !self.description_enabled || isDefined(self.menu["description"]) && !isDefined(description)) {
		self.menu["description"] destroy_element();
	}

	if(isDefined(description) && self.description_enabled) {
		if(!isDefined(self.menu["description"])) {
			self.menu["description"] = self create_text(description, self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", (self.x_offset + 4), (self.y_offset + 36), (0.75, 0.75, 0.75), 1, 10);
		} else {
			self.menu["description"] set_text(description);
		}
	}
}

display_option() {
	self destroy_option();
	self menu_option();
	if(!isDefined(self.structure) || !self.structure.size) {
		self add_option(empty_option());
	}

	self display_title();
	self display_description();
	if(isDefined(self.structure) && self.structure.size) {
		if(self get_cursor() >= self.structure.size) {
			self set_cursor((self.structure.size - 1));
		}

		if(!isDefined(self.menu["toggle"][0])) {
			self.menu["toggle"][0] = [];
		}

		if(!isDefined(self.menu["toggle"][1])) {
			self.menu["toggle"][1] = [];
		}

		menu = self get_menu();
		cursor = self get_cursor();
		maximum = min(self.structure.size, self.option_limit);
		for(a = 0; a < maximum; a++) {
			if(self get_cursor() >= int((self.option_limit / 2)) && self.structure.size > self.option_limit) {
				if((self get_cursor() + int((self.option_limit / 2))) >= (self.structure.size - 1)) {
					start = (self.structure.size - self.option_limit);
				} else {
					start = (self get_cursor() - int((self.option_limit / 2)));
				}
			} else {
				start = 0;
			}
			index = (a + start);
			if(isDefined(self.structure[index].command) && self.structure[index].command == ::new_menu) {
				element_color = set_variable((cursor == index), (0.75, 0.75, 0.75), (0.5, 0.5, 0.5));
				self.menu["submenu"][index] = self create_text(">", self.font, self.font_scale, "TOP_RIGHT", "TOPCENTER", (self.x_offset + 220), (self.y_offset + ((a * self.option_spacing) + 18.5)), element_color, 1, 10);
			}

			if(isDefined(self.structure[index].toggle)) { // Toggle Off
				self.menu["toggle"][0][index] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 14), (self.y_offset + ((a * self.option_spacing) + 19)), 10, 10, (0.25, 0.25, 0.25), 1, 9);
				if(self.structure[index].toggle) { // Toggle On
					self.menu["toggle"][1][index] = self create_shader("white", "TOP_RIGHT", "TOPCENTER", (self.x_offset + 13), (self.y_offset + ((a * self.option_spacing) + 20)), 8, 8, (1, 1, 1), 1, 10);
				}
			}

			if(isDefined(self.structure[index].array) || isDefined(self.structure[index].increment)) {
				if(isDefined(self.structure[index].array)) { // Array Text
					element_color = set_variable((cursor == index), (0.75, 0.75, 0.75), (0.5, 0.5, 0.5));
					self.menu["slider"][index] = self create_text(self.slider[(menu + "_" + index)], self.font, self.font_scale, "TOP_RIGHT", "TOPCENTER", (self.x_offset + (self.menu["cursor"].width - 2)), (self.y_offset + ((a * self.option_spacing) + 20)), element_color, 1, 10);
				} else if(cursor == index) { // Increment Text
					self.menu["slider"][index] = self create_text(self.slider[(menu + "_" + index)], self.font, self.font_scale, "TOP_RIGHT", "TOPCENTER", (self.x_offset + (self.menu["cursor"].width - 3)), (self.y_offset + ((a * self.option_spacing) + 20)), (0.75, 0.75, 0.75), 1, 10);
				}

				self update_slider(undefined, index);
			}

			text_string = set_variable((isDefined(self.structure[index].array) || isDefined(self.structure[index].increment)), (self.structure[index].text + ":"), self.structure[index].text);

			if(isDefined(self.structure[index].toggle)) {
				element_x_offset = (self.x_offset + 16);
			} else {
				if(!isDefined(self.structure[index].command)) {
					element_x_offset = (self.x_offset + (self.menu["cursor"].width / 2));
				} else {
					element_x_offset = (self.x_offset + 4);
				}
			}

			if(!isDefined(self.structure[index].command)) {
				element_color = self.color_theme;
			} else {
				if((cursor == index)) {
					element_color = (0.75, 0.75, 0.75);
				} else {
					element_color = (0.5, 0.5, 0.5);
				}
			}

			self.menu["text"][index] = self create_text(text_string, self.font, self.font_scale, "TOP_LEFT", "TOPCENTER", element_x_offset, (self.y_offset + ((a * self.option_spacing) + 20)), element_color, 1, 10);
		}
	}
}

update_display() {
	self display_option();
	self update_scrollbar();
	self update_progression();
	self update_rescaling();
}

update_scrolling(scrolling) {
	if(isDefined(self.structure[self get_cursor()]) && !isDefined(self.structure[self get_cursor()].command)) {
		self set_cursor((self get_cursor() + scrolling));
		return self update_scrolling(scrolling);
	}

	if(self get_cursor() >= self.structure.size || self get_cursor() < 0) {
		self set_cursor(set_variable(self get_cursor() >= self.structure.size, 0, (self.structure.size - 1)));
	}

	self update_display();
}

update_slider(scrolling, cursor) {
	menu = self get_menu();
	cursor = set_variable(isDefined(cursor), cursor, self get_cursor());
	scrolling = set_variable(isDefined(scrolling), scrolling, 0);
	if(!isDefined(self.slider[(menu + "_" + cursor)])) {
		self.slider[(menu + "_" + cursor)] = set_variable(isDefined(self.structure[cursor].array), 0, self.structure[cursor].start);
	}

	if(isDefined(self.structure[cursor].array)) {
		if(scrolling == -1) {
			self.slider[(menu + "_" + cursor)]++;
		}

		if(scrolling == 1) {
			self.slider[(menu + "_" + cursor)]--;
		}

		if(self.slider[(menu + "_" + cursor)] > (self.structure[cursor].array.size - 1) || self.slider[(menu + "_" + cursor)] < 0) {
			self.slider[(menu + "_" + cursor)] = set_variable(self.slider[(menu + "_" + cursor)] > (self.structure[cursor].array.size - 1), 0, (self.structure[cursor].array.size - 1));
		}

		if(isDefined(self.menu["slider"][cursor])) {
			self.menu["slider"][cursor] set_text((self.structure[cursor].array[self.slider[(menu + "_" + cursor)]] + " [" + (self.slider[(menu + "_" + cursor)] + 1) + "/" + self.structure[cursor].array.size + "]"));
		}
	} else {
		if(scrolling == -1) {
			self.slider[(menu + "_" + cursor)] += self.structure[cursor].increment;
		}

		if(scrolling == 1) {
			self.slider[(menu + "_" + cursor)] -= self.structure[cursor].increment;
		}

		if(self.slider[(menu + "_" + cursor)] > self.structure[cursor].maximum || self.slider[(menu + "_" + cursor)] < self.structure[cursor].minimum) {
			self.slider[(menu + "_" + cursor)] = set_variable(self.slider[(menu + "_" + cursor)] > self.structure[cursor].maximum, self.structure[cursor].minimum, self.structure[cursor].maximum);
		}

		if(isDefined(self.menu["slider"][cursor])) {
			self.menu["slider"][cursor] setValue(self.slider[(menu + "_" + cursor)]);
		}
	}
}

update_progression() {
	if(isDefined(self.structure[self get_cursor()].increment) && self.slider[(self get_menu() + "_" + self get_cursor())] != 0) {
		value = abs((self.structure[self get_cursor()].minimum - self.structure[self get_cursor()].maximum)) / (self.menu["cursor"].width);
		width = ceil(((self.slider[(self get_menu() + "_" + self get_cursor())] - self.structure[self get_cursor()].minimum) / value));
		if(!isDefined(self.menu["progression"])) {
			self.menu["progression"] = self create_shader("white", "TOP_LEFT", "TOPCENTER", (self.x_offset + 1), self.menu["cursor"].y, int(width), 16, (0.3, 0.3, 0.3), 1, 5);
		} else {
			self.menu["progression"] set_shader(self.menu["progression"].shader, int(width), self.menu["progression"].height);
		}

		if(self.menu["progression"].y != self.menu["cursor"].y) {
			self.menu["progression"].y = self.menu["cursor"].y;
		}
	} else if(isDefined(self.menu["progression"])) {
		self.menu["progression"] destroy_element();
	}
}

update_scrollbar() {
	maximum = min(self.structure.size, self.option_limit);
	height = int((maximum * self.option_spacing));
	adjustment = set_variable(self.structure.size > self.option_limit, ((self.menu["foreground"].height / self.structure.size) * maximum), height);
	if(height - adjustment == 0) {
		position = set_variable(self.structure.size > self.option_limit, 0, 0);
	} else {
		position = set_variable(self.structure.size > self.option_limit, ((self.structure.size - 1) / (height - adjustment)), 0);
	}
	if(isDefined(self.menu["cursor"])) {
		self.menu["cursor"].y = (self.menu["text"][self get_cursor()].y - 4);
	}

	if(isDefined(self.menu["scrollbar"])) {
		self.menu["scrollbar"].y = (self.y_offset + 16);
		if(self.structure.size > self.option_limit) {
			self.menu["scrollbar"].y += (self get_cursor() / position);
		}
	}

	self.menu["scrollbar"] set_shader(self.menu["scrollbar"].shader, self.menu["scrollbar"].width, int(adjustment));
}

update_rescaling() {
	maximum = min(self.structure.size, self.option_limit);
	height = int((maximum * self.option_spacing));
	if(isDefined(self.menu["description"])) {
		self.menu["description"].y = (self.y_offset + (height + 20));
	}

	description_height = set_variable(isDefined(self get_description()) && self.description_enabled, (height + 34), (height + 18));
	self.menu["border"] set_shader(self.menu["border"].shader, self.menu["border"].width, description_height);
	self.menu["background"] set_shader(self.menu["background"].shader, self.menu["background"].width, description_height - 2);
	self.menu["foreground"] set_shader(self.menu["foreground"].shader, self.menu["foreground"].width, height);
}

// Option Structure

menu_option() {
	menu = self get_menu();
	switch (menu) {
		case "Synergy":
			self add_menu(menu, menu.size);

			self add_option("Basic Options", undefined, ::new_menu, "Basic Options");
			self add_option("Fun Options", undefined, ::new_menu, "Fun Options");
			self add_option("Weapon Options", undefined, ::new_menu, "Weapon Options");
			self add_option("Give Killstreaks", undefined, ::new_menu, "Give Killstreaks");
			self add_option("Menu Options", undefined, ::new_menu, "Menu Options");
			self add_option("All Players", undefined, ::new_menu, "All Players");

			break;
		case "Basic Options":
			self add_menu(menu, menu.size);

			self add_toggle("God Mode", "Makes you Invincible", ::god_mode, self.god_mode);
			self add_toggle("Frag No Clip", "Fly through the Map using (^3[{+frag}]^7)", ::frag_no_clip, self.frag_no_clip);
			self add_toggle("Infinite Ammo", "Gives you Infinite Ammo and Infinite Grenades", ::infinite_ammo, self.infinite_ammo);

			self add_option("Give All Perks", undefined, ::give_all_perks);
			self add_option("Take All Perks", undefined, ::take_all_perks);

			self add_option("Give Perks", undefined, ::new_menu, "Give Perks");
			self add_option("Take Perks", undefined, ::new_menu, "Take Perks");

			break;
		case "Fun Options":
			self add_menu(menu, menu.size);

			self add_toggle("Forge Mode", undefined, ::forge_mode, self.forge_mode);

			self add_increment("Set Speed", undefined, ::set_speed, 190, 190, 990, 20);
			self add_increment("Set Timescale", undefined, ::set_timescale, 1, 1, 10, 1);
			self add_increment("Set Gravity", undefined, ::set_gravity, 900, 120, 900, 20);

			self add_toggle("Fullbright", "Removes all Shadows and Lighting", ::fullbright, self.fullbright);
			self add_toggle("Third Person", undefined, ::third_person, self.third_person);

			self add_option("Visions", undefined, ::new_menu, "Visions");

			break;
		case "Menu Options":
			self add_menu(menu, menu.size);

			self add_increment("Move Menu X", "Move the Menu around Horizontally", ::modify_menu_position, 0, -600, 20, 10, "x");
			self add_increment("Move Menu Y", "Move the Menu around Vertically", ::modify_menu_position, 0, -50, 50, 10, "y");

			self add_option("Rainbow Menu", "Set the Menu Outline Color to Cycling Rainbow", ::set_menu_rainbow);

			self add_increment("Red", "Set the Red Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Red");
			self add_increment("Green", "Set the Green Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Green");
			self add_increment("Blue", "Set the Blue Value for the Menu Outline Color", ::set_menu_color, 255, 1, 255, 1, "Blue");

			self add_toggle("Watermark", "Enable/Disable Watermark in the Top Left Corner", ::watermark, self.watermark);
			self add_toggle("Hide UI", undefined, ::hide_ui, self.hide_ui);
			self add_toggle("Hide Weapon", undefined, ::hide_weapon, self.hide_weapon);

			break;
		case "All Players":
			self add_menu(menu, menu.size);

			foreach(player in level.players){
				self add_option(player.name, undefined, ::new_menu, "Player Option");
			}

			break;
		case "Player Option":
			self add_menu(menu, menu.size);

			target = undefined;
			foreach(player in level.players) {
				if(player.name == self.previous_option) {
					target = player;
					break;
				}
			}

			if(isDefined(target)) {
				self add_option("Print", "Print Player Name", ::iPrintString, target);
				self add_option("Kill", "Kill the Player", ::commit_suicide, target);

				if(!target isHost()) {
					self add_option("Kick", "Kick the Player from the Game", ::kick_player, target);
				}
			} else {
				self add_option("Player not found");
			}

			break;
		case "Give Perks":
			self add_menu(menu, menu.size);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self add_option(self.syn["perks"][1][i], undefined, ::give_perk, self.syn["perks"][0][i], 0);
			}

			break;
		case "Take Perks":
			self add_menu(menu, menu.size);

			for(i = 0; i < self.syn["perks"][0].size; i++) {
				self add_option(self.syn["perks"][1][i], undefined, ::take_perk, self.syn["perks"][0][i]);
			}

			break;
		case "Visions":
			self add_menu(menu, menu.size);

			self add_option("None", undefined, ::set_vision, "");

			for(i = 0; i < self.syn["visions"][0].size; i++) {
				self add_option(self.syn["visions"][1][i], undefined, ::set_vision, self.syn["visions"][0][i]);
			}

			break;
		case "Give Killstreaks":
			self add_menu(menu, menu.size, 1);

			for(i = 0; i < self.syn["killstreaks"][0].size; i++) {
				self add_option(self.syn["killstreaks"][1][i], undefined, ::give_killstreak, self.syn["killstreaks"][0][i], self.syn["killstreaks"][2][i]);
			}

			break;
		case "Weapon Options":
			self add_menu(menu, menu.size);

			category = get_category(getBaseWeaponName(self getCurrentWeapon()));

			self add_option("Give Weapons", undefined, ::new_menu, "Give Weapons");

			if(isDefined(category)) {
				if(category != "launchers" && category != "extras") {
					self add_option("Attachments", undefined, ::new_menu, "Attachments");
				}
			}

			self add_option("Take Current Weapon", undefined, ::take_weapon);
			self add_option("Drop Current Weapon", undefined, ::drop_weapon);

			break;
		case "Give Weapons":
			self add_menu(menu, menu.size);

			for(i = 0; i < self.syn["weapons"]["category"][1].size; i++) {
				self add_option(self.syn["weapons"]["category"][1][i], undefined, ::new_menu, self.syn["weapons"]["category"][1][i]);
			}

			break;
		case "Attachments":
			self add_menu(menu, menu.size);

			category = get_category(getBaseWeaponName(self getCurrentWeapon()));

			if(isDefined(category)) {
				if(category != "launchers" && category != "extras") {
					self add_option("Equip Attachment", undefined, ::new_menu, "Equip Attachment");
				}
				if(category != "launchers" && category != "machine_pistols" && category != "shotguns" && category != "pistols" && category != "extras") {
					self add_option("Equip Camo", undefined, ::new_menu, "Equip Camo");
				}
			}

			break;
		case "Equip Attachment":
			self add_menu(menu, menu.size);

			weapon_attachments = get_weapon_attachments(getBaseWeaponName(self getCurrentWeapon()));

			foreach(attachment in weapon_attachments) {
				self add_option(get_attachment_name(attachment), undefined, ::equip_attachment, attachment);
			}

			break;
		case "Equip Camo":
			self add_menu(menu, menu.size);

			self add_increment("Equip Camo", undefined, ::equip_camo, 1, 1, 8, 1);
			self add_toggle("Cycle Camos", undefined, ::cycle_camos, self.cycle_camos);

			break;
		case "Assault Rifles":
			self add_menu(menu, menu.size);

			load_weapons("assault_rifles");

			break;
		case "Sub Machine Guns":
			self add_menu(menu, menu.size);

			load_weapons("sub_machine_guns");

			break;
		case "Light Machine Guns":
			self add_menu(menu, menu.size);

			load_weapons("light_machine_guns");

			break;
		case "Sniper Rifles":
			self add_menu(menu, menu.size);

			load_weapons("sniper_rifles");

			break;
		case "Machine Pistols":
			self add_menu(menu, menu.size);

			load_weapons("machine_pistols");

			break;
		case "Shotguns":
			self add_menu(menu, menu.size);

			load_weapons("shotguns");

			break;
		case "Pistols":
			self add_menu(menu, menu.size);

			load_weapons("pistols");

			break;
		case "Launchers":
			self add_menu(menu, menu.size);

			load_weapons("launchers");

			break;
		case "Extras":
			self add_menu(menu, menu.size);

			load_weapons("extras");

			break;
		default:
			if(!isDefined(self.selected_player)) {
				self.selected_player = self;
			}

			self player_option(menu, self.selected_player);
			break;
	}
}

player_option(menu, player) {
	if(!isDefined(menu) || !isDefined(player) || !isplayer(player)) {
		menu = "Error";
	}

	switch (menu) {
		case "Player Option":
			self add_menu(clean_name(player get_name()));
			break;
		case "Error":
			self add_menu();
			self add_option("Oops, Something Went Wrong!", "Condition: Undefined");
			break;
		default:
			error = true;
			if(error) {
				self add_menu("Critical Error");
				self add_option("Oops, Something Went Wrong!", "Condition: Menu Index");
			}
			break;
	}
}

// Misc Options

return_toggle(variable) {
	return isDefined(variable) && variable;
}

close_controls_menu() {
	if(isDefined(self.controls["title"])) {
		self.controls["title"] destroy();
		self.controls["separator"][0] destroy();
		self.controls["separator"][1] destroy();
		self.controls["border"] destroy();
		self.controls["background"] destroy();
		self.controls["foreground"] destroy();

		self.controls["text"][0] destroy();
		self.controls["text"][1] destroy();
		self.controls["text"][2] destroy();
		self.controls["text"][3] destroy();
	}
}

iPrintString(string) {
	if(!isDefined(self.syn["string"])) {
		self.syn["string"] = self create_text(string, "default", 1.5, "center", "top", 0, -100, (1, 1, 1), 1, 9999, false);
	} else {
		self.syn["string"] set_text(string);
	}
  self.syn["string"] notify("stop_hud_fade");
  self.syn["string"].alpha = 1;
  self.syn["string"] setText(string);
  self.syn["string"] thread fade_hud(0, 2.5);
}

fade_hud(alpha, time) {
	self endon("stop_hud_fade");
	self fadeOverTime(time);
	self.alpha = alpha;
	wait time;
}

set_variable(check, option_1, option_2) {
	if(check) {
		return option_1;
	} else {
		return option_2;
	}
}

strIsNumber(value) {
	return !isString(value);
}

array_contains(array_x, value_x) {
	if(array_x.size <= 0) {
		return false;
	}

	foreach(key_x in array_x) {
		if(key_x == value_x) {
			return true;
		}
	}

	return false;
}

load_weapons(weapon_category) {
	for(i = 0; i < self.syn["weapons"][weapon_category][0].size; i++) {
		self add_option(self.syn["weapons"][weapon_category][1][i], undefined, ::give_weapon, self.syn["weapons"][weapon_category][0][i]);
	}
}

// Menu Options

modify_menu_position(offset, axis) {
	if(axis == "x") {
		self.x_offset = 175 + offset;
	} else {
		self.y_offset = 160 + offset;
	}
	self close_menu();
	self open_menu();
}

set_menu_rainbow() {
	if(!isString(self.color_theme)) {
		self.color_theme = "rainbow";
		self close_menu();
		self open_menu();
		self.menu["title"].x = 264.2;
	}
}

set_menu_color(value, color) {
	if(color == "Red") {
		self.menu_color_red = value;
		iPrintString(color + " Changed to " + value);
	} else if(color == "Green") {
		self.menu_color_green = value;
		iPrintString(color + " Changed to " + value);
	} else if(color == "Blue") {
		self.menu_color_blue = value;
		iPrintString(color + " Changed to " + value);
	} else {
		iPrintString(value + " | " + color);
	}
	self.color_theme = (self.menu_color_red / 255, self.menu_color_green / 255, self.menu_color_blue / 255);
	self close_menu();
	self open_menu();
	self.menu["title"].x = 264.2;
}

watermark() {
	self.watermark = !return_toggle(self.watermark);
	if(self.watermark) {
		iPrintString("Watermark [^2ON^7]");
		if(!isDefined(self.syn["watermark"])) {
			self.syn["watermark"] = self create_text("SyndiShanX", self.font, 2, "TOP_LEFT", "TOPCENTER", -425, -25, self.color_theme, 1, 3);
		} else {
			self.syn["watermark"].alpha = 1;
			self.syn["watermark"].color = self.color_theme;
		}
	} else {
		iPrintString("Watermark [^1OFF^7]");
		self.syn["watermark"].alpha = 0;
	}
}

hide_ui() {
	self.hide_ui = !return_toggle(self.hide_ui);
	setDvar("\cg_draw2D", !self.hide_ui);
}

hide_weapon() {
	self.hide_weapon = !return_toggle(self.hide_weapon);
	setDvar("\cg_drawGun", !self.hide_weapon);
}

// Basic Options

god_mode() {
	self.god_mode = !return_toggle(self.god_mode);
	if(self.god_mode) {
		iPrintString("God Mode [^2ON^7]");
	} else {
		iPrintString("God Mode [^1OFF^7]");
	}
}

frag_no_clip() {
	self endon("disconnect");

	self endon("game_ended");

	if(!isDefined(self.frag_no_clip)) {
		self.frag_no_clip = true;
		iPrintString("Frag No Clip [^2ON^7], Press ^3[{+frag}]^7 to Enter and ^3[{+melee}]^7 to Exit");
		while (isDefined(self.frag_no_clip)) {
			if(self fragButtonPressed()) {
				if(!isDefined(self.frag_no_clip_loop)) {
					self thread frag_no_clip_loop();
				}
			}
			wait .05;
		}
	} else {
		self.frag_no_clip = undefined;
		iPrintString("Frag No Clip [^1OFF^7]");
	}
}

frag_no_clip_loop() {
	self endon("disconnect");

	self endon("noclip_end");
	self disableWeapons();
	self disableOffHandWeapons();
	self.frag_no_clip_loop = true;

	clip = spawn("script_origin", self.origin);
	self playerLinkTo(clip);
	if(!isDefined(self.god_mode) || !self.god_mode) {
		god_mode();
		self.temp_god_mode = true;
	}

	while (true) {
		vec = anglesToForward(self getPlayerAngles());
		end = (vec[0] * 60, vec[1] * 60, vec[2] * 60);
		if(self attackButtonPressed()) {
			clip.origin = clip.origin + end;
		}
		if(self adsButtonPressed()) {
			clip.origin = clip.origin - end;
		}
		if(self meleeButtonPressed()) {
			break;
		}
		wait .05;
	}

	clip delete();
	self enableWeapons();
	self enableOffhandWeapons();

	if(isDefined(self.temp_god_mode)) {
		god_mode();
		self.temp_god_mode = undefined;
	}

	self.frag_no_clip_loop = undefined;
}

infinite_ammo() {
	self.infinite_ammo = !return_toggle(self.infinite_ammo);
	if(self.infinite_ammo) {
		iPrintString("Infinite Ammo [^2ON^7]");
		self thread infinite_ammo_loop();
	} else {
		iPrintString("Infinite Ammo [^1OFF^7]");
		self notify("stop_infinite_ammo");
	}
}

infinite_ammo_loop() {
	self endon("stop_infinite_ammo");
	self endon("game_ended");

	for(;;) {
		self setWeaponAmmoClip(self getCurrentWeapon(), 999);

		self setWeaponAmmoStock(self getCurrentWeapon(), 999);

		wait 0.5;
	}
}

// Fun Options

forge_mode() {
	self.forge_mode = !return_toggle(self.forge_mode);
	if(self.forge_mode) {
		iPrintString("Forge Mode [^2ON^7], Press ^3[{+speed_throw}]^7 to Pick Up/Drop Objects");
		self thread forge_mode_loop();
	} else {
		iPrintString("Forge Mode [^1OFF^7]");
		self notify("stop_forge_mode");
	}
}

forge_mode_loop() {
	self endon("disconnect");

	self endon("stop_forge_mode");

	while (true) {
		trace = bullettrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 1, self);
		if(isDefined(trace["entity"])) {
			if(self adsButtonPressed()) {
				while (self adsButtonPressed()) {
					trace["entity"] moveTo(self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 200, .5);
					trace["entity"].origin = self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 200;
					wait .01;
				}
			}
			if(self attackButtonPressed()) {
				while (self attackButtonPressed()) {
					trace["entity"] rotatePitch(1, .01);
					wait .01;
				}
			}
			if(self fragButtonPressed()) {
				while (self fragButtonPressed()) {
					trace["entity"] rotateYaw(1, .01);
					wait .01;
				}
			}
			if(self secondaryOffhandButtonPressed()) {
				while (self secondaryOffhandButtonPressed()) {
					trace["entity"] rotateRoll(1, .01);
					wait .01;
				}
			}
			if(!isPlayer(trace["entity"]) && self meleeButtonPressed()) {
				trace["entity"] delete();
				wait .2;
			}
		}
		wait .05;
	}
}

set_speed(value) {
	setDvar("g_speed", value);
}

set_timescale(value) {
	setDvar("timescale", value);
}

set_gravity(value) {
	setDvar("g_gravity", value);
}

fullbright() {
	self.fullbright = !return_toggle(self.fullbright);
	if(self.fullbright) {
		iPrintString("Fullbright [^2ON^7]");
		setDvar("r_fullbright", 1);
		wait .01;
	} else {
		iPrintString("Fullbright [^1OFF^7]");
		setDvar("r_fullbright", 0);
		wait .01;
	}
}

third_person() {
	self.third_person = !return_toggle(self.third_person);
	if(self.third_person) {
		iPrintString("Third Person [^2ON^7]");
		setDvar("camera_thirdPerson", 1);
	} else {
		iPrintString("Third Person [^1OFF^7]");
		setDvar("camera_thirdPerson", 0);
	}
}

set_vision(vision) {
	self visionSetNakedForPlayer("", 0.1);
	wait .25;
	self visionSetNakedForPlayer(vision, 0.1);
}

commit_suicide(target) {
	target suicide();
}

kick_player(target) {
	kick(target getEntityNumber());
}

// Killstreaks

give_killstreak(streak, value) {
	self maps\mp\killstreaks\_killstreaks::tryGiveKillstreak(streak, int(value));
}

// Perks

give_all_perks() {
	foreach(perk in self.syn["perks"][0]) {
		give_perk(perk);
	}
}

take_all_perks() {
	foreach(perk in self.syn["perks"][0]) {
		take_perk(perk);
	}
}

give_perk(perk) {
	self _setPerk(perk);
}

take_perk(perk) {
	if(_hasPerk(perk)) {
		_unsetPerk(perk);
	}
}

// Weapon Options

get_category(weapon) {
	foreach(weapon_category in self.syn["weapons"]["category"][0]) {
		foreach(weapon_id in self.syn["weapons"][weapon_category][0]) {
			if(weapon_id == weapon) {
				return weapon_category;
			}
		}
	}
}

check_weapons(weapon) {
	if(isDefined(self getWeaponsListPrimaries()[1])) {
		extra_weapon_check = self getWeaponsListPrimaries()[1] != weapon;
	} else {
		extra_weapon_check = true;
	}
	return self getCurrentWeapon() != weapon && extra_weapon_check;
}

give_weapon(weapon, category, index) {
	if(check_weapons(weapon)) {
		max_weapon_num = 2;
		if(self getWeaponsListPrimaries().size >= max_weapon_num) {
			self take_weapon();
		}

		weapon = weapon + "_mp";

		self giveWeapon(weapon);
		self switchToWeapon(weapon);
	} else {
		self switchToWeaponImmediate(weapon);
	}
	wait 1;
	self setWeaponAmmoClip(self getCurrentWeapon(), 999);
}

equip_attachment(attachment) {
	weapon = getBaseWeaponName(self getCurrentWeapon());
	weapon_split = strtok(self getCurrentWeapon(), "_");
	weapon_attachment_1 = undefined;
	weapon_attachment_2 = undefined;

	if(weapon_split.size > 1) {
		for(i = 2; i < weapon_split.size; i++) {
			if(isDefined(weapon_split[i]) && weapon_split[i] != "mp") {
				if(array_contains(self.syn["attachments"][0], weapon_split[i])) {
					if(!isDefined(weapon_attachment_1)) {
						weapon_attachment_1 = weapon_split[i];
					} else if(!isDefined(weapon_attachment_2)) {
						weapon_attachment_2 = weapon_split[i];
					}
				}
			}
		}
	}

	if(!isDefined(weapon_attachment_1)) {
		weapon_attachment_1 = attachment;
	} else if(!isDefined(weapon_attachment_2)) {
		weapon_attachment_2 = attachment;
	}

	if(!isDefined(weapon_attachment_1)) {
		weapon_attachment_1 = "none";
	}
	if(!isDefined(weapon_attachment_2)) {
		weapon_attachment_2 = "none";
	}

	weapon_attached = maps\mp\gametypes\_class::buildWeaponName(weapon, weapon_attachment_1, weapon_attachment_2);
	if(check_weapons(weapon_attached)) {
		self take_weapon();
		self _giveWeapon(weapon_attached);
		self switchToWeapon(weapon_attached);
	} else {
		self switchToWeapon(weapon);
	}
}

equip_camo(camo_index) {
	weapon = self getCurrentWeapon();
	self take_weapon();

  wait(0.05);

	self _giveWeapon(weapon, int(camo_index));
  self switchToWeapon(weapon);
}

cycle_camos() {
	self.cycle_camos = !return_toggle(self.cycle_camos);
	if(self.cycle_camos) {
		self iPrintString("Cycle Camos [^2ON^7]");
		self thread cycle_camos_loop();
	} else {
		self iPrintString("Cycle Camos [^1OFF^7]");
		self notify("stop_cycle_camos");
	}
}

cycle_camos_loop() {
	self endon("stop_cycle_camos");
	self endon("game_ended");

	for(;;) {
		for(i = 1; i <= 8; i++) {
			equip_camo(i);
			wait 2;
		}
	}
}

take_weapon() {
	if(isDefined(self getCurrentWeapon())) {
		self takeweapon(self getCurrentWeapon());
		self switchToWeapon(self getWeaponsListPrimaries()[0]);
	}
}

drop_weapon() {
	if(isDefined(self getCurrentWeapon())) {
		self dropItem(self getCurrentWeapon());
		self switchToWeapon(self getWeaponsListPrimaries()[0]);
	}
}

get_weapon_attachments(weapon) {
	attachments = [];

	for(i = 11;; i++) {
		column = tableLookup("mp/statsTable.csv", 4, weapon, i);

		if(!isDefined(column) || column == "") {
			break;
		}

		attachments[attachments.size] = column;
	}

	return alphabetize(attachments);
}

get_attachment_name(attachment) {
	for(i = 0; i < self.syn["attachments"][0].size; i++) {
		if(attachment == self.syn["attachments"][0][i]) {
			return self.syn["attachments"][1][i];
		}
	}
}
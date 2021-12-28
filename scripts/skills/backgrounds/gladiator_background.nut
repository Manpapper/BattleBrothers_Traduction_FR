this.gladiator_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gladiator";
		this.m.Name = "Gladiator";
		this.m.Icon = "ui/backgrounds/background_61.png";
		this.m.BackgroundDescription = "Gladiators are expensive, but a life in the arena has forged them into skilled fighters.";
		this.m.GoodEnding = "You thought that %name% the gladiator would return to the arenas as you thought he might. However, news from the south speaks of an uprising of indebted and gladiators alike. Unlike previous revolts, this one has viziers swinging from rooftops and slavers being lynched in the streets. The general upheaval is apparently about to sit the once-ringfighter as a legitimate powerbroker in the region.";
		this.m.BadEnding = "The call of the crowd was too loud for the gladiator %name%. After your quick retirement from the unsuccessful %companyname%, the fighter returned to the southern kingdoms\' fighting arenas. Unfortunately, the wear and tear of his time with mercenaries slowed him a step and he was mortally slain by a half-starved slave wielding a pitchfork and a net.";
		this.m.HiringCost = 200;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.weasel",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Bodies = this.Const.Bodies.Gladiator;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 60;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.Level = this.Math.rand(2, 4);
		this.m.IsCombatBackground = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onBuildDescription()
	{
		return "{The South is littered with slaves of all sorts, called the indebted for their debt to the Gilder. While most find themselves in the fields, a select few are taken to the fighting pits to battle it out. | While northerners do partake in combat tournaments, nothing gets close to the violence and gore of a southern gladiatorial pit. | In the South, rich and poor alike enjoy cheering on the gladiators of the fighting pits. | Southern gladiatorial pits are filled with indebted and voluntary killers alike. | A bloody house of combat and betting, a gladiatorial pit is the one place in the South one may find rich and poor crowded together.} {It was from these ranks %name% came. He rapidly grew through the ranks and managed to buy his way out of the pits and into whatever \'freedom\' one could find after such a life. | A crowd-favorite, %name%\'s time as a gladiator ended after a \'pardon\' by his wealthy sponsors. But in early retirement he found his life unfulfilled. | Successful killers such as %name% can buy their way to freedom, though the bloodlust has yet to leave the man. | %name% was involved in a \'diving\' incident and received a year long ban from the pits. | But gladiators like %name% are not just popular with the public, but particularly with the womenfolk. A raunchy tryst with a nobleman\'s wife led to the fighter being spirited away under the cover of night lest he be castrated. | A pit\'s most popular fighter is usually a blend of murderous handsomeness, and a man such as %name% was only the former. Dispirited by the lack of fame he thought he had earned, he purchased his freedom and departed the blood sport.} {Gladiators usually cross from fighting pit to fighting pit, so a sturdy, well skilled fighter such as %name% is rare to find in the wild. Yet here he stands, albeit with enough scars to make a flagellant blush. | You\'ve met many a warrior, but rarely one with the particular skillsets of a pit fighter such as %name%. All the clashing in the arenas has made him a clever warrior indeed, and also one with many a scar and injury to match his time there. | There\'s many pairings in this world, and a gladiator with an untouched body is not one of them. %name% is a skilled fighter, but he earned those experiences with his own blood and body. | An impressive gladiatorial resume such as the one %name% brings hints at a man well versed in killing. The many scars, however, flatly state that his time in the pits came with an irreversible price of their own. | Gladiators such as %name% could be the most skilled fighters in all the land, but the fighting pits are full of games and are designed to bring harm to all who partake. The man is a talented warrior, but he wears the scars and wounds of a career in the arena.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 30)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				8,
				6
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				5,
				8
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(1, 2) == 2)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.GladiatorTitles[this.Math.rand(0, this.Const.Strings.GladiatorTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/shamshir",
				"weapons/shamshir",
				"weapons/oriental/two_handed_scimitar",
				"weapons/oriental/heavy_southern_mace",
				"weapons/oriental/heavy_southern_mace",
				"weapons/oriental/swordlance",
				"weapons/oriental/polemace",
				"weapons/fighting_axe",
				"weapons/fighting_spear"
			];

			if (this.Const.DLC.Wildmen)
			{
				weapons.extend([
					"weapons/two_handed_flail",
					"weapons/two_handed_flanged_mace",
					"weapons/bardiche"
				]);
			}

			items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (items.hasEmptySlot(this.Const.ItemSlot.Offhand))
		{
			local offhand = [
				"tools/throwing_net",
				"shields/oriental/metal_round_shield"
			];
			items.equip(this.new("scripts/items/" + offhand[this.Math.rand(0, offhand.len() - 1)]));
		}

		local a = this.new("scripts/items/armor/oriental/gladiator_harness");
		local u;
		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			u = this.new("scripts/items/armor_upgrades/light_gladiator_upgrade");
		}
		else if (r == 2)
		{
			u = this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade");
		}

		a.setUpgrade(u);
		items.equip(a);
		r = this.Math.rand(2, 3);

		if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/gladiator_helmet"));
		}
	}

});


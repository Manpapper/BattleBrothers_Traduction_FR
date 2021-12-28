this.squire_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.squire";
		this.m.Name = "Squire";
		this.m.Icon = "ui/backgrounds/background_03.png";
		this.m.BackgroundDescription = "Squires usually have received some training in warfare, and often have a high resolve to excel in what they do.";
		this.m.GoodEnding = "%name% the squire eventually left the %companyname%. You\'ve heard that he\'s since been knighted. No doubt he is sitting happy as a plum wherever he is.";
		this.m.BadEnding = "The squire, %name%, eventually departed the %companyname%. He intended to return home and become knighted, fulfilling his lifelong dream. Cruel politics got in the way and not only was he not knighted, he was stripped of his squire duties. Word has it he hanged himself from a barn\'s rafters.";
		this.m.HiringCost = 160;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.clubfooted",
			"trait.irrational",
			"trait.disloyal",
			"trait.fat",
			"trait.fainthearted",
			"trait.craven",
			"trait.dastard",
			"trait.fragile",
			"trait.insecure",
			"trait.asthmatic",
			"trait.clumsy",
			"trait.pessimist",
			"trait.greedy",
			"trait.bleeder"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.YoungMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "{A young squire, %name% dutifully accompanied his knight to many battles. | Squire to a harsh knight, %name% spent his days running errands for his lordship. | Although a squire, %name%\'s life largely meant guarding prisoners of war, much to his chagrin. | Squire to a knight, sure, but %name% mostly cleaned latrines, fed dogs, and got far too much use out of a shinebox.} {One night, strange, shuffling men silhouetted the moonlit horizon. Alarm bells met their moans and an hour later half of %townname% lay in ruin. | While traveling, brigands attacked his lordship\'s wagon-train. Swords were drawn, heads were halved, and when it was all said and done the squire had failed: everyone he was supposed to protect lay dead. | But one evening a horde of ferocious, furred creatures came down upon his lord\'s keep. In desperation, %name% let a group of prisoners free, hoping they would aid him in combat. Instead, they slew his lordship and ran off into the night. The squire, bravely, managed to survive, a dozen husky corpses at his feet, but the battle left him alone and without purpose. | Angered by a horrible crime in %townname%, he took matters into his own hands, personally slaying the criminal. A just act, but also an improper one. The young squire was banished for his insubordination. | When a devilish red knight came to %townname% for a duel, %name%\'s knight proved far too sick to fight. After downing a mug of liquid confidence, %name% donned his lordship\'s armor and faced the red knight himself. With a sword slash so fast it rang the very air, %name% slew his opponent down.} {Now there was only one task left for him - to attain knighthood. | Now the squire seeks the company of good men with which to again prove himself worthy of being a knight. | As war ravages the land, there is now plenty of opportunity to put his skills to use. | Though a bit too earnest, there is no doubt the world needs men like %name%.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				12,
				12
			],
			Stamina = [
				7,
				5
			],
			MeleeSkill = [
				7,
				5
			],
			RangedSkill = [
				7,
				8
			],
			MeleeDefense = [
				1,
				3
			],
			RangedDefense = [
				1,
				3
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

});


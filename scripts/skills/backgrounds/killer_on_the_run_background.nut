this.killer_on_the_run_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.killer_on_the_run";
		this.m.Name = "Killer on the Run";
		this.m.Icon = "ui/backgrounds/background_02.png";
		this.m.BackgroundDescription = "A killer on the run may kill again, and he knows where to aim.";
		this.m.GoodEnding = "Always a risk taker, you accepted %name% into the %companyname%\'s ranks despite him being a killer on the run. It worked in your favor as he proved himself an able and brave sellsword. As far as you know, he is still with the company, thoroughly enjoying every \'business\' opportunity it affords him.";
		this.m.BadEnding = "While many doubted the risk of hiring a killer on the run such as %name%, the man did prove himself a very capable sellsword. Unfortunately, an old life never trails far behind and bounty hunters kidnapped him in the night. You can find his skeleton squatting in a gibbet fifty feet in the air.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.hate_undead",
			"trait.lucky",
			"trait.clubfooted",
			"trait.cocky",
			"trait.clumsy",
			"trait.loyal",
			"trait.hesitant",
			"trait.bright",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.fainthearted",
			"trait.craven",
			"trait.fearless",
			"trait.optimist"
		];
		this.m.Titles = [
			"Darkhearted",
			"Backblade",
			"Throatslash",
			"on the Run",
			"the Wanted",
			"the Murderer"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "Higher Chance To Hit Head"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%fullname% has a face that no one desires - one fit for a wanted poster. | With blood on his hands, %name% resembles a man recently described to you by bounty hunters. | %name% looks about ready to join any outfit - or disappear into its ranks. | Upon meeting people, %name% stammers out his name as if reluctant to part with it.} {Recognizing %name% is no hard feat: this man is a known-murderer, the blood of both his cuckolding wife and her lover on his hands. | His eyes are dark and shifting. There is a crime behind them, but also a sense of humanity, as if he knows he has done wrong and is looking to make amends. | Mud stands up to his legs. He\'s been running for a long time. His hands tremble, too, for his legs run from what his hands have done. | They say he killed his newborn daughter, having always wanted a son instead. | Some believe he struck down a man in self-defense. | Being blackmailed with scandalous information, it\'s hard to blame the man for what he has done.} {Even if he has done wrong, a party of killers could use a man such as he. But can the man be trusted? | %name%\'s eyes skirt from yours. When you ask how he is with a weapon, he mumbles about only having to hit \'the man\' once. | A man of %name%\'s physique could be useful, but how much can you depend upon a man whose former life was one of being on the run? | The man chamfers on his fingernails like a beaver would a tree. He\'s jumpy, but maybe that\'s a good thing in this world. | Mercenary bands are just the thing for a man like him.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				4,
				0
			],
			RangedSkill = [
				2,
				3
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.HitChance[this.Const.BodyPart.Head] += 10;
	}

});


this.juggler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.juggler";
		this.m.Name = "Juggler";
		this.m.Icon = "ui/backgrounds/background_14.png";
		this.m.BackgroundDescription = "Jugglers need to have good reflexes and hand-eye-coordination for their profession.";
		this.m.GoodEnding = "%name% the juggler took all his mercenary money and started a traveling troupe of performers. Last you heard, he started an entire theater and puts on a new play a month!";
		this.m.BadEnding = "%name% the juggler retired from fighting. He was performing for a gaudy nobleman in the {south | north | east | west} when an act went horribly wrong. Word has it he was thrown off a tower for his mistake, but you prefer to not believe that.";
		this.m.HiringCost = 75;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.clubfooted",
			"trait.brute",
			"trait.clumsy",
			"trait.tough",
			"trait.strong",
			"trait.short_sighted",
			"trait.dumb",
			"trait.hesitant",
			"trait.deathwish",
			"trait.insecure",
			"trait.asthmatic",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Juggler",
			"the Jester",
			"the Fool"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
				id = 15,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "Higher Chance To Hit Head"
			}
		];
	}

	function onBuildDescription()
	{
		return "{Taught by his step-brother, %name% took up juggling like a sailor to his oars. | Although sneered at by his peers, %name% always loved juggling. | Visited by a troupe of jesters, %name% was most enamored - and eventually taught - by one particularly interesting man: a juggler. | Son to a local lord, %name%\'s embarrassing obsession with juggling and entertaining had him exiled from the family line. | %name% didn\'t juggle just for the sake of it, but to earn the laughter and applause of an audience.} {Unfortunately, there\'s not many folks to entertain when war is ravaging the land. | But crowds and crowns are sparse in a land of misery and suffering. | But a juggling accident involving adzes and a royal infant had the entertainer running for his life. | So good at flipping swords and daggers, it wasn\'t long until he was accused of sorcery and driven from his passion. | Sadly, %name%\'s skill in juggling led to much jealousy amongst his fellow jesters. They conspired against him - and his poor wrists. | When an assassin killed the lord he was entertaining, the juggler was the first to be accused. He barely escaped with his life.} {Now, %name% seeks a new path, even if death itself has become his audience. | Now, %name% finds respite in the company of equally down-on-their-luck men. | With fast hands and quick reactions, %name% should have no problem hitting his targets. | Juggling knives with his eyes closed, %name% knows exactly where to throw each blade. | There is far more coin in killing than juggling, a sad reality %name% has come to accept.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				3,
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
				12,
				10
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/jesters_hat"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.HitChance[this.Const.BodyPart.Head] += 5;
	}

});


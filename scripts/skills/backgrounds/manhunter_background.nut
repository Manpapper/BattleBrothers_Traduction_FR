this.manhunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.manhunter";
		this.m.Name = "Manhunter";
		this.m.Icon = "ui/backgrounds/background_62.png";
		this.m.BackgroundDescription = "Manhunters are used to hunting down people in the rough environment of the south.";
		this.m.GoodEnding = "%name% the manhunter stuck with the %companyname% for a long while after you left it. You haven\'t gotten much word of the man other than he\'s found far more income in the world of sellswords than that of hunting down the indebted.";
		this.m.BadEnding = "Upset with how his time in the company of the %companyname% has gone, %name% the manhunter deserted and returned south. It\'s hard to say what became of him, but the business of tracking and hunting human prey carries endless dangers. The only news you have of him is ancillary to his vocation: that of numerous indebted uprisings with many manhunters being buried alive or fed to a variety of desert-borne creatures.";
		this.m.HiringCost = 120;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.bleeder",
			"trait.bright",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.iron_lungs",
			"trait.tiny",
			"trait.optimist",
			"trait.dastard",
			"trait.asthmatic",
			"trait.craven",
			"trait.insecure",
			"trait.short_sighted"
		];
		this.m.Titles = [
			"the Manhunter",
			"the Mancatcher",
			"the Hunter",
			"the Ruthless",
			"the Bounty Hunter",
			"the Brutal",
			"the Cruel",
			"the Unforgiving",
			"the Merciless",
			"the Tracker",
			"the Catcher",
			"the Heartless",
			"the Swine",
			"the Slaver"
		];
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.IsLowborn = true;
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
		return "{The large population of slaves, prisoners, criminals, and indebted servants in the south has produced an economy of sellers, buyers, and, given the flighty nature of the product, hunters. | Southern city states must have enormous reserves of labor to fuel their desert-borne economies. While many are born into working tirelessly for Viziers, some must be coerced into a life of servitude. | The deserts so sparse in natural resources, it is often an ample supply of captured criminals and indebted souls which bolsters the southern economy. And the business of hunting down these eventual servants is a prosperous one. | Southern Viziers are so fearful of rebellions that an entire market of Manhunters has emerged to nip them in the bud.} {%name% entered manhunting with a vengeful attitude: his entire family was massacred in a slave uprising. | %name% was once an ordinary caravan guard but turned to manhunting nomads who kept trying to ambush his convoys. Finding more profit in the human trade, he\'s stuck with it ever since. | %name% is a manhunter with a good nose for tracking criminals, deserters, prisoners of war, and more. You sometimes wonder if he\'s got a keen sense of smell for fearful sweat. | Once a big game hunter, %name% grew fond of chasing the greatest game of all: man. He is an expert tracker with a nose for sniffing out desperation.} {For %name%, the opportunity of working for a mercenary band simply brings in more consistent work than waiting around for some pressed criminal to get antsy about his chains. | %name% is a rugged, shady individual and it is quite possible that he is just as flighty as the men he sought to hunt down. | Hunters like %name% carry traits and skills that would be useful in a mercenary band, but to some their past may be an ever present slight. Not all manhunters are seen in good light. | Capturing humans for the purpose of labor is frowned upon by many and catching those seeking their freedom equally so. Manhunters like %name% certainly have useful skills, but may rub some the wrong way. | To no surprise, many see men like %name% as opportunistic slugs. If he can make it with the company, it may take time to change the minds of some about his past.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				2,
				3
			],
			Bravery = [
				7,
				5
			],
			Stamina = [
				3,
				5
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				2,
				2
			],
			RangedDefense = [
				-1,
				-1
			],
			Initiative = [
				3,
				5
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
			items.equip(this.new("scripts/items/weapons/battle_whip"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/oriental/saif"));
		}

		items.equip(this.new("scripts/items/tools/throwing_net"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});


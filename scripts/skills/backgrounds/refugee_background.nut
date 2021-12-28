this.refugee_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.refugee";
		this.m.Name = "Refugee";
		this.m.Icon = "ui/backgrounds/background_38.png";
		this.m.BackgroundDescription = "Refugees lack the conviction to fight for their homes, but they are used to long and exhausting travel by now.";
		this.m.GoodEnding = "%name% the refugee showed himself to be a natural fighter, but he eventually retired from the %companyname%. Word has it he returned to his home and is currently using all his crowns to help rebuild it.";
		this.m.BadEnding = "With the downfall of the %companyname% written plainly on the wall, %name% the refugee split with the company. He used what scant crowns he had left to purchase a set of shoes and returned to his destroyed home to try and rebuild it. While walking home, an illiterate wildman murdered him and ate the shoes.";
		this.m.HiringCost = 40;
		this.m.DailyCost = 4;
		this.m.Excluded = [
			"trait.impatient",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.tough",
			"trait.strong",
			"trait.loyal",
			"trait.cocky",
			"trait.fat",
			"trait.bright",
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.greedy",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Refugee",
			"the Survivor",
			"Runsfar",
			"the Derelict",
			"the Surbated"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
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
		return "{Catastrophes are cheap. | Disease, the ultimate invisible hand. | Win or lose a war, everything is as it has been.} %name% hails from a tiny village that {is now only remembered by spoken word, a generation away from being forgotten. | was destroyed, to put it succinctly. | now stands as a mere footnote, wasting little of the historian\'s ink. | suffered the world\'s wrath.} But %name% is a survivor. {He fled the disaster with just the clothes on his back. | His home ablaze, he saved what he could and fled. | After stumbling upon his dead family, he gathered what he could and ran. | War, famine, disease. It\'s all a blur to him now.} {%name% is merely a man anxious to look ahead rather than behind. | %name% carries little more than a sense of steeled determination, but that is something worth having. | A horrific history scars his body and glazes his eyes, but the man is easily motivated to never experience that past again. | Whatever befell the man\'s town didn\'t get him and, judging by the rumors you hear, that\'s saying something. | The man isn\'t skilled in martial arts, but he is for damn sure determined to survive. | Whatever vocation he had in the past is now lost. Like many others, he seeks mercenary work to get by in this increasingly bloody world. | One of many refugees you\'ve seen, this man has decided to stop running and start fighting.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-8,
				-5
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				7,
				5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				1,
				0
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
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
	}

});


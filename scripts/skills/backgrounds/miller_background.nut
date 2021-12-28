this.miller_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.miller";
		this.m.Name = "Miller";
		this.m.Icon = "ui/backgrounds/background_05.png";
		this.m.BackgroundDescription = "A miller is used to physical labor.";
		this.m.GoodEnding = "%name% the once-miller stayed with the %companyname% for a time, collecting enough crowns to start his own bakery. Last you heard, his sword-shaped desserts have been a hit with the nobility and he makes more money selling to them than he ever did with the company.";
		this.m.BadEnding = "As the %companyname% fell on hard times, %name% the miller saw fit to go ahead and leave while he could still walk. He helped a nobleman test out a new way of grinding grains with mules and waterwheels working in tandem. Unfortunately, by \'helping\' he managed to fall into the contraption and was brutally crushed to death.";
		this.m.HiringCost = 65;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.bright",
			"trait.cocky",
			"trait.quick",
			"trait.fragile",
			"trait.greedy",
			"trait.sure_footing",
			"trait.deathwish",
			"trait.dexterous",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Miller"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{The life as a miller had always been lacking something for %name%, yet the hard work kept him from making any big plans. | Continuing the family tradition, %name% learned the millers trade from his father. | Although just a simple miller, %name% always dreamed about wandering out into the world and bring home tales and pockets full of crowns. | Being a simple fellow, %name% did not mind working hard in the mill every day. | %name% always was more ambitious than other people. While his brother was content with running their family\'s mill, he could not shake the feeling that he was destined for more.} {One night he was awoken by a loud thunderstorm. Rushing outside, %name% realised that his mill had been ignited by a lightning strike. | When he caught his promised wife in bed with another man, he was furious, battering both of them with a hail of blows. His fists were bruised, people were shouting at him, but the only thing he felt was emptyness where once was his heart. As if in a dream he quickly packed his belongings and set out, never to return. | When his young and lovely wife was found dead, torn apart by wild beasts in the woods, he did not say a word. Silently he packed his belongings and set out into the world, to start a new life somewhere far away. | After hearing wild tales from a hedge knight in the tavern of %townname%, his imagination was running wild with all the possibilities out there in the world waiting for him. | A drought meant business was running slow for him. When %name% was not able to pay his debts any more his life was threatened by ruthless money collectors. He had to disappear.} {Remembering his cousin, %randomname%, who has made a decent living in the mercenary business, %name% decided to do the same. | While looking for opportunities he met a mercenary recruiter who promised him fame and fortune. | Although he does not know the next thing about fighting, %name% is eager to sign up with a mercenary company hooked by the promise of adventure. | Whether by lack of alternatives or by his free will, %name% stands before you now, ready to swear fealty.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				3,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				8,
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
				0,
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

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}
	}

});


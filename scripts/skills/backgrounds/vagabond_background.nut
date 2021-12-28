this.vagabond_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.vagabond";
		this.m.Name = "Vagabond";
		this.m.Icon = "ui/backgrounds/background_32.png";
		this.m.BackgroundDescription = "Vagabonds are used to long travels, but don\'t excel in anything in particular.";
		this.m.GoodEnding = "Some men were just intended to wander. While his time with the %companyname% went well, %name% the vagabond eventually departed with the company and set off on the roads once more. You\'ve no idea where he\'s gone, you just know all he\'s interested in is going.";
		this.m.BadEnding = "As the company fell apart, it\'s little surprise that a vagabond like %name% chose to leave it behind and return to the roads. Unfortunately, with the world in such a dire state, it did not take long for him to find trouble. His body was found hanging outside a small farming village. A sign nailed to his chest read: \'No Free Rangers\'.";
		this.m.HiringCost = 70;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.clubfooted",
			"trait.fat",
			"trait.loyal",
			"trait.gluttonous",
			"trait.asthmatic"
		];
		this.m.Titles = [
			"the Vagabond",
			"the Wanderer",
			"Threefeet",
			"Bindlestiff",
			"Tatterdemalion",
			"the Homeless",
			"the Restless",
			"the Traveller",
			"the Raven"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
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
		return "{Pushed out of his town by war, %name% wanders the world as a vagabond. | Lazy and unmotivated, %name% one day put all three of his belongings into a knapsack and hit the road. | Never a strong learner in school, %name% dropped out to wander the earth. | %name% did not have the business acumen to protect his inheritance from debtors, lawmen, and other maleficent men. Now he wanders with the last of his crowns jangling in a pocket. | Life on the road has taught %name% to be a jack of all trades, and a master of none - except walking, of course. | Not quite one for the city, and not quite one for the wild, %name% spends his purposeless days traveling between both. | During his drinking days, %name% managed to gamble away a small fortune. Now homeless, he simply wanders. | When his wife was murdered while he was away, %name% refused to sleep in the house. The man walks the earth, trying to forget the memory. | His son murdered five others. In shame, %name% abandoned his hometown to walk the earth and forget his failures as a father.} {But when a gang of thieves took all he had - including his shoes - he knew he needed yet another change. | But when he came to a literal fork in the road, the man realized he hadn\'t eaten in some time. His stomach demanded a change in scenery - and diet. | Sadly, the world is not a pleasant place for those who nobody would miss. He was harassed and bullied every day. | After one particularly harsh day trudging through mud, he realized there was no life to be had in walking around. | Strangely, one day he came across his long-forgotten brother he-never-had who said there was plenty of walking to be done for a mercenary outfit - and they\'d pay him to do it, too! | Like any good, impulsive man, he flipped a coin on whether or not to try his hand at mercenary work.} {He\'s not particularly good at anything, but %name% has seen and done a lot, and that\'s worth at least something. | Mucking about this violent land and surviving with all his limbs is a lot more than some folks can say. | A mercenary band would be but another adventure for a vagabond like %name%. One hopes he survives to write about it. | Through his travels his only weapon was a walking stick. Let\'s see how he does with something a smidge sharper. | A thief, a scoundrel, a baker, a tailor, %name%\'s done it all. Too bad he was never good at any of those things. Maybe it\'ll be different this time. | The world has been harsh to %name% for many years now. That isn\'t going to change, but at least he will be with brothers now.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-3,
				0
			],
			Bravery = [
				-5,
				-7
			],
			Stamina = [
				10,
				15
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
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});


this.peddler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.peddler";
		this.m.Name = "Peddler";
		this.m.Icon = "ui/backgrounds/background_19.png";
		this.m.BackgroundDescription = "Peddlers are not used to hard physical labor or warfare, but they do excel at haggling for good prices.";
		this.m.GoodEnding = "A man of the sale, %name% the peddler couldn\'t stay fighting for long. He eventually left the %companyname% to go out and start his own business. Recently, you got word that he was selling trinkets with the company\'s sigil on them. You specifically told him he can do whatever he wants except just this one thing, but apparently your warning merely fostered the idea in him. When you went to tell him to stop, he slammed a crown-bulging satchel on his rather ornate table, saying it was your \'cut.\' He sells those trinkets to this day.";
		this.m.BadEnding = "With hard times hitting the %companyname%, many brothers saw fit to return to their old lives. %name% the peddler was no different. Last you heard he got the tar beaten out of him trying to sell stolen wares that \'fell off the wagon\' to the very merchant which they originally belonged.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.iron_jaw",
			"trait.clubfooted",
			"trait.brute",
			"trait.athletic",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dexterous",
			"trait.dumb",
			"trait.deathwish",
			"trait.bloodthirsty"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Thick;
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
		return "{House to house, | Once a proud merchant, now | An annoyance to most, | In tough times, everyone has to scrape by somehow, hence why | Not a man of the trades, but instead of trade itself,} %name% is a mere peddler. {He\'ll dance, he\'ll sing, he\'ll boast and he\'ll act a king, anything to make that sale. | Pushy and unrelenting, his tenacity is admirable. | He\'ll try to sell off a rusty bucket for a helm once worn by kings. This man will sell anything. | This man will make you crave things you never knew you wanted. No refunds, though. | He used to make a decent living selling {used carts | pots, pans and jars}, until fierce competition drove him out of business - by breaking his arm.} {Marketing himself is what this frail man does best, though few believe his pitch about having \'Great swordsmanship and resolute bravery\'. | He supposedly handed out \'coupons\' for his services, whatever those are. He\'s chippy, though, and any outfit these days could use a warm body no matter its real value. | If hired, he promises, you\'ll get a special discount on a virility enhancing potion. | The man lowers his voice and tells you he\'s got a great deal on rusted arrow tips, just for you. He looks disappointed at your lack of interest. | This man knows a man who knows a man who knows a man. All three strangers potentially better at fighting than him. | A shame a man can\'t fight with his words these days. %name% would be unstoppable.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
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
				-10,
				-9
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				2,
				7
			],
			RangedDefense = [
				2,
				7
			],
			Initiative = [
				0,
				7
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.PeddlerTitles[this.Math.rand(0, this.Const.Strings.PeddlerTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});


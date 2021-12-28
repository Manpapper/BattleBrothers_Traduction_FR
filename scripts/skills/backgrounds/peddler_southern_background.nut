this.peddler_southern_background <- this.inherit("scripts/skills/backgrounds/peddler_background", {
	m = {},
	function create()
	{
		this.peddler_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
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
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{House to house, | Once a proud merchant, now | An annoyance to most, | In tough times, everyone has to scrape by somehow, hence why | Not a man of the trades, but instead of trade itself,} %name% is a mere peddler. {He\'ll dance, he\'ll sing, he\'ll boast and he\'ll act a king, anything to make that sale. | Pushy and unrelenting, his tenacity is admirable. | He\'ll try to sell off a rusty bucket for a helm once worn by kings. This man will sell anything. | This man will make you crave things you never knew you wanted. No refunds, though. | He used to make a decent living selling {used carts | pots, pans and jars}, until fierce competition drove him out of business - by breaking his arm.} {Marketing himself is what this frail man does best, though few believe his pitch about having \'Great swordsmanship and resolute bravery\'. | He supposedly handed out \'coupons\' for his services, whatever those are. He\'s chippy, though, and any outfit these days could use a warm body no matter its real value. | If hired, he promises, you\'ll get a special discount on a virility enhancing potion. | The man lowers his voice and tells you he\'s got a great deal on rusted arrow tips, just for you. He looks disappointed at your lack of interest. | This man knows a man who knows a man who knows a man. All three strangers potentially better at fighting than him. | A shame a man can\'t fight with his words these days. %name% would be unstoppable.}";
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
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});


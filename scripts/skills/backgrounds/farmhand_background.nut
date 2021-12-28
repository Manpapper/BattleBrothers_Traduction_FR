this.farmhand_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.farmhand";
		this.m.Name = "Farmhand";
		this.m.Icon = "ui/backgrounds/background_09.png";
		this.m.BackgroundDescription = "Farmhands are used to hard physical labor.";
		this.m.GoodEnding = "The former farmhand, %name%, retired from the %companyname%. The money he made was put toward purchasing a bit of land. He spends the rest of his days happily farming and starting a family with way too many children.";
		this.m.BadEnding = "The former farmhand, %name%, soon left the %companyname%. He purchased a bit of land out {south | north | east | west} and was doing quite well for himself - until noble soldiers hanged him from a tree for refusing to hand over all his crops.";
		this.m.HiringCost = 90;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.clubfooted",
			"trait.asthmatic"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "{Tilling the soil is hard work, requiring the blood and sweat of sturdier men. | Every farm in the land needs a stable of hardy men to work the fields.  | Man puts his sweat into the earth to feed himself, and he feeds himself to put his sweat into the Earth another day. | No matter the weather, a farm needs working. | Pigsties, stables, and ungated pens, these are the dreams and nightmares of farming men. | While some men earn their keep by killing, others look below their own two feet, wondering what crops the soil may hold. | A special breed of men comes out of ranchers and farmers. Sturdy, resolute, hard-working. | With food so needed, there\'s little wonder why farmers are the most common sort of man in all the land. | A farmer hates to see his land fertilized in blood, but that\'s becoming more and more common these days. | In war, farms are hotspots for armies. Not just to feed themselves, but to recruit from the stable of strong men who work those lands. | As cities grow and distance themselves from the hinterland, citizens often forget to whom their full bellies owe gratitude.} %name% {is a burly, sweat-sculpted farmhand. | hails from the outskirts of %randomtown% where he drove ploughs and broke horses. | knows a couple kinds of hoes, all of which the farmhand can swing with ease. | grew up on one of the land\'s many farms. | spent many years harvesting the crops that feed everyone in the land. | worked as a farmhand for a simple homestead. | fell into farming after his boating business went under. | became a farmhand to help feed his dozen kids and two wives. | took up farming as a means to a belly-filled end. | carries the stocky frame best used for planting, harvesting, and surviving winters.} {Unfortunately, it didn\'t take war and turmoil long to find his farm. | But poor harvests have driven him from the farms. | Sadly, his farm was one of the first to be attacked during these trying times. | Word of coming violence, however, drove him from the peaceful vocation of farming. | Droughts, poorly-timed as ever, have now driven the man from his work. | Unpaid for his labor, he eventually abandoned the farm life. | With more crowns than ever in the killing businesses, the man was easily drawn away from his motley crops. | One day, he realized his strong body had more value chopping heads than milking cows. | After raiders pillaged his crops, he\'d had enough, leaving the farm life for good. | After the weather soured his harvest, the farmer decided to choose a vocation not wholly based on the whims of Mother Nature. | Word has it he really did sleep with the farmer\'s daughter. What a surprise he\'s no longer on the farm.} {Cornfed and barnbred, %name% stands before you as fit a man you\'ve ever seen. | He misses the cows, true, but %name% should take to the mercenary\'s tough life with ease. | Growing up on a farm gives a man all the nutrients he\'d ever need, and %name% certainly took advantage. | %name% once took a mule kick to the face. Its foot broken, they had to put the animal down. | If men were trees, %name% would never fall down. Or something gracious like that. | Don\'t let his simple past fool you, %name% could fit right in with any wrestler or fighter. | %name% shares a lot in common with draught animals. Just point him the right way. | Judging by his size, there must have been a lot of meat in that corn %name% spent all his life eating. | %name% is big enough to wring a guy\'s neck like it was a cow\'s udder.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				12,
				10
			],
			Bravery = [
				-2,
				-3
			],
			Stamina = [
				10,
				20
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
			items.equip(this.new("scripts/items/weapons/pitchfork"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/wooden_flail"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});


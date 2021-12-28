this.poacher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.poacher";
		this.m.Name = "Poacher";
		this.m.Icon = "ui/backgrounds/background_21.png";
		this.m.BackgroundDescription = "Poachers tend to have some skill in using bow and arrow to hunt down rabbits and the like.";
		this.m.GoodEnding = "%name%, former poacher, eventually saved enough money to leave the %companyname%. You learned he found a bit of mountain land and works it for a local nobleman. Ironically, his job is to hunt down poachers.";
		this.m.BadEnding = "No longer seeing the point in risking his life for so few crowns, %name% the former poacher put down the sellsword\'s life and returned to unlawfully hunting deer in the woods. A nobleman once offered you a good satchel of crowns to specifically hunt the man down. You declined the offer, but the writing was on the wall: his days are numbered.";
		this.m.HiringCost = 65;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.hate_undead",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.loyal",
			"trait.fat",
			"trait.fearless",
			"trait.brave",
			"trait.bright"
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
		return "{Interested in the thrill of the hunt, | Looking to support his family, | With a grumbling stomach, | After a long and hard winter that left him without a stock of food,} %name% {set off into the woods in chase of deer | sought wildlife to which, if his skittishness is any indication, he may or may not have had proper claim | ate his fill of all manner of woodland creatures, a well-used bow yoked across his shoulders indicating the means to his meals | took to the woods to hunt game with bow and spear}. Hailing from %townname%, %name% {was, as a poacher, the hunter and the hunted | needed to feed his wife and children back home | sought to support himself, his own hide, and his ever-growling stomach | was poaching, an act of rebellion against the order of things as much as a means to fill his belly}. {Fearful that his pursuits would attract bounty hunters or lawmen, he decided to settle on life as a bow for hire. | Tired of working so hard just to put food on the table, buying a meal with a sellsword\'s pay just seemed so much easier in his mind. | After a bad hunt led him to a long stay in a lord\'s dungeon, he\'d rather put his neck on the line as a mercenary now than in the noose as a poacher. | Years of lonely hunting wore on the man. Although life as a mercenary is exceedingly dangerous, he\'d rather die with company than by himself. | His wife pleaded long that he change his ways lest the whole family pay for his crimes. He stands here now, a testament to who won the argument.}";
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
				5
			],
			Stamina = [
				3,
				0
			],
			MeleeSkill = [
				2,
				0
			],
			RangedSkill = [
				15,
				7
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
				4
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Wildmen)
		{
			r = this.Math.rand(1, 100);

			if (r <= 50)
			{
				items.equip(this.new("scripts/items/weapons/short_bow"));
				items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			}
			else if (r <= 80)
			{
				items.equip(this.new("scripts/items/weapons/staff_sling"));
			}
			else
			{
				items.equip(this.new("scripts/items/weapons/wonky_bow"));
				items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			}
		}
		else
		{
			if (this.Math.rand(1, 100) <= 75)
			{
				items.equip(this.new("scripts/items/weapons/short_bow"));
			}
			else
			{
				items.equip(this.new("scripts/items/weapons/wonky_bow"));
			}

			items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.addToBag(this.new("scripts/items/weapons/militia_spear"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});


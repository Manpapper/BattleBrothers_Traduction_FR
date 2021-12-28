this.messenger_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.messenger";
		this.m.Name = "Messenger";
		this.m.Icon = "ui/backgrounds/background_46.png";
		this.m.BackgroundDescription = "Messengers are used to long and tiring travels.";
		this.m.GoodEnding = "The oddity of having %name% the messenger in your band did not seem so strange after he showed himself to be a killer sellsword. As far as you know, he\'s still with the company, preferring the march of a mercenary to that of a messenger. You don\'t blame him: an errand boy must bend the knee to every nobleman he comes across, but in the company of sellswords he\'ll no doubt get the occasional chance to kill one of them bastards. Not a hard trade off to accept!";
		this.m.BadEnding = "%name% the messenger departed the %companyname% and returned to being an errand boy for the letters of lieges. You tried to find out where the man had gone to and eventually tracked him down - or what was left of him. Unfortunately, \"don\'t shoot the messenger\" is not an adage well followed in these fractured lands.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.clubfooted",
			"trait.asthmatic",
			"trait.cocky",
			"trait.craven",
			"trait.deathwish",
			"trait.dumb",
			"trait.fat",
			"trait.gluttonous",
			"trait.brute"
		];
		this.m.Titles = [
			"the Messenger",
			"the Courier",
			"the Runner"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{Some men are so important that they require other men to carry their words. %name% is such a man - the latter, that is. | %name%\'s shoulders are yoked with bags of mail, the receivers almost certainly dead on arrival. | To escape a life of servitude, %name% took up the vocation of a messenger. | With so many hurrying to find out the status of relatives, %name% has found ample work as a messenger. | %name% once traveled the land as a modest messenger. | Like his father and his father\'s father before him, %name% took messages across the land for royalty and laymen alike. | Picking up a dead messenger\'s bags, %name% soon found himself in the role of a would-be messenger. | Once a refugee, %name% figured he might as well deliver letters if he was already wandering the land.} {But making the rounds gets boring. The mailman seeks a new field of work. | Carrying love letters, the would-be adventurer wondered what the hell he was doing. | Claiming to be a budding hero, %name% now believes the task of delivering mail is beneath him. | Rain or sunshine, sure, snow or sleet, sure, but all out war? Maybe another time. | But after opening a letter that would ruin a goodhearted noble, the messenger decided to leave his post. | When robbers made his life hell, %name% figured he\'d be better off traveling in the company of armed men. | After sleeping with a mayor\'s wife, the messenger had a small army on his heels. He figured he\'d best slip into a different outfit for his own safety.} {%name% has spent years memorizing messages. Now he\'ll have to remember keeping the shield wall as arrows rain down on it. | Ironically, %name% has never written anything in his life. | Rolling up his sleeves, %name% boasts he has one last message to give the world. Everybody look out. | Perhaps his joining mercenaries suggests that, indeed, the pen is not mightier than a sword. | %name% has a tendency to repeat everything said to him. Old messenger habits die hard. | Ironically, the well-traveled messenger has probably seen more horrors on the road than most of the men in the outfit. | Few, if any, of %name%\'s skills make him ready for combat. But he does have some sturdy legs, hopefully just not for running away.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				0
			],
			Stamina = [
				15,
				10
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
				2
			],
			RangedDefense = [
				3,
				3
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
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
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


this.deserter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.deserter";
		this.m.Name = "Deserter";
		this.m.Icon = "ui/backgrounds/background_07.png";
		this.m.BackgroundDescription = "Deserters have received some martial training, but usually aren\'t eager to put it to use.";
		this.m.GoodEnding = "%name% the deserter continued fighting for the %companyname%, ever striving to redeem his name. Word has it that during a brutal fight with orcs, he dove headfirst into a crowd of greenskins, surfing across the top of their shocked heads. His heroism rallied the men to an incredible victory and he lives out his days getting toasted in every bar he enters.";
		this.m.BadEnding = "You heard %name% the deserter actually renewed his title and fled a battle the %companyname% had with some greenskins. Goblins caught him out in the woods and turned his head into a goblet for an orc warlord.";
		this.m.HiringCost = 85;
		this.m.DailyCost = 11;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.impatient",
			"trait.clubfooted",
			"trait.fearless",
			"trait.sure_footing",
			"trait.brave",
			"trait.loyal",
			"trait.deathwish",
			"trait.cocky",
			"trait.determined",
			"trait.fragile",
			"trait.optimist",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"the Deserter",
			"Turncloak",
			"the Betrayer",
			"the Runner",
			"the Dog",
			"the Worm"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = this.Math.rand(1, 2);
		this.m.IsCombatBackground = true;
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
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is always content with being in reserve"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name% used to be a common soldier in a lord\'s army, but suffering loss after loss, | Once a watchman on the outskirts of %randomtown%, %name% watched all his friends die to the beasts that lurk there. After so many losses | When two lords quarreled over a petty matter of who owned a local pond, %name% was conscripted to help settle the matter. Being a nobody, it was clear his life was of little value. One slaughter later, | While employed in a lord\'s professional army, a horrible disease fell upon %name% and his comrades. Fearing its wrath, | While on a lengthy military campaign, %name% felt that there was too much marching and too little spoils to be had. So} he {stuck his weapons in the ground and walked off. | waited until night to desert his outfit. | and several others disbanded in protest. | volunteered for a patrol and, at the first opening, abandoned his soldiering career.} {It is no secret that deserters are widely despised - and %name% keeps his head hung low to stay out of others\' eyes. | Most deserters spend the rest of their days avoiding the noose, and %name% is no different. | Donning the garb of the everyman, %name% has, for a time, avoided the deserter\'s punishment. | By total luck, %name% has, thus far, gotten away with his crime.} {But now broke and penniless, he seeks a return to his former field. | Perhaps compelled by lawmen closing in, he now finds himself joining another fighting force. | Unfortunately, he is not a smart man. Lacking the imagination to pursue a safer career, %name% once again returns to fighting. | Feeling guilty about deserting his brothers in the field, he now seeks redemption in fighting for another outfit. But who is to say he won\'t flee again? | With an empty coin purse from drinking his memories away, he now considers any opportunity to make a living.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-15,
				-10
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				7,
				0
			],
			MeleeDefense = [
				3,
				5
			],
			RangedDefense = [
				3,
				5
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
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/militia_spear"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/short_bow"));
			items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}

		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsContentWithBeingInReserve = true;
	}

});


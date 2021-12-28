this.raider_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.raider";
		this.m.Name = "Raider";
		this.m.Icon = "ui/backgrounds/background_49.png";
		this.m.BackgroundDescription = "Any raider that survived so far will have some expertise in fighting.";
		this.m.GoodEnding = "A former raider, %name% fit in well with the %companyname% and proved himself an excellent fighter. Having saved a veritable mountain of crowns, he retired from the company and returned from whence he came. He was last seen sailing a riverboat toward a small village.";
		this.m.BadEnding = "As the %companyname% speedily declined, %name% the raider departed from the company and went on his own way again. He returned to raiding, taking his greedy violence along the shorelines of river villages. You\'re not sure if it\'s true, but word has it that he was impaled with a pitchfork by a stable boy. Word has it that the town hoisted his body parts along the outer walls as a warning to future would-be raiders.";
		this.m.HiringCost = 160;
		this.m.DailyCost = 28;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Titles = [
			"the Raider",
			"the Marauder",
			"the Terrible",
			"the Bandit",
			"Fourfingers",
			"Ravensblack",
			"the Crow",
			"the Defiant",
			"the Pillager",
			"the Menace"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 4);
		this.m.IsCombatBackground = true;
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
		return "{Living by the shore, %name%\'s life was peppered with the spice of sea raiders. As an adult, he joined them in the raiding. | When his family was slaughtered, newborn %name% was taken in by the very raiders who did it. | Born in a faraway place, %name% traveled to this land looking for towns to pillage. | A strong man from a remote part of the land, %name%\'s presence here has been hellacious for local residents. | A raider with a strong oar-arm and an even greater axe-arm, %name% is part of the folklore that keeps kids in bed at night. | Part warrior, part criminal, %name% has made a good life as a raider. | %name% decided many years ago to take by force from the weak and feeble whatever he desired, and has made his presence known by raiding caravans and villages ever since. | A poor and starved boy growing up, %name% took to joining robbers and cutthroats out of desperation. For the first time in his life he didn\'t feel hunger every night, and so he continued to take by force from others what he needed. He learned to fight and to kill without remorse, and before long, he was a monster of a man. | Wearing a lord\'s boots and a queen\'s torn dress as a shawl, %name%\'s attire reflects his years of raiding well. | The threat that stirs lords in their sleep and rushes housewives beneath beds, %name% is a menacing raider. | The strong take from the weak - that is the order of things that %name% lives by.} {He and his comrades raided caravans and preyed on outlying farms, only to find themselves being attacked for spoils of war one day. A small band of orcs had spotted %name%\'s camp and washed it away like a force of nature, scattering the few survivors into every which direction. %name% ran and didn\'t look behind. | After many years of ill-gotten gains, the man gave up the life after a raid on an orphanage ended with an out of control fire and the deaths of those inside. | A devoted believer in the old ways, %name% desires to die a glorious warrior\'s death to take his place beside the gods. But slaughtering villagers like cattle won\'t get the attention of the gods, and so he now looks for a greater challenge. | But while raping and pillaging, %name% was noticed to have a preference for the husbands over the wives. His taste ostracized him from the rest of the warband. | It started with a good raid on a merchant caravan. The few guards were quickly cut down and the fleeing merchant didn\'t run fast enough - a javelin to his back attested to it. The spoils were rich, but before long there was heated argument about how they were to be shared. By evening, most of the raiders had killed each other. %name% only barely escaped and had nothing to show for his day but a limping leg. | But he always had a soft spot for women, and the constant rape and murder by his comrades pushed the raider away from this lifestyle. | Caught by a lord\'s guards, the raider barely escaped, instead watching from a hilltop as his comrades were executed. | But one village ambushed his party on a raid, cutting down everyone but himself as he stole a stable horse and escaped certain doom. | While staking out in a forest, the raider\'s party was attacked by vicious beasts. He fed his own comrade to the foul things just to save his own neck. | But as war tears the world asunder, the raider realized there was less and less to actually pillage. | But as conflicts boil, every village he ran into was either dirt poor or already armed to face other fiends of the world.} {Now, %name% just wants a fresh start, even in the dour field of sellswords. | %name% can\'t be wholly trusted as a mercenary, but having been in league with brigands and raiders at the very least makes him fit for the work. | The man is not brotherly in the least, but he can wield a weapon like it\'s one of his missing fingers. | While %name%\'s past leaves a bad taste in anyone\'s mouth, there are even worse out there. | %name% is adept at killing and looting, just make sure those skills are directed toward your enemies. | While a good fighter, %name% is first and foremost loyal to loot. | %name% is here to kill things and take things. For you, this is a good thing. | %name% wears a necklace of ears about his neck, and another necklace adorned with those ears\' earrings. Fancy. | %name% is a strong fighter, but he\'s in good running to be the least-liked individual in your whole party. | The countryside is an alluring, green canvas upon which to build a life. Maybe the raider just wants to settle down. | Wearing clothes tracked with their previous owner\'s blood, %name% looks strikingly ready for duty. | You get the feeling that %name% is wearing clothes that someone was probably murdered in.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 40)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
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
				-3
			],
			Stamina = [
				2,
				0
			],
			MeleeSkill = [
				12,
				10
			],
			RangedSkill = [
				5,
				0
			],
			MeleeDefense = [
				6,
				5
			],
			RangedDefense = [
				6,
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
		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/morning_star"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/military_pick"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/dented_nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_rusty_mail"));
		}
	}

});


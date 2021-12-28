this.servant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.servant";
		this.m.Name = "Servant";
		this.m.Icon = "ui/backgrounds/background_16.png";
		this.m.BackgroundDescription = "Servants are often not used to hard physical labor.";
		this.m.GoodEnding = "As it turns out, %name% the servant had been stowing away every last crown he had earned with the %companyname%. When he had enough, he retired and bought himself some land and slowly worked his way up the social ladder. He died in a comfortable bed, surrounded by friends, family, and loyal servants.";
		this.m.BadEnding = "%name% the servant grew tired of the sellsword life and left the company. He returned to serving nobility. When raiders attacked his liege\'s castle, the nobleman pushed the servant out the door with only a kitchen knife to defend himself with. He was found headless in a pile of broken chairs, a few dead raiders littered around him.";
		this.m.HiringCost = 45;
		this.m.DailyCost = 4;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.hate_beasts",
			"trait.impatient",
			"trait.iron_jaw",
			"trait.brute",
			"trait.athletic",
			"trait.strong",
			"trait.disloyal",
			"trait.fat",
			"trait.brave",
			"trait.fearless",
			"trait.optimist",
			"trait.cocky",
			"trait.bright",
			"trait.determined",
			"trait.greedy",
			"trait.sure_footing",
			"trait.bloodthirsty"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
	}

	function onBuildDescription()
	{
		return "{Life is difficult. Moreso for some than others. | Some men can fall from grace. Other men have nowhere to fall to, having been born already on the ground. | If life is a throw of dice, maybe some are fools to be men rather than mice.} %name% {was a servant to a decadent lord. | served an abusive family where the kids played with fire. | was kidnapped by brigands and forced to serve their every. Last. Need. | worked feverishly for mad men who looked far too long at the stars.}  He rarely made a mistake about his place in the world. One day, though, his masters {beat him unconscious. When he awoke, he did so in the bed of a benevolent doctor who refused to return him to his \'employers\'. Instead, %name% was free to go and his masters were told he had died. | set him free, no questions asked. Not one to dally on ceremony, %name% left in earnest. | invited him to a party. Believing he was a guest, he showed up in his finest attire - a shirt with hemmed sleeves and a billowy set of pantaloons that hid his skeletal frame well. Unfortunately, he was but a show for the party - they gave him a wooden shield and sword, threw him into an arena with a wild boar, and took bets as they watched the horrific spectacle. He barely escaped the \'festivities\'.} {%name% has since sworn to never \'serve\' someone again. | The man, though now free of his duties, still bears a great deal of humiliation and pain from his long, hard life.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				-5,
				-5
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
				2,
				0
			],
			Initiative = [
				5,
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
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
	}

});


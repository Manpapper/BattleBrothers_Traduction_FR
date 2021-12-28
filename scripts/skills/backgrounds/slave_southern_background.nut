this.slave_southern_background <- this.inherit("scripts/skills/backgrounds/slave_background", {
	m = {},
	function create()
	{
		this.slave_background.create();
		this.m.GoodEnding = "You purchased %name% as an indebted for almost no gold and continued to pay him a \'slave\'s wage\' for his stay as a sellsword. He did make himself an effective fighter, no doubt believing it was better to be paid nothing and fight to stay alive than be paid nothing and give up and rot. After your departure, you heard that the %companyname% traveled south on a campaign and the indebted got a good chance to exact a fair bit of revenge on a number of enemies in his past. Thankfully, he does not consider you one such person despite having kept him enslaved.";
		this.m.BadEnding = "You purchased %name% as an indebted and after your retiring, he went on with the %companyname%. Word of the mercenary band\'s problems have trickled in, but nothing about the indebted\'s current situation. Knowing how this world works, he has either been put into the vanguard as fodder or perhaps even been sold off to recoup profits. Either way, the world isn\'t easy on a sellsword, and it isn\'t easy on an indebted, and the man is unfortunately both.";
		this.m.Bodies = this.Const.Bodies.SouthernSlave;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.Titles = [
			"the Enslaved",
			"the Prisoner",
			"the Unlucky",
			"the Indebted",
			"the Indebted",
			"the Indebted",
			"the Unfree",
			"the Criminal",
			"the Obedient",
			"the Shackled",
			"the Bound"
		];
	}

	function onBuildDescription()
	{
		return "{Much of the southern city states float atop the expendable bodies of prisoners of war, criminals, and indebted, throngs of people who have slighted the Gilder or His followers and must \'earn\' salvation through hard work. %name% is one such unfortunate soul.} {Like a shocking many, %name% was not always a hunted man. He worked as a traveling merchant until nomads ambushed his caravan. The nomads took him to a Vizier, pretending the man a criminal, and sold him as a hunted man. | Spotted for his handsomeness, %name% was kidnapped off the streets of %randomcitystate% and sold straight to a manipulative Vizier. He does not speak much of what all happened, but there is a sense manual labor was not his sole duty. | So great the religious transgressions of his predecessors, %name% was born into an indebted family, and it is uncertain how far back into his ancestry you must go before a truly free man would be found. | Desperate to save his family from generational debt, %name% sold himself into indentured servitude to ensure his wife and children have a life to live for themselves. | %name% swears he is from the north, but the deserts of the south have left him darkly tanned and, frankly, you\'ve not much reason to believe the words of a former prisoner of war no matter where he\'s from. | A once sea-farer, %name% spent years as an oarmen traveling from harbor to harbor to drive the goods of opulent merchants. Those who gave him to you stated he has a criminal past in piracy. | %name% was accused of ravishing an old woman and was given the option of execution or lifelong servitude. | Caught stealing from a fruit stall, %name% was pressed into lifelong servitude. | Fornications with \'non-women\' led to %name%\'s submission to servitude per the rules of the city-state in which he broke the laws. It was either that or become a eunuch, and you can hardly blame him for choosing the hard labor in this case.} {The hardships of his life, rather quaintly, may serve as an excellent cast from which to mold a proper mercenary. | His servitude no doubt made the man formidable in appearance, though it may be hard to say where his mind is at being what is essence an indentured sellsword. | Slaves for warriors are a usual sight in the southern cities and %name% might serve as a useful, albeit enslaved, sellsword yet. | You hope %name% could make a sound sellsword, but you have the feeling his primary allegiance is to that which any man wishes to taste: freedom.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-10
			],
			Bravery = [
				-10,
				-5
			],
			Stamina = [
				5,
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
				-5,
				-5
			]
		};
		return c;
	}

});


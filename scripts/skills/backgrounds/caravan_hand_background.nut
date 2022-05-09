this.caravan_hand_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.caravan_hand";
		this.m.Name = "Aide-caravanier";
		this.m.Icon = "ui/backgrounds/background_12.png";
		this.m.BackgroundDescription = "Les Aide-caravaniers sont habitués à des voyages longs et épuisants.";
		this.m.GoodEnding = "%name% the once-caravan hand retired from fighting. He used his mercenary money to start a trade-guarding business that specializes in transporting goods through dangerous lands.";
		this.m.BadEnding = "%name% the caravan hand retired back into guarding trade wagons. He died when defending against an ambush by brigands. They took his shirt and left his body in a ditch.";
		this.m.HiringCost = 75;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.tiny",
			"trait.clubfooted",
			"trait.gluttonous",
			"trait.bright",
			"trait.asthmatic",
			"trait.fat"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{Toujours du genre aventurier, %name% a été facilement attiré par la vie d\'un conducteur de caravane. | Orphelin de guerre et de peste, %name% a grandi sous les ailes d\'un marchand ambulant. | La vie d\'un valet de caravane est dure, mais %name% ne supporte pas de rester trop longtemps au même endroit. | Bien que le travail soit dangereux, être un aide-caravanier a permis à %name% de voir le monde. | Lorsque sa famille et ses obligations sont détruites par un incendie, %name% ne voit aucune raison de ne pas rejoindre une caravane qui passe. | Il a été le premier à être choisi par un marchand pour protéger son stock en tant qu\'aide-caravanier. | S\'enfuyant de chez lui, %name% ne tarda pas à rejoindre une caravane et à y travailler.} {Mais la marchande pour laquelle il travaillait s\'est avérée être abusive, à deux doigts d\'être une esclavagiste. Après une intense dispute avec la femme, %name% a pensé qu\'il valait mieux partir avant de faire quelque chose d\'horrible. | Un jour, des marchandises ont disparu et la main a été accusée, ce qui a mis fin à son séjour dans la caravane. | Mais une caravane a besoin de protection pour une raison, et une embuscade tendue par des brigands a prouvé pourquoi. %name% s\'en est sorti de justesse. | Les années sur la route se sont déroulées sans problème jusqu\'à ce qu\'un nouveau maître de caravane refuse de payer %name%. D\'une seule main, le caravanier frappa son patron et s\'empara de son salaire. Mais il a utilisé ses deux jambes pour courir. | Les caravanes sont souvent des endroits tendus. Un soir fatidique, lors d\'une dispute pour des dettes de jeu, il a enfoncé la tête d\'un autre voyageur. Craignant des représailles, %name% est parti avant le matin. | Malheureusement, avec l\'extension de la guerre, les profits de la caravane étaient marginaux. %name% a été licencié alors que les marchands retiraient leurs chariots. | Après avoir vu le travail immonde des bêtes sur un autre caravanier, %name% n\'a pas mis longtemps à comprendre que son salaire n\'était pas à la hauteur des menaces qui l\'entouraient. | Mais la guerre a privé la caravane de son bétail et bientôt son conducteur s\'est mis à vendre des esclaves. Consterné, %name% en libère autant qu\'il peut avant de partir pour de bon. | Malheureusement, sa caravane a commencé à vendre des biens humains. Bien que les profits soient énormes, cela attire l\'attention de la milice locale - et de ses fourches. Une embuscade plus tard, %name% devait fuir pour sa vie.} {Désormais incertain de ce qu\'il doit faire, il cherche toute opportunité qui pourrait se présenter. | Un homme comme %name% n\'est pas étranger au danger, ce qui en fait un bon élément pour tout groupe de mercenaires. | Avec ses jours de caravane derrière lui, travailler comme mercenaire n\'était qu\'une autre possibilité d\'aventure et de profit. | Dans l\'esprit de %name%, être un mercenaire ressemble beaucoup à être un caravanier. Juste mieux payé. | Habitué à voyager, %name% semble tout à fait apte à accomplir les tâches qui incombent déjà à un mercenaire. | Des années de voyages sur les routes ont fait de %name% une personne très résistante. N\'importe quel groupe de mercenaires aurait besoin de plus d\'hommes comme lui.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				3,
				5
			],
			Bravery = [
				3,
				3
			],
			Stamina = [
				5,
				7
			],
			MeleeSkill = [
				4,
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
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

});


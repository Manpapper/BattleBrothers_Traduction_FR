this.caravan_hand_southern_background <- this.inherit("scripts/skills/backgrounds/caravan_hand_background", {
	m = {},
	function create()
	{
		this.caravan_hand_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.tiny",
			"trait.clubfooted",
			"trait.gluttonous",
			"trait.bright",
			"trait.asthmatic",
			"trait.fat"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{Toujours du genre aventurier, %name% a été facilement attiré par la vie d\'un conducteur de caravane. | Orphelin de guerre et de peste, %name% a grandi sous les ailes d\'un marchand ambulant. | La vie d\'un valet de caravane est dure, mais %name% ne supporte pas de rester trop longtemps au même endroit. | Bien que le travail soit dangereux, être un aide-caravanier a permis à %name% de voir le monde. | Lorsque sa famille et ses obligations sont détruites par un incendie, %name% ne voit aucune raison de ne pas rejoindre une caravane qui passe. | Il a été le premier à être choisi par un marchand pour protéger son stock en tant qu\'aide-caravanier. | S\'enfuyant de chez lui, %name% ne tarda pas à rejoindre une caravane et à y travailler.} {Mais la marchande pour laquelle il travaillait s\'est avérée être abusive, à deux doigts d\'être une esclavagiste. Après une intense dispute avec la femme, %name% a pensé qu\'il valait mieux partir avant de faire quelque chose d\'horrible. | Un jour, des marchandises ont disparu et la main a été accusée, ce qui a mis fin à son séjour dans la caravane. | Mais une caravane a besoin de protection pour une raison, et une embuscade tendue par des brigands a prouvé pourquoi. %name% s\'en est sorti de justesse. | Les années sur la route se sont déroulées sans problème jusqu\'à ce qu\'un nouveau maître de caravane refuse de payer %name%. D\'une seule main, le caravanier frappa son patron et s\'empara de son salaire. Mais il a utilisé ses deux jambes pour courir. | Les caravanes sont souvent des endroits tendus. Un soir fatidique, lors d\'une dispute pour des dettes de jeu, il a enfoncé la tête d\'un autre voyageur. Craignant des représailles, %name% est parti avant le matin. | Malheureusement, avec l\'extension de la guerre, les profits de la caravane étaient marginaux. %name% a été licencié alors que les marchands retiraient leurs chariots. | Après avoir vu le travail immonde des bêtes sur un autre caravanier, %name% n\'a pas mis longtemps à comprendre que son salaire n\'était pas à la hauteur des menaces qui l\'entouraient. | Mais la guerre a privé la caravane de son bétail et bientôt son conducteur s\'est mis à vendre des esclaves. Consterné, %name% en libère autant qu\'il peut avant de partir pour de bon. | Malheureusement, sa caravane a commencé à vendre des biens humains. Bien que les profits soient énormes, cela attire l\'attention de la milice locale - et de ses fourches. Une embuscade plus tard, %name% devait fuir pour sa vie.} {Désormais incertain de ce qu\'il doit faire, il cherche toute opportunité qui pourrait se présenter. | Un homme comme %name% n\'est pas étranger au danger, ce qui en fait un bon élément pour tout groupe de mercenaires. | Avec ses jours de caravane derrière lui, travailler comme mercenaire n\'était qu\'une autre possibilité d\'aventure et de profit. | Dans l\'esprit de %name%, être un mercenaire ressemble beaucoup à être un caravanier. Juste mieux payé. | Habitué à voyager, %name% semble tout à fait apte à accomplir les tâches qui incombent déjà à un mercenaire. | Des années de voyages sur les routes ont fait de %name% une personne très résistante. N\'importe quel groupe de mercenaires aurait besoin de plus d\'hommes comme lui.}";
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
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/oriental/light_southern_mace"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/oriental/saif"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/padded_vest"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}

		r = this.Math.rand(0, 3);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_leather_cap"));
		}
	}

});


this.graverobber_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.graverobber";
		this.m.Name = "Pilleur de Tombes";
		this.m.Icon = "ui/backgrounds/background_25.png";
		this.m.BackgroundDescription = "Les pilleurs de tombes ne sont pas des âmes sensibles.";
		this.m.GoodEnding = "Les pilleurs de tombes comme %name% ne sont pas vraiment les hommes les plus aimés dans ce monde, mais tout ce dont vous aviez besoin, c\'était qu\'il soit un grand mercenaire et ce fut une franche réussite. Après avoir quitté le métier, vous avez appris que le pilleur de tombes restait pour le long terme. D\'après ce que vous savez, il est maintenant le formateur de la compagnie, aidant les nouvelles recrues à se mettre à niveau.";
		this.m.BadEnding = "Un homme comme %name% le pilleur de tombes est venu à la compagnie pour l\'aider à effacer ses erreurs les plus illégales et immorales, et quel meilleur moyen de le faire que de tuer des gens pour de l\'argent? Malheureusement, la compagnie %companyname% a commencé à s\'effondrer lentement. Vous avez appris que %name% a fini par quitter la compagnie pour en rejoindre une autre quasi similaire et concurrente. il est impossible de dire où il est maintenant, et vous ne savez pas si vous devez vous sentir insulté par sa trahison ou comprendre son raisonnement. Les affaires ne sont que des affaires, après tout.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.night_blind",
			"trait.cocky",
			"trait.craven",
			"trait.fainthearted",
			"trait.loyal",
			"trait.optimist",
			"trait.superstitious",
			"trait.determined",
			"trait.deathwish"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
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
		return "{Qu\'est-ce qui pousse un homme à déranger ceux qui sont décédés ? | Avec les rumeurs de mort qui renaissent, c\'est peut-être un peu avant-gardiste d\'aller déterrer des tombes. | Ennemis des standards moraux et des sensibilités, les hommes qui emmènent des pelles sur des tombes fraîches trouvent peu d\'alliés. | Un lâche attaque un homme quand il est à terre, un pilleur de tombes attaque un homme quand il est vraiment sous terre. | Il serait simple de constater à quel point il est facile de piller un homme pris par la mort | Quand vient la mort, les vers prennent la chair, et le temps les os, mais les pilleurs de tombes prennent les bijoux.} {Élevé par une mère abusive, %name% a trouvé une meilleur harmonie parmis les morts que parmis les vivants. | Après de nombreuses nuits solitaires en ermite, on raconte que %name% se serait mis à danser avec les morts. | %name% romancé sous les étoiles, mais pâle et froid décrit plus que le ciel nocturne. | Pour se divertir dans une vie ennuyeuse, %name% est connu pour visiter les sombres entrailles des cimetières. | Escroqué par un vendeur, %name% s\'est retrouvé à creuser des tombes pour trouver du butin. C\'est ce qu\'on raconte, en tout cas. | Autrefois bijoutier, la démence a poussé %name% à créer un style de vêtements très différent. Un collier denté vous interpelle pendant qu\'il vous parle.} {Les déviances d\'un tel homme ne connaissent peut-être pas de limites, mais son corps pour l\'instant chaud pourrait être utile. | Il n\'est pas bien dans sa tête, mais peut-être qu\'il l\'est avec une épée à la main. Peut-être. | Aussi dérangeant qu\'il puisse être, les temps désespérés appellent des recrues désespérées. | Il porte un collier uni d\'une subtile couleur blanc cassé que l\'on pourrait qualifier d\"os\". | Chassé par une foule particulièrement furieuse, %name% est l\'un des nombreux parias à s\'aventurer dans le monde des mercenaires. | L\'homme est calme, mais on ne peut pas le faire taire dans un cimetière. | Espérons qu\'il aime mettre les corps froids dans les tombes autant qu\'il aime les déterrer.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				8,
				5
			],
			Stamina = [
				5,
				5
			],
			MeleeSkill = [
				3,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				0,
				1
			],
			RangedDefense = [
				0,
				1
			],
			Initiative = [
				0,
				4
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
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/ancient/broken_ancient_sword"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/ancient/ancient_household_helmet"));
		}
	}

});


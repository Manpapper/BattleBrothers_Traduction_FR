this.squire_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.squire";
		this.m.Name = "Écuyer";
		this.m.Icon = "ui/backgrounds/background_03.png";
		this.m.BackgroundDescription = "Les écuyers ont généralement reçu un entraînement à la guerre et sont souvent très déterminés à exceller dans ce qu\'ils font.";
		this.m.GoodEnding = "%name%, l\'écuyer, a fini par quitter la compagnie %companyname%. Vous avez entendu dire qu\'il a été fait chevalier depuis. Nul doute qu\'il est heureux comme un poisson dans l\'eau, où qu\'il soit.";
		this.m.BadEnding = "%name%, l\'écuyer, a finalement quitté la compagnie %companyname%. Il avait l\'intention de rentrer chez lui et de devenir chevalier, réalisant ainsi le rêve de toute une vie. Des politiques cruelles se sont interposées et non seulement il n\'a pas été fait chevalier, mais il a été déchu de ses fonctions d\'écuyer. On dit qu\'il s\'est pendu aux chevrons d\'une grange.";
		this.m.HiringCost = 160;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.clubfooted",
			"trait.irrational",
			"trait.disloyal",
			"trait.fat",
			"trait.fainthearted",
			"trait.craven",
			"trait.dastard",
			"trait.fragile",
			"trait.insecure",
			"trait.asthmatic",
			"trait.clumsy",
			"trait.pessimist",
			"trait.greedy",
			"trait.bleeder"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.YoungMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "{Un jeune écuyer, %name% a fidèlement servi son chevalier dans de nombreuses batailles. | Écuyer d\'un chevalier impitoyable, %name% passait ses journées à faire des commissions pour sa seigneurie. | Bien qu\'il soit écuyer, la vie de %name% consiste essentiellement à garder des prisonniers de guerre, à son grand dam. | Ecuyer d\'un chevalier, certes, mais %name% a surtout nettoyé des latrines, nourri des chiens, et a beaucoup trop utilisé sa boîte à cirage.} {Une nuit, des hommes étranges, traînant les pieds, ont regardé l\'horizon éclairé par la lune. Les cloches ont retenti et une heure plus tard, la moitié de %townname% était en ruine. | Lors d\'un voyage, des brigands ont attaqué le convoi de chariots de sa seigneurie. Des épées furent volées, des têtes furent coupées en deux, et au bout du compte, l\'écuyer avait échoué : tous ceux qu\'il était censé protéger étaient morts. | Mais un soir, une horde de créatures féroces et velues s\'abattit sur le donjon de son seigneur. En désespoir de cause, %name% a libéré un groupe de prisonniers, espérant qu\'ils l\'aideraient au combat. Au lieu de cela, ils ont tué son seigneur et se sont enfuis dans la nuit. L\'écuyer, courageusement, réussit à survivre, une douzaine de cadavres de husky à ses pieds, mais la bataille le laissa seul et sans but. | Dégouté d\'une crime horrible commis dans %townname%, il a pris les choses en main en tuant personnellement le criminel. Un acte juste, mais aussi un acte inapproprié. Le jeune écuyer a été banni pour son insubordination. | Quand un chevalier rouge diabolique est venu à %townname% pour un duel, le chevalier de %name% s\'est avéré bien trop malade pour se battre. Après avoir avalé une potion de confiance, %name% a revêtu l\'armure de sa seigneurie et a affronté le chevalier rouge en personne. D\'un coup d\'épée si rapide qu\'il résonnait dans l\'air, %name% a terrassé son adversaire.} {Il ne lui restait plus qu\'une seule tâche à accomplir : devenir chevalier. | L\'écuyer cherche maintenant la compagnie d\'hommes de bien pour prouver à nouveau qu\'il est digne d\'être un chevalier. | Alors que la guerre ravage le pays, il y a maintenant de nombreuses occasions de mettre ses compétences à profit. | Bien qu\'un peu trop sérieux, il ne fait aucun doute que le monde a besoin d\'hommes comme %name%.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				12,
				12
			],
			Stamina = [
				7,
				5
			],
			MeleeSkill = [
				7,
				5
			],
			RangedSkill = [
				7,
				8
			],
			MeleeDefense = [
				1,
				3
			],
			RangedDefense = [
				1,
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
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}

		r = this.Math.rand(0, 2);

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
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

});


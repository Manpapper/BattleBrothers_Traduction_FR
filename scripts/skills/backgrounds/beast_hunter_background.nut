this.beast_hunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.beast_slayer";
		this.m.Name = "Tueur de Bêtes";
		this.m.Icon = "ui/backgrounds/background_57.png";
		this.m.BackgroundDescription = "Les chasseurs de bêtes sont utilisés pour chasser de manière experte les bêtes monstrueuses où qu\'elles soient.";
		this.m.GoodEnding = "%name% a pris sa retraite de la compagnie et a acheté l\'acte d'un château abandonné. Il y commande une troupe de tueurs de bêtes qui parcourent le pays pour le protéger des monstres. La dernière fois que vous lui avez parlé, il avait une amie aux cheveux noirs qui n\'a pas apprécié votre présence, ni celle de quiconque d'ailleurs. Vous êtes sûr qu\'il est heureux.";
		this.m.BadEnding = "Après avoir quitté la compagnie %companyname%, %name% s\'est retiré de la chasse aux bêtes et aux dernières nouvelles, il a engendré une fille albinos. Malheureusement, des rumeurs se sont rapidement répandues sur les pouvoirs surnaturels de la jeune fille et sa mère a été exécutée par le feu. Le père et l\'enfant n'ont jamais été attrapés ni revus.";
		this.m.HiringCost = 150;
		this.m.DailyCost = 15;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.fear_beasts",
			"trait.ailing",
			"trait.bleeder",
			"trait.dumb",
			"trait.fragile",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.short_sighted",
			"trait.fat",
			"trait.clumsy",
			"trait.gluttonous",
			"trait.asthmatic",
			"trait.craven",
			"trait.dastard"
		];
		this.m.Titles = [
			"the Beasthunter",
			"Woodstalker",
			"the Beastslayer",
			"the Tracker",
			"the Trophyhunter",
			"the Hunter"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 3);
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
		return "{Le passé de %name% n\'est guère extravagant. | %name% a parcouru ces contrées depuis un certain temps, mais pas toujours dans le cadre de sa vocation actuelle. | Malgré son métier macabre, %name% n\'est pas issu d\'une vie extraordinaire. | Une longue liste de bêtes vaincues et les peaux qui le prouvent peuvent induire en erreur quant au passé de %name%.} {Le tueur de bêtes était autrefois un simple chasseur, armé d\'un arc et de sagesse. Cependant, après avoir découvert un loup-garou monstrueux dans l\'un de ses pièges, il a pris goût à la chasse d\'ennemis plus dangereux. | Lorsque son village a été attaqué par des webknechts, l\'homme s\'est mis à apprendre tout ce qu\'il pouvait sur la chasse aux bêtes. Et il l\'a fait avec beaucoup de succès. | On dit qu\'il était le meunier du village jusqu\'à ce que les alpages hantent tout le village. N\'ayant jamais été un grand dormeur lui-même, il passait des nuits entières à apprendre sur les monstres jusqu\'à ce qu\'il les surpasse. | Il servait de dénicheur de proies pour un seigneur local. Mais quand une chasse a mal tourné et qu\'il s\'est retrouvé dans la gueule du loup, l\'homme s\'est mis à étudier les bêtes et comment les tuer. | Un simple bûcheron, le tueur de bêtes est devenu une réalité lorsque tous ses pairs ont été massacrés par un schrat, un arbre vivant. Il a vengé ses amis et a juré d\'apprendre tout ce qu\'il pouvait sur les monstres. | Ancien moine, l\'homme s\'est tourné vers l\'étude des bêtes et des épées après que des nachzehrers aient ravagé son monastère.} {Les temps changent, cependant, et même cet habile chasseur de monstres ne peut faire cavalier seul. Il cherche à rejoindre une compagnie et à tuer autant de bêtes qu\'il peut. | Les jours sont inhabituellement courts et la lune brille chaque nuit. Ce tueur sent un changement dans l\'air, et s\'il veut combattre ce qui arrive, il aura besoin de plus que lui-même pour le faire. | Bien qu\'il n\'aime pas la compagnie, le tueur de bêtes veut tuer autant de créatures que possible, et il aura besoin de l\'aide de quelques bons frères pour y parvenir. | Dans un monde de plus en plus dangereux et désespéré, le tueur de bêtes cherche de l\'argent et de la compagnie. | Un compagnon professionnel tel que cet homme pourrait être d\'une grande utilité pour une compagnie de mercenaires et vous ne doutez pas qu\'il sera diligent dans sa lutte contre la mort. | Malheureusement, l\'homme a pris un apprenti sous son aile, mais le gamin a été massacré par un loup-garou. Le tueur de bêtes brisé cherche maintenant une compagnie plus solide.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				3
			],
			Bravery = [
				13,
				10
			],
			Stamina = [
				5,
				7
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				11,
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
				7,
				5
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 75)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 75)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hunting_bow"));
			items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/spetum"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/javelin"));
		}

		if (this.Math.rand(1, 100) <= 50 && items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
		{
			items.equip(this.new("scripts/items/tools/throwing_net"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hunters_hat"));
		}
	}

});


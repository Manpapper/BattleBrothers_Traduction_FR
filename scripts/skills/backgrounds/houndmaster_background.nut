this.houndmaster_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.houndmaster";
		this.m.Name = "Maître-chien";
		this.m.Icon = "ui/backgrounds/background_50.png";
		this.m.BackgroundDescription = "Le maître-chien utilise des chiens de combat.";
		this.m.GoodEnding = "Les chiens ne sont pas simplement des \"chiens de chasse\" pour %name%, malgré son titre de \"maître-chien\". Pour lui, ils sont ses amis les plus fidèles. Après avoir quitté la compagnie, il a découvert un moyen ingénieux d\'élever des animaux adaptés aux désirs de la noblesse. Vous voulez une bête massive comme chien de garde ? Il peut le faire. Vous voulez quelque chose de petit et doux pour les enfants ? Il peut le faire aussi. L\'ancien mercenaire gagne maintenant très bien sa vie en faisant ce qu\'il aime - travailler avec les chiens.";
		this.m.BadEnding = "Ce qui n\'est qu\'un chien de chasse pour un homme est une bête loyale pour %name%. Après avoir quitté la comapgnie, le maître-chien est parti travailler pour la noblesse. Malheureusement, il a refusé que des centaines de ses chiens soient utilisés comme chair à canon pour donner un avantage éphémère lors de combats. Il a été pendu pour ses \"lâches idéaux\".";
		this.m.HiringCost = 80;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.bleeder",
			"trait.bright",
			"trait.asthmatic",
			"trait.fainthearted",
			"trait.tiny"
		];
		this.m.Titles = [
			"the Houndmaster",
			"the Kennelmaster",
			"the Dogkeeper"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
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
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Les chiens de combat lâchés par ce personnage démarreront avec un moral confiant."
			}
		];
	}

	function onBuildDescription()
	{
		return "{L\'affection de %name% pour les chiens a commencé après que son père ait gagné un chiot lors d\'un concours de tir. | Lorsqu\'un chien l\'a sauvé d\'un ours, %name% a consacré sa vie à l\'espèce canine. | En voyant un chien repousser un potentiel voleur, l\'affection de %name% pour les chiens n\'a fait que croître. | Un jeune %name%, chasseur d\'oiseaux, a vite compris l\'honneur, la loyauté et le travail d\'un chien. | Après avoir été mordu par un chien sauvage, %name% a affronté sa peur des canidés en apprenant à les dresser.} {Le maître-chien a passé de nombreuses années à travailler pour un seigneur local. Il a abandonné le poste après que le seigneur ait abattu un chien juste pour le sport. | Rapidement après avoir dressé ses bâtards, le maître a loué ses chiens à un lucratif cirque itinérant. | L\'homme a gagné beaucoup d\'argent dans les combats de chiens, ses clébards sont réputés pour leur férocité et leur obéissance. | Employé par les hommes de loi, le maître-chien utilisait l\'odorat de ses chiens pour traquer de nombreux criminels. | Utilisés par un seigneur local, de nombreux chiens du maître se sont retrouvés sur le champ de bataille. | Pendant de nombreuses années, le maître a utilisé ses chiens pour aider à remonter le moral des enfants orphelins et celui des infirmes.} {Cependant, %name% cherche à changer de vocation. | Lorsqu\'il a entendu parler du salaire d\'un mercenaire, %name% a décidé de s\'essayer au métier de soldat indépendant. | Approché par un mercenaire pour acheter un de ses chiens, %name% s\'est intéressé à la perspective de devenir lui-même mercenaire. | Fatigué de dresser des chiens dans tel ou tel but, %name% cherche à se former lui-même dans... eh bien, dans tel ou tel but. | Une perspective intéressante, on ne peut qu\'espérer que %name% soit aussi loyal que les chiens qu\'il commandait autrefois.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				5,
				0
			],
			Bravery = [
				5,
				5
			],
			Stamina = [
				5,
				0
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
				3,
				3
			],
			RangedDefense = [
				0,
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

		if (this.Math.rand(1, 100) >= 50)
		{
			items.equip(this.new("scripts/items/tools/throwing_net"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

});


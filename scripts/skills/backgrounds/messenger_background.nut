this.messenger_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.messenger";
		this.m.Name = "Messager";
		this.m.Icon = "ui/backgrounds/background_46.png";
		this.m.BackgroundDescription = "Les messagers sont habitués à des voyages longs et fatigants.";
		this.m.GoodEnding = "L\'étrangeté d\'avoir %name% le messager dans votre groupe n\'a pas semblé si bizarre après qu\'il se soit révélé être un tueur à gages. Pour autant que vous le sachiez, il est toujours dans la compagnie, préférant marcher comme mercenaire plutôt que comme un messager. On ne peut pas lui en vouloir : un garçon de courses doit plier le genou à tous les nobles qu\'il croise, mais en compagnie de mercenaires, il aura sans doute l\'occasion de tuer un de ces salauds. Ce n\'est pas un compromis difficile à accepter!";
		this.m.BadEnding = "Le messager quitta la compagnie %companyname% et redevint un garçon de course déstiné aux lettres qu\'envoyèrent les seigneurs. Vous avez essayé de découvrir où l\'homme était parti et avez fini par le retrouver - ou ce qu\'il en restait. Malheureusement, \"ne tirez pas sur le messager\" n\'est pas un adage bien suivi dans ces terres fracturées.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.clubfooted",
			"trait.asthmatic",
			"trait.cocky",
			"trait.craven",
			"trait.deathwish",
			"trait.dumb",
			"trait.fat",
			"trait.gluttonous",
			"trait.brute"
		];
		this.m.Titles = [
			"the Messenger",
			"the Courier",
			"the Runner"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{Certains hommes sont si importants qu\'ils ont besoin des autres pour porter leurs paroles. %name% est de cette trempe - le dernier, en fait. | Les épaules de %name% sont chargées de sacs remplis de courrier, les destinataires étant presque certainement morts à son arrivée. | Pour échapper à une vie de servitude, %name% a embrassé la vocation de messager. | Comme beaucoup de gens se pressent pour connaître la situation de leurs proches, %name% a trouvé du travail comme messager. | %name% parcourait autrefois le pays en tant que modeste messager. | Comme son père et le père de son père avant lui, %name% a porté des messages à travers le pays pour la royauté et les profanes. | Ramassant les sacs d\'un messager mort, %name% s\'est rapidement retrouvé dans le rôle d\'un soi-disant messager. | Une fois réfugié, %name% s\'est dit qu\'il pouvait aussi bien distribuer des lettres s\'il était déjà en train d\'errer dans le pays.} {Mais faire la tournée devient ennuyeux. Le facteur cherche un nouvel emploi. | Transportant des lettres d\'amour, l\'aventurier en herbe se demande ce qu\'il fait. | Prétendant être un héros en herbe, %name% pense maintenant que la tâche de distribuer le courrier est indigne de lui. | La pluie ou le soleil, certain, la neige ou la grêle, assurément, mais la guerre totale ? Peut-être une autre fois. | Mais après avoir ouvert une lettre qui ruinerait un noble au grand cœur, le messager décide de quitter son poste. | Quand les voleurs ont fait de sa vie un enfer, %name% s\'est dit qu\'il serait mieux de voyager en compagnie d\'hommes armés. | Après avoir couché avec la femme d\'un maire, le messager avait une petite armée à ses trousses. Il s\'est dit qu\'il ferait mieux de changer de tenue pour sa propre sécurité.} {%name% a passé des années à mémoriser des messages. Maintenant, il va devoir se souvenir de garder son bouclier levé lorsque que les flèches pleuvent dessus. | Ironiquement, %name% n\'a jamais rien écrit de sa vie. | Retroussant ses manches, %name% se vante d\'avoir un dernier message à transmettre au monde. Que tout le monde fasse attention. | Le fait qu\'il ait rejoint des mercenaires suggère que, peut-être, la plume n\'est pas plus puissante que l\'épée. | %name% a tendance à répéter tout ce qu\'on lui dit. Les vieilles habitudes de messager ont la vie dure. | Ironiquement, le messager qui a beaucoup voyagé a probablement vu plus d\'horreurs sur la route que la plupart des hommes de l\'équipe. | Peu, voire aucunes des compétences de %name% le rendent apte au combat. Il a des jambes solides, mais, espérons-le, pas pour s\'enfuir.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				0
			],
			Stamina = [
				15,
				10
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
				2
			],
			RangedDefense = [
				3,
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
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});


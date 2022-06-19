this.swordmaster_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.swordmaster";
		this.m.Name = "Maître d\'armes";
		this.m.Icon = "ui/backgrounds/background_30.png";
		this.m.BackgroundDescription = "Un maître d\'armes excelle dans le combat au corps à corps comme personne, mais peut être vulnérable à distance. L\'âge a pu avoir un impact sur ses capacités physiques mais il est toujours capable d\'exercer son métier.";
		this.m.GoodEnding = "Le meilleur épéiste que vous ayez jamais vu, %name%, a été une recrue logique pour la compagnie %companyname%. Mais un homme ne peut pas se battre éternellement. Malgré le succès croissant de la compagnie, il devenait évident que le maître d\'armes était physiquement à bout. Il s\'est retiré dans un bel endroit et profite d\'un peu de temps pour lui. Enfin, c\'est ce que vous pensiez. Vous êtes sortis pour aller voir l\'homme et vous l\'avez trouvé en train d\'entraîner secrètement la fille d\'un noble. Vous avez promis de garder le secret.";
		this.m.BadEnding = "C\'est une honte que, au crépuscule de sa vie, le maître d\'armes %name% ait dû rester dans une compagnie de mercenaires en déclin. Il s\'est retiré, déclarant que physiquement, il était à bout. Vous pensez qu\'il a dit ça juste pour partir plus facilement de la compagnie %companyname%, parce qu\'une semaine plus tard, il a tué dix brigands en puissance sur le bord d\'une route sans verser une goutte de sueur. Aux dernières nouvelles, il entraînait des princes disgracieux à l\'art du combat à l\'épée.";
		this.m.HiringCost = 400;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.huge",
			"trait.weasel",swordmaster
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.paranoid",
			"trait.impatient",
			"trait.clubfooted",
			"trait.irrational",
			"trait.athletic",
			"trait.gluttonous",
			"trait.dumb",
			"trait.bright",
			"trait.clumsy",
			"trait.tiny",
			"trait.insecure",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.hesitant",
			"trait.fragile",
			"trait.iron_lungs",
			"trait.tough",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"the Legend",
			"the Old Guard",
			"the Master"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(3, 5);
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
		return "{%name% se bat comme un poisson s\'entraîne à nager. | %name% n\'est pas seulement le nom d\'un homme, c\'est un mythe. Un nom utilisé à la place de mots comme guerre, combat et mort. | Dire : \"Tu bouges comme %name%\" est peut-être le plus grand honneur qu\'un homme puisse faire à un compagnon de guerre. | %name% est considéré comme l\'un des plus dangereux épéistes à avoir foulé la terre.} {Une grande partie de sa vie est fondée sur le mythe : des histoires comme celle où il a démantelé un royaume en défiant un roi et tous ses gardes en duel - et en les tuant d\'une seule main. | On dit qu\'il a combattu vingt hommes dans son propre jardin, en cueillant et en taillant lentement ses tomates avec la même lame qu\'il utilisait pour tuer. | Certains disent qu\'il a été abandonné en mer pendant trois cents jours et qu\'il y a appris - en se tenant en équilibre sur un morceau d\'épave - comment se déplacer, comment se battre et comment survivre. | Une histoire raconte que sa famille a été assassinée et les coupables jamais retrouvés. Voulant être prêt si il les croisait, il a appris à être bon avec une lame pour pouvoir tuer n\'importe qui. | Élevé par un père manchot, il a d\'abord appris à se battre avec des contraintes. Au moment où il a commencé à utiliser ses deux mains, il en avait besoin que d\'une pour tuer n\'importe qui.} {Malheureusement, le temps et l\'âge ont fait de %name% une coquille vide. | Pendant les invasions orques, %name% a réussi à tuer une douzaine de peaux-vertes à lui tout seul. Malheureusement, il en a payé le prix : sa main dominante a perdu trois doigts et son tendon d\'Achille a été sectionné. | Malheureusement, une horde d\'ivrognes s\'est abattue sur sa maison, chacun espérant devenir célèbre en tuant le célèbre épéiste. Il les a tous tués, mais pas avant d\'avoir subi des blessures irréversibles. | La légende veut qu\'il se soit disputé avec une bête immonde aux proportions démesurées. Il écarte cette idée de sa main estropiée et d\'un clin d\'œil balafré. | Alors qu\'il enseignait à la royauté comment se battre, un coup d\'État qui a balayé tout le royaume l\'a fait fuir pour sauver sa vie. | Engagé pour enseigner les techniques de combat aux héritiers de la noblesse, il n\'a pas tardé à se retrouver mêlé à un réseau d\'intrigues et de coups bas, et a dû partir aussi vite que possible.} {Maintenant, le vieil épéiste cherche juste à utiliser le reste de ses connaissances en matière de combat sur le terrain. | Bien qu\'il ait perdu de son mordant, l\'homme reste très dangereux et certains disent qu\'il cherche à transmettre son savoir avant de mourir. | Il a beau être un maître en arts martiaux, chacun de ses mouvements est accompagné du craquement de ses vieux os. | Dépressif et sans but, %name% trouve maintenant un sens à sa vie en se fondant parmi ses anciens étudiants. | L\'homme fait en sorte qu\'il soit impossible de passer à travers sa défense, contrant tout ce qui lui est présenté, mais il n\'a plus la capacité d\'attaquer en retour. Admirable, mais triste. | Lorsqu\'on lui donne une épée, l\'ancien garde la fait tourner et virevolter dans une démonstration impressionnante. Lorsqu\'il la plante dans le sol, il s\'appuie sur le pommeau pour reprendre son souffle. Pas si impressionnant. | L\'homme a été privé de ses qualités athlétiques, mais ses connaissances ont transformé le combat à l\'épée en mathématiques.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-12,
				-12
			],
			Bravery = [
				12,
				10
			],
			Stamina = [
				-15,
				-10
			],
			MeleeSkill = [
				25,
				20
			],
			RangedSkill = [
				-5,
				-5
			],
			MeleeDefense = [
				10,
				15
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				-10,
				-10
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.SwordmasterTitles[this.Math.rand(0, this.Const.Strings.SwordmasterTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 2);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/noble_sword"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/arming_sword"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/fencing_sword"));
			}
		}
		else
		{
			r = this.Math.rand(0, 1);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/noble_sword"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/arming_sword"));
			}
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}

		if (this.Math.rand(1, 100) <= 33)
		{
			items.equip(this.new("scripts/items/helmets/greatsword_hat"));
		}
	}

});


this.raider_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.raider";
		this.m.Name = "Pillard";
		this.m.Icon = "ui/backgrounds/background_49.png";
		this.m.BackgroundDescription = "Tout pillard qui a survécu jusqu\'ici aura une certaine expertise en matière de combat.";
		this.m.GoodEnding = "Ancien pillard, %name% s\'est bien intégré a la compagnie %companyname% et s\'est révélé un excellent combattant. Ayant économisé une véritable montagne de couronnes, il s\'est retiré de la compagnie et est retourné d\'où il venait. Il a été vu pour la dernière fois naviguant sur une barque vers un petit village.";
		this.m.BadEnding = "Comme la compagnie %companyname% déclinait rapidement, %name% le pillard a quitté la compagnie et est reparti de son côté. Il est retourné au pillage, terrorisant de petits village fluviaux part son extrême violence. On ne sait pas si c\'est vrai, mais on dit qu\'il a été empalé avec une fourche par un garçon d\'écurie. On raconte que la ville a hissé son corps le long des murs extérieurs en guise d\'avertissement aux futurs pillards potentiels.";
		this.m.HiringCost = 160;
		this.m.DailyCost = 28;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Titles = [
			"the Raider",
			"the Marauder",
			"the Terrible",
			"the Bandit",
			"Fourfingers",
			"Ravensblack",
			"the Crow",
			"the Defiant",
			"the Pillager",
			"the Menace"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 4);
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
		return "{%name% vivait sur le rivage, l\'odeur des pillards enivrait son existence. À l\'âge adulte, il s\'est joint à eux pour piller. | Quand sa famille a été massacrée, le nouveau-né %name% a été recueilli par les mêmes pillards qui avaient fait le coup. | Né dans une contrée lointaine, %name% a voyagé jusqu\'ici à la recherche de villes à piller. | Homme robuste venant d\'une contrée lointaine, la présence de %name% ici a été infernale pour les résidents locaux. | Pillard doté d\'un bras et d\'une hache puissante, %name% fait partie du folklore qui empêche les enfants de se lever la nuit. | Mi-guerrier mi-criminel, %name% s\'est fait une belle carrière en tant que pillard. | %name% a décidé, il y a de nombreuses années, de prendre ce qu\'il voulait aux faibles par la force, et depuis, il s\'est fait connaître en pillant les caravanes et les villages. | Enfant pauvre et affamé, %name% s\'est joint aux voleurs et aux égorgeurs par désespoir. Pour la première fois de sa vie, il ne ressentait pas la faim tous les soirs, et il a donc continué à prendre de force aux autres ce dont il avait besoin. Il a appris à se battre et à tuer sans remords, et très vite, il est devenu un monstre. | Portant les bottes d\'un seigneur et la robe déchirée d\'une reine en guise de châle, la tenue de %name% reflète bien ses années de pillages. | La menace qui agite les seigneurs dans leur sommeil et précipite les ménagères sous les lits se nomme %name%. | Les forts prennent aux faibles - c\'est l\'ordre des choses dans lequel vit %name%.} {Lui et ses camarades ont fait des raids sur des caravanes et se sont attaqués à des fermes isolées, mais un jour, ils ont été attaqués pour leur butin de guerre habituel. Une petite bande d\'orcs avait repéré le camp de %name% et l\'avait balayé comme une force de la nature, dispersant les quelques survivants dans toutes les directions. %name% a couru sans regarder derrière lui. | Après de nombreuses années de profits bien mal acquis, l\'homme a abandonné cette vie après le millage d\'un orphélinat qui s\'est terminé par un incendie incontrôlable et la mort de ceux qui s\'y trouvaient. | Fidèle aux anciennes traditions, %name% souhaite mourir en guerrier pour avoir sa place auprès des dieux. Mais massacrer des villageois comme du bétail n\'attirera pas l\'attention des dieux, il cherche donc un plus grand défi. | Mais pendant qu\'il violait et pillait, %name% a remarqué qu\'il avait une préférence pour les maris plutôt que pour les femmes. Ses goûts l\'ont ostracisé du reste de la troupe. | Tout a commencé par un bon raid sur une caravane de marchands. Les quelques gardes ont été rapidement abattus et le marchand en fuite n\'a pas couru assez vite - un javelot dans le dos l\'ayant stoppé net. Le butin était riche, mais il y eut bientôt des discussions animées sur la manière de le partager. Le soir venu, la plupart des pillards s\'étaient entretués. %name% s\'est échappé de justesse et n\'a rien gagné de la journée à part une jambe boiteuse. | Mais il a toujours eu un faible pour les femmes, et les viols et meurtres constants de ses camarades ont éloigné le pillards de ce style de vie. | Capturé par les gardes d\'un seigneur, le pillard s\'est échappé de justesse et a assisté, du haut d\'une colline, à l\'exécution de ses camarades. | Mais un village a tendu une embuscade à son groupe lors d\'un raid, tuant tout le monde sauf lui-même alors qu\'il volait un cheval d\'écurie et échappait à une mort certaine. | Alors qu\'il faisait du repérage dans une forêt, le pillard et son groupe ont été attaqué par des bêtes féroces. Il a donné son propre camarade à manger à ces choses immondes juste pour sauver son propre cou. | Alors que la guerre déchire le monde, le pilleur a réalisé qu\'il y avait de moins en moins de choses à voler. | Alors que les conflits couvent un peu partout, tous les villages qu\'il rencontre sont soit très pauvres, soit déjà armés pour affronter les monstres peuplant le monde.} {Maintenant, %name% veut juste un nouveau départ, même dans le milieu déprimant des mercenaires. | On ne peut pas faire entièrement confiance à %name% en tant que mercenaire, mais le fait d\'avoir côtoyé des brigands et des pillards le rend au moins apte au travail. | L\'homme n\'est pas du tout fraternel, mais il peut manier une arme comme si c\'était l\'un de ses doigts manquants. | Si le passé de %name% laisse un mauvais goût dans la bouche de n\'importe qui, il y a encore pire dehors. | %name% est capable de tuer et de piller, mais assurez-vous que ces compétences soient dirigées vers vos ennemis. | Bien qu\'il soit un bon combattant, %name% est d\'abord et avant tout fidèle au butin. | %name% est ici pour tuer des choses et prendre des choses. Pour toi, c\'est une bonne chose. | %name% porte un collier d\'oreilles autour du cou, et un autre collier orné des boucles d\'oreilles de ces oreilles. Fantaisie quand tu nous tiens. | %name% est un combattant puissant, mais il est en bonne voie pour être la personne la moins aimée de tout votre groupe. | La campagne est un cadre verdoyante et séduisante sur laquelle on peut bâtir sa vie. Peut-être que le pillard veut juste s\'installer. | Portant des vêtements imprégnés du sang de leur ancien propriétaire, %name% a l\'air étonnamment prêt pour le travail. | On a l\'impression que %name% porte des vêtements dans lesquels quelqu\'un a probablement été assassiné.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 40)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				0,
				-3
			],
			Stamina = [
				2,
				0
			],
			MeleeSkill = [
				12,
				10
			],
			RangedSkill = [
				5,
				0
			],
			MeleeDefense = [
				6,
				5
			],
			RangedDefense = [
				6,
				5
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
		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/morning_star"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/military_pick"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}

		r = this.Math.rand(0, 0);

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
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/dented_nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_rusty_mail"));
		}
	}

});


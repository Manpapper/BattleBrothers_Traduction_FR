this.historian_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.historian";
		this.m.Name = "Historien";
		this.m.Icon = "ui/backgrounds/background_47.png";
		this.m.BackgroundDescription = "Les historiens sont des individus studieux qui possèdent une grande quantité de connaissances, mais qui ne sont d\'aucune utilité sur le champ de bataille.";
		this.m.GoodEnding = "Vous ne vous attendiez pas à ce que l\'historien, %name%, reste éternellement dans la compagnie. Il a fini par partir et on dit qu\'il a emporté avec lui un grand nombre de parchemins. Il s\'avère qu\'il compilait une liste de toutes les succès de la compagnie %companyname% . Il a créé un codex de tous ses accomplissements, inscrivant le nom de tous les mercenaires dans les livres d\'histoire pour les générations futures. Vous espérez qu\'ils apprennent quelque chose de vos agissements.";
		this.m.BadEnding = "La compagnie %companyname% a poursuivi son déclin et de nombreux non combattants, comme %name% l\'historien, ont considéré que c\'était le bon moment pour partir. Vous avez essayé de suivre ces hommes, mais l\'historien était particulièrement facile à trouver: il a laissé une trace écrite. Vous avez cherché l\'homme, demandant aux scribes s\'ils avaient entendu parler de lui. Ils ont dit qu\'il n\'était qu\'un petit homme écrivant un livre sur la noirceur, la violence et l\'inutilité de la vie d\'un mercenaire.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_beasts",
			"trait.paranoid",
			"trait.impatient",
			"trait.iron_jaw",
			"trait.dumb",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty",
			"trait.iron_lungs",
			"trait.irrational",
			"trait.cocky",
			"trait.dexterous",
			"trait.sure_footing",
			"trait.strong",
			"trait.tough",
			"trait.superstitious",
			"trait.spartan"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue
		];
		this.m.Titles = [
			"the Owl",
			"the Studious",
			"the Historian"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
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
				id = 13,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] Experience Gain"
			}
		];
	}

	function onBuildDescription()
	{
		return "{Lecteur vorace depuis toujours, %name% a passé de longues nuits dans la bibliothèque de %randomcity%. | Brimé par ses camarades plus forts, le jeune %name% s\'est retiré dans le monde des livres. | Cherchant d\'où vient l\'Homme, %name% a lu des livres et étudié la nature humaine. | Avec tant de changements dans le monde, %name% a décidé d\'aider à les archiver. | Lecteur assidu et doté d’un esprit vif, %name% s’efforçait de coucher sur papier l’histoire du monde connu au service des autres. | Élève d\'une petite université de %randomcity%, %name% archive les histoires du monde pour les générations futures. | Refroidi par de sombres événements dans le monde, %name% a cessé d\'étudier les végétaux et a commencé à archiver l\'histoire humaine.} {Un historien digne de ce nom cherche les sources les plus crédibles qu\'il puisse trouver, ce qui l\'a amené à fréquenter des mercenaires. | Après que des brigands aient ruiné ses œuvres écrites, l\'homme a enfilé ses bottes pour mener de nouvelles recherches - à titre personnel. | Lorsque son professeur a déclaré que ses recherches étaient nulles, l\'historien est parti à la découverte du monde pour prouver qu\'il avait tort. | Accusé de plagiat, l\'historien a été mis à la porte du monde universitaire. Il cherche la rédemption dans le monde de ce qu\'il a étudié : la guerre. | Profitant de sa position dans le monde universitaire pour coucher avec des femmes, d\'éventuels scandales et controverses ont poussé l\'historien à quitter son domaine et l\'ont laissé sans le sou, prêt à accepter n\'importe quel emploi. | Lassé de lire des histoires d\'aventuriers, l\'historien s\'est dit qu\'il allait commencer à croquer la vie à pleine dent, en changeant son mode vestimentaire pour commencer. | Avec tant de groupes de mercenaires gravitant autour de lui, l\'historien a cherché à s\'y intégrer pour apprendre ce qu\'est la vie.} {%name% n\'a pas grand-chose en commun avec les vrais soldats, mais son esprit imaginatif a pu lui faire entrevoir ce qu\'est une vraie bataille. | Si %name% a passé toute sa vie à écrire, il n\'en a passé aucune à se battre. Jusqu\'à maintenant. | %name% fourmille à l\'idée de consigner les voyages de votre équipe. Il peut vous aider en prenant une épée et une armure. | %name% porte un sac de livre sur son épaule. Vous suggérez un fléau en remplacement. C\'est similaire, mais plus pointu et plus tranchant. | On trouve souvent %name% en train de griffonner des notes car il voit toujours le monde avec l\'œil d\'un chercheur. | %name% vient avec une poche pleine de plumes d\'oie. Les plumes feraient de très bonnes flèches. | Vous pouvez avoir confiance en la volonté sincère de %name% de faire des recherches, mais peut-être pas autant en sa capacité à manier l\'épée. | Le temps passé par %name% avec l\'équipe est destiné à développer une théorie, mais pourra-t-il survivre aux expériences? | Vous promettez à %name% que s\'il meurt, vous trouverez un moyen de faire durer sa mémoire. Il vous remercie et vous remet son testament. Il est écrit dans une langue qui vous est étrangère et vous ne pouvez absolument rien lire. Vous lui souriez quand même.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-2,
				-5
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				-5,
				-5
			],
			MeleeSkill = [
				-5,
				-5
			],
			RangedSkill = [
				-3,
				-2
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
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 1.15;
	}

});


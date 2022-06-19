this.historian_southern_background <- this.inherit("scripts/skills/backgrounds/historian_background", {
	m = {},
	function create()
	{
		this.historian_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 90;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{Lecteur vorace depuis toujours, %name% a passé de longues nuits dans la bibliothèque de %randomcity%. | Brimé par ses camarades plus forts, le jeune %name% s\'est retiré dans le monde des livres. | Cherchant d\'où vient l\'Homme, %name% a lu des livres et étudié la nature humaine. | Avec tant de changements dans le monde, %name% a décidé d\'aider à les archiver. | Lecteur assidu et doté d’un esprit vif, %name% s’efforçait de coucher sur papier l’histoire du monde connu au service des autres. | Élève d\'une petite université de %randomcity%, %name% archive les histoires du monde pour les générations futures. | Refroidi par de sombres événements dans le monde, %name% a cessé d\'étudier les végétaux et a commencé à archiver l\'histoire humaine.} {Un historien digne de ce nom cherche les sources les plus crédibles qu\'il puisse trouver, ce qui l\'a amené à fréquenter des mercenaires. | Après que des brigands aient ruiné ses œuvres écrites, l\'homme a enfilé ses bottes pour mener de nouvelles recherches - à titre personnel. | Lorsque son professeur a déclaré que ses recherches étaient nulles, l\'historien est parti à la découverte du monde pour prouver qu\'il avait tort. | Accusé de plagiat, l\'historien a été mis à la porte du monde universitaire. Il cherche la rédemption dans le monde de ce qu\'il a étudié : la guerre. | Profitant de sa position dans le monde universitaire pour coucher avec des femmes, d\'éventuels scandales et controverses ont poussé l\'historien à quitter son domaine et l\'ont laissé sans le sou, prêt à accepter n\'importe quel emploi. | Lassé de lire des histoires d\'aventuriers, l\'historien s\'est dit qu\'il allait commencer à croquer la vie à pleine dent, en changeant son mode vestimentaire pour commencer. | Avec tant de groupes de mercenaires gravitant autour de lui, l\'historien a cherché à s\'y intégrer pour apprendre ce qu\'est la vie.} {%name% n\'a pas grand-chose en commun avec les vrais soldats, mais son esprit imaginatif a pu lui faire entrevoir ce qu\'est une vraie bataille. | Si %name% a passé toute sa vie à écrire, il n\'en a passé aucune à se battre. Jusqu\'à maintenant. | %name% fourmille à l\'idée de consigner les voyages de votre équipe. Il peut vous aider en prenant une épée et une armure. | %name% porte un sac de livre sur son épaule. Vous suggérez un fléau en remplacement. C\'est similaire, mais plus pointu et plus tranchant. | On trouve souvent %name% en train de griffonner des notes car il voit toujours le monde avec l\'œil d\'un chercheur. | %name% vient avec une poche pleine de plumes d\'oie. Les plumes feraient de très bonnes flèches. | Vous pouvez avoir confiance en la volonté sincère de %name% de faire des recherches, mais peut-être pas autant en sa capacité à manier l\'épée. | Le temps passé par %name% avec l\'équipe est destiné à développer une théorie, mais pourra-t-il survivre aux expériences? | Vous promettez à %name% que s\'il meurt, vous trouverez un moyen de faire durer sa mémoire. Il vous remercie et vous remet son testament. Il est écrit dans une langue qui vous est étrangère et vous ne pouvez absolument rien lire. Vous lui souriez quand même.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});


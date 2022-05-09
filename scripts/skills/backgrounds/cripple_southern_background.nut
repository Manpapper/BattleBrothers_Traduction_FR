this.cripple_southern_background <- this.inherit("scripts/skills/backgrounds/cripple_background", {
	m = {},
	function create()
	{
		this.cripple_background.create();
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
	}

	function onBuildDescription()
	{
		return "%name% {boitille vers vous comme un chien galeux | vous salue avec une main à laquelle il manque de nombreux doigts | vous sourit avec un sourire édenté | a la posture avachie d\'un homme au dos cassé | vacille sur deux jambes très raides, peut-être même en bois | utilise une canne pour marcher vers vous | rampe d\'abord vers vous, puis se lève avec la grâce d\'un ivrogne sur les marches d\'une église. | a des os qui grincent et craquent à chaque pas | a un bras en écharpe et une canne en guise d\'appui pour une de ses jambes | a un nez cassé et deux yeux noircis | ressemble à quelqu\'un qu\'on a essayé de scalper et de brûler vif | a une chair qui sent le mi-cuit, ses yeux grimacent à chaque pas qu\'il fait vers vous | il lui manque deux oreilles, mais les trous entendent toujours | pue la merde et l\'urine | a un œil en moins, et l\'autre vagabonde fortement | a deux yeux paresseux et un sourire mauvais, plein de trous}. Il explique qu\'{qu\'il était autrefois maçon, mais qu\'il a été attaqué par un fou qui essayait de reproduire son travail | il a autrefois revêtu l\'armure d\'un chevalier, mais ce cruel destin lui a tout pris | il était autrefois un noble, mais son vocabulaire pauvre suggère que c\'est peut-être un mensonge | il a été colporteur un jour, mais la vente d\'un sentier a fini par le mettre à la merci d\'une foule en colère | il a fait partie d\'un culte, mais quand il s\'est enfui, ils l\'ont puni pour ça | il était autrefois un moine, mais {des cultistes ont attaqué son église | une prise de bec avec d\'autres moines l\'a fait sévèrement punir | des brigands l\'ont attaqué pour avoir crucifié un des leurs} | il se battait pour les seigneurs, mais un passage à tabac par d\'autres combattants l\'a laissé infirme | il parcourait le pays pour des tournois de joutes, mais un mauvais tournoi s\'est terminé avec lui étant horriblement estropié | il pillait des tombes, mais quand il s\'est fait prendre, un paroissien lui a cassé plus d\'os qu\'il n\'en connaissait sur un squelette | il s\'est adonné {aux arts arcaniques | à la nécromancie} mais, comme le montre son état de mort imminente, cette expérience ne lui a pas réussi | il était autrefois un joueur prospère, mais il s\'avère que ne pas rembourser ses dettes est mauvais pour les affaires - et pour les os | il chantait autrefois comme ménestrel, mais quand sa voix s\'est éteinte au milieu de la chanson, un seigneur l\'a brutalement torturé | il avait l\'habitude d\'attraper des rats pour vivre, mais apparemment un rat géant lui a rendu une visite vengeresse dans la nuit | il a servi une fois un seigneur, mais après avoir fait tomber une assiette de nourriture, il a été envoyé dans les cachots où il a été rapidement oublié pendant des années | il a tué un homme, certes, mais il méritait un meilleur sort que la torture qu\'il a reçue en guise de punition | il chassait les sorcières, mais une cruelle maîtresse lui a fait boire une concoction qui l\'a rendu infirme | il a déserté une fois une armée et, évidemment, s\'est fait attraper | il jonglait pour la royauté jusqu\'à ce qu\'il tombe accidentellement dans les escaliers au milieu d\'une cascade. Les marches se sont avérées plutôt difficiles à manipuler pour ses os, semble-t-il | il est né avec une horrible déformation | son père l\'a brutalement attaqué parce qu\'il ne se comportait à la hauteur de son image | sa mère l\'a marqué avec des tortures sans fin | ses frères et sœurs l\'ont torturé toute sa vie}. {Cet homme a l\'air si faible qu\'on peut presque voir son enveloppe mortelle s\'échapper. | L\'embaucher serait presque certainement signer sa mort. Quelle miséricorde ! | Vous ne voulez pas avoir l\'air d\'engager n\'importe qui, mais si ce type n\'est personne, est-ce que ça compte quand même comme \"n\'importe qui\" ? | Vous avez vu des morts plus beaux que cet homme. | Ce type est un repas de loup sur deux jambes. | La bonne nouvelle, c\'est que s\'il revient d\'entre les morts, il ne devrait pas être trop difficile de le faire tomber une seconde fois. | Les rêves et les objets inanimés sont plus menaçants que ce pauvre type. | Pour être honnête, vous préféreriez engager un enfant, mais apparemment les gens n\'apprecient pas ça, alors vous êtes ici à la place. | Et vous pensiez que %randombrother% sentait mauvais. | Engager un tel homme ferait tourner la tête de n\'importe qui. | Oh, allez, regardez-le ! %companyname% a-t-elle vraiment besoin de corps chauds ? | Engager cet homme ne serait pas juste. Peu importe, c\'est parti. | Une paire de béquilles a plus de valeur que ce pauvre homme. | Cet homme est dans un tel état qu\'il peut faire le mort debout.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			local item = this.new("scripts/items/helmets/oriental/nomad_head_wrap");
			item.setVariant(16);
			items.equip(item);
		}
	}

});


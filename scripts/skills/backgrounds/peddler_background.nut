this.peddler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.peddler";
		this.m.Name = "Colporteur";
		this.m.Icon = "ui/backgrounds/background_19.png";
		this.m.BackgroundDescription = "Les colporteurs ne sont pas habitués aux travaux physiques difficiles ou à la guerre, mais ils excellent dans le marchandage dans le but d\'obtenir de bons prix.";
		this.m.GoodEnding = "Homme de commerce, le colporteur n\'a pas pu se battre longtemps. Il a finalement quitté la compagnie %companyname% pour se lancer dans sa propre entreprise. Récemment, vous avez appris qu\'il vendait des bibelots portant le sigle de la compagnie. Vous lui avez spécifiquement dit qu\'il pouvait faire tout ce qu\'il voulait sauf ça, mais apparemment votre avertissement n\'a fait que l\'encourager à le faire. Quand vous avez voulu lui dire d\'arrêter, il a fait claquer une sacoche remplie de couronnes sur sa table et disant que c\'était votre \"part\". Encore aujourd\'hui, il continue de vendre ses babioles.";
		this.m.BadEnding = "Les temps difficiles frappant la compagnie %companyname%, de nombreux frères ont jugé bon de retourner à leur ancienne vie. %name% le colporteur est lui aussi parti. Aux dernières nouvelles, il s\'est fait tabasser en essayant de vendre des marchandises \"tombées du wagon\" au marchand auquel elles appartenaient à l\'origine.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.iron_jaw",
			"trait.clubfooted",
			"trait.brute",
			"trait.athletic",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dexterous",
			"trait.dumb",
			"trait.deathwish",
			"trait.bloodthirsty"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Thick;
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
		return "{D\'une maison à l\'autre, | Autrefois un fier marchand, maintenant | Une nuisance pour la plupart, | Dans les moments difficiles, tout le monde doit s\'en sortir d\'une manière ou d\'une autre. | Non pas un homme de commerce, mais plutôt le commerce lui-même,} %name% est un simple colporteur. {Il dansera, chantera, se vantera et jouera au roi, dans le seul but de faire cette vente. | Exigeant et inflexible, sa ténacité est remarquable. | Il essaiera de vendre un seau rouillé pour un casque porté par les rois. Cet homme est prêt à vendre n\'importe quoi. | Cet homme va vous vendre des objets que vous ne vouliez même pas à la base. Pas de remboursement, cependant. | Il avait l\'habitude de gagner sa vie en vendant {des chariots usagés | des casseroles, poêles et bocaux}, jusqu\'à ce qu\'une concurrence féroce le pousse à la faillite - en lui cassant le bras.} {Se vendre est ce que cet homme frêle fait de mieux, bien que peu de gens croient son discours sur \"l\'art de l\'épée et le courage résolu\". | Il est censé distribuer des \"coupons\" pour ses services, quels qu\'ils soient. Mais il n\'est pas cher, et n\'importe quelle entreprise de nos jours a besoin d\'un corps chaud, quelle que soit sa valeur réelle. | S\'il est recruté, il promet que vous aurez une réduction spéciale sur une potion améliorant la virilité. | L\'homme baisse la voix et vous dit qu\'il a une bonne affaire concernant des pointes de flèches rouillées, juste pour vous. Il a l\'air déçu par votre manque d\'intérêt. | Cet homme connaît un homme qui connaît un homme qui connaît un homme. Ces trois inconnus sont potentiellement meilleurs que lui au combat. | C\'est dommage qu\'un homme ne puisse pas se battre avec ses mots de nos jours. %name% serait inarrêtable.}";
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
				0
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				-10,
				-9
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				2,
				7
			],
			RangedDefense = [
				2,
				7
			],
			Initiative = [
				0,
				7
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
			actor.setTitle(this.Const.Strings.PeddlerTitles[this.Math.rand(0, this.Const.Strings.PeddlerTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

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

});


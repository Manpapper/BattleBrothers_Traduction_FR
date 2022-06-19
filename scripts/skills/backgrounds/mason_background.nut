this.mason_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.mason";
		this.m.Name = "Maçon";
		this.m.Icon = "ui/backgrounds/background_17.png";
		this.m.BackgroundDescription = "Un bon maçon est habitué au travail physique et étudie pour améliorer son métier.";
		this.m.GoodEnding = "La maçonnerie a son degré de fascination, notamment celui de pierres parfaitement taillées et de tours impossibles qui défient la capacité de l\'œil à les façonner rien qu\'en les regardants. Le maçon %name% est revenu à son ancien métier et, avec tout l\'argent qu\'il avait gagné avec la compagnie %companyname%, il a lancé une entreprise réputée pour sa capacité à construire des pièces en pierre qui conservaient la chaleur pendant les hivers et la fraîcheur pendant les étés.";
		this.m.BadEnding = "La compagnie %companyname% a continué à subir des pertes longtemps après votre départ. De plus en plus de frères ont quitté la compagnie, et bon nombre d\'entre eux ont repris leurs anciens métiers. %name% le maçon a fait la même chose. Malheureusement, tout le temps passé à se battre avait détruit l\'assise qu\'il lui restait. Avec des mains qui n\'arrêtent pas de trembler, il ne peut plus façonner les pierres comme avant. Aux dernières nouvelles, il transportait des pierres en tant qu\'ouvrier payé à la journée au lieu de les façonner en tant que maçon.";
		this.m.HiringCost = 90;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.athletic",
			"trait.asthmatic",
			"trait.dumb",
			"trait.clumsy",
			"trait.bloodthirsty"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
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
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] Experience Gain"
			}
		];
	}

	function onBuildDescription()
	{
		return "{Ayant grandi dans le quartier de %townname%, %name% a passé sa jeunesse à étudier les livres de bricolage avec sérieux. | Élevé par une guilde de commerçants, l\'ascension rapide de %name% dans le domaine de la maçonnerie n\'a guère surpris. | Étudiant de la prestigieuse université de %randomtown%, %name% a obtenu son diplôme avec brio, et des rêves encore plus fous en tête. | Avec un père maçon, l\'entrée de %name% dans la maçonnerie n\'a été que la plus petite des étapes. | Émerveillé par les structures royales de l\'église et de l\'État, %name% est tombé amoureux de la maçonnerie. | Lorsque %randomtown% a eu un besoin urgent de murs défensifs, %name% s\'est mis à la maçonnerie comme une évidence.} {Malheureusement, son temps en tant que maçon a été de courte durée. Une église qu\'il a construite s\'est effondrée et de ses ruines est sortie une foule meurtrière cherchant à se venger. | Cinq bâtiments construits, cinq bâtiments démolis. Les guerres sans fin ont rendu la vocation de l\'homme impossible. | Trahi par un collègue architecte, le maçon a emmuré son rival dans les murs de son prochain projet. Il n\'a pas fallu longtemps pour que les gens commencent à poser des questions. | Alors qu\'il travaillait sur le toit, l\'homme a fait un faux pas et est tombé. Les blessures qui ont suivi l\'ont forcé à quitter son chantier. | Mais quand un seigneur lui demande de construire un terrifiant donjon, le maçon refuse. il est maintenant banni partout où il va. | Un plan de construction égaré a fait que le maçon a construit le temple des Davkulians et non celui des Davkuliads. Maintenant il dit que les dieux eux-mêmes sont après lui.} {Remplaçant son marteau et son ciseau par une épée, %name% travaille désormais dans le domaine du mercenariat. | Un jour, une affiche pour une troupe de mercenaires se formant a attiré son attention. Tout comme ses anciennes constructions, le reste appartient à l\'histoire. | Des années de maçonnerie ont rendu l\'homme apte à une vie de sang et de boue. | %name% trouve quelque chose à redire à chaque bâtiment qu\'il croise. Espérons qu\'il puisse être aussi minutieux sur un champ de bataille.}";
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
				5,
				5
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

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.MasonTitles[this.Math.rand(0, this.Const.Strings.MasonTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.new("scripts/items/armor/linen_tunic"));
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 1.05;
	}

});


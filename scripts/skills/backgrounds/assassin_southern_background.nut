this.assassin_southern_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.assassin_southern";
		this.m.Name = "Tueur";
		this.m.Icon = "ui/backgrounds/background_53.png";
		this.m.BackgroundDescription = "Un assassin doit être agile et habile dans l\'utilisation des armes.";
		this.m.GoodEnding = "%name% l\'assassin a quitté la	compagnie %companyname% avec un grand coffre d\'or et a voyagé très loin. D\'après les rumeurs que vous avez entendues, il a construit un château dans les montagnes à l\'est des royaumes du sud. Vous ne savez pas si c\'est vrai, mais il y a eu une augmentation constante des morts chez les vizirs et les seigneurs ces derniers temps.";
		this.m.BadEnding = "%name% a disparu peu de temps après votre retraite de %companyname%. L\'assassin ne veut probablement pas être trouvé et on ne peut pas savoir où il est. Dans des moments d\'honnêteté, vous dites aux autres que vous auriez préféré ne pas l\'avoir engagé du tout. Il vous traque et vous chasse, cette terreur ne vous quitte plus, et vous passez de nombreuses nuits avec un seul œil ouvert, à la recherche de l\'homme en noir avec la dague tordue.";
		this.m.HiringCost = 800;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.huge",
			"trait.weasel",
			"trait.teamplayer",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.dumb",
			"trait.loyal",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.brute",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue
		];
		this.m.Titles = [
			"the Shadow",
			"the Assassin",
			"the Insidious",
			"the Backstabber",
			"the Unseen",
			"the Murderer",
			"the Dagger",
			"the Elusive"
		];
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.SouthernYoung;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
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
		return "{Au premier abord, on ne le croirait pas, mais %name% ressemble à n\'importe quel autre homme. Ordinaire. Juste un homme ordinaire. | {Mais %name% ressemble presque au moule de tous les hommes que vous avez rencontrés réunis. Il a un visage dont tu ne te souviendrais jamais. | Il a un sourire et un comportement doux. Il parle à tous les autres sur un pied d\'égalité, soupesant les opinions des riches et des pauvres, apparemment pour se mesurer à eux. | %name% n\'offre rien qui puisse susciter un second regard. Il est tout à fait simple, et tout à fait un homme destiné à faire partie de ce monde.} {Bien sûr, c\'est à dessein. C\'est un assassin envoyé par une guilde de tueurs entraînés. Un parchemin qu\'il porte suggère, sans menace, que vous le preniez à votre service. | Cette existence sans prétention est un visage formé pour un homme qui est, en réalité, un assassin entraîné portant une dague Qatal unique de sa guilde. | Ce visage fade cache un passé meurtrier, car l\'homme porte une dague Qatal donnée uniquement aux meilleurs tueurs de l\'une des guildes d\'assassins du Sud. | Mais le visage de l\'étranger familier est une mise en scène destinée à cacher le fait qu\'il s\'agit d\'un homme d\'une guilde d\'assassins envoyé pour des raisons que vous ne connaîtrez jamais.} {%name% pourrait se trouver juste à côté de vous, mais avoir l\'impression d\'avoir disparu dans une foule de deux personnes. | Bien que tu n\'aies jamais rencontré cet homme jusqu\'à présent, tu ne peux t\'empêcher de penser que tu as déjà vu %name% quelque part. | Vous vous sentez naturellement à l\'aise en présence de %name%, ce qui ressemble presque à un piège en soi, alors vous vous forcez à rester vigilant en sa présence.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				10,
				10
			],
			Stamina = [
				-5,
				-5
			],
			MeleeSkill = [
				10,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				20,
				15
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
			items.equip(this.new("scripts/items/weapons/oriental/qatal_dagger"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/tools/smoke_bomb_item"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/tools/daze_bomb_item"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/assassin_robe"));
		}

		items.equip(this.new("scripts/items/helmets/oriental/assassin_head_wrap"));
	}

});


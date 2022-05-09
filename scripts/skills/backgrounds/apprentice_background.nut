this.apprentice_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.apprentice";
		this.m.Name = "Apprenti";
		this.m.Icon = "ui/backgrounds/background_40.png";
		this.m.BackgroundDescription = "Les apprentis ont tendance à être avides de connaissances et à apprendre plus vite que les autres.";
		this.m.GoodEnding = "Perhaps one of the sharpest men you\'ve ever met, %name% the apprentice was the quickest learner in the %companyname%. With plenty of crowns stored, he retired from fighting to take his talents to the business world. Last you heard he was doing very well for himself across multiple trades. If you ever have a son, this. is the man you\'ll send him to for apprenticeship.";
		this.m.BadEnding = "%name% the apprentice was, by far, the quickest learner in the %companyname%. Little surprise then that he was also one of the quickest to recognize its inevitable downfall and leave while he still could. Had he been born in a different time he would have gone on to do great things. Instead, many wars, invasions, and plagues spreading across the land ultimately ensured %name% and many other talented men went to total waste.";
		this.m.HiringCost = 90;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.dumb",
			"trait.clumsy",
			"trait.asthmatic",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Learner",
			"Quickmind",
			"the Apprentice",
			"the Understudy",
			"Goodhand",
			"the Student",
			"the Young",
			"the Kid",
			"the Bright"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.YoungMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Experience Gain"
			}
		];
	}

	function onBuildDescription()
	{
		return "{On entre dans le monde en cherchant toujours à être le meilleur possible, la maîtrise d\'un art est prestigieuse, tout le monde admire les meilleurs, mais personne n\'y arrive en un instant. | alors quel meilleur moyen d\'être le meilleur que d\'apprendre sous un autre ? | Et ce n\'est pas un secret que la plupart des gens attendent l\'aide des maîtres.} {%name% pensait la même chose, prenant le rôle d\'un apprenti dans %townname%. | Croyant que c\'était vrai, %name% a pris le rôle d\'un apprenti dans %townname%. | Lorsque le collège de %randomtown% demande des apprentis, %name% est le premier à s\'inscrire. | Pressé par ses parents d\'améliorer son métier, %name% a voulu commencer sa carrière en tant qu\'apprenti. | Pour ne pas être en reste par rapport à son frère, %name% a commencé à chercher un apprentissage.} {Malheureusement, son maître était mal choisi : un charpentier fou qui avait tendance à couper l\'encolure au lieu de la ligne des arbres. Fuyant le malheur imminent par association, %name% s\'est retrouvé en compagnie d\'épées. | En apprenant tout ce qu\'il pouvait, %name% a construit la plus grande oeuvre d\'art jamais vue dans le domaine de la vannerie sous-marine. Son maître, cependant, était un jaloux. Pour ne pas être surpassé par un élève, il a brûlé le projet en cendres et en fumées. C\'était clair pour %name% : il pouvait apprendre vite, mais il y avait peut-être de meilleurs maîtres sous lesquels étudier. | Il avait absorbé tout ce qu\'il y avait à apprendre : maçonnerie, charpenterie, forge, amour. Maintenant il tourne ses yeux vers les arts martiaux. Bien qu\'il ne soit pas encore un guerrier, %name% apprend vite.}";
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

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/apron"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 1.1;
	}

});


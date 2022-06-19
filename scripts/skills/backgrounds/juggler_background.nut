this.juggler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.juggler";
		this.m.Name = "Jongleur";
		this.m.Icon = "ui/backgrounds/background_14.png";
		this.m.BackgroundDescription = "Les jongleurs doivent avoir de bons réflexes et une bonne coordination œil-main pour excercer leur profession.";
		this.m.GoodEnding = "%name% le jongleur a pris tout son argent de mercenaire et a monté une troupe itinérante d\'artistes. Aux dernières nouvelles, il a monté un théâtre entier et joue une nouvelle pièce par mois !";
		this.m.BadEnding = "%name% le jongleur s\'est retiré des combats. Il se produisait pour un noble prétentieux dans  { le sud | le nord | l\'est | l\'ouest} quand un numéro a mal tourné. A cause de son erreur, on dit qu\'il a été jeté d\'une tour, mais vous préférez ne pas y croire.";
		this.m.HiringCost = 75;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.clubfooted",
			"trait.brute",
			"trait.clumsy",
			"trait.tough",
			"trait.strong",
			"trait.short_sighted",
			"trait.dumb",
			"trait.hesitant",
			"trait.deathwish",
			"trait.insecure",
			"trait.asthmatic",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Juggler",
			"the Jester",
			"the Fool"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
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
				id = 15,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "Higher Chance To Hit Head"
			}
		];
	}

	function onBuildDescription()
	{
		return "{Grâce à l\'enseignement de son demi-frère, %name% s\'est mis à jongler comme un marin utilise ses rames. | Bien que méprisé par ses pairs, %name% a toujours aimé jongler. | Une troupe de bouffons a rendu visite à %name%, il a été charmé et a reçu un enseignement par un homme particulièrement intéressant: un jongleur. | Fils d\'un seigneur local, l\'obsession embarrassante de %name% pour la jonglerie et le divertissement l\'a fait exclure de la lignée familiale. | %name% ne jonglait pas pour le plaisir, mais pour recevoir les rires et les applaudissements d\'un public.} {Malheureusement, il n\'y a pas beaucoup de gens à divertir quand la guerre ravage le pays. | Mais les foules et les couronnes sont rares dans un pays de misère et de souffrance. | Mais un accident de jonglage impliquant des herminettes et un enfant royal a fait fuir l\'artiste. | Si doué pour manier épées et poignards, il ne tarde pas à être accusé de sorcellerie et a dû s\'éloigner de sa passion. | Malheureusement, les talents de jongleur de %name% ont suscité la jalousie de ses collègues bouffons. Ils ont conspiré contre lui - et ses pauvres poignets. | Quand un assassin a tué le seigneur qu\'il divertissait, le jongleur a été le premier à être accusé. Il a échappé de justesse à la mort.} {Aujourd\'hui, %name% cherche une nouvelle voie, même si la mort elle-même est devenue son public. | Maintenant, %name% trouve du répit en compagnie d\'hommes tout aussi malchanceux. | Grâce à sa dextérité et à sa rapidité, %name% ne devrait avoir aucun problème à atteindre ses objectifs. | Jonglant avec des couteaux les yeux fermés, %name% sait exactement où lancer chaque lame. | Il y a bien plus d\'argent à gagner en tuant qu\'en étant jongleur, une triste réalité que %name% a fini par accepter.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
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
				3,
				3
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
				12,
				10
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/jesters_hat"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.HitChance[this.Const.BodyPart.Head] += 5;
	}

});


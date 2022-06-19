this.miller_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.miller";
		this.m.Name = "Meunier";
		this.m.Icon = "ui/backgrounds/background_05.png";
		this.m.BackgroundDescription = "Un meunier est habitué au travail physique.";
		this.m.GoodEnding = "%name% l\'ancien meunier est resté avec la compagnie %companyname% pendant un certain temps, collectant assez de couronnes pour démarrer sa propre boulangerie. Aux dernières nouvelles, ses desserts en forme d\'épée ont eu du succès auprès de la noblesse et il gagne plus d\'argent en leur vendant qu\'en travaillant pour la compagnie.";
		this.m.BadEnding = "Comme la compagnie %compagnie% a connu des temps difficiles, %name% le meunier a jugé bon de partir tant qu\'il pouvait encore marcher. Il a aidé un noble à tester une nouvelle façon de moudre les grains avec des mules et des roues à eau travaillant ainsi en tandem. Malheureusement, en \"aidant\", il a réussi à tomber dans l\'engin et a été brutalement écrasé à mort.";
		this.m.HiringCost = 65;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.bright",
			"trait.cocky",
			"trait.quick",
			"trait.fragile",
			"trait.greedy",
			"trait.sure_footing",
			"trait.deathwish",
			"trait.dexterous",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Miller"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{La vie de meunier a toujours manqué à %name%, mais le dur labeur l\'a empêché de faire de grands projets. | Poursuivant la tradition familiale, %name% a appris le métier de meunier auprès de son père. | Bien qu\'il ne soit qu\'un simple meunier, %name% a toujours rêvé de parcourir le monde et de rapporter des contes et des poches pleines de couronnes. | Étant un homme simple, %name% n\'avait pas peur de travailler dur à l\'usine tous les jours. | %name% a toujours été plus ambitieux que les autres. Alors que son frère se contentait de diriger le moulin de la famille, il ne pouvait se défaire du sentiment qu\'il était destiné à plus.} {Une nuit, il a été réveillé par un violent orage. Se précipitant dehors, %name% a réalisé que son moulin avait été enflammé par la foudre. | Quand il a surpris sa femme promise au lit avec un autre homme, il était furieux et les a frappés tous les deux avec une pluie de coups. Ses poings étaient meurtris, les gens criaient après lui, mais la seule chose qu\'il ressentait était un vide là où se trouvait son cœur. Comme dans un rêve, il a rapidement préparé ses affaires et est parti, pour ne jamais revenir. | Lorsque sa jeune et jolie épouse a été retrouvée morte, déchiquetée par des bêtes sauvages dans les bois, il n\'a pas dit un mot. En silence, il a fait ses bagages et est parti à la découverte du monde, pour commencer une nouvelle vie quelque part loin d\'ici. | Après avoir entendu les histoires folles d\'un chevalier errant dans la taverne de %townname%, son imagination s\'est emballée avec toutes les possibilités qui l\'attendaient. | En raison d\'une sécheresse, les affaires tournaient au ralenti pour lui. Lorsque %name% n\'a plus été en mesure de payer ses dettes, sa vie a été menacée par d\'impitoyables collecteurs d\'argent. Il a dû disparaître.} {Se souvenant de son cousin, %randomname%, qui a réussi à gagner sa vie dans le commerce des mercenaires, %name% a décidé de faire de même. | En cherchant des opportunités, il a rencontré un recruteur de mercenaires qui lui a promis la gloire et la fortune. | Bien qu\'il ne connaisse rien au combat, %name% est impatient de s\'engager dans une compagnie de mercenaires, séduit par la promesse d\'une aventure. | Que ce soit par manque d\'alternatives ou par sa propre volonté, %name% se tient devant vous maintenant, prêt à jurer fidélité.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				3,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				8,
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

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}
	}

});


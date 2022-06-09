this.companion_ranged_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.companion";
		this.m.Name = "Compagnon";
		this.m.Icon = "ui/traits/trait_icon_32.png";
		this.m.HiringCost = 0;
		this.m.DailyCost = 14;
		this.m.DailyCostMult = 1.0;
		this.m.Excluded = [
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.hate_greenskins",
			"trait.huge",
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.paranoid",
			"trait.night_blind",
			"trait.impatient",
			"trait.asthmatic",
			"trait.greedy",
			"trait.clubfooted",
			"trait.dumb",
			"trait.fragile",
			"trait.short_sighted",
			"trait.disloyal",
			"trait.drunkard",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.dastard",
			"trait.insecure",
			"trait.hesitant"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.MeleeSkill,
			this.Const.Attributes.MeleeDefense
		];
		this.m.GoodEnding = "Du tout début jusqu\'à votre retraite, %name% était avec vous, quittant la compagnie peu de temps après votre départ. Mais il n\'en avait pas encore fini avec la vie de combattant et a commencé à se battre pour une autre compagnie - la sienne. Ayant tant appris sous votre direction, il vous rend aussi fier qu\'un fils puisse le faire. Ironically, il déteste l\'idée que vous soyez une figure paternelle pour lui, et vous lui dites toujours que vous n\'aurez jamais engendré un fils aussi laid pour commencer. Vous restez en contact jusqu\'à ce. jour.";
		this.m.BadEnding = "Avec vous depuis le début, %name% a été aussi loyal que talentueux. Il est resté dans la compagnie pendant un certain temps avant de la quitter pour suivre sa propre voix. L\'autre jour, vous avez reçu une lettre du mercenaire indiquant qu\'il avait créé sa propre compagnie et qu\'il avait besoin d\'aide. Malheureusement, le message était daté d\'il y a presque un an. Lorsque vous avez enquêté sur l\'existence de sa compagnie, vous avez appris qu\'elle avait été complètement anéantie lors d\'une bataille entre nobles.";
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsUntalented = true;
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
		return "%name% est l\'un des tireurs d\'élite les plus talentueux que vous ayez rencontrés dans vos voyages. {Après qu\'il vous ait sauvé la vie en décochant une flèche dans le cœur d\'un aspirant assassin, vous l\'avez engagé sur-le-champ. | Il était facile d\'apprendre à connaître cet homme - il suffisait de trouver le vainqueur d\'une compétition de tir locale. | Il a une fois gagné un concours de tir à l\'arc qui comptait plus de cent participants de toutes les terres. | On dit qu\'il peut fendre une flèche - en plein vol. | Vous avez trouvé l\'homme dans une ferme où, de toute évidence, vous pensiez que ses talents de tireur allaient être gaspillés. | Un braconnier, un archer, un archer, les compétences de l\'homme ont été largement utilisées. Vous pensez qu\'il a accepté votre offre de travail de mercenaire juste pour dire qu\'il a tout fait. | Vous l\'avez vu une fois tirer sur la lune, mais c\'était peut-être une sorte de ruse. | Habile archer, il a une fois décoché deux flèches simultanément pour tuer un groupe de brigands en train de charger.} Bien qu\'il aime tuer de loin, il n\'est pas mauvais en combat rapproché.";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"1h",
			brothers.len() >= 1 ? brothers[0].getName() : ""
		]);
		_vars.push([
			"2h",
			brothers.len() >= 2 ? brothers[1].getName() : ""
		]);
		_vars.push([
			"ranged",
			brothers.len() >= 3 ? brothers[2].getName() : ""
		]);
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				5,
				5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				5,
				0
			],
			RangedSkill = [
				16,
				10
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
				5,
				5
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
			actor.setTitle(this.Const.Strings.SellswordTitles[this.Math.rand(0, this.Const.Strings.SellswordTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local talents = this.getContainer().getActor().getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.RangedSkill] = 2;
		talents[this.Const.Attributes.RangedDefense] = 1;
		talents[this.Const.Attributes.Initiative] = 1;
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/light_crossbow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		items.addToBag(this.new("scripts/items/weapons/knife"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
	}

});


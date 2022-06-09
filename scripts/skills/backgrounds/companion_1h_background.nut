this.companion_1h_background <- this.inherit("scripts/skills/backgrounds/character_background", {
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
			"trait.superstitious",
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
			"trait.ailing",
			"trait.impatient",
			"trait.asthmatic",
			"trait.greedy",
			"trait.dumb",
			"trait.clubfooted",
			"trait.drunkard",
			"trait.disloyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.GoodEnding = "Du tout début jusqu\'à votre retraite, %name% était avec vous, quittant la compagnie peu de temps après votre départ. Mais il n\'en avait pas encore fini avec la vie de combattant et a commencé à se battre pour une autre compagnie - la sienne. Ayant tant appris sous votre direction, il vous rend aussi fier qu\'un fils puisse le faire. Ironically, il déteste l\'idée que vous soyez une figure paternelle pour lui, et vous lui dites toujours que vous n\'aurez jamais engendré un fils aussi laid pour commencer. Vous restez en contact jusqu\'à ce. jour.";
		this.m.BadEnding = "Avec vous depuis le début, %name% a été aussi loyal que talentueux. Il est resté dans la compagnie pendant un certain temps avant de la quitter pour suivre sa propre voix. L\'autre jour, vous avez reçu une lettre du mercenaire indiquant qu\'il avait créé sa propre compagnie et qu\'il avait besoin d\'aide. Malheureusement, le message était daté d\'il y a presque un an. Lorsque vous avez enquêté sur l\'existence de sa compagnie, vous avez appris qu\'elle avait été complètement anéantie lors d\'une bataille entre nobles.";
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsCombatBackground = true;
		this.m.IsUntalented = true;
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
		return "%name% n\'est pas connu pour être un grand parleur, mais il a tous les droits de l\'être. {Il a sauvé la vie de %2h% et de %ranged%. |Il t\'a une fois épargné de la chaîne maléfique d\'un orc. | Un assassin t\'aurait tué dans un pub si cet homme n\'avait pas été là. | Une arbalète mal tirée a failli t\'arracher un œil - si le bouclier de %name% n\'avait pas été là pour l\'arrêter. | Il a un jour poussé deux hommes d\'une falaise en utilisant uniquement son bouclier et ses deux solides jambes. | Il a appris à se battre grâce à son père, qui était à l\'avant-garde lors de la bataille de Many Names. | En sacrifiant l\'héritage de sa famille - un vieux bouclier de bois et de fer clouté - il t\'a sauvé la vie. | Un homme à l\'héroïsme constant, il a tiré un %2h% ivre de l\'incendie d\'un pub. | Face à une horde de gobelins, il a utilisé son bouclier et sa force pour faire un trou dans leurs lignes, ouvrant la voie à %2h% et %ranged% pour les tuer tous.} En faisant tournoyer son bouclier, l\'homme a dévié toute sorte de danger mortel. Bien qu\'il soit plutôt discret, vous avez trouvé que la place de %name% dans un mur de boucliers était plutôt indispensable.";
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
				10,
				5
			],
			Stamina = [
				5,
				5
			],
			MeleeSkill = [
				10,
				5
			],
			RangedSkill = [
				5,
				5
			],
			MeleeDefense = [
				5,
				5
			],
			RangedDefense = [
				5,
				5
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
			actor.setTitle(this.Const.Strings.SellswordTitles[this.Math.rand(0, this.Const.Strings.SellswordTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local talents = this.getContainer().getActor().getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Hitpoints] = 2;
		talents[this.Const.Attributes.Fatigue] = 1;
		talents[this.Const.Attributes.Bravery] = 1;
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/militia_spear"));
		items.equip(this.new("scripts/items/shields/wooden_shield"));
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/full_leather_cap"));
		}
	}

});


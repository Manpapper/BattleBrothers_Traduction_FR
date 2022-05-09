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
		this.m.GoodEnding = "He was with you from the start, %name%, and he was with you in retirement, leaving the company not long after you did. But he wasn\'t yet done with the fighting life and took up fighting for another company - his own. Having learned so much from your leadership, he is making you about as proud as any son could. Ironically, he hates the notion of you being a father figure to him, and you always tell him you\'d never father a son so ugly to begin with. You keep in touch to this. day.";
		this.m.BadEnding = "With you from the start, %name% was as loyal as he was talented. He stayed with the company for a time before eventually leaving to forge out a path for himself. The other day, you received a letter from the mercenary stating that he had started his own company and was in dire need of help. Unfortunately, the message was dated to nearly a full year ago. When you investigated the existence of his company, you learned that it had been completely annihilated in a battle between nobles.";
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


this.witchhunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.witchhunter";
		this.m.Name = "Chasseur de sorcières";
		this.m.Icon = "ui/backgrounds/background_23.png";
		this.m.BackgroundDescription = "Les chasseurs de sorcières ont généralement une certaine expérience des arts martiaux, et leur détermination reste souvent inébranlable, même face à une horreur indicible.";
		this.m.GoodEnding = "Le chasseur de sorcières %name% a fini par entendre parler du mal qui se répandait dans les villages du nord. Il quitta la compagnie %companyname% et depuis, il brûle ces horribles sorcières sur le bûcher.";
		this.m.BadEnding = "La rumeur selon laquelle le mal se répand dans le nord a attiré %name% le chasseur de sorcières. Il est parti avec des pieux, des fioles de liquides étranges et beaucoup de bois d\'allumage. Un mois plus tard, un paysan le trouve errant dans les terres du nord, les yeux arrachés et la bouche cousue. Il avait un étrange symbole gravé au fer sur sa poitrine et lorsque le paysan l\'a touché, les deux hommes ont explosé.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 13;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.insecure",
			"trait.hesitant",
			"trait.craven",
			"trait.fainthearted",
			"trait.dumb",
			"trait.superstitious",
			"trait.drunkard"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 3);
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
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Resolve at morale checks against fear, panic or mind control effects"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name% est apparu un jour dans %townname%, certains disent à la demande {du conseil local | d\'un prêtre local}. | %name% a la réputation d\'apparaître là où des choses inhabituelles se produisent et d\'être présent au moment ou la nuit est la plus sombre. | Homme calme et sombre, %name% a tendance à mettre les autres mal à l\'aise en sa présence, voire à les effrayer. | Le nom de %name% est connu dans de nombreux villages, car il a parcouru le pays pour aller là où ses talents sont les plus nécessaires.} {Il se fait appeler chasseur de sorcières. Grâce à son assortiment d\'outils exotiques, il a une grande expérience pour faire avouer aux gens, dans l\'agonie et sous une terrible torture, leurs liaisons pécheresses avec les démons et les diables. | Il se présente comme un chasseur de sorcières, mais seuls les idiots superstitieux peuvent le croire et se laisser prendre à ses histoires grotesques. | Il se fait appeler chasseur de sorcières et prétend avoir vu des atrocités venues de l\'au-delà qui rendraient fou un homme ordinaire. | Après son arrivée dans %townname%, des rumeurs ont circulé selon lesquelles il était à la recherche d\'adorateurs du diable et de créatures de la nuit, mais personne ne savait quel était le véritable objectif de sa visite. | Dans %townname%, il a tué une vieille femme et a été jeté au cachot. Il s\'est avéré que la femme était responsable de l\'enlèvement et de la mort de trois enfants, et il a donc été libéré de suite. | Pendant des nuits entières, il s\'est assis dans le pub de %townname%, étudiant silencieusement chaque client comme un oiseau qui tourne au-dessus de sa proie, son arbalète jamais très loin. Cela ne plaisait pas aux résidents, mais ils n\'osaient pas l\'approcher.} {A présent, la plupart des gens du coin veulent que %name% parte le plus tôt possible et seraient heureux de le voir rejoindre une compagnie de mercenaires itinérants. | Il semble que sa mission, quelle qu\'elle soit, soit maintenant accomplie et %name% propose donc ses services en tant que mercenaire. | Il est assez évident que %name% n\'est pas facilement effrayé et qu\'il sait également manier une arbalète. Personne n\'a donc été surpris lorsqu\'il s\'est approché d\'une compagnie de mercenaires qui embauchait. | Maintenant, une compagnie de mercenaires serait juste l\'outil dont il avait besoin pour accomplir sa quête personnelle contre le mal situé dans l\'au-delà. | La plupart des gens seraient heureux de se débarrasser de lui.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 25)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				12,
				10
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
				15,
				8
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
			actor.setTitle(this.Const.Strings.WitchhunterTitles[this.Math.rand(0, this.Const.Strings.WitchhunterTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/light_crossbow"));
		}
		else
		{
			items.equip(this.new("scripts/items/weapons/crossbow"));
		}

		items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/witchhunter_hat"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.MoraleCheckBravery[1] += 20;
	}

});


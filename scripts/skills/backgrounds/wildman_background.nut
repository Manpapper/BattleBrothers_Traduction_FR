this.wildman_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Tattoo = 0
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.wildman";
		this.m.Name = "Homme sauvage";
		this.m.Icon = "ui/backgrounds/background_31.png";
		this.m.BackgroundDescription = "Les hommes sauvages sont habitués à la dure vie de la nature où seuls les forts l\'emportent. Ils sont moins habitués au milieu urbain, où règnent la ruse et la tromperie.";
		this.m.GoodEnding = "Alors que la compagnie %companyname% visitait une ville pour se reposer et récupérer, une princesse locale s\'est entichée de %name% le sauvage. Il a été \"acheté\" pour une grande somme d\'or et offert à la noble dame. Vous êtes allé rendre visite à l\'homme récemment. Pour le dîner, il s\'est assis à une table royale, souriant gaiement et imitant les nobles qui l\'entouraient du mieux qu\'il pouvait. Sa nouvelle et inexplicable épouse l\'adorait, et lui aussi. Lorsque vous lui avez fait vos adieux, il vous a offert une lourde couronne d\'or qui lui appartenait. Elle était chargée de traditions et d\'histoires anciennes. Vous avez dit que ce serait mieux qu\'il la garde. Le sauvageon a haussé les épaules et est parti, faisant tourner la bague autour de son doigt.";
		this.m.BadEnding = "%name% le sauvage est resté avec la compagnie %companyname% qui se divisait pendant un certain temps et puis, juste comme ça, il est parti. La compagnie est partie à sa recherche dans une forêt, et a fini par trouver une sorte de note grossière : une énorme pile de couronnes à côté d\'un dessin poussiéreux représentant la compagnie %companyname% et certains de ses membres, ils sont tous serrés dans les bras d\'un gros bâton au sens propre du terme, avec un sourire niais sur le visage. Il y avait aussi l\'offrande d\'un lapin mort, à moitié mangé.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 12;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_beasts",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.night_blind",
			"trait.ailing",
			"trait.clubfooted",
			"trait.fat",
			"trait.tiny",
			"trait.gluttonous",
			"trait.pessimist",
			"trait.optimist",
			"trait.short_sighted",
			"trait.dexterous",
			"trait.insecure",
			"trait.hesitant",
			"trait.asthmatic",
			"trait.greedy",
			"trait.fragile",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.bright",
			"trait.cocky",
			"trait.dastard",
			"trait.drunkard"
		];
		this.m.Titles = [
			"the Savage",
			"the Outcast",
			"the Wildman",
			"the Feral",
			"the Wild",
			"the Barbarian"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Wild;
		this.m.BeardChance = 100;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 2);
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
				id = 15,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] Experience Gain"
			}
		];
	}

	function onBuildDescription()
	{
		return "{Pour certains, la nature est un refuge. | On dit que l\'homme naît avec la nature sauvage en lui, et qu\'il fait le mal quand il lui tourne le dos. | La civilisation est une tache, un armement prolongé de chaque génération suivante pour mieux combattre l\'ennemi ultime : Mère Nature elle-même. | En temps de guerre, il n\'est pas surprenant que beaucoup cherchent à nouveau refuge dans la nature. | Certaines personnes fuient de ville en ville. D\'autres s\'arrêtent entre deux, disparaissant dans la tranquillité des forêts.} {%%name% a autrefois trouvé un refuge sûr parmi les arbres, mais ce temps est révolu. | Autrefois un personnage mystérieux pour les chasseurs - le célèbre masskewatsthat - %name% revient maintenant à la civilisation pour des raisons inconnues. | %name% a les mains d\'un forgeron, mais l\'hygiène d\'une porcherie. | C\'était peut-être un amour impossible, ou peut-être juste la guerre, mais %name% a passé la dernière décennie loin du reste de l\'humanité. | Probablement un braconnier qui s\'est installé là où il chassait, %name% vit parmi les arbres depuis des années. | Avec ses vêtements habilement cousus, l\'apparence ancestral de %name% cache peut-être un passé de tailleur ou de tanneur.} {Il y a une barrière linguistique évidente avec l\'homme sauvage, mais pour une raison quelconque, il semble très désireux de se battre. Espérons que sa nouvelle \"vocation\" ne cache pas un dessein plus sombre. | Des rituels colorés et permanents tournent autour de son corps. Lorsqu\'on lui demande pourquoi il souhaite rejoindre une bande de mercenaires, il hulule et, d\'un doigt crochu, reproduit l\'un de ses arts charnels dans le ciel. | Des blessures, anciennes et récentes, parsèment son corps déjà tacheté. Et elles ne sont pas superficielles - cet homme s\'est battu contre quelque chose de féroce dans la nature. | C\'est à se demander si les désastres qui l\'ont poursuivi dans les forêts n\'ont pas fini par l\'en chasser. | A en juger par ses grognements sauvages, il est peu probable qu\'il soit là pour rejoindre la civilisation. | Des années de solitude n\'ont pas fait oublier à l\'homme ce que quelques couronnes peuvent vous apporter. La question est, pourquoi est-il revenu ? | Il a la force de lutter contre un sanglier - et ses nombreuses cicatrices vous font vous demander si il ne l\'a pas vraiment fait.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				12,
				10
			],
			Bravery = [
				12,
				10
			],
			Stamina = [
				18,
				23
			],
			MeleeSkill = [
				6,
				0
			],
			RangedSkill = [
				-5,
				0
			],
			MeleeDefense = [
				-5,
				0
			],
			RangedDefense = [
				-5,
				-5
			],
			Initiative = [
				-5,
				-5
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
		this.m.Tattoo = this.Math.rand(0, 1);
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local body = actor.getSprite("body");
		tattoo_body.setBrush((this.m.Tattoo == 0 ? "warpaint_01_" : "scar_02_") + body.getBrush().Name);
		tattoo_body.Visible = true;
		tattoo_head.setBrush(this.m.Tattoo == 0 ? "warpaint_01_head" : "scar_02_head");
		tattoo_head.Visible = true;
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush((this.m.Tattoo == 0 ? "warpaint_01_" : "scar_02_") + body.getBrush().Name);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 7);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/hatchet"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wooden_stick"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_metal_club"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_wooden_club"));
			}
			else if (r == 4)
			{
				items.equip(this.new("scripts/items/weapons/boar_spear"));
			}
			else if (r == 5)
			{
				items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
			}
			else if (r == 6)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_wooden_hammer"));
			}
			else if (r == 7)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_wooden_flail"));
			}
		}
		else
		{
			r = this.Math.rand(0, 6);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/hatchet"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wooden_stick"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_metal_club"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_wooden_club"));
			}
			else if (r == 4)
			{
				items.equip(this.new("scripts/items/weapons/boar_spear"));
			}
			else if (r == 5)
			{
				items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
			}
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.XPGainMult *= 0.85;
	}

	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeU8(this.m.Tattoo);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.Tattoo = _in.readU8();
	}

});


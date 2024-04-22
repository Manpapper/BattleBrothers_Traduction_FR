this.gladiator_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gladiator";
		this.m.Name = "Gladiateur";
		this.m.Icon = "ui/backgrounds/background_61.png";
		this.m.BackgroundDescription = "Les gladiateurs coûtent cher, mais une vie dans l\'arène les a forgés en combattants compétents.";
		this.m.GoodEnding = "Vous pensiez que %name% le gladiateur reviendrait dans les arènes comme prévu. Cependant, des nouvelles du sud parlent d\'un soulèvement de personnes endettées et de gladiateurs. Contrairement aux révoltes précédentes, celle-ci voit des vizirs se balancer du haut des toits et des esclavagistes se faire lyncher dans les rues. Le bouleversement général est apparemment sur le point d\'asseoir le combattant d\'autrefois comme un détenteur légitime du pouvoir dans la région.";
		this.m.BadEnding = "L\'appel de la foule était trop fort pour le gladiateur %name%. Après l\'échec de la compagnie %companyname% et de votre retaite forçée, le combattant est retourné dans les arènes de combat des royaumes du sud. Malheureusement, le temps passé avec les mercenaires l\'a usé et ramolli et il a été mortellement tué par un esclave à moitié affamé maniant une fourche et un filet.";
		this.m.HiringCost = 200;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.weasel",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Bodies = this.Const.Bodies.Gladiator;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 60;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.Level = this.Math.rand(2, 4);
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
		return "{Le Sud est rempli d\'esclaves de toutes sortes, appelés les endettés pour leur dette envers le Gilder. Si la plupart d\'entre eux se retrouvent dans les champs, quelques-uns sont emmenés dans les fosses de combat pour se battre. | Bien que les habitants du Nord participent à des tournois de combat, ce n\'est en rien comparable à la violence et au sang d\'une fosse de gladiateurs du Sud. | Dans le Sud, les riches comme les pauvres prennent plaisir à encourager les gladiateurs des fosses de combat. | Les fosses de gladiateurs du Sud sont remplies de tueurs volontaires ou endettés. | Lieu de combat et de paris, la fosse aux gladiateurs est le seul endroit du Sud où l\'on peut trouver riches et pauvres réunis.} {C\'est de là que vient %name%. Il a rapidement gravi les échelons et a réussi à se frayer un chemin hors des fosses et à trouver la \"liberté\" qu\'on pourrait trouver dans un tel monde. | Apprécié du public, le temps de %name% en tant que gladiateur s\'est terminé par un \"pardon\" de ses riches sponsors. Mais dans sa retraite anticipée, il a trouvé sa vie était inassouvie. | Les tueurs qui ont réussi, comme %name%, peuvent acheter leur liberté, bien que la soif de sang n\'ait pas encore quitté l\'homme. | %name% a été impliqué dans un incident et a été banni des fosses pendant un an. | Mais les gladiateurs comme %name% ne sont pas seulement populaires auprès du public, mais surtout auprès des femmes. Un rendez-vous galant avec la femme d\'un noble a conduit le combattant à être emmené sous le couvert de la nuit de peur qu\'il ne soit castré. | Le combattant le plus populaire d\'une fosse est généralement un mélange de beauté meurtrière, et un homme comme %name% n\'était que le deuxième. Déçu par le manque de renommée qu\'il pensait avoir gagné, il a acheté sa liberté et a quitté le sport sanguinaire.} {Les gladiateurs passent généralement d\'une fosse de combat à l\'autre. Il est donc rare de trouver dans la nature un combattant robuste et compétent tel que %name%. Pourtant, il est là, avec suffisamment de cicatrices pour faire rougir un flagellant. | Vous avez rencontré beaucoup de guerriers, mais rarement un guerrier ayant les compétences particulières d\'un combattant de fosse comme %name%. Tous les affrontements dans les arènes ont fait de lui un guerrier intelligent, mais aussi un guerrier avec de nombreuses cicatrices et blessures. | Il y a beaucoup de choses qui vont de paire dans ce monde, et un gladiateur avec un corps intact n\'en fait pas partie. %name% est un combattant expérimenté, mais il a gagné ces expériences avec son propre sang et au détriment de son corps. | Un impressionnant curriculum vitae de gladiateur, tel que celui de %name%, indique un homme habitué à tuer. Les nombreuses cicatrices, cependant, indiquent clairement que son séjour dans les fosses a eu un prix irréversible. | Les gladiateurs tels que %name% pourraient être les combattants les plus habiles de tout le pays, mais les fosses de combat sont pleines de jeux et sont conçues pour faire du mal à tous ceux qui y participent. Cet homme est un guerrier talentueux, mais il porte les cicatrices et les blessures d\'une carrière dans l\'arène.}";
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

		if (this.Math.rand(1, 100) <= 30)
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
				5,
				5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				8,
				6
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				5,
				8
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

		if (this.Math.rand(1, 2) == 2)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.GladiatorTitles[this.Math.rand(0, this.Const.Strings.GladiatorTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/shamshir",
				"weapons/shamshir",
				"weapons/oriental/two_handed_scimitar",
				"weapons/oriental/heavy_southern_mace",
				"weapons/oriental/heavy_southern_mace",
				"weapons/oriental/swordlance",
				"weapons/oriental/polemace",
				"weapons/fighting_axe",
				"weapons/fighting_spear"
			];

			if (this.Const.DLC.Wildmen)
			{
				weapons.extend([
					"weapons/two_handed_flail",
					"weapons/two_handed_flanged_mace",
					"weapons/bardiche"
				]);
			}

			items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (items.hasEmptySlot(this.Const.ItemSlot.Offhand))
		{
			local offhand = [
				"tools/throwing_net",
				"shields/oriental/metal_round_shield"
			];
			items.equip(this.new("scripts/items/" + offhand[this.Math.rand(0, offhand.len() - 1)]));
		}

		local a = this.new("scripts/items/armor/oriental/gladiator_harness");
		local u;
		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			u = this.new("scripts/items/armor_upgrades/light_gladiator_upgrade");
		}
		else if (r == 2)
		{
			u = this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade");
		}

		a.setUpgrade(u);
		items.equip(a);
		r = this.Math.rand(2, 3);

		if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/gladiator_helmet"));
		}
	}

});


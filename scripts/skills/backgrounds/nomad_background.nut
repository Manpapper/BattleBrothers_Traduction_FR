this.nomad_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.nomad";
		this.m.Name = "Nomade";
		this.m.Icon = "ui/backgrounds/background_63.png";
		this.m.BackgroundDescription = "Tout nomade qui a survécu dans le désert aura une certaine expertise en matière de combat.";
		this.m.GoodEnding = "%name% le nomade a quitté la compagnie %companyname% quelques mois après vous. Il a apparemment voyagé vers le sud et dirige maintenant ce qu\'ils appellent la \"Ville sur pattes\", un vaste groupe de personnes qui errent dans les déserts. Il s\'agit apparemment d\'une société si riche et prospère que les vizirs craignent que leur propre peuple n\'y afflue.";
		this.m.BadEnding = "Vous avez appris que %name% le nomade a quitté la compagnie dans l\'espoir de trouver de nouvelles plaines à parcourir. Apparemment, il s\'est mis en tête de voyager loin vers le nord et de s\'acoquiner avec les barbares qui s\'y trouvent.À sa décharge, les barbares et les nomades partagent un mode de vie, une culture, une langue, une religion, des lois, des luttes, des conflits et des apparences générales similaires. Malheureusement, Le nomade était massacré presque instantanément dès son entrée dans un campement barbare et ses restes étaient mangés lors d\'un rituel guerrier.";
		this.m.HiringCost = 200;
		this.m.DailyCost = 28;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.hate_undead",
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
		this.m.Titles = [
			"the Desert Raider",
			"of the Desert",
			"Son of the Desert",
			"the Desert Scourge",
			"the Scorpion",
			"the Nomad",
			"Redsands",
			"the Hyena",
			"the Hawk",
			"the Serpent",
			"the Free",
			"the Wanderer",
			"the Waylayer"
		];
		this.m.Bodies = this.Const.Bodies.SouthernMuscular;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
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
		return "{Comme beaucoup de Sudistes, %name% a grandi dans le désert, parcourant les dunes et dévalisant les caravanes et les voyageurs perdus. | Né dans l\'une des nombreuses tribus du désert du Sud, %name% a appris à vivre dans le desert avant d\'apprendre quoi que ce soit d\'autre. | Les nomades peuplent les déserts du sud et c\'est dans l\'une de ces bandes errantes qu\'est né %name%. | Les vrais nomades sont rares dans les villes du sud et %name% ne fait pas exception. | On voit rarement un nomade en dehors de son milieu naturel que sont les dunes de sable, mais %name% se tient debout, bronzé et encore couvert de sable.} {Cependant, la politique des nomades est un peu compliquée. Un événement, que le nomade devenu mercenaire refuse d\'expliquer, l\'a conduit dans les villes à la recherche de travail. | Une règle de sa tribu veut que chaque troisième fils parte à la découverte du monde et, s\'il le souhaite, revienne. Donc, voici %name%. | Accusé d\'avoir eu des rapports sexuels inappropriés avec une femme qui ne lui était pas officiellement offerte, %name% était confronté à l\'exécution ou à l\'exil de la tribu. Sa respiration et sa position devant vous indiquent laquelle des deux options il a choisie. | Ayant assassiné un de ses compagnons pour une dette de jeu au sein de sa tribu, le nomade a dû s\'exiler. | Mais une embuscade désastreuse, qu\'il était chargé de planifier, l\'a fait exclure de sa tribu. | Mais le nomade voulait se rapprocher de la civilisation, se voir comme quelqu\'un capable de rassembler plus que ce qu\'il pouvait faire au sein de sa tribu, et c\'est ainsi qu\'il est parti à l\'aventure, découvrant la vie urbaine.} {Le nomade se dresse devant vous avec toute l\'étendue de son apprentissage : le teint sombre, les yeux noirs, les mains poncées. S\'il n\'est pas déjà un guerrier, il pourrait vraisemblablement être formé pour le devenir avec le temps. | En tant qu\'homme du sud insupportable, il n\'est pas surprenant que le nomade soit physiquement prêt à assumer les devoirs du mercenariat. Que les compétences soient là est une toute autre question. | Les hommes qui s\'aventurent dans les étendues désertiques sont très résistants et %name% ne fait pas exception. | Les nomades tels que %name% gagnent la plupart de leur expérience de combat en tendant de petites embuscades. Il pourrait être utile dans un groupe de mercenaires, bien que le travail en ligne de front soit assez différent de l\'embuscade de pauvres marchands. | %name% est un homme du sud tel que vous les connaissez : usé par le sable, mais arborant une constitution d\'un homme prêt à affronter la journée et toutes celles à venir. | %name% n\'est probablement pas encore un combattant entraîné et compétent, mais en tant qu\'homme des terres australes, il ne fait aucun doute qu\'il a le cœur et l\'esprit d\'un guerrier.}";
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
				0,
				-3
			],
			Stamina = [
				2,
				0
			],
			MeleeSkill = [
				12,
				10
			],
			RangedSkill = [
				5,
				0
			],
			MeleeDefense = [
				6,
				5
			],
			RangedDefense = [
				6,
				5
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
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/oriental/saif"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/oriental/nomad_mace"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/oriental/light_southern_mace"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/militia_spear"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/oriental/southern_light_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/stitched_nomad_armor"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/oriental/leather_nomad_robe"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_leather_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/oriental/nomad_light_helmet"));
		}
	}

});


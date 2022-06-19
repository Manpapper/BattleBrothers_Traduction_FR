this.hedge_knight_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hedge_knight";
		this.m.Name = "Le Chevalier Errant";
		this.m.Icon = "ui/backgrounds/background_33.png";
		this.m.BackgroundDescription = "Les chevaliers errants sont des individus compétitifs qui excellent dans le combat entre hommes grâce à une force brute et une armure lourde mais il sera moins à l\'aise en societé et sa rapidité lui fera souvent défaut.";
		this.m.GoodEnding = "Un homme comme %name% trouve toujours sa propre voix. Le chevalier errant a fini par quitter la compagnie, de manière inévitable, et s\'est mis à son compte. Contrairement à de nombreux autres frères, il n\'a pas dépensé ses couronnes pour acheter des terres ou des accointances qui lui aurait permis de gravir les échelons dans la noblesse. Au lieu de cela, il s\'est acheté les meilleurs chevaux de guerre et les talents de divers armuriers. Ce mastodonte allait d\'un tournoi de joute à l\'autre, les remportant tous avec facilité. Il le fait encore aujourd\'hui, et vous pensez qu\'il ne s\'arrêtera pas avant d\'être mort. Le chevalier errant ne connaît simplement aucune autre vie.";
		this.m.BadEnding = "%name% le chevalier errant a fini par quitter la compagnie. Il a parcouru les terres, retournant à son passe-temps favori, la joute, qui était en fait une couverture pour son vrai passe-temps favori, qui consistait à faire tomber les hommes des chevaux dans une pluie d\'éclats et de gloire. À un moment donné, on lui a ordonné de \"lancer\" un match contre un prince pitoyable et dégingandé pour que le noble gagne en prestige. Au lieu de cela, le chevalier errant a planté sa lance dans le crâne du prince. Furieux, le seigneur du pays a ordonné que le chevalier errant soit tué. On dit que plus d\'une centaine de soldats se sont rendus chez lui et que seule la moitié est revenue vivante.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.ailing",
			"trait.swift",
			"trait.clubfooted",
			"trait.irrational",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure",
			"trait.asthmatic"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Initiative,
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"the Lone Wolf",
			"the Wolf",
			"the Hound",
			"Steelwielder",
			"the Slayer",
			"the Jouster",
			"the Giant",
			"the Mountain",
			"Strongface",
			"the Defiler",
			"the Knightslayer",
			"the Hedge Knight"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 5);
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
		return "{Certains hommes sont nés pour être craints. Mesurant plus d\'un mètre quatre-vingt, la stature de %name% s\'avère menaçante à elle seule. | l\'ombre de %name% se projette sur les hommes plus petits que lui - et ils semblent rapetisser encore plus lorsqu\'il passe à côté. | Se tenant parmi les hommes comme un ours en armure, %name% suscite de nombreux regards. | Des années de combat brutal avec ses frères tout aussi immenses ont fait de %name% un personnage au visage marqué et effrayant.} {Le chevalier errant a passé de nombreuses saisons à emmener son précieux cheval à des tournois de joute. Malheureusement, une arme d\'hast a touchée sa monture à la tête, le laissant sans rien. | Mercenaire à part entière, le chevalier errant a erré pendant des années, se battant pour ceux qui offraient le plus de couronnes. | Lorsqu\'il a tranché cinq hommes d\'un seul coup, dont trois étaient de son clan, le chevalier errant a été interdit de service dans toutes les armées du pays. | Commandité pour tuer les ennemis d\'un seigneur, le chevalier errant a défoncé la porte ou vivait une famille et les a tous massacrés à mains nues. Quand le seigneur a refusé de payer, %name% l\'a tué aussi. | Le chevalier errant a passé de nombreuses nuits à dormir paisiblement sous une lune pâle et autant de jours à tuer sans pitié sous un soleil radieux.} {Toujours à la recherche de plus de couronnes, la compagnie des mercenaires semblait être un bon choix. | Trop terrifiant pour être employé, %name% cherche la compagnie d\'hommes qui ne se pisseront pas dessus lorsqu\'il s\'emparera d\'une arme. | Fatigué de tuer des jouteurs et des seigneurs, ainsi que des femmes et des enfants, %name% considère le travail de mercenaire comme des vacances. | La guerre s\'est apparemment mise en travers de la carrière de jouteuse de %name%. Il cherche à corriger ce problème.}";
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
				12,
				13
			],
			Bravery = [
				9,
				4
			],
			Stamina = [
				15,
				10
			],
			MeleeSkill = [
				11,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				6,
				5
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				-14,
				-7
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 2) == 2)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.HedgeKnightTitles[this.Math.rand(0, this.Const.Strings.HedgeKnightTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 2);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/greataxe"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/greatsword"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_flanged_mace"));
			}
		}
		else
		{
			r = this.Math.rand(0, 1);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/greataxe"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/greatsword"));
			}
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/scale_armor"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/reinforced_mail_hauberk"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_mail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/bascinet_with_mail"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/closed_flat_top_helmet"));
		}
	}

});


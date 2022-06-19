this.lumberjack_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.lumberjack";
		this.m.Name = "Bûcheron";
		this.m.Icon = "ui/backgrounds/background_04.png";
		this.m.BackgroundDescription = "Les bûcherons sont habitués à un travail physique difficile. Et aux haches.";
		this.m.GoodEnding = "%name% le bûcheron robuste a fini par quitter l\'entreprise pour retourner dans les bois. Il a lancé une entreprise de bûcheronnage et opère tous les jours de l\'année. Heureusement, le timing était de son côté : la noblesse s\'est récemment mise à la \"mode\" des cabanes et paie à tour de bras des couronnes à quiconque peut en construire.";
		this.m.BadEnding = "%name% le bûcheron en a eu assez d\'être un mercenaire et est retourné au bûcheronnage. Aux dernières nouvelles, il a été victime d\'une chute d\'arbre et son corps aurait pu être roulé comme un tapis tant les os étaient écrasés.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 13;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.ailing",
			"trait.clubfooted",
			"trait.asthmatic",
			"trait.clumsy",
			"trait.fat",
			"trait.craven",
			"trait.fainthearted",
			"trait.bright",
			"trait.bleeder",
			"trait.fragile",
			"trait.tiny"
		];
		this.m.Titles = [
			"the Sturdy",
			"the Axe",
			"the Woodsman"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "Le bûcheron, %fullname% {passait la plupart de ses journées dans les bois, abattant des arbres | gagnait ses couronnes en coupant des arbres pour le bois de chauffage | n\'était jamais vu sans hache ou bois sur l\'épaule | a toujours été un homme tranquille qui préférait la sérénité des forêts à la compagnie des gens | était remarqué par de nombreuses jeunes femmes grâce à sa grande taille et à ses mains robustes | a toujours rêvé qu\'il était un chevalier, balançant sa hache non pas contre des arbres mais contre des orcs et des trolls}. {Un homme grand et robuste, le travail à l\'extérieur lui était facile | Il aimait sa collection de haches, et avait donné à chacune d\'elles le nom d\'une femme qu\'il avait connue | Il travaillait dur tous les jours, mais c\'était un boulot honnête | Seul dans les bois, il parlait aux arbres et leur faisait dire lesquels donneraient le meilleur bois | Peu d\'hommes pouvaient manier la hache comme il le faisait, faisant tomber un arbre comme il le voulait | Avec sa grande et solide carrure, il pouvait porter sur son dos un poids qui aurait fait s\'effondrer sur lui même n\'importe qui d\'autre}. {Comme la plupart des gens, il a embrassé la profession de son père. Pourtant, au fil des ans, il s\'est rendu compte qu\'il voulait voir autre chose que les mêmes forêts jours après jours. Après avoir longuement réfléchi, il s\'est décidé à | Sa vie s\'est écroulée lorsque sa femme bien-aimée est morte en accouchant. Tout lui ayant été retiré, il est devenu de plus en plus solitaire, et même les fôrets ne pouvaient plus lui apporter la paix. Voulant juste s\'éloigner, il a décidé de | Un jour, en revenant des bois, il a vu de la fumée au loin. Son village brûlait, les gens avaient été massacrés ou enlevés. Sa maison a été détruite. Plein de colère, il s\'est mis en route et a décidé de | Au fil du temps, d\'étranges créatures ont commencé à apparaître dans les bois. Les villageois ont disparu les uns après les autres, certains ont déménagé. Après une longue nuit sans sommeil, il a décidé qu\'il était temps pour lui de partir aussi. N\'ayant rien pour vivre, il était prêt à tout pour | Les villageois le trouvait curieux. Avec le temps, il semblait que %name% avait perdu tout intérêt pour le bois, parlant de partir de plus en plus souvent à chaque fois qu\'il ouvrait la bouche. Un jour fatidique, ils l\'ont vu se porter volontaire en vue de | Tragiquement, un jour, un arbre qu\'il a abattu est tombé sur un cerf, le tuant sur le coup. %name% ne voulait pas le gaspiller et l\'a donc ramené chez lui, mais il s\'est retrouvé accusé de braconnage. Avant qu\'une sentence ne soit prononcée, il a décidé de quitter le village en toute hâte et de tenter de} rejoindre une compagnie de mercenaires itinérants.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				10
			],
			Bravery = [
				0,
				5
			],
			Stamina = [
				10,
				15
			],
			MeleeSkill = [
				5,
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
				-5,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(6);
			items.equip(item);
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});


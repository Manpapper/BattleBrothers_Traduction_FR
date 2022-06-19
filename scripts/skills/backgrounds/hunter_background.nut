this.hunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hunter";
		this.m.Name = "Chasseur";
		this.m.Icon = "ui/backgrounds/background_22.png";
		this.m.BackgroundDescription = "Les chasseurs ont l\'habitude de chasser les animaux à l\'aide d\'un arc et de flèches, et de parcourir les bois par leurs propres moyens.";
		this.m.GoodEnding = "Alors que la compagnie %companyname% poursuivait ses activités avec beaucoup de succès, %name% le chasseur a finalement jugé bon de tout laisser derrière lui. Il retourna dans les forêts et les champs, chassant le cerf et le petit gibier. Il a rarement montré la triste réalité de la chasse aux humains, mais vous devez imaginer qu\'il préférerait ne rien dire. Pour autant que vous le sachiez, il se débrouille bien en ce moment. Il a acheté un bout de terre et guider les nobles lors de chasse à courre.";
		this.m.BadEnding = "Le déclin de la compagnie %companyname% étant évident, %name% le chasseur a quitté la société et est retourné à la chasse au gibier. Malheureusement, une partie de chasse avec un noble a mal tourné lorsque le seigneur a été encorné aux deux joues par un sanglier. Le chasseur, sentant qu\'il serait blâmé, a tiré sur le noble et sa garde et s\'est enfui dans les forêts par ses propres moyens. Il n\'a pas été revu depuis.";
		this.m.HiringCost = 120;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.short_sighted",
			"trait.fat",
			"trait.clumsy",
			"trait.gluttonous",
			"trait.asthmatic",
			"trait.craven",
			"trait.dastard",
			"trait.drunkard"
		];
		this.m.Titles = [
			"the Deerhunter",
			"Woodstalker",
			"the Woodsman",
			"the Hunter",
			"True-Shot",
			"One Shot",
			"Eagle Eye"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Untidy;
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{Père absent, sa mère lui a appris à tirer à l\'arc et à nourrir le reste de sa famille. | Né dans l\'arrière-pays de %randomtown%, %name% a passé une grande partie de sa vie à traquer les bêtes dans les arbres. | Un jour, %name% a pris le pari de tirer une pomme sur la tête d\'un cochon. Il a raté son coup. Le ventre plein de bacon, il est déterminé à ne plus jamais rater son coup - sauf si cela signifiait avoir plus de bacon, bien sûr. | Au début de sa vie, %name% aimait se promener dans les forêts. Lorsqu\'un renard enragé l\'a attaqué, il a appris à se saisir d\'un arc. Quand un aigle diabolique lui griffait le visage, il apprenait à tirer.} {Autrefois employé par la royauté locale, une chasse au sanglier désastreuse s\'est terminée avec un baron encorné et toute la responsabilité - et le sang - sur les mains de %name%. | Le chasseur s\'est bien gardé de cette pensée, mais pendant longtemps, il s\'est demandé ce que cela ferait de chasser le gibier ultime : l\'homme. | Malheureusement, un mauvais résultat à la roulette paysanne a obligé le chasseur de cerfs à chercher d\'autres moyens de revenus. | Malheureusement, il n\'est pas aussi doué pour cuisiner les cerfs que pour les tirer. Un dîner composé de viandes mal cuites a empoisonné toute sa famille. Sa nouvelle vie ne serait que désespoir, ce qui est compréhensible. | Après un voyage ardu en ville pour vendre des viandes et des cuirs, il a suivi l\'appel du travail de mercenaire. | A cause de la guerre, le gibier n\'était plus aussi présent, ce qui influa sur les revenus de %name%. Il cherche maintenant un autre travail. | Quand sa femme est tombée malade, il n\'a pas pu la guérir avec de la viande qu\'il avait chassé. Ayant besoin de gagner des couronnes pour payer son traitement, il s\'est lancé dans le mercenariat - ou d\'arbalétriers, en quelque sorte.} {N\'importe quelle équipe pourrait avoir besoin d\'un franc-tireur comme cet homme. | Pas entièrement sans défaut, %name% est néanmoins un archer professionnel. | Une démonstration rapide est proposée : %name% tire une flèche haut dans le ciel, et avec une autre, il l\'abat. Impressionnant. | %name% semble avoir quelque chose à prouver - assurez-vous qu\'il le fasse à distance. Quand on lui a donné une épée pour la première fois, il l\'a prise par le mauvais bout. Oui, ce bout. | Le chasseur manie son arc comme l\'un de ses membres, et décoche ses flèches comme un prédicateur manie les mots.}";
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
				5
			],
			Stamina = [
				7,
				5
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				20,
				17
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				3
			],
			Initiative = [
				0,
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/hunting_bow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else
		{
			items.equip(this.new("scripts/items/helmets/hunters_hat"));
		}
	}

});


this.monk_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.monk";
		this.m.Name = "Moine";
		this.m.Icon = "ui/backgrounds/background_13.png";
		this.m.BackgroundDescription = "Les moines ont tendance à être très déterminés dans ce qu\'ils font, mais ils ne sont pas habitués à un travail physique difficile ou à la guerre.";
		this.m.GoodEnding = "%name% le moine s\'est retiré pour reprendre des tâches spirituelles plus calmes. Il se trouve actuellement dans un monastère en montagne, où il profite du calme tout en réfléchissant à son passage dans la compagnie des mercenaires. Les autres moines le détestent parce qu\'il se bat et tue, mais il écrit un tome qui va changer le monde et qui traite de l\'équilibre entre la paix et la violence.";
		this.m.BadEnding = "Après une dépression spirituelle, %name% s\'est retiré des combats et a trouvé refuge dans un monastère. Tous ses confrères et abbés l\'ont ostracisé pour avoir pris part à une aventure aussi violente. On dit qu\'il a fini par être exilé lorsqu\'un sacristain l\'a surpris en train de voler des offrandes déstinées à dieu.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_beasts",
			"trait.swift",
			"trait.impatient",
			"trait.clubfooted",
			"trait.brute",
			"trait.gluttonous",
			"trait.disloyal",
			"trait.cocky",
			"trait.quick",
			"trait.dumb",
			"trait.superstitious",
			"trait.iron_lungs",
			"trait.craven",
			"trait.greedy",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Pious",
			"the Monk",
			"the Scholar",
			"the Preacher",
			"the Devoted",
			"the Quiet",
			"the Calm",
			"the Faithful"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.Monk;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Monk;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
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
		return "{Après que des pillards ont assassiné sa famille, %name% s\'est retiré dans le confort de la religion et est devenu moine dans un monastère voisin. | S\'éloignant souvent de son église et de ses collègues moines, %name% a passé des années à prêcher à la paysannerie dans des villages reculés. | %name%, un moine tranquille, a passé d\'innombrables jours à vénérer les anciens dieux dans le monastère de %townname%. | Un moine parmi d\'autres, %name% avait l\'habitude d\'errer dans les temples et d\'admirer les clochers de %randomtown%. | Abandonné sur les marches d\'un monastère, %name% a grandi en compagnie de moines et a rapidement adopté leur mode de vie. | Essayant de trouver la paix dans un pays en ruine, %name% est devenu moine. | Enfant toujours turbulent, les parents de %name% le confient au monastère local où il est rapidement converti en moine.} {Malheureusement, le penchant de son abbé pour la jeunesse et les choses charnelles a conduit à un terrible scandale. %name% s\'enfuit pour préserver sa vie et sa foi. | Mais sa foi a été irréversiblement ébranlée par une attaque sauvage de pillards qui a laissé des hommes castrés, des femmes violées et des enfants embrochés sur des piques. | Bien que croyant aux anciens dieux, le moine ne supportait pas les atrocités que le prêtre en chef commettait en leur nom. Le moine a fini par partir à la recherche de la spiritualité par ses propres moyens. | De plus en plus de souffrance dans le monde ont fait que l\'abbé de %name% lui a demandé de sortir et de guérir les gens qui en avaient besoin - ou de tuer ceux qui leur faisaient du mal. | Cultes de la mort, bêtes de cauchemar et hommes de cruauté. %name% a quitté les couloirs de son temple pour tous les purifier. | Mais lorsqu\'un enfant lui a posé une question qui a bouleversé sa foi, %name% a abandonné sa foi, cherchant la spiritualité par d\'autres moyens. | Malheureusement, la prière n\'a pas épargné ses frères d\'un massacre. %name% a réalisé que sa foi était plus utile pour sa propre personne plutôt que de devoir l\'utiliser pour murmurer à un soi-disant dieu. | Toujours animé par sa foi, %name% a quitté la protection des monastères pour sortir et \"redresser\" le monde. | L\'un des rares hommes lettrés des environs, %name% a abandonné sa vie monacal pour en apprendre davantage sur le monde et, espérons-le, pour guérir ce qui le rend malade. | Mais une nuit, une femme a couché avec lui. Il s\'est réveillé avec sa foi en miettes dans des draps dans le même état. Honteux, il n\'est jamais retourné à son monastère. | Mais il a utilisé sa notoriété pour des gains mal acquis en volant le trésor du temple. Il n\'a pas fallu longtemps pour que le scandale le fasse partir. | Malheureusement, un enfant l\'a accusé d\'avoir un comportement indigne d\'un moine. Personne ne connaît la vérité derrière cette histoire, mais %name% n\'est pas resté longtemps à l\'église. | Une nuit, il a découvert une terrible vérité dans un vieux tome. Peu de temps après, %name% a rapidement quitté l\'église, sans jamais dire ce qu\'il avait découvert.} {Cet homme ne connaît pratiquement rien au combat, mais il a la force mentale d\'une montagne capable d\'arrêter une tempête. | Des années de solitude et de prière ont laissé %name% en mauvaise santé, mais c\'est son esprit blindé qui a le plus de valeur. | N\'ayant peut-être jamais été vraiment satisfait de sa vie, il est difficile de savoir exactement pourquoi quelqu\'un comme %name% a rejoint une bande de mercenaires. | Peut-être y a-t-il trop de démons dans le monde, ou trop en lui, mais vous ne vous demandez pas pourquoi %name% souhaite rejoindre une bande de mercenaires. | La foi ne fendra pas une peau verte, mais elle ne fera pas fuir un homme comme %name% non plus. | Le conviction de %name% à débarrasser le monde de \"l\'infidèle\" est presque effrayant dans sa détermination. | Bien que la spiritualité de %name% soit louable, les murmures constants aux anciens dieux sont un peu ennuyeux. | Si les mains de %name% sont mieux jointes en prière qu\'autour d\'une épée, peu de mercenaires ont le sens de la rigueur qu\'il possède. | Un livre saint quasiment ancré à son poignet, %name% a recherché la compagnie des mercenaires. | Le livre saint qu\'il porte est suffisamment épais pour être utilisé comme bouclier, mais %name% a l\'air absolument horrifié lorsque vous le dites à haute voix. | Peut-être avec une vision romantique du mercenariat ayant besoin d\'une bonne purification spirituelle, %name% cherche à les accompagner. | Ayant autrefois lu des articles sur les prêtres guerriers, %name% souhaite maintenant imiter ces braves et inébranlables soldats de la foi. | On a l\'impression que %name% veut être libéré de ce monde rempli de péchés. Si c\'est la vérité, alors il est au bon endroit.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				11,
				11
			],
			Stamina = [
				-10,
				0
			],
			MeleeSkill = [
				-5,
				-5
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
		items.equip(this.new("scripts/items/armor/monk_robe"));
	}

});


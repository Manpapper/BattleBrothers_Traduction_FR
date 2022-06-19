this.eunuch_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.eunuch";
		this.m.Name = "Eunuque";
		this.m.Icon = "ui/backgrounds/background_52.png";
		this.m.BackgroundDescription = "Le fait que les eunuques ne puissent pas engendrer d\'enfants est probablement une préoccupation secondaire pour une compagnie de mercenaires.";
		this.m.GoodEnding = "Pour %name%, il y a toujours des choses qui manquent un peu. Mais cela n\'a pas empêché l\'eunuque de s\'amuser. S\'étant éloigné de la compagnie %companyname% avec un gros tas de couronnes, et étant complètement dépourvu de l\'attrait des femmes, l\'homme a continué à vivre une vie merveilleuse et extrêmement intense.";
		this.m.BadEnding = "Il se dit que %name% l\'eunuque a quitté la compagnie peu de temps après vous. Il a parcouru le pays, fauché et brisé, gaspillant ses maigres couronnes en bière et en femmes. Insulté par une prostituée pour son manque d\'assurance, l\'eunuque ivre et furieux a poignardé la femme dans l\'œil avec une corne de chèvre. Encore en état d\'ébriété lorsque la garde l\'a trouvé, l\'eunuque, confus et désorienté, a été dépouillé, pendu et mutilé par les habitants de la ville avant d\'être donné en pâture aux porcs.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.weasel",
			"trait.lucky",
			"trait.cocky",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty",
			"trait.deathwish",
			"trait.impatient"
		];
		this.m.Titles = [
			"l\'Eunuque",
			"le Hongre"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.YoungMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "{Lorsque %name% n\'était qu\'un petit garçon, un clerc local l\'a castré afin que sa voix puisse porter un ton plus élevé dans la chorale locale. | Lorsque des pillards ont envahi son village, %name% s\'est défendu, mais sa queue et ses couilles ont été séparées de son corps en guise de punition. | Accusé d\'un crime odieux dans le lit d\'une femme non consentante, %name% avait le choix entre la mort et la vie d\'eunuque. Vous n\'avez pas besoin de preuves physiques pour savoir lequel des deux il a choisi. | Autrefois moine en formation, on dit que %name% a couché avec une femme d\'une autre foi. Il a été chassé de la religion et, dans une tentative de regagner leur sympathie, l\'homme a retiré l\'équipement offensant. Il semble que les fidèles ne l\'aient pas accueilli à nouveau. | Enfant, {la mère | le père | la grande soeur | le grand frère} de %name% a utilisé {une poêle chaude | un couteau dentelé} {jusqu\'à sa bite pendant qu\'il dormait | jusqu\'à sa bite comme forme de torture vicieuse.} | Alors que %name% traversait les forêts non loin de %townname%, il a été attaqué par un { sanglier | ours | chien | faucon} sauvage qui a arraché de grands morceaux de chair de son corps. Survivant, il a fini par comprendre que la bête l\'avait aussi castré. | %name% est originaire des bordels de %randomtown% où la mutilation de son corps a été faite pour satisfaire les demandes d\'un client particulier.} {L\'homme était perdu quand vous l\'avez croisé. Maintenant, il semble juste qu\'il veuille s\'éloigner du monde, même si cela signifie rejoindre des mercenaires. Bien que sa situation ne soit pas celle que vous souhaiteriez à quiconque, c\'est un homme plutôt calme. | Vous avez trouvé l\'homme qui était malmené par des enfants quand vous l\'avez trouvé. Voyant votre épée, il a poliment demandé à rejoindre votre groupe d\'hommes où le passé, ou les difformités physiques, n\'ont pas d\'importance. Il est déjà habitué aux luttes de la vie, peut-être d\'une manière dont la plupart des hommes ne peuvent parler. | Étonnamment, l\'homme se tient plus droit que la plupart des gens. Il semble plutôt calme et posé pour un homme à qui on a retiré quelque chose de si cher. | Alors que les horreurs du passé de l\'homme vous hérissent le poil, et que vos parties inférieures sont presque repliées sur elles-mêmes, l\'eunuque semble ne pas être dérangé par ce qui lui est arrivé. C\'est un personnage calme, presque passif. | Cet homme a plus de stoïcisme dans ses mouvements que la plupart des moines que vous avez vus. Il semble en paix avec son passé calamiteux. | Ne pouvant plus assouvir ses désirs charnels, l\'homme semble plutôt apaisé et calme. Résolu, même, et voyant le monde au-delà de ce que ses apparences physiques peuvent offrir.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				-5
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
				-5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
	}

});


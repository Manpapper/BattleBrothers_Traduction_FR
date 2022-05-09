this.eunuch_southern_background <- this.inherit("scripts/skills/backgrounds/eunuch_background", {
	m = {},
	function create()
	{
		this.eunuch_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = null;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.lucky",
			"trait.cocky",
			"trait.athletic",
			"trait.brute",
			"trait.bloodthirsty",
			"trait.deathwish",
			"trait.impatient"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{ Lorsque des pillards ont envahi son village, %name% s'est défendu, mais sa queue et ses couilles ont été séparées de son corps en guise de punition. | Accusé d'un crime odieux dans le lit d'une femme non consentante, %name% avait le choix entre la mort et la vie d'eunuque. Vous n'avez pas besoin de preuves physiques pour savoir lequel des deux il a choisi. | Enfant, {la mère | le père | la grande soeur | le grand frère} de %name% a utilisé {une poêle chaude | un couteau dentelé} {jusqu'à sa bite pendant qu'il dormait | jusqu'à sa bite comme forme de torture vicieuse.} | Alors que %name% traversait les forêts non loin de %townname%, il a été attaqué par un { sanglier | ours | chien | faucon} sauvage qui a arraché de grands morceaux de chair de son corps. Survivant, il a fini par comprendre que la bête l'avait aussi castré. | %name% est originaire des bordels de %randomtown% où la mutilation de son corps a été faite pour satisfaire les demandes d'un client particulier.} {L'homme était perdu quand vous l'avez croisé. Maintenant, il semble juste qu'il veuille s'éloigner du monde, même si cela signifie rejoindre des mercenaires. Bien que sa situation ne soit pas celle que vous souhaiteriez à quiconque, c'est un homme plutôt calme. | Vous avez trouvé l'homme qui était malmené par des enfants quand vous l'avez trouvé. Voyant votre épée, il a poliment demandé à rejoindre votre groupe d'hommes où le passé, ou les difformités physiques, n'ont pas d'importance. Il est déjà habitué aux luttes de la vie, peut-être d'une manière dont la plupart des hommes ne peuvent parler. | Étonnamment, l'homme se tient plus droit que la plupart des gens. Il semble plutôt calme et posé pour un homme à qui on a retiré quelque chose de si cher. | Alors que les horreurs du passé de l'homme vous hérissent le poil, et que vos parties inférieures sont presque repliées sur elles-mêmes, l'eunuque semble ne pas être dérangé par ce qui lui est arrivé. C'est un personnage calme, presque passif. | Cet homme a plus de stoïcisme dans ses mouvements que la plupart des moines que vous avez vus. Il semble en paix avec son passé calamiteux. | Ne pouvant plus assouvir ses désirs charnels, l'homme semble plutôt apaisé et calme. Résolu, même, et voyant le monde au-delà de ce que ses apparences physiques peuvent offrir.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/oriental/padded_vest"));
		}
	}

});


this.gambler_southern_background <- this.inherit("scripts/skills/backgrounds/gambler_background", {
	m = {},
	function create()
	{
		this.gambler_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 90;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.huge",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.paranoid",
			"trait.brute",
			"trait.athletic",
			"trait.dumb",
			"trait.clumsy",
			"trait.loyal",
			"trait.craven",
			"trait.dastard",
			"trait.deathwish",
			"trait.short_sighted",
			"trait.spartan",
			"trait.insecure",
			"trait.hesitant",
			"trait.strong",
			"trait.tough",
			"trait.bloodthirsty"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{On dit que la chance est le diable, alors combien de temps un joueur comme %name% peut-il jouer avec elle ? | Tout le monde joue, alors %name% s'est dit pourquoi ne pas le faire pour de l'argent ? | Dés, cartes, billes - il y a beaucoup de façons de prendre l'argent d'un homme, et %name% les connaît toutes. | %name% a les yeux d'un serpent du désert et des cartes cachés sous sa manche. | Dans un monde de vie ou de mort, prendre des risques est le jeu de %name%. | Un homme comme %name% voit tout venir, surtout la prochaine carte du jeu.} {Il a subvenu à ses besoins en jouant aux cartes de ville en ville, ne partant que lorsqu'il avait vidé leurs poches. | Mais c'est un mystère de savoir comment un homme décide de prendre les cartes comme style de vie. | Le va-et-vient constant des mercenaires en faisait des cibles faciles - jusqu'à ce qu'un mauvais perdant le fasse fuir avec une épée bâtarde. | Orphelin de naissance, il a toujours cherché à gagner sa vie en jouant avec les autres. | Quand il était enfant, un jeu de gobelets lui a montré la valeur de l'arnaque. | Lorsque son père a contracté des dettes de jeu, il s'est dit que la meilleure façon de les rembourser était de devenir lui-même un meilleur escroc. | Après avoir pris toutes leurs couronnes, les villes de tout le pays ont interdit à %name% de faire la manche dans un accès de soi-disant \"renouveau religieux\".} {Maintenant, le parieur cherche à jeter ses dés dans le vent - ainsi que dans la boue, en rejoignant n'importe quelle groupe qui paie. | On peut se demander ce qu'un joueur de cartes fait sans jouer aux cartes. Mais peut-être que c'est bien qu'il voit votre groupe comme un pari qui vaut le coup d'être testé. | Peut-être que des années à arnaquer des mercenaires lui ont donné l'idée qu'il pourrait tout aussi bien en être un. | Intelligent et vif, le parieur survit en se déplaçant avant tout le monde, une compétence aussi utile que n'importe quelle autre dans ce monde. | Ironiquement, une mauvaise pièce de théâtre lui a fait contracter une énorme dette auprès d'un baron. Maintenant, il doit trouver un autre moyen de le rembourser. | Les guerres ont fait disparaître la plupart des gros poissons de ses jeux de cartes. Au lieu d'attendre, il s'est dit qu'il allait les suivre.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/noble_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
	}

});


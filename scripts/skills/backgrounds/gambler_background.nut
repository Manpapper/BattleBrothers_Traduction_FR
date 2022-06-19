this.gambler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gambler";
		this.m.Name = "Parieur";
		this.m.Icon = "ui/backgrounds/background_20.png";
		this.m.BackgroundDescription = "Les parieurs ont tendance à avoir des réflexes rapides et une plus grande détermination que leurs adversaires à la table de jeu.";
		this.m.GoodEnding = "C\'était peut-être un risque de prendre un joueur comme %name% dans vos rangs. Mais avec le recul, il est évident que vous avez fait le bon choix. Aux dernières nouvelles, il est toujours dans la compagnie et utilise ses gains pour s\'enrichir. La rumeur dit que, grâce à ses gains, il est devenu secrètement l\'un des hommes les plus riches du pays. Vous pensez que c\'est un tas de conneries, mais un nombre surprenant de maires sont devenus soudainement laxistes sur les jeux...";
		this.m.BadEnding = "%name% le parieur s\'est retiré de la société en déclin et a repris ses habitudes de jeu. Il a rapidement acquis de grandes dettes qu\'il ne pouvait pas payer. Vous l\'avez vu mendier au coin d\'une rue avec une main en moins et des trous à la place des dents. Vous avez déposé quelques couronnes dans sa boîte et dit quelques mots, mais il ne vous a pas reconnu.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
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
		this.m.Titles = [
			"le Joker",
			"le Faiseur de Chance",
			"le Chanceux",
			"le Tricheur",
			"le Parieur"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
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
		return "{On dit que la chance est le diable, alors combien de temps un joueur comme %name% peut-il jouer avec elle ? | Tout le monde joue, alors %name% s\'est dit pourquoi ne pas le faire pour de l\'argent ? | Dés, cartes, billes - il y a beaucoup de façons de prendre l\'argent d\'un homme, et %name% les connaît toutes. | %name% a les yeux d\'un serpent du désert et des cartes cachés sous sa manche. | Dans un monde de vie ou de mort, prendre des risques est le jeu de %name%. | Un homme comme %name% voit tout venir, surtout la prochaine carte du jeu.} {Il a subvenu à ses besoins en jouant aux cartes de ville en ville, ne partant que lorsqu\'il avait vidé leurs poches. | Mais c\'est un mystère de savoir comment un homme décide de prendre les cartes comme style de vie. | Le va-et-vient constant des mercenaires en faisait des cibles faciles - jusqu\'à ce qu\'un mauvais perdant le fasse fuir avec une épée bâtarde. | Orphelin de naissance, il a toujours cherché à gagner sa vie en jouant avec les autres. | Quand il était enfant, un jeu de gobelets lui a montré la valeur de l\'arnaque. | Lorsque son père a contracté des dettes de jeu, il s\'est dit que la meilleure façon de les rembourser était de devenir lui-même un meilleur escroc. | Après avoir pris toutes leurs couronnes, les villes de tout le pays ont interdit à %name% de faire la manche dans un accès de soi-disant \"renouveau religieux\".} {Maintenant, le parieur cherche à jeter ses dés dans le vent - ainsi que dans la boue, en rejoignant n\'importe quelle groupe qui paie. | On peut se demander ce qu\'un joueur de cartes fait sans jouer aux cartes. Mais peut-être que c\'est bien qu\'il voit votre groupe comme un pari qui vaut le coup d\'être testé. | Peut-être que des années à arnaquer des mercenaires lui ont donné l\'idée qu\'il pourrait tout aussi bien en être un. | Intelligent et vif, le parieur survit en se déplaçant avant tout le monde, une compétence aussi utile que n\'importe quelle autre dans ce monde. | Ironiquement, une mauvaise pièce de théâtre lui a fait contracter une énorme dette auprès d\'un baron. Maintenant, il doit trouver un autre moyen de le rembourser. | Les guerres ont fait disparaître la plupart des gros poissons de ses jeux de cartes. Au lieu d\'attendre, il s\'est dit qu\'il allait les suivre.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-2,
				-2
			],
			Bravery = [
				12,
				12
			],
			Stamina = [
				-6,
				-5
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
				2
			],
			RangedDefense = [
				2,
				8
			],
			Initiative = [
				12,
				10
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
			items.equip(this.new("scripts/items/armor/noble_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});


local gt = this.getroottable();
gt.Const.FactionArchetypes <- [
	[
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Warmonger,
				this.Const.FactionTrait.ManOfThePeople
			],
			Description = "La maison de %noblehousename% tourne autour d\'un culte religieux qui enseigne la compassion envers les siens mais les a rendus zélés et impitoyables envers leurs ennemis. Il y a des générations, une grande invasion orque a pillé et détruit la plupart des biens de la famille, qui ne s\'en est jamais vraiment remise. Depuis lors, la maison a lancé de nombreuses croisades et expéditions punitives dans les terres orques, mais n\'a jamais réussi à chasser définitivement les peaux vertes",
			Mottos = [
				"La vertu est la seule noblesse",
				"Pour la défense des personnes en détresse",
				"Zèle et honneur",
				"Noble dans la colère",
				"Purifié par la flamme",
				"La paix est obtenue par la guerre",
				"Tant que nous avons le souffle, nous espérons",
				"Audacieusement et honorablement",
				"Nous méprisons le changement et la peur",
				"La victoire est dans la vérité",
				"La lumière dans les ténèbres",
				"Un cœur, une voie"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Sheriff,
				this.Const.FactionTrait.ManOfThePeople
			],
			Description = "La maison %noblehousename% défend les principes de justice et d\'honneur, et sans décisions irrationnelles, sa région a prospéré. Leur réputation peut être pacifique, mais les chevaliers de %noblehousename% sont aguerris au combat et leurs troupes combattent férocement toute personne menaçant leur royaume, leurs subordonnés ou leurs principes. De nombreux nobles envient leurs richesses et se moquent de leurs principes ; la maison %othernoblehouse% a notamment une rancune plus ou moins ouverte envers ceux de %noblehousename%.",
			Mottos = [
				"Vivez pour que vous puissiez vivre",
				"L\'amitié sans tromperie",
				"Ose être sage",
				"Les braves font toujours preuve de clémence",
				"Un ami pour un ami",
				"Cette main est hostile aux tyrans",
				"N\'irritez pas le lion",
				"Un chêne à la force vieillie",
				"Avec le coeur et la main",
				"Toujours vigilant",
				"Gloire au père",
				"La vertu sous la force",
				"Préparé dans tous les cas",
				"Pas seulement pour nous-mêmes"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Sheriff,
				this.Const.FactionTrait.Collector
			],
			Description = "Nombreux sont ceux qui recherchent la richesse, mais les négociants très réputés de la maison %noblehousename% sont les meilleurs lorsqu\'il s\'agit de conclure des affaires profitables. Liés par des liens ancestraux à la renommée de leurs ancêtres, ils font de l\'honnêteté et de l\'intégrité leurs valeurs familiales",
			Mottos = [
				"La raison est le guide de la vie",
				"Fermement dans l\'action et doucement dans la manière",
				"Soyons vus par nos actions",
				"S\'efforcer sans reproche",
				"Le soleil se lève après les nuages",
				"Courage dans les difficultés",
				"L\'abondance est causée par la dilligence"
			]
		}
	],
	[
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Warmonger,
				this.Const.FactionTrait.Tyrant
			],
			Description = "La maison noble de %noblehousename% est une famille fière et implacable avec une longue et sanglante histoire de conquête. Assis dans leur forteresse de %factionfortressname%, ils prennent par les armes ce qu\'ils considèrent comme leur appartenant de droit. Un fief ancestral avec la maison %othernoblehouse% fournit des raisons sans fin pour maintenir la haine dans les cœurs et les fonderies de minerai en feu.",
			Mottos = [
				"Il se tient debout par ses propres pouvoirs",
				"Il conquiert qui endure",
				"Avec audace et droiture",
				"Sous ce signe, tu vas conquérir",
				"Il ne meurt pas dont la renommée survit",
				"Aucun pas en arrière",
				"A travers les flèches et les ennemis",
				"Rien ne résiste à la bravoure et aux armes",
				"Telle est la voie de l\'immortalité",
				"Et nous avons aussi lancé nos javelots",
				"Le héron cherche les lieux élevés"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Warmonger,
				this.Const.FactionTrait.Marauder
			],
			Description = "Dédaignée pour son impitoyabilité, sa brutalité et sa cupidité, la maison %noblehousename% a peu d\'interaction avec les autres familles nobles. Leurs capitaines et soldats sont connus pour leurs raids sur les caravanes commerciales, les fermes périphériques et les petits villages depuis leur forteresse de %factionfortressname%. Une vie ne vaut pas grand chose dans le royaume de la maison %noblehousename% et plus d\'un mercenaire à la recherche d\'une pièce de monnaie n\'a trouvé qu\'une fin rapide ici.",
			Mottos = [
				"Tout ce qui pousse périt dans les cendres",
				"Nous le piétinons sous nos pieds",
				"Pour moi et pour les miens",
				"L\'aigle n\'attrape pas les mouches",
				"Des actes, pas des mots",
				"Les dieux nourrissent les corbeaux",
				"Toujours assoiffés",
				"Les fils de chiens viennent ici et prennent de la chair",
				"Pas sans butin"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Schemer,
				this.Const.FactionTrait.Tyrant
			],
			Description = "La maison %noblehousename% est détestée par beaucoup mais crainte par encore plus de monde. Un certain nombre de soulèvements, petits et grands, ont été réprimés par le feu et l\'épée et les sbires de %noblehousename% sont connus pour avoir des yeux dans tous les coins sombres et des oreilles dans tous les murs. La maison ancestrale de la famille, %factionfortressname%, fourmille de gardes armés, de chiens de garde renifleurs et de mercenaires imposant pour protéger leurs dirigeants paranoïaques.",
			Mottos = [
				"Un couteau dans l\'obscurité",
				"Couper provoque la croissance",
				"Toujours prêt",
				"La sentinelle ne dort pas",
				"Les armes maintiennent la paix",
				"Innocents comme des colombes",
				"Fermement décidé",
				"Obéir",
				"Par les lois et les armes",
				"Apprendre à supporter ce qui doit être supporté",
				"La colère du lion est noble"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Marauder,
				this.Const.FactionTrait.Tyrant
			],
			Description = "La maison %noblehousename% est bien connue pour son style de vie fastueux et ses débauche bruyante. Le prix doit être payé par quelqu\'un, donc le bétail à moitié affamé, les greniers vides et les citadins désespérés sont un spectacle commun où la maison %noblehousename% règne. Bien que d\'autres maisons nobles puissent mépriser une telle brutalité et un tel épuisement, elles attendent en même temps désespérément leur invitation au prochain festin",
			Mottos = [
				"Inconquise",
				"Cruelle rumeur, sois tranquille",
				"Je m\'élève",
				"Avec bon droit",
				"Je méprise",
				"Moutons, vous portez la laine",
				"N\'épargnez pas",
				"Le profit est acquis par le danger",
				"Souviens-toi que tu dois mourir"
			]
		}
	],
	[
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Schemer,
				this.Const.FactionTrait.Collector
			],
			Description = "Le commerce et le marchandage peuvent être tout aussi féroces que la guerre, et la maison %noblehousename% est un véritable maître des négociations rusées. La rumeur veut que de nombreuses affaires profitables conclues par la maison %noblehousename% ne soient pas seulement basées sur un commerce honnête mais aussi sur la corruption, l\'extorsion et la tromperie. La famille réside dans la pompeuse capitale régionale de %factionfortressname%, mais malgré ses richesses incommensurables, elle est connue pour être notoirement avare.",
			Mottos = [
				"Vivre sans un souhait caché",
				"La fortune favorise les audacieux",
				"Le monde ne suffit pas",
				"Séparer l\'honnête de l\'utile",
				"Notre récolte arrivera aussi",
				"Je gagne au hasard"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.ManOfThePeople,
				this.Const.FactionTrait.Collector
			],
			Description = "La maison %noblehousename% prétend avoir ses racines à l\'époque où l\'homme a revendiqué cette terre pour la première fois et où le premier roi a régné sur tous les hommes. Elle n\'est plus qu\'une des nombreuses maisons nobles, mais elle est fière de sa longue histoire et a l\'ambition de continuer à écrire l\'histoire. Alors que leur renommée et leurs ressources s\'amenuisent aujourd\'hui, on dit qu\'ils financent des expéditions dans le but de déterrer les trésors perdus du passé, dans des villes englouties et des lieux oubliés depuis longtemps",
			Mottos = [
				"Il vit deux fois qui vit bien",
				"La richesse pour celui qui sait l\'utiliser",
				"Les choses enfermées sont en sécurité",
				"Une fois et toujours",
				"Jauge et mesure",
				"En sécurité sur les vagues",
				"Chacun sa part",
				"Avec voile et rames",
				"Parmi les premiers"
			]
		},
		{
			Traits = [
				this.Const.FactionTrait.NobleHouse,
				this.Const.FactionTrait.Marauder,
				this.Const.FactionTrait.Schemer
			],
			Description = "La plupart des membres de la maison %noblehousename% vivent reclus derrière d\'épaisses portes et des fenêtres à barreaux et certains d\'entre eux n\'ont pas été vus depuis des années. La rumeur veut que leur sang noble soit en proie à la folie et à la démence, mais aucun homme ordinaire n\'ose prononcer de telles affirmations par crainte de leur vengeance. Les autres maisons nobles évitent principalement le contact avec la maison %noblehousename% car les invités peuvent être accueillis à bras ouverts ainsi qu\'avec des carreaux d\'arbalète.",
			Mottos = [
				"Rien dans la vie n\'est permanent",
				"Considère la fin",
				"Nous ne méprisons ni ne craignons rien",
				"Ne jugez pas",
				"Toutes les choses changent",
				"Chacun pour soi",
				"Toutes les choses sont donc instables",
				"Méfiez-vous du loup"
			]
		}
	]
];
gt.Const.CityStateArchetypes <- [
	{
		Traits = [
			this.Const.FactionTrait.OrientalCityState
		],
		Description = "Une ville-état riche et indépendante, principalement axée sur le commerce et l\'acquisition de nouvelles richesses",
		Mottos = [
			"Il vit bien qui vit paisiblement",
			"La richesse est ma flèche",
			"La richesse est notre épée",
			"Les tours d\'or au loin",
			"Un cadeau rendu",
			"On donne, on prend"
		]
	},
	{
		Traits = [
			this.Const.FactionTrait.OrientalCityState
		],
		Description = "Une ville-état dédiée à l\'acquisition de connaissances par-dessus tout - même si cela doit se faire au prix d\'autopsies, de lecture de tomes interdits ou d\'engagement avec des pouvoirs sinistres qui ne sont pas de ce monde",
		Mottos = [
			"Osez la sagesse",
			"La sagesse, conquérante de la fortune",
			"Lire et apprendre",
			"Le château de la sagesse",
			"La connaissance enfin"
		]
	},
	{
		Traits = [
			this.Const.FactionTrait.OrientalCityState
		],
		Description = "Une ville-état dirigée par un conseil impitoyable qui cherche à atteindre le pouvoir par tous les moyens. De nombreuses morts prématurées sont dues, selon la rumeur, à un assassinat commandité par les vizirs de %citystatename%.",
		Mottos = [
			"Un serpent dans l\'herbe",
			"De l\'ombre",
			"Par tous les moyens",
			"Le faucon n\'attrape pas les mouches"
    	]
	}
];


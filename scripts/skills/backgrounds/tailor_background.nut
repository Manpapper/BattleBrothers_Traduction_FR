this.tailor_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.tailor";
		this.m.Name = "Tailleur";
		this.m.Icon = "ui/backgrounds/background_48.png";
		this.m.BackgroundDescription = "Les tailleurs ne sont pas habitués à un travail physique éprouvant.";
		this.m.GoodEnding = "Que faisait un tailleur dans une compagnie de mercenaires ? Une bonne question, mais %name% y a certainement bien répondu en tuant tant d\'ennemis qu\'ils auraient pu en faire une tapisserie épique. Après avoir passer de très bonnes années dans la compagnie, il a fini par partir pour monter sa propre entreprise de tailleur destinée à la noblesse. Son nom est connu dans le monde entier et il a réussi à diversifier ses revenus, ce qui lui permet de gagner très bien sa vie aujourd\'hui.";
		this.m.BadEnding = "Tailleur dans l\'âme, il n\'en fallait pas plus pour pousser %name% à quitter l\'entreprise qui coulait à pic. Il est parti pour monter une affaire, mais a été kidnappé en chemin par un groupe de brigands. Lorsqu\'ils ont menacé de le tuer, il a prétendu être un simple et pauvre tailleur et leur a montré ses talents. Impressionnés, les hors-la-loi habillés en haillons l\'ont pris dans leur groupe. Quelques jours plus tard, ils étaient tous morts et cet homme \"naïf\" est sorti du camp avec un peu de rouge sur lui. Il a lancé son entreprise une semaine plus tard et se porte bien jusqu\'à présent.";
		this.m.HiringCost = 50;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.athletic",
			"trait.deathwish",
			"trait.clumsy",
			"trait.fearless",
			"trait.spartan",
			"trait.brave",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dumb",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Peculiar",
			"the Tailor",
			"the Particular",
			"the Fine",
			"Silkworm"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{%name% a toujours été curieux à propos des tissus, voyant plus de science dans un tissu de lin qu\' {un devin le ferait dans les sables du désert. | un haruspex dans les entrailles d\'un crapaud. | un alchimiste dans un mortier et son pilon.} | %name% a toujours été un garçon bizarre en grandissant, aimant les belles robes en soie plutôt que la fille qui les portent. | Fils d\'un {père mineur | écuyer | chevalier | valet de ferme}, %name% s\'est tourné vers la confection de vêtements à la surprise générale. | Alors que les sœurs de %name% s\'imaginaient être des guerrières et des héroïnes, %name% se voyait comme un futur couturier des rois. | %name% a passé une grande partie de sa jeunesse en compagnie de filles, mais pas pour les raisons que l\'on pourrait croire. | %name% a toujours aimé les animaux, en particulier ce qu\'ils pourraient donner comme manteau ou écharpe. | Les tuniques et les chemises devenant de plus en plus populaires, %name% s\'est tourné vers la couture pour se faire une ou deux couronnes. | Avec l\'augmentation de la popularité des pantalons, %name% est passé du métier de tanneur à celui de tailleur pour gagner plus d\'argent. | %name% vient d\'un pays lointain où la façon dont un homme s\'habille est plus importante que sa façon de se battre. | La confection est la science des couleurs et des tissus, et %name% est réputé pour cela. | Bon pour mesurer et calculer, %name% a mis ses talents de mathématicien au service de la couture pour gagner le plus de couronnes possibles. | La carrière de tailleur de %name% a commencé lorsque sa mère l\'a poussé dans cette voix pour éviter la conscription d\'un noble de passage. | %name% s\'est mis à la couture pour honorer son père, un tailleur qui a été tué par un client mécontent. | Veuve de guerre, la mère de %name% lui a appris à mieux utiliser ses mains en confectionnant des vêtements au lieu de tuer.} {Lorsque des pillards ont attaqué sa maison, %name% a confectionné des déguisements pour tout le monde. La ville a été détruite, mais pas une âme n\'a été emportée. | Il a passé de nombreuses années à habiller la royauté jusqu\'à ce qu\'une faute de goût le conduise à l\'exil. | Malheureusement, un homme qui avait envie d\'un beau vêtement comme %name% a l\'habitude de le faire, a banni le tailleur de nombreux villages. | Il a essayé de percer dans les grandes villes, mais malheureusement, il ne pouvait pas rivaliser avec les autres tailleurs. | Lorsqu\'un seigneur organisait une armée, %name% s\'occupait des vêtements, donnant aux soldats des uniformes appropriés. | Mais une concurrence féroce entre les tailleurs s\'est soldé par la découverte d\'un des leurs, mort, enveloppé dans du lin. %name% à laisser sa boutique derrière lui par coïncidence. | Malheureusement, des voleurs ont saccagé son magasin et, avec les guerres actuelles, il serait impossible de se réapprovisionner. | Mais quand il a tondu un mouton qui ne lui appartenait pas, %name% a été chassé de la ville. | Une fois, il a étouffé un voleur potentiel avec un mètre ruban. C\'est ce qu\'il dit, en tout cas. | Mais le fait d\'habiller une noblesse antipathique et inamicale a fini par {l\'ennuyer. | le fatigué.} | Chargé un jour de confectionner une tunique brodée d\'exploits héroïques, %name% s\'est demandé à quoi ressemblait vraiment le monde extérieur. | Concevoir une robe ornée de {quêtes épiques | exploits épiques}, %name% se demandait s\'il ne devait pas être celui sur qui on tissait des histoires.} Maintenant, le tailleur cherche une nouvelle vie, peu importe où elle le mène. {Il est peut-être capable d\'habiller correctement son unité, ou autre chose. | Il est particulier et singulier, et critique tout le monde sur leurs styles vestimentaires. | Il n\'est pas né soldat, mais il évalue la tenue d\'un homme comme s\'il était sur le point de partir en guerre avec lui. | La façon dont il mesure et calcule juste pour se vêtir, c\'est dommage que %name% n\'ait pas été ingénieur dans la fabrication d\'engins de siège. | Bien qu\'il ne soit pas un soldat, l\'amour sincère de %name% pour la confection de vêtements est admirable. | La connaissance qu\'a %name% des différents vêtements est sérieusement impressionnante. | D\'un côté comme de l\'autre, %name% a le jeu de jambes d\'un combattant à l\'épée, mais une épée aussi douce qu\'une brise matinale. | Le %name% ne semble pas à sa place dans une armure, mais il va en avoir besoin. | Il s\'avère que %name% peut en fait faire une bourse en soie à partir d\'une oreille de truie. | Ne vous fiez pas à sa vocation, %name% est plus habile de ses mains que certains {tricheurs | jongleurs | pickpockets}. | Les tailleurs ne semblent pas faits pour le combat, mais là encore, la plupart des hommes que vous rencontrez de nos jours ne le sont pas non plus. | Un tailleur semble peu apte au combat, mais pour une raison inconnue, on trouve les meilleurs soldats dans les endroits les plus étranges. | Avec un œil {pour les calculs | pour les mesures}, %name% est beaucoup plus intelligent qu\'il ne le laisse paraître à première vue.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-3,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				-5,
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
				0
			],
			RangedDefense = [
				0,
				0
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
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});


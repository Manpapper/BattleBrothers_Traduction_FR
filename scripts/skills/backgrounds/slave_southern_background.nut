this.slave_southern_background <- this.inherit("scripts/skills/backgrounds/slave_background", {
	m = {},
	function create()
	{
		this.slave_background.create();
		this.m.GoodEnding = "Vous avez acheté %name% en tant qu\'endetté pour presque rien et avez continué à lui verser un \"salaire d\'esclave\" pour son activité de mercenaire. Il en a résulté un excellent combattant, croyant sans doute qu\'il valait mieux ne pas être payé et se battre pour rester en vie plutôt que de ne pas recevoir un sou et rester à pourrir dans un coin. Après votre départ, vous avez appris que la compagnie %companyname% s\'est rendu dans le sud pour une mission et que l\'endetté a eu l\'occasion de se venger d\'un certain nombre de ses anciens ennemis. Heureusement, il ne vous considère pas comme tel, bien que vous l\'ayez gardé en esclavage.";
		this.m.BadEnding = "Vous avez acheté %name% en tant qu\'endetté et après votre retraite, il a continué avec la compagnie %companyname%. Des rumeurs sur des problèmes au sein du groupe de mercenaires ont circulé, mais rien sur la situation actuelle de l\'endetté. Connaissant la façon dont le monde fonctionne, il a été mis à l\'avant-garde comme chair à canon ou peut-être même vendu pour en récupérer les bénéfices. Dans tous les cas, le monde n\'est pas facile pour un mercenaire ou pour un endetté, et l\'homme cumule les deux fonctions.";
		this.m.Bodies = this.Const.Bodies.SouthernSlave;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		this.m.Titles = [
			"the Enslaved",
			"the Prisoner",
			"the Unlucky",
			"the Indebted",
			"the Indebted",
			"the Indebted",
			"the Unfree",
			"the Criminal",
			"the Obedient",
			"the Shackled",
			"the Bound"
		];
	}

	function onBuildDescription()
	{
		return "{La plupart des villes-états du sud du pays reposent sur les corps de prisonniers de guerre, de criminels et d\'endettés, des foules de gens qui ont offensé le Gilder ou ses disciples et qui doivent \"gagner\" leur salut en travaillant dur. %name% est l\'une de ces âmes malheureuses.} {Comme beaucoup de gens choqués, %name% n\'a pas toujours été un homme traqué. Il travaillait comme marchand ambulant jusqu\'à ce que des nomades tendent une embuscade à sa caravane. Les nomades l\'ont emmené chez un Vizir, le faisant passer pour un criminel, et l\'ont vendu en tant qu\'homme traqué. | Repéré pour sa beauté, %name% a été enlevé dans les rues de %randomcitystate% et vendu directement à un Vizir manipulateur. Il ne parle pas beaucoup de ce qui s\'est passé, mais on sent que le travail manuel n\'était pas son seul devoir. | Si grandes que soient les transgressions religieuses de ses prédécesseurs, %name% est né dans une famille endettée, et on ne sait pas jusqu\'où il faut remonter dans sa généalogie pour trouver un homme vraiment libre. | Désireux de sauver sa famille d\'une dette générationnelle, %name% s\'est vendu en tant qu\'endetté pour garantir que sa femme et ses enfants aient une vie à eux. | %name% jure qu\'il vient du nord, mais les déserts du sud l\'ont laissé hâlé et, franchement, vous n\'avez pas beaucoup de raisons de croire les paroles d\'un ancien prisonnier de guerre, peu importe d\'où il vient. | Autrefois marin, %name% a passé des années comme rameur voyageant de port en port pour conduire les marchandises des opulents marchands. Ceux qui vous l\'ont remis ont déclaré qu\'il avait un passé criminel de pirate. | %name% a été accusé d\'avoir violé une vieille femme et a eu le choix entre l\'exécution ou la servitude à vie. | Pris en train de voler sur un étal de fruits, %name% a été contraint à la servitude à vie. | Les fornications avec des \"non femmes\" entraînaient la soumission de %name% à la servitude selon les règles de la cité-état dans laquelle il avait enfreint les lois. C\'était ça ou devenir un eunuque, et on peut difficilement lui reprocher d\'avoir choisi les travaux forcés dans ce cas.} {Les difficultés de sa vie, plutôt bizarres, peuvent servir d\'excellent moule pour façonner un mercenaire digne de ce nom. | Sa servitude a sans doute rendu l\'homme redoutable en apparence, bien qu\'il soit difficile de dire où se trouve son esprit en tant que mercenaire sous contrat. | Les esclaves pour les guerriers sont monnaie courante dans les villes du sud et %name% pourrait servir de mercenaire efficace, bien qu\'asservi. | Vous espérez que %name% pourrait faire un bon mercenaire, mais vous avez le sentiment que son allégeance première est celle que tout homme désire goûter : la liberté.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-10
			],
			Bravery = [
				-10,
				-5
			],
			Stamina = [
				5,
				5
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

});


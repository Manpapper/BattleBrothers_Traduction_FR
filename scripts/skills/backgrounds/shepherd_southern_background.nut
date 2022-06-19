this.shepherd_southern_background <- this.inherit("scripts/skills/backgrounds/shepherd_background", {
	m = {},
	function create()
	{
		this.shepherd_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.hate_undead",
			"trait.impatient",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.deathwish",
			"trait.sure_footing",
			"trait.disloyal",
			"trait.greedy",
			"trait.drunkard",
			"trait.fearless",
			"trait.brave",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{%name% n\'était qu\'un simple berger d\'une simple ville, passant de nombreuses années à s\'occuper de son troupeau. | Un endroit charmant comme %townname% méritait un berger charmant comme %name%. | %name% a hérité de son troupeau le jour même où il a enterré son père. | Enfant, %name% tomba par hasard sur un berger mort et son troupeau apathique à ses côtés. Le garçon a pris le bâton du berger et a continué son travail pendant de nombreuses années. | Plus daltonien qu\'un chien, %name% a toujours apprécié la compagnie de moutons aux divers coloris. | Quand %name% est tombé d\'une tour, un troupeau de moutons a amorti sa chute. Il a juré de rembourser leur sacrifice en devenant le berger le plus sûr du pays. | %name% a trouvé son compte dans le transport de moutons d\'une ville à l\'autre, vendant leurs manteaux aux tailleurs et leurs peaux aux tanneurs. | Garder les moutons était le travail le plus facile que %name% pouvait trouver. | Aussi inoffensif que les moutons qu\'il garde, %name% a choisi de devenir berger pour trouver la paix dans ce monde cruel. | N\'ayant jamais trouvé de bons amis parmi les humains, %name% préférait la sagesse des moutons. | Brimé dans son enfance, %name% a trouvé la paix en gardant des troupeaux de moutons. | Les moutons étant joueurs et dociles, %name% a reçu le calme et la paix qu\'il n\'avait pas reçu pendant sa prime enfance. | Confondu une fois avec un {prophète | nouveau messie}, %name% a échappé aux {hordes religieuses | inquisiteurs en colère} en fuyant pour, a terme, embrasser sa vocation de berger. | Regarder {les moutons | les pelotes de laine blanche} grignoter de l\'herbe toute la journée peut sembler ennuyeux, mais pour %name% c\'était le bonheur. | Captivé par un concours de chien de berger, %name% en a fait son métier et sa vocation. | Le berger étant toujours quelqu\'un de doux et gentil, ce métier était logique pour les gens comme %name%. | Ayant échappé au abus de {sa mère| son père | ses soeurs | ses frères | son oncle | sa tante}, %name% a choisi la sérénité d\'être un berger.} {mêlé à un conflit religieux entre les adeptes des dieux et les cultistes, son troupeau a subi la colère de ceux qui cherchaient à la fois des boucs émissaires et des sacrifices. | Après avoir repoussé {les brigands | les loups} avec sa canne, le berger s\'est dit qu\'il était sans doute plus fort que ce qu\'il pensait. | Avec le temps, l\'homme s\'est senti {comme si sa vocation l\'avait dépassé. | comme si le cœur n\'y était plus.} {Il s\'est retiré en pleurant | Il a raccroché son bâton de berger} et a cherché un autre travail. | Ayant l\'impression de voir la beauté du monde mais de ne pas la vivre pleinement, l\'homme décide d\'abandonner le métier de berger. | Lorsque d\'énormes bêtes à fourrure ont massacré son troupeau, le berger a cherché à se venger. | Malheureusement, le seul compagnon de l\'homme, un chien de berger, a été tué par {des brigands | des orcs | des loups}, laissant notre homme paisible en quête de vengeance. | Pris dans les filets d\'un escroc, le berger a soudain eu besoin de plus d\'argent que son troupeau de moutons ne pouvait en fournir. | Cependant, la solitude de sa vie a fini par avoir raison du berger. | Mais les longues journées et nuits passées seul épuisaient le berger comme ca aurait été le cas pour tout autre personne. | Mais il ne peut échapper à la masculinité que son père attend de lui, et pose un jour sa canne pour se chercher une vocation plus virile. | Mais un jour, alors qu\'il gardait les moutons, il les a tous dirigés en direction d\'une falaise. | Mais par un après-midi pluvieux, il a pris un bêêh de trop : il devait faire autre chose que de contempler des moutons toute la journée. | Malheureusement, les rumeurs sur ce qu\'il faisait dans l\'intimité de son troupeau étaient trop gênantes pour qu\'il y soit confronté et il a dû fuir vers des pâturages plus verts et plus accueillants. | Malheureusement, des nomades ivres de violence sont tombés sur son troupeau. Bessie, Little Ada, et même le nouveau-né Goatsieg ont été tués dans le sang.} {En s\'arrêtant en ville pour réfléchir, %name% est tombé sur un recrutement de mercenaires. N\'ayant rien à perdre, il est prêt à s\'engager. | La contrée n\'avait pas de place pour un berger paisible. Il était temps de passer à autre chose. | Une minuscule cloche rouillée de sang est accrochée au cou de %name%. C\'est la relique d\'une ancienne vie, et peut-être le signe d\'une nouvelle. | Il jure entendre encore les bêlements de son troupeau. Pour une raison ou pour une autre, cela n\'inspire pas beaucoup de confiance dans ses compétences de combat. | Bien que paisible, sans troupeau, l\'homme est perdu. | Bien qu\'il ne soit pas un combattant, l\'homme sait comment maintenir une formation serrée. | %name% connaît les étoiles étonnamment bien et peut localiser un son dans l\'obscurité comme un chien aveugle reniflant une friandise. | Marcher autant a donné à %name% des jambes robustes, mais sa plus grande expérience du combat se fait avec un bâton. | Le monde n\'a pas l\'habitude de se tourner vers les bergers lorsqu\'il est dans le besoin, mais en ce moment, il en a besoin. | En regardant le berger, on se demande à quel point les choses ont mal tourné pour qu\'un tel homme se tienne là où il est. | %name% porte presque toutes les armes comme s\'il s\'agissait de bâtons de marche, et il a la mauvaise habitude de taper sur les jambes des autres pour les faire avancer. | L\'humilité de %name% est un répit bienvenu par rapport aux frères qui deviennent des mercenaires. | %name% ne ferait pas de mal à une mouche, mais avec un bon entraînement, vous pouvez faire en sorte qu\'il puisse au moins l\'attraper. | %name% n\'a pas la conviction meurtrière des autres mercenaires, mais comme tout homme, il peut être formé de la bonne façon. | Certains des hommes de la compagnie %companyname% sont à peine mieux que des moutons. Peut-être que %name% a sa place ici après tout.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Math.rand(1, 100) <= 66)
		{
			items.equip(this.new("scripts/items/weapons/oriental/nomad_sling"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
	}

});


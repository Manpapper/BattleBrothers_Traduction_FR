this.vagabond_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.vagabond";
		this.m.Name = "Vagabond";
		this.m.Icon = "ui/backgrounds/background_32.png";
		this.m.BackgroundDescription = "Les vagabonds sont habitués aux longs voyages, mais n\'excellent dans aucun domaine en particulier.";
		this.m.GoodEnding = "Certains hommes sont simplement destinés à errer. Bien que le temps passé avec la compagnie %compagnie% ait été bon, %name% le vagabond a fini par la quitter et est reparti sur les routes. Vous n\'avez aucune idée de l\'endroit où il se trouve, mais vous savez que tout ce qui l\'intéresse, c\'est de partir.";
		this.m.BadEnding = "La compagnie étant à bout de souffle, il n\'est guère surprenant qu\'un vagabond comme %name% ait choisi de tout laisser derrière lui et de partir. Malheureusement, avec un monde dans un tel état, il n\'a pas fallu longtemps pour qu\'il soit dans le pétrin. Son corps a été retrouvé pendu à l\'extérieur d\'un petit village agricole. Une pancarte clouée sur sa poitrine indiquait : \"Vagabondage interdit\".";
		this.m.HiringCost = 70;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.clubfooted",
			"trait.fat",
			"trait.loyal",
			"trait.gluttonous",
			"trait.asthmatic"
		];
		this.m.Titles = [
			"the Vagabond",
			"the Wanderer",
			"Threefeet",
			"Bindlestiff",
			"Tatterdemalion",
			"the Homeless",
			"the Restless",
			"the Traveller",
			"the Raven"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
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
		return "{Chassé de sa ville par la guerre, %name% erre dans le monde comme un vagabond. | Paresseux et démotivé, %name% met ,un jour, ses trois affaires dans un sac à dos et prend la route. | N\'ayant jamais été très fort l\'école, %name% a abandonné l\'éducation pour vagabonder ici et là. | %name% n\'a pas eu le sens des affaires pour protéger son héritage des débiteurs, des hommes de loi et autres malfaiteurs. Il erre maintenant avec la dernière de ses couronnes en poche. | La vie sur la route a fait de %name% un homme à tout faire, sans toutefois réussir à maitriser un seul métier - sauf la marche, bien sûr. | N\'étant pas vraiment fait pour la ville, ni pour la nature, %name% passe ses journées sans but à voyager entre les deux. | Pendant ses jours de beuverie, %name% à parier une petite fortune aux jeux. Maintenant sans abri, il erre simplement. | Quand sa femme a été assassinée en son absence, %name% a refusé de dormir dans la maison. il parcourt le monde, essayant d\'oublier ce souvenir. | Son fils en a assassiné cinq autres. Par honte, %name% a abandonné sa ville natale pour parcourir le monde et oublier ses échecs en tant que père.} {Mais lorsqu\'un gang de voleurs lui a pris tout ce qu\'il avait - y compris ses chaussures - il a su qu\'il avait besoin d\'un nouveau départ. | Mais lorsqu\'il est arrivé à un embranchement, l\'homme s\'est rendu compte qu\'il n\'avait pas mangé depuis un certain temps. Son estomac exigeait un changement de décor - et de régime. | Malheureusement, le monde n\'est pas un endroit accueillant pour ceux qui ne manqueraient à personne. Il était harcelé et intimidé tous les jours. | Après une journée particulièrement dure à marcher dans la boue, il a réalisé qu\'il n\'y avait aucune vie à avoir en marchant simplement. | Étrangement, un jour, il a rencontré un compagnon de route qui est vite devenu son frère qu\'il n\'avait jamais eu. Il lui a dit qu\'il y avait des mercenaires qui cherchaient de la main d\'œuvre - et qu\'ils le paieraient pour le faire, aussi ! | Comme tout personne impulsive, il a joué à pile ou face pour savoir s\'il devait ou non s\'essayer au métier de mercenaire.} {Il n\'est pas particulièrement doué pour quoi que ce soit, mais %name% a vu et fait beaucoup de choses, et cela vaut au moins quelque chose. | Se débrouiller dans ce pays violent et survivre en gardant tous les membres de son corps, c\'est beaucoup plus dur que ce que certains s\'imaginent. | Une bande de mercenaires ne serait qu\'une aventure de plus pour un vagabond comme %name%. On espère qu\'il survivra pour l\'écrire. | Au cours de ses voyages, sa seule arme était un bâton de marche. Voyons comment il se débrouille avec quelque chose d\'un peu plus tranchant. | Un voleur, une crapule, un boulanger, un tailleur, %name% a tout fait. Dommage qu\'il n\'ait jamais été bon à aucune de ces choses. Peut-être que ce sera différent cette fois. | La vie a été dure pour %name% depuis de nombreuses années. Cela ne va pas changer, mais au moins il sera avec des frères maintenant.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-3,
				0
			],
			Bravery = [
				-5,
				-7
			],
			Stamina = [
				10,
				15
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
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});


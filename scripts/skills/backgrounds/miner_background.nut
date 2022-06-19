this.miner_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.miner";
		this.m.Name = "Mineur";
		this.m.Icon = "ui/backgrounds/background_45.png";
		this.m.BackgroundDescription = "Un mineur est habitué au travail physique, mais respirer l\'air poussiéreux des mines peut avoir eu un impact sur sa santé au fil des ans.";
		this.m.GoodEnding = "%name% le mineur n\'est jamais retourné dans les mines, heureusement. S\'il y a une vie qui pourrait être pire que celle de se battre pour vivre, c\'est bien celle de creuser dans les montagnes pour vivre! Apparemment, le mineur a construit une maison au bord de la mer, passant le reste de ses jours à pêcher tranquillement pour le dîner et à profiter des levers de soleil ou une autre connerie du genre.";
		this.m.BadEnding = "S\'il y a une vie plus rude que celle de mercenaire, c\'est bien celle de mineur. Malheureusement, %name% est retourné à cette vie, retournant dans les mines pour extraire des métaux et des minerais afin de remplir les poches d\'un riche homme. Un récent tremblement de terre a fait s\'effondrer beaucoup de ces mines. Vous n\'êtes pas sûr que le vieux frère ait survécu, c\'est triste.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.swift",
			"trait.iron_lungs",
			"trait.bright",
			"trait.fat",
			"trait.clumsy",
			"trait.fragile",
			"trait.strong",
			"trait.craven",
			"trait.dastard"
		];
		this.m.Titles = [
			"the Miner",
			"the Crawler",
			"Earthside"
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
		return "{Pour subvenir aux besoins d\'une famille sans père, %name% est descendu dans les mines dès son plus jeune âge. | Orphelin, le seul travail que %name% a pu trouver était de travailler dans les mines. | L\'exploitation minière est un travail difficile, le genre de travail que les hommes comme %name% recherchent. | Même si son père est mort dans les mines, %name% s\'est senti obligé d\'y descendre, comme la plupart des hommes de son milieu. | %name% a travaillé dans les mines comme une tradition familiale étalée sur plusieurs générations. | Lorsque des guerres éclatent, les mineurs comme %name% sont plus que jamais indispensables, par crainte qu\'une armée ne se retrouve sans acier disponible. | Un marteau et une pioche, les outils que %name% utilise depuis des années pour creuser dans la mine.} {Mais une mine n\'est pas inépuisable, et le mineur a échappé de justesse au dernier effondrement. | Malheureusement, il s\'est avéré être le seul survivant de l\'effondrement d\'un conduit, et il n\'est pas question qu\'il y retourne tout seul. | Après l\'effondrement tragique d\'une mine, la vue de dizaines de veuves a poussé l\'homme à chercher un autre domaine d\'activité. | Ayant survécu à un nouvel effondrement, la femme de l\'homme a exigé qu\'il cherche un nouveau travail, quel qu\'il soit. | C\'est fatiguant de se pencher et se déplacer dans l\'obscurité, l\'homme a donc cherché une autre vocation. | Travaillant dans des environnements beaucoup trop sombres, l\'homme a accidentellement tué un collègue. La tragédie l\'a poussé à quitter le milieu. | Après que son propre fils ait perdu la vie dans les mines, l\'homme a quitté ce métier pour toujours. | Mais souffrant d\'une toux incessante, l\'homme s\'est dit qu\'une carrière à l\'air libre lui conviendrait peut-être mieux.} {%name% a la carrure trapue d\'un mineur. Malheureusement, il en a aussi ses poumons. | Il est solide, mais la respiration sifflante de %name% ressemble à des lames rouillées qui s\'entrechoquent.  | Vous vous demandez si les poumons de %name% contiennent assez de poussière de métal pour fabriquer une lame ou deux. | L\'haleine de %name% pourrait probablement encrer un morceau de charbon. | %name% a passé des années à gagner de l\'argent pour une entreprise. Maintenant, il veut gagner le sien. | %name% a hâte d\'empocher une partie de l\'or qu\'il a extrait de la terre depuis des années. | De façon désagréable, %name% pointe du doigt la moitié de votre équipement - les trucs en métal le plus souvent - et rappelle à tout le monde qui en est l\'auteur. | %name% a une vision presque féline dans l\'obscurité. Il aurait fait un bon assassin s\'il n\'avait pas eu cette satanée respiration sifflante. | %name% a trompé la mort plusieurs fois, alors pourquoi ne pas continuer sur cette lancée en tant que mercenaire? | %name% a déjà eu de la terre elle-même au dessus de sa tête alors quelques trucs sur le sol ne l\'effraient pas beaucoup. |Si l\'obscurité est vraiment l\'ambassadrice de la mort, %name% lui a déjà parlé pendant des années. | Les âmes bêtement courageuses comme %name% peuvent certainement trouver un bon registre avec cette tenue. | %name% se vante fièrement qu\'il était autrefois capable de jouer aux cartes dans le noir. Vous n\'en doutez pas. | Si %name% peut manier l\'épée aussi bien que la pioche, alors tout va bien.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				10
			],
			Bravery = [
				5,
				8
			],
			Stamina = [
				-10,
				-10
			],
			MeleeSkill = [
				5,
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

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/pickaxe"));
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/mouth_piece"));
		}
	}

});


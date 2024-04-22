this.gravedigger_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.gravedigger";
		this.m.Name = "Fossoyeur";
		this.m.Icon = "ui/backgrounds/background_28.png";
		this.m.BackgroundDescription = "Les fossoyeurs sont habitués au travail physique et à manipuler les morts.";
		this.m.GoodEnding = "Grâce aux nombreux succès de la compagnie %companyname%, %name% le fossoyeur a pu continuer à pratiquer son métier. Comme les couronnes ont commencé à s\'empiler, il a fini par quitter la compagnie et est retourné aux cimetières. Aux dernières nouvelles, il s\'était remis à creuser des trous et élevait joyeusement une famille de sacristains.";
		this.m.BadEnding = "D\'après ce que tu as entendu, %name% le fossoyeur était l\'un des derniers hommes à quitter la compagnie %companyname%. Avec à peine une couronne en poche, il a sombré dans la boisson et aux dernières nouvelles, son corps a été retrouvé dans un ravin boueux.";
		this.m.HiringCost = 50;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.night_blind",
			"trait.swift",
			"trait.cocky",
			"trait.craven",
			"trait.fainthearted",
			"trait.dexterous",
			"trait.quick",
			"trait.iron_lungs",
			"trait.optimist"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
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
		return "{%name% a fait ses débuts comme fossoyeur en enterrant son petit frère. | C\'est en mettant une épée dans le cou de son père ivre que %name% a fait ses débuts en tant que fossoyeur. D\'abord il a caché le crime, puis il a enterré les hommes qui venaient poser des questions. | Après que la maladie ait balayé %townname%, %name% était le dernier homme debout. Il a dû abandonner son métier pour se consacrer à la seule chose qui restait : fossoyeur.} On dit que les morts ont un regard. Mais il y a aussi un regard dans ceux qui ont vu les morts. %name% a maintenant passé une vie et demi {à regarder des cadavres | à mettre des corps en terre | à creuser des tombes, grandes et petites}. Pour ce fossoyeur, {la mort n\'est plus qu\'une science | les morts ont été de meilleure compagnie que les vivants | gagner de l\'or pour enterrer les morts n\'est pas une nouvelle tâche}. {Employé par un convoi, %name% parcourait la terre et la creusait aussi. Mais un jour, il a eu une mésaventure lors de l\'un de ses nombreux enterrements. Non pas à cause de buses ou de rats, mais à cause du mort lui-même. Voir un tel spectacle, et devoir enterrer le même homme deux fois, oblige sans doute à un changement rapide de carrière. | Chaque fossoyeur est regardé avec suspicion. Il n\'a pas fallu longtemps pour que ses clients deviennent des accusateurs et que la notion d\'un crime horrible de passion charnel avec un mort-vivant le détourne de son travail. Les accusations sont absurdes, mais on ne peut pas lire sur son visage pâle. C\'est comme jouer aux cartes avec la lune. | A présent, l\'homme semble avoir besoin d\'un changement de paysage. Mais ne lui demandez pas d\'enterrer les victimes.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				4
			],
			Bravery = [
				7,
				5
			],
			Stamina = [
				5,
				7
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
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});


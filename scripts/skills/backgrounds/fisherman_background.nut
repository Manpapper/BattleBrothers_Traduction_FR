this.fisherman_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.fisherman";
		this.m.Name = "Pêcheur";
		this.m.Icon = "ui/backgrounds/background_15.png";
		this.m.BackgroundDescription = "Les pêcheurs sont habitués au travail physique.";
		this.m.GoodEnding = "%name% s\'est retiré des combats et est retourné à ses activités de pêche. Une énorme tempête s\'est abattue sur les côtes, détruisant toutes les embarcations, sauf celle de ce pêcheur rusé! Seul bateau à flot, les affaires de %name% ont explosé. Il vit une vie confortable en se réveillant chaque matin avec une belle vue sur la plage.";
		this.m.BadEnding = "La carrière de combattant se déroulant si mal, %name% décide de se retirer du terrain et de retourner à la pêche. Il a disparu en mer après qu\'une énorme tempête ait ravagé les rivages.";
		this.m.HiringCost = 65;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.night_blind",
			"trait.tiny",
			"trait.fat"
		];
		this.m.Titles = [
			"le Pêcheur",
			"le Poissonnier"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{%name% aimait la mer et la sérénité de la pêche en solitaire sur l\'eau | Ironiquement, %name% a toujours détesté l\'eau, mais il est devenu pêcheur après son père et le père de son père.. | %name% était un pêcheur fort et compétent | %name% se contentait d\'être un pêcheur | %name% a toujours eu la chance de trouver les meilleurs lieux de pêche et d\'attraper les plus gros poissons}. Tant qu\'il n\'y avait pas de tempête, il était là, à pêcher, jour après jour. {Malheureusement, sa cabane de pêcheur a été réduite en cendres alors qu\'il était en mer. | Mais le désastre survient lorsqu\'il perd son meilleur ami en mer lors d\'une tempête soudaine, le laissant avec un bateau gravement endommagé et personne avec qui naviguer. | Mais le désastre survient lorsque sa femme meurt pendant l\'accouchement, bouleversant tout ce qui lui était cher. | Cependant, après avoir été incapable de payer ses dettes pendant un certain temps, son bateau lui a été enlevé par un usurier sans pitié. | C\'est après avoir étranglé sa femme dans un accès de rage qu\'il a perdu tout intérêt pour le métier de pêcheur. | À son grand désarroi, pendant presque tout un été, la plupart des poissons qu\'il attrapait étaient déjà morts et pourris à l\'intérieur. | C\'est après qu\'un prêtre des dieux ait dit à %name% que la vie de pêcheur n\'était pas ce qu\'ils souhaitaient de lui, mais qu\'ils souhaitaient qu\'il fasse couler le sang en leur nom, qu\'il s\'est tourné vers un autre métier.} En visitant la taverne un soir, une nouvelle opportunité s\'est présentée avec la promesse d\'argent pour un travail dangereux.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				5,
				0
			],
			Bravery = [
				5,
				0
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
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		items.equip(this.new("scripts/items/tools/throwing_net"));
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});


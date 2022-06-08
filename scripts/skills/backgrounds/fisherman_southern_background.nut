this.fisherman_southern_background <- this.inherit("scripts/skills/backgrounds/fisherman_background", {
	m = {},
	function create()
	{
		this.fisherman_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.night_blind",
			"trait.tiny",
			"trait.fat"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{%name% aimait la mer et la sérénité de la pêche en solitaire sur l\'eau | Ironiquement, %name% a toujours détesté l\'eau, mais il est devenu pêcheur après son père et le père de son père.. | %name% était un pêcheur fort et compétent | %name% se contentait d\'être un pêcheur | %name% a toujours eu la chance de trouver les meilleurs lieux de pêche et d\'attraper les plus gros poissons}. Tant qu\'il n\'y avait pas de tempête, il était là, à pêcher, jour après jour. {Malheureusement, sa cabane de pêcheur a été réduite en cendres alors qu\'il était en mer. | Mais le désastre survient lorsqu\'il perd son meilleur ami en mer lors d\'une tempête soudaine, le laissant avec un bateau gravement endommagé et personne avec qui naviguer. | Mais le désastre survient lorsque sa femme meurt pendant l\'accouchement, bouleversant tout ce qui lui était cher. | Cependant, après avoir été incapable de payer ses dettes pendant un certain temps, son bateau lui a été enlevé par un usurier sans pitié. | C\'est après avoir étranglé sa femme dans un accès de rage qu\'il a perdu tout intérêt pour le métier de pêcheur. | À son grand désarroi, pendant presque tout un été, la plupart des poissons qu\'il attrapait étaient déjà morts et pourris à l\'intérieur. | C\'est après qu\'un prêtre des dieux ait dit à %name% que la vie de pêcheur n\'était pas ce qu\'ils souhaitaient de lui, mais qu\'ils souhaitaient qu\'il fasse couler le sang en leur nom, qu\'il s\'est tourné vers un autre métier.} En visitant la taverne un soir, une nouvelle opportunité s\'est présentée avec la promesse d\'argent pour un travail dangereux.";

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


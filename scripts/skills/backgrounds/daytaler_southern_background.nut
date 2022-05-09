this.daytaler_southern_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
	m = {},
	function create()
	{
		this.daytaler_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernSkinny;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.SouthernUntidy;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 90;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.fear_undead",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{Travailler ici et là | Sans travail stable | Travailler et s\'arrêter | Faire ceci et cela | N\'ayant appris aucun métier}, %name% est connu comme un \"Travailleur Journalier\", quelqu\'un à qui l\'on demande un coup de main supplémentaire quand on en a besoin. {Le travail a été rare pendant un certain temps maintenant, alors | Il y avait peu de travail à faire ces dernières semaines, alors | %name% voulait faire quelque chose qu\'il n\'avait jamais fait auparavant, alors | Bien qu\'il n\'ait aucune expérience de la bataille, regarder trop profondément dans la bouteille lui a fait croire que | %name% considère que la profession de combattant est une profession qui ne manque pas de travail de nos jours, alors | %name% a perdu l\'être aimé à cause de la maladie, comme c\'est souvent le cas de nos jours, et a craqué. Après des semaines passées à boire pour oublier son chagrin,} une compagnie de mercenaires itinérants semblait être une bonne opportunité {pour rester avec eux pendant un certain temps | pour gagner quelques pièces | pour voir un peu le monde | pour se vider la tête | pour l\'amener au prochain village tout en remplissant ses poches.}.";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

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
		else
		{
			local item = this.new("scripts/items/armor/oriental/cloth_sash");
			items.equip(item);
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});


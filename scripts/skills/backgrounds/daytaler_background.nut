this.daytaler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.daytaler";
		this.m.Name = "Travailleur Journalier";
		this.m.Icon = "ui/backgrounds/background_36.png";
		this.m.BackgroundDescription = "Les travailleurs journaliers sont habitués à toutes sortes de travaux physiques, mais n\'excellent dans aucun d\'entre eux.";
		this.m.GoodEnding = "%name% the daytaler retired from fighting and, well, he keeps working with his hands. Now he\'s back to laying bricks and carrying hay instead of slaying beasts and crushing heads. He took all his mercenary money to purchase a bit of land and settle down. While not the richest man, word has it that there is hardly a happier man in the realm.";
		this.m.BadEnding = "%name% retired from fighting while he still had most of his fingers and toes intact. He went back to working for the nobility. Last you heard he was out {south | north | east | west} building a great tower for some nobleman. Sadly, you also heard that tower collapsed halfway through its construction with many workers going down with it.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{Travailler ici et là | Sans travail stable | Travailler et s\'arrêter | Faire ceci et cela | N\'ayant appris aucun métier}, %name% est connu comme un \"Travailleur Journalier\", quelqu\'un à qui l\'on demande un coup de main supplémentaire quand on en a besoin. {Le travail a été rare pendant un certain temps maintenant, alors | Il y avait peu de travail à faire ces dernières semaines, alors | %name% voulait faire quelque chose qu\'il n\'avait jamais fait auparavant, alors | Bien qu\'il n\'ait aucune expérience de la bataille, regarder trop profondément dans la bouteille lui a fait croire que | %name% considère que la profession de combattant est une profession qui ne manque pas de travail de nos jours, alors | %name% a perdu l\'être aimé à cause de la maladie, comme c\'est souvent le cas de nos jours, et a craqué. Après des semaines passées à boire pour oublier son chagrin,} une compagnie de mercenaires itinérants semblait être une bonne opportunité {pour rester avec eux pendant un certain temps | pour gagner quelques pièces | pour voir un peu le monde | pour se vider la tête | pour l\'amener au prochain village tout en remplissant ses poches.}.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				0,
				3
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
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/headscarf"));
		}
	}

});


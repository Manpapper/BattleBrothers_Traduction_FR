this.pacified_flagellant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.pacified_flagellant";
		this.m.Name = "Flagellant apaisé";
		this.m.Icon = "ui/backgrounds/background_13.png";
		this.m.HiringCost = 60;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.clubfooted",
			"trait.tough",
			"trait.strong",
			"trait.disloyal",
			"trait.insecure",
			"trait.cocky",
			"trait.fat",
			"trait.fainthearted",
			"trait.bright",
			"trait.craven",
			"trait.greedy",
			"trait.gluttonous"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.IsOffendedByViolence = true;
	}

	function onBuildDescription()
	{
		return "Après une longue discussion avec un moine, %name% s\'est converti à un moyen plus pacifique d\'exprimer sa foi. Désormais, lorsqu\'il prend une arme, vous pouvez être sûr qu\'elle ne sera pointée que sur quelqu\'un d\'autre que lui.";
	}

	function onAddEquipment()
	{
	}

});


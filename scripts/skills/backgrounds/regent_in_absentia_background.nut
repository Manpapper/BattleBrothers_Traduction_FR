this.regent_in_absentia_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.regent_in_absentia";
		this.m.Name = "Régent d\'Absentia";
		this.m.Icon = "ui/backgrounds/background_06.png";
		this.m.HiringCost = 135;
		this.m.DailyCost = 17;
		this.m.Excluded = [
			"trait.clumsy",
			"trait.fragile",
			"trait.spartan",
			"trait.clubfooted"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.IsCombatBackground = true;
		this.m.IsNoble = true;
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
		return "{%name% n\'est plus désavoué par sa famille royale, mais son allégeance va désormais à la compagnie %companyname%. Bien qu\'il ne soit pas retourné dans sa famille royale, vous savez qu\'au fond de lui, il appartiendra toujours à sa lignée.}";
	}

	function onAddEquipment()
	{
	}

});


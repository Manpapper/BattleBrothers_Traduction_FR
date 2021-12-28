this.gladiator_origin_background <- this.inherit("scripts/skills/backgrounds/gladiator_background", {
	m = {},
	function create()
	{
		this.gladiator_background.create();
		this.m.DailyCost = 50;
		this.m.DailyCostMult = 1.0;
	}

	function onAddEquipment()
	{
	}

});


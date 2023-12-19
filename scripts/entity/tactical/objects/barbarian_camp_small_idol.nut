this.barbarian_camp_small_idol <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Idole";
	}

	function getDescription()
	{
		return "Une idole barbare.";
	}

	function onInit()
	{
		local variants = [
			"orcs_08",
			"barbarians_03"
		];
		local body = this.addSprite("body");
		body.setBrush(variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


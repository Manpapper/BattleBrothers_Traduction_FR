this.barbarian_camp_Fireplace <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Foyer";
	}

	function getDescription()
	{
		return "Un foyer pour cuisiner.";
	}

	function onInit()
	{
		local variants = [
			"01"
		];
		local body = this.addSprite("body");
		body.setBrush("barbarians_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


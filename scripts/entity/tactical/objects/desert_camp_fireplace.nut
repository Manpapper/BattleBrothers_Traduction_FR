this.desert_camp_Fireplace <- this.inherit("scripts/entity/tactical/entity", {
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
			"05",
			"08"
		];
		local body = this.addSprite("body");
		body.setBrush("desert_camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


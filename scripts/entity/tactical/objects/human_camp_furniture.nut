this.human_camp_furniture <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Furniture";
	}

	function getDescription()
	{
		return "Wooden furniture for this camp\'s inhabitants.";
	}

	function onInit()
	{
		local variants = [
			"14"
		];
		local body = this.addSprite("body");
		body.setBrush("camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


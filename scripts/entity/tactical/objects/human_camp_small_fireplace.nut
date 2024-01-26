this.human_camp_small_Fireplace <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Foyer";
	}

	function getDescription()
	{
		return "Un foyer avec un chaudron.";
	}

	function onInit()
	{
		local variants = [
			"10"
		];
		local body = this.addSprite("body");
		body.setBrush("camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


this.human_camp_wood <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Chopped Wood";
	}

	function getDescription()
	{
		return "Wood chopped as firewood or for constructing palisades.";
	}

	function onInit()
	{
		local variants = [
			"11",
			"15"
		];
		local body = this.addSprite("body");
		body.setBrush("camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


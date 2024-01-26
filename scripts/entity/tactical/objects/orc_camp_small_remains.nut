this.orc_camp_small_remains <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Restes d'animaux";
	}

	function getDescription()
	{
		return "Restes macabres d'une sorte d'animal.";
	}

	function onInit()
	{
		local variants = [
			"02",
			"03"
		];
		local body = this.addSprite("body");
		body.setBrush("orcs_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


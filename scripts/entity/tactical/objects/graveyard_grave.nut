this.graveyard_grave <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Graves";
	}

	function getDescription()
	{
		return "The last resting place of some unfortunate souls.";
	}

	function onInit()
	{
		local variants = [
			"10",
			"11",
			"12"
		];
		local body = this.addSprite("body");
		body.setBrush("graveyard_" + variants[this.Math.rand(0, variants.len() - 1)]);
		body.setHorizontalFlipping(this.Math.rand(0, 1) == 1);
	}

});


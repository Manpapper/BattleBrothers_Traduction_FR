this.graveyard_ruins <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Ruins";
	}

	function getDescription()
	{
		return "Ruins of crumbled stone.";
	}

	function onInit()
	{
		local variants = [
			"20",
			"33",
			"33",
			"33"
		];
		local r = this.Math.rand(0, variants.len() - 1);
		local body = this.addSprite("body");
		body.setBrush("graveyard_" + variants[r]);
		body.setHorizontalFlipping(this.Math.rand(0, 1) == 1);

		if (variants[r] != "33")
		{
			this.setBlockSight(true);
		}
	}

});


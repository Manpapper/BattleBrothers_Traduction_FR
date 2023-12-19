this.tree_stump2 <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Tree Stump";
	}

	function getDescription()
	{
		return "The remains of a cut-down tree.";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("stump_04");
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.varyColor(0.05, 0.05, 0.05);
		body.Scale = 0.6 + this.Math.rand(0, 40) / 100.0;
		body.Rotation = this.Math.rand(-5, 5);
	}

});


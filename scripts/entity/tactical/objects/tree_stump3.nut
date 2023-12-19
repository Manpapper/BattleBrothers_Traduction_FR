this.tree_stump3 <- this.inherit("scripts/entity/tactical/entity", {
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
		body.setBrush("snow_forest_treetrunk_02");
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.Scale = 0.4 + this.Math.rand(0, 30) / 100.0;
		body.Rotation = this.Math.rand(-5, 5);
	}

});


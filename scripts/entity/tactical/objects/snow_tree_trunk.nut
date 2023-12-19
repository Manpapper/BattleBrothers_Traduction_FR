this.snow_tree_trunk <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return this.Const.Strings.Tactical.EntityName.Tree;
	}

	function getDescription()
	{
		return "The remains of a once proud tree.";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("snow_forest_treetrunk_0" + this.Math.rand(1, 3));
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.Scale = 0.7 + this.Math.rand(0, 30) / 100.0;
	}

});


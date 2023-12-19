this.swamp_tree_trunk <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return this.Const.Strings.Tactical.EntityName.Tree;
	}

	function getDescription()
	{
		return this.Const.Strings.Tactical.EntityDescription.TreeTrunk;
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("swamp_treetrunk_01");
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.varyColor(0.07, 0.07, 0.07);
		body.Scale = 0.7 + this.Math.rand(0, 30) / 100.0;
	}

});


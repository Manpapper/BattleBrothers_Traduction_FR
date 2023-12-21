this.tree_trunk_forest <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return this.Const.Strings.Tactical.EntityName.Tree;
	}

	function getDescription()
	{
		return "Les restes d'un arbre d'autrefois.";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("forest_treetrunk_0" + this.Math.rand(2, 4));
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.Color = this.createColor("#dbdef0");
		body.varyColor(0.05, 0.05, 0.05);
		body.Scale = 0.7 + this.Math.rand(0, 30) / 100.0;
	}

});


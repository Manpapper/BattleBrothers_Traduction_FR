this.tree_lush_smaller <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return this.Const.Strings.Tactical.EntityName.Tree;
	}

	function getDescription()
	{
		return this.Const.Strings.Tactical.EntityDescription.Tree;
	}

	function onInit()
	{
		local v = this.Math.rand(1, 3);
		local rotation = this.Math.rand(-5, 5);
		local scale = 0.7;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("tree_0" + v + "_bottom");
		bottom.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		bottom.varyColor(0.03, 0.03, 0.03);
		bottom.Rotation = rotation;
		bottom.Scale = scale;
		local top = this.addSprite("top");
		top.setBrush("tree_0" + v + "_top");
		top.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		top.varyColor(0.125, 0.125, 0.125);
		top.Rotation = rotation + this.Math.rand(-5, 5);
		top.Scale = scale * (0.8 + this.Math.rand(0, 20) / 100.0);
		this.setSpriteOcclusion("top", 2, 2, -3);
		this.setBlockSight(true);
	}

});


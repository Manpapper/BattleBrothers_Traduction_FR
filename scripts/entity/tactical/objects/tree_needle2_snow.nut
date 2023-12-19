this.tree_needle2_snow <- this.inherit("scripts/entity/tactical/entity", {
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
		local baseScale = 0.6 + this.Math.rand(0, 40) / 100.0;
		local rotation = this.Math.rand(-6, 6);
		local bottom = this.addSprite("bottom");
		bottom.setBrush("tree_needle_03_snow_bottom");
		bottom.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		bottom.Scale = baseScale;
		bottom.Rotation = rotation;
		local top = this.addSprite("top");
		top.setBrush("tree_needle_03_snow_top");
		top.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		top.Scale = baseScale * 0.9 + this.Math.rand(0, 10) / 100.0;
		top.Rotation = this.Math.rand(-3, 3) + rotation;
		this.setSpriteOcclusion("top", 3, 2, -3);
		this.setBlockSight(true);
	}

});


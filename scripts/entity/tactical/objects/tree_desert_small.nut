this.tree_desert_small <- this.inherit("scripts/entity/tactical/entity", {
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
		local baseScale = 0.75 + this.Math.rand(0, 25) / 100.0;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("tree_small_desert_01_bottom");
		bottom.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		bottom.varyColor(0.04, 0.04, 0.04);
		bottom.Scale = baseScale;
		local top = this.addSprite("top");
		top.setBrush("tree_small_desert_01_top");
		top.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		top.varyColor(0.15, 0.15, 0.15);
		top.varySaturation(0.1);
		top.Scale = baseScale * 0.9 + this.Math.rand(0, 10) / 100.0;
		top.Rotation = this.Math.rand(-3, 3);
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.setBlockSight(true);
	}

});


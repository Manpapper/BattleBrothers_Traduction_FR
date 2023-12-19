this.tree_needle2 <- this.inherit("scripts/entity/tactical/entity", {
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
		bottom.setBrush("tree_needle_03_bottom");
		bottom.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		bottom.varyColor(0.04, 0.04, 0.04);
		bottom.Scale = baseScale;
		bottom.Rotation = rotation;
		local top = this.addSprite("top");
		top.setBrush("tree_needle_03_top");
		top.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		top.varyColor(0.15, 0.15, 0.15);
		top.varySaturation(0.1);
		top.Scale = baseScale * 0.9 + this.Math.rand(0, 10) / 100.0;
		top.Rotation = this.Math.rand(-3, 3) + rotation;
		local web = this.addSprite("web");
		web.setBrush("web_01");
		web.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		web.Scale = bottom.Scale * 0.75;
		web.Visible = false;
		this.setSpriteOcclusion("top", 3, 2, -3);
		this.setBlockSight(true);
	}

});


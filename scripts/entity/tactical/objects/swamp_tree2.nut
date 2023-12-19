this.swamp_tree2 <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return this.Const.Strings.Tactical.EntityName.Tree;
	}

	function getDescription()
	{
		return this.Const.Strings.Tactical.EntityDescription.TreeSwamp;
	}

	function onInit()
	{
		local variants = [
			"11",
			"12",
			"01",
			"03"
		];
		local v = variants[this.Math.rand(0, variants.len() - 1)];
		local flip = this.Math.rand(0, 1) == 1;
		local baseScale = 0.8 + this.Math.rand(0, 20) / 100.0;
		local rotation = this.Math.rand(-5, 5);
		local bottom = this.addSprite("bottom");
		bottom.setBrush("swamp_tree_" + v + "_bottom");
		bottom.setHorizontalFlipping(flip);
		bottom.varyColor(0.07, 0.07, 0.07);
		bottom.Scale = baseScale;
		bottom.Rotation = rotation;
		local top = this.addSprite("top");
		top.setBrush("swamp_tree_" + v + "_top");
		top.setHorizontalFlipping(flip);
		top.Color = bottom.Color;
		top.Scale = baseScale;
		top.Rotation = bottom.Rotation;
		local web = this.addSprite("web");
		web.setBrush("web_03");
		web.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		web.Scale = bottom.Scale * 0.9;
		web.Visible = false;

		if (v == "11" || v == "12")
		{
			this.setSpriteOcclusion("top", 2, 2, -3);
		}
		else
		{
			this.setSpriteOcclusion("top", 1, 1, -3);
		}

		this.setBlockSight(true);
	}

});


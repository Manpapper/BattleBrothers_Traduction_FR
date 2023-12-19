this.tree_desert_large <- this.inherit("scripts/entity/tactical/entity", {
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
		local rotation = this.Math.rand(-5, 5);
		local flipBottom = this.Math.rand(0, 100) < 50;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("tree_desert_01_bottom");
		bottom.setHorizontalFlipping(flipBottom);
		bottom.varyColor(0.03, 0.03, 0.03);
		bottom.Rotation = rotation;
		local middle = this.addSprite("middle");
		middle.setBrush("tree_desert_01_middle");
		middle.setHorizontalFlipping(flipBottom);
		middle.Color = bottom.Color;
		middle.Rotation = rotation;
		local top = this.addSprite("top");
		top.setBrush("tree_desert_01_top");
		top.setHorizontalFlipping(flipBottom);
		top.varyColor(0.125, 0.125, 0.125);
		top.Rotation = rotation + this.Math.rand(-5, 5);
		top.Scale = 0.8 + this.Math.rand(0, 20) / 100.0;
		local web = this.addSprite("web");
		web.setBrush("web_01");
		web.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		web.Scale = bottom.Scale * 0.75;
		web.Visible = false;
		this.setSpriteOcclusion("middle", 2, 3, -3);
		this.setSpriteOcclusion("top", 2, 3, -3);
		this.setBlockSight(true);
	}

});


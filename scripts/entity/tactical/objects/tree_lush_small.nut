this.tree_lush_small <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return this.Const.Strings.Tactical.EntityName.Tree;
	}

	function getDescription()
	{
		return "Un petit arbre.";
	}

	function onInit()
	{
		local v = 4;
		local flip = this.Math.rand(0, 1) == 1;
		local scale = 0.93 + this.Math.rand(0, 7) / 100.0;
		local rotation = this.Math.rand(-5, 5);
		local hasLeaves = this.Math.rand(1, 100) <= 90;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("tree_0" + v + "_bottom");
		bottom.setHorizontalFlipping(flip);
		bottom.varyColor(0.03, 0.03, 0.03);
		bottom.Rotation = rotation;
		bottom.Scale = scale;
		local middle = this.addSprite("middle");
		middle.setBrush("tree_0" + v + "_middle");
		middle.setHorizontalFlipping(flip);
		middle.varyColor(0.03, 0.03, 0.03);
		middle.Rotation = rotation;
		middle.Scale = scale;

		if (hasLeaves)
		{
			local top = this.addSprite("top");
			top.setBrush("tree_0" + v + "_top");
			top.setHorizontalFlipping(flip);
			top.varyColor(0.125, 0.125, 0.125);
			top.Rotation = rotation;
			top.Scale = scale;
			this.setSpriteOcclusion("top", 1, 2, -3);
		}

		this.setSpriteOcclusion("middle", 1, 2, -3);
		this.setBlockSight(true);
	}

});


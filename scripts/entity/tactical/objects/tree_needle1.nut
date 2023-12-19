this.tree_needle1 <- this.inherit("scripts/entity/tactical/entity", {
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
		local hasNeedles = this.Math.rand(1, 100) <= 90;
		local scale = 1.0;
		local flip = this.Math.rand(0, 1) == 1;
		local v = this.Math.rand(1, 2);
		local rotation = this.Math.rand(-3, 3);
		local bottom = this.addSprite("bottom");
		bottom.setBrush("tree_needle_0" + v + "_bottom");
		bottom.setHorizontalFlipping(flip);
		bottom.Rotation = rotation;
		bottom.Scale = scale;
		local middle = this.addSprite("middle");
		middle.setBrush("tree_needle_0" + v + "_middle");
		middle.setHorizontalFlipping(flip);
		middle.Rotation = rotation;
		middle.Scale = scale;

		if (hasNeedles)
		{
			local top = this.addSprite("top");
			top.setBrush("tree_needle_0" + v + "_top");
			top.setHorizontalFlipping(flip);
			top.Rotation = rotation;
			top.Scale = scale;
			top.varyColor(0.15, 0.15, 0.15);
			top.varySaturation(0.1);
			this.setSpriteOcclusion("top", 1, 2, -3);
		}

		this.setSpriteOcclusion("middle", 1, 2, -3);
		this.setBlockSight(true);
	}

});


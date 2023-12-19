this.tree_forest <- this.inherit("scripts/entity/tactical/entity", {
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
		bottom.setBrush("tree_05_bottom");
		bottom.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		bottom.varyColor(0.04, 0.04, 0.04);
		bottom.Scale = baseScale;
		local top = this.addSprite("top");
		top.setBrush("tree_05_top");
		top.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		top.varyColor(0.15, 0.15, 0.15);
		top.varySaturation(0.1);
		top.Scale = baseScale * 0.9 + this.Math.rand(0, 10) / 100.0;
		top.Rotation = this.Math.rand(-3, 3);
		this.setSpriteOcclusion("bottom", 1, -1, -2);
		this.setSpriteOcclusion("top", 3, 2, -3);
		this.setBlockSight(true);
	}

	function onFinish()
	{
	}

	function onSerialize( _out )
	{
		this.entity.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.entity.onDeserialize(_in);
	}

});


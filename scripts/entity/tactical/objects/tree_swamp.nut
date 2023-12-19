this.tree_swamp <- this.inherit("scripts/entity/tactical/entity", {
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
		local body = this.addSprite("body");
		body.setBrush("swamp_tree_01");
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.varyColor(0.07, 0.07, 0.07);
		body.Rotation = this.Math.rand(-10, 10);

		if (this.Math.rand(0, 100) < 50)
		{
			body.Scale = 0.9 + this.Math.rand(0, 10) / 100.0;
		}
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


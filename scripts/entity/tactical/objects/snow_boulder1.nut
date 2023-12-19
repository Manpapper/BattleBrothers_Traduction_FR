this.snow_boulder1 <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return this.Const.Strings.Tactical.EntityName.Boulder;
	}

	function getDescription()
	{
		return this.Const.Strings.Tactical.EntityDescription.Boulder;
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("snow_boulder_0" + this.Math.rand(1, 3));
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.Scale = 0.8 + this.Math.rand(0, 20) / 100.0;
		this.setBlockSight(true);
	}

});


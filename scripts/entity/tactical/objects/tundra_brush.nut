this.tundra_brush <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Bush";
	}

	function getDescription()
	{
		return "Dense shrubbery that blocks movement and line of sight.";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("tundra_brush_0" + this.Math.rand(1, 3));
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.varyColor(0.07, 0.07, 0.07);
		body.Scale = 0.9 + this.Math.rand(0, 10) / 100.0;
		body.Rotation = this.Math.rand(-5, 5);
		this.setBlockSight(true);
	}

});


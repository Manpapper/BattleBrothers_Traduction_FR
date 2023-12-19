this.swamp_tree1 <- this.inherit("scripts/entity/tactical/entity", {
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
			"02",
			"04",
			"05",
			"06",
			"07",
			"08",
			"09",
			"10"
		];
		local v = variants[this.Math.rand(0, variants.len() - 1)];
		local body = this.addSprite("body");
		body.setBrush("swamp_tree_" + v);
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.varyColor(0.07, 0.07, 0.07);
		body.Rotation = this.Math.rand(-10, 10);

		if (this.Math.rand(0, 100) < 50)
		{
			body.Scale = 0.8 + this.Math.rand(0, 20) / 100.0;
		}

		local web = this.addSprite("web");
		web.setBrush("web_03");
		web.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		web.Scale = body.Scale * 0.8;
		web.Visible = false;
	}

});


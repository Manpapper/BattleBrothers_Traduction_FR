this.southern_ruins_big <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Ruines";
	}

	function getDescription()
	{
		return "Ruines de pierres effritées.";
	}

	function onInit()
	{
		local variants = [
			"04",
			"05",
			"06",
			"07",
			"10",
			"11",
			"12",
			"31"
		];
		local v = variants[this.Math.rand(0, variants.len() - 1)];
		local flip = this.Math.rand(0, 1) == 1;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("southern_ruins_" + v + "_bottom");
		bottom.setHorizontalFlipping(flip);
		local top = this.addSprite("top");
		top.setBrush("southern_ruins_" + v + "_top");
		top.setHorizontalFlipping(flip);
		this.setBlockSight(true);
		this.setSpriteOcclusion("top", 2, 2, -3);
	}

});


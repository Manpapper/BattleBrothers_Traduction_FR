this.southern_ruins_statue <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Statue de Bronze";
	}

	function getDescription()
	{
		return "Une statue de bronze d'une époque révolue.";
	}

	function onInit()
	{
		local variants = [
			"13"
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


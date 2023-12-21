this.barbarian_camp_altar <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Autel";
	}

	function getDescription()
	{
		return "Un autel sacrificiel en pierre.";
	}

	function onInit()
	{
		local variants = [
			"06"
		];
		local v = variants[this.Math.rand(0, variants.len() - 1)];
		local flip = this.Math.rand(0, 1) == 1;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("barbarians_" + v + "_bottom");
		bottom.setHorizontalFlipping(flip);
		local top = this.addSprite("top");
		top.setBrush("barbarians_" + v + "_top");
		top.setHorizontalFlipping(flip);
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.setBlockSight(false);
	}

});


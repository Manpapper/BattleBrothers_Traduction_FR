this.goblin_camp_standard <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Etendard Gobelin";
	}

	function getDescription()
	{
		return "Un étendard qui ne laisse aucun doute sur l'identité des habitants de ce camp.";
	}

	function onInit()
	{
		local variants = [
			"07"
		];
		local v = variants[this.Math.rand(0, variants.len() - 1)];
		local flip = this.Math.rand(0, 1) == 1;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("goblins_" + v + "_bottom");
		bottom.setHorizontalFlipping(flip);
		local top = this.addSprite("top");
		top.setBrush("goblins_" + v + "_top");
		top.setHorizontalFlipping(flip);
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.setBlockSight(false);
	}

});


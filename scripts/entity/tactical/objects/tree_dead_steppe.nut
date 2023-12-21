this.tree_dead_steppe <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Arbre Mort";
	}

	function getDescription()
	{
		return "Cet arbre s'est desséché et est mort depuis longtemps. Il bloque les mouvements et la visibilité.";
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("steppe_dead_tree_0" + this.Math.rand(1, 2));
		body.setHorizontalFlipping(this.Math.rand(0, 100) < 50);
		body.varyColor(0.03, 0.03, 0.03);
		body.Scale = 0.7 + this.Math.rand(0, 30) / 100.0;
		this.setSpriteOcclusion("body", 1, -1, -2);
		this.setBlockSight(true);
	}

});


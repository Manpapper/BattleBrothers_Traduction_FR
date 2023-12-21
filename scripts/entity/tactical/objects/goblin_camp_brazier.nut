this.goblin_camp_brazier <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Brasier";
	}

	function getDescription()
	{
		return "Un brasier rempli de bois brûlé.";
	}

	function onInit()
	{
		local variants = [
			"04"
		];
		local body = this.addSprite("body");
		body.setBrush("goblins_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


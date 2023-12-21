this.human_camp_wood <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Bois Coupé";
	}

	function getDescription()
	{
		return "Bois coupé comme bois de chauffage ou pour la construction de palissades.";
	}

	function onInit()
	{
		local variants = [
			"11",
			"15"
		];
		local body = this.addSprite("body");
		body.setBrush("camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


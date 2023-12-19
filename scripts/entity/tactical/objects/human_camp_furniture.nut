this.human_camp_furniture <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Meuble";
	}

	function getDescription()
	{
		return "Meuble en bois pour les occupants de ce camp.";
	}

	function onInit()
	{
		local variants = [
			"14"
		];
		local body = this.addSprite("body");
		body.setBrush("camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


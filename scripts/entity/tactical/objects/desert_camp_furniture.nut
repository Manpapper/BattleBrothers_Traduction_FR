this.desert_camp_furniture <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Meuble";
	}

	function getDescription()
	{
		return "Des meubles en bois pour les occupants de ce camp.";
	}

	function onInit()
	{
		local variants = [
			"04",
			"06"
		];
		local body = this.addSprite("body");
		body.setBrush("desert_camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


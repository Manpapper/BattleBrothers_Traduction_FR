this.orc_camp_supplies <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Provisions";
	}

	function getDescription()
	{
		return "Des provisions pour nourrir les habitants de ce camp.";
	}

	function onInit()
	{
		local variants = [
			"01",
			"04",
			"05"
		];
		local body = this.addSprite("body");
		body.setBrush("orcs_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


this.human_camp_supplies <- this.inherit("scripts/entity/tactical/entity", {
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
			"03",
			"04",
			"05",
			"06",
			"12",
			"16"
		];
		local body = this.addSprite("body");
		body.setBrush("camp_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


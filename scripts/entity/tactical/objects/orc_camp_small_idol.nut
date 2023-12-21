this.orc_camp_small_idol <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Idol";
	}

	function getDescription()
	{
		return "An idol erected by greenskins.";
	}

	function onInit()
	{
		local variants = [
			"08"
		];
		local body = this.addSprite("body");
		body.setBrush("orcs_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


this.orc_camp_Fireplace <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Foyer";
	}

	function getDescription()
	{
		return "Une cheminée. Vous ne voulez pas savoir ce qu'ils cuisinent ici.";
	}

	function onInit()
	{
		local variants = [
			"06",
			"09"
		];
		local body = this.addSprite("body");
		body.setBrush("orcs_" + variants[this.Math.rand(0, variants.len() - 1)]);
	}

});


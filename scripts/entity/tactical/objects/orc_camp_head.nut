this.orc_camp_head <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Tête empalée";
	}

	function getDescription()
	{
		return "Une démonstration macabre de ce qui arrive aux humains par ici.";
	}

	function setFlipped( _flip )
	{
		this.getSprite("body").setHorizontalFlipping(_flip);
	}

	function setVariant( _variant )
	{
		local variants = [
			"15",
			"16"
		];
		this.getSprite("body").setBrush("orcs_" + variants[_variant]);
	}

	function onInit()
	{
		this.addSprite("body");
	}

});


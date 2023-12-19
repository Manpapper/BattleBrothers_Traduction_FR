this.destroyed_greenskin_catapult <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Machine de siège détruite";
	}

	function getDescription()
	{
		return "Cette machine de siège des peaux vertes a été rendue inutilisable.";
	}

	function onInit()
	{
		local flip = false;
		local bottom = this.addSprite("bottom");
		bottom.setBrush("greenskin_catapult_destroyed_bottom");
		local top = this.addSprite("top");
		top.setBrush("greenskin_catapult_destroyed_top");
		this.setSpriteOcclusion("top", 1, 2, -3);
		this.setBlockSight(false);
	}

	function isDying()
	{
		return true;
	}

});


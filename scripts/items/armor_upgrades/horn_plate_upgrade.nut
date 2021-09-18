this.horn_plate_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.horn_plate";
		this.m.Name = "Horn Plate";
		this.m.Description = "These segments of horn plate are made from one of the hardest yet flexible materials nature has to offer. Worn over common armor, they can help to deflect incoming blows.";
		this.m.ArmorDescription = "Segments of horn plate provide additional protection.";
		this.m.Icon = "armor_upgrades/upgrade_22.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_22.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_22.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_22_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_22_back";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_22_back_dead";
		this.m.ConditionModifier = 30;
		this.m.Value = 1200;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+30[/color] Durability"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces any melee damage to the body by [color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces any melee damage to the body by [color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color]"
		});
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.BodyPart == this.Const.BodyPart.Body)
		{
			_properties.DamageReceivedMeleeMult *= 0.9;
		}
	}

});


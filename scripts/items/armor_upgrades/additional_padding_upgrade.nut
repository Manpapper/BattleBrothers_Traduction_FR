this.additional_padding_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.additional_padding";
		this.m.Name = "Additional Fur Padding";
		this.m.Description = "Crafted from thick furs, this additional padding helps dampen the impact of any blow.";
		this.m.ArmorDescription = "Additional fur padding helps to further dampen the impact of any blow.";
		this.m.Icon = "armor_upgrades/upgrade_03.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_03.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_03.png";
		this.m.SpriteFront = "upgrade_03_front";
		this.m.SpriteBack = "upgrade_03_back";
		this.m.SpriteDamagedFront = "upgrade_03_front_damaged";
		this.m.SpriteDamagedBack = "upgrade_03_back";
		this.m.SpriteCorpseFront = "upgrade_03_front_dead";
		this.m.SpriteCorpseBack = "upgrade_03_back_dead";
		this.m.StaminaModifier = 2;
		this.m.Value = 700;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/direct_damage.png",
			text = "Reduces damage ignoring armor by [color=" + this.Const.UI.Color.NegativeValue + "]33%[/color]"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] Maximum Fatigue"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/direct_damage.png",
			text = "Only take [color=" + this.Const.UI.Color.NegativeValue + "]66%[/color] of any damage that ignores armor"
		});
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.BodyPart == this.Const.BodyPart.Body && _attacker != null && _attacker.getID() != this.getArmor().getContainer().getActor().getID())
		{
			_properties.DamageReceivedDirectMult *= 0.66;
		}
	}

});


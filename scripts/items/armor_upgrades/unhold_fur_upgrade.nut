this.unhold_fur_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.unhold_fur";
		this.m.Name = "Cape en Fourrure d'Unhold";
		this.m.Description = "Une épaisse cape confectionnée à partir de la majestueuse fourrure blanche d'un Unhold de givre. Peut être portée par-dessus n'importe quelle armure pour rendre le porteur plus résistant aux armes à distance.";
		this.m.ArmorDescription = "Une cape en épaisse fourrure blanche a été attachée à cette armure pour la rendre plus résistante aux armes à distance.";
		this.m.Icon = "armor_upgrades/upgrade_02.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_02.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_02.png";
		this.m.SpriteFront = "upgrade_02_front";
		this.m.SpriteBack = "upgrade_02_back";
		this.m.SpriteDamagedFront = "upgrade_02_front_damaged";
		this.m.SpriteDamagedBack = "upgrade_02_back";
		this.m.SpriteCorpseFront = "upgrade_02_front_dead";
		this.m.SpriteCorpseBack = "upgrade_02_back_dead";
		this.m.ConditionModifier = 10;
		this.m.StaminaModifier = 0;
		this.m.Value = 1000;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Durabilité"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Réduit les dégâts de toute attaque à distance sur le corps de [color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Réduit les dégâts de toute attaque à distance sur le corps de [color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color]"
		});
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.BodyPart == this.Const.BodyPart.Body)
		{
			_properties.DamageReceivedRangedMult *= 0.8;
		}
	}

});


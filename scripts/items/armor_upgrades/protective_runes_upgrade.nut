this.protective_runes_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.protective_runes";
		this.m.Name = "Runes et Sceaux Protecteurs";
		this.m.Description = "Runes et sceaux protecteurs inscrits sur une peau parcheminée et émettant une aura inquiétante.";
		this.m.ArmorDescription = "Des runes et des sceaux protecteurs inscrits sur une peau parcheminée sont fixés à cette armure.";
		this.m.Icon = "armor_upgrades/upgrade_07.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_07.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_07.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_07_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_07_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_07_back_dead";
		this.m.Value = 1100;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Résistance aux checks de moral contre la peur, la panique ou les effets de contrôle mental"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Résistance aux checks de moral contre la peur, la panique ou les effets de contrôle mental"
		});
	}

	function onUpdateProperties( _properties )
	{
		_properties.MoraleCheckBravery[1] += 20;
	}

});


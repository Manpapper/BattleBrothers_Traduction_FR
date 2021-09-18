this.light_gladiator_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.light_gladiator_upgrade";
		this.m.Name = "Padded Armor Pieces";
		this.m.Description = "Padded armpieces that provides additional protection.";
		this.m.ArmorDescription = "This harness has padded armpieces attached that provide additional protection.";
		this.m.Icon = "armor_upgrades/upgrade_24.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_24.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_24.png";
		this.m.SpriteFront = "upgrade_24_front";
		this.m.SpriteBack = null;
		this.m.SpriteDamagedFront = "upgrade_24_front_damaged";
		this.m.SpriteDamagedBack = null;
		this.m.SpriteCorpseFront = "upgrade_24_front_dead";
		this.m.SpriteCorpseBack = null;
		this.m.Value = 200;
		this.m.ConditionModifier = 60;
		this.m.StaminaModifier = 4;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+60[/color] Durability"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-4[/color] Maximum Fatigue"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
	}

});


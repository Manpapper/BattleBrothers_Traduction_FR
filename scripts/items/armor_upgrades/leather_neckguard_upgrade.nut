this.leather_neckguard_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.leather_neckguard";
		this.m.Name = "Leather Neckguard";
		this.m.Description = "This neckguard of cured leather can be attached to any armor for some additional protection.";
		this.m.ArmorDescription = "A neckguard of cured leather has been attached to this armor for additional protection.";
		this.m.Icon = "armor_upgrades/upgrade_13.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_13.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_13.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_13_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_13_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_13_back_dead";
		this.m.Value = 100;
		this.m.ConditionModifier = 10;
		this.m.StaminaModifier = 0;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Durability"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
	}

});


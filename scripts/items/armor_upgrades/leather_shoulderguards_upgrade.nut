this.leather_shoulderguards_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.leather_shoulderguards";
		this.m.Name = "Leather Shoulderguards";
		this.m.Description = "Studded leather shoulderguards can help in making even light armors a little bit more resilient.";
		this.m.ArmorDescription = "Shoulderguards made of studded leather have been added to this armor for additional protection.";
		this.m.Icon = "armor_upgrades/upgrade_08.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_08.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_08.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_08_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_08_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_08_back_dead";
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


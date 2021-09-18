this.mail_patch_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.mail_patch";
		this.m.Name = "Mail Patch";
		this.m.Description = "A large patch of mail that can be added to any armor to further protect the most vulnerable areas.";
		this.m.ArmorDescription = "A large patch of mail has been added to this armor to further protect the most vulnerable areas.";
		this.m.Icon = "armor_upgrades/upgrade_09.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_09.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_09.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_09_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_09_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_09_back_dead";
		this.m.Value = 200;
		this.m.ConditionModifier = 20;
		this.m.StaminaModifier = 2;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Durability"
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
	}

});


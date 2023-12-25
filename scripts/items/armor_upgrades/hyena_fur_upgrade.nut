this.hyena_fur_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.hyena_fur";
		this.m.Name = "Manteau en Fourrure de Hyène";
		this.m.Description = "Fourrures prélevées sur des hyènes féroces, traitées et cousues ensemble pour être portées comme un trophée de chasseur de bêtes autour du cou. Revêtir la peau d'une bête comme celle-ci renforce la volonté d'agir.";
		this.m.ArmorDescription = "Un manteau de fourrure de hyène a été attaché à cette armure, renforçant la volonté d'agir du porteur.";
		this.m.Icon = "armor_upgrades/upgrade_26.png";
		this.m.Icon = "armor_upgrades/upgrade_26.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_26.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_26.png";
		this.m.SpriteFront = "upgrade_26_front";
		this.m.SpriteBack = "upgrade_26_back";
		this.m.SpriteDamagedFront = "upgrade_26_front_damaged";
		this.m.SpriteDamagedBack = "upgrade_26_back";
		this.m.SpriteCorpseFront = "upgrade_26_front_dead";
		this.m.SpriteCorpseBack = "upgrade_26_back_dead";
		this.m.Value = 600;
		this.m.ConditionModifier = 15;
		this.m.StaminaModifier = 0;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Durabilité"
		});
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Initiative"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Initiative"
		});
	}

	function onUpdateProperties( _properties )
	{
		_properties.Initiative += 15;
	}

});


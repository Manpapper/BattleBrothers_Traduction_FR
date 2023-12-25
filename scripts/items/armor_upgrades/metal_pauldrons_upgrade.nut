this.metal_pauldrons_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.metal_pauldrons";
	this.m.Name = "Spalières en Métal";
		this.m.Description = "Des spalières en métal robuste qui peuvent être ajoutées à n'importe quelle armure pour une protection accrue des épaules et du haut du corps. Bien sûr, cela rendra également l'armure un peu plus lourde.";
		this.m.ArmorDescription = "Des spalières en métal robuste ont été ajoutées à cette armure pour une protection accrue des épaules et du haut du corps, mais au prix d'un poids supplémentaire.";
		this.m.Icon = "armor_upgrades/upgrade_11.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_11.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_11.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_11_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_11_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_11_back_dead";
		this.m.Value = 500;
		this.m.ConditionModifier = 40;
		this.m.StaminaModifier = 4;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/armor_body.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+40[/color] Durabilité"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-4[/color] Fatigue Maximum"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
	}

});


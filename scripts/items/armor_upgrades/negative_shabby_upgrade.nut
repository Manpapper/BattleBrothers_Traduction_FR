this.negative_shabby_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.negative_shabby";
		this.m.Name = "Délabré";
		this.m.Description = "";
		this.m.ArmorDescription = "On dirait que le propriétaire précédent n'en a pas du tout pris soin ; des pièces sont manquantes ou ont été remplacées par des réparations improvisées.";
		this.m.Icon = null;
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_downgrade_02.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_downgrade_02.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "downgrade_02_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "downgrade_02_back";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "downgrade_02_back_dead";
		this.m.Value = -100;
	}

	function onArmorTooltip( _result )
	{
		_result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "Aucun emplacement d'accessoire d'armure"
		});
	}

	function onAdded()
	{
		this.m.Armor.m.Condition += -10;
		this.m.Armor.m.ConditionMax += -10;
	}

});


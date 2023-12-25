this.negative_falling_apart_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.negative_falling_apart";
		this.m.Name = "En Train de Tomber en Morceaux";
		this.m.Description = "";
		this.m.ArmorDescription = "Cette armure est sur le point de tomber en morceaux. La négligence et une utilisation prolongée l'ont laissée dans un état triste bien au-delà de toute réparation possible.";
		this.m.Icon = null;
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_downgrade_01.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_downgrade_01.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "downgrade_01_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "downgrade_01_back";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "downgrade_01_back_dead";
		this.m.Value = -200;
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
		this.m.Armor.m.Condition += -20;
		this.m.Armor.m.ConditionMax += -20;
	}

});


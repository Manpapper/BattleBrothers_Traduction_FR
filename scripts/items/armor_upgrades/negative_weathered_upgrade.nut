this.negative_weathered_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.negative_weathered";
		this.m.Name = "Vieilli";
		this.m.Description = "";
		this.m.ArmorDescription = "Cette armure est légèrement vieillie par la poussière et la pluie, ce qui a rendu le métal terne et le cuir cassant.";
		this.m.Icon = null;
		this.m.Icon = null;
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_downgrade_04.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_downgrade_04.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "downgrade_04_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "downgrade_04_back";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "downgrade_04_back_dead";
		this.m.Value = -150;
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
		this.m.Armor.m.Condition += -15;
		this.m.Armor.m.ConditionMax += -15;
	}

});


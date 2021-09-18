this.light_padding_replacement_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {
		PreviousValue = 0
	},
	function create()
	{
		this.armor_upgrade.create();
		this.m.ID = "armor_upgrade.light_padding_replacement";
		this.m.Name = "Light Padding Replacement";
		this.m.Description = "Crafted from exotic materials, this replacement padding can provide the same amount of protection as regular padding at less weight.";
		this.m.ArmorDescription = "This armor has its padding replaced by a lighter but no less durable one.";
		this.m.Icon = "armor_upgrades/upgrade_05.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = "armor_upgrades/icon_upgrade_05.png";
		this.m.OverlayIconLarge = "armor_upgrades/inventory_upgrade_05.png";
		this.m.SpriteFront = null;
		this.m.SpriteBack = "upgrade_05_back";
		this.m.SpriteDamagedFront = null;
		this.m.SpriteDamagedBack = "upgrade_05_back_damaged";
		this.m.SpriteCorpseFront = null;
		this.m.SpriteCorpseBack = "upgrade_05_back_dead";
		this.m.Value = 650;
	}

	function getTooltip()
	{
		local result = this.armor_upgrade.getTooltip();
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "Reduces an armor\'s penalty to Maximum Fatigue by [color=" + this.Const.UI.Color.NegativeValue + "]20%[/color]"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
	}

	function onAdded()
	{
		this.m.StaminaModifier = this.Math.floor(this.m.Armor.m.StaminaModifier * 0.2);
		this.armor_upgrade.onAdded();
	}

	function onRemoved()
	{
		this.m.StaminaModifier = 0;
		this.armor_upgrade.onRemoved();
	}

});


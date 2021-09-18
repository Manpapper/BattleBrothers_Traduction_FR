this.armor_of_davkul <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.armor_of_davkul";
		this.m.Name = "Aspect of Davkul";
		this.m.Description = "A grisly aspect of Davkul, an ancient power not from this world, and the last remnants of %sacrifice% from whose body it has been fashioned. It shall never break, but instead keep regrowing its scarred skin on the spot.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IsIndestructible = true;
		this.m.Variant = 81;
		this.updateVariant();
		this.m.ImpactSound = [
			"sounds/combat/cleave_hit_hitpoints_01.wav",
			"sounds/combat/cleave_hit_hitpoints_02.wav",
			"sounds/combat/cleave_hit_hitpoints_03.wav"
		];
		this.m.InventorySound = this.m.ImpactSound;
		this.m.Value = 20000;
		this.m.Condition = 270;
		this.m.ConditionMax = 270;
		this.m.StaminaModifier = -18;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Regenerates itself by [color=" + this.Const.UI.Color.PositiveValue + "]90[/color] points of durability each turn."
		});
		return result;
	}

	function onTurnStart()
	{
		this.m.Condition = this.Math.minf(this.m.ConditionMax, this.m.Condition + 90.0);
		this.updateAppearance();
	}

	function onCombatFinished()
	{
		this.m.Condition = this.m.ConditionMax;
		this.updateAppearance();
	}

	function onSerialize( _out )
	{
		this.armor.onSerialize(_out);
		_out.writeString(this.m.Description);
	}

	function onDeserialize( _in )
	{
		this.armor.onDeserialize(_in);
		this.m.Description = _in.readString();
	}

});


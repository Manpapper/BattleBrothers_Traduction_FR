this.unhold_armor_heavy <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.unhold_armor_heavy";
		this.m.Name = "Armor";
		this.m.Description = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorUnholdImpact;
		this.m.InventorySound = this.Const.Sound.ArmorUnholdImpact;
		this.m.Value = 0;
		this.m.Condition = 400;
		this.m.ConditionMax = 400;
		this.m.StaminaModifier = -10;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_armored_unhold_body_" + variant;
		this.m.SpriteDamaged = "bust_armored_unhold_body_" + variant;
		this.m.SpriteCorpse = "bust_armored_unhold_body_" + variant + "_dead";
	}

});


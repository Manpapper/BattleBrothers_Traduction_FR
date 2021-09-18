this.unhold_helmet_heavy <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.unhold_helmet_heavy";
		this.m.Name = "Armor";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.HideCharacterHead = false;
		this.m.HideHelmetIfDestroyed = false;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorUnholdImpact;
		this.m.InventorySound = this.Const.Sound.ArmorUnholdImpact;
		this.m.Value = 0;
		this.m.Condition = 400;
		this.m.ConditionMax = 400;
		this.m.StaminaModifier = -10;
		this.m.Vision = 0;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_armored_unhold_head_" + variant;
		this.m.SpriteDamaged = "bust_armored_unhold_head_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_armored_unhold_head_" + variant + "_dead";
	}

});


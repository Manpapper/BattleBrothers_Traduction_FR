this.orc_warrior_heavy_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		local variants = [
			3,
			4,
			5
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.body.orc_warrior_heavy_armor";
		this.m.Name = "Looted Plate Armor";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 400;
		this.m.ConditionMax = 400;
		this.m.StaminaModifier = -30;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_03_armor_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_orc_03_armor_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_orc_03_armor_0" + this.m.Variant + "_dead";
	}

});


this.goblin_skirmisher_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "armor.body.goblin_skirmisher_armor";
		this.m.Name = "Skirmisher Armor";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 35;
		this.m.ConditionMax = 35;
		this.m.StaminaModifier = -2;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_04_armor_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_04_armor_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_04_armor_0" + this.m.Variant + "_dead";
	}

});


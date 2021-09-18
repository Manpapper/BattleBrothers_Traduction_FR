this.goblin_heavy_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		local variants = [
			2,
			4
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.body.goblin_heavy_armor";
		this.m.Name = "Heavy Armor";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Condition = 90;
		this.m.ConditionMax = 90;
		this.m.StaminaModifier = -8;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_01_armor_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_01_armor_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_01_armor_0" + this.m.Variant + "_dead";
	}

});


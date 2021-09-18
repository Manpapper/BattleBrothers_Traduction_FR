this.greatsword_faction_helm <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.greatsword_faction_helm";
		this.m.Name = "Zweihander\'s Helmet";
		this.m.Description = "A sturdy metal helmet with added padding, covered with a large feathered hat.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 850;
		this.m.Condition = 160;
		this.m.ConditionMax = 160;
		this.m.StaminaModifier = -7;
		this.m.Vision = -1;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "faction_helmet_2_" + variant;
		this.m.SpriteDamaged = "faction_helmet_2_" + variant + "_damaged";
		this.m.SpriteCorpse = "faction_helmet_2_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_faction_helmet_2_" + variant + ".png";
	}

});


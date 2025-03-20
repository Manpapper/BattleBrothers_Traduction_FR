this.greater_flesh_golem_helmet_03 <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.greater_flesh_golem_helmet_03";
		this.m.Name = "Face of Perfection";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.ReplaceSprite = true;
		this.m.Variant = 3;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorUnholdImpact;
		this.m.InventorySound = this.Const.Sound.ArmorUnholdImpact;
		this.m.Value = 0;
		this.m.Condition = 170;
		this.m.ConditionMax = 170;
		this.m.StaminaModifier = 0;
		this.m.Vision = 0;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_greater_flesh_golem_helmet_" + variant;
		this.m.SpriteDamaged = "bust_greater_flesh_golem_helmet_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_greater_flesh_golem_helmet_" + variant + "_dead";
	}

});


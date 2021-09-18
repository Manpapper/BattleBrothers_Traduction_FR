this.dented_nasal_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.dented_nasal_helmet";
		this.m.Name = "Padded Dented Nasal Helmet";
		this.m.Description = "A dented metal nasal helmet that has seen some fighting.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		this.m.Variant = 0;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 350;
		this.m.Condition = 110;
		this.m.ConditionMax = 110;
		this.m.StaminaModifier = -7;
		this.m.Vision = -1;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_helmet_30";
		this.m.SpriteDamaged = "bust_helmet_30_damaged";
		this.m.SpriteCorpse = "bust_helmet_30_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_helmet_30.png";
	}

});


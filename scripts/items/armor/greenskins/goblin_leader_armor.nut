this.goblin_leader_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.goblin_leader_armor";
		this.m.Name = "";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Condition = 180;
		this.m.ConditionMax = 180;
		this.m.StaminaModifier = -15;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_03_armor_01";
		this.m.SpriteDamaged = "bust_goblin_03_armor_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_03_armor_01_dead";
	}

});


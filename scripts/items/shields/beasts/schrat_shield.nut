this.schrat_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.schrat";
		this.m.Name = "Schrat\'s Shield";
		this.m.Description = "";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.Value = 0;
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = 0;
		this.m.Condition = 32;
		this.m.ConditionMax = 32;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_schrat_shield_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_schrat_shield_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
	}

});


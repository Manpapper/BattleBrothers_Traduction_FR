this.wooden_shield_old <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.wooden_shield_old";
		this.m.Name = "Old Wooden Shield";
		this.m.Description = "An old round wooden shield.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.updateVariant();
		this.m.Value = 60;
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -10;
		this.m.Condition = 16;
		this.m.ConditionMax = 16;
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_round_enemy_01";
		this.m.SpriteDamaged = "shield_round_enemy_01_damaged";
		this.m.ShieldDecal = "shield_round_enemy_01_destroyed";
		this.m.IconLarge = "shields/inventory_shield_round_enemy_01.png";
		this.m.Icon = "shields/icon_shield_round_enemy_01.png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});


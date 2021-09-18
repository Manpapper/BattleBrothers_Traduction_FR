this.goblin_light_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.goblin_light_shield";
		this.m.Name = "Wooden Skirmisher Shield";
		this.m.Description = "A wooden shield made by goblins. Light but also small, offering little protection against attacks for a human using it.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.Value = 45;
		this.m.MeleeDefense = 10;
		this.m.RangedDefense = 10;
		this.m.StaminaModifier = -4;
		this.m.Condition = 12;
		this.m.ConditionMax = 12;
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_goblin_01_0" + this.m.Variant;
		this.m.SpriteDamaged = "shield_goblin_01_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "shield_goblin_01_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/inventory_goblin_shield_01_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_goblin_shield_01_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
	}

});


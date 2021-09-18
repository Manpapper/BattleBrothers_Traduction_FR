this.faction_wooden_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.faction_wooden_shield";
		this.m.Name = "Wooden Shield";
		this.m.Description = "A round wooden shield.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.Value = 90;
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -10;
		this.m.Condition = 24;
		this.m.ConditionMax = 24;
	}

	function setFaction( _f )
	{
		this.m.Variant = _f;
		this.updateVariant();
	}

	function updateVariant()
	{
		local variant = this.m.Variant < 10 ? "0" + this.m.Variant : this.m.Variant;
		this.m.Sprite = "faction_shield_round_" + variant + "_01";
		this.m.SpriteDamaged = "faction_shield_round_" + variant + "_01_damaged";
		this.m.ShieldDecal = "faction_shield_round_" + variant + "_01_destroyed";
		this.m.Icon = "shields/icon_faction_shield_round_" + variant + "_01.png";
		this.m.IconLarge = "shields/inventory_faction_shield_round_" + variant + "_01.png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});


this.buckler_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.buckler";
		this.m.Name = "Buckler";
		this.m.Description = "A small but sturdy shield gripped in the fist. Offers poor protection against ranged attacks but can be useful in deflecting blows in melee.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.SoundOnHit = this.Const.Sound.ShieldHitMetal;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.Value = 45;
		this.m.MeleeDefense = 10;
		this.m.RangedDefense = 5;
		this.m.StaminaModifier = -4;
		this.m.Condition = 16;
		this.m.ConditionMax = 16;
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_buckler_0" + this.m.Variant;
		this.m.SpriteDamaged = "shield_buckler_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "shield_buckler_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/inventory_buckler_shield_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_buckler_shield_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});


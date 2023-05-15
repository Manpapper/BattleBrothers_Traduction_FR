this.rondel_dagger <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rondel_dagger";
		this.m.Name = "Dague à rouelles";
		this.m.Description = "Une longue pointe quadrangulaire conçue pour percer les points faibles de l\'armure.";
		this.m.Categories = "Dague, Une Main";
		this.m.IconLarge = "weapons/melee/dagger_02.png";
		this.m.Icon = "weapons/melee/dagger_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_dagger_02";
		this.m.Condition = 50.0;
		this.m.ConditionMax = 50.0;
		this.m.Value = 400;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.2;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/stab"));
		this.addSkill(this.new("scripts/skills/actives/puncture"));
	}

});


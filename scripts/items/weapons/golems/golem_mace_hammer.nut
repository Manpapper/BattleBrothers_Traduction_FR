this.golem_mace_hammer <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.golem_mace_hammer";
		this.m.Name = "Mace and Hammer";
		this.m.Description = "";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsDoubleGrippable = true;
		this.m.IsDroppedAsLoot = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_dual_mace_hammer_01";
		this.m.RangeMin = 1;
		this.m.RangeMax = 1;
		this.m.RangeIdeal = 1;
		this.m.Value = 0;
		this.m.Condition = 0;
		this.m.ConditionMax = 0;
		this.m.StaminaModifier = 0;
		this.m.RegularDamage = 0;
		this.m.RegularDamageMax = 0;
		this.m.ArmorDamageMult = 0.0;
		this.m.DirectDamageMult = 0.0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/golem_bash_skill"));
		this.addSkill(this.new("scripts/skills/actives/golem_knock_out_skill"));
		local batter = this.new("scripts/skills/actives/golem_batter_skill");
		batter.m.Icon = "skills/active_60.png";
		batter.m.IconDisabled = "skills/active_60_sw.png";
		batter.m.Overlay = "active_60";
		this.addSkill(batter);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


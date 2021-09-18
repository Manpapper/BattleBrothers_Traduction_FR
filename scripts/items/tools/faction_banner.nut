this.faction_banner <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.faction_banner";
		this.m.Name = "Battle Standard";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDroppedAsLoot = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = false;
		this.m.ArmamentIcon = "";
		this.m.Value = 1000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 0;
		this.m.ConditionMax = 0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local impale = this.new("scripts/skills/actives/impale");
		impale.m.Icon = "skills/active_54.png";
		impale.m.IconDisabled = "skills/active_54_sw.png";
		impale.m.Overlay = "active_54";
		this.addSkill(impale);
	}

	function updateAppearance()
	{
		if (!this.isEquipped())
		{
			return;
		}

		local actor = this.getContainer().getActor();
		local variant = this.m.Variant < 10 ? "0" + this.m.Variant : this.m.Variant;

		if (actor.hasSprite("background"))
		{
			actor.getSprite("background").setBrush("faction_banner_" + variant);
		}

		if (actor.hasSprite("shaft"))
		{
			actor.getSprite("shaft").setBrush("faction_banner_shaft");
		}

		actor.setDirty(true);
	}

	function onMovementFinished()
	{
		local actor = this.getContainer().getActor();
		local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());

		foreach( ally in allies )
		{
			if (ally.getID() != actor.getID())
			{
				ally.getSkills().update();
			}
		}
	}

});


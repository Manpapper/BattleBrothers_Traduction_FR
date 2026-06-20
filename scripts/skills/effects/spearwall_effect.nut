this.spearwall_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.spearwall";
		this.m.Name = "Mur de Lance";
		this.m.Icon = "skills/status_effect_04.png";
		this.m.IconMini = "status_effect_04_mini";
		this.m.Overlay = "status_effect_04";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Une fois sa lance prête, ce personnage bénéficie d\'une attaque gratuite automatique contre tout adversaire tentant de pénétrer dans sa zone de contrôle.";
	}

	function onAdded()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (item != null && item.isItemType(this.Const.Items.ItemType.MeleeWeapon))
		{
			item.onLowerWeapon();
		}
	}

	function onUpdate( _properties )
	{
		_properties.IsAttackingOnZoneOfControlEnter = true;

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInSpears)
		{
			_properties.IsAttackingOnZoneOfControlAlways = true;
		}
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

	function onRemoved()
	{
		local item = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (item != null && item.isItemType(this.Const.Items.ItemType.MeleeWeapon))
		{
			item.onRaiseWeapon();
		}
		else
		{
			local app = this.getContainer().getActor().getItems().getAppearance();
			app.LowerWeapon = false;
			this.getContainer().getActor().getItems().updateAppearance();
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.Tactical.TurnSequenceBar.getActiveEntity() == null || this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getContainer().getActor().getID())
		{
			_properties.DamageTotalMult *= 0.5;
		}
	}

});


this.perk_quick_hands <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function isSpent()
	{
		return this.m.IsSpent;
	}

	function create()
	{
		this.m.ID = "perk.quick_hands";
		this.m.Name = this.Const.Strings.PerkName.QuickHands;
		this.m.Description = "Et si vous utilisiez plutôt celui-ci ? Ce personnage a les mains agiles et peut encore échanger un objet gratuitement ce tour-ci.";
		this.m.Icon = "ui/perks/perk_39.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillOrder.Any;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().isPlayerControlled() && this.getContainer().getActor().isPlacedOnMap() && !this.m.IsSpent)
		{
			this.m.IsHidden = false;
		}
		else
		{
			this.m.IsHidden = true;
		}
	}

	function onSpend( _items )
	{
		local isShield = false;

		foreach( i in _items )
		{
			if (i != null && i.isItemType(this.Const.Items.ItemType.Shield))
			{
				isShield = true;
				break;
			}
		}

		if (!isShield)
		{
			this.m.IsSpent = true;
		}
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onCombatStarted()
	{
		this.skill.onCombatStarted();
		this.m.IsSpent = false;

		if (this.getContainer().getActor().isPlayerControlled())
		{
			this.m.IsHidden = false;
		}
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsSpent = false;
		this.m.IsHidden = true;
	}

});


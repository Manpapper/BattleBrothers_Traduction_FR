this.hand_to_hand <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.hand_to_hand";
		this.m.Name = "Attaque au corps à corps";
		this.m.Description = "Une attaque basique au poing. Faites les voler !";
		this.m.KilledString = "Écrasé à mort";
		this.m.Icon = "skills/active_08.png";
		this.m.IconDisabled = "skills/active_08_sw.png";
		this.m.Overlay = "active_08";
		this.m.SoundOnUse = [
			"sounds/combat/hand_01.wav",
			"sounds/combat/hand_02.wav",
			"sounds/combat/hand_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/hand_hit_01.wav",
			"sounds/combat/hand_hit_02.wav",
			"sounds/combat/hand_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsSerialized = false;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.1;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "A [color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] chance de toucher"
		});
		return ret;
	}

	function isUsable()
	{
		local mainhand = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return (mainhand == null || this.getContainer().hasSkill("effects.disarmed")) && this.skill.isUsable();
	}

	function isHidden()
	{
		local mainhand = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return mainhand != null && !this.getContainer().hasSkill("effects.disarmed") || this.skill.isHidden();
	}

	function onUpdate( _properties )
	{
		if (this.isUsable())
		{
			_properties.DamageRegularMin = 5;
			_properties.DamageRegularMax = 10;
			_properties.DamageArmorMult = 0.5;
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill -= 10;
		}
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

});


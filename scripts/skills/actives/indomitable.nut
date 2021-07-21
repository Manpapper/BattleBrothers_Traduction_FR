this.indomitable <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.indomitable";
		this.m.Name = "Invincible";
		this.m.Description = "Rassemble toute la force physique et la volonté pour devenir Invincible jusqu\'au tour suivant.";
		this.m.Icon = "ui/perks/perk_30_active.png";
		this.m.IconDisabled = "ui/perks/perk_30_active_sw.png";
		this.m.Overlay = "perk_30_active";
		this.m.SoundOnUse = [
			"sounds/combat/indomitable_01.wav",
			"sounds/combat/indomitable_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Reçoit seulement [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] des dégâts"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ne peut pas être étourdi"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ne peut pas être repousser ou attraper"
			}
		];
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.indomitable");
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (!this.getContainer().hasSkill("effects.indomitable"))
		{
			this.m.Container.add(this.new("scripts/skills/effects/indomitable_effect"));
			return true;
		}

		return false;
	}

});


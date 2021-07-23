this.perfect_focus <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.perfect_focus";
		this.m.Name = "Concentration Parfaite";
		this.m.Description = "Devenez un avec votre arme et gagnez une concentration parfaite comme si le temps s\'arrêtait.";
		this.m.Icon = "ui/perks/perk_37_active.png";
		this.m.IconDisabled = "ui/perks/perk_37_active_sw.png";
		this.m.Overlay = "perk_37_active";
		this.m.SoundOnUse = [
			"sounds/combat/perfect_focus_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 10;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		local ret = [
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
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Les Points d\'Action pour utiliser des compétences sont divisés par deux jusqu\'à la fin de ce tour, mais le gain de Fatigue est doublé."
			}
		];
		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.perfect_focus");
	}

	function onUse( _user, _targetTile )
	{
		if (!this.getContainer().hasSkill("effects.perfect_focus"))
		{
			this.m.Container.add(this.new("scripts/skills/effects/perfect_focus_effect"));
			return true;
		}

		return false;
	}

});


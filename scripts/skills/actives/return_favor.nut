this.return_favor <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.return_favor";
		this.m.Name = "Rendre la Faveur";
		this.m.Description = "Utilise vos compétences de guerrier aguerri pour adopter une posture défensive et vous essayerez d\'incapaciter tous les personnes qui vous attaqueront que vous pouvez toucher vous-même.";
		this.m.Icon = "ui/perks/perk_31_active.png";
		this.m.IconDisabled = "ui/perks/perk_31_active_sw.png";
		this.m.Overlay = "perk_31_active";
		this.m.SoundOnUse = [
			"sounds/combat/return_favor_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 30;
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
				text = "Gagne une chance de [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] d\'étourdir un ennemi qui vous attaquerait en mêlée mais ne vous toucherait pas (résistances et immunités s\'appliquent toujours)."
			}
		];
		return ret;
	}

	function isUsable()
	{
		return !this.m.IsSpent && this.skill.isUsable();
	}

	function onUse( _user, _targetTile )
	{
		if (!this.m.IsSpent)
		{
			this.m.Container.add(this.new("scripts/skills/effects/return_favor_effect"));
			this.m.IsSpent = true;
			return true;
		}

		return false;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

});


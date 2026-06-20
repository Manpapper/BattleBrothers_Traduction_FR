this.overwhelmed_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Count = 1
	},
	function create()
	{
		this.m.ID = "effects.overwhelmed";
		this.m.Name = "Débordé";
		this.m.Description = "Ce personnage a été submergé par une rafale d\'attaques auxquelles il a dû faire face, ce qui ne lui a laissé que peu d\'occasions de contre-attaquer efficacement.";
		this.m.Icon = "skills/status_effect_74.png";
		this.m.IconMini = "status_effect_74_mini";
		this.m.Overlay = "status_effect_74";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		if (this.m.Count <= 1)
		{
			return this.m.Name;
		}
		else
		{
			return this.m.Name + " (x" + this.m.Count + ")";
		}
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
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.Count * 10 + "%[/color] Compétence en Mêlée"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.Count * 10 + "%[/color] Compétence à Distance"
			}
		];
	}

	function onRefresh()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " résiste aux assauts grâce à sa physiologie hors du commun");
			}

			return;
		}

		++this.m.Count;
		this.spawnIcon("status_effect_74", this.getContainer().getActor().getTile());
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkillMult = this.Math.maxf(0.0, _properties.MeleeSkillMult - 0.1 * this.m.Count);
		_properties.RangedSkillMult = this.Math.maxf(0.0, _properties.RangedSkillMult - 0.1 * this.m.Count);
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

	function onNewRound()
	{
		this.removeSelf();
	}

});


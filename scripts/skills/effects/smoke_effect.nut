this.smoke_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.smoke";
		this.m.Name = "Enveloppé de Fumée";
		this.m.Icon = "skills/status_effect_117.png";
		this.m.IconMini = "status_effect_117_mini";
		this.m.Overlay = "status_effect_117";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage est enveloppé de denses nappes de fumée. Apparaissant et disparaissant à volonté, il peut se déplacer librement et ignorer toutes les zones de contrôle.";
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
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] Compétence à Distance"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100%[/color] de Défense à Distance"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Non affecté par les zones de contrôle"
			}
		];
	}

	function onNewRound()
	{
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap())
		{
			return;
		}

		local tile = actor.getTile();

		if (tile.Properties.Effect == null || tile.Properties.Effect.Type != "smoke")
		{
			this.removeSelf();
		}
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap())
		{
			return;
		}

		local tile = actor.getTile();

		if (tile.Properties.Effect == null || tile.Properties.Effect.Type != "smoke")
		{
			this.removeSelf();
		}
		else
		{
			_properties.RangedSkillMult *= 0.5;
			_properties.RangedDefenseMult *= 2.0;
		}
	}

});


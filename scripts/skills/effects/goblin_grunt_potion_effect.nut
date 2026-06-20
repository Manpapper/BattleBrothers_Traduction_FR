this.goblin_grunt_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.goblin_grunt_potion";
		this.m.Name = "Muscles des jambes réactifs";
		this.m.Icon = "skills/status_effect_124.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_124";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Les jambes de ce personnage ont subi une mutation qui lui permet d\'effectuer des mouvements rapides et complexes avec plus d\'aisance et de rapidité. Au repos, on peut encore parfois apercevoir ses muscles trembler sous la peau.";
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
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Les coûts en points d\'action des compétences \"Remplacer\" et \"Jeu de jambes\" sont réduits à [color=" + this.Const.UI.Color.PositiveValue + "]2[/color]"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Les coûts en fatigue des compétences \"Remplacer\" et \"Jeu de jambes\" sont réduits de [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color]"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "D\'autres mutations entraîneront une durée de maladie plus longue."
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.IsFleetfooted = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGoblinGruntPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGoblinGruntPotionAcquired", false);
	}

});


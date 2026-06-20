this.wiederganger_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.wiederganger_potion";
		this.m.Name = "Réactivité Sous-Cutanée";
		this.m.Icon = "skills/status_effect_135.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_135";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ce n\'est qu\'une blessure superficielle ! Les tissus sous-cutanés de ce personnage ont subi une mutation et réagissent automatiquement à tout traumatisme soudain, réduisant ainsi le risque de blessures au combat.";
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
				icon = "ui/icons/special.png",
				text = "Le seuil à partir duquel la probabilité de subir une blessure est augmentée de [color=" + this.Const.UI.Color.PositiveValue + "]33%[/color]"
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
		_properties.ThresholdToReceiveInjuryMult *= 1.33;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isWiedergangerPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isWiedergangerPotionAcquired", false);
	}

});


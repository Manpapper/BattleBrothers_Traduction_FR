this.orc_warrior_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.orc_warrior_potion";
		this.m.Name = "Redondance Sensorielle";
		this.m.Icon = "skills/status_effect_128.png";
		this.m.IconMini = "status_effect_128_mini";
		this.m.Overlay = "status_effect_128";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Le corps de ce personnage a subi une mutation qui lui a permis de développer un certain nombre de synapses redondantes, ce qui lui permet de conserver un certain contrôle sur sa vue, son ouïe et sa motricité, même lorsqu’il subit des coups dévastateurs.";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]33%[/color] chance de résister aux effets d\'état \"Étourdi\", \"Chancelant\", \"Assommé\", \"Distrait\" et \"Flétri\""
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
		_properties.IsResistantToPhysicalStatuses = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isOrcWarriorPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isOrcWarriorPotionAcquired", false);
	}

});


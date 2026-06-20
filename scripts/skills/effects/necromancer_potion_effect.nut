this.necromancer_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.necromancer_potion";
		this.m.Name = "Visions";
		this.m.Icon = "skills/status_effect_138.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_138";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ce personnage a d\'étranges visions de ce qui s\'est passé et de ce qui va arriver. Même si cela ne met pas vraiment à l\'ambiance autour du feu de camp, cela semble lui conférer une certaine capacité à créer des liens et à assimiler plus rapidement de nouvelles expériences.";
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
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] de gain d\'Expérience"
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
		_properties.XPGainMult *= 1.2;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isNecromancerPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isNecromancerPotionAcquired", false);
	}

});


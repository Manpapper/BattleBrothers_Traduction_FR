this.serpent_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.serpent_potion";
		this.m.Name = "Opportunisme Renforcé";
		this.m.Icon = "skills/status_effect_142.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_142";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Les yeux de ce personnage ont été modifiés pour lui permettre de détecter plus facilement les failles dans les défenses d\'une cible. Il semble également émettre de très légers sifflements ressemblant à des \"s\".";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3%[/color] chance de porter un coup en combat rapproché pour chaque allié adjacent à votre cible"
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
		_properties.SurroundedBonus += 3;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isSerpentPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isSerpentPotionAcquired", false);
	}

});


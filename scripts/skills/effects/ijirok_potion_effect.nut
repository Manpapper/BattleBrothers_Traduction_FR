this.ijirok_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ijirok_potion";
		this.m.Name = "Sous l\'égide du Dieu Fou";
		this.m.Icon = "skills/status_effect_150.png";
		this.m.IconMini = "status_effect_150_mini";
		this.m.Overlay = "status_effect_150";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ce personnage a quelque chose d\'étrange. Outre ses éclats de rire hystériques et ses tirades murmurées, son corps semble, de manière aléatoire, rejeter les modifications qui lui sont infligées. Au combat, cela a pour effet positif de lui permettre parfois d\'ignorer les effets débilitants.";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] chance de résister à tout effet d\'état, comme \"Étourdi\" ou \"Assommé\""
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
		_properties.IsResistantToAnyStatuses = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isIjirokPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isIjirokPotionAcquired", false);
	}

});


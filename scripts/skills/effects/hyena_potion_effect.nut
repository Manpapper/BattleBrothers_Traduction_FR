this.hyena_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.hyena_potion";
		this.m.Name = "Coagulation sous-cutanée";
		this.m.Icon = "skills/status_effect_143.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_143";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Lorsque la peau de ce personnage est lacérée, une substance est sécrétée qui accélère considérablement le processus de coagulation sanguine dans la zone touchée. Les blessures hémorragiques sont donc beaucoup moins graves, même si une certaine perte de sang persiste.";
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
				text = "Les dégâts subis en raison de l\'effet d\'état \"Saignement\" sont réduits de [color=" + this.Const.UI.Color.NegativeValue + "]50%[/color]"
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

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isHyenaPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isHyenaPotionAcquired", false);
	}

});


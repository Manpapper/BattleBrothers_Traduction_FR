this.rachegeist_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rachegeist_potion";
		this.m.Name = "Aura Macabre";
		this.m.Icon = "skills/status_effect_153.png";
		this.m.IconMini = "status_effect_153_mini";
		this.m.Overlay = "status_effect_153";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ce personnage a consommé une substance, désormais présente dans son sang, qui émet un champ cinétique. Ce champ s\'intensifie à mesure que sa santé se détériore, jusqu\'à émettre un scintillement bleu et à produire un effet perceptible sur tous les coups qu\'il inflige ou qu\'il subit. Il affirme également entendre un murmure constant, presque imperceptible, lorsqu\'il est seul, mais il s\'agit probablement d\'une superstition.";
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
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] de Dégâts si les Points de vie sont en dessous de [color=" + this.Const.UI.Color.NegativeValue + "]50%[/color]"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Reçoit seulement [color=" + this.Const.UI.Color.PositiveValue + "]75%[/color] des Dégâts si les Points de vie sont en dessous de [color=" + this.Const.UI.Color.NegativeValue + "]50%[/color]"
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
		local actor = this.getContainer().getActor();

		if (actor.getHitpoints() < actor.getHitpointsMax() / 2)
		{
			_properties.DamageTotalMult *= 1.25;
			_properties.DamageReceivedTotalMult *= 0.75;
		}
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isRachegeistPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isRachegeistPotionAcquired", false);
	}

});


this.ifrit_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		HeadArmorBoost = 25,
		HeadDamageTaken = 0,
		BodyArmorBoost = 25,
		BodyDamageTaken = 0
	},
	function create()
	{
		this.m.ID = "effects.ifrit_potion";
		this.m.Name = "Peau de pierre";
		this.m.Icon = "skills/status_effect_141.png";
		this.m.IconMini = "status_effect_141_mini";
		this.m.Overlay = "status_effect_141";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "La peau de ce personnage a subi une mutation et forme désormais des plaques dures, semblables à de la roche, qui sont bien plus résistantes et difficiles à percer. Lorsqu’elles se brisent, ces plaques se reforment progressivement, au cours d’un processus apparemment assez douloureux et désagréable. Vous devriez leur dire d’arrêter de gratter cette croûte.";
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
				icon = "ui/icons/armor_body.png",
				text = "La peau de ce personnage est dure et semblable à de la pierre, ce qui lui confère [color=" + this.Const.UI.Color.PositiveValue + "]25[/color] de points d\'armure naturelle"
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

	function onCombatStarted()
	{
		this.m.HeadDamageTaken = 0;
		this.m.BodyDamageTaken = 0;
	}

	function onCombatFinished()
	{
		this.m.HeadDamageTaken = 0;
		this.m.BodyDamageTaken = 0;
	}

	function onUpdate( _properties )
	{
		_properties.Armor[this.Const.BodyPart.Head] += this.Math.max(0.0, this.m.HeadArmorBoost - this.m.HeadDamageTaken);
		_properties.Armor[this.Const.BodyPart.Body] += this.Math.max(0.0, this.m.BodyArmorBoost - this.m.BodyDamageTaken);
		_properties.ArmorMax[this.Const.BodyPart.Head] += this.m.HeadArmorBoost;
		_properties.ArmorMax[this.Const.BodyPart.Body] += this.m.BodyArmorBoost;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.BodyPart == this.Const.BodyPart.Head)
		{
			if (this.m.HeadDamageTaken >= this.m.HeadArmorBoost)
			{
				return;
			}

			_properties.DamageArmorReduction += this.m.HeadArmorBoost - this.m.HeadDamageTaken;
			this.m.HeadDamageTaken += _hitInfo.DamageArmor;
		}
		else if (_hitInfo.BodyPart == this.Const.BodyPart.Body)
		{
			if (this.m.BodyDamageTaken >= this.m.BodyArmorBoost)
			{
				return;
			}

			_properties.DamageArmorReduction += this.m.BodyArmorBoost - this.m.BodyDamageTaken;
			this.m.BodyDamageTaken += _hitInfo.DamageArmor;
		}
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isIfritPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isIfritPotionAcquired", false);
	}

});


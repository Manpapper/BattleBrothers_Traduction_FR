this.orc_young_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.orc_young_potion";
		this.m.Name = "Coups Cinétiques";
		this.m.Icon = "skills/status_effect_127.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_127";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Les poignets de ce personnage ont subi une mutation qui leur permet d\'amortir le choc initial provoqué par les forces adverses. Concrètement, ils réduisent les propriétés protectrices de l\'armure d\'un ennemi lorsqu\'ils le frappent. Ils permettent également de créer des ombres chinoises assez farfelues.";
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
				icon = "ui/icons/armor_damage.png",
				text = "Les attaques ont [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] efficacité contre l\'armure"
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
		_properties.DamageArmorMult += 0.1;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isOrcYoungPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isOrcYoungPotionAcquired", false);
	}

});


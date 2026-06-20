this.geist_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.geist_potion";
		this.m.Name = "Revêtement cinétique";
		this.m.Icon = "skills/status_effect_137.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_137";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ce personnage est capable de sécréter une substance qui vibre rapidement lorsqu\'elle est stimulée. Appliquée à des armes, cette substance génère une forte force cinétique qui facilite la pénétration des armures.";
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
				icon = "ui/icons/direct_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] de chance supplémentaire d\'ignorer l\'armure en utilisant des armes de Mêlée"
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
		_properties.DamageDirectMeleeAdd += 0.05;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGeistPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGeistPotionAcquired", false);
	}

});


this.alp_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.alp_potion";
		this.m.Name = "Globes oculaires améliorés";
		this.m.Icon = "skills/status_effect_147.png";
		this.m.IconMini = "status_effect_147_mini";
		this.m.Overlay = "status_effect_147";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Les yeux de ce personnage ont subi une mutation qui leur permet de s\'adapter plus rapidement et de manière plus spectaculaire aux environnements peu éclairés. De ce fait, sa vision nocturne est presque aussi bonne que sa vision diurne.";
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
				text = "Non affecté aux pénalités nocturnes"
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
		_properties.IsAffectedByNight = false;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isAlpPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isAlpPotionAcquired", false);
	}

});


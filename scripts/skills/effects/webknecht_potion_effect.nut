this.webknecht_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.webknecht_potion";
		this.m.Name = "Système Circulatoire Altéré";
		this.m.Icon = "skills/status_effect_144.png";
		this.m.IconMini = "status_effect_144_mini";
		this.m.Overlay = "status_effect_144";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Le corps de ce personnage a subi une mutation qui ralentit considérablement la diffusion des toxines et autres substances dangereuses dans le sang, ce qui permet de les éliminer sans conséquences graves pour la santé. Curieusement, cela ne semble pas affecter sa capacité à s\'enivrer.";
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
				text = "Immunisé contre les effets des poisons, y compris ceux des Webknechts et des gobelins"
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
		_properties.IsImmuneToPoison = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isWebknechtPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isWebknechtPotionAcquired", false);
	}

});


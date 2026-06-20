this.nachzehrer_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.nachzehrer_potion";
		this.m.Name = "Croissance Tissulaire Hyperactive";
		this.m.Icon = "skills/status_effect_149.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_149";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Le corps de ce personnage a subi une mutation qui lui permet de régénérer sa peau et ses tissus musculaires beaucoup plus rapidement que la normale. Les blessures profondes cicatrisent donc bien plus vite que d\'habitude. Il semble également avoir développé un goût prononcé pour la viande rouge, mais cela n\'a probablement aucun rapport.";
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
				icon = "ui/icons/days_wounded.png",
				text = "Réduit d\'un jour le temps nécessaire à la guérison de toute blessure, jusqu\'à un minimum d\'un jour"
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
			this.World.Statistics.getFlags().set("isNachzehrerPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isNachzehrerPotionAcquired", false);
	}

	function onUpdate( _properties )
	{
		_properties.AdditionalHealingDays -= 1;
	}

});


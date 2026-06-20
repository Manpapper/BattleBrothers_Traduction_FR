this.goblin_shaman_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.goblin_shaman_potion";
		this.m.Name = "Glandes sudoripares hyperactives";
		this.m.Icon = "skills/status_effect_125.png";
		this.m.IconMini = "status_effect_125_mini";
		this.m.Overlay = "status_effect_125";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Dans les situations de stress intense, le corps muté de ce personnage produit une substance visqueuse et gluante qu’il commence à transpirer abondamment. Dans cet état, il lui sera beaucoup plus facile de se libérer de n’importe quel filet ou piège. Pensez simplement à emporter une serviette.";
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
				text = "Capable de toujours réussir à échapper aux effets de pièges, tels que ceux causés par des filets ou des racines"
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
			this.World.Statistics.getFlags().set("isGoblinShamanPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGoblinShamanPotionAcquired", false);
	}

});


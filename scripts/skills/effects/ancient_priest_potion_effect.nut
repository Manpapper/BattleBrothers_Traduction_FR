this.ancient_priest_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ancient_priest_potion";
		this.m.Name = "Synapse Blockage";
		this.m.Icon = "skills/status_effect_134.png";
		this.m.IconMini = "status_effect_134_mini";
		this.m.Overlay = "status_effect_134";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Le corps de ce personnage a subi une mutation qui a altéré sa réaction de \"combat ou fuite\". Dans les situations de stress intense, son système limbique se voit tout simplement privé des ressources nécessaires à la fuite, ce qui le rend pratiquement invincible sur le champ de bataille.";
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
				icon = "ui/icons/morale.png",
				text = "Ne peut pas être réduit à la morale \'Fuite\', seulement \'Rompre\'"
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
			this.World.Statistics.getFlags().set("isAncientPriestPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isAncientPriestPotionAcquired", false);
	}

});


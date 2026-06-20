this.skeleton_warrior_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.skeleton_warrior_potion";
		this.m.Name = "Raccords à Verrouillage";
		this.m.Icon = "skills/status_effect_131.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_131";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Le corps de ce personnage a subi une mutation qui lui permet de bloquer ses membres dans certaines positions presque indéfiniment, ce qui lui permet d\'encaisser les coups sans presque transpirer.";
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
				text = "Réduit le coût en fatigue de la compétence \"Mur de Boulier\" de [color=" + this.Const.UI.Color.PositiveValue + "]" + 100 * (1 - this.Const.Combat.WeaponSpecFatigueMult) + "%[/color]"
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
		_properties.IsProficientWithShieldWall = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isSkeletonWarriorPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isSkeletonWarriorPotionAcquired", false);
	}

});


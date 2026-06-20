this.double_strike_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TimeAdded = 0
	},
	function create()
	{
		this.m.ID = "effects.double_strike";
		this.m.Name = "Double coup !";
		this.m.Icon = "skills/status_effect_01.png";
		this.m.IconMini = "status_effect_01_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Après avoir réussi un coup, ce personnage est prêt à enchaîner avec une puissante attaque ! La prochaine attaque infligera [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] de Dégâts à une cible. Si plusieurs cibles sont touchées, seule la première subira des dégâts accrus. Si l\'attaque rate sa cible, l\'effet est perdu.";
	}

	function onAdded()
	{
		this.m.TimeAdded = this.Time.getVirtualTimeF();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		if (!this.m.IsGarbage && this.m.TimeAdded + 0.1 < this.Time.getVirtualTimeF() && !_targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			_properties.DamageTotalMult *= 1.2;
			this.removeSelf();
		}
	}

});


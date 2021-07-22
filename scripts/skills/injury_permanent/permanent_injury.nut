this.permanent_injury <- this.inherit("scripts/skills/skill", {
	m = {
		IsFresh = true
	},
	function getNameOnly()
	{
		return this.m.Name;
	}

	function isFresh()
	{
		return this.m.IsFresh;
	}

	function setTreated( _f )
	{
	}

	function setOutOfCombat( _f )
	{
	}

	function create()
	{
		this.m.IsStacking = false;
		this.m.Type = this.Const.SkillType.Injury | this.Const.SkillType.PermanentInjury;
		this.m.Order = this.Const.SkillOrder.PermanentInjury;
	}

	function addTooltipHint( _tooltip )
	{
		_tooltip.push({
			id = 6,
			type = "hint",
			icon = "ui/icons/days_wounded.png",
			text = "Permanent"
		});
	}

	function showInjury()
	{
		this.onApplyAppearance();
	}

	function isValid( _actor )
	{
		return true;
	}

	function onAdded()
	{
		this.onApplyAppearance();
	}

	function onCombatStarted()
	{
		this.m.IsFresh = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.onApplyAppearance();
	}

	function onApplyAppearance()
	{
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.IsFresh = false;
	}

});


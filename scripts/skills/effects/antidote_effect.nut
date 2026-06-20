this.antidote_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.immune_to_poison";
		this.m.Name = "Immunité au poison";
		this.m.Icon = "skills/status_effect_118.png";
		this.m.IconMini = "status_effect_118_mini";
		this.m.Overlay = "status_effect_118";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage a pris un antidote et est désormais immunisé contre tout type de poison pendant encore [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] tour(s).";
	}

	function onAdded()
	{
		this.m.TurnsLeft = 3;
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 3;
		this.spawnIcon("status_effect_118", this.getContainer().getActor().getTile());
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToPoison = true;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});


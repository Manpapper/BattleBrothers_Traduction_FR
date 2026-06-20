this.indomitable_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.indomitable";
		this.m.Name = "Indomptable";
		this.m.Icon = "ui/perks/perk_30.png";
		this.m.IconMini = "perk_30_mini";
		this.m.Overlay = "perk_30";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage a mobilisé toute sa force physique et sa volonté pour devenir indomptable jusqu\'à son prochain tour.";
	}

	function getTooltip()
	{
		return [
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
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Reçoit [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] de tout type d\'attaque"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immunisé contre les étourdissements"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immunisé contre les repoussements et les saisies"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= 0.5;
		_properties.IsImmuneToStun = true;
		_properties.IsImmuneToKnockBackAndGrab = true;
		_properties.TargetAttractionMult *= 0.5;
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

});


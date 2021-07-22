this.broken_knee_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.broken_knee";
		this.m.Name = "Genou Cassé";
		this.m.Description = "Ce personnage a prit quelque chose dans le genou, et ça n\'a jamais vraiment guéri. Se précipiter en avant ou éviter des coups peut être douloureux, et ça manque d\'une grâce certaine.";
		this.m.Icon = "ui/injury/injury_permanent_icon_11.png";
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
				id = 7,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] de Défense en Mêlée"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] de Défense à Distance"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] d\'Initiative"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Est toujours content d'être placé en réserve"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefenseMult *= 0.6;
		_properties.RangedDefenseMult *= 0.6;
		_properties.InitiativeMult *= 0.6;
		_properties.IsContentWithBeingInReserve = true;
	}

	function onApplyAppearance()
	{
	}

});


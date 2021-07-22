this.swift_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.swift";
		this.m.Name = "Leste";
		this.m.Icon = "ui/traits/trait_icon_53.png";
		this.m.Description = "Ce personnage est naturellement leste et agile, et a plus de chance d\'esquiver les projectiles.";
		this.m.Titles = [
			"le Leste",
			"Rapide sur ses Pieds"
		];
		this.m.Excluded = [
			"trait.clumsy",
			"trait.fat",
			"trait.clubfooted"
		];
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
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] de Défense à Distance"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.RangedDefense += 5;
	}

});


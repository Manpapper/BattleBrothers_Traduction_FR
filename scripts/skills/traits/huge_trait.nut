this.huge_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.huge";
		this.m.Name = "Immense";
		this.m.Icon = "ui/traits/trait_icon_61.png";
		this.m.Description = "Étant particulièrement grand et costaud, les coups de ce personnage font très mal, mais il est aussi une plus grosse cible que d\'autres.";
		this.m.Titles = [
			"la Montagne",
			"le Boeuf",
			"l\'Ours",
			"le Géant",
			"La Tour",
			"le Taureau"
		];
		this.m.Excluded = [
			"trait.tiny",
			"trait.quick",
			"trait.fragile"
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
				id = 12,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] de Maîtrise en Mêlée"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Défense en Mêlée"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Défense à Distance"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDamageMult *= 1.1;
		_properties.MeleeDefense -= 5;
		_properties.RangedDefense -= 5;
	}

});


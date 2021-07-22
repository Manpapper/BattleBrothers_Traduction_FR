this.night_blind_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.night_blind";
		this.m.Name = "Aveugle de nuit";
		this.m.Icon = "ui/traits/trait_icon_56.png";
		this.m.Description = "Durant la nuit, ce personnage a besoin d\'être attaché, car il ne voit même pas son propre nez.";
		this.m.Excluded = [
			"trait.eagle_eyes",
			"trait.night_owl"
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
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-1[/color] de Vision durant la Nuit"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().hasSkill("special.night"))
		{
			_properties.Vision -= 1;
		}
	}

});


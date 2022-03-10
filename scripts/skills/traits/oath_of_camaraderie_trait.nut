this.oath_of_camaraderie_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_camaraderie";
		this.m.Name = "Oath of Camaderie";
		this.m.Icon = "ui/traits/trait_icon_85.png";
		this.m.Description = "This character has taken an Oath of Camaraderie, and is sworn to stand and fall together with his allies. The general confusion of higher numbers on the battlefield, and the lack of focus on individual skill and personal glory has taken a toll on this character\'s resolve at the start of battle, however.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
		this.m.Excluded = [];
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
				icon = "ui/icons/morale.png",
				text = "Will start combat at Wavering or Breaking morale"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().isPlacedOnMap() && this.Time.getRound() < 1)
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				this.getContainer().getActor().setMoraleState(this.Const.MoraleState.Wavering);
			}
			else
			{
				this.getContainer().getActor().setMoraleState(this.Const.MoraleState.Breaking);
			}
		}
	}

});


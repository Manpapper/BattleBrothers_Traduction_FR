this.cursed_crystal_skull <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.cursed_crystal_skull";
		this.m.Name = "Cursed Crystal Skull";
		this.m.Description = "An eerie skull carved from a single large crystal. No scratch or other mark can be seen on its surface. Just being near it kills the fire of determination in almost any man, breaks hope and lets sprout doubts.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/ancient_skull.png";
		this.m.Sprite = "";
		this.m.Value = 250;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Reduces the Resolve of any opponent engaged in melee by [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color]"
		});
		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "User can never have [color=" + this.Const.UI.Color.NegativeValue + "]confident[/color] morale"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.Threat += 10;
		local actor = this.getContainer().getActor();
		actor.setMaxMoraleState(this.Const.MoraleState.Steady);

		if (actor.getMoraleState() > this.Const.MoraleState.Steady)
		{
			actor.setMoraleState(this.Const.MoraleState.Steady);
			actor.setDirty(true);
		}
	}

	function onCombatStarted()
	{
		this.getContainer().getActor().setMaxMoraleState(this.Const.MoraleState.Steady);
	}

});


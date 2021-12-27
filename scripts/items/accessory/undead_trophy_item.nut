this.undead_trophy_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.undead_trophy";
		this.m.Name = "Trophée morts-vivant";
		this.m.Description = "Cet ancien collier tiré d\'un tas d\'os déclare celui qui le porte un vétéran de nombreuses batailles contre le fléau morts-vivant, et un homme à ne pas faiblir facilement face à leur horreur.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/undead_trophy.png";
		this.m.Sprite = "undead_trophy";
		this.m.Value = 500;
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
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Double votre résolution si vous vous défendez contre la peur et les capacités de contrôle mental"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] *= 2.0;
	}

});


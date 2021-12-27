this.ghoul_trophy_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.ghoul_trophy";
		this.m.Name = "Collier Trophée de Nachzehrer";
		this.m.Description = "Ce collier fabriqué à partir de trophées prélevés sur divers Nachzehrers déclare que celui qui le porte est un vétéran de batailles contre les bêtes sauvages et qu\'il n\'est pas facile à intimider.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/nachzehrer_trophy.png";
		this.m.Sprite = "nachzehrer_trophy";
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
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+4[/color] Détermination"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.Bravery += 4;
	}

});


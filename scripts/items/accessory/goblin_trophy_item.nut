this.goblin_trophy_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.goblin_trophy";
		this.m.Name = "Trophé Goblin";
		this.m.Description = "Ce collier d\'oreilles de gobelin déclare celui qui le porte comme un vétéran de nombreuses batailles contre la menace verte, pas du genre à tomber dans leurs sales petits tours.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/goblin_trophy.png";
		this.m.Sprite = "goblin_trophy";
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
			text = "Accorde l\'immunité contre les filets ou les vignes saisissantes"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.IsImmuneToRoot = true;
	}

});


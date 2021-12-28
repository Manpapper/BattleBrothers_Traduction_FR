this.snake_oil_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.snake_oil";
		this.m.Name = "Huile de serpent";
		this.m.Description = "Une mystérieuse concoction qui aide à lutter contre la chute des cheveux, la syphilis, la surdité, l\'impuissance, les éruptions cutanées, la variole et le bloc de l\'écrivain. Une vraie potion miracle si seulement vous y croyez. Peut être vendu partout pour une jolie somme.";
		this.m.Icon = "misc/inventory_snake_oil.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Loot;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 650;
	}

	function getBuyPrice()
	{
		return this.m.Value;
	}

	function getSellPrice()
	{
		return this.m.Value;
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
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

});


this.snake_oil_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.snake_oil";
		this.m.Name = "Snake Oil";
		this.m.Description = "A mysterious concoction said to help against hair loss, syphilis, deafness, impotence, skin rash, pox and writer\'s block. A true miracle potion if only you believe in it. Can be sold everywhere for a tidy sum.";
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


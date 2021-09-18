this.paint_black_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.paint_black";
		this.m.Name = "Black Paint";
		this.m.Description = "A bucket of black paint. Can be used to paint many common helmets.";
		this.m.Icon = "consumables/paint_black.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 120;
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
			id = 65,
			type = "text",
			text = "Right-click or drag onto a helmet carried by the currently selected character in order to paint it. This item will be consumed in the process."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		local helmet = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head) : _item;

		if (helmet == null || !("onPaint" in helmet))
		{
			return false;
		}

		this.Sound.play("sounds/inventory/paint_set_use_01.wav", this.Const.Sound.Volume.Inventory);
		helmet.onPaint(this.Const.Items.Paint.Black);
		return true;
	}

});


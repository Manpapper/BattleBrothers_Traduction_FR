this.paint_set_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.paint_set_shields";
		this.m.Name = "Paint Set";
		this.m.Description = "A palette of several vibrant colors and a set of brushes. Can be used to paint common shields in your company\'s colors.";
		this.m.Icon = "consumables/paint_set_shields.png";
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
			text = "Right-click or drag onto a shield carried by the currently selected character in order to paint it. This item will be consumed in the process."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		local shield = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) : _item;

		if (shield == null)
		{
			return false;
		}

		local newShield;

		if (_item == null)
		{
			if (shield.getID() == "shield.faction_heater_shield")
			{
				newShield = this.new("scripts/items/shields/heater_shield");
				newShield.setCondition(shield.getCondition());
			}
			else if (shield.getID() == "shield.faction_kite_shield")
			{
				newShield = this.new("scripts/items/shields/kite_shield");
				newShield.setCondition(shield.getCondition());
			}
			else if (shield.getID() == "shield.faction_wooden_shield")
			{
				newShield = this.new("scripts/items/shields/wooden_shield");
				newShield.setCondition(shield.getCondition());
			}

			if (newShield != null)
			{
				_actor.getItems().unequip(shield);
				_actor.getItems().equip(newShield);
				shield = newShield;
			}
		}

		if (!("onPaintInCompanyColors" in shield))
		{
			return false;
		}

		this.Sound.play("sounds/inventory/paint_set_use_01.wav", this.Const.Sound.Volume.Inventory);
		shield.onPaintInCompanyColors();
		this.updateAchievement("AColorfulBand", 1, 1);
		return true;
	}

});


this.potion_of_knowledge_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.potion_of_knowledge";
		this.m.Name = "Potion of Knowledge";
		this.m.Description = "Knowledge of the world, arcane and mundane, is said to be distilled into this potion. Upon drinking it, lessons are more easily learned.";
		this.m.Icon = "consumables/potion_05.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 750;
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
			id = 13,
			type = "text",
			icon = "ui/icons/xp_received.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100%[/color] Experience Gain"
		});
		result.push({
			id = 65,
			type = "text",
			text = "Right-click or drag onto the currently selected character in order to drink. This item will be consumed in the process."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		this.Sound.play("sounds/combat/drink_03.wav", this.Const.Sound.Volume.Inventory);
		_actor.getSkills().add(this.new("scripts/skills/effects_world/new_knowledge_potion_effect"));
		this.Const.Tactical.Common.checkDrugEffect(_actor);
		return true;
	}

});


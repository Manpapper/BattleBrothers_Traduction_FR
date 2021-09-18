this.cat_potion_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "accessory.cat_potion";
		this.m.Name = "Cat Potion";
		this.m.Description = "Be quick as a cat! This potion promises to heighten your senses and sharpen your reflexes. Drink responsibly. Lasts for the next battle.";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_06.png";
		this.m.Value = 350;
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
			id = 11,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Initiative"
		});
		result.push({
			id = 65,
			type = "text",
			text = "Right-click or drag onto the currently selected character in order to drink. This item will be consumed in the process."
		});
		result.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Overindulgence may lead to sickness"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function getTime()
	{
		if (("State" in this.World) && this.World.State != null && this.World.State.getCombatStartTime() != 0)
		{
			return this.World.State.getCombatStartTime();
		}
		else
		{
			return this.Time.getVirtualTimeF();
		}
	}

	function onUse( _actor, _item = null )
	{
		this.Sound.play("sounds/combat/drink_0" + this.Math.rand(1, 3) + ".wav", this.Const.Sound.Volume.Inventory);
		_actor.getSkills().add(this.new("scripts/skills/effects/cat_potion_effect"));
		this.Const.Tactical.Common.checkDrugEffect(_actor);
		return true;
	}

});


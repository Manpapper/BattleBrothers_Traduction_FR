this.berserker_mushrooms_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "accessory.berserker_mushrooms";
		this.m.Name = "Strange Mushrooms";
		this.m.Description = "Strange mushrooms that have anyone chewing them enter a trance-like state of rage where they don\'t feel any pain and exhibit significantly increased aggression. Eat responsibly. Lasts for the next battle.";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.IconLarge = "";
		this.m.Icon = "consumables/mushrooms_01.png";
		this.m.Value = 100;
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
			icon = "ui/icons/regular_damage.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] Damage in Melee"
		});
		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/melee_defense.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] Melee Defense"
		});
		result.push({
			id = 12,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] Ranged Defense"
		});
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/morale.png",
			text = "No morale check triggered upon losing hitpoints"
		});
		result.push({
			id = 65,
			type = "text",
			text = "Right-click or drag onto the currently selected character in order to eat. This item will be consumed in the process."
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
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		this.Sound.play("sounds/combat/eat_01.wav", this.Const.Sound.Volume.Inventory);
		_actor.getSkills().add(this.new("scripts/skills/effects/berserker_mushrooms_effect"));
		this.Const.Tactical.Common.checkDrugEffect(_actor);
		return true;
	}

});


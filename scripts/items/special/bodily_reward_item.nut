this.bodily_reward_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.bodily_reward";
		this.m.Name = "Green Vial";
		this.m.Description = "Traded for with a malevolent witch at the expense of another man\'s life, this mysterious concoction promises to be a magical drink for the body, and to instantly heal any injury that would also heal on its own.";
		this.m.Icon = "consumables/vial_green_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 2500;
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
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Instantly heals all temporary injuries, as well as the Hangover and Exhausted status effects"
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
		_actor.getSkills().removeByType(this.Const.SkillType.TemporaryInjury);
		_actor.getSkills().removeByID("effects.hangover");
		_actor.getSkills().removeByID("effects.exhausted");
		_actor.setHitpoints(_actor.getHitpointsMax());
		this.Const.Tactical.Common.checkDrugEffect(_actor);
		return true;
	}

});


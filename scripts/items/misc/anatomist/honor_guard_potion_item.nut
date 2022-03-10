this.honor_guard_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.honor_guard_potion";
		this.m.Name = "Elixir of Boneflesh";
		this.m.Description = "The undead are rightly feared for their unflagging purpose and their unbreakable will, but any experienced warrior knows of a third horror, the dread creatures resistance to spears and arrows. With this concoction, the living may obtain such an aegis as well!";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_19.png";
		this.m.Value = 0;
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
			icon = "ui/icons/special.png",
			text = "Take between [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color] and [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] less damage from piercing attacks, such as those from bows or spears"
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
			text = "Mutates the body, causing sickness"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		_actor.getSkills().add(this.new("scripts/skills/effects/honor_guard_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});


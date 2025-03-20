this.grand_diviner_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.grand_diviner_potion";
		this.m.Name = "Elixir of Enlightenment";
		this.m.Description = "They say the difference between poison and medicine is in the dosage, and perhaps nowhere is this more true than the unusual substance found in the Grand Diviner\'s censer and, more curiously, bloodstream. Whoever drinks this elixir, brewed from that substance, will surely gain his same otherwordly vision!";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_39.png";
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
			text = "Immediately gain 10 levels worth of XP"
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
		_actor.addXP(this.Const.LevelXP[10], false);
		_actor.updateLevel();
		_actor.getSkills().add(this.new("scripts/skills/effects/grand_diviner_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});


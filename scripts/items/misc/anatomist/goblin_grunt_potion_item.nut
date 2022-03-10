this.goblin_grunt_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.goblin_grunt_potion";
		this.m.Name = "Potion of Fleetfoot";
		this.m.Description = "Developed from drugs found on goblin frontline troops, this concoction can grant a man the celerity typically found in the diminutive greenskins. May result in minor skin discoloration.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_11.png";
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
			icon = "ui/icons/action_points.png",
			text = "The Action Point costs of the Rotation and Footwork skills are reduced to [color=" + this.Const.UI.Color.PositiveValue + "]2[/color]"
		});
		result.push({
			id = 12,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = "The Fatigue costs of the Rotation and Footwork skills are reduced by [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color]"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/goblin_grunt_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});


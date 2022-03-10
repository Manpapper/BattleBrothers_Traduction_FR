this.rachegeist_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.rachegeist_potion";
		this.m.Name = "Knife Edge Potion";
		this.m.Description = "Few creatures defy understanding like the so-called Rachegeist. Through meticulous examination of its meager remains, however, this miraculous potion was created! Now even mortal men may bring out the power of undeath itself!";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_40.png";
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
			text = "Deal [color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] damage and receive only [color=" + this.Const.UI.Color.PositiveValue + "]75%[/color] of any damage if hitpoints are below [color=" + this.Const.UI.Color.NegativeValue + "]50%[/color]"
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
		_actor.getSkills().add(this.new("scripts/skills/effects/rachegeist_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});


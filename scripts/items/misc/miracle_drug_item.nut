this.miracle_drug_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.miracle_drug_";
		this.m.Name = "Apothecary\'s Miracle";
		this.m.Description = "A powerful remedy against many common illnesses and diseases, to reduce inflammation, and to support the body\'s natural healing.\n\nCharacters treated with this drug will recover faster from injuries, just like if they\'ve been treated at a temple.";
		this.m.Icon = "consumables/pills_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
		this.m.Value = 450;
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
			text = "Right-click or drag onto the currently selected character in order to swallow. This item will be consumed in the process."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		this.Sound.play("sounds/inventory/pills_swallow_01.wav", this.Const.Sound.Volume.Inventory);
		local allInjuries = _actor.getSkills().query(this.Const.SkillType.TemporaryInjury);

		foreach( injury in allInjuries )
		{
			injury.setTreated(true);
		}

		_actor.getSkills().removeByID("effects.hangover");
		_actor.updateInjuryVisuals();
		return true;
	}

});


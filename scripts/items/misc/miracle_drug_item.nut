this.miracle_drug_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.miracle_drug_";
		this.m.Name = "Miracle de l\'apothicaire";
		this.m.Description = "Un remède puissant contre de nombreuses maladies et maux courants, pour réduire l\'inflammation et favoriser la guérison naturelle du corps.\n\nLes personnages traités avec ce médicament se remettront plus rapidement des blessures, tout comme s\'ils avaient été traités à un temple.";
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
			text = "Faites un clic droit ou faites glisser sur le caractère actuellement sélectionné afin d\'ingérer. Cet article sera consommé au cours du processus."
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


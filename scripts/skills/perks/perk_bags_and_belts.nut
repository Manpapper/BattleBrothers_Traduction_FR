this.perk_bags_and_belts <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bags_and_belts";
		this.m.Name = this.Const.Strings.PerkName.BagsAndBelts;
		this.m.Description = this.Const.Strings.PerkDescription.BagsAndBelts;
		this.m.Icon = "ui/perks/perk_20.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		this.getContainer().getActor().getItems().setUnlockedBagSlots(4);
	}

	function onRemoved()
	{
		local items = this.getContainer().getActor().getItems();
		local item;
		item = items.getItemAtBagSlot(2);

		if (item != null)
		{
			items.removeFromBag(item);
			this.World.Assets.getStash().add(item);
		}

		item = items.getItemAtBagSlot(3);

		if (item != null)
		{
			items.removeFromBag(item);
			this.World.Assets.getStash().add(item);
		}

		this.getContainer().getActor().getItems().setUnlockedBagSlots(2);
	}

});


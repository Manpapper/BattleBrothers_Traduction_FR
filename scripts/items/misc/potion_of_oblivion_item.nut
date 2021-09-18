this.potion_of_oblivion_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.potion_of_oblivion";
		this.m.Name = "Potion of Oblivion";
		this.m.Description = "Better not ask how this concoction of the rarest and most bizarre ingredients tastes! Anybody who drinks this is said to be able to relive his life, changing the decisions he made along the way.";
		this.m.Icon = "consumables/potion_08.png";
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
		local perks = _actor.m.PerkPointsSpent;
		local hasStudent = false;

		if (_actor.getLevel() >= 11 && _actor.getSkills().hasSkill("perk.student"))
		{
			perks = perks - 1;
			hasStudent = true;
		}

		_actor.m.PerkPoints += perks;
		_actor.m.PerkPointsSpent = hasStudent ? 1 : 0;
		_actor.getSkills().removeByType(this.Const.SkillType.Perk);

		if (hasStudent)
		{
			_actor.getSkills().add(this.new("scripts/skills/perks/perk_student"));
		}

		this.Const.Tactical.Common.checkDrugEffect(_actor);
		this.updateAchievement("MemoryLoss", 1, 1);
		return true;
	}

});


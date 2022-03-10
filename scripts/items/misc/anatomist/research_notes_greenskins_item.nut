this.research_notes_greenskins_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.research_notes_greenskins";
		this.m.Name = "Greenskin Research Notes";
		this.m.Description = "A tidy collection of eyewitness reports, experiment logs, and research diaries detailing the anatomy of various greenskin specimens.";
		this.m.Icon = "misc/inventory_anatomists_book_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
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
			icon = "ui/icons/papers.png",
			text = "Tracks your study of orc and goblin anatomy"
		});
		local buffAcquisitions = [
			{
				flag = "isGoblinGruntPotionDiscovered",
				creatureName = "Goblin",
				potionName = "Potion of Fleetfoot"
			},
			{
				flag = "isGoblinOverseerPotionDiscovered",
				creatureName = "Goblin Overseer",
				potionName = "Deadeye\'s Draught"
			},
			{
				flag = "isGoblinShamanPotionDiscovered",
				creatureName = "Goblin Shaman",
				potionName = "Greasejar Potion"
			},
			{
				flag = "isOrcYoungPotionDiscovered",
				creatureName = "Orc Young",
				potionName = "Kineticist\'s Draft"
			},
			{
				flag = "isOrcBerserkerPotionDiscovered",
				creatureName = "Orc Berserker",
				potionName = "Rose Philter"
			},
			{
				flag = "isOrcWarriorPotionDiscovered",
				creatureName = "Orc Warrior",
				potionName = "Ironhead Potion"
			},
			{
				flag = "isOrcWarlordPotionDiscovered",
				creatureName = "Orc Warlord",
				potionName = "Font of Strength"
			}
		];

		foreach( buff in buffAcquisitions )
		{
			if (this.World.Statistics.getFlags().get(buff.flag))
			{
				result.push({
					id = 15,
					type = "text",
					icon = "ui/icons/special.png",
					text = "" + buff.creatureName + ": " + buff.potionName
				});
			}
		}

		return result;
	}

});


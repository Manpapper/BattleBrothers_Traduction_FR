this.research_notes_undead_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.research_notes_undead";
		this.m.Name = "Ledger of the Dead";
		this.m.Description = "A ledger stuffed full of folktales, post-mortems, autopsy notes, and the mad scribblings of a supposed necromancer that collectively contain your knowledge of the undead.";
		this.m.Icon = "misc/inventory_anatomists_book_02.png";
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
			text = "Tracks your findings on the undead"
		});
		local buffAcquisitions = [
			{
				flag = "isSkeletonWarriorPotionDiscovered",
				creatureName = "Ancient Skeleton",
				potionName = "Potion of the Sleepless"
			},
			{
				flag = "isHonorGuardPotionDiscovered",
				creatureName = "Ancient Honor Guard",
				potionName = "Elixir of Boneflesh"
			},
			{
				flag = "isAncientPriestPotionDiscovered",
				creatureName = "Ancient Priest",
				potionName = "Dastard\'s Valor"
			},
			{
				flag = "isNecrosavantPotionDiscovered",
				creatureName = "Necrosavant",
				potionName = "Potion of the Nightstalker"
			},
			{
				flag = "isWiedergangerPotionDiscovered",
				creatureName = "Wiederganger",
				potionName = "Potion of Leather Skin"
			},
			{
				flag = "isFallenHeroPotionDiscovered",
				creatureName = "Fallen Hero",
				potionName = "Elixir of Perseverance"
			},
			{
				flag = "isGeistPotionDiscovered",
				creatureName = "Geist",
				potionName = "Deadman\'s Drink"
			},
			{
				flag = "isNecromancerPotionDiscovered",
				creatureName = "Necromancer",
				potionName = "The King in Chains"
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


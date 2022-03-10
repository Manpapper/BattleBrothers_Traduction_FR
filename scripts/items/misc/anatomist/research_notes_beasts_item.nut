this.research_notes_beasts_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.research_notes_beasts";
		this.m.Name = "Tome of Beasts";
		this.m.Description = "A treatise on the beasts of the world. Coded notes fill the margins in sections on the most interesting - and real - creatures.";
		this.m.Icon = "misc/inventory_anatomists_book_03.png";
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
			text = "Tracks your research on the beasts of the world"
		});
		local buffAcquisitions = [
			{
				flag = "isDirewolfPotionDiscovered",
				creatureName = "Direwolf",
				potionName = "Potion of Blade Dancing"
			},
			{
				flag = "isNachzehrerPotionDiscovered",
				creatureName = "Nachzehrer",
				potionName = "Potion of Flesh Knitting"
			},
			{
				flag = "isLindwurmPotionDiscovered",
				creatureName = "Lindwurm",
				potionName = "Tincture of Emberblood"
			},
			{
				flag = "isHyenaPotionDiscovered",
				creatureName = "Hyena",
				potionName = "Bloodgate Brew"
			},
			{
				flag = "isSerpentPotionDiscovered",
				creatureName = "Serpent",
				potionName = "Quickfang Potion"
			},
			{
				flag = "isIfritPotionDiscovered",
				creatureName = "Ifrit",
				potionName = "Potion of Stoneskin"
			},
			{
				flag = "isAlpPotionDiscovered",
				creatureName = "Alp",
				potionName = "Nightking\'s Draft"
			},
			{
				flag = "isHexePotionDiscovered",
				creatureName = "Hexe",
				potionName = "Potion of Malevolence"
			},
			{
				flag = "isSchratPotionDiscovered",
				creatureName = "Schrat",
				potionName = "Draught of Godtree Roots"
			},
			{
				flag = "isUnholdPotionDiscovered",
				creatureName = "Unhold",
				potionName = "Fool\'s Treasure Potion"
			},
			{
				flag = "isWebknechtPotionDiscovered",
				creatureName = "Webknecht",
				potionName = "Venomblood Potion"
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


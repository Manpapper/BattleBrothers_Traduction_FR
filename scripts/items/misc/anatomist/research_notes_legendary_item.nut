this.research_notes_legendary_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.research_notes_legendary";
		this.m.Name = "Book of Legends";
		this.m.Description = "A slim journal bound in fine leather, containing your meager scientific notes on creatures of myth and legend.";
		this.m.Icon = "misc/inventory_anatomists_book_04.png";
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
			text = "Tracks your research into mythical creatures, should you discover any"
		});
		local buffAcquisitions = [
			{
				flag = "isKrakenPotionDiscovered",
				creatureName = "Kraken",
				potionName = "Bog King\'s Draught"
			},
			{
				flag = "isRachegeistPotionDiscovered",
				creatureName = "Rachegeist",
				potionName = "Knife Edge Potion"
			},
			{
				flag = "isIjirokPotionDiscovered",
				creatureName = "Ijirok",
				potionName = "Elixir of the Mad God"
			},
			{
				flag = "isLorekeeperPotionDiscovered",
				creatureName = "Lorekeeper",
				potionName = "Potion of Inner Phylactery"
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


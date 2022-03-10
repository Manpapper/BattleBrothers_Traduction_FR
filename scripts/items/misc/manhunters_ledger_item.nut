this.manhunters_ledger_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.manhunters_ledger";
		this.m.Name = "Company Ledger";
		this.m.Description = "A ledger detailing the members and contract terms of the company.";
		this.m.Icon = "misc/inventory_ledger_item.png";
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

		local indebted = this.World.Statistics.getFlags().getAsInt("ManhunterIndebted");
		local nonIndebted = this.World.Statistics.getFlags().getAsInt("ManhunterNonIndebted");
		result.push({
			id = 65,
			type = "text",
			text = indebted + " Indebted in the company"
		});
		result.push({
			id = 65,
			type = "text",
			text = nonIndebted + " Manhunters in the company"
		});
		result.push({
			id = 65,
			type = "text",
			icon = "ui/icons/xp_received.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Experience Gain for Indebted"
		});
		result.push({
			id = 65,
			type = "text",
			icon = "ui/icons/xp_received.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Experience Gain for Manhunters"
		});

		if (indebted <= nonIndebted)
		{
			result.push({
				id = 65,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "There are too few Indebted in the company! The Manhunters will become dissatisfied if this continues!"
			});
		}

		return result;
	}

});


this.golden_goose_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.golden_goose";
		this.m.Name = "L\'Oie d\'Or";
		this.m.Description = "Une petite statue d\'oie en or massif. Un petit oeuf d\'or émerge mystérieusement de la statue une fois par jour.";
		this.m.Icon = "loot/golden_goose.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Legendary;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = false;
		this.m.Value = 3000;
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
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Génère [color=" + this.Const.UI.Color.PositiveValue + "]15[/color] couronnes d\'or par jour."
		});
		return result;
	}

	function getBuyPrice()
	{
		if (this.m.IsSold)
		{
			return this.getSellPrice();
		}

		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			return this.Math.max(this.getSellPrice(), this.Math.ceil(this.getValue() * 1.5 * this.World.State.getCurrentTown().getBuyPriceMult()));
		}
		else
		{
			return this.Math.ceil(this.getValue());
		}
	}

	function getSellPrice()
	{
		if (this.m.IsBought)
		{
			return this.getBuyPrice();
		}

		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			return this.Math.floor(this.getValue() * this.Const.World.Assets.BaseLootSellPrice * this.World.State.getCurrentTown().getSellPriceMult() * this.Const.Difficulty.SellPriceMult[this.World.Assets.getEconomicDifficulty()]);
		}
		else
		{
			return this.Math.floor(this.getValue());
		}
	}

	function onAddedToStash( _stashID )
	{
		if (_stashID == "player")
		{
			this.World.Flags.set("IsGoldenGoose", true);
		}
	}

	function onRemovedFromStash( _stashID )
	{
		if (_stashID == "player")
		{
			this.World.Flags.set("IsGoldenGoose", false);
		}
	}

});


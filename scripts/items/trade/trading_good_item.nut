this.trading_good_item <- this.inherit("scripts/items/item", {
	m = {
		BoughtAtPrice = 0,
		ProducingBuildings = [],
		Culture = 0
	},
	function create()
	{
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.TradeGood | this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = true;
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
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.m.BoughtAtPrice > 0)
		{
			result.push({
				id = 7,
				type = "text",
				text = "Bought for [img]gfx/ui/tooltips/money.png[/img]" + this.m.BoughtAtPrice
			});
		}

		return result;
	}

	function onAddedToStash( _stashID )
	{
		if (_stashID == "player" && this.m.BoughtAtPrice == 0)
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
			{
				this.m.BoughtAtPrice = this.getBuyPrice();
			}
		}
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function getBuyPrice()
	{
		if (this.m.IsSold)
		{
			return this.getSellPrice();
		}

		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			local isLocalCulture = this.m.Culture == this.Const.World.Culture.Neutral || this.World.State.getCurrentTown().getCulture() == this.m.Culture || this.World.State.getCurrentTown().hasBuilding("building.port");
			local isBuildingPresent = false;

			foreach( b in this.m.ProducingBuildings )
			{
				if (this.World.State.getCurrentTown().hasAttachedLocation(b))
				{
					isBuildingPresent = true;
					break;
				}
			}

			return this.Math.max(this.getSellPrice(), this.Math.ceil(this.getValue() * this.getBuyPriceMult() * this.World.Assets.m.BuyPriceTradeMult * this.getPriceMult() * this.World.State.getCurrentTown().getBuyPriceMult() * (isBuildingPresent ? this.Const.World.Assets.BaseBuyPrice : this.Const.World.Assets.BuyPriceNotProducedHere) * (isLocalCulture ? 1.0 : this.Const.World.Assets.BuyPriceNotLocalCulture)));
		}

		return this.item.getBuyPrice();
	}

	function getSellPrice()
	{
		if (this.m.IsBought)
		{
			return this.getBuyPrice();
		}

		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			local isLocalCulture = this.m.Culture == this.Const.World.Culture.Neutral || this.World.State.getCurrentTown().getCulture() == this.m.Culture || this.World.State.getCurrentTown().hasBuilding("building.port");
			local isBuildingPresent = false;

			foreach( b in this.m.ProducingBuildings )
			{
				if (this.World.State.getCurrentTown().hasAttachedLocation(b))
				{
					isBuildingPresent = true;
					break;
				}
			}

			return this.Math.floor(this.getValue() * this.getSellPriceMult() * this.World.Assets.m.SellPriceTradeMult * this.World.State.getCurrentTown().getSellPriceMult() * (isBuildingPresent ? this.Const.World.Assets.BaseSellPrice : this.Const.World.Assets.SellPriceNotProducedHere) * (isLocalCulture ? 1.0 : this.Const.World.Assets.SellPriceNotLocalCulture));
		}

		return this.item.getSellPrice();
	}

	function getSellPriceMult()
	{
		return 1.0;
	}

	function getBuyPriceMult()
	{
		return 1.0;
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeU16(this.m.BoughtAtPrice);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.BoughtAtPrice = _in.readU16();
	}

});


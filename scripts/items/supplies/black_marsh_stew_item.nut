this.black_marsh_stew_item <- this.inherit("scripts/items/supplies/food_item", {
	m = {},
	function create()
	{
		this.food_item.create();
		this.m.ID = "supplies.black_marsh_stew";
		this.m.Name = "Black Marsh Stew";
		this.m.Description = "Provisions. Black as the marshes it hails from, this ghastly stew is far from delicious but takes ages to spoil. Possibly because it already is spoiled to begin with.";
		this.m.Icon = "supplies/inventory_provisions_17.png";
		this.m.Value = 85;
		this.m.GoodForDays = 12;
	}

	function getBuyPrice()
	{
		if (this.m.IsSold)
		{
			return this.getSellPrice();
		}

		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			local isBuildingPresent = false;
			return this.Math.max(this.getSellPrice(), this.Math.ceil(this.getValue() * this.getPriceMult() * this.World.State.getCurrentTown().getFoodPriceMult() * this.World.State.getCurrentTown().getBuyPriceMult() * (isBuildingPresent ? this.Const.World.Assets.BaseBuyPrice : this.Const.World.Assets.BuyPriceNotProducedHere)));
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
			local isBuildingPresent = false;
			return this.Math.floor(this.getValue() * this.World.State.getCurrentTown().getFoodPriceMult() * this.World.State.getCurrentTown().getSellPriceMult() * (isBuildingPresent ? this.Const.World.Assets.BaseSellPrice : this.Const.World.Assets.SellPriceNotProducedHere));
		}

		return this.item.getSellPrice();
	}

});


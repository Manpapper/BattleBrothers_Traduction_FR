this.food_item <- this.inherit("scripts/items/item", {
	m = {
		Amount = 0.0,
		GoodForDays = 0,
		BestBefore = 0.0,
		BoughtAtPrice = 0,
		IsUndesirable = false
	},
	function isDesirable()
	{
		return !this.m.IsUndesirable;
	}

	function isAmountShown()
	{
		return true;
	}

	function getAmountString()
	{
		return this.Math.floor(this.m.Amount);
	}

	function getAmountColor()
	{
		return this.Const.Items.ConditionColor[this.Math.min(this.getSpoilInDays() - 1, this.Const.Items.ConditionColor.len() - 1)];
	}

	function getAmount()
	{
		return this.m.Amount;
	}

	function setAmount( _a )
	{
		this.m.Amount = _a;
	}

	function getRawValue()
	{
		return this.m.Value;
	}

	function getValue()
	{
		return this.Math.floor(this.m.Amount / 25.0 * this.Math.minf(1.0, this.getSpoilInDays() / (this.m.GoodForDays * 1.0)) * this.m.Value);
	}

	function getBestBeforeTime()
	{
		return this.m.BestBefore + (("State" in this.World) && this.World.State != null ? this.World.Assets.m.FoodAdditionalDays * this.World.getTime().SecondsPerDay : 0);
	}

	function randomizeAmount()
	{
		this.m.Amount = this.Math.rand(1, 25);
	}

	function randomizeBestBefore()
	{
		if (("State" in this.World) && this.World.State != null && this.World.State.getCombatStartTime() != 0)
		{
			this.m.BestBefore = this.World.State.getCombatStartTime() + this.Math.rand(1, this.m.GoodForDays) * this.World.getTime().SecondsPerDay;
		}
		else
		{
			this.m.BestBefore = this.Time.getVirtualTimeF() + this.Math.rand(1, this.m.GoodForDays) * this.World.getTime().SecondsPerDay;
		}
	}

	function getSpoilInDays()
	{
		if (this.m.BestBefore != 0)
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCombatStartTime() != 0)
			{
				return this.Math.max(1, (this.getBestBeforeTime() - this.World.State.getCombatStartTime()) / this.World.getTime().SecondsPerDay);
			}
			else
			{
				return this.Math.max(1, (this.getBestBeforeTime() - this.Time.getVirtualTimeF()) / this.World.getTime().SecondsPerDay);
			}
		}
		else
		{
			return this.m.GoodForDays;
		}
	}

	function create()
	{
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Food;
		this.m.Amount = 25.0;
		this.m.IsDroppedAsLoot = true;
		this.m.IsChangeableInBattle = false;
		this.m.IsAllowedInBag = false;
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

		result.push({
			id = 67,
			type = "text",
			text = "Will spoil in [color=" + this.Const.UI.Color.NegativeValue + "]" + this.getSpoilInDays() + "[/color] days."
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function onAddedToStash( _stashID )
	{
		if (_stashID == "player" && this.m.BestBefore == 0)
		{
			local time;

			if (("State" in this.World) && this.World.State != null && this.World.State.getCombatStartTime() != 0)
			{
				time = this.World.State.getCombatStartTime();
			}
			else
			{
				time = this.Time.getVirtualTimeF();
			}

			this.m.BestBefore = time + this.m.GoodForDays * this.World.getTime().SecondsPerDay;
			this.World.Assets.updateFood();
		}

		if (_stashID == "player" && this.m.BoughtAtPrice == 0)
		{
			if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
			{
				this.m.BoughtAtPrice = this.getBuyPrice();
			}
		}
	}

	function onRemovedFromStash( _stashID )
	{
		if (_stashID == "player")
		{
			this.World.Assets.updateFood();
		}
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeF32(this.m.Amount);
		_out.writeF32(this.m.BestBefore);
		_out.writeU16(this.m.BoughtAtPrice);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.Amount = _in.readF32();
		this.m.BestBefore = _in.readF32();
		this.m.BoughtAtPrice = _in.readU16();
	}

});


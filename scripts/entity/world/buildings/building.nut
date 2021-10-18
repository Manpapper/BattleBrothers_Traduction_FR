this.building <- {
	m = {
		ID = "",
		Name = "",
		Description = "",
		UIImage = null,
		UIImageNight = null,
		Tooltip = null,
		TooltipIcon = "",
		Sounds = [],
		SoundsAtNight = [],
		Settlement = null,
		IsClosedAtNight = true,
		IsRepairOffered = false
	},
	function getID()
	{
		return this.m.ID;
	}

	function getName()
	{
		return this.m.Name;
	}

	function getDescription()
	{
		return this.m.Description;
	}

	function getUIImage()
	{
		return this.World.getTime().IsDaytime ? this.m.UIImage : this.m.UIImageNight;
	}

	function getTooltip()
	{
		return this.World.getTime().IsDaytime || !this.m.IsClosedAtNight ? this.m.Tooltip : null;
	}

	function getTooltipIcon()
	{
		return this.m.TooltipIcon;
	}

	function getSounds()
	{
		return this.World.getTime().IsDaytime ? this.m.Sounds : this.m.SoundsAtNight;
	}

	function getStash()
	{
		return null;
	}

	function getSettlement()
	{
		return this.m.Settlement;
	}

	function setSettlement( _s )
	{
		this.m.Settlement = this.WeakTableRef(_s);
	}

	function isHidden()
	{
		return false;
	}

	function isClosedAtNight()
	{
		return this.m.IsClosedAtNight;
	}

	function isRepairOffered()
	{
		return this.m.IsRepairOffered;
	}

	function create()
	{
	}

	function pushUIMenuStack()
	{
		this.World.State.getMenuStack().push(function ()
		{
			this.World.State.getTownScreen().showMainDialog();
		}, function ()
		{
			return !this.World.State.getTownScreen().isAnimating();
		});
	}

	function fillStash( _list, _stash, _priceMult, _allowDamagedEquipment = false )
	{
		_stash.clear();
		local rarityMult = this.getSettlement().getModifiers().RarityMult;
		local foodRarityMult = this.getSettlement().getModifiers().FoodRarityMult;
		local medicineRarityMult = this.getSettlement().getModifiers().MedicalPriceMult;
		local mineralRarityMult = this.getSettlement().getModifiers().MineralRarityMult;
		local buildingRarityMult = this.getSettlement().getModifiers().BuildingRarityMult;
		local isTrader = this.World.Retinue.hasFollower("follower.trader");

		foreach( i in _list )
		{
			local r = i.R;

			for( local num = 0; true;  )
			{
				local p = this.Math.rand(0, 100) * rarityMult;
				local item;

				if (p >= r)
				{
					item = this.new("scripts/items/" + i.S);
					local isFood = item.isItemType(this.Const.Items.ItemType.Food);
					local isMedicine = item.getID() == "supplies.medicine";
					local isMineral = item.getID() == "misc.uncut_gems" || item.getID() == "misc.copper_ingots";
					local isBuilding = item.getID() == "misc.quality_wood" || item.getID() == "misc.copper_ingots";

					if (!isFood || p * foodRarityMult >= r)
					{
						if (!isMedicine || p * medicineRarityMult >= r)
						{
							if (!isMineral || p * mineralRarityMult >= r)
							{
								if (!isBuilding || p * buildingRarityMult >= r)
								{
									_stash.add(item);
								}
							}
						}
					}

					if (r != 0 || rarityMult < 1.0 || isFood && foodRarityMult < 1.0 || isMedicine && medicineRarityMult < 1.0 || isMineral && mineralRarityMult < 1.0 || isBuilding && buildingRarityMult < 1.0)
					{
						r = r + p;
					}

					if (_allowDamagedEquipment && item.getConditionMax() > 1)
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							item.setCondition(this.Math.rand(item.getConditionMax() * 0.4, item.getConditionMax()) * 1.0);
						}
					}

					item.setPriceMult(i.P * _priceMult);
				}
				else
				{
					break;
				}

				num = ++num;

				if (num >= 3 || !isTrader && num >= 2 && item.isItemType(this.Const.Items.ItemType.TradeGood))
				{
					break;
				}
			}
		}

		_stash.sort();
	}

	function onClicked()
	{
	}

	function onSettlementEntered()
	{
	}

	function onUpdateShopList()
	{
	}

	function onUpdateDraftList( _list )
	{
	}

	function onSerialize( _out )
	{
	}

	function onDeserialize( _in )
	{
	}

};


this.item_container <- {
	m = {
		Actor = null,
		Items = [],
		UnlockedBagSlots = 2,
		ActionCost = this.Const.Tactical.Settings.SwitchItemAPCost,
		ActionCost2H = this.Const.Tactical.Settings.SwitchItemAPCost,
		Appearance = {
			ShowQuiver = false,
			HideHead = false,
			HideCorpseHead = false,
			HideBody = false,
			HideHair = false,
			HideBeard = false,
			RaiseShield = false,
			LowerWeapon = false,
			TwoHanded = false,
			Quiver = "",
			Body = "",
			Armor = "",
			ArmorColor = this.createColor("#ffffff"),
			ArmorUpgradeFront = "",
			ArmorUpgradeBack = "",
			Accessory = "",
			Corpse = "",
			CorpseArmor = "",
			CorpseArmorUpgrade = "",
			CorpseArmorUpgradeFront = "",
			CorpseArmorUpgradeBack = "",
			Helmet = "",
			HelmetColor = this.createColor("#ffffff"),
			HelmetDamage = "",
			HelmetCorpse = "",
			Shield = "",
			Weapon = "",
			ImpactSound = []
		},
		IsUpdating = false
	},
	function setActor( _a )
	{
		this.m.Actor = this.WeakTableRef(_a);
	}

	function getActor()
	{
		return this.m.Actor;
	}

	function getAppearance()
	{
		return this.m.Appearance;
	}

	function getUnlockedBagSlots()
	{
		return this.m.UnlockedBagSlots;
	}

	function setUnlockedBagSlots( _n )
	{
		this.m.UnlockedBagSlots = _n;
	}

	function setActionCost( _v )
	{
		this.m.ActionCost = _v;
	}

	function create()
	{
		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			local empty_slot = [];

			for( local j = 0; j < this.Const.ItemSlotSpaces[i]; j = ++j )
			{
				empty_slot.push(null);
			}

			this.m.Items.push(empty_slot);
		}

		for( local i = 0; i < this.Const.BodyPart.COUNT; i = ++i )
		{
			this.m.Appearance.ImpactSound.push([]);
		}
	}

	function updateAppearance()
	{
		if (this.m.Actor != null && !this.m.Actor.isNull())
		{
			this.m.Actor.onAppearanceChanged(this.m.Appearance);
		}
	}

	function isActionAffordable( _items )
	{
		local twoHanded = false;

		foreach( i in _items )
		{
			if (i != null && i.isItemType(this.Const.Items.ItemType.Shield))
			{
				twoHanded = true;
				break;
			}
		}

		return this.m.Actor.getActionPoints() >= (twoHanded ? this.m.ActionCost2H : this.m.ActionCost);
	}

	function getActionCost( _items )
	{
		local twoHanded = false;

		foreach( i in _items )
		{
			if (i != null && i.isItemType(this.Const.Items.ItemType.Shield))
			{
				twoHanded = true;
				break;
			}
		}

		return twoHanded ? this.m.ActionCost2H : this.m.ActionCost;
	}

	function payForAction( _items )
	{
		local twoHanded = false;

		foreach( i in _items )
		{
			if (i != null && i.isItemType(this.Const.Items.ItemType.Shield))
			{
				twoHanded = true;
				break;
			}
		}

		this.m.Actor.setActionPoints(this.Math.max(0, this.m.Actor.getActionPoints() - (twoHanded ? this.m.ActionCost2H : this.m.ActionCost)));

		if (!twoHanded)
		{
			this.m.ActionCost = this.Const.Tactical.Settings.SwitchItemAPCost;
		}

		this.m.Actor.getSkills().update();
	}

	function getItemAtSlot( _slotType )
	{
		if (_slotType == null || _slotType == this.Const.ItemSlot.None)
		{
			return null;
		}

		for( local i = 0; i < this.m.Items[_slotType].len(); i = ++i )
		{
			if (this.m.Items[_slotType][i] != null && this.m.Items[_slotType][i] != -1)
			{
				return this.m.Items[_slotType][i];
			}
		}

		return null;
	}

	function getItemAtBagSlot( _slot )
	{
		return this.m.Items[this.Const.ItemSlot.Bag][_slot];
	}

	function getAllItemsAtSlot( _slotType )
	{
		local ret = [];

		for( local i = 0; i < this.m.Items[_slotType].len(); i = ++i )
		{
			if (this.m.Items[_slotType][i] != null && this.m.Items[_slotType][i] != -1)
			{
				ret.push(this.m.Items[_slotType][i]);
			}
		}

		return ret;
	}

	function getAllItems()
	{
		local ret = [];

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.Const.ItemSlotSpaces[i]; j = ++j )
			{
				if (this.m.Items[i][j] != null && this.m.Items[i][j] != -1)
				{
					ret.push(this.m.Items[i][j]);
				}
			}
		}

		return ret;
	}

	function getData()
	{
		return this.m.Items;
	}

	function hasItemWithType( _type )
	{
		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.Const.ItemSlotSpaces[i]; j = ++j )
			{
				if (this.m.Items[i][j] != null && this.m.Items[i][j] != -1)
				{
					if (this.m.Items[i][j].isItemType(_type))
					{
						return true;
					}
				}
			}
		}

		return false;
	}

	function hasDefensiveItem()
	{
		local items = this.getAllItems();

		foreach( item in items )
		{
			if (item.isItemType(this.Const.Items.ItemType.Defensive))
			{
				if (item.isItemType(this.Const.Items.ItemType.Weapon))
				{
					if (item.getAmmoMax() == 0 || item.getAmmo() > 0)
					{
						return true;
					}
					else
					{
						foreach( ammo in items )
						{
							if (ammo.getID() == item.getAmmoID() && ammo.getAmmo() > 0)
							{
								return true;
							}
						}
					}
				}
				else
				{
					return true;
				}
			}
		}

		return false;
	}

	function getNumberOfEmptySlots( _slotType )
	{
		local n = 0;

		for( local i = 0; i < this.m.Items[_slotType].len(); i = ++i )
		{
			if (this.m.Items[_slotType][i] == null)
			{
				n = ++n;
			}
		}

		return n;
	}

	function hasEmptySlot( _slotType )
	{
		for( local i = 0; i < this.m.Items[_slotType].len(); i = ++i )
		{
			if (this.m.Items[_slotType][i] == null && (_slotType != this.Const.ItemSlot.Bag || i < this.m.UnlockedBagSlots))
			{
				return true;
			}
		}

		return false;
	}

	function hasBlockedSlot( _slotType )
	{
		for( local i = 0; i < this.m.Items[_slotType].len(); i = ++i )
		{
			if (this.m.Items[_slotType][i] == -1)
			{
				return true;
			}
		}

		return false;
	}

	function getItemByInstanceID( _instanceID )
	{
		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.Const.ItemSlotSpaces[i]; j = ++j )
			{
				if (this.m.Items[i][j] != null && this.m.Items[i][j] != -1 && this.m.Items[i][j].getInstanceID() == _instanceID)
				{
					return this.m.Items[i][j];
				}
			}
		}

		return null;
	}

	function addToBag( _item, _slot = -1 )
	{
		if (_item.getCurrentSlotType() != this.Const.ItemSlot.None)
		{
			this.logWarning("Attempted to add item " + _item.getName() + " to bag, but is already placed somewhere else");
			return false;
		}

		if (!_item.isAllowedInBag())
		{
			return false;
		}

		local vacancy = -1;

		if (_slot != -1)
		{
			if (_slot >= this.m.UnlockedBagSlots || this.m.Items[this.Const.ItemSlot.Bag][_slot] != null)
			{
				this.logWarning("Attempted to add item " + _item.getName() + " to bag slot which isn\'t empty or is locked");
				return false;
			}

			vacancy = _slot;
		}
		else
		{
			for( local i = 0; i < this.Math.min(this.m.Items[this.Const.ItemSlot.Bag].len(), this.m.UnlockedBagSlots); i = ++i )
			{
				if (this.m.Items[this.Const.ItemSlot.Bag][i] == null)
				{
					vacancy = i;
					break;
				}
			}
		}

		if (vacancy != -1)
		{
			this.m.Items[this.Const.ItemSlot.Bag][vacancy] = _item;
			_item.setContainer(this);
			_item.setCurrentSlotType(this.Const.ItemSlot.Bag);
			_item.onPutIntoBag();

			if (this.m.Actor.isPlayerControlled())
			{
				this.m.Actor.getSkills().update();
			}

			return true;
		}
		else
		{
			this.logWarning("Could not add " + _item.getName() + " to bag because no empty slot was found");
			return false;
		}
	}

	function removeFromBag( _item )
	{
		if (_item.getCurrentSlotType() != this.Const.ItemSlot.Bag)
		{
			this.logWarning("Attempted to remove item " + _item.getName() + " from bag, but is placed somewhere else");
			return false;
		}

		for( local i = 0; i < this.m.Items[this.Const.ItemSlot.Bag].len(); i = ++i )
		{
			if (this.m.Items[this.Const.ItemSlot.Bag][i] == _item)
			{
				_item.onRemovedFromBag();
				_item.setContainer(null);
				this.m.Items[this.Const.ItemSlot.Bag][i] = null;
				_item.setCurrentSlotType(this.Const.ItemSlot.None);

				if (this.m.Actor != null && !this.m.Actor.isNull() && this.m.Actor.isPlayerControlled())
				{
					this.m.Actor.getSkills().update();
				}

				return true;
			}
		}

		return false;
	}

	function removeFromBagSlot( _slot )
	{
		local item = this.m.Items[this.Const.ItemSlot.Bag][_slot];

		if (item == null)
		{
			this.logWarning("Attempted to remove item from empty bag slot");
			return false;
		}

		item.onRemovedFromBag();
		item.setContainer(null);
		this.m.Items[this.Const.ItemSlot.Bag][_slot] = null;
		item.setCurrentSlotType(this.Const.ItemSlot.None);

		if (this.m.Actor.isPlayerControlled())
		{
			this.m.Actor.getSkills().update();
		}

		return true;
	}

	function equip( _item )
	{
		if (_item.getSlotType() == this.Const.ItemSlot.None)
		{
			return false;
		}

		if (_item.getCurrentSlotType() != this.Const.ItemSlot.None)
		{
			this.logWarning("Attempted to equip item " + _item.getName() + ", but it is already placed somewhere else");
			return false;
		}

		local vacancy = -1;

		for( local i = 0; i < this.m.Items[_item.getSlotType()].len(); i = ++i )
		{
			if (this.m.Items[_item.getSlotType()][i] == null)
			{
				vacancy = i;
				break;
			}
		}

		local blocked = -1;

		if (_item.getBlockedSlotType() != null)
		{
			for( local i = 0; i < this.m.Items[_item.getBlockedSlotType()].len(); i = ++i )
			{
				if (this.m.Items[_item.getBlockedSlotType()][i] == null)
				{
					blocked = i;
					break;
				}
			}
		}

		if (vacancy != -1 && (_item.getBlockedSlotType() == null || blocked != -1))
		{
			if (_item.getContainer() != null)
			{
				_item.getContainer().unequip(_item);
			}

			this.m.Items[_item.getSlotType()][vacancy] = _item;

			if (_item.getBlockedSlotType() != null)
			{
				this.m.Items[_item.getBlockedSlotType()][blocked] = -1;
			}

			_item.setContainer(this);
			_item.setCurrentSlotType(_item.getSlotType());

			if (_item.getSlotType() == this.Const.ItemSlot.Bag)
			{
				_item.onPutIntoBag();
			}
			else
			{
				_item.onEquip();
			}

			this.m.Actor.getSkills().update();
			return true;
		}
		else
		{
			return false;
		}
	}

	function unequip( _item )
	{
		if (_item == null || _item == -1)
		{
			return;
		}

		if (_item.getCurrentSlotType() == this.Const.ItemSlot.None || _item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
		{
			this.logWarning("Attempted to unequip item " + _item.getName() + ", but is not equipped");
			return false;
		}

		for( local i = 0; i < this.m.Items[_item.getSlotType()].len(); i = ++i )
		{
			if (this.m.Items[_item.getSlotType()][i] == _item)
			{
				_item.onUnequip();
				_item.setContainer(null);
				_item.setCurrentSlotType(this.Const.ItemSlot.None);
				this.m.Items[_item.getSlotType()][i] = null;

				if (_item.getBlockedSlotType() != null)
				{
					for( local i = 0; i < this.m.Items[_item.getBlockedSlotType()].len(); i = ++i )
					{
						if (this.m.Items[_item.getBlockedSlotType()][i] == -1)
						{
							this.m.Items[_item.getBlockedSlotType()][i] = null;
							break;
						}
					}
				}

				if (this.m.Actor != null && !this.m.Actor.isNull() && this.m.Actor.isAlive())
				{
					this.m.Actor.getSkills().update();
				}

				return true;
			}
		}

		return false;
	}

	function swap( _itemA, _itemB )
	{
		if (_itemA.getSlotType() != _itemB.getSlotType())
		{
			this.logWarning("Unable to swap, items don\'t use the same slot!");
			return false;
		}

		if (_itemA.isEquipped())
		{
			this.unequip(_itemA);

			if (_itemB.isInBag())
			{
				this.removeFromBag(_itemB);
				this.addToBag(_itemA);
			}

			this.equip(_itemB);
		}
		else if (_itemB.isEquipped())
		{
			this.unequip(_itemB);

			if (_itemA.isInBag())
			{
				this.removeFromBag(_itemA);
				this.addToBag(_itemB);
			}

			this.equip(_itemA);
		}
		else
		{
			this.logWarning("Neither item is equipped, unable to swap!");
			return false;
		}

		return true;
	}

	function dropAll( _tile, _killer, _flip = false )
	{
		local IsDroppingLoot = true;
		local isPlayer = this.m.Actor.getFaction() == this.Const.Faction.Player || this.isKindOf(this.m.Actor.get(), "player");
		local emergency = false;

		if (_killer != null && !_killer.isPlayerControlled() && !this.m.Actor.isPlayerControlled() && _killer.getID() != this.m.Actor.getID() && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
		{
			IsDroppingLoot = false;
		}

		if (!this.m.Actor.isPlayerControlled() && this.m.Actor.isAlliedWithPlayer())
		{
			IsDroppingLoot = false;
		}

		if (_killer != null && _killer.isPlayerControlled() && !isPlayer && _killer.isAlliedWith(this.m.Actor))
		{
			IsDroppingLoot = false;
		}

		if (_tile == null)
		{
			if (this.m.Actor.isPlacedOnMap())
			{
				_tile = this.m.Actor.getTile();
				emergency = true;
			}
			else
			{
				return;
			}
		}

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.m.Items[i].len(); j = ++j )
			{
				if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
				{
				}
				else if (this.m.Items[i][j].isChangeableInBattle() || emergency)
				{
					if (IsDroppingLoot || this.m.Items[i][j].isItemType(this.Const.Items.ItemType.Legendary))
					{
						this.m.Items[i][j].drop(_tile);
					}
					else
					{
						this.m.Items[i][j].m.IsDroppedAsLoot = false;
					}
				}
				else if (!IsDroppingLoot && !this.m.Items[i][j].isItemType(this.Const.Items.ItemType.Legendary))
				{
					this.m.Items[i][j].m.IsDroppedAsLoot = false;
				}
			}
		}

		_tile.IsContainingItemsFlipped = _flip;
	}

	function transferToStash( _stash )
	{
		local toTransfer = [];

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.m.Items[i].len(); j = ++j )
			{
				if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
				{
				}
				else
				{
					local item = this.m.Items[i][j];

					if (item.isEquipped())
					{
						this.unequip(item);
					}
					else
					{
						this.removeFromBag(item);
					}

					toTransfer.push(item);
				}
			}
		}

		foreach( item in toTransfer )
		{
			if (_stash.add(item) == null)
			{
				break;
			}
		}
	}

	function transferTo( _other )
	{
		local toTransfer = [];

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.m.Items[i].len(); j = ++j )
			{
				if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
				{
				}
				else
				{
					toTransfer.push(this.m.Items[i][j]);
				}
			}
		}

		foreach( item in toTransfer )
		{
			if (item.isInBag())
			{
				this.removeFromBag(item);
				_other.addToBag(item);
			}
			else
			{
				this.unequip(item);
				_other.equip(item);
			}
		}
	}

	function clear()
	{
		local toClear = [];

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.m.Items[i].len(); j = ++j )
			{
				if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
				{
				}
				else
				{
					toClear.push(this.m.Items[i][j]);
				}
			}
		}

		foreach( item in toClear )
		{
			if (item.isInBag())
			{
				this.removeFromBag(item);
			}
			else
			{
				this.unequip(item);
			}
		}
	}

	function collectGarbage()
	{
		if (this.m.IsUpdating)
		{
			return;
		}

		this.m.IsUpdating = true;

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.m.Items[i].len(); j = ++j )
			{
				if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
				{
				}
				else if (this.m.Items[i][j].isGarbage())
				{
					if (this.m.Items[i][j].isEquipped())
					{
						this.unequip(this.m.Items[i][j]);
					}
					else
					{
						this.removeFromBag(this.m.Items[i][j]);
					}
				}
			}
		}

		this.m.IsUpdating = false;
	}

	function print()
	{
		this.logInfo("##############################################");
		this.logInfo("# Showing inventory of " + this.getActor().getName());

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			local out = "# " + this.Const.Strings.ItemSlotName[i] + ": ";

			for( local j = 0; j < this.m.Items[i].len(); j = ++j )
			{
				if (j != 0)
				{
					out = out + ", ";
				}

				if (this.m.Items[i][j] == null)
				{
					out = out + "-";
				}
				else if (this.m.Items[i][j] == -1)
				{
					out = out + "X";
				}
				else
				{
					out = out + this.m.Items[i][j].getName();

					if (this.m.Items[i][j].getArmorMax() != 0)
					{
						out = out + (" (" + this.m.Items[i][j].getArmor() + "/" + this.m.Items[i][j].getArmorMax() + ")");
					}
				}
			}

			this.logInfo(out);
		}

		this.logInfo("##############################################");
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		this.m.IsUpdating = true;

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.m.Items[i].len(); j = ++j )
			{
				if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
				{
				}
				else
				{
					this.m.Items[i][j].onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties);

					if (this.m.Items[i][j].isGarbage())
					{
						if (this.m.Items[i][j].isEquipped())
						{
							this.unequip(this.m.Items[i][j]);
						}
						else
						{
							this.removeFromBag(this.m.Items[i][j]);
						}
					}
				}
			}
		}

		this.m.IsUpdating = false;
	}

	function onDamageReceived( _damage, _fatalityType, _slotType, _attacker )
	{
		this.m.IsUpdating = true;

		for( local i = 0; i < this.m.Items[_slotType].len(); i = ++i )
		{
			if (this.m.Items[_slotType][i] != null && this.m.Items[_slotType][i] != -1)
			{
				this.m.Items[_slotType][i].onDamageReceived(_damage, _fatalityType, _attacker);

				if (this.m.Items[_slotType][i].isGarbage())
				{
					if (this.m.Items[_slotType][i].isEquipped())
					{
						this.unequip(this.m.Items[_slotType][i]);
					}
					else
					{
						this.removeFromBag(this.m.Items[_slotType][i]);
					}
				}
			}
		}

		this.m.IsUpdating = false;
	}

	function onDamageDealt( _target, _skill, _hitInfo )
	{
		this.m.IsUpdating = true;

		for( local i = 0; i < this.m.Items[this.Const.ItemSlot.Mainhand].len(); i = ++i )
		{
			if (this.m.Items[this.Const.ItemSlot.Mainhand][i] != null && this.m.Items[this.Const.ItemSlot.Mainhand][i] != -1)
			{
				this.m.Items[this.Const.ItemSlot.Mainhand][i].onDamageDealt(_target, _skill, _hitInfo);

				if (this.m.Items[this.Const.ItemSlot.Mainhand][i].isGarbage())
				{
					this.unequip(this.m.Items[this.Const.ItemSlot.Mainhand][i]);
				}
			}
		}

		this.m.IsUpdating = false;
	}

	function onShieldHit( _attacker, _skill )
	{
		this.m.IsUpdating = true;

		for( local i = 0; i < this.m.Items[this.Const.ItemSlot.Offhand].len(); i = ++i )
		{
			if (this.m.Items[this.Const.ItemSlot.Offhand][i] != null && this.m.Items[this.Const.ItemSlot.Offhand][i] != -1)
			{
				this.m.Items[this.Const.ItemSlot.Offhand][i].onShieldHit(_attacker, _skill);

				if (this.m.Items[this.Const.ItemSlot.Offhand][i].isGarbage())
				{
					if (this.m.Items[this.Const.ItemSlot.Offhand][i].isEquipped())
					{
						this.unequip(this.m.Items[this.Const.ItemSlot.Offhand][i]);
					}
					else
					{
						this.removeFromBag(this.m.Items[this.Const.ItemSlot.Offhand][i]);
					}
				}
			}
		}

		this.m.IsUpdating = false;
	}

	function onNewRound()
	{
		if (this.m.Actor.getSkills().hasSkill("perk.quick_hands"))
		{
			this.m.ActionCost = 0;
		}
	}

	function onMovementFinished()
	{
		this.m.IsUpdating = true;

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.m.Items[i].len(); j = ++j )
			{
				if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
				{
				}
				else
				{
					this.m.Items[i][j].onMovementFinished();
				}
			}
		}

		this.m.IsUpdating = false;
	}

	function onCombatFinished()
	{
		this.m.IsUpdating = true;

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.m.Items[i].len(); j = ++j )
			{
				if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
				{
				}
				else
				{
					this.m.Items[i][j].onCombatFinished();
				}
			}
		}

		this.m.IsUpdating = false;
	}

	function onActorDied( _onTile )
	{
		this.m.IsUpdating = true;

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.m.Items[i].len(); j = ++j )
			{
				if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
				{
				}
				else
				{
					this.m.Items[i][j].onActorDied(_onTile);
				}
			}
		}

		this.m.IsUpdating = false;
	}

	function onFactionChanged( _faction )
	{
		this.m.IsUpdating = true;

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.m.Items[i].len(); j = ++j )
			{
				if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
				{
				}
				else
				{
					this.m.Items[i][j].onFactionChanged(_faction);
				}
			}
		}

		this.m.IsUpdating = false;
	}

	function onSerialize( _out )
	{
		_out.writeU8(this.m.UnlockedBagSlots);
		local numItems = 0;

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.Const.ItemSlotSpaces[i]; j = ++j )
			{
				if (this.m.Items[i][j] != null && this.m.Items[i][j] != -1)
				{
					numItems = ++numItems;
				}
			}
		}

		_out.writeU8(numItems);

		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.Const.ItemSlotSpaces[i]; j = ++j )
			{
				if (this.m.Items[i][j] != null && this.m.Items[i][j] != -1)
				{
					_out.writeU8(this.m.Items[i][j].getCurrentSlotType());
					_out.writeI32(this.m.Items[i][j].ClassNameHash);
					this.m.Items[i][j].onSerialize(_out);
				}
			}
		}
	}

	function onDeserialize( _in )
	{
		this.m.UnlockedBagSlots = _in.readU8();
		local numItems = _in.readU8();

		for( local i = 0; i < numItems; i = ++i )
		{
			local slotType = _in.readU8();
			local item = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
			item.onDeserialize(_in);
			local win = false;

			if (slotType == this.Const.ItemSlot.Bag)
			{
				win = this.addToBag(item);
			}
			else
			{
				win = this.equip(item);
			}

			if (!win)
			{
				this.World.Assets.getOverflowItems().push(item);
			}
		}
	}

};


this.item <- {
	m = {
		ID = "",
		Name = "",
		Icon = "",
		IconLarge = "",
		Description = "",
		Categories = "",
		MagicNumber = 0,
		Variant = 0,
		Condition = 1.0,
		ConditionMax = 1.0,
		SlotType = this.Const.ItemSlot.Bag,
		CurrentSlotType = this.Const.ItemSlot.None,
		BlockedSlotType = null,
		ItemType = this.Const.Items.ItemType.None,
		ItemProperty = this.Const.Items.Property.None,
		Container = null,
		SkillPtrs = [],
		Tile = null,
		Value = 0,
		PriceMult = 1.0,
		LastEquippedByFaction = 0,
		IsGarbage = false,
		IsDroppedAsLoot = false,
		IsChangeableInBattle = true,
		IsIndestructible = false,
		IsToBeRepaired = false,
		IsConsumed = false,
		IsAllowedInBag = true,
		IsUsable = false,
		IsSold = false,
		IsBought = false
	},
	function setContainer( _c )
	{
		if (_c != null)
		{
			this.m.Container = this.WeakTableRef(_c);
		}
		else
		{
			this.m.Container = null;
		}
	}

	function getContainer()
	{
		return this.m.Container;
	}

	function getName()
	{
		return this.m.Name;
	}

	function getID()
	{
		return this.m.ID;
	}

	function getInstanceID()
	{
		return this.toHash(this).tostring();
	}

	function getIcon()
	{
		return this.m.Icon;
	}

	function getIconLarge()
	{
		return this.m.IconLarge != "" ? this.m.IconLarge : null;
	}

	function getIconOverlay()
	{
		return "";
	}

	function getIconLargeOverlay()
	{
		return "";
	}

	function getDescription()
	{
		return this.m.Description;
	}

	function getCategories()
	{
		return this.m.Categories;
	}

	function getSlotType()
	{
		return this.m.SlotType;
	}

	function getCurrentSlotType()
	{
		return this.m.CurrentSlotType;
	}

	function getBlockedSlotType()
	{
		return this.m.BlockedSlotType;
	}

	function getLastEquippedByFaction()
	{
		return this.m.LastEquippedByFaction;
	}

	function setCurrentSlotType( _t )
	{
		this.m.CurrentSlotType = _t;
	}

	function isItemType( _t )
	{
		return (this.m.ItemType & _t) != 0;
	}

	function getItemType()
	{
		return this.m.ItemType;
	}

	function hasProperty( _t )
	{
		return (this.m.ItemProperty & _t) != 0;
	}

	function isInBag()
	{
		return this.m.CurrentSlotType == this.Const.ItemSlot.Bag;
	}

	function isEquipped()
	{
		return this.m.CurrentSlotType != this.Const.ItemSlot.Bag && this.m.CurrentSlotType != this.Const.ItemSlot.None;
	}

	function isGarbage()
	{
		return this.m.IsGarbage;
	}

	function isChangeableInBattle()
	{
		return this.m.SlotType >= 0 ? this.m.IsChangeableInBattle && this.Const.ItemSlotChangeableInBattle[this.m.SlotType] : false;
	}

	function isDroppedAsLoot()
	{
		return this.m.IsDroppedAsLoot;
	}

	function isSold()
	{
		return this.m.IsSold;
	}

	function isBought()
	{
		return this.m.IsBought;
	}

	function isToBeRepaired()
	{
		return this.m.CurrentSlotType != this.Const.ItemSlot.None && this.getCondition() < this.getConditionMax() || this.m.IsToBeRepaired;
	}

	function isConsumed()
	{
		return this.m.IsConsumed;
	}

	function isIndestructible()
	{
		return this.m.IsIndestructible;
	}

	function isUsable()
	{
		return this.m.IsUsable;
	}

	function setToBeRepaired( _r )
	{
		if (_r && this.getCondition() == this.getConditionMax())
		{
			return false;
		}

		this.m.IsToBeRepaired = _r;
		return true;
	}

	function getVariant()
	{
		return this.m.Variant;
	}

	function getMagicNumber()
	{
		return this.m.MagicNumber;
	}

	function getArmor()
	{
		return 0;
	}

	function getArmorMax()
	{
		return 0;
	}

	function getCondition()
	{
		return this.Math.floor(this.m.Condition);
	}

	function getConditionMax()
	{
		return this.Math.floor(this.m.ConditionMax);
	}

	function getValue()
	{
		return this.m.Value;
	}

	function getPriceMult()
	{
		return this.m.PriceMult;
	}

	function setValue( _v )
	{
		this.m.Value = _v;
	}

	function setPriceMult( _m )
	{
		this.m.PriceMult = _m;
	}

	function setSold( _f )
	{
	}

	function setBought( _f )
	{
	}

	function setCondition( _a )
	{
		this.m.Condition = _a;
		this.updateAppearance();
	}

	function setMagicNumber( _m )
	{
		this.m.MagicNumber = _m;
	}

	function isAmountShown()
	{
	}

	function getAmount()
	{
		return 0;
	}

	function getAmountMax()
	{
		return 0;
	}

	function getAmountColor()
	{
		return "#ffffff";
	}

	function getAmountString()
	{
		return "";
	}

	function getStaminaModifier()
	{
		return 0;
	}

	function isAllowedInBag()
	{
		if (!this.m.IsAllowedInBag || this.m.SlotType == this.Const.ItemSlot.Body || this.m.SlotType == this.Const.ItemSlot.Head || this.m.SlotType == this.Const.ItemSlot.None)
		{
			return false;
		}

		return true;
	}

	function getValueString()
	{
		if (this.getValue() != 0)
		{
			return "Valeur [img]gfx/ui/tooltips/money.png[/img][b]" + this.getValue() + "[/b]";
		}
		else
		{
			return "N\'a aucune valeur.";
		}
	}

	function getBuyPrice()
	{
		if (this.m.IsSold)
		{
			return this.getSellPrice();
		}

		if (("State" in this.World) && this.World.State != null && this.World.State.getCurrentTown() != null)
		{
			return this.Math.max(this.getSellPrice(), this.Math.ceil(this.getValue() * this.getBuyPriceMult() * this.getPriceMult() * this.World.State.getCurrentTown().getBuyPriceMult() * this.Const.Difficulty.BuyPriceMult[this.World.Assets.getEconomicDifficulty()]));
		}
		else
		{
			return this.Math.ceil(this.getValue() * this.getPriceMult());
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
			return this.Math.floor(this.getValue() * this.getSellPriceMult() * this.Const.World.Assets.BaseSellPrice * this.World.State.getCurrentTown().getSellPriceMult() * this.Const.Difficulty.SellPriceMult[this.World.Assets.getEconomicDifficulty()]);
		}
		else
		{
			return this.Math.floor(this.getValue() * this.Const.World.Assets.BaseSellPrice);
		}
	}
	
	function getSellPriceMult()
	{
		return 1.0;
	}

	function getBuyPriceMult()
	{
		return 1.0;
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

		if (!this.isItemType(this.Const.Items.ItemType.Crafting))
		{
			if (this.m.Categories.len() != 0)
			{
				result.push({
					id = 65,
					type = "text",
					text = this.m.Categories
				});
			}

			result.push({
				id = 66,
				type = "text",
				text = this.getValueString()
			});

			if (!this.isItemType(this.Const.Items.ItemType.Misc) || this.isItemType(this.Const.Items.ItemType.Usable) || this.isItemType(this.Const.Items.ItemType.Legendary))
			{
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
			}
		}
		else
		{
			result.push({
				id = 66,
				type = "text",
				text = this.getValueString()
			});

			if (this.Const.DLC.Unhold)
			{
				result.push({
					id = 50,
					type = "hint",
					icon = "ui/icons/plus.png",
					text = "Peut être utilisé pour crafter des objets"
				});
			}
		}

		return result;
	}

	function removeSelf()
	{
		this.m.IsGarbage = true;
		this.m.Container.collectGarbage();
	}

	function addSkill( _skill )
	{
		_skill.setItem(this);
		this.m.SkillPtrs.push(_skill);
		this.getContainer().getActor().getSkills().add(_skill, this.m.SkillPtrs.len());
	}

	function addGenericItemSkill()
	{
		local skill = this.new("scripts/skills/items/generic_item");
		skill.setItem(this);
		this.addSkill(skill);
	}

	function removeSkill( _skill )
	{
		local idx = this.m.SkillPtrs.find(_skill);

		if (idx != null)
		{
			this.m.SkillPtrs.remove(idx);
		}

		_skill.setItem(null);
		this.getContainer().getActor().getSkills().remove(_skill);
	}

	function clearSkills()
	{
		if (this.getContainer() == null || this.getContainer().getActor() == null || this.getContainer().getActor().isNull())
		{
			return;
		}

		foreach( i, skill in this.m.SkillPtrs )
		{
			this.getContainer().getActor().getSkills().remove(skill);
		}

		this.m.SkillPtrs = [];
	}

	function removeFromContainer()
	{
		this.m.Container = null;
		this.m.CurrentSlotType = this.Const.ItemSlot.None;
	}

	function drop( _tile = null )
	{
		local isPlayer = this.m.LastEquippedByFaction == this.Const.Faction.Player || this.m.Container != null && this.m.Container.getActor() != null && !this.m.Container.getActor().isNull() && this.isKindOf(this.m.Container.getActor().get(), "player");
		local isDropped = this.isDroppedAsLoot() && (this.Tactical.State.getStrategicProperties() == null || !this.Tactical.State.getStrategicProperties().IsArenaMode || isPlayer);

		if (this.m.Container != null)
		{
			if (_tile == null && this.m.Container.getActor() != null && this.m.Container.getActor().isPlacedOnMap())
			{
				_tile = this.m.Container.getActor().getTile();
			}

			if (this.m.CurrentSlotType != this.Const.ItemSlot.Bag)
			{
				this.m.Container.unequip(this);
			}
			else
			{
				this.m.Container.removeFromBag(this);
			}
		}

		if (!isDropped)
		{
			this.m.IsDroppedAsLoot = false;
			return false;
		}

		if (_tile == null)
		{
			this.logWarning("Attempted to drop item, but no tile specified!");
			return false;
		}

		_tile.Items.push(this);
		_tile.IsContainingItems = true;
		this.m.Tile = _tile;
		this.onDrop(_tile);
		return true;
	}

	function removeFromTile()
	{
		if (this.m.Tile == null)
		{
			return;
		}

		local n = this.m.Tile.Items.find(this);
		this.m.Tile.Items.remove(n);
		this.m.Tile.IsContainingItems = this.m.Tile.Items.len() != 0;
		this.m.Tile = null;
	}

	function pickup()
	{
		this.removeFromTile();
	}

	function setVariant( _v )
	{
		this.m.Variant = _v;
		this.updateVariant();
	}

	function updateVariant()
	{
	}

	function updateAppearance()
	{
	}

	function playInventorySound( _eventType )
	{
	}
	
	function create()
	{
		this.m.MagicNumber = this.Math.rand(1, 100);
	}

	function onFactionChanged( _faction )
	{
		this.m.LastEquippedByFaction = _faction;
	}

	function onEquip()
	{
		if (this.m.Container != null && this.m.Container.getActor() != null)
		{
			this.m.LastEquippedByFaction = this.m.Container.getActor().getFaction();
		}
	}

	function onUnequip()
	{
		this.clearSkills();
	}

	function onPutIntoBag()
	{
	}

	function onRemovedFromBag()
	{
		this.clearSkills();
	}

	function onPickedUp()
	{
	}

	function onDrop( _tile )
	{
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
	}

	function onDamageReceived( _damage, _fatalityType, _attacker )
	{
	}

	function onDamageDealt( _target, _skill, _hitInfo )
	{
	}

	function onShieldHit( _attacker, _skill )
	{
	}

	function onUpdateProperties( _properties )
	{
	}

	function onTurnStart()
	{
	}

	function onUse( _skill )
	{
	}

	function onTotalArmorChanged()
	{
	}

	function onMovementFinished()
	{
	}
	
	function onCombatStarted()
	{
	}

	function onCombatFinished()
	{
	}

	function onActorDied( _onTile )
	{
	}

	function onAddedToStash( _stashID )
	{
	}

	function onRemovedFromStash( _stashID )
	{
	}

	function onUse( _actor, _item = null )
	{
	}

	function onSerialize( _out )
	{
		_out.writeBool(this.m.IsToBeRepaired);
		_out.writeU16(this.m.Variant);
		_out.writeF32(this.m.Condition);
		_out.writeF32(this.m.PriceMult);
		_out.writeU8(this.m.MagicNumber);
	}

	function onDeserialize( _in )
	{
		this.m.IsToBeRepaired = _in.readBool();
		this.m.Variant = _in.readU16();
		this.m.Condition = _in.readF32();
		this.m.PriceMult = _in.readF32();

		if (_in.getMetaData().getVersion() >= 58)
		{
			this.m.MagicNumber = _in.readU8();
		}

		this.updateVariant();
	}

};


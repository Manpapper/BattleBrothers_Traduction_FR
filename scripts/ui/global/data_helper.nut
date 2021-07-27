this.data_helper <- {
	m = {},
	function create()
	{
	}

	function destroy()
	{
	}

	function convertCampaignStoragesToUIData()
	{
		local isWorldmap = ("Assets" in this.World) && this.World.Assets != null;
		local result = [];
		local storages = this.PersistenceManager.queryStorages();

		foreach( storageMeta in storages )
		{
			if (isWorldmap && this.World.Assets.isIronman() && storageMeta.getFileName() == this.World.Assets.getName() + "_" + this.World.Assets.getCampaignID())
			{
				continue;
			}

			if (storageMeta.getInt("difficulty") >= this.Const.Strings.Difficulty.len() || storageMeta.getInt("difficulty2") >= this.Const.Strings.Difficulty.len())
			{
				continue;
			}

			result.push(this.convertCampaignStorageToUIData(storageMeta));
		}

		return result;
	}

	function convertCampaignStorageToUIData( _meta )
	{
		local d;
		d = " (" + this.Const.Strings.Difficulty[_meta.getInt("difficulty2")] + "/" + this.Const.Strings.Difficulty[_meta.getInt("difficulty")];

		if (_meta.getInt("ironman") == 1)
		{
			d = d + " Ironman";
		}

		d = d + ")";
		return {
			fileName = _meta.getFileName(),
			name = _meta.getName(),
			groupName = _meta.getString("groupname"),
			banner = _meta.getString("banner"),
			dayName = "Jour " + _meta.getInt("days") + d,
			creationDate = _meta.getCreationDate(),
			isIncompatibleVersion = _meta.getVersion() < 33 || _meta.getVersion() > this.Const.Serialization.Version || !this.Const.DLC.isCompatible(_meta),
			isIronman = _meta.getInt("ironman") == 1
		};
	}

	function convertContractsToUIData( _contracts )
	{
		if (_contracts == null || _contracts.len() == 0)
		{
			return null;
		}

		local result = [];

		foreach( contract in _contracts )
		{
			result.push(this.convertContractToUIData(contract));
		}

		return result;
	}

	function convertContractToUIData( _contract )
	{
		if (_contract != null)
		{
			local result = {
				id = _contract.getEmployerUIIndex(),
				title = _contract.getName(),
				headerImagePath = _contract.getHeaderImage(),
				content = [
					{
						id = 1,
						type = "image",
						imagePath = _contract.getEmployerImage()
					},
					{
						id = 2,
						type = "description",
						text = _contract.getDescription()
					}
				],
				buttons = _contract.getButtons()
			};

			if (_contract.getBulletpoints().len() != 0)
			{
				result.content.push({
					id = 3,
					type = "list",
					title = "Objectives",
					items = _contract.getBulletpoints()
				});
			}

			return result;
		}
		else
		{
		}
	}

	function convertHireRosterToUIData( _rosterID )
	{
		local result = [];
		local roster = this.World.getRoster(_rosterID);

		if (roster == null)
		{
			return null;
		}

		local entities = roster.getAll();

		if (entities != null)
		{
			local result = [];

			foreach( entity in entities )
			{
				result.push(this.convertEntityHireInformationToUIData(entity));
			}

			return result;
		}

		return null;
	}

	function convertAssetsInformationToUIData()
	{
		local roster = this.World.getPlayerRoster();
		local entities = roster.getAll();
		return {
			Money = this.World.Assets.getMoney(),
			Food = this.World.Assets.getFood(),
			Supplies = this.World.Assets.getArmorParts(),
			Ammo = this.World.Assets.getAmmo(),
			Medicine = this.World.Assets.getMedicine(),
			Brothers = entities != null ? entities.len() : 0,
			BrothersMax = this.World.Assets.getBrothersMax(),
			BusinessReputation = this.World.Assets.getBusinessReputationAsText()
		};
	}

	function convertStashAndEntityToUIData( _entity = null, _activeEntity = null, _withoutStash = false, _filter = 0 )
	{
		local result = {};
		result.stashSpaceUsed <- this.Stash.getNumberOfFilledSlots();
		result.stashSpaceMax <- this.Stash.getCapacity();

		if (_withoutStash == false)
		{
			result.stash <- this.convertStashToUIData(false, _filter);
		}

		if (_entity != null)
		{
			local entity = this.convertEntityToUIData(_entity, _activeEntity);
			result.brother <- entity;
		}

		return result;
	}

	function convertEntityToUIData( _entity, _activeEntity )
	{
		local result = {
			id = _entity.getID(),
			flags = {},
			character = {},
			stats = {},
			activeSkills = {},
			passiveSkills = {},
			statusEffects = {},
			injuries = [],
			perks = [],
			equipment = {},
			bag = [],
			ground = []
		};
		this.addFlagsToUIData(_entity, _activeEntity, result.flags);
		this.addCharacterToUIData(_entity, result.character);
		this.addStatsToUIData(_entity, result.stats);
		local skills = _entity.getSkills();
		this.addSkillsToUIData(skills.querySortedByItems(this.Const.SkillType.Active), result.activeSkills);
		this.addSkillsToUIData(skills.querySortedByItems(this.Const.SkillType.Trait | this.Const.SkillType.PermanentInjury), result.passiveSkills);
		local injuries = skills.query(this.Const.SkillType.TemporaryInjury | this.Const.SkillType.SemiInjury);

		foreach( i in injuries )
		{
			result.injuries.push({
				id = i.getID(),
				imagePath = i.getIconColored()
			});
		}

		this.addSkillsToUIData(skills.querySortedByItems(this.Const.SkillType.StatusEffect, this.Const.SkillType.Trait), result.passiveSkills);
		this.addPerksToUIData(_entity, skills.query(this.Const.SkillType.Perk, true), result.perks);
		local items = _entity.getItems();
		this.convertPaperdollEquipmentToUIData(items, result.equipment);
		this.convertBagItemsToUIData(items, result.bag);

		if (this.Tactical.isActive() && _entity.getTile() != null)
		{
			this.convertItemsToUIData(_entity.getTile().Items, result.ground);
			result.ground.push(null);
		}

		return result;
	}

	function convertStatisticsEntityToUIData( _entity )
	{
		local combatStats = _entity.getCombatStats();
		return {
			id = _entity.getID(),
			name = _entity.getNameOnly(),
			title = _entity.getTitle(),
			imagePath = _entity.getImagePath(),
			imageOffsetX = _entity.getImageOffsetX(),
			imageOffsetY = _entity.getImageOffsetY(),
			killsMade = combatStats.Kills,
			xpReceived = combatStats.XPGained,
			damageDealt = combatStats.DamageDealtHitpoints + combatStats.DamageDealtArmor,
			damageReceived = combatStats.DamageReceivedHitpoints + combatStats.DamageReceivedArmor,
			daysWounded = _entity.getDaysWounded(),
			leveledUp = _entity.isLeveled(),
			isDead = !_entity.isAlive(),
			isSurvivor = _entity.isAlive() && this.hasFreshPermanentInjury(_entity),
			injuries = _entity.isAlive() ? this.queryFreshInjuries(_entity) : null
		};
	}

	function queryFreshInjuries( _entity )
	{
		local ret = [];
		local injuries = _entity.getSkills().query(this.Const.SkillType.Injury);

		foreach( inj in injuries )
		{
			if (inj.isFresh())
			{
				ret.push({
					id = inj.getID(),
					icon = inj.getIconColored()
				});
			}
		}

		return ret;
	}

	function hasFreshPermanentInjury( _entity )
	{
		local injuries = _entity.getSkills().query(this.Const.SkillType.PermanentInjury);

		foreach( inj in injuries )
		{
			if (inj.isFresh())
			{
				return true;
			}
		}

		return false;
	}

	function convertEntityHireInformationToUIData( _entity )
	{
		local background = _entity.getBackground();
		return {
			ID = _entity.getID(),
			Name = _entity.getName(),
			Level = _entity.getLevel(),
			InitialMoneyCost = this.Math.ceil(_entity.getHiringCost() * this.World.Assets.m.HiringCostMult),
			DailyMoneyCost = _entity.getDailyCost(),
			DailyFoodCost = _entity.getDailyFood(),
			TryoutCost = _entity.getTryoutCost(),
			IsTryoutDone = _entity.isTryoutDone(),
			ImagePath = _entity.getImagePath(),
			ImageOffsetX = _entity.getImageOffsetX(),
			ImageOffsetY = _entity.getImageOffsetY(),
			BackgroundImagePath = background.getIconColored(),
			BackgroundText = background.getDescription(),
			Traits = _entity.getHiringTraits()
		};
	}

	function addFlagsToUIData( _entity, _activeEntity, _target )
	{
		_target.isSelected <- false;

		if (_activeEntity != null && _entity == _activeEntity)
		{
			_target.isSelected <- true;
		}
	}

	function addCharacterToUIData( _entity, _target )
	{
		_target.name <- _entity.getNameOnly();
		_target.title <- _entity.getTitle();
		_target.imagePath <- _entity.getImagePath();
		_target.imageOffsetX <- _entity.getImageOffsetX();
		_target.imageOffsetY <- _entity.getImageOffsetY();
		_target.perkPoints <- _entity.getPerkPoints();
		_target.perkPointsSpent <- _entity.getPerkPointsSpent();
		_target.level <- _entity.getLevel();
		_target.levelUp <- null;
		_target.daysWithCompany <- _entity.getDaysWithCompany();
		_target.xpValue <- _entity.getXP();
		_target.xpValueMax <- _entity.getXPForNextLevel();
		_target.dailyMoneyCost <- _entity.getDailyCost();
		_target.daysWounded <- _entity.getDaysWounded();
		_target.leveledUp <- _entity.isLeveled();
		_target.moodIcon <- "ui/icons/mood_0" + (_entity.getMoodState() + 1) + ".png";
		_target.isPlayerCharacter <- _entity.getFlags().get("IsPlayerCharacter");

		if (_entity.getLevelUps() > 0)
		{
			_target.levelUp = _entity.getAttributeLevelUpValues();
		}
	}

	function addStatsToUIData( _entity, _target )
	{
		local properties = _entity.getCurrentProperties();
		_target.hitpoints <- _entity.getHitpoints();
		_target.hitpointsMax <- _entity.getHitpointsMax();
		_target.hitpointsTalent <- _entity.getTalents()[this.Const.Attributes.Hitpoints];
		_target.fatigue <- _entity.getFatigue();
		_target.fatigueMax <- _entity.getFatigueMax();
		_target.fatigueTalent <- _entity.getTalents()[this.Const.Attributes.Fatigue];
		_target.initiative <- _entity.getInitiative();
		_target.initiativeMax <- this.Const.CharacterMaxValue.Initiative;
		_target.initiativeTalent <- _entity.getTalents()[this.Const.Attributes.Initiative];
		_target.bravery <- _entity.getBravery();
		_target.braveryMax <- this.Const.CharacterMaxValue.Bravery;
		_target.braveryTalent <- _entity.getTalents()[this.Const.Attributes.Bravery];
		_target.meleeSkill <- properties.getMeleeSkill();
		_target.meleeSkillMax <- this.Const.CharacterMaxValue.MeleeSkill;
		_target.meleeSkillTalent <- _entity.getTalents()[this.Const.Attributes.MeleeSkill];
		_target.rangeSkill <- properties.getRangedSkill();
		_target.rangeSkillMax <- this.Const.CharacterMaxValue.RangedSkill;
		_target.rangeSkillTalent <- _entity.getTalents()[this.Const.Attributes.RangedSkill];
		_target.meleeDefense <- properties.getMeleeDefense();
		_target.meleeDefenseMax <- this.Const.CharacterMaxValue.MeleeDefense;
		_target.meleeDefenseTalent <- _entity.getTalents()[this.Const.Attributes.MeleeDefense];
		_target.rangeDefense <- properties.getRangedDefense();
		_target.rangeDefenseMax <- this.Const.CharacterMaxValue.RangedDefense;
		_target.rangeDefenseTalent <- _entity.getTalents()[this.Const.Attributes.RangedDefense];
		_target.actionPoints <- _entity.getActionPoints();
		_target.actionPointsMax <- _entity.getActionPointsMax();
		_target.morale <- _entity.getMoraleState();
		_target.moraleMax <- this.Const.MoraleState.COUNT - 1;
		_target.moraleLabel <- this.Const.MoraleStateName[_entity.getMoraleState()];
		local dm = 1.0;
		dm = dm * (_entity.isArmedWithMeleeWeapon() ? properties.MeleeDamageMult : 1.0);
		_target.regularDamage <- properties.getRegularDamageAverage() * dm;
		_target.regularDamageMax <- this.Const.CharacterMaxValue.RegularDamage;
		_target.regularDamageLabel <- this.Math.floor(properties.getDamageRegularMin() * dm) + " - " + this.Math.floor(properties.getDamageRegularMax() * dm);
		_target.armorHead <- _entity.getArmor(this.Const.BodyPart.Head);
		_target.armorHeadMax <- _entity.getArmorMax(this.Const.BodyPart.Head);
		_target.armorHeadTalent <- 0;
		_target.armorBody <- _entity.getArmor(this.Const.BodyPart.Body);
		_target.armorBodyMax <- _entity.getArmorMax(this.Const.BodyPart.Body);
		_target.armorBodyTalent <- 0;
		_target.crushingDamage <- this.Math.floor(properties.getDamageArmorMult() * 100);
		_target.crushingDamageMax <- this.Const.CharacterMaxValue.ArmorDamage;
		_target.crushingDamageLabel <- this.Math.floor(properties.getDamageArmorMult() * 100) + "%";
		_target.chanceToHitHead <- properties.getHitchance(this.Const.BodyPart.Head);
		_target.chanceToHitHeadMax <- this.Const.CharacterMaxValue.Hitchance;
		_target.chanceToHitHeadLabel <- properties.getHitchance(this.Const.BodyPart.Head) + "%";
		_target.sightDistance <- properties.getVision();
		_target.sightDistanceMax <- this.Const.CharacterMaxValue.Vision;
	}

	function addSkillsToUIData( _skills, _target )
	{
		if (_skills != null && _skills.len() > 0)
		{
			local result = this.convertSkillsToUIData(_skills[this.Const.ItemSlot.Body]);

			if (result != null)
			{
				if ("body" in _target)
				{
					_target.body.extend(result);
				}
				else
				{
					_target.body <- result;
				}
			}

			result = this.convertSkillsToUIData(_skills[this.Const.ItemSlot.Head]);

			if (result != null)
			{
				if ("head" in _target)
				{
					_target.head.extend(result);
				}
				else
				{
					_target.head <- result;
				}
			}

			result = this.convertSkillsToUIData(_skills[this.Const.ItemSlot.Mainhand]);

			if (result != null)
			{
				if ("mainhand" in _target)
				{
					_target.mainhand.extend(result);
				}
				else
				{
					_target.mainhand <- result;
				}
			}

			result = this.convertSkillsToUIData(_skills[this.Const.ItemSlot.Offhand]);

			if (result != null)
			{
				if ("offhand" in _target)
				{
					_target.offhand.extend(result);
				}
				else
				{
					_target.offhand <- result;
				}
			}

			result = this.convertSkillsToUIData(_skills[this.Const.ItemSlot.Accessory]);

			if (result != null)
			{
				if ("accessory" in _target)
				{
					_target.accessory.extend(result);
				}
				else
				{
					_target.accessory <- result;
				}
			}

			result = this.convertSkillsToUIData(_skills[this.Const.ItemSlot.Free]);

			if (result != null)
			{
				if ("free" in _target)
				{
					_target.free.extend(result);
				}
				else
				{
					_target.free <- result;
				}
			}
		}
	}

	function convertSkillsToUIData( _skills )
	{
		local result;

		foreach( skill in _skills )
		{
			if (result == null)
			{
				result = [];
			}

			if (this.Stash.isLocked() == false)
			{
				if (skill.isType(this.Const.SkillType.Terrain) != true)
				{
					result.push(this.convertSkillToUIData(skill));
				}
			}
			else
			{
				result.push(this.convertSkillToUIData(skill));
			}
		}

		return result;
	}

	function convertSkillToUIData( _skill )
	{
		return {
			id = _skill.getID(),
			imagePath = _skill.getIconColored()
		};
	}

	function addPerksToUIData( _entity, _perks, _target )
	{
		foreach( p in _perks )
		{
			_target.push(p.getID());
		}
	}

	function convertPerkToUIData( _perkId )
	{
		local perk = this.Const.Perks.findById(_perkId);

		if (perk != null)
		{
			return {
				id = perk.ID,
				name = perk.Name,
				description = perk.Tooltip,
				imagePath = perk.Icon
			};
		}

		return null;
	}

	function convertPerksToUIData()
	{
		return this.Const.Perks.Perks;
	}

	function convertCombatResultRosterToUIData()
	{
		local roster = this.Tactical.CombatResultRoster;
		local numKills = 0;

		if (roster != null)
		{
			local result = [];

			foreach( entity in roster )
			{
				result.push(this.convertStatisticsEntityToUIData(entity));
				numKills = numKills + entity.getCombatStats().Kills;
			}

			if (!this.Tactical.State.isScenarioMode() && numKills >= 24)
			{
				this.updateAchievement("Outnumbered", 1, 1);
			}

			return result;
		}

		return null;
	}

	function convertCombatResultLootToUIData()
	{
		local items = this.Tactical.CombatResultLoot.getItems();

		if (items != null)
		{
			local result = [];

			foreach( item in items )
			{
				result.push(this.convertItemToUIData(item, true));
			}

			return result;
		}

		return null;
	}

	function convertPaperdollEquipmentToUIData( _items, _target )
	{
		if (_items == null)
		{
			return;
		}

		local item = _items.getItemAtSlot(this.Const.ItemSlot.Body);

		if (item != null)
		{
			_target.body <- this.convertItemToUIData(item, false);
		}

		item = _items.getItemAtSlot(this.Const.ItemSlot.Head);

		if (item != null)
		{
			_target.head <- this.convertItemToUIData(item, false);
		}

		item = _items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (item != null)
		{
			_target.mainhand <- this.convertItemToUIData(item, false);
		}

		item = _items.getItemAtSlot(this.Const.ItemSlot.Offhand);

		if (item != null)
		{
			_target.offhand <- this.convertItemToUIData(item, false);
		}

		item = _items.getItemAtSlot(this.Const.ItemSlot.Accessory);

		if (item != null)
		{
			_target.accessory <- this.convertItemToUIData(item, false);
		}

		item = _items.getItemAtSlot(this.Const.ItemSlot.Ammo);

		if (item != null)
		{
			_target.ammo <- this.convertItemToUIData(item, true);
		}
	}

	function convertBagItemsToUIData( _items, _target )
	{
		if (_items == null)
		{
			return;
		}

		local numUnlockedBags = _items.getUnlockedBagSlots();

		for( local i = 0; i < this.Const.ItemSlotSpaces[this.Const.ItemSlot.Bag]; i = ++i )
		{
			local item = _items.getItemAtBagSlot(i);

			if (i < numUnlockedBags)
			{
				_target.push(this.convertItemToUIData(item, true));
			}
		}
	}

	function convertStashToUIData( _ignoreLocked = false, _filter = 0 )
	{
		if (!_ignoreLocked && this.Stash.isLocked())
		{
			return null;
		}

		if (_filter == 0)
		{
			_filter = this.Const.Items.ItemFilter.All;
		}

		local items = this.Stash.getItems();

		if (items != null)
		{
			local result = [];

			foreach( item in items )
			{
				if (item != null && (item.getItemType() & _filter) != 0)
				{
					result.push(this.convertItemToUIData(item, true, this.Const.UI.ItemOwner.Stash));
				}
				else
				{
					result.push(null);
				}
			}

			return result;
		}

		return null;
	}

	function convertItemsToUIData( _items, _target, _owner = null, _filter = 0 )
	{
		if (_filter == 0)
		{
			_filter = this.Const.Items.ItemFilter.All;
		}

		if (_items == null || _items.len() == 0)
		{
			return;
		}

		for( local i = 0; i < _items.len(); i = ++i )
		{
			if (_items[i] != null && (_items[i].getItemType() & _filter) != 0)
			{
				_target.push(this.convertItemToUIData(_items[i], true, _owner));
			}
			else
			{
				_target.push(null);
			}
		}
	}

	function convertItemToUIData( _item, _forceSmallIcon, _owner = null )
	{
		if (_item == null)
		{
			return null;
		}

		local result = {
			id = _item.getInstanceID()
		};

		switch(_item.getSlotType())
		{
		case this.Const.ItemSlot.Body:
			result.slot <- "body";
			break;

		case this.Const.ItemSlot.Head:
			result.slot <- "head";
			break;

		case this.Const.ItemSlot.Mainhand:
			result.slot <- "mainhand";
			break;

		case this.Const.ItemSlot.Offhand:
			result.slot <- "offhand";
			break;

		case this.Const.ItemSlot.Accessory:
			result.slot <- "accessory";
			break;

		case this.Const.ItemSlot.Ammo:
			result.slot <- "ammo";
			break;

		case this.Const.ItemSlot.Free:
			result.slot <- "free";
			break;

		default:
			result.slot <- "none";
			break;
		}

		if (_forceSmallIcon == false && _item.getIconLarge() != null)
		{
			result.imagePath <- _item.getIconLarge();
			result.imageOverlayPath <- _item.getIconLargeOverlay();
			result.isLarge <- true;
		}
		else
		{
			result.imagePath <- _item.getIcon();
			result.imageOverlayPath <- _item.getIconOverlay();
			result.isLarge <- false;
		}

		if (_item.getBlockedSlotType() != null && _item.getBlockedSlotType() == this.Const.ItemSlot.Offhand)
		{
			result.isBlockingOffhand <- true;
		}

		result.isChangeableInBattle <- _item.isChangeableInBattle();
		result.isAllowedInBag <- _item.isAllowedInBag();
		result.isUsable <- _item.isUsable();
		result.showAmount <- _item.isAmountShown();
		result.amount <- _item.getAmountString();
		result.amountColor <- _item.getAmountColor();
		result.repair <- _item.isToBeRepaired();
		result.price <- 0;

		if (_owner != null)
		{
			switch(_owner)
			{
			case this.Const.UI.ItemOwner.Stash:
				result.price = _item.getSellPrice();
				break;

			case this.Const.UI.ItemOwner.Shop:
				result.price = _item.getBuyPrice();
				break;
			}
		}

		return result;
	}

};


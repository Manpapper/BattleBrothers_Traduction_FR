this.world_entity <- {
	m = {
		Name = "",
		Description = "",
		VisionRadius = this.Const.World.Settings.Vision,
		VisibilityMult = 1.0,
		CombatID = 0,
		CombatSeed = 0,
		OnCombatWithPlayerCallback = null,
		Troops = [],
		Strength = 0.0,
		Flags = null,
		Inventory = [],
		LootScale = 1.0,
		IsAlive = true,
		IsDirty = false,
		IsAttackable = false,
		IsAttackableByAI = true,
		IsDestructible = true,
		IsLooting = false,
		IsDroppingLoot = true,
		IsUsingGlobalVision = true,
		IsShowingStrength = true,
		IsShowingName = true
	},
	function getName()
	{
		return this.m.Name;
	}

	function getNameOnly()
	{
		return this.m.Name;
	}

	function getDescription()
	{
		return this.m.Description;
	}

	function getFlags()
	{
		return this.m.Flags;
	}

	function getVisibilityMult()
	{
		return this.m.VisibilityMult;
	}

	function getCombatID()
	{
		return this.m.CombatID;
	}

	function getCombatSeed()
	{
		return this.m.CombatSeed;
	}

	function getTroops()
	{
		return this.m.Troops;
	}

	function getStrength()
	{
		return this.m.Strength;
	}

	function clearTroops()
	{
		this.m.Troops = [];
		this.updateStrength();
	}

	function setDirty( _v )
	{
		this.m.IsDirty = _v;
	}

	function setName( _n )
	{
		this.m.Name = _n;
		this.updateStrength();
	}

	function setDescription( _v )
	{
		this.m.Description = _v;
	}

	function setCombatID( _v )
	{
		this.m.CombatID = _v;
	}

	function isAlive()
	{
		return this.m.IsAlive;
	}

	function isDirty()
	{
		return this.m.IsDirty;
	}

	function isAttackable()
	{
		return this.m.IsAttackable && this.m.VisibilityMult > 0;
	}

	function isAttackableByAI()
	{
		return this.m.IsAttackableByAI;
	}

	function isDestructible()
	{
		return this.m.IsDestructible;
	}

	function isUsingGlobalVision()
	{
		return this.m.IsUsingGlobalVision;
	}

	function isInCombat()
	{
		return this.m.CombatID != 0;
	}

	function isParty()
	{
		return false;
	}

	function isLocation()
	{
		return false;
	}

	function isLooting()
	{
		return this.m.IsLooting;
	}

	function isDroppingLoot()
	{
		return this.m.IsDroppingLoot;
	}

	function isPlayerControlled()
	{
		return this.getFaction() == this.Const.FactionType.Player;
	}

	function isAlliedWithPlayer()
	{
		return this.getFaction() == 0 || this.getFaction() == this.Const.FactionType.Player || this.World.FactionManager.isAlliedWithPlayer(this.getFaction());
	}

	function setAttackable( _f )
	{
		this.m.IsAttackable = _f;
	}

	function setAttackableByAI( _f )
	{
		this.m.IsAttackableByAI = _f;
	}

	function setVisibilityMult( _v )
	{
		this.m.VisibilityMult = _v;
	}

	function setVisionRadius( _v )
	{
		this.m.VisionRadius = _v;
	}

	function setUsingGlobalVision( _v )
	{
		this.m.IsUsingGlobalVision = _v;
	}

	function setLooting( _f )
	{
		this.m.IsLooting = _f;
	}

	function setShowName( _b )
	{
		this.m.IsShowingName = _b;

		if (this.hasLabel("name"))
		{
			this.getLabel("name").Visible = _b;
		}
	}

	function setDropLoot( _l )
	{
		this.m.IsDroppingLoot = _l;
	}

	function setLootScale( _f )
	{
		this.m.LootScale = _f;
	}

	function getInventory()
	{
		return this.m.Inventory;
	}

	function addToInventory( _i )
	{
		this.m.Inventory.push(_i);
	}

	function clearInventory()
	{
		this.m.Inventory = [];
	}

	function getLoot()
	{
		return this.m.Loot;
	}

	function isAlliedWith( _p )
	{
		if (this.getFaction() == 0)
		{
			return true;
		}

		local f = _p;

		if (typeof _p == "instance" || typeof _p == "table")
		{
			f = _p.getFaction();
		}

		return f == this.getFaction() || this.World.FactionManager.isAllied(this.getFaction(), f);
	}

	function setFaction( _f )
	{
		this.setFactionEx(_f);
		this.updatePlayerRelation();
	}

	function setOnCombatWithPlayerCallback( _c )
	{
		this.m.OnCombatWithPlayerCallback = _c;
	}

	function getVisionRadius()
	{
		if (!this.m.IsUsingGlobalVision)
		{
			return this.m.VisionRadius * this.Const.World.TerrainTypeVisionRadiusMult[this.getTile().Type];
		}
		else
		{
			return this.m.VisionRadius * this.World.getGlobalVisibilityMult() * this.Const.World.TerrainTypeVisionRadiusMult[this.getTile().Type];
		}
	}

	function isAbleToSee( _entity )
	{
		local e = typeof _entity == "instance" ? _entity.get() : this._entity2;
		return e.isVisibleToEntity(this, this.getVisionRadius());
	}

	function getImagePath()
	{
		return "worldentity(" + this.Math.rand() + "," + this.getID() + ")";
	}

	function getTooltip()
	{
		return [
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
	}

	function getTroopComposition()
	{
		local entities = [];
		local champions = [];
		local entityTypes = [];
		entityTypes.resize(this.Const.EntityType.len(), 0);

		foreach( t in this.m.Troops )
		{
			if (t.Script.len() != "")
			{
				if (t.Variant != 0 && this.Const.DLC.Wildmen)
				{
					champions.push(t);
				}
				else
				{
					++entityTypes[t.ID];
				}
			}
		}

		foreach( c in champions )
		{
			entities.push({
				id = 20,
				type = "text",
				icon = "ui/orientation/" + this.Const.EntityIcon[c.ID] + ".png",
				text = c.Name
			});
		}

		for( local i = 0; i < entityTypes.len(); i = ++i )
		{
			if (entityTypes[i] > 0)
			{
				if (entityTypes[i] == 1)
				{
					local start = this.isFirstCharacter(this.Const.Strings.EntityName[i], [
						"A",
						"E",
						"I",
						"O",
						"U"
					]) ? "Un " : "Un ";
					entities.push({
						id = 20,
						type = "text",
						icon = "ui/orientation/" + this.Const.EntityIcon[i] + ".png",
						text = start + this.removeFromBeginningOfText("The ", this.Const.Strings.EntityName[i])
					});
				}
				else
				{
					local num = this.Const.Strings.EngageEnemyNumbers[this.Math.max(0, this.Math.floor(this.Math.minf(1.0, entityTypes[i] / 14.0) * (this.Const.Strings.EngageEnemyNumbers.len() - 1)))];
					entities.push({
						id = 20,
						type = "text",
						icon = "ui/orientation/" + this.Const.EntityIcon[i] + ".png",
						text = num + " " + this.Const.Strings.EntityNamePlural[i]
					});
				}
			}
		}

		return entities;
	}

	function setOrders( _o )
	{
	}

	function fadeOutAndDie()
	{
		this.m.IsAlive = false;
		this.fadeAndDie();
	}

	function updatePlayerRelation()
	{
		if (this.isPlayerControlled())
		{
			return;
		}

		if (!this.hasLabel("name"))
		{
			return;
		}

		if (!this.isAlliedWithPlayer())
		{
			if (this.World.FactionManager.getFaction(this.getFaction()).isPlayerRelationPermanent())
			{
				this.getLabel("name").Color = this.Const.Factions.PermanentHostileColor;
			}
			else
			{
				this.getLabel("name").Color = this.Const.Factions.HostileColor;
			}
		}
		else
		{
			this.getLabel("name").Color = this.Const.Factions.NeutralColor;
		}
	}

	function updateStrength()
	{
		if (!this.isAlive())
		{
			return;
		}

		this.m.Strength = 0;

		foreach( t in this.m.Troops )
		{
			this.m.Strength += t.Strength;
		}

		if (this.hasLabel("name"))
		{
			if (!this.isPlayerControlled())
			{
				if (this.m.Troops.len() != 0 && this.m.IsShowingStrength)
				{
					this.getLabel("name").Text = this.getName() + " (" + this.m.Troops.len() + ")";
				}
				else
				{
					this.getLabel("name").Text = this.getName();
				}
			}
		}
	}

	function getStrengthAsText()
	{
		local v = 0;

		if (this.m.Strength != 0)
		{
			v = this.m.Strength;
		}
		else
		{
			return "";
		}

		local p = this.World.State.getPlayer() != null ? this.World.State.getPlayer().getStrength() : 33;
		local s = p / (v * 1.0);

		if (s >= 0.85 && s <= 1.15)
		{
			return "Even";
		}
		else if (s >= 0.7 && s < 0.85)
		{
			return "Challenging";
		}
		else if (s >= 0.5 && s < 0.7)
		{
			return "Deadly";
		}
		else if (s < 0.5)
		{
			return "Impossible";
		}
		else if (s >= 1.15 && s <= 1.3)
		{
			return "Slightly Weaker";
		}
		else if (s >= 1.3 && s <= 1.5)
		{
			return "Weaker";
		}
		else if (s > 1.5)
		{
			return "Puny";
		}

		return "Unknown";
	}

	function removeTroop( _t )
	{
		if (!this.isAlive())
		{
			return;
		}

		foreach( i, troop in this.m.Troops )
		{
			if (troop == _t)
			{
				this.m.Troops.remove(i);
				break;
			}
		}

		this.updateStrength();
	}

	function stun( _seconds )
	{
	}

	function dropMoney( _num, _lootTable )
	{
		_num = this.Math.max(0, this.Math.round(_num * this.m.LootScale));

		if (_num == 0)
		{
			return;
		}

		local money = this.new("scripts/items/supplies/money_item");
		money.setAmount(_num);
		_lootTable.push(money);
	}

	function dropFood( _num, _items, _lootTable )
	{
		_num = this.Math.max(0, this.Math.round(_num * this.m.LootScale));

		if (_num == 0)
		{
			return;
		}

		for( local i = 0; i != _num; i = ++i )
		{
			local food = this.new("scripts/items/supplies/" + _items[this.Math.rand(0, _items.len() - 1)]);
			food.randomizeAmount();
			food.randomizeBestBefore();
			_lootTable.push(food);
		}
	}

	function dropTreasure( _num, _items, _lootTable )
	{
		_num = this.Math.max(0, this.Math.floor(_num * this.m.LootScale));

		if (_num == 0)
		{
			return;
		}

		for( local i = 0; i != _num; i = ++i )
		{
			local item = this.new("scripts/items/" + _items[this.Math.rand(0, _items.len() - 1)]);
			_lootTable.push(item);
		}
	}

	function dropAmmo( _num, _lootTable )
	{
		_num = this.Math.max(0, this.Math.round(_num * this.m.LootScale));

		if (_num == 0)
		{
			return;
		}

		local ammo = this.new("scripts/items/supplies/ammo_item");
		ammo.setAmount(_num);
		_lootTable.push(ammo);
	}

	function dropArmorParts( _num, _lootTable )
	{
		_num = this.Math.max(0, this.Math.round(_num * this.m.LootScale));

		if (_num == 0)
		{
			return;
		}

		local armorParts = this.new("scripts/items/supplies/armor_parts_item");
		armorParts.setAmount(_num);
		_lootTable.push(armorParts);
	}

	function dropMedicine( _num, _lootTable )
	{
		_num = this.Math.max(0, this.Math.round(_num * this.m.LootScale));

		if (_num == 0)
		{
			return;
		}

		local medicine = this.new("scripts/items/supplies/medicine_item");
		medicine.setAmount(_num);
		_lootTable.push(medicine);
	}

	function create()
	{
		this.m.Flags = this.new("scripts/tools/tag_collection");
	}

	function onUpdate()
	{
		if (!this.m.IsAlive)
		{
			return;
		}

		this.setVisibility(this.m.VisibilityMult * this.Const.World.TerrainTypeVisibilityMult[this.getTile().Type]);

		if (this.Const.World.AI.VisionDebugMode)
		{
			local debug_vision = this.getSprite("debug_vision");
			debug_vision.Scale = this.getVisionRadius() / 100.0;
		}
	}

	function onBeforeCombatStarted()
	{
	}

	function onCombatStarted()
	{
	}

	function onCombatWon()
	{
	}

	function onCombatLost()
	{
		if (this.m.IsDestructible)
		{
			if (this.hasLabel("name"))
			{
				this.getLabel("name").Visible = false;
			}

			this.fadeOutAndDie();
		}
	}

	function onDropLootForPlayer( _lootTable )
	{
		foreach( item in this.m.Inventory )
		{
			local item = this.new("scripts/items/" + item);

			if (item.isItemType(this.Const.Items.ItemType.Food))
			{
				item.randomizeAmount();
				item.randomizeBestBefore();
			}

			_lootTable.push(item);
		}
	}

	function onEnteringCombatWithPlayer( _isPlayerAttacking = true )
	{
		if (this.m.OnCombatWithPlayerCallback != null)
		{
			this.m.OnCombatWithPlayerCallback(this, _isPlayerAttacking);
			return false;
		}
		else
		{
			return true;
		}
	}

	function onInit()
	{
		this.m.IsDirty = true;

		if (this.Const.World.AI.VisionDebugMode)
		{
			local debug_vision = this.addSprite("debug_vision");
			debug_vision.setBrush("debug_circle_100");
			debug_vision.Scale = this.m.VisionRadius / 100.0;
			debug_vision.Visible = false;
		}

		if (this.m.CombatSeed == 0)
		{
			this.m.CombatSeed = this.Math.rand();
		}
	}

	function onAfterInit()
	{
		local selection = this.addSprite("selection");
		this.setSpriteScaling("selection", false);
		this.setSpriteOffset("selection", this.createVec(-30, 30));
		selection.setBrush("world_party_selection");
		selection.Visible = false;
		this.updateStrength();
	}

	function onFinish()
	{
		this.m.IsAlive = false;
	}

	function onDiscovered()
	{
		if (!this.World.State.isPaused() && this.isAttackable() && this.getFaction() != 0 && !this.isAlliedWithPlayer())
		{
			this.World.State.playEnemyDiscoveredSound();
		}
	}

	function onSerialize( _out )
	{
		_out.writeString(this.m.Name);
		_out.writeString(this.m.Description);
		_out.writeU8(this.Math.min(255, this.m.Troops.len()));

		foreach( t in this.m.Troops )
		{
			_out.writeU16(t.ID);
			_out.writeU8(t.Variant);
			_out.writeF32(t.Strength);
			_out.writeI8(t.Row);
			_out.writeString(t.Name);
			_out.writeI32(this.IO.scriptHashByFilename(t.Script));
		}

		_out.writeI32(this.m.CombatID);
		_out.writeI32(this.m.CombatSeed);
		_out.writeF32(this.m.VisionRadius);
		_out.writeF32(this.m.VisibilityMult);
		local numInventoryItems = this.Math.min(255, this.m.Inventory.len());
		_out.writeU8(numInventoryItems);

		for( local i = 0; i < numInventoryItems; i = ++i )
		{
			_out.writeString(this.m.Inventory[i]);
		}

		_out.writeF32(this.m.LootScale);
		_out.writeBool(this.m.IsAttackable);
		_out.writeBool(this.m.IsAttackableByAI);
		_out.writeBool(this.m.IsUsingGlobalVision);
		_out.writeBool(this.m.IsShowingName);
		_out.writeBool(this.m.IsLooting);
		_out.writeBool(this.m.IsDroppingLoot);
		this.m.Flags.onSerialize(_out);
		_out.writeBool(false);
	}

	function onDeserialize( _in )
	{
		this.getSprite("selection").Visible = false;
		this.setSpriteOffset("selection", this.createVec(-30, 30));
		this.m.Troops = [];
		this.m.Strength = 0;
		this.m.Inventory = [];
		this.m.Name = _in.readString();
		this.m.Description = _in.readString();

		if (this.hasLabel("name"))
		{
			this.getLabel("name").Text = this.getName();
		}

		local numTroops = _in.readU8();

		for( local i = 0; i < numTroops; i = ++i )
		{
			local troop = clone this.Const.World.Spawn.Unit;
			troop.ID = _in.readU16();
			troop.Variant = _in.readU8();
			troop.Strength = _in.readF32();
			troop.Row = _in.readI8();
			troop.Party = this.WeakTableRef(this);
			troop.Faction = this.getFaction();

			if (_in.getMetaData().getVersion() >= 48)
			{
				troop.Name = _in.readString();
			}
			else if (_in.getMetaData().getVersion() < 40)
			{
				troop.ID = this.Const.EntityType.convertOldToNew(troop.ID);
			}

			local hash = _in.readI32();

			if (hash != 0)
			{
				troop.Script = this.IO.scriptFilenameByHash(hash);
			}

			if (troop.Script == "scripts/entity/tactical/enemies/alp_illusion")
			{
			}
			else
			{
				this.m.Troops.push(troop);
			}
		}

		this.updateStrength();
		this.m.CombatID = _in.readI32();

		if (_in.getMetaData().getVersion() >= 49)
		{
			this.m.CombatSeed = _in.readI32();
		}

		this.m.VisionRadius = _in.readF32();
		this.m.VisibilityMult = _in.readF32();
		local numInventoryItems = _in.readU8();

		for( local i = 0; i != numInventoryItems; i = ++i )
		{
			this.m.Inventory.push(_in.readString());
		}

		this.m.LootScale = _in.readF32();
		this.m.IsAttackable = _in.readBool();
		this.m.IsAttackableByAI = _in.readBool();
		this.m.IsUsingGlobalVision = _in.readBool();
		this.m.IsShowingName = _in.readBool();
		this.m.IsLooting = _in.readBool();
		this.m.IsDroppingLoot = _in.readBool();

		if (this.hasLabel("name"))
		{
			this.getLabel("name").Visible = true;
		}

		this.m.Flags.onDeserialize(_in);
		_in.readBool();
	}

};


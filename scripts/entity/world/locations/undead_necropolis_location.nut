this.undead_necropolis_location <- this.inherit("scripts/entity/world/location", {
	m = {
		SettlementName = "",
		SettlementSprite = ""
	},
	function getDescription()
	{
		return "Once a thriving human settlement, this place has been defiled and fallen into ruin, turned into a necropolis of the undead. Waves of walking corpses pour forth to spread terror and fear in the surrounding lands.";
	}

	function setSprite( _s )
	{
		this.m.SettlementSprite = _s;
		this.getSprite("body").setBrush(this.m.SettlementSprite + "_undead");
		this.getSprite("lighting").setBrush(this.m.SettlementSprite + "_undead_lights");
	}

	function setName( _n )
	{
		this.m.SettlementName = _n;
		this.world_entity.setName("Ruins of " + _n);
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.undead_necropolis";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.ruins";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Walls;
		this.m.CombatLocation.CutDownTrees = false;
		this.m.CombatLocation.ForceLineBattle = true;
		this.m.CombatLocation.AdditionalRadius = 5;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		local r = this.Math.rand(1, 3);
		this.setDefenderSpawnList(this.Const.World.Spawn.UndeadScourge);
		this.m.Resources = 350;
		this.m.NamedWeaponsList = this.Const.Items.NamedUndeadWeapons;
		this.m.NamedShieldsList = this.Const.Items.NamedUndeadShields;
	}

	function onSpawned()
	{
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(0, 500), _lootTable);
		this.dropTreasure(this.Math.rand(3, 4), [
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/signet_ring_item",
			"loot/white_pearls_item",
			"loot/golden_chalice_item",
			"loot/gemstones_item",
			"loot/ancient_gold_coins_item",
			"loot/jeweled_crown_item",
			"loot/ancient_gold_coins_item",
			"loot/ornate_tome_item"
		], _lootTable);
	}

	function onCombatLost()
	{
		this.getTile().spawnDetail(this.m.SettlementSprite + "_ruins", this.Const.World.ZLevel.Object - 3, 0, false);
		this.World.EntityManager.onWorldEntityDestroyed(this, true);
		this.world_entity.onCombatLost();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		local light = this.addSprite("lighting");
		this.setSpriteColorization("lighting", false);
		light.IgnoreAmbientColor = true;
		light.Alpha = 0;
		this.registerThinker();
	}

	function onFinish()
	{
		this.location.onFinish();
		this.unregisterThinker();
	}

	function onUpdate()
	{
		local lighting = this.getSprite("lighting");

		if (lighting.IsFadingDone)
		{
			if (lighting.Alpha == 0 && this.World.getTime().TimeOfDay >= 4 && this.World.getTime().TimeOfDay <= 7)
			{
				local insideScreen = this.World.getCamera().isInsideScreen(this.getPos(), 0);

				if (insideScreen)
				{
					lighting.fadeIn(5000);
				}
				else
				{
					lighting.Alpha = 255;
				}
			}
			else if (lighting.Alpha != 0 && this.World.getTime().TimeOfDay >= 0 && this.World.getTime().TimeOfDay <= 3)
			{
				local insideScreen = this.World.getCamera().isInsideScreen(this.getPos(), 0);

				if (insideScreen)
				{
					lighting.fadeOut(4000);
				}
				else
				{
					lighting.Alpha = 0;
				}
			}
		}
	}

	function onSerialize( _out )
	{
		this.location.onSerialize(_out);
		_out.writeString(this.m.SettlementName);
		_out.writeString(this.m.SettlementSprite);
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.m.SettlementName = _in.readString();
		this.m.SettlementSprite = _in.readString();
	}

});


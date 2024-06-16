this.send_peasants_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		Start = null,
		Dest = null
	},
	function create()
	{
		this.m.ID = "send_peasants_action";
		this.m.Cooldown = 300.0;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.FactionManager.isGreaterEvil())
		{
			return;
		}

		if (_faction.isEnemyNearby())
		{
			return;
		}

		if (_faction.getUnits().len() >= 1)
		{
			return;
		}

		local mySettlements = _faction.getSettlements();
		local allSettlements = this.World.EntityManager.getSettlements();
		local destinations;

		if (!this.World.FactionManager.isGreaterEvil())
		{
			destinations = allSettlements;
		}
		else
		{
			destinations = [];

			foreach( s in allSettlements )
			{
				if (s.getOwner() == null || s.getOwner().isAlliedWith(_faction.getID()))
				{
					destinations.push(s);
				}
			}
		}

		local settlements = this.getRandomConnectedSettlements(2, mySettlements, destinations, true);

		if (settlements.len() < 2)
		{
			return;
		}

		this.m.Start = settlements[0];
		this.m.Dest = settlements[1];

		if (this.World.FactionManager.isGreaterEvil())
		{
			this.m.Score = 1;
		}
		else
		{
			this.m.Score = 5;
		}
	}

	function onClear()
	{
		this.m.Start = null;
		this.m.Dest = null;
	}

	function onExecute( _faction )
	{
		local party;

		if (_faction.getType() == this.Const.FactionType.OrientalCityState)
		{
			party = _faction.spawnEntity(this.m.Start.getTile(), "Citoyens", false, this.Const.World.Spawn.PeasantsSouthern, this.Math.rand(30, 60));
			party.getSprite("body").setBrush("figure_civilian_06");
			party.setDescription("Fermiers, artisans, pèlerins ou autres citoyens des grandes villes qui voyagent de ville en ville.");
		}
		else
		{
			party = _faction.spawnEntity(this.m.Start.getTile(), "Paysants", false, this.Const.World.Spawn.Peasants, this.Math.rand(30, 60));
			party.getSprite("body").setBrush("figure_civilian_0" + this.Math.rand(1, 5));
			party.setDescription("Fermiers, artisans, pèlerins ou autres paysans qui voyagent de ville en ville.");
		}

		party.setFootprintType(this.Const.World.FootprintsType.Peasants);
		party.getSprite("banner").Visible = false;
		party.getFlags().set("IsRandomlySpawned", true);
		party.getLoot().Money = this.Math.rand(0, 50);
		local r = this.Math.rand(1, 4);

		if (r == 1)
		{
			party.addToInventory("supplies/bread_item");
		}
		else if (r == 2)
		{
			party.addToInventory("supplies/roots_and_berries_item");
		}
		else if (r == 3)
		{
			party.addToInventory("supplies/dried_fruits_item");
		}
		else if (r == 4)
		{
			party.addToInventory("supplies/ground_grains_item");
		}

		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Dest.getTile());
		move.setRoadsOnly(true);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(move);
		c.addOrder(despawn);
	}

});


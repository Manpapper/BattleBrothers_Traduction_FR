this.militia_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.militia";
		this.m.Name = "Milice Paysanne";
		this.m.Description = "[p=c][img]gfx/ui/events/event_141.png[/img][/p][p]Ça a commencé avec une milice en guenille composée de courageux ou de personnes assez désespérées pour se proposer à défendre leurs maisons, mais qui a grossi pour devenir une petite armée. Une armée qui a besoin d\'être nourri tous les jours. Peut-être que les services de la milice pouraient être loués ?\n[color=#bcad8c]Armée Paysanne :[/color] Commencez avec une compagnie de 12 paysans très mal équipés.\n[color=#bcad8c]Vague Humaine[/color] : Emmenez jusqu\'à 16 hommes en bataille en même temps, et ayez jusqu\'à 25 hommes dans votre compagnie.\n[color=#bcad8c]Sales Paysans[/color] : Vous pouvez engager seulement des paysans de naissance.[/p]";
		this.m.Difficulty = 1;
		this.m.Order = 20;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 12; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.worsenMood(1.5, "Lost many a friend in battle");
			bro.improveMood(0.5, "Part of a militia");
			bro.m.HireTime = this.Time.getVirtualTimeF();

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"farmhand_background"
		]);
		bros[0].getBackground().m.RawDescription = "%name% is a farmer\'s son, and presumably wishes to be the father of his own son at some point. For now, he\'s with you which is quite a regrettable clash between dreams and reality.";
		bros[0].improveMood(3.0, "Has recently fallen in love");
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/pitchfork"));
		bros[1].setStartValuesEx([
			"farmhand_background"
		]);
		bros[1].getBackground().m.RawDescription = "%name% owned a farmstead that has long since gone underfoot of countless passing armies, including the very ones he has fought for. His \'allegiance\' to you is arguably the result of an empty belly more than anything.";
		bros[1].worsenMood(0.5, "Was involved in a brawl");
		bros[1].addLightInjury();
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/warfork"));
		bros[2].setStartValuesEx([
			"poacher_background"
		]);
		bros[2].getBackground().m.RawDescription = "It is a common joke that %name% is in fact a nobleman hiding away from the world, but to the best of your knowledge he was a simple poacher. The grind of the world got him to where he is today, not much else need be said other than you hope he gets back on his feet.";
		bros[2].worsenMood(0.5, "Was involved in a brawl");
		bros[2].addLightInjury();
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/staff_sling"));
		bros[3].setStartValuesEx([
			"vagabond_background",
			"thief_background",
			"gambler_background"
		]);
		bros[3].getBackground().m.RawDescription = "You notice that %name% hides from certain noblemen. It is likely that he is a common criminal at large for some petty crime, but so long as he fights well it is no business to you.";
		bros[3].improveMood(1.5, "Stole someone\'s scramasax");
		items = bros[3].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/scramasax"));
		bros[4].setStartValuesEx([
			"daytaler_background"
		]);
		bros[4].getBackground().m.RawDescription = "A daytaler and common laborer, %name% would rather join your outfit than go back to wasting his body building some nobleman\'s new fancy foyer.";
		bros[4].worsenMood(0.5, "Was involved in a brawl");
		bros[4].addLightInjury();
		bros[5].setStartValuesEx([
			"miller_background"
		]);
		bros[5].getBackground().m.RawDescription = "Seeking riches, %name% has come to the right place in your newfound mercenary band. Unfortunately, his background is in farming, milling, and laying stone, particularly none of which he was any good at.";
		bros[5].improveMood(1.0, "Looks forward to becoming rich as a sellsword");
		local items = bros[5].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/pitchfork"));
		bros[6].setStartValuesEx([
			"fisherman_background"
		]);
		bros[6].getBackground().m.RawDescription = "%name% states he was a sailor prior to coming inland and falling in with the militia and now your mercenary band. He hopes to eventually own a boat and put its sails to the open ocean. You hope he can do that someday, truly.";
		bros[6].worsenMood(0.25, "Feels somewhat sickly of late");
		bros[7].setStartValuesEx([
			"militia_background"
		]);
		bros[7].getBackground().m.RawDescription = "%name% has apparently been in many militias, all of which eventually dissolved for one reason or another. At no point has he made any money in any of them, so he hopes to changes that with this whole new sellswording schtick.";
		bros[7].improveMood(3.0, "Has recently become a father");
		bros[7].m.PerkPoints = 0;
		bros[7].m.LevelUps = 0;
		bros[7].m.Level = 1;
		bros[8].setStartValuesEx([
			"minstrel_background"
		]);
		bros[8].getBackground().m.RawDescription = "A proper lad, %name% enjoys carousing ladies at the pub and chasing skirt in the church. You get the sense he\'s only tagged along to spread his sense of \'fun\' around the world.";
		local items = bros[8].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/lute"));
		bros[9].setStartValuesEx([
			"daytaler_background"
		]);
		bros[9].getBackground().m.RawDescription = "Daytaler, laborer, caravan hand, sailor, militiaman, %name%\'s done a bit of it all. Hopefully this new foray into mercenary work will stick for him.";
		bros[9].worsenMood(1.0, "Had his trusty scramasax stolen");
		bros[10].setStartValuesEx([
			"militia_background"
		]);
		bros[10].getBackground().m.RawDescription = "Like yourself, %name% was fed up with militias being overused to solve the crises of unprepared nobles. He was arguably the most earnest of the men in joining the transition to mercenary work.";
		bros[10].worsenMood(0.5, "Disliked that some members of the militia were involved in a brawl");
		bros[10].m.PerkPoints = 0;
		bros[10].m.LevelUps = 0;
		bros[10].m.Level = 1;
		bros[11].setStartValuesEx([
			"butcher_background",
			"tailor_background",
			"shepherd_background"
		]);
		bros[11].getBackground().m.RawDescription = "%name% is, ostensibly, running away from his wife. You met her once and approve his escape plan entirely, and not just because it affords you another body on the front line.That wench is genuinely crazy.";
		bros[11].improveMood(1.0, "Managed to get away from his wife");
		this.World.Assets.m.BusinessReputation = -100;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 9);
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2;
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 2;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo / 2;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() == 1)
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		this.World.Flags.set("HomeVillage", randomVillage.getName());
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else if (tile.Type != this.Const.World.TerrainType.Plains && tile.Type != this.Const.World.TerrainType.Steppe && tile.Type != this.Const.World.TerrainType.Tundra && tile.Type != this.Const.World.TerrainType.Snow)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(8);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		randomVillage.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(40.0, "Considered local heroes for keeping the village safe");
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/retirement_01.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.militia_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 25;
		this.World.Assets.m.BrothersMaxInCombat = 16;
		this.World.Assets.m.BrothersScaleMax = 14;
	}

	function onUpdateHiringRoster( _roster )
	{
		local garbage = [];
		local bros = _roster.getAll();

		foreach( i, bro in bros )
		{
			if (!bro.getBackground().isLowborn())
			{
				garbage.push(bro);
			}
		}

		foreach( g in garbage )
		{
			_roster.remove(g);
		}
	}

});


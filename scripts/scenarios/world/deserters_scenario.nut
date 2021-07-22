this.deserters_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.deserters";
		this.m.Name = "Déserteurs";
		this.m.Description = "[p=c][img]gfx/ui/events/event_88.png[/img][/p][p]Pendant trop longtemps vous avez été traîné d\'une bataille sanglante à une autre au bon vouloir des seigneurs restant dans leurs hautes tours. La nuit dernière, vous vous êtes enfuit de votre camp avec 3 compères. Vous êtes toujours habillés comme des soldats, mais vous êtes des déserteurs, et la corde sera votre fin si vous restez ici trop longtemps.\n\n[color=#bcad8c]Déserteurs:[/color] Commencez avec 3 déserteurs et des armures décentes, mais peu de fonds et une Maison de Noble qui vous traque.\n[color=#bcad8c]Premiers à courrir:[/color] Vos hommes sont toujours les premiers à agir dans le premier tour d\'un combat.[/p]";
		this.m.Difficulty = 2;
		this.m.Order = 50;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function setupBro( _bro, _faction )
	{
		_bro.setStartValuesEx([
			"deserter_background"
		]);
		_bro.worsenMood(1.0, "Was dragged from one bloody battle to the next");
		_bro.improveMood(1.5, "Deserted from the army");
		_bro.m.HireTime = this.Time.getVirtualTimeF();
		_bro.m.Talents = [];
		_bro.m.Attributes = [];
		_bro.m.Talents.resize(this.Const.Attributes.COUNT, 0);

		if (this.Math.rand(1, 100) <= 50)
		{
			_bro.addHeavyInjury();
		}
		else if (this.Math.rand(1, 100) <= 50)
		{
			_bro.addLightInjury();
		}

		local items = _bro.getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		local shield = this.new("scripts/items/shields/faction_heater_shield");
		shield.setFaction(_faction.getBanner());
		items.equip(shield);

		if (this.Math.rand(1, 100) <= 33 && items.getItemAtSlot(this.Const.ItemSlot.Head) != null)
		{
			items.getItemAtSlot(this.Const.ItemSlot.Head).setCondition(items.getItemAtSlot(this.Const.ItemSlot.Head).getConditionMax() * 0.5);
		}

		if (this.Math.rand(1, 100) <= 33 && items.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
		{
			items.getItemAtSlot(this.Const.ItemSlot.Mainhand).setCondition(items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getConditionMax() * 0.5);
		}

		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		local armor;
		local r = this.Math.rand(1, 5);

		if (r == 1)
		{
			armor = this.new("scripts/items/armor/mail_hauberk");
			armor.setVariant(28);
		}
		else if (r == 2)
		{
			armor = this.new("scripts/items/armor/mail_shirt");
		}
		else if (r == 3)
		{
			armor = this.new("scripts/items/armor/gambeson");
		}
		else
		{
			armor = this.new("scripts/items/armor/basic_mail_shirt");
		}

		armor.setCondition(armor.getConditionMax() * this.Math.rand(25, 100) * 0.01);
		items.equip(armor);
	}

	function onSpawnAssets()
	{
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.m.BusinessReputation = 150;
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && !randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 7), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 7));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 7), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 7));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 4)
				{
				}
				else if (!tile.HasRoad || tile.Type == this.Const.World.TerrainType.Shore)
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
		this.World.Assets.updateLook(12);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		local f = randomVillage.getFactionOfType(this.Const.FactionType.NobleHouse);
		f.addPlayerRelation(-100.0, "You and your men deserted");
		local names = [];

		for( local i = 0; i < 3; i = ++i )
		{
			while (true)
			{
				local n = this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)];

				if (names.find(n) == null)
				{
					names.push(n);
					break;
				}
			}
		}

		local roster = this.World.getPlayerRoster();

		for( local i = 0; i < 3; i = ++i )
		{
			local bro = roster.create("scripts/entity/tactical/player");
			bro.setName(names[i]);
			bro.setPlaceInFormation(3 + i);
			this.setupBro(bro, f);
		}

		local bros = roster.getAll();
		bros[0].getBackground().m.RawDescription = "{Prior to his conscription into the army, %name% was a failed, illiterate baker. His poor work and frequent dessert errors made him prone to being pulled into military ranks. Having always hated the life, the deserter was quick to join your cause and company.}";
		bros[0].getBackground().buildDescription(true);
		local talents = bros[0].getTalents();
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.Hitpoints] = 1;
		talents[this.Const.Attributes.Fatigue] = 1;
		bros[0].m.PerkPoints = 1;
		bros[0].m.LevelUps = 1;
		bros[0].m.Level = 2;
		bros[0].m.XP = this.Const.LevelXP[bros[0].m.Level - 1];
		bros[0].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
		items.equip(this.new("scripts/items/weapons/hatchet"));
		bros[1].getBackground().m.RawDescription = "{A fine fighter by any judgment, %name% simply hated the low pay of being a soldier in the army. His pursuit of the sellsword\'s life makes sense. Though he is quite flighty, you believe his transient sense of allegiance will be buffered by a steady flow of good coin.}";
		bros[1].getBackground().buildDescription(true);
		local talents = bros[1].getTalents();
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.MeleeDefense] = 1;
		talents[this.Const.Attributes.Bravery] = 1;
		bros[1].m.PerkPoints = 0;
		bros[1].m.LevelUps = 0;
		bros[1].m.Level = 1;
		bros[1].m.XP = this.Const.LevelXP[bros[1].m.Level - 1];
		bros[1].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
		items.equip(this.new("scripts/items/weapons/shortsword"));
		bros[2].getBackground().m.RawDescription = "{%name% is like many deserters. You can see the spirit of a fighter in him, but the heart for it is withering. It doesn\'t make him a coward, as many assume deserters to be, but instead simply a man who may need change. Hopefully the coin of mercenary work can provide it.}";
		bros[2].getBackground().buildDescription(true);
		local talents = bros[2].getTalents();
		talents[this.Const.Attributes.RangedSkill] = 2;
		talents[this.Const.Attributes.RangedDefense] = 1;
		talents[this.Const.Attributes.Initiative] = 1;
		bros[2].m.PerkPoints = 1;
		bros[2].m.LevelUps = 1;
		bros[2].m.Level = 2;
		bros[2].m.XP = this.Const.LevelXP[bros[2].m.Level - 1];
		bros[2].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
		items.equip(this.new("scripts/items/weapons/light_crossbow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/retirement_02.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.deserters_scenario_intro");
		}, null);
	}

});


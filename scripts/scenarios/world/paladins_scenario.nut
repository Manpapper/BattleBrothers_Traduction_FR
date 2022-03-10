this.paladins_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.paladins";
		this.m.Name = "Oathtakers";
		this.m.Description = "[p=c][img]gfx/ui/events/event_180.png[/img][/p][p]Oathtakers are knightly warriors beholden not to liege lords, but to the ideals and teachings of their founder, Young Anselm. The order now finds itself in dire straits, and they\'ve turned to you to reverse their fortunes. Can you teach these zealots to become successful mercenaries?\n\n[color=#bcad8c]Paladins:[/color] Start with two battle-hardened warriors and good equipment.\n[color=#bcad8c]Oathtakers:[/color] Sworn to Young Anselm\'s teachings, you must take oaths that confer various advantages and disadvantages until fulfilled.[/p]";
		this.m.Difficulty = 2;
		this.m.Order = 40;
		this.m.IsFixedLook = true;
	}

	function isValid()
	{
		return this.Const.DLC.Paladins;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 2; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"old_paladin_background"
		]);
		bros[0].getBackground().m.RawDescription = "{Perhaps of an age more suitable for caretaking than oathtaking, %name% is a rather old, nigh on decrepit Oathtaker. While age has robbed him of his more natural talents, it has at least gifted him with learning and experience that no physical capabilities can match. He is a man of many spirits, having gone around this world in the shell of soldier, farmer, sellsword, and more. Now he is an Oathtaker, and all those skills and traits he built up over the years has made him quite a formidable one at that. | When First Oathtaker Anselm first met %name%, it is said that the prime paladin divulged details no one else could have possibly known, thus proving the aethereal power behind his beliefs. %name% is an ardent believer in the Oaths, and in seeing Young Anselm\'s vision through.}";
		bros[0].setPlaceInFormation(4);
		bros[0].m.PerkPoints = 2;
		bros[0].m.LevelUps = 2;
		bros[0].m.Level = 3;
		bros[0].getSkills().add(this.new("scripts/skills/traits/old_trait"));
		bros[0].m.Talents = [];
		local talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Bravery] = 3;
		talents[this.Const.Attributes.MeleeSkill] = 1;
		talents[this.Const.Attributes.RangedDefense] = 2;
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items.equip(this.new("scripts/items/helmets/heavy_mail_coif"));
		items.equip(this.new("scripts/items/armor/adorned_mail_shirt"));
		items.equip(this.new("scripts/items/accessory/oathtaker_skull_01_item"));
		local banner = this.new("scripts/items/tools/player_banner");
		banner.setVariant(this.World.Assets.getBannerID());
		items.equip(banner);
		bros[1].setStartValuesEx([
			"paladin_background"
		]);
		bros[1].getBackground().m.RawDescription = "{%name%, like many of the Oathtakers\' more spry members, strives to be like Young Anselm. A youthful, capable man who has yet to let the world\'s horrors and grind wear him down. In moments of honesty, he reminds you of yourself. In moments of reflection, you realize that he will likely one day resemble you as you are now. But until then, to the youth of the world, for the Oaths are certainly not wasted upon them! | When Anselm set out on his quest, it was %name% whom joined him first. Despite the Young Anselm\'s untimely death, %name% still sought to see the young man\'s vision through. He is an ardent believer in the Oaths and can be frequently found idolizing and commemorating Young Anselm\'s skull.}";
		bros[1].setPlaceInFormation(5);
		bros[1].m.PerkPoints = 0;
		bros[1].m.LevelUps = 0;
		bros[1].m.Level = 1;
		bros[1].m.Talents = [];
		talents = bros[1].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Initiative] = 3;
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.MeleeDefense] = 1;
		items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items.equip(this.new("scripts/items/helmets/adorned_closed_flat_top_with_mail"));
		items.equip(this.new("scripts/items/armor/adorned_warriors_armor"));
		items.equip(this.new("scripts/items/weapons/arming_sword"));
		local shield = this.new("scripts/items/shields/heater_shield");
		shield.onPaintInCompanyColors();
		items.equip(shield);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.m.MoralReputation = 60.0;

		if (!this.Const.DLC.Desert)
		{
			this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 27);
		}

		this.World.Assets.m.Money = this.World.Assets.m.Money - 1000;
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 2;
		this.World.Assets.m.Ammo = this.World.Assets.m.Medicine / 2;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3 && !randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
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

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
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
		this.World.Assets.updateLook(19);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.IntroTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.paladins_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 18;
	}

	function onHired( _bro )
	{
		if (this.World.Ambitions.hasActiveAmbition())
		{
			switch(this.World.Ambitions.getActiveAmbition().getID())
			{
			case "ambition.oath_of_humility":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_humility_trait"));
				break;

			case "ambition.oath_of_valor":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_valor_trait"));
				break;

			case "ambition.oath_of_endurance":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_endurance_trait"));
				break;

			case "ambition.oath_of_vengeance":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_vengeance_trait"));
				break;

			case "ambition.oath_of_righteousness":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_righteousness_trait"));
				break;

			case "ambition.oath_of_dominion":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_dominion_trait"));
				break;

			case "ambition.oath_of_wrath":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_wrath_trait"));
				break;

			case "ambition.oath_of_honor":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_honor_trait"));
				_bro.getSkills().add(this.new("scripts/skills/special/oath_of_honor_warning"));
				break;

			case "ambition.oath_of_camaraderie":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_camaraderie_trait"));
				break;

			case "ambition.oath_of_sacrifice":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_sacrifice_trait"));
				break;

			case "ambition.oath_of_fortification":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_fortification_trait"));
				_bro.getSkills().add(this.new("scripts/skills/special/oath_of_fortification_warning"));
				break;

			case "ambition.oath_of_distinction":
				_bro.getSkills().add(this.new("scripts/skills/traits/oath_of_distinction_trait"));
				_bro.getFlags().set("OathtakersDistinctionLevelUps", 0);
				break;
			}
		}
	}

	function onUpdateLevel( _bro )
	{
		if (!this.World.Ambitions.hasActiveAmbition())
		{
			return;
		}

		if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_distinction")
		{
			_bro.getFlags().increment("OathtakersDistinctionLevelUps");
		}
	}

	function onActorKilled( _actor, _killer, _combatID )
	{
		if (!this.World.Ambitions.hasActiveAmbition())
		{
			return;
		}

		if (_killer != null && _killer.getFaction() != this.Const.Faction.Player && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
		{
			if (_actor.isPlayerControlled && this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_fortification")
			{
				this.World.Statistics.getFlags().increment("OathtakersBrosDead");
			}

			return;
		}

		if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_honor")
		{
			if (_actor.getTile().getZoneOfControlCountOtherThan(_actor.getAlliedFactions()) == 1)
			{
				this.World.Statistics.getFlags().increment("OathtakersSoloKills");
			}

			return;
		}

		switch(_actor.getType())
		{
		case this.Const.EntityType.Necromancer:
		case this.Const.EntityType.Zombie:
		case this.Const.EntityType.ZombieYeoman:
		case this.Const.EntityType.ZombieKnight:
		case this.Const.EntityType.ZombieBetrayer:
		case this.Const.EntityType.Ghost:
		case this.Const.EntityType.ZombieBoss:
		case this.Const.EntityType.SkeletonLight:
		case this.Const.EntityType.SkeletonMedium:
		case this.Const.EntityType.SkeletonHeavy:
		case this.Const.EntityType.SkeletonPriest:
		case this.Const.EntityType.SkeletonBoss:
		case this.Const.EntityType.Vampire:
		case this.Const.EntityType.SkeletonLich:
			if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_righteousness")
			{
				this.World.Statistics.getFlags().increment("OathtakersUndeadSlain");
			}
			else if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_wrath")
			{
				this.World.Statistics.getFlags().increment("OathtakersWrathSlain");
			}

			break;

		case this.Const.EntityType.OrcYoung:
		case this.Const.EntityType.OrcWarrior:
		case this.Const.EntityType.OrcBerserker:
		case this.Const.EntityType.OrcWarlord:
		case this.Const.EntityType.GoblinAmbusher:
		case this.Const.EntityType.GoblinFighter:
		case this.Const.EntityType.GoblinWolfrider:
		case this.Const.EntityType.GoblinLeader:
		case this.Const.EntityType.GoblinShaman:
			if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_vengeance")
			{
				this.World.Statistics.getFlags().increment("OathtakersGreenskinsSlain");
			}
			else if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_wrath")
			{
				this.World.Statistics.getFlags().increment("OathtakersWrathSlain");
			}

			break;

		case this.Const.EntityType.Direwolf:
		case this.Const.EntityType.Lindwurm:
		case this.Const.EntityType.Unhold:
		case this.Const.EntityType.UnholdFrost:
		case this.Const.EntityType.UnholdBog:
		case this.Const.EntityType.BarbarianUnhold:
		case this.Const.EntityType.BarbarianUnholdFrost:
		case this.Const.EntityType.Spider:
		case this.Const.EntityType.Ghoul:
		case this.Const.EntityType.Alp:
		case this.Const.EntityType.Hexe:
		case this.Const.EntityType.Schrat:
		case this.Const.EntityType.Kraken:
		case this.Const.EntityType.TricksterGod:
		case this.Const.EntityType.Serpent:
		case this.Const.EntityType.SandGolem:
		case this.Const.EntityType.Hyena:
			if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_dominion")
			{
				this.World.Statistics.getFlags().increment("OathtakersBeastsSlain");
			}
			else if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_wrath")
			{
				this.World.Statistics.getFlags().increment("OathtakersWrathSlain");
			}

			break;

		case this.Const.EntityType.BountyHunter:
		case this.Const.EntityType.Mercenary:
		case this.Const.EntityType.Swordmaster:
		case this.Const.EntityType.HedgeKnight:
		case this.Const.EntityType.MasterArcher:
		case this.Const.EntityType.Cultist:
		case this.Const.EntityType.Footman:
		case this.Const.EntityType.Greatsword:
		case this.Const.EntityType.Billman:
		case this.Const.EntityType.Arbalester:
		case this.Const.EntityType.StandardBearer:
		case this.Const.EntityType.Sergeant:
		case this.Const.EntityType.Knight:
		case this.Const.EntityType.BanditThug:
		case this.Const.EntityType.BanditRaider:
		case this.Const.EntityType.BanditPoacher:
		case this.Const.EntityType.BanditMarksman:
		case this.Const.EntityType.BanditLeader:
		case this.Const.EntityType.BarbarianThrall:
		case this.Const.EntityType.BarbarianMarauder:
		case this.Const.EntityType.BarbarianChampion:
		case this.Const.EntityType.BarbarianChosen:
		case this.Const.EntityType.BarbarianDrummer:
		case this.Const.EntityType.BarbarianBeastmaster:
		case this.Const.EntityType.NomadCutthroat:
		case this.Const.EntityType.NomadOutlaw:
		case this.Const.EntityType.NomadSlinger:
		case this.Const.EntityType.NomadArcher:
		case this.Const.EntityType.NomadLeader:
		case this.Const.EntityType.DesertDevil:
		case this.Const.EntityType.Executioner:
		case this.Const.EntityType.DesertStalker:
		case this.Const.EntityType.Slave:
		case this.Const.EntityType.Conscript:
		case this.Const.EntityType.Officer:
		case this.Const.EntityType.Gunner:
		case this.Const.EntityType.Engineer:
		case this.Const.EntityType.Gladiator:
		case this.Const.EntityType.Assassin:
		case this.Const.EntityType.Oathbringer:
			if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_wrath")
			{
				this.World.Statistics.getFlags().increment("OathtakersWrathSlain");
			}

			break;
		}
	}

	function onBattleWon( _combatLoot )
	{
		if (!this.World.Ambitions.hasActiveAmbition())
		{
			return;
		}

		if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_valor" && this.World.Statistics.getFlags().getAsInt("LastEnemiesDefeatedCount") > this.World.Statistics.getFlags().getAsInt("LastPlayersAtBattleStartCount"))
		{
			this.World.Statistics.getFlags().increment("OathtakersDefeatedOutnumbering");
		}

		if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_endurance" && this.World.Statistics.getFlags().getAsInt("LastCombatResult") == 1)
		{
			this.World.Statistics.getFlags().increment("OathtakersBattlesWon");
		}
	}

	function onContractFinished( _contractType, _cancelled )
	{
		if (!this.World.Ambitions.hasActiveAmbition())
		{
			return;
		}

		if (_contractType == "contract.arena" || _contractType == "contract.arena_tournament")
		{
			return;
		}

		if (!_cancelled && this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_humility")
		{
			this.World.Statistics.getFlags().increment("OathtakersContractsComplete");
		}
	}

});


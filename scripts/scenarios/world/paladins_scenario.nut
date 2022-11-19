this.paladins_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.paladins";
		this.m.Name = "Prêteurs de Serments";
		this.m.Description = "[p=c][img]gfx/ui/events/event_180.png[/img][/p][p]Les Prêteurs de Serments sont des guerriers chevaleresques redevables non pas aux seigneurs, mais aux idéaux et aux enseignements de leur fondateur, le Jeune Anselm. L\'ordre se trouve maintenant dans une situation difficile, et ils se sont tournés vers vous pour changer leur destin. Pouvez-vous apprendre à ces fanatiques à devenir de bons mercenaires ?\n[color=#bcad8c]Paladins:[/color] Commencez avec deux guerriers aguerris et un bon équipement.\n[color=#bcad8c]Prêteurs de Serments:[/color] En prêtant serment aux enseignements du jeune Anselm, vous devez choisir des serments qui confèrent divers avantages et désavantages jusqu\'à ce qu\'ils soient accomplis.[/p]";
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
		bros[0].getBackground().m.RawDescription = "{Peut-être d\'un âge plus adapté à la garde qu\'au serment %name% est un Prêteur de Serments plutôt vieux, presque décrépit. Si l\'âge l\'a privé de ses talents les plus naturels, il l\'a au moins doté d\'un apprentissage et d\'une expérience qu\'aucune capacité physique ne peut égaler. C\'est un homme d\'esprit, qui a parcouru le monde en tant que soldat, fermier, mercenaire, et plus encore. Aujourd\'hui, c\'est en tant que Prêteur de Serments, et toutes ces compétences et caractéristiques qu\'il a acquises au fil des ans en ont fait un homme redoutable. | Lorsque le Premier Prêteur de Serments Anselm a rencontré %name% pour la première fois, on dit que le premier paladin a divulgué des détails que personne d\'autre n\'aurait pu connaître, prouvant ainsi le pouvoir éthéré derrière ses croyances. %name% est un fervent croyant dans les serments et dans la réalisation de la vision du jeune Anselm.}";
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
		bros[1].getBackground().m.RawDescription = "{%name%, comme beaucoup de membres des Prêteurs de Serments, s\'efforce d\'être comme le jeune Anselm. Un homme jeune et compétent qui n\'a pas encore laissé les horreurs et les difficultés du monde le consumer. Dans les moments d\'honnêteté, il vous rappelle vous-même. Dans les moments de réflexion, vous réalisez qu\'il vous ressemblera probablement un jour tel que vous êtes maintenant. Mais d\'ici là, à la jeunesse du monde, car les serments ne sont certainement pas gaspillés pour eux ! | Quand Anselm s\'est lancé dans sa quête, c\'est %name% qui l\'a rejoint en premier. Malgré la mort prématurée du Jeune Anselm, %name% a toujours cherché à concrétiser la vision du jeune homme. Il est un fervent adepte des Serments et on le retrouve souvent en train d\'idolâtrer et de commémorer le crâne du Jeune Anselm.}";
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
		this.World.Assets.addMoralReputation(10.0);

		if (!this.Const.DLC.Desert)
		{
			this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 27);
		}

		this.World.Assets.m.Money = this.World.Assets.m.Money - 1000;
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

		if (_killer == null || _killer.getFaction() != this.Const.Faction.Player && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
		{
			if (_actor.isPlayerControlled() && this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_fortification")
			{
				this.World.Statistics.getFlags().increment("OathtakersBrosDead");
			}

			return;
		}

		if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_honor")
		{
			if (_actor.getTile().getZoneOfControlCountOtherThan(_actor.getAlliedFactions()) <= 1)
			{
				this.World.Statistics.getFlags().increment("OathtakersSoloKills");
			}

			return;
		}

		local actorFaction = this.Const.EntityType.getDefaultFaction(_actor.getType());

		if (actorFaction == this.Const.FactionType.Zombies || actorFaction == this.Const.FactionType.Undead)
		{
			if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_righteousness")
			{
				this.World.Statistics.getFlags().increment("OathtakersUndeadSlain");
			}
		}
		else if (actorFaction == this.Const.FactionType.Goblins || actorFaction == this.Const.FactionType.Orcs)
		{
			if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_vengeance")
			{
				this.World.Statistics.getFlags().increment("OathtakersGreenskinsSlain");
			}
		}
		else if (actorFaction == this.Const.FactionType.Beasts || _actor.getType() == this.Const.EntityType.BarbarianUnhold || _actor.getType() == this.Const.EntityType.BarbarianUnholdFrost)
		{
			if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_dominion")
			{
				this.World.Statistics.getFlags().increment("OathtakersBeastsSlain");
			}
		}
		
		if (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_wrath")
		{
			this.World.Statistics.getFlags().increment("OathtakersWrathSlain");
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


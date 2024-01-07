this.decisive_battle_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Warcamp = null,
		WarcampTile = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.decisive_battle";
		this.m.Name = "The Battle";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		if (this.m.WarcampTile == null)
		{
			local settlements = this.World.EntityManager.getSettlements();
			local lowest_distance = 99999;
			local best_settlement;
			local myTile = this.m.Home.getTile();

			foreach( s in settlements )
			{
				if (this.World.FactionManager.isAllied(this.getFaction(), s.getFaction()))
				{
					continue;
				}

				local d = s.getTile().getDistanceTo(myTile);

				if (d < lowest_distance)
				{
					lowest_distance = d;
					best_settlement = s;
				}
			}

			this.m.WarcampTile = myTile.getTileBetweenThisAnd(best_settlement.getTile());
			this.m.Flags.set("EnemyNobleHouse", best_settlement.getOwner().getID());
		}

		this.m.Flags.set("CommanderName", this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]);
		this.m.Payment.Pool = 1600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("RequisitionCost", this.beautifyNumber(this.m.Payment.Pool * 0.25));
		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * 0.35));
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Allez au camps de guerre et présentez vous devant  %commander%",
					"Aidez l\'armée dans leur bataille contre %feudfamily%"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).addPlayerRelation(-99.0, "Took sides in the war");

				if (this.Contract.m.WarcampTile == null)
				{
					local settlements = this.World.EntityManager.getSettlements();
					local lowest_distance = 99999;
					local best_settlement;
					local myTile = this.Contract.m.Home.getTile();

					foreach( s in settlements )
					{
						if (this.World.FactionManager.isAllied(this.Contract.getFaction(), s.getFaction()))
						{
							continue;
						}

						local d = s.getTile().getDistanceTo(myTile);

						if (d < lowest_distance)
						{
							lowest_distance = d;
							best_settlement = s;
						}
					}

					this.Contract.m.WarcampTile = myTile.getTileBetweenThisAnd(best_settlement.getTile());
				}

				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.WarcampTile, 1, 12, [
					this.Const.World.TerrainType.Shore,
					this.Const.World.TerrainType.Ocean,
					this.Const.World.TerrainType.Mountains,
					this.Const.World.TerrainType.Forest,
					this.Const.World.TerrainType.LeaveForest,
					this.Const.World.TerrainType.SnowyForest,
					this.Const.World.TerrainType.AutumnForest,
					this.Const.World.TerrainType.Swamp
				], false, false, true);
				tile.clear();
				this.Contract.m.WarcampTile = tile;
				this.Contract.m.Warcamp = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/noble_camp_location", tile.Coords));
				this.Contract.m.Warcamp.onSpawned();
				this.Contract.m.Warcamp.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall());
				this.Contract.m.Warcamp.setFaction(this.Contract.getFaction());
				this.Contract.m.Warcamp.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Warcamp.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 40)
				{
					this.Flags.set("IsScoutsSighted", true);
				}
				else
				{
					this.Flags.set("IsRequisitionSupplies", true);
					r = this.Math.rand(1, 100);

					if (r <= 33)
					{
						this.Flags.set("IsAmbush", true);
					}
					else if (r <= 66)
					{
						this.Flags.set("IsUnrulyFarmers", true);
					}
					else
					{
						this.Flags.set("IsCooperativeFarmers", true);
					}
				}

				r = this.Math.rand(1, 100);

				if (r <= 40)
				{
					if (this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getSettlements().len() >= 2)
					{
						this.Flags.set("IsInterceptSupplies", true);
						local myTile = this.Contract.m.Warcamp.getTile();
						local settlements = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getSettlements();
						local lowest_distance = 99999;
						local highest_distance = 0;
						local best_start;
						local best_dest;

						foreach( s in settlements )
						{
							if (s.isIsolated())
							{
								continue;
							}

							local d = s.getTile().getDistanceTo(myTile);

							if (d < lowest_distance)
							{
								lowest_distance = d;
								best_dest = s;
							}

							if (d > highest_distance)
							{
								highest_distance = d;
								best_start = s;
							}
						}

						this.Flags.set("InterceptSuppliesStart", best_start.getID());
						this.Flags.set("InterceptSuppliesDest", best_dest.getID());
					}
				}
				else if (r <= 80)
				{
					this.Flags.set("IsDeserters", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Allez au camps de guerre et présentez vous devant %commander%"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp) && !this.Flags.get("IsWarcampDay1Shown"))
				{
					this.Flags.set("IsWarcampDay1Shown", true);
					this.Contract.setScreen("WarcampDay1");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_WaitForNextDay",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Attendez dans le camp de guerre que vos services soient demandés"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					if (this.World.getTime().Days > this.Flags.get("LastDay"))
					{
						if (this.Flags.get("NextDay") == 2)
						{
							this.Contract.setScreen("WarcampDay2");
						}
						else
						{
							this.Contract.setScreen("WarcampDay3");
						}

						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_Scouts",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Interceptez les eclaireurs de %feudfamily% vu pour la dernière fois %direction% du camp de guerre",
					"Ne laissez personne en réchappé vivant"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithScouts.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsScoutsFailed"))
					{
						this.Contract.setScreen("ScoutsEscaped");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("ScoutsCaught");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsScoutsRetreat"))
				{
					this.Flags.set("IsScoutsRetreat", false);
					this.Contract.m.Destination.die();
					this.Contract.m.Destination = null;
					this.Contract.setScreen("ScoutsEscaped");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithScouts( _dest, _isPlayerAttacking = true )
			{
				local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				properties.CombatID = "Scouts";
				properties.Music = this.Const.Music.NobleTracks;
				properties.EnemyBanners = [
					this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall()
				];
				this.World.Contracts.startScriptedCombat(properties, _isPlayerAttacking, true, true);
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsFailed", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsRetreat", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterScouts",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez au camp de guerre"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp) && !this.Flags.get("IsReportAfterScoutsShown"))
				{
					this.Flags.set("IsReportAfterScoutsShown", true);
					this.Contract.setScreen("WarcampDay1End");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Requisition",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Récuperez les provisions à %objective% %direction% du camp de guerre"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Destination) && !this.TempFlags.get("IsReportAfterRequisitionShown"))
				{
					this.TempFlags.set("IsReportAfterRequisitionShown", true);
					this.Contract.setScreen("RequisitionSupplies2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRequisitionRetreat") && !this.Flags.get("IsRequisitionCombatDone"))
				{
					this.Flags.set("IsRequisitionCombatDone", true);
					this.Contract.setScreen("BeatenByFarmers");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRequisitionVictory") && !this.Flags.get("IsRequisitionCombatDone"))
				{
					this.Flags.set("IsRequisitionCombatDone", true);
					this.Contract.setScreen("PoorFarmers");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Ambush" || _combatID == "TakeItByForce")
				{
					this.Flags.set("IsRequisitionRetreat", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Ambush" || _combatID == "TakeItByForce")
				{
					this.Flags.set("IsRequisitionVictory", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterRequisition",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez au camp de guerre"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					if (this.Flags.get("IsInterceptSupplies") || this.Flags.get("IsDeserters"))
					{
						this.Contract.setScreen("WarcampDay1End");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("WarcampDay2End");
						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_InterceptSupplies",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Interceptez les provisions en route pour %supply_dest% en provenance de %supply_start%"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setVisibleInFogOfWar(true);
				}
			}

			function update()
			{
				if (this.Flags.get("IsInterceptSuppliesSuccess"))
				{
					this.Contract.setScreen("SuppliesIntercepted");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination != null && this.Contract.m.Destination.isNull())
				{
					this.Flags.set("IsInterceptSuppliesFailure", true);
					this.Contract.setScreen("SuppliesReachedEnemy");
					this.World.Contracts.showActiveContract();
				}
			}

			function onPartyDestroyed( _party )
			{
				if (_party.getFlags().has("ContractSupplies"))
				{
					this.Flags.set("IsInterceptSuppliesSuccess", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterIntercept",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez au camp de guerre"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					this.Contract.setScreen("WarcampDay2End");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Deserters",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Suivez les empreintes de pas et approchez les déserteurs",
					"Convainquez-les de revenir ou tuez-les"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Flags.get("IsDesertersFailed"))
				{
					if (this.Contract.m.Destination != null)
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
					}

					this.Contract.setState("Running_ReturnAfterIntercept");
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination != null && this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("DesertersAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Destination, this.Const.World.CombatSettings.CombatPlayerDistance / 2) && !this.TempFlags.get("IsDeserterApproachShown"))
				{
					this.TempFlags.set("IsDeserterApproachShown", true);
					this.Contract.setScreen("Deserters2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Deserters")
				{
					this.Flags.set("IsDesertersFailed", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_FinalBattle",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Gagnez la bataille pour %noblehouse%"
				];
			}

			function update()
			{
				if (this.Flags.get("IsFinalBattleLost") && !this.Flags.get("IsFinalBattleLostShown"))
				{
					this.Flags.set("IsFinalBattleLostShown", true);
					this.Contract.m.Warcamp.die();
					this.Contract.m.Warcamp = null;
					this.Contract.setScreen("BattleLost");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFinalBattleWon") && !this.Flags.get("IsFinalBattleWonShown"))
				{
					this.Flags.set("IsFinalBattleWonShown", true);
					this.Contract.m.Warcamp.die();
					this.Contract.m.Warcamp = null;
					this.Contract.setScreen("BattleWon");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.TempFlags.get("IsFinalBattleStarted"))
				{
					this.TempFlags.set("IsFinalBattleStarted", true);
					local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Warcamp.getTile(), 3, 12, [
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains,
						this.Const.World.TerrainType.Forest,
						this.Const.World.TerrainType.LeaveForest,
						this.Const.World.TerrainType.SnowyForest,
						this.Const.World.TerrainType.AutumnForest,
						this.Const.World.TerrainType.Swamp,
						this.Const.World.TerrainType.Hills
					], false);
					this.World.State.getPlayer().setPos(tile.Pos);
					this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "FinalBattle";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					p.AllyBanners = [
						this.World.Assets.getBanner(),
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
					];
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall()
					];
					local allyStrength = 90;

					if (this.Flags.get("IsRequisitionFailure"))
					{
						allyStrength = allyStrength - 20;
					}

					if (this.Flags.get("IsDesertersFailed"))
					{
						allyStrength = allyStrength - 20;
					}

					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, allyStrength * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
					p.Entities.push({
						ID = this.Const.EntityType.Knight,
						Variant = 0,
						Row = 2,
						Script = "scripts/entity/tactical/humans/knight",
						Faction = this.Contract.getFaction(),
						Callback = this.Contract.onCommanderPlaced.bindenv(this.Contract)
					});
					local enemyStrength = 150;

					if (this.Flags.get("IsScoutsFailed"))
					{
						enemyStrength = enemyStrength + 25;
					}

					if (this.Flags.get("IsInterceptSuppliesFailure"))
					{
						enemyStrength = enemyStrength + 25;
					}

					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, enemyStrength * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyNobleHouse"));
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyNobleHouse"));
					p.Entities.push({
						ID = this.Const.EntityType.Knight,
						Variant = this.Const.DLC.Wildmen && this.Contract.getDifficultyMult() >= 1.15 ? 1 : 0,
						Name = this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)],
						Row = 2,
						Script = "scripts/entity/tactical/humans/knight",
						Faction = this.Flags.get("EnemyNobleHouse"),
						Callback = null
					});
					this.Contract.setState("Running_FinalBattle");
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "FinalBattle")
				{
					this.Flags.set("IsFinalBattleLost", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "FinalBattle")
				{
					this.Flags.set("IsFinalBattleWon", true);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à " + this.Contract.m.Home.getName() + " pour réclamer votre paiement"
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% vous accueille à l\'intérieur. Il porte une armure, bien que ses commandants semblent essayer de le dissuader de participer directement au combat. L\'homme vous accueille chaleureusement malgré tout et vous explique rapidement ce dont il a besoin de votre part.%SPEECH_ON%Nous sommes sur le point de conclure cette guerre absurde. Mes plus grandes forces s\'organisent %direction% à partir d\'ici. J\'ai besoin que vous vous rendiez là-bas et que vous rencontriez %commander%. Il vous expliquera comment vous pourrez nous être utile. Si vous parvenez à nous aider à renverser les marées, alors vous serez généreusement rémunéré, mercenaire.%SPEECH_OFF% | Vous entrez dans la pièce de %employer% pour le voir donner une bannière de %feudfamily% à quelques chiens. Les molosses la déchirent avec une férocité bien entraînée. %employer% lève les yeux vers vous.%SPEECH_ON%Ah, mercenaire. Content que vous soyez enfin ici. J\'ai besoin que vous alliez rendre visite à %commander% %direction% d\'ici. Nous entamons les dernières étapes de cette maudite guerre et je crois que des hommes comme vous peuvent accélérer sa fin. Je ne peux pas vous dire à quoi vous pouvez vous attendre, si ce n\'est que ces guerres se terminent généralement de manière spectaculaire. Votre paiement, lui aussi, sera spectaculaire.%SPEECH_OFF% | Vous entrez dans la pièce de %employer% pour le trouver entouré de ses généraux. Ils regardent une carte où un grand nombre de pions ennemis sont positionnés face à face. Le noble vous regarde.%SPEECH_ON%Ah, mercenaire. J\'ai besoin que vous alliez ici.%SPEECH_OFF%Il lâche un bâton sur la carte.%SPEECH_ON%Et que vous rencontriez %commander%. Nous nous préparons à mettre fin à cette guerre une fois pour toutes et votre aide sera cruciale.%SPEECH_OFF%Vous hochez la tête, mais vous vous attardez. L\'homme lève les sourcils puis un doigt.%SPEECH_ON%Oh oui, votre aide sera rémunérée ! Ne vous trompez pas là-dessus.%SPEECH_OFF% | Vous ne pouvez pas entrer dans la pièce de %employer%. À la place, l\'un de ses commandants vient à votre rencontre à l\'extérieur avec une carte et un contrat. Il explique qu\'une grande bataille se prépare et que votre aide est nécessaire. Si vous choisissez d\'accepter, vous irez à %commander% %direction% d\'ici et là, vous attendrez d\'autres instructions. | Un garde devant la pièce de %employer% vous empêche d\'entrer. Il fixe le sigle que vous portez de la %companyname%, puis s\'adresse directement à vous.%SPEECH_ON%Je suis censé vous remettre ceci.%SPEECH_OFF%Il vous assène un parchemin sur la poitrine. Les instructions précisent qu\'une bataille mettant fin à la guerre approche et, si vous choisissez d\'aider, vous devrez vous rendre au camp de %commander% pour d\'autres instructions. Vous demandez si vous devez marchander avec le garde ou avec %employer%. Le garde avale difficilement et une perle de sueur coule sur sa joue.%SPEECH_ON%Si vous devez marchander, c\'est avec moi que vous devez le faire.%SPEECH_OFF% | %employer% vous salue et vous emmène dehors vers son maître des chiens personnel. Les chiens s\'assoient docilement pendant qu\'il descend la ligne. Il passe la main sur le dessus de leurs têtes, un geste facile et impératif.%SPEECH_ON%%commander% dirige mes hommes %direction% d\'ici et il m\'a rapporté qu\'une grande bataille pourrait être imminente.%SPEECH_OFF%Le noble s\'arrête et se tourne vers vous.%SPEECH_ON%Il pense que cela pourrait mettre fin à la guerre avec %feudfamily%. Alors, je veux que vous y alliez et que vous aidiez, tout ce qui peut mettre fin à son horrible conflit.%SPEECH_OFF% | Vous rencontrez %employer% dans une pièce pleine de généraux. Ses commandants vous regardent avec suspicion, mais l\'homme vous invite dans un coin pour discuter personnellement.%SPEECH_ON%Ne faites pas attention à eux. Vite maintenant, j\'ai une armée dirigée par %commander% juste %direction% d\'ici. J\'ai besoin que vous y alliez et que vous le rencontriez pour d\'autres instructions. Mes commandants pensent qu\'une bataille finale pourrait être imminente et nous avons besoin de toute l\'aide possible. Si ce combat met vraiment fin à cette guerre, vous serez récompensé en conséquence.%SPEECH_OFF% | Un garde vous laisse entrer dans la salle de %employer% et là vous trouvez l\'homme entouré de généraux qui se disputent. Ils crient les uns sur les autres, renversant des jetons de guerre sur une carte, créant le chaos dans l\'organisation qui est la planification de la bataille. %employer% se lève et vient à votre rencontre personnellement.%SPEECH_ON%Ne faites pas attention au bruit. Les hommes sont sur les nerfs parce qu\'il est tout à fait possible que nous soyons sur le point de mettre fin à cette maudite guerre avec %feudfamily%. %commander% et la plupart de mon armée se reposent %direction% d\'ici. Il a demandé autant de renforts qu\'il le pouvait, y compris des mercenaires. Si vous y allez et aidez à mettre fin à cette foutue guerre, alors vous serez très bien récompensé, mercenaire.%SPEECH_OFF% | %employer% vous emmène à l\'extérieur près des enclos à cochons. Là, vous trouvez les porcs en train de mâcher un cadavre. À proximité, quelques chèvres grignotent une bannière de %feudfamily%. %employer% se tourne vers vous avec un sourire.%SPEECH_ON%Un espion, vous comprenez comment ça marche. Quoi qu\'il en soit, %commander% m\'a informé qu\'il pense qu\'une bataille finale avec %feudfamily% pourrait être imminente. Il a demandé toute l\'aide possible et j\'ai l\'intention de la lui envoyer. Si vous y allez, le rencontrez et faites ce qu\'il demande, vous serez très généreusement récompensé.%SPEECH_OFF% | Vous rencontrez l\'un des gardes de %employer% qui vous conduit personnellement chez l\'homme. Il est perché dans une petite pièce qui doit être une sorte de refuge loin des agacements du monde. Une bougie vacille pendant qu\'il feuillette un livre. Il parle sans vous regarder.%SPEECH_ON%Bonjour, mercenaire. Mon commandant sur le terrain, %commander%, m\'a envoyé un petit oiseau pour dire que les armées de %feudfamily% pourraient se rassembler. Il pense que nous avons une chance de mettre fin à cette guerre une fois pour toutes.%SPEECH_OFF%Le noble lèche son pouce et tourne lentement une page. Il continue.%SPEECH_ON%Je veux que vous alliez le rejoindre. Naturellement, votre paiement tiendra compte de ce que vous avez à offrir, ce qui, je le suspecte, est assez important.%SPEECH_OFF% | Un des gardes de %employer% vous conduit en haut d\'une tour où vous trouvez l\'homme lui-même. Il vous regarde.%SPEECH_ON%Belle vue, non ?%SPEECH_OFF%Vous regardez autour de vous. Le pays s\'étend et les gens deviennent de petits acariens bondissant à sa surface. Une petite charrette tirée par un âne fait son chemin sous la tour, entrant à %townname% pour les affaires. Vous hausserez les épaules. %employer% hoche la tête.%SPEECH_ON%Je vous aurais imaginé comme quelqu\'un qui apprécie de tels paysages, mais je suppose qu\'un homme d\'affaires n\'aurait pas de telles pensées en tête lorsque les affaires sont en cours. Et, cher mercenaire, les affaires sont en cours. L\'un de mes commandants a rapporté que les armées de %feudfamily% se rassemblent. Il pense qu\'il est possible que nous puissions mettre fin à cette guerre avec eux dans une grande bataille finale. Compris ?%SPEECH_OFF%Vous hochez la tête. Il continue.%SPEECH_ON%Si cela se passe comme prévu, vous serez payé en fonction de vos services. Je ne sais pas si vous avez déjà contribué à mettre fin à une guerre, mercenaire, mais beaucoup d\'hommes paieraient une rançon royale pour de tels services.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "A great battle, you say?",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Je ne soumettrai pas la %companyname% au commandement d\'un autre homme. | Je dois décliner. | On est demandé autre part.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "WarcampDay1",
			Title = "Au camp de guerre...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{Vous arrivez au camp, qui ressemble plus à une ville de tentes, et vous trouvez %commander%. Il vous accueille dans sa tente, qui ressemble plus à une ville de cartes alors qu\'il surveille où se trouve son armée et où pourrait être l\'armée de %feudfamily%.%SPEECH_ON%Bienvenue, mercenaire. Vous êtes arrivé juste à temps.%SPEECH_OFF% | Le camp de guerre de %commander% est rempli d\'hommes ennuyés. Ils brassent des ragoûts ou jouent à des jeux de cartes. La chose la plus excitante disponible est un combat entre un scarabée et un ver, un combat dont aucun des deux camps ne semble particulièrement intéressé. %commander% lui-même vous accueille et vous emmène à l\'intérieur de sa tente, ornée de cartes et d\'autres outils de planification. | Vous entrez dans la tente de %commander% pour y trouver un groupe d\'hommes peu enthousiastes. L\'un crie.%SPEECH_ON%Vous n\'êtes pas les femmes que nous avons demandées.%SPEECH_OFF%Les soldats rient. %randombrother% riposte.%SPEECH_ON%Vos mères ont pris soin de nous en premier.%SPEECH_OFF%Prévisiblement, tous les côtés commencent à tirer leurs armes. %commander% lui-même intervient pour éviter une bataille sanglante. Il vous emmène dans sa tente.%SPEECH_ON%Content que vous soyez là, bien que vos hommes pourraient être moins nuisibles si nous devons gagner cette foutue guerre.%SPEECH_OFF% | Vous arrivez au camp de %commander% pour y trouver les hommes participant à une course de scarabées. Ils encouragent les scarabées qui, à mi-parcours sur une piste faite de paille de foin, se tournent les uns contre les autres et commencent à se battre. Les acclamations des soldats deviennent de plus en plus fortes. %commander% vous trouve à travers la foule et vous emmène dans sa tente.%SPEECH_ON%Je suis content que vous soyez là, mercenaire. J\'ai quelque chose pour vous à faire dès maintenant.%SPEECH_OFF% | Arrivant au camp de guerre de %commander%, vous trouvez les hommes encourager une femme à moitié habillée qui tourne autour d\'un âne. La dame et l\'âne disparaissent dans une tente qui se remplit rapidement d\'hommes. %randombrother% demande s\'il peut y aller. Vous dites que vous y allez aussi, alors oui, bien sûr. À ce moment-là, %commander% vous attrape. Il vous conduit dans sa tente de commandement.%SPEECH_ON%Faites-moi confiance, vous ne voulez pas voir ça.%SPEECH_OFF%Vous ne lui faites pas confiance. | Le camp de guerre de %commander% a transformé le terrain en boue. Ils ont abattu tous les arbres à proximité, construisant à leur place de petites cabanes mal faites qui penchent là où la boue cède. Les tentes s\'étendent à perte de vue. Des feux brillent sur la route, comme des étoiles brillant le long d\'un ciel blanc.\n\nVous rencontrez %commander% dans sa tente, remplie de cartes et de lieutenants en attente d\'ordres. | Le camp de guerre est plein de cliquetis et de claquements. Les forgerons travaillent pour réparer l\'équipement, les cuisiniers mijotent des plats horribles qu\'ils prétendent être de la nourriture, et les soldats enfoncent des poteaux pour leurs tentes. Vous rencontrez %commander% dans sa tente. Volé loin de tout ce bruit métallique, il est remplacé par les arguments de ses lieutenants. Il secoue la tête.%SPEECH_ON%Quand une grande bataille se profile, les hommes deviennent nerveux. Ne faites pas attention à leurs querelles.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "De quoi avez-vous besoin que le %companyname% fasse ?",
					function getResult()
					{
						if (this.Flags.get("IsScoutsSighted"))
						{
							return "ScoutsSighted";
						}
						else
						{
							return "RequisitionSupplies1";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay1End",
			Title = "Au camp de guerre..."
			Text = "[img]gfx/ui/events/event_96.png[/img]{Vous retournez au camp de guerre et ordonnez à vos hommes de se reposer. Qui sait ce qui vous attend demain. | Eh bien, les ordres de %commander% ont été exécutés, mais il y en aura sûrement d\'autres demain. Reposez-vous tant que vous le pouvez ! | Le camp de guerre est exactement comme vous l\'avez laissé. Vous n\'êtes pas sûr si c\'est bon ou mauvais. Demain apportera plus de choses à régler, alors vous ordonnez au %companyname% de se reposer.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Reposez-vous bien, nous serons bientôt rappelés.",
					function getResult()
					{
						this.Flags.set("LastDay", this.World.getTime().Days);
						this.Flags.set("NextDay", 2);
						this.Contract.setState("Running_WaitForNextDay");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ScoutsSighted",
			Title = "Au camp de guerre...",
			Text = "[img]gfx/ui/events/event_54.png[/img]%commander% explique la situation.%SPEECH_ON%{Nos éclaireurs ont repéré leurs éclaireurs. Malheureusement, je n\'ai pas armé mes éclaireurs pour le combat, alors ils ont demandé de l\'aide. L\'ennemi se trouve %direction% d\'ici. Tuez-les tous et %feudfamily% sera laissé dans l\'ignorance de nos mouvements de troupes. | Quelques-uns de mes éclaireurs ont repéré certains des éclaireurs de %feudfamily% juste %direction% d\'ici. Ils fouillent à la recherche de l\'armée principale, mais ils ne la trouveront pas car vous irez là-bas pour les tuer tous. C\'est compris ? | Les éclaireurs de %feudfamily% ont été repérés %direction% d\'ici. Je vous demande d\'aller les tuer tous avant qu\'ils ne nous trouvent ou ne rapportent ce qu\'ils ont appris au cours des derniers jours. | En guerre, l\'information est une arme. Et j\'ai récemment acquis l\'information selon laquelle les éclaireurs de %feudfamily% sont en chasse juste %direction% d\'ici. Si je peux en apprendre davantage sur eux, puis détruire ce qu\'ils ont appris sur nous, alors nous aurons acquis un avantage considérable pour les combats à venir.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "La compagnie partira immédiatement.",
					function getResult()
					{
						this.Contract.setState("Running_Scouts");
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.Contract.m.Warcamp.getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 8);
				local party = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).spawnEntity(tile, "Scouts", false, this.Const.World.Spawn.Noble, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall());
				party.setDescription("Soldats professionnels au service des seigneurs locaux.");
				party.setFootprintType(this.Const.World.FootprintsType.Nobles);
				this.Contract.m.UnitsSpawned.push(party);
				party.getLoot().Money = this.Math.rand(50, 100);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 6);

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
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				this.Contract.m.Destination = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Warcamp);
				roam.setMinRange(4);
				roam.setMaxRange(9);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
			}

		});
		this.m.Screens.push({
			ID = "ScoutsEscaped",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Malheureusement, un ou plusieurs des éclaireurs ont réussi à échapper à la bataille. Toutes les informations qu\'ils avaient collectées sont désormais entre les mains de %feudfamily%. | Maudit soit le sort ! Certains des éclaireurs ont réussi à s\'échapper et font sans aucun doute leur chemin de retour vers %feudfamily%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Maudit soit!",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterScouts");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ScoutsCaught",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Tous les éclaireurs ont été tués. Toutes les informations qu\'ils possédaient sont mortes avec eux. Cela sera d\'une grande aide pour la bataille à venir. | Les éclaireurs sont morts et toutes les informations qu\'ils avaient apprises sont mortes avec eux.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Victoire !",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterScouts");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RequisitionSupplies1",
			Title = "Au camp de guerre...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{%commander% soupire et commence à parler.%SPEECH_ON%Je ne veux pas gaspiller vos talents, mercenaire, mais j\'ai besoin de quelqu\'un pour sortir et réquisitionner des provisions alimentaires pour l\'armée. Nous sommes à court de provisions et avons besoin de toute l\'aide possible.%SPEECH_OFF%Hé, si vous êtes payé, ce n\'est pas une insulte pour vous. | %commander% fourre une feuille séchée derrière sa lèvre et croise les bras.%SPEECH_ON%Bon, je sais que vous êtes ici pour combattre. Je sais que vous êtes ici pour tuer des hommes et être bien payé pour le faire. Mais en ce moment, mon armée a besoin d\'être nourrie et pour être nourrie, j\'ai besoin de quelqu\'un pour sortir là-bas et chercher de la nourriture.%SPEECH_OFF%Il se dirige vers l\'une de ses cartes et pointe du doigt.%SPEECH_ON%J\'ai besoin que vous rendiez visite à ces fermiers et chargiez leur nourriture. Ils vous attendront, donc il ne devrait pas y avoir de problèmes. Considérez cela comme une journée facile avant la bataille, d\'accord ?%SPEECH_OFF% | %commander% pointe un parchemin posé sur l\'une de ses cartes. Il y a des chiffres dessus, et les chiffres diminuent au fur et à mesure qu\'ils descendent la page.%SPEECH_ON%Nous sommes à court de provisions alimentaires. Nous réquisitionnons habituellement des réserves en visitant les fermiers %direction% d\'ici. J\'ai besoin que vous y alliez et que vous en rameniez davantage. Ils vous attendront et il ne devrait pas y avoir de problèmes.%SPEECH_OFF% | Vous regardez une assiette avec une miche de pain dessus. Il y a de la viande sur l\'assiette à côté, à moitié mangée, le reste envahi par les mouches. Un chien bien nourri et en bonne santé remue la queue dans un coin. %commander% fait le tour de l\'une de ses cartes.%SPEECH_ON%Nous sommes très bas en provisions alimentaires. Si mes hommes ont faim, ils ne combattront pas, et s\'ils ne combattent pas, alors nous perdons !%SPEECH_OFF%Vous hochez la tête. Les chiffres concordent. Il continue.%SPEECH_ON%Nous avons pris de la nourriture aux fermiers %direction% d\'ici depuis un certain temps déjà. J\'ai besoin que vous y alliez et fassiez de même. Un de mes gardes vous remettra une liste des choses à obtenir. Les fermiers eux-mêmes ne s\'opposeront pas à vous. Ils savent ce qui arrive s\'ils le font.%SPEECH_OFF% | Vous voyez un homme studieux dans le coin de la tente. Il fait courir une plume sèche sur un parchemin, secouant la tête tout en le faisant. Soudain, il se lève et tend la page à %commander%. Le commandant hoche la tête quelques fois puis vous regarde.%SPEECH_ON%Cela peut sembler en dessous de certains mercenaires, mais j\'ai besoin que le %companyname% visite les fermes %direction% d\'ici et \'réquisitionne\' la nourriture qu\'elles ont. Ce ne sera pas la première fois que notre armée fait des demandes à ces fermiers. La dernière fois que nous sommes allés, ils ont essayé de résister mais, eh bien, des leçons ont été apprises. Mon scribe écrira tout ce dont nous avons besoin. Considérez cela comme une journée de shopping sur les marchés.%SPEECH_OFF%Le commandant sourit ironiquement.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "La compagnie se mettra en route dans l\'heure.",
					function getResult()
					{
						this.Contract.setState("Running_Requisition");
						return 0;
					}

				}
			],
			function start()
			{
				local settlements = this.World.EntityManager.getSettlements();
				local lowest_distance = 99999;
				local best_location;
				local myTile = this.Contract.m.Warcamp.getTile();

				foreach( s in settlements )
				{
					foreach( l in s.getAttachedLocations() )
					{
						if (l.getTypeID() == "attached_location.wheat_fields" || l.getTypeID() == "attached_location.pig_farm")
						{
							local d = myTile.getDistanceTo(l.getTile());

							if (d < lowest_distance)
							{
								lowest_distance = d;
								best_location = l;
							}
						}
					}
				}

				best_location.setActive(true);
				this.Contract.m.Destination = this.WeakTableRef(best_location);
			}

		});
		this.m.Screens.push({
			ID = "RequisitionSupplies2",
			Title = "À la ferme...",
			Text = "[img]gfx/ui/events/event_72.png[/img]{Les fermes se rapprochent. Une mer de cultures s\'étend devant vous, les champs ondulant comme des vagues lorsque le vent souffle. %randombrother% passe sa main à travers un champ de blé. %randombrother2% le frappe à l\'épaule.%SPEECH_ON%Tu veux ramener des drosophiles à la maison ? Retire ta main de là.%SPEECH_OFF%Le mercenaire frotte son épaule avant de riposter.%SPEECH_ON%Va te faire foutre. Ma main va où elle veut, demande juste à ta mère.%SPEECH_OFF%Les coups augmentent rapidement en intensité et la scène idyllique se brise. | Les fermes sont au loin. Des champs de cultures oscillent sous un vent sec, bruissant comme des vagues calmes. Des ouvriers agricoles coupent à travers les champs avec des faux, une équipe de suiveurs jetant les restes avec des fourches. Des ânes ferment la marche, tirant des charrettes à travers le terrain accidenté. | Les fermes roulent parmi les collines, le sol est trop bon pour laisser un peu de géographie se mettre en travers du chemin. Chaque champ est plein de cultures, et à travers eux passent les ouvriers agricoles, faux et fourches étincelant lorsqu\'ils montent et descendent. Au loin, vous voyez les propriétaires des fermes debout ensemble. Ils ont l\'air foutrement furieux, mais rarement quelqu\'un reste en colère devant le %companyname%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Allons chercher ce pour quoi nous sommes ici.",
					function getResult()
					{
						if (this.Flags.get("IsAmbush"))
						{
							return "Ambush";
						}
						else if (this.Flags.get("IsUnrulyFarmers"))
						{
							return "UnrulyFarmers";
						}
						else
						{
							return "CooperativeFarmers";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Ambush",
			Title = "À la ferme...",
			Text = "[img]gfx/ui/events/event_10.png[/img]{À mesure que vous vous rapprochez des fermiers, un cri vient de vos côtés et un groupe d\'hommes bien armés surgit. C\'est une embuscade ! | En approchant des fermes, les chariots remplis de nourriture commencent à reculer. À mesure qu\'ils se déplacent, ils révèlent lentement une troupe d\'hommes bien armés. Les fermiers s\'écartent rapidement. %randombrother% tire son arme.%SPEECH_ON%C\'est une embuscade !%SPEECH_OFF% | Vous vous approchez des chariots de nourriture. Les fermiers s\'écartent alors que %randombrother% avance et jette la bâche d\'un des wagons. Il n\'y a rien à l\'intérieur. Soudain, une flèche s\'écrase contre le côté du wagon avec un bruit de bois. Les fermiers se baissent et s\'enfuient tandis que des hommes bien armés arrivent de tous les côtés. C\'est une embuscade !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						local n = 0;

						do
						{
							n = this.Math.rand(1, this.Const.PlayerBanners.len());
						}
						while (n == this.World.Assets.getBannerID());

						p.Entities = [];
						p.EnemyBanners = [
							this.Const.PlayerBanners[n - 1],
							"banner_noble_11"
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 40 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "UnrulyFarmers",
			Title = "À la ferme...",
			Text = "[img]gfx/ui/events/event_43.png[/img]Vous approchez des fermiers pour les trouver résistants. Leur chef croise les bras et secoue la tête.%SPEECH_ON%{Regardez. Mes hommes ont déjà chargé les chariots. Je suis prêt à faire un compromis ici, vous savez ? Parce que nous avons des familles à nourrir et des dettes à payer comme tout le monde. Et si vous nous payez %cost% couronnes, nous laisserons tout cela remonter jusqu\'à %commander%. | Vous êtes des mercenaires, n\'est-ce pas ? Alors vous comprendriez le besoin d\'or mieux que la plupart. Nous sommes de simples fermiers, pas des changeurs d\'argent. Tout ce que nous demandons, c\'est une petite compensation pour notre travail. Vous nous donnez %cost% couronnes, et nous vous donnerons la nourriture. Nous subissons encore une perte avec cet accord, mais je pense que c\'est toujours équitable. | Vous arrivez ici avec votre tenue tape-à-l\'œil en pensant que vous allez simplement nous intimider. %commander% a déjà pris trop, je dis, et il est grand temps qu\'il paie sa nourriture comme tout le monde ! Alors voici le marché. Je vous vends la nourriture pour %cost% couronnes. Je pense que c\'est parfaitement juste pour ce que nous avons à offrir.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Vous oubliez votre place, fermier. Voulez-vous que nous le prenions de force ?",
					function getResult()
					{
						return "TakeItByForce";
					}

				},
				{
					Text = "Je comprends. Vous aurez vos %cost% couronnes et nous aurons les provisions.",
					function getResult()
					{
						return "PayCompensation";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BeatenByFarmers",
			Title = "À la ferme...",
			Text = "[img]gfx/ui/events/event_22.png[/img]L\'embuscade est trop forte ! Vous prenez les hommes encore debout et battez en retraite. Les hommes de %commander% devront maintenant rationner encore plus, et la nouvelle de la défaite du %companyname% ici se répandra sans aucun doute.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Maudit soit cela !",
					function getResult()
					{
						this.Flags.set("IsRequisitionFailure", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PoorFarmers",
			Title = "À la ferme...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Les fermiers et leurs épées engagées sont abattus. L\'un des ouvriers agricoles, reculant avec ses entrailles à l\'air, implore la clémence lorsque vous vous approchez pour le tuer. Vous secouez la tête.%SPEECH_ON%Tu es tout retourné, gamin. Cela, c\'est la clémence.%SPEECH_OFF%La lame glisse facilement à travers sa gorge. Il gargouille, mais c\'est très vite terminé. Vous ordonnez aux hommes de ramasser les provisions et de se préparer à Retournez à %commander%. | Les fermiers et leurs hommes embusqués ont été tués jusqu\'au dernier. Vous ordonnez aux hommes de rassembler les provisions. %commander% et ses hommes devraient être heureux de votre retour. | Il y a du sang sur certaines denrées, mais un peu d\'eau le frottera bien. Les hommes de %commander% apprécieront votre travail ici. | %randombrother% ramasse un fermier qui faisait le mort et lui tranche la gorge. L\'homme gargouille et se libère de la prise du mercenaire. Il se dirige vers l\'une des charrettes, projetant du sang partout sur la nourriture. Vous criez.%SPEECH_ON%Nom de Dieu, sortez-le de là !%SPEECH_OFF%Le fermier est rapidement éliminé, mais ce chargement est sans aucun doute ruiné. Vous secouez la tête.%SPEECH_ON%Mettez une couverture sur ceux-là. Peut-être que personne ne le remarquera.%SPEECH_OFF% | Obtenir la nourriture a nécessité un peu plus de travail que prévu, mais tout est entre vos mains maintenant. Vous confiez la propriété des terres à un ouvrier agricole pauvre avec des sacs de laine pour chaussures.%SPEECH_ON%N\'oublie pas ce qui est arrivé à ton maître ici, parce que ça peut sûrement t\'arriver aussi, compris ?%SPEECH_OFF%Le gamin hoche rapidement la tête. Vous ordonnez au %companyname% de préparer son Retournez à %commander%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Imbéciles.",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CooperativeFarmers",
			Title = "À la ferme...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Les fermiers vous accueillent chaleureusement.%SPEECH_ON%Laissez-moi deviner, %commander% vous a envoyé tous ?%SPEECH_OFF%Vous hochez la tête. Le fermier crache et hoche la tête à son tour.%SPEECH_ON%Eh bien d\'accord. Vous n\'aurez aucun problème ici. Les gars, aidez-les à prendre la route.%SPEECH_OFF%Les ouvriers agricoles sortent pour aider vos hommes à prendre les provisions et à préparer le voyage de retour vers %commander%. | Vous rencontrez le chef des fermiers. Il vous serre la main.%SPEECH_ON%Le petit oiseau de %commander% m\'a dit qu\'il avait envoyé des mercenaires, mais votre tenue semble être un cran au-dessus de toute compagnie que j\'ai jamais vue. Mes gars vont vous aider à charger les charrettes pour que vous puissiez reprendre la route.%SPEECH_OFF% | Les fermiers commencent à charger les charrettes à votre approche. Leur leader s\'avance.%SPEECH_ON%Je ne suis pas content de faire ça, mais je suis plus heureux ici dans ces champs que d\'attendre de mourir dans un camp de guerre pour une guerre qui ne me concerne pas. Mes hommes vont vous aider à charger les charrettes pour que vous puissiez reprendre votre route. Quand vous verrez %commander%, plaidez en ma faveur, d\'accord ? J\'aimerais continuer à cultiver.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je suis sûr que %noblehouse% l\'appréciera.",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TakeItByForce",
			Title = "À la ferme...",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Vous tirez votre épée. Les fermiers reculent et le cliquetis des fourches qu\'on saisit résonne parmi leurs rangs. Leur leader crache et passe sa manche sur sa bouche.%SPEECH_ON%Merdre, tu veux en arriver là ? Alors allons-y.%SPEECH_OFF% | Vous secouez la tête.%SPEECH_ON%Pas de marché. Abandonnez les provisions ou faites face à notre courroux.%SPEECH_OFF%Le fermier brandit une fourche de gauche à droite. Ses hommes commencent lentement à prendre les armes. Il hoche la tête.%SPEECH_ON%Nous sommes des fermiers, trou du cul. Le courroux nous a choisis il y a bien longtemps.%SPEECH_OFF% | Vous n\'êtes pas venu ici pour négocier des accords.%SPEECH_ON%Il n\'y aura pas de compensation. %commander% nous a envoyés ici pour...%SPEECH_OFF%Le fermier rit et vous interrompt.%SPEECH_ON%Le commandant a envoyé quelques toutous. Eh bien, je vais te dire, petit chien, voyons si tes hommes sont plus bruit que morsure.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Faisons ça rapidement.",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "TakeItByForce";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.Entities = [];
						p.EnemyBanners = [
							"banner_noble_11"
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Peasants, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PayCompensation",
			Title = "À la ferme...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Vous ne voyez aucune raison de verser le sang de pauvres fermiers qui essaient simplement de vivre leur vie. Remettant les couronnes, vous avertissez le fermier de faire attention en essayant de conclure des accords de ce genre.%SPEECH_ON%Tout le monde n\'est pas aussi gentil pour essayer de négocier avec vous.%SPEECH_OFF%Le fermier tourne la tête, révélant une longue cicatrice qui va du cuir chevelu à l\'épaule.%SPEECH_ON%Je le sais assez bien. Merci pour votre considération, mercenaire.%SPEECH_OFF% | Vous n\'êtes dans le business de tuer des fermiers que si quelqu\'un vous paie pour le faire. %commander% ne l\'a pas fait. Vous acceptez les termes des fermiers. Leur chef vous serre la main.%SPEECH_ON%Merci mercenaire. Il est rare de voir un homme prêt à céder du terrain. Je vous prenais pour un brute, mais clairement vous êtes un homme de beaucoup d\'acuité.%SPEECH_OFF% | Vous n\'êtes pas venu jusqu\'ici pour massacrer de pauvres fermiers. Vous acceptez les conditions de l\'homme. Il vous remercie de ne pas être venu jusqu\'ici pour massacrer de pauvres fermiers. %randombrother%, cependant, déclare tranquillement qu\'il n\'est pas venu jusqu\'ici pour... Vous lui dites bruyamment de se taire et de commencer à charger les chariots.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Dépêchons-nous de retourner au camp de guerre.",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("RequisitionCost"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					Text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("RequisitionCost") + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "WarcampDay2",
			Title = "Au camp de guerre...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{Le soleil du matin s\'infiltre dans votre tente, projetant un rayon droit dans vos yeux pour vraiment vous rappeler que vous avez une nouvelle journée à endurer. | Vous vous levez et enfilez vos bottes, écrasant quelques araignées qui ont pensé que c\'était l\'endroit idéal pour se reposer pendant la nuit. | À l\'extérieur de votre tente, un coq fait savoir à tout le monde à quel point c\'est un vrai connard d\'animal. Vous vous levez à contrecœur. | Vous vous réveillez pour un jour de plus. Génial. | Vous avez dormi comme un mort et vous réveillez de la même manière. La lumière du soleil qui glisse dans la tente est trop éblouissante pour retourner au lit et les rabats sont trop loin pour être fermés. Peu importe, vous allez vous lever. | Matin. Cette heure inévitable où mille regrets arrivent sur le devant de la scène lumineuse d\'une nouvelle journée.}\n\n Un jeune garçon se tient devant votre tente avec un parchemin. Il le déploie et a du mal à le lire.%SPEECH_ON%{Votre... co-co-commandant a re... rekeestered... euh, vous feriez mieux d\'aller le voir vous-même. | %commander% souhaites te voir, il... il dit, attendez, pas de chevaux ici ? Quoi ? Regarde, je ne sais pas lire. Allez simplement voir le commandant. | Monsieur, ce papier ici me dit de vous dire que, vous... euh, vous devriez... heu, aller voir le commandant. Il y a beaucoup plus, mais on y passerait toute la journée si j\'essayais de le finir. | Ouais, je ne peux pas vraiment lire, mais je pense que le commandant souhaite te voir. | Voyons voir, cette lettre... Je connais cette lettre... c\'est la lettre \'I\', et je pense que le reste de la phrase est un tas de je ne peux pas lire un foutu mot de cette merde. Regarde, va juste voir le commandant. Je pense que c\'est ce qu\'il veut.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il est temps de rendre visite au commandant...",
					function getResult()
					{
						if (this.Flags.get("IsInterceptSupplies"))
						{
							return "InterceptSupplies";
						}
						else
						{
							return "Deserters1";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "InterceptSupplies",
			Title = "Au camp de guerre...",
			Text = "[img]gfx/ui/events/event_96.png[/img]Vous rencontrez %commander% dans sa tente. Il a l\'air plutôt excité. Un homme rusé et voilé se tient à ses côtés. Le commandant parle précipitamment.%SPEECH_ON%{Mon petit oiseau ici a rapporté qu\'un envoi d\'équipement se dirige vers l\'armée de %feudfamily%. Si nous pouvons l\'intercepter et le détruire, ils ne seront pas aussi prêts à combattre à l\'avenir ! | Salut, mercenaire. Mes espions me disent que %feudfamily% attend un envoi très nécessaire d\'équipement vers leur camp. J\'ai besoin que tu ailles le détruire. | Les espions ne sont-ils pas les meilleurs ? Regardez ce petit homme. Il me dit, monsieur, %feudfamily% attend un gros envoi de marchandises. Armes, armures, nourriture, et ainsi de suite. Eh bien, je dis que j\'ai juste l\'homme pour profiter de cette nouvelle : toi ! Va et trouve cet envoi et mets-le en pièces. | Les batailles se gagnent souvent avant même d\'avoir lieu, tu sais cela, n\'est-ce pas ? Mon petit espion ici me dit que %feudfamily% attend un envoi d\'armes et d\'armures. Si tu peux le prendre, leur armée sera beaucoup moins préparée pour un combat en terrain découvert. | Savez-vous que j\'ai déjà remporté une bataille sans lever une épée ? J\'ai réussi à intercepter un envoi de marchandises qui a laissé mon ennemi totalement impréparé, alors ils ont préféré se rendre. Mon petit espion ici me dit que %feudfamily% attend un envoi similaire d\'équipement. Je suis sûr que cela ne mettra pas fin à la guerre, mais si tu peux y aller et le détruire, ce serait un énorme avantage. | Savez-vous qu\'une armée sans équipement n\'est guère une armée pour commencer ? L\'armée de %feudfamily% est à court de fournitures. En fait, la raison pour laquelle ils n\'ont pas encore attaqué est qu\'ils attendent l\'arrivée de plus d\'armes et d\'armures ! Eh bien, mon petit espion ici a repéré cet envoi. Et je veux que tu y ailles et le détruises. | J\'ai acquis une excellente nouvelle, mercenaire. %feudfamily% attend l\'arrivée d\'armes et d\'armures - et nous savons exactement d\'où ça vient. J\'ai juste besoin que tu fasses l\'évidence : détruis cet envoi et handicape mon ennemi avant même qu\'il ne comprenne ce qui lui arrive.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "La compagnie partira immédiatement.",
					function getResult()
					{
						this.Contract.setState("Running_InterceptSupplies");
						return 0;
					}

				}
			],
			function start()
			{
				local startTile = this.World.getEntityByID(this.Flags.get("InterceptSuppliesStart")).getTile();
				local destTile = this.World.getEntityByID(this.Flags.get("InterceptSuppliesDest")).getTile();
				local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
				local party = enemyFaction.spawnEntity(startTile, "Supply Caravan", false, this.Const.World.Spawn.NobleCaravan, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("base").Visible = false;
				party.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall());
				party.setMirrored(true);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setDescription("Une caravane accompagnée d'escortes armées transportant des provisions, des fournitures et du matériel entre les colonies.");
				party.setFootprintType(this.Const.World.FootprintsType.Caravan);
				party.getFlags().set("IsCaravan", true);
				party.setAttackableByAI(false);
				party.getFlags().add("ContractSupplies");
				this.Contract.m.Destination = this.WeakTableRef(party);
				this.Contract.m.UnitsSpawned.push(party);
				party.getLoot().Money = this.Math.rand(50, 100);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 6);

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
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(destTile);
				move.setRoadsOnly(true);
				local despawn = this.new("scripts/ai/world/orders/despawn_order");
				c.addOrder(move);
				c.addOrder(despawn);
			}

		});
		this.m.Screens.push({
			ID = "SuppliesReachedEnemy",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Vous avez échoué à détruire le convoi. De toute évidence, toutes ses marchandises ont atteint l\'armée de %feudfamily%, ce qui rendra les combats beaucoup plus difficiles dans les jours à venir. | Le convoi n\'a pas été détruit. Vous pouvez être assuré que l\'armée de %feudfamily% sera presque à pleine force pour la grande bataille à venir. | Eh bien, merde. Le convoi n\'a pas été détruit. Maintenant, l\'armée de %feudfamily% va être très bien préparée pour la bataille à venir.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous devrions retourner au camp...",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SuppliesIntercepted",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Vous aviez espéré peut-être piller tout ce que vous pouviez du convoi, mais les gardes ont tout incendié avant qu\'il ne puisse être volé. Malheureusement, tout ce qui compte, c\'est que l\'armée de %feudfamily% n\'a pas mis la main sur tout cet équipement. | Vous avez détruit une grande partie du convoi et ce que vous n\'avez pas fait, les gardes l\'ont fait eux-mêmes dans le but de garder l\'équipement hors des mains de l\'ennemi. %commander% sera très satisfait de ces résultats. | C\'était une bataille difficile, mais vous avez réussi à tuer les gardes du convoi. Malheureusement, la troupe semble avoir adopté une politique de terre brûlée, car ils ont réussi à incendier chaque chariot avant qu\'ils ne puissent être capturés. Ils savaient qu\'il ne fallait pas laisser tout cet équipement tomber entre les mains de l\'ennemi. %commander% sera plus que satisfait néanmoins. | Les gardes du convoi ont bien combattu, tout bien considéré, mais le %companyname% parvient à les tuer tous. Ou du moins, c\'est ce que vous pensez : pendant la bataille, l\'un des gardes a réussi à s\'échapper et à appliquer une politique de terre brûlée. Chaque chariot a été incendié. De toute évidence, si %feudfamily% ne pouvait pas obtenir l\'équipement, alors personne ne le pouvait. Agaçant, mais intelligent. Néanmoins, %commander% et ses hommes apprécieront la nouvelle. | Le convoi a été mis à mal. Vous aviez espéré peut-être capturer les chariots et prendre l\'équipement pour vous-même, mais l\'un des gardes a réussi à les brûler tous, sans doute pour éviter que de tels équipements ne tombent entre les mains de l\'ennemi. Quoi qu\'il en soit, l\'armée de %feudfamily% a certainement été affaiblie.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Un problème de moins à régler dans la bataille à venir.",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Deserters1",
			Title = "Au camp de guerre...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{Vous entrez dans la tente de %commander% juste à temps pour voir une bougie voler devant votre visage. Sa mèche crépite dans la boue pendant que vous regardez une table la suivre, basculant encore et encore avec toutes ses cartes qui volent. Un %commander% rougeaud se tient au pied du carnage, les mains sur les hanches, respirant fort alors qu\'il se reprend. Il s\'explique.%SPEECH_ON%Déserteurs ! Ils ont déserté ! À la veille de la bataille la plus importante de ma vie, je ne peux même pas garder mes satanés hommes autour de moi. Regardez, je ne peux pas permettre que cette armée se défasse. J\'ai besoin que vous alliez trouver ces déserteurs et que vous les rameniez. S\'ils refusent de revenir, eh bien, tuez-les tous. Un des guetteurs a dit les avoir vus partir %direction% d\'ici. Maintenant, dépêchez-vous !%SPEECH_OFF% | Juste au moment où vous vous apprêtez à entrer dans la tente de %commander%, un homme en sort en volant. %commander% se précipite hors de la tente et le projette dans la boue. Il l\'attrape par le col et le soulève comme un pantin.%SPEECH_ON%Où sont-ils allés ? Je jure par les anciens dieux que je vous ferai supplier la mort si vous ne me répondez pas honnêtement !%SPEECH_OFF%L\'homme crie et pointe.%SPEECH_ON%%direction%! Ils sont partis par là, je le jure !%SPEECH_OFF%%commander% lâche l\'homme qui est rapidement traîné par une paire de gardes. Le commandant se redresse et passe une main dans ses cheveux.%SPEECH_ON%Sellsword, quelques-uns de mes hommes ont jugé bon de déserter le camp. Trouvez-les. Ramenez-les. Compris ?%SPEECH_OFF%Vous hochez la tête, mais demandez que faire si les hommes refusent. Le commandant hausse les épaules.%SPEECH_ON%Abattez-les, bien sûr.%SPEECH_OFF% | Vous entrez dans la tente de %commander% pour le trouver s\'éloignant d\'un homme assis. Le commandant a des pinces dans les mains et il y a une dent blanche serrée entre les branches. Vous remarquez que l\'homme assis est évanoui, la tête ballotant, le sang coulant de sa bouche. %commander% lance les pinces sur sa table et passe une main dans ses cheveux rougis.%SPEECH_ON%Certains de mes hommes ont déserté. Je ne peux pas risquer que cette armée se défasse, pas à cette heure, pas lorsque la bataille est si proche. Mon petit ami ici, lorsqu\'il parlait encore de toute façon, m\'a dit que ses compatriotes avaient jugé bon de s\'enfuir %direction% d\'ici. Allez, mercenaire, et ramenez-moi ces déserteurs.%SPEECH_OFF%Avant de partir, vous demandez quoi faire si les déserteurs refusent de revenir. Le commandant vous dévisage.%SPEECH_ON%Qu\'est-ce que tu penses ? Tuez-les tous !%SPEECH_OFF% | Vous trouvez %commander% en train de broyer du noir sur ses cartes. Ses poings s\'enfoncent dans sa table, les pieds gémissant et vacillants. Il regarde. Ses yeux flashent, un regard rapide d\'une colère incroyable.%SPEECH_ON%Certains de mes hommes ont jugé bon de déserter mon armée. Les guetteurs me disent les avoir vus s\'enfuir %direction% d\'ici. Allez les chercher et ramenez-les.%SPEECH_OFF%Vous demandez s\'il les veut vivants. Il hoche la tête.%SPEECH_ON%Je les veux de retour en pleine forme pour que je puisse mieux leur rappeler ce que cela signifie d\'abandonner mon armée. Bien sûr, s\'ils refusent catégoriquement, je les veux morts. C\'est aussi un bon rappel de ne pas abandonner l\'armée, n\'est-ce pas ?%SPEECH_OFF% | %commander% a attaché l\'un de ses lieutenants à l\'un des poteaux de la tente. Le commandant a une longue baguette en main et s\'en sert pour frapper le lieutenant sur la poitrine et les jambes. L\'homme crie, se tournant sur lui-même pour que son dos soit battu. Lorsque le lieutenant se retourne, son visage violet renifle dans l\'inconscience.\n\n %commander% jette la baguette par terre et commence à retirer les échardes de ses doigts.%SPEECH_ON%Content que tu sois venu, mercenaire. Quelques-uns de mes hommes ont déserté et j\'ai besoin que tu les retrouves. Ramène-les vivants, tue-les tous s\'ils refusent. Mon ami ici a dit qu\'ils ont fui %direction%. Pour son bien, j\'espère qu\'il dit la vérité.%SPEECH_OFF%Vous espérez qu\'il dit la vérité, vous aussi.}"
			Image = "",
			List = [],
			Options = [
				{
					Text = "The company will head out within the hour.",
					function getResult()
					{
						this.Contract.setState("Running_Deserters");
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
					this.Const.World.TerrainType.Shore,
					this.Const.World.TerrainType.Mountains
				]);
				local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(tile, "Deserters", false, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush("banner_deserters");
				party.setFootprintType(this.Const.World.FootprintsType.Nobles);
				party.setAttackableByAI(false);
				party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(playerTile, party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Nobles, 0.75);
				this.Contract.m.Destination = this.WeakTableRef(party);
				party.getLoot().Money = this.Math.rand(50, 100);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 6);

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
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				local c = party.getController();
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
			}

		});
		this.m.Screens.push({
			ID = "Deserters2",
			Title = "En vous approchant...",
			 Text = "[img]gfx/ui/events/event_88.png[/img]{Vous tombez sur les déserteurs assis autour d\'un feu de camp fumant, l\'un d\'eux jetant désespérément de la poussière sur les braises. Il s\'arrête en vous voyant. Le reste des déserteurs suit son regard avant de se lever précipitamment.%SPEECH_ON%On ne retourne pas. Vous pouvez dire à %commander% d\'aller en enfer.%SPEECH_OFF% | Les déserteurs se disputent entre eux lorsque vous perturbez leur petite fête de fugitifs. L\'un des hommes recule.%SPEECH_ON%%commander% vous a envoyé, n\'est-ce pas ? Eh bien, vous pouvez lui dire d\'aller en enfer.%SPEECH_OFF%Un autre homme serre le poing.%SPEECH_ON%Ouais, on n\'y retourne pas !%SPEECH_OFF%C\'est une bande indisciplinée, sans aucun doute. | %randombrother% signale un groupe d\'hommes debout près d\'un panneau de signalisation. Ils se disputent si bruyamment entre eux qu\'ils ne vous entendent pas approcher. Vous sifflez fort, ce qui les fait taire instantanément et les fait se retourner. L\'un d\'eux recule.%SPEECH_ON%Ce rat de commandant a envoyé des mercenaires après nous ?%SPEECH_OFF%Vous hochez la tête et expliquez qu\'ils devraient revenir avec vous. Un autre déserteur secoue la tête.%SPEECH_ON%Retourner là-bas ? Pourquoi n\'irais-tu pas te faire foutre ? On n\'y retourne pas, alors va dire ça au commandant.%SPEECH_OFF% | Les déserteurs sont en train de partager de la nourriture d\'un sac en laine. Ils s\'arrêtent à votre vue et l\'un d\'eux choisit d\'essayer d\'avaler sa nourriture d\'un coup. Il s\'étouffe. Le reste des hommes ne bouge pas. Le gars qui s\'étouffe se précipite pour demander de l\'aide, son visage devenant violet. Ses jambes battent sur le sac en laine, renversant de la nourriture partout. Vous hochez la tête.%SPEECH_ON%Aidez votre homme.%SPEECH_OFF%Les déserteurs courent rapidement vers l\'homme qui s\'étouffe et lui tapent dans le dos. Il halète. Vous commencez à expliquer ce que %commander% vous a demandé, mais l\'un des déserteurs vous interrompt.%SPEECH_ON%Non. Nous ne retournons pas. Cette guerre est une perte de temps et nous ne voulons pas y participer.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					 Text = "Est-ce ainsi que vous voulez être ? Des lâches qui ne défendront pas leurs propres terres ?",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "DesertersAcceptMotivation" : "DesertersRefuseMotivation";
      }
    },
    {
      Text = "Votre choix est simple. Combattez pour votre seigneur, ou mourrez ici.",
      function getResult()
      {
        return this.Math.rand(1, 100) <= 50 ? "DesertersAcceptThreats" : "DesertersRefuseThreats";
      }
    },
    {
      Text = "Soyons honnêtes sur ce dont il s\'agit. Voici %bribe% couronnes si vous revenez.",
      function getResult()
      {
        return "DesertersAcceptBribe";
      }

				}
			]
		});
		this.m.Screens.push({
			ID = "DesertersAcceptBribe",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Vous sortez un sac et y mettez %bribe% couronnes.%SPEECH_ON%Je vais personnellement vous payer pour revenir avec moi au camp de guerre. %commander% est furieux contre vous, ne vous méprenez pas là-dessus, mais il a besoin de chaque homme possible. Si vous combattez pour lui dans la bataille à venir, je ne doute pas qu\'il pardonnera cette petite erreur que vous avez commise.%SPEECH_OFF% | Vous offrez aux déserteurs %bribe% couronnes. Les hommes se regardent, puis vous parlent.%SPEECH_ON%Et à quoi ça sert l\'argent quand le commandant nous pendra tous ?%SPEECH_OFF%Vous hochez la tête et répondez.%SPEECH_ON%Bonne question, mais %commander% n\'est pas idiot. Il a besoin de tous les hommes qu\'il peut rassembler pour la bataille à venir. Montrez-vous dans cette bataille et cette petite fête que vous vous êtes organisée sera oubliée.%SPEECH_OFF%}{Les déserteurs réfléchissent à leurs options et finissent par accepter de revenir avec vous. | Les déserteurs se rassemblent et parviennent à un certain accord. Rompant la réunion, leur chef s\'avance.%SPEECH_ON%Malgré certaines objections, nous acceptons de revenir avec vous au camp de guerre. J\'espère ne pas le regretter.%SPEECH_OFF% | Après un court débat sur la marche à suivre, les déserteurs mettent cela aux voix. Ce n\'est pas unanime, mais ils parviennent à un accord : ils retourneront avec vous auprès de %commander%. | Les déserteurs débattent de ce qu\'il faut faire ensuite. Inévitablement, cela en vient à un vote. Prévisiblement, ce vote est égal. Les hommes acceptent alors de lancer une pièce : face, ils retournent au camp, pile, ils partent. Leur chef lance la pièce et tous les hommes regardent alors qu\'elle tourne et brille. La pièce atterrit sur face. Chacun d\'eux soupire en la voyant, comme si le hasard et la fortune les avaient soulagés d\'une énorme responsabilité au-delà de leur propre choix.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Cela devrait nous aider dans la bataille à venir.",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("Bribe"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					 text = "Vous dépensez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("Bribe") + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "DesertersAcceptThreats",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog% s\'avance, faisant tournoyer une arme par-dessus son épaule avec facilité. Il hoche la tête.%SPEECH_ON%Vous avez peur de %commander%. Je comprends ça. Vous le connaissez, vous connaissez son tempérament et ce dont il est capable. La question est...%SPEECH_OFF%Le mercenaire sourit, le sourire rusé reflété dans l\'éclat de sa lame.%SPEECH_ON%Me connaissez-vous ?%SPEECH_OFF% | Les déserteurs semblent prêts à partir quand %bigdog% siffle bruyamment.%SPEECH_ON%Hé, vous, merdes, mon commandant vous a donné un ordre.%SPEECH_OFF%L\'un des déserteurs ricane.%SPEECH_ON%Ouais ? Il n\'est pas notre foutu commandant, alors vous pouvez prendre cet ordre et le fourrer là où je pense.%SPEECH_OFF%%bigdog% sort une énorme lame et la plante dans le sol. Il pose ses mains sur le pommeau.%SPEECH_ON%Vous avez peur de %commander% et c\'est bien. Mais continuez à être une petite merde, mon ami, et nous verrons bien quel commandant vous auriez vraiment dû craindre.%SPEECH_OFF% | Les déserteurs se retournent pour partir. %bigdog% sort une énorme lame et la fait vibrer contre son armure. Lentement, les déserteurs se retournent. %bigdog% sourit.%SPEECH_ON%Est-ce que l\'un de vous a déjà pissé dans son froc ?%SPEECH_OFF%L\'un des déserteurs secoue la tête.%SPEECH_ON%H-hé mec, tire-toi avec ce discours.%SPEECH_OFF%%bigdog% saisit sa lame et pointe la pointe vers le déserteur.%SPEECH_ON%Oh, tu veux que je me taise ? Continuez à me parler comme ça et il n\'y aura bientôt plus personne qui parlera ici.%SPEECH_OFF%}{Les déserteurs réfléchissent à leurs options et finissent par accepter de revenir avec vous. | Les déserteurs se rassemblent et parviennent à un certain accord. Rompant la réunion, leur chef s\'avance.%SPEECH_ON%Malgré certaines objections, nous acceptons de revenir avec vous au camp de guerre. J\'espère ne pas le regretter.%SPEECH_OFF% | Après un court débat sur la marche à suivre, les déserteurs mettent cela aux voix. Ce n\'est pas unanime, mais ils parviennent à un accord : ils retourneront avec vous auprès de %commander%. | Les déserteurs débattent de ce qu\'il faut faire ensuite. Inévitablement, cela en vient à un vote. Prévisiblement, ce vote est égal. Les hommes acceptent alors de lancer une pièce : face, ils retournent au camp, pile, ils partent. Leur chef lance la pièce et tous les hommes regardent alors qu\'elle tourne et brille. La pièce atterrit sur face. Chacun d\'eux soupire en la voyant, comme si le hasard et la fortune les avaient soulagés d\'une énorme responsabilité au-delà de leur propre choix.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					 Text = "Vous avez pris la bonne décision.",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.m.Dude = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.player"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
					{
						candidates.push(bro);
					}
				}

				if (candidates.len() == 0)
				{
					candidates = brothers;
				}

				this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersAcceptMotivation",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Alors que les déserteurs s\'apprêtent à partir, %motivator% s\'avance et se raclant la gorge.%SPEECH_ON%Alors, c\'est comme ça que ça va se passer, hein ? Vous allez vous dérober à vos responsabilités comme une bande de bites molles ? Je sais ce que vous ressentez. Je sais que vous ne voyez aucun sens dans cette guerre ni à risquer votre vie pour quelque noble coincé qui n\'a aucune idée de ce que vous traversez. C\'est juste. Mais vous allez vous réveiller dans quelques années, en rebondissant votre petit-fils sur votre genou, et il vous posera des questions sur quand vous avez combattu pendant la guerre. Et vous devrez mentir à ce petit garçon.%SPEECH_OFF% | %motivator% met ses doigts à ses lèvres et siffle bruyamment. Les déserteurs se tournent vers lui alors qu\'il commence à parler.%SPEECH_ON%Alors c\'est ça, hein ? Vous allez délibérément vous charger de ça ? Et que dire à vos petits quand le moment viendra, hein ? Que vous étiez un déserteur bon à rien qui a laissé ses camarades mourir à votre place ? Et ne vous trompez pas, votre absence fera mourir des hommes qui ne devraient pas. Votre absence aura des conséquences au-delà de votre mesure !%SPEECH_OFF% | %motivator% appelle les déserteurs.%SPEECH_ON%D\'accord, alors vous partez maintenant. Jetez votre bannière et appelez cela une campagne. Et que se passe-t-il quand %feudfamily% gagne, hein ?%SPEECH_OFF%Un des déserteurs hausse les épaules.%SPEECH_ON%Ils ne me connaissent pas. Je vais retourner auprès de ma famille et travailler la ferme.%SPEECH_OFF%Riant, %motivator% secoue la tête.%SPEECH_ON%Est-ce ainsi ? Et que ferez-vous quand ces hommes étrangers viendront chez vous ? Quand ils verront votre femme ? Quand ils verront vos enfants ? Qu\'est-ce que vous pensez exactement que cette guerre représente ? Il n\'y aura pas de chez vous où retourner, imbécile !%SPEECH_OFF%}{Les déserteurs réfléchissent à leurs options et finissent par accepter de revenir avec vous. | Les déserteurs se rassemblent et parviennent à un certain accord. Rompant la réunion, leur chef s\'avance.%SPEECH_ON%Malgré certaines objections, nous acceptons de revenir avec vous au camp de guerre. J\'espère ne pas le regretter.%SPEECH_OFF% | Après un court débat sur la marche à suivre, les déserteurs mettent cela aux voix. Ce n\'est pas unanime, mais ils parviennent à un accord : ils retourneront avec vous auprès de %commander%. | Les déserteurs débattent de ce qu\'il faut faire ensuite. Inévitablement, cela en vient à un vote. Prévisiblement, ce vote est égal. Les hommes acceptent alors de lancer une pièce : face, ils retournent au camp, pile, ils partent. Leur chef lance la pièce et tous les hommes regardent alors qu\'elle tourne et brille. La pièce atterrit sur face. Chacun d\'eux soupire en la voyant, comme si le hasard et la fortune les avaient soulagés d\'une énorme responsabilité au-delà de leur propre choix.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					 Text = "Vous avez pris la bonne décision.",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.m.Dude = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local highest_bravery = 0;
				local best;

				foreach( bro in brothers )
				{
					if (bro.getCurrentProperties().getBravery() > highest_bravery)
					{
						best = bro;
					}
				}

				this.Contract.m.Dude = best;
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersRefuseThreats",
			Title = "En vous approchant...",
			 Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog% avance, faisant tournoyer une arme sur son épaule avec aisance. Il hoche la tête.%SPEECH_ON%Vous avez peur de %commander%. Je comprends. Vous le connaissez, vous connaissez son tempérament, et ce dont il est capable. La question est...%SPEECH_OFF%Le mercenaire sourit, le sourire rusé se reflétant dans l\'éclat de sa lame.%SPEECH_ON%Me connaissez-vous ?%SPEECH_OFF% | Les déserteurs semblent prêts à partir quand %bigdog% siffle bruyamment.%SPEECH_ON%Eh, vous merdes, mon commandant vous a donné un ordre.%SPEECH_OFF%Un des déserteurs ricane.%SPEECH_ON%Ouais ? Il n\'est pas notre foutu commandant, alors vous pouvez prendre cet ordre et vous le mettre là où je pense.%SPEECH_OFF%%bigdog% sort une énorme lame et la plante dans le sol. Il tente ses mains au sommet du pommeau.%SPEECH_ON%Vous avez peur de %commander% et c\'est bien. Mais continuez à être une petite merde, mon ami, et nous verrons quel commandant vous auriez vraiment dû craindre.%SPEECH_OFF% | Les déserteurs s\'apprêtent à partir. %bigdog% sort une énorme lame et la fait résonner contre son armure. Lentement, les déserteurs se retournent. %bigdog% sourit.%SPEECH_ON%Any one of you ever pissed your pants ?%SPEECH_OFF%L\'un des déserteurs secoue la tête.%SPEECH_ON%H-hey mec, tire-toi d\'ici avec ce discours.%SPEECH_OFF%%bigdog% attrape sa lame et pointe la pointe vers le déserteur.%SPEECH_ON%Oh, tu veux que je me taise ? Continue à me parler comme ça et il n\'y aura bientôt plus personne qui parlera ici.%SPEECH_OFF%}{Les déserteurs ne peuvent pas décider entre eux et mettent cela aux voix. Le choix de continuer à fuir l\'emporte. Leur chef vous informe de ce résultat démocratique et vous salue. %commander% n\'en sera pas content, mais vous tirez votre épée et dites aux hommes qu\'il n\'y a qu\'un autre chemin pour eux. Le chef se retourne, dégainant sa lame et faisant un signe de tête.%SPEECH_ON%D\'accord, je me disais bien que vous n\'étiez pas venus jusqu\'ici juste pour nous dire au revoir. En garde, les gars.%SPEECH_OFF% | %commander% n\'aimera pas ça, mais les déserteurs refusent de revenir. Ils ne voient aucune raison de sauter de nouveau dans la mêlée. Vous souhaitez bonne chance à leur chef. Il vous remercie, mais tombe rapidement silencieux lorsque vous tirez votre arme, le reste de la %companyname% faisant de même. Le chef soupire.%SPEECH_ON%Yeah, je pensais que ça se passerait comme ça.%SPEECH_OFF%Vous hochez la tête.%SPEECH_ON%Rien de personnel. Peu m\'importe ce que vous faites, mais c\'est une question d\'affaires et nous devons la mener à son terme.%SPEECH_OFF% | Les déserteurs ne peuvent pas prendre de décision, alors ils laissent le hasard décider : leur chef sort une pièce et la fait tournoyer dans les airs. Pile, ils retournent au camp, face, ils continuent de partir. C\'est pile. Les déserteurs soupirent collectivement. Leur chef vous tape sur l\'épaule.%SPEECH_ON%La fortune a décidé de notre sort.%SPEECH_OFF%Vous hochez la tête et tirez votre épée, le reste de la compagnie faisant de même.%SPEECH_ON%Gardez cela à l\'esprit quand nous vous tuerons tous.%SPEECH_OFF%Le chef sourit faiblement en tirant sa lame.%SPEECH_ON%C\'est tout à fait bien. Nous préférons mourir devant la porte de la liberté que de retourner à cette routine.%SPEECH_OFF% | Le chef refuse poliment de revenir.%SPEECH_ON%Nous n\'avons pas choisi ce chemin à la légère, mercenaire. Nous ne revenons pas.%SPEECH_OFF%Vous ordonnez à la %companyname% de sortir leurs armes. Le chef des déserteurs soupire, mais hoche la tête avec compréhension.%SPEECH_ON%Je suppose que c\'est comme ça que ça doit être. Nous en avons parlé, et nous sommes prêts à mourir ici, à marcher où nous le souhaitons, plutôt que de mourir là-bas sur ordre d\'un chien. C\'est tout le monde pour nous maintenant.%SPEECH_OFF%Haussant les épaules, vous répondez.%SPEECH_ON%Tis only business for us.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get this over with...",
					function getResult()
					{
						this.Contract.m.Dude = null;
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Deserters";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Contract.getFaction()
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							"banner_deserters"
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.player"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
					{
						candidates.push(bro);
					}
				}

				if (candidates.len() == 0)
				{
					candidates = brothers;
				}

				this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersRefuseMotivation",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Alors que les déserteurs s\'apprêtent à partir, %motivator% s\'avance et se raclare la gorge.%SPEECH_ON%Alors, c\'est comme ça que ça va se passer, hein ? Vous allez esquiver vos responsabilités comme une bande de lâches ? Je sais ce que vous ressentez. Je sais que vous ne voyez aucun sens dans cette guerre ou à risquer votre vie pour quelque noble prétentieux qui n\'a aucune idée de ce que vous traversez. C\'est juste. Mais vous vous réveillerez dans quelques années, rebondissant votre petit-fils sur votre genou, et il vous posera des questions sur quand vous avez combattu dans la guerre. Et vous devrez mentir à ce petit garçon.%SPEECH_OFF% | %motivator% met ses doigts sur ses lèvres et siffle fort. Les déserteurs se tournent vers lui alors qu\'il commence à parler.%SPEECH_ON%Alors c\'est ça, hein ? Vous allez délibérément vous charger de cela ? Et que direz-vous à vos petits quand le moment viendra, hein ? Que vous étiez un bon à rien déserteur qui a laissé mourir ses camarades à sa place ? Et ne vous y trompez pas, votre absence causera la mort d\'hommes qui n\'auraient pas dû mourir. Votre absence aura des conséquences au-delà de votre mesure !%SPEECH_OFF% | %motivator% crie aux déserteurs.%SPEECH_ON%D\'accord, alors vous partez maintenant. Abandonnez votre bannière et appelez cela une campagne. Et que se passe-t-il quand %feudfamily% gagne, hein ?%SPEECH_OFF%Un des déserteurs hausse les épaules.%SPEECH_ON%Il ne me connaissent pas. Je vais retourner chez moi avec ma famille et ma ferme.%SPEECH_OFF%Riant, %motivator% secoue la tête.%SPEECH_ON%C\'est ça ? Et que ferez-vous quand ces étrangers viendront chez vous ? Quand ils verront votre femme ? Quand ils verront vos enfants ? Qu\'est-ce que, exactement, pensez-vous que cette guerre signifie ? Il n\'y aura pas de maison pour vous où retourner, imbécile !%SPEECH_OFF%}{Les déserteurs ne peuvent pas décider entre eux et mettent cela aux voix. Le choix de continuer à fuir l\'emporte. Leur chef vous informe de ce résultat démocratique et vous salue. %commander% n\'en sera pas content, mais vous tirez votre épée et dites aux hommes qu\'il n\'y a qu\'un autre chemin pour eux. Le chef se retourne, dégainant sa lame et faisant un signe de tête.%SPEECH_ON%D\'accord, je me disais bien que vous n\'étiez pas venus jusqu\'ici juste pour nous dire au revoir. En garde, les gars.%SPEECH_OFF% | %commander% n\'aimera pas ça, mais les déserteurs refusent de revenir. Ils ne voient aucune raison de sauter de nouveau dans la mêlée. Vous souhaitez bonne chance à leur chef. Il vous remercie, mais tombe rapidement silencieux lorsque vous tirez votre arme, le reste de la %companyname% faisant de même. Le chef soupire.%SPEECH_ON%Yeah, je pensais que ça se passerait comme ça.%SPEECH_OFF%Vous hochez la tête.%SPEECH_ON%Rien de personnel. Peu m\'importe ce que vous faites, mais c\'est une question d\'affaires et nous devons la mener à son terme.%SPEECH_OFF% | Les déserteurs ne peuvent pas prendre de décision, alors ils laissent le hasard décider : leur chef sort une pièce et la fait tournoyer dans les airs. Pile, ils retournent au camp, face, ils continuent de partir. C\'est pile. Les déserteurs soupirent collectivement. Leur chef vous tape sur l\'épaule.%SPEECH_ON%La fortune a décidé de notre sort.%SPEECH_OFF%Vous hochez la tête et tirez votre épée, le reste de la compagnie faisant de même.%SPEECH_ON%Gardez cela à l\'esprit quand nous vous tuerons tous.%SPEECH_OFF%Le chef sourit faiblement en tirant sa lame.%SPEECH_ON%C\'est tout à fait bien. Nous préférons mourir devant la porte de la liberté que de retourner à cette routine.%SPEECH_OFF% | Le chef refuse poliment de revenir.%SPEECH_ON%Nous n\'avons pas choisi ce chemin à la légère, mercenaire. Nous ne revenons pas.%SPEECH_OFF%Vous ordonnez à la %companyname% de sortir leurs armes. Le chef des déserteurs soupire, mais hoche la tête avec compréhension.%SPEECH_ON%Je suppose que c\'est comme ça que ça doit être. Nous en avons parlé, et nous sommes prêts à mourir ici, à marcher où nous le souhaitons, plutôt que de mourir là-bas sur ordre d\'un chien. C\'est tout le monde pour nous maintenant.%SPEECH_OFF%Haussant les épaules, vous répondez.%SPEECH_ON%C\'est juste une question d\'affaires pour nous.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mettons fin à cela...",
					function getResult()
					{
						this.Contract.m.Dude = null;
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Deserters";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Contract.getFaction()
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							"banner_deserters"
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local highest_bravery = 0;
				local best;

				foreach( bro in brothers )
				{
					if (bro.getCurrentProperties().getBravery() > highest_bravery)
					{
						best = bro;
					}
				}

				this.Contract.m.Dude = best;
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersAftermath",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% nettoie sa lame sur la tabard de l\'un des cadavres.%SPEECH_ON%Dommage qu\'ils soient partis comme ça. Ils auraient pu vivre. Ils avaient le choix.%SPEECH_OFF%Vous haussez les épaules et répondez.%SPEECH_ON%Ils avaient la mort de tous les côtés. Ils nous ont simplement choisis comme bourreau.%SPEECH_OFF% | Les déserteurs sont morts tout autour de vous. L\'un d\'eux rampe sur le sol, toujours à distance de l\'armée de %commander%. Vous vous accroupissez à côté de lui, un poignard à la main pour finir le travail. Il rit de vous.%SPEECH_ON%Pas besoin de salir le poignard, mercenaire. Donnez-moi juste du temps. C\'est tout c-ce que j\'ai, augh.%SPEECH_OFF%Un éclat de sang coule le long de son menton. Ses yeux se rétrécissent, fixant droit devant lui, et il s\'effondre lentement sur le sol. Vous vous levez et dites à la compagnie de se préparer à partir. | Le dernier déserteur est retrouvé adossé à un rocher, ses mains pendantes le long de ses côtés, les deux tournées vers le haut comme un mendiant avec beaucoup d\'affaires. Il y a du sang qui coule le long de sa poitrine et de ses jambes et qui s\'amasse autour du sol. Il le regarde.%SPEECH_ON%Ça va, merci de demander, mercenaire.%SPEECH_OFF%Vous lui dites que vous n\'avez rien dit. Il vous regarde, vraiment confus.%SPEECH_ON%Vous n\'avez pas? Eh bien alors.%SPEECH_OFF%Un moment plus tard, il tombe sur le côté, le visage figé de cette manière morte. | Certains hommes aiment l\'hilarité d\'une vie condamnée. Avec tous les choix et la liberté qui leur sont enlevés, que reste-t-il à faire sinon rire au visage d\'un destin aussi cruel ? Chaque déserteur est mort avec un air d\'aplomb absolu sur son visage. | Le dernier déserteur vivant est retrouvé en train de regarder le ciel. Il pédale une main dans l\'air.%SPEECH_ON%Merde, je veux juste en voir un.%SPEECH_OFF%Vous demandez ce qu\'il veut voir. Il rit, un rire vigoureux rapidement interrompu par une montée de douleur.%SPEECH_ON%Un oiseau. Oh, il y en a un. Il est tellement grand, tellement beau.%SPEECH_OFF%Il pointe et vous regardez en l\'air. Un vautour tournoie au-dessus. Lorsque vous regardez à nouveau vers le bas, l\'homme est mort.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Malheureux, mais cela devait être fait.",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay2End",
			Title = "Au camp de guerre...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{%commander% vous informe que demain est le grand jour. Vous retournez à votre tente pour un repos bien mérité. | Vous retournez à %commander% et lui faites part de la nouvelle. Il est très calme, ses pensées absorbées par ce qui vient demain : une grande et décisive bataille. La journée terminée, vous décidez d\'aller vous coucher et d\'attendre le matin. | Vous faites votre rapport à %commander%, mais il ne réagit même pas. Il vit pratiquement dans ses cartes de bataille.%SPEECH_ON%Je vous verrai demain, mercenaire. Reposez-vous bien cette nuit car vous en aurez besoin.%SPEECH_OFF% | %commander% vous accueille dans sa tente, mais semble ignorer vos rapports. À la place, il est concentré sur ses cartes et continue de débattre avec ses lieutenants sur les plans de bataille de demain. Vous décidez d\'aller vous coucher et de passer une bonne nuit de repos. | %commander% fait signe de tête à vos rapports, mais il ne vous prête pas vraiment attention. Plusieurs cartes de bataille sont étalées sur une table et ses yeux sont rivés sur celles-ci. Vous comprenez : demain, c\'est la grande bataille et il a des choses plus importantes à penser. Vous décidez d\'aller vous coucher pour la nuit.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Reposez-vous bien cette nuit, car la bataille vous attend demain !",
					function getResult()
					{
						this.Flags.set("LastDay", this.World.getTime().Days);
						this.Flags.set("NextDay", 3);
						this.Contract.setState("Running_WaitForNextDay");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay3",
			Title = "Au camp de guerre...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%commander% marche devant un rassemblement de ses soldats. Certains semblent fatigués, n\'ayant pas dormi de la nuit. D\'autres tremblent encore d\'appréhension. Leur commandant s\'adresse à eux.%SPEECH_ON%Avez-vous peur ? Êtes-vous effrayés ? C\'est bien. Je m\'inquiéterais si ce n\'était pas le cas.%SPEECH_OFF%Des rires éparpillés détendent l\'atmosphère. Il continue.%SPEECH_ON%Mais pour l\'instant, je vous demande de ne pas avoir peur pour votre propre peau, mais plutôt d\'avoir peur pour la vie de vos compatriotes, de vos familles ! C\'est pour eux que nous combattons aujourd\'hui ! Occupons-nous de nous-mêmes demain, car aujourd\'hui, nous serons des hommes !%SPEECH_OFF%Les rires se transforment en acclamations retentissantes. | %commander% a ses hommes rassemblés devant lui. Fantassins, archers, réservistes, tous debout dans un vent fort. Le commandant les examine de haut en bas.%SPEECH_ON%Je sais ce que vous pensez, \'Pourquoi je me bats pour ce pauvre type. S\'il est si noble, où est son destrier pour se tenir dessus ?\'%SPEECH_OFF%Les soldats rient, relâchant un peu de tension. %commander% continue.%SPEECH_ON%Eh bien, moche ou pas, je n\'aime rien de mieux qu\'un bon combat. Et c\'est là que je serai, messieurs. Je serai là avec vous, combattant jusqu\'à ce que je ne puisse plus, combattant jusqu\'à la fin même, car c\'est ce qu\'un combattant est censé faire !%SPEECH_OFF%Les soldats lèvent les bras et acclament. Leur commandant se retourne, l\'épée levée.%SPEECH_ON%Maintenant, suivez-moi, et nous montrerons à %feudfamily% ce que signifie être des hommes !%SPEECH_OFF% | L\'armée hétéroclite de %commander% s\'est rassemblée pour la grande bataille. Marchant le long des lignes de bataille, le commandant entame un discours.%SPEECH_ON%Certains d\'entre vous ont l\'air épuisés. Quoi, vous êtes nerveux ? Moi aussi ! Pas fermé l\'œil.%SPEECH_OFF%Cela détend certains des hommes. Il est bon de savoir que vous n\'êtes pas seul, que ce soit dans la chair ou dans l\'esprit. Il continue.%SPEECH_ON%Mais je suis éveillé pour aujourd\'hui, pour ce combat. Je ne le manquerais pour rien au monde. Alors frottez-vous les yeux, messieurs, car aujourd\'hui nous montrons à ces salauds de %feudfamily% qu\'ils auraient dû rester dans leurs lits !%SPEECH_OFF% | %commander% s\'adresse à ses hommes qui se préparent. Vous n\'écoutez pas un mot. À la place, vous préparez vos hommes pour le combat à venir. | Vous regardez %commander% aller vers ses hommes et les bombarder de lignes inspirantes. Beaucoup que vous avez déjà entendues. En fait, ces lignes proviennent-elles d\'un vieux parchemin ? D\'un orateur motivant dont l\'énergie a été transmise à travers les générations ? %randombrother% vient vers vous en riant.%SPEECH_ON%Je sais que le commandant parle de la rhétorique creuse, mais je me sens quand même obligé de faire quelques pompes.%SPEECH_OFF%En riant, vous dites à l\'homme de se mettre en ligne avec le reste de la compagnie. Il réplique.%SPEECH_ON%Y aura-t-il un discours ?%SPEECH_OFF%Vous poussez l\'homme alors qu\'il s\'éloigne en riant. | %commander% marche de long en large devant ses lignes de bataille. Il arrive à un garçon qui tremble si fort que son armure en grince.%SPEECH_ON%Tu me rappelles moi, gamin, tu le sais ça ? Tu penses que je ne suis jamais passé par là ? Heh, prends ça cool, parce qu\'un jour tu pourrais être là où je suis.%SPEECH_OFF%Le gamin regarde avec une nouvelle lueur dans les yeux. Il se stabilise et hoche la tête avec détermination. Le commandant élève la voix, criant à ses hommes de se préparer pour la bataille de leur vie. | %commander% va vers ses hommes, criant que cette bataille est l\'événement le plus important qu\'ils vivront jamais. Vous n\'en êtes pas si sûr, mais ce qui est sûr, c\'est que ce sera la dernière chose que beaucoup d\'entre eux vivront. Les cruautés de la guerre ne constituent pas la meilleure des motivations, alors vous gardez la bouche fermée. | Vous resserrez vos bottes pendant que %commander% prépare ses hommes avec un grand discours pompeux sur l\'importance grandiose d\'une guerre entre les maisons nobles. C\'est très convaincant. Ça doit l\'être, si des hommes qui n\'ont rien à gagner de la lutte vont mourir. | %commander% se tient devant ses hommes. Il est vêtu d\'habits de bataille spectaculaires, se tenant au milieu de ses hommes comme une perle parmi le sable de la plage. Il explique qu\'ils doivent gagner la bataille, car la perdre pourrait aussi bien perdre toute la guerre. Il dit n\'importe quoi pour que les hommes s\'investissent, pensez-vous. Vous ne mourriez certainement pas pour une noblesse délicate simplement parce qu\'un commandant en quête d\'honneur l\'a deviné à partir d\'esprits politiques. En même temps, c\'est cette attitude qui fait de vous un mercenaire à la base. | La guerre est une sacrée chose. Comment vendre ça à un homme ? %commander% fait de son mieux, pontifiant sur de nombreux sujets en s\'adressant à ses hommes. D\'abord, il affirme que c\'est la chose honorable à faire. Ensuite, il affirme qu\'il y a beaucoup de soldats ici, augmentant certainement les chances qu\'un autre imbécile mourra à votre place. La santé en nombre ! Ensuite, il argumente que perdre cette bataille pourrait signifier perdre leurs femmes, leurs enfants, leur pays. Ce dernier argument semble fonctionner le mieux car les hommes rugissent de colère et d\'énergie. À travers la foule désormais joyeuse de soldats, vous pouvez facilement repérer les cyniques et les sodomites. | %commander% s\'adresse à ses hommes d\'un ton profond et fort.%SPEECH_ON%Ah, certains d\'entre vous ont l\'air très joyeux. Impatients de massacrer les hommes de %feudfamily%, hein ? Je connais ce sentiment.%SPEECH_OFF%Un éclat de rire nerveux. Le commandant continue.%SPEECH_ON%Gardez vos familles à l\'esprit, les gars, car elles dépendent sûrement de nous en ce jour !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "En avant, frères, il y a une bataille à remporter !",
					function getResult()
					{
						this.Contract.setState("Running_FinalBattle");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleLost",
			Title = "Après la bataille...",
			 Text = "[img]gfx/ui/events/event_86.png[/img]{Des cadavres partout. La silhouette du %commander% au sommet des cadavres, son armure scintillante, un écrin brillant d\'une ruine charnelle. %employer% sera sans aucun doute attristé par la perte de la bataille ici, mais il n\'y a plus rien à faire. | La bataille est perdue ! Les hommes de %commander% ont été tués, ne laissant qu\'une poignée de survivants, et le commandant lui-même a été abattu. Des vautours tournoient déjà au-dessus, et les hommes de %feudfamily% travaillent sans relâche à travers les monticules de cadavres pour tuer tout homme prétendant être mort. Vous rassemblez rapidement les restes de la %companyname% pour battre en retraite. %employer% sera sans aucun doute horrifié par les résultats ici, mais il n\'y a plus rien à faire maintenant.}",
			Image = "",
			List = [],
			Options = [
				{
					 Text = "Toutes les batailles ne peuvent pas être gagnées...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Lost an important battle");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWon",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Vous avez triomphé ! Eh bien, vous et les hommes de %commander% également. La bataille a été remportée, c\'est ce qui importe le plus. Vous marchez sur les monticules de cadavres pour vous préparer à retourner vers votre employeur. | Des cadavres empilés sur cinq rangs. Des vautours arrachent des morceaux des monticules. Des blessés implorent de l\'aide. Certainement, aux yeux d\'un étranger, il ne semble pas y avoir de vainqueur ici. %commander%, cependant, s\'approche avec un large sourire.%SPEECH_ON%{Bien joué, mercenaire ! Vous devriez retourner vers votre employeur et lui dire ce qui s\'est passé ici. | Eh bien, si ce n\'est pas le mercenaire. Je n\'étais pas sûr que vous y arriveriez. Vous devriez retourner vers votre employeur et lui dire ce qui s\'est passé ici.}%SPEECH_OFF% | Un homme blessé implore à vos pieds. Vous ne pouvez pas dire s\'il est l\'un des hommes de %commander% ou un ennemi. Soudain, une pointe de lance jaillit et transperce l\'homme à travers la tête, le laissant perpétuellement de côté. Vous regardez le tueur en train de frotter ses mains au sommet de la lance avec un air accompli. Il pointe du doigt.%SPEECH_ON%Tu es bien le mercenaire, non ? %commander% m\'a dit de te dire que tu devrais retourner chez ton employeur. Ça te semble correct ?%SPEECH_OFF%Vous hochez la tête. Un grognement s\'élève des monticules de cadavres. L\'homme reprend sa lance, la reprenant dans son autre main.%SPEECH_ON%Allez, au travail !%SPEECH_OFF% | La bataille terminée, vous trouvez %commander% rugissant et arrachant son armure et son maillot de corps. Il montre ses blessures, les fléchissant pour qu\'elles s\'ouvrent comme des écorces de fruit fraîchement coupé. Il demande à ses hommes d\'en faire de même, les retournant chacun pour qu\'il puisse voir leur dos%SPEECH_ON%Tu vois, les bons guerriers comme nous portent nos blessures ici, ici et ici...%SPEECH_OFF% Il montre chaque endroit sur le devant de son corps, puis il montre son dos.%SPEECH_ON%Mais ici, aucun homme ne porte de blessure ici. Parce que nous mourons en avançant, pas un pas en arrière ! N\'est-ce pas vrai ?%SPEECH_OFF% Les hommes applaudissent, bien que certains soient chancelants sur leurs pieds, le sang coulant de leurs blessures. Vous ignorez le théâtre et rassemblez les hommes de la %companyname%. Votre employeur sera certainement heureux d\'apprendre les résultats ici, et c\'est tout ce qui vous importe vraiment. | %commander% vous salue après la bataille. Il est trempé de sang comme s\'il avait coupé la tête de quelqu\'un et s\'était baigné sous le tronc qui crachait. Une lueur blanche des dents apparaît quand il sourit. %SPEECH_ON%Voilà ce que j\'appelle un combat.%SPEECH_OFF%Vous demandez s\'il dirait la même chose s\'il avait perdu. Il rit.%SPEECH_ON%Oh, le cynique, n\'est-ce pas ? Non, je n\'avais aucune intention de perdre ici et, si c\'était le cas, je n\'avais aucune intention d\'être en vie pour assister à ma propre défaite.%SPEECH_OFF%Vous hochez la tête et répondez.%SPEECH_ON%Rare est l\'homme qui a la chance de survivre pour voir sa plus grande défaite. C\'était bien de combattre avec vous, commandant, mais je dois retourner chez votre employeur maintenant.%SPEECH_OFF%Le commandant hoche la tête et se retourne, criant à quelqu\'un d\'aller lui chercher une serviette. | Vous trouvez %commander% accroupi sur un soldat ennemi blessé. Il passe un poignard le long de la poitrine du pauvre homme, de va-et-vient, le raclant le long de l\'armure. Le commandant vous regarde.%SPEECH_ON%Qu\'en penses-tu, mercenaire ? Devrais-je le laisser vivre ?%SPEECH_OFF%Le prisonnier vous fixe, il penche la tête en avant, clignant des yeux. Vous supposez que c\'est un \'oui\'. Vous haussez les épaules.%SPEECH_ON%Cela ne dépend pas de moi. Regarde, c\'était bien de combattre avec toi, mais je dois retourner chez ton employeur maintenant.%SPEECH_OFF%%commander% hoche la tête.%SPEECH_ON%Au revoir, alors.%SPEECH_OFF%En partant, le commandant est toujours là, penché à côté de son prisonnier, la lame cliquetant au fur et à mesure de ses allers-retours, de va-et-vient, de va-et-vient. | Vous trouvez %commander% en train de planter un poignard dans le côté de la poitrine d\'un homme blessé. L\'ennemi abattu cède à la douleur, mais il s\'efface rapidement, devenant mou en quelques instants. Un flot de sang suit la récupération de la lame alors que le commandant l\'essuie sur son pantalon.%SPEECH_ON%Droit au cœur, rapide et facile. Quel homme pourrait espérer mieux ?%SPEECH_OFF%Vous hochez la tête et dites au commandant que vous retournez chez votre employeur pour votre salaire. | Vous regardez %commander% et un groupe de soldats vadrouiller sur le champ de bataille, tuant tout ennemi blessé qu\'ils découvrent. %randombrother% demande si nous devrions rapporter au commandant. Vous secouez la tête.%SPEECH_ON%Non. Nous rapportons à votre employeur. À l\'enfer avec cet endroit, allons être payés.%SPEECH_OFF% | Le champ de bataille est jonché de morts et de ceux qui souhaiteraient l\'être. Les hommes de %commander% s\'affairent à rassembler leurs blessés et à tuer tout ennemi qu\'ils trouvent. Le commandant lui-même vous tapote l\'épaule, une éclaboussure de sang éclaboussant votre joue.%SPEECH_ON%Bon travail, mercenaire. Je n\'étais pas sûr que vos hommes tiendraient leur part du marché, mais vous l\'avez bien fait. Votre employeur devrait être très heureux de vous voir, je crois.%SPEECH_OFF% | Vous allez rassembler les hommes de la %companyname%. %commander% vient à vous, essuyant un chiffon sur une épée, le sang s\'en allant en grosses gouttes.%SPEECH_ON%Partir si tôt ?%SPEECH_OFF%Vous hochez la tête.%SPEECH_ON%C\'est votre employeur qui nous paie, alors c\'est vers lui que nous allons.%SPEECH_OFF%Le commandant remet son arme dans son fourreau et hoche la tête.%SPEECH_ON%Ça a du sens. Bon combat, mercenaire. Dommage que je ne puisse pas vous avoir dans mon unité. Vous les gars, vous devez continuer à courir après cette pièce, hein ?%SPEECH_OFF%}",
			List = [],
			Options = [
				{
					Text = "Victory!",
					function getResult()
					{
						local faction = this.World.FactionManager.getFaction(this.Contract.getFaction());
						local settlements = faction.getSettlements();
						local origin = settlements[this.Math.rand(0, settlements.len() - 1)];
						local party = faction.spawnEntity(this.World.State.getPlayer().getTile(), origin.getName() + " Company", true, this.Const.World.Spawn.Noble, 150);
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + faction.getBannerString());
						party.setDescription("Soldats professionnels au service des seigneurs locaux.");
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous trouvez %employer% ivre comme un polisson. Il vous fixe par-dessus le bord d\'une tasse et parle dans le creux avant de boire.%SPEECH_ON%Ah bon sang, tu es de retour.%SPEECH_OFF%La tasse s\'éloigne alors qu\'il avale. Vous rapportez rapidement votre succès. L\'homme sourit bien qu\'il soit tellement ivre qu\'il a l\'air presque confus.%SPEECH_ON%Alors c\'est fait. La victoire est mienne. C\'est ce que je voulais. J\'espère que trop de gens n\'ont pas péri à faire ce que je voulais.%SPEECH_OFF%Il éclate de rire. Un de ses gardes vous tend une bourse et vous sort de la pièce. | %employer% vous accueille avec une bourse de couronnes.%SPEECH_ON%{La victoire est à nous. Merci, mercenaire. | Un sacré boulot là-bas, mercenaire. La victoire nous appartient et nous avons, en partie, à te remercier pour cela. Tes %reward_completion% couronnes sont juste ici. | Combien était-ce, %reward_completion% couronnes ? Un petit prix à payer pour avoir vaincu cette armée et nous rapprocher un peu plus de la fin de cette guerre. | Mes petits oiseaux m\'ont dit que tu t\'en es bien sorti là-bas, mercenaire. Bien sûr, ils me disent aussi que l\'armée de %feudfamily% est en retraite. Que pourrais-je demander de plus ? Tes %reward_completion% couronnes, comme promis.}%SPEECH_OFF% | Vous trouvez %employer% hurlant des ordres à ses commandants. En vous voyant, il pointe rapidement dans votre direction.%SPEECH_ON%Voyez cet homme ici ? C\'est un homme qui fait le travail. Gardes ! Donnez-lui %reward_completion% couronnes. Si seulement je pouvais vous payer, sales chiens, pour faire la moitié d\'aussi bon boulot que lui !%SPEECH_OFF% | %employer% se trouve dans son jardin à raconter des blagues à un groupe de femmes. Vous vous frayez un chemin jusqu\'à leur groupe, trempé de sang, couvert de boue. Les femmes poussent des cris et s\'éloignent. %employer% rit.%SPEECH_ON%Ah, le mercenaire revient ! Tu es vraiment un séducteur, mercenaire. J\'aimerais pouvoir vous offrir l\'une de ces belles femmes, mais j\'ai bien peur que leurs pères ne vous coupent les noix si vous les touchez ne serait-ce qu\'un peu.%SPEECH_OFF%L\'une des dames passe une main le long de son corsage.%SPEECH_ON%Il peut me toucher s\'il veut.%SPEECH_OFF%%employer% rit à nouveau.%SPEECH_ON%Oh mon cher, n\'as-tu pas déjà mis assez d\'hommes dans l\'embarras ? Courez, mesdemoiselles, et dites à l\'un de mes gardes d\'aller chercher une bourse de %reward_completion% couronnes.%SPEECH_OFF% | Vous trouvez %employer% en train d\'essayer d\'apprendre à son chat à donner la patte.%SPEECH_ON%Regardez ce petit voyou. Il ne veut même pas me regarder dans les yeux ! Et quand je le nourris, il se comporte comme si c\'était attendu de ma part. Je pourrais foutre ce petit fark par cette fenêtre maudite si je voulais.%SPEECH_OFF%Vous répondez.%SPEECH_ON%Il atterrirait sur ses pattes.%SPEECH_OFF%Le noble hoche la tête.%SPEECH_ON%C\'est la partie maudite.%SPEECH_OFF%Votre employeur prend le chat résilient et le jette par la fenêtre. Il bat des mains avant de vous donner une bourse de %reward_completion% couronnes.%SPEECH_ON%Désolé si j\'ai l\'air préoccupé. Vous vous en êtes bien sorti là-bas. L\'armée de %feudfamily% en retraite et je ne pourrais pas demander plus en ces jours.%SPEECH_OFF% | Vous trouvez %employer% en train de faire un procès improvisé à l\'un de ses commandants. Vous n\'êtes pas sûr de quoi il s\'agit, mais le menton du commandant est haut et défiant. Lorsque c\'est fini, il est malmené et emmené dehors. %employer% vous fait signe de vous approcher.%SPEECH_ON%{Merci, mercenaire. La victoire est à nous et je ne suis pas sûr que cela aurait pu être le cas sans votre aide. Bien sûr, votre récompense de %reward_completion% couronnes, comme convenu. | L\'homme a refusé mes ordres, c\'est comme ça. Vous, en revanche, avez excellé ! Vos %reward_completion% couronnes, comme convenu. | Cet homme ne voulait pas se battre pour moi. Il a dit qu\'il ne lèverait pas une épée contre son demi-frère qui combat pour l\'ennemi. Quelle foutaise. Vous avez bien fait, mercenaire. Vos %reward_completion% couronnes, comme promis.}%SPEECH_OFF% | Vous retournez chez %employer% qui se trouve au milieu d\'une ligne de commandants.%SPEECH_ON%{Merci, mercenaire. La victoire nous appartient maintenant. Vos %reward_completion% couronnes, comme convenu. | La guerre continue, mais la fin est peut-être proche à cause de vous. Avec l\'armée ennemie en pleine retraite, nous sommes un pas de plus vers la fin de cette maudite chose. Vos %reward_completion% couronnes sont des couronnes bien méritées, mercenaire.}%SPEECH_OFF% | L\'un des gardes de %employer% vous empêche de vous approcher. Il porte une bourse de %reward_completion% couronnes qui est rapidement remise.%SPEECH_ON%Mon suzerain me dit que vous avez bien fait en bataille.%SPEECH_OFF%Le garde regarde autour de lui mal à l\'aise.%SPEECH_ON%C\'était... c\'était tout ce que je devais dire.%SPEECH_OFF% | %employer% vous accueille dans sa salle de guerre qui a été vidée de ses commandants.%SPEECH_ON%Bien de te revoir, mercenaire. Comme tu le sais certainement, l\'armée de %feudfamily% est déjà en retraite. Qui sait si nous aurions pu le faire sans toi. %reward_completion% couronnes rien que pour toi, comme convenu.%SPEECH_OFF% | %employer% nourrit un grand oiseau idiot. Vous n\'avez jamais vu un oiseau de cette taille auparavant et vous gardez vos distances. Un noble amusé parle alors qu\'il laisse la créature manger dans sa main.%SPEECH_ON%Rien à craindre ici, mercenaire. Juste pour que vous le sachiez, j\'ai déjà entendu parler de vos exploits. L\'armée de %feudfamily% est en retraite et nous nous rapprochons un peu plus de la fin de cette maudite guerre. Ce garde là-bas, celui qui tient la bourse, a vos %reward_completion% couronnes.%SPEECH_OFF%L\'oiseau bat des ailes et criaille alors que vous partez. | Vous trouvez %employer% près d\'un étang artificiel. Il ramasse des grenouilles avec une main douce. Les bestioles glissantes s\'agitent et sautent loin.%SPEECH_ON%La victoire nous appartient. Je dirais que c\'est un travail bien fait, mercenaire. Je t\'ai donné une énorme opportunité et tu l\'as vraiment... sautée.%SPEECH_OFF%Vous avez dû faire une grimace, car le noble se lève rapidement, s\'essuyant les mains sur son pantalon.%SPEECH_ON%Mince, ce n\'était pas si mal, non ? Bon, le garde là-bas a votre paiement de %reward_completion% couronnes.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Won an important battle");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isCivilWar())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
			}

		});
	}

	function onCommanderPlaced( _entity, _tag )
	{
		_entity.setName(this.m.Flags.get("CommanderName"));
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.World.FactionManager.getFaction(this.getFaction()).getName()
		]);
		_vars.push([
			"feudfamily",
			this.World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse")).getName()
		]);
		_vars.push([
			"commander",
			this.m.Flags.get("CommanderName")
		]);
		_vars.push([
			"objective",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"cost",
			this.m.Flags.get("RequisitionCost")
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);

		if (this.m.Flags.get("IsInterceptSupplies"))
		{
			_vars.push([
				"supply_start",
				this.World.getEntityByID(this.m.Flags.get("InterceptSuppliesStart")).getName()
			]);
			_vars.push([
				"supply_dest",
				this.World.getEntityByID(this.m.Flags.get("InterceptSuppliesDest")).getName()
			]);
		}

		if (this.m.Dude != null)
		{
			_vars.push([
				"bigdog",
				this.m.Dude.getName()
			]);
			_vars.push([
				"motivator",
				this.m.Dude.getName()
			]);
		}

		if (this.m.Destination == null)
		{
			_vars.push([
				"direction",
				this.m.WarcampTile == null ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.WarcampTile)]
			]);
		}
		else
		{
			_vars.push([
				"direction",
				this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Warcamp != null && !this.m.Warcamp.isNull())
			{
				this.m.Warcamp.die();
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Warcamp != null && !this.m.Warcamp.isNull())
		{
			_out.writeU32(this.m.Warcamp.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local warcamp = _in.readU32();

		if (warcamp != 0)
		{
			this.m.Warcamp = this.WeakTableRef(this.World.getEntityByID(warcamp));
		}

		this.contract.onDeserialize(_in);
	}

});


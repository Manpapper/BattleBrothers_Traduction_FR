this.siege_fortification_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Allies = []
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

		this.m.Type = "contract.siege_fortification";
		this.m.Name = "Siege Fortification";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
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

		this.m.Flags.set("ObjectiveName", this.m.Origin.getName());
		this.m.Flags.set("RivalHouseID", this.m.Origin.getOwner().getID());
		this.m.Flags.set("RivalHouse", this.m.Origin.getOwner().getName());
		this.m.Flags.set("WaitUntil", 0.0);
		this.m.Name = "Siege %objective%";
		this.m.Flags.set("CommanderName", this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]);
		this.m.Payment.Pool = 1550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Voyagez jusqu\'à %objective% %direction%",
					"Help in the siege"
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
				this.Contract.m.Origin.getOwner().addPlayerRelation(-99.0, "Took sides in the war");
				local r = this.Math.rand(1, 100);

				if (r <= 50)
				{
					this.Flags.set("IsTakingAction", true);
					local r = this.Math.rand(1, 100);

					if (r <= 50)
					{
						this.Flags.set("IsAssaultTheGate", true);
					}
					else if (r <= 80)
					{
						this.Flags.set("IsBurnTheCastle", true);
					}
					else
					{
						this.Flags.set("IsPlayerDecision", true);
					}
				}
				else
				{
					this.Flags.set("IsMaintainingSiege", true);
					r = this.Math.rand(1, 100);

					if (r <= 25)
					{
						this.Flags.set("IsNighttimeEncounter", true);
					}
					else
					{
						this.Flags.set("IsReliefAttack", true);
						r = this.Math.rand(1, 100);

						if (r <= 40)
						{
							this.Flags.set("IsSurrender", true);
						}
						else
						{
							this.Flags.set("IsDefendersSallyForth", true);
						}
					}
				}

				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (!this.Flags.get("IsSecretPassage") && !this.Flags.get("IsSurrender"))
					{
						this.Flags.set("IsPrisoners", true);
					}
				}

				this.Contract.spawnSiege();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}
			}

			function update()
			{
				if (this.Contract.isPlayerNear(this.Contract.m.Origin, 300))
				{
					this.Contract.setScreen("TheSiege");
					this.World.Contracts.showActiveContract();

					foreach( a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally != null)
						{
							ally.setAttackableByAI(true);
						}
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_Wait",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Maintenez le siège de %objective%",
					"Interceptez tous ceux qui essaient de passer"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Time.getVirtualTimeF() < this.Flags.get("WaitUntil"))
				{
					return;
				}

				this.Contract.m.Origin.getOwner().addPlayerRelation(-99.0, "Took sides in the war");

				foreach( i, a in this.Contract.m.Allies )
				{
					local ally = this.World.getEntityByID(a);

					if (ally == null || !ally.isAlive())
					{
						this.Contract.m.Allies.remove(i);
					}
				}

				if (this.Contract.isPlayerNear(this.Contract.m.Origin, 300))
				{
					if (this.Flags.get("IsReliefAttackForced"))
					{
						if (this.World.getTime().IsDaytime)
						{
							this.Contract.setScreen("ReliefAttack");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsSurrenderForced"))
					{
						this.Contract.setScreen("Surrender");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsDefendersSallyForthForced"))
					{
						this.Contract.setScreen("DefendersSallyForth");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsTakingAction"))
					{
						if (this.World.getTime().IsDaytime)
						{
							if (this.Flags.get("IsPlayerDecision"))
							{
								this.Contract.setScreen("TakingAction");
								this.World.Contracts.showActiveContract();
							}
							else
							{
								this.Contract.setState("Running_TakingAction");
							}
						}
					}
					else if (this.Flags.get("IsMaintainingSiege"))
					{
						this.Contract.setScreen("MaintainSiege");
						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_TakingAction",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Participez à l\'assault de %objective%"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Time.getVirtualTimeF() < this.Flags.get("WaitUntil"))
				{
					return;
				}

				if (this.Flags.get("IsLost"))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssaultTheGate") && !this.TempFlags.get("AssaultTheGateShown"))
				{
					this.TempFlags.set("AssaultTheGateShown", true);
					this.Contract.setScreen("AssaultTheGate");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssaultAftermath"))
				{
					this.Contract.setScreen("AssaultAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssaultTheCourtyard") && !this.TempFlags.get("AssaultTheCourtyardShown"))
				{
					this.TempFlags.set("AssaultTheCourtyardShown", true);
					this.Contract.setScreen("AssaultTheCourtyard");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBurnTheCastleAftermath"))
				{
					this.Contract.setScreen("BurnTheCastleAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBurnTheCastle") && !this.TempFlags.get("BurnTheCastleShown"))
				{
					this.TempFlags.set("BurnTheCastleShown", true);
					this.Contract.setScreen("BurnTheCastle");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					foreach( i, a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally == null || !ally.isAlive())
						{
							this.Contract.m.Allies.remove(i);
						}
					}

					if (this.Contract.m.Allies.len() == 0)
					{
						this.Contract.setScreen("Failure");
						this.World.Contracts.showActiveContract();
						return;
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "AssaultTheGate")
				{
					this.Flags.set("IsAssaultTheGate", false);
					this.Flags.set("IsAssaultTheCourtyard", true);
				}
				else if (_combatID == "AssaultTheCourtyard")
				{
					this.Flags.set("IsAssaultTheCourtyard", false);
					this.Flags.set("IsAssaultAftermath", true);
				}
				else if (_combatID == "BurnTheCastle")
				{
					this.Flags.set("IsBurnTheCastle", false);
					this.Flags.set("IsBurnTheCastleAftermath", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "AssaultTheGates" || _combatID == "AssaultTheCourtyard" || _combatID == "BurnTheCastle")
				{
					this.Flags.set("IsLost", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_NighttimeEncounter",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Maintenez le siège de %objective%",
					"Interceptez tous ceux qui essaient de passer"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Time.getVirtualTimeF() < this.Flags.get("WaitUntil") || this.World.getTime().IsDaytime)
				{
					return;
				}

				if (this.Flags.get("IsNighttimeEncounterLost"))
				{
					this.Contract.setScreen("NighttimeEncounterFail");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsNighttimeEncounterAfermath"))
				{
					this.Contract.setScreen("NighttimeEncounterAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsNighttimeEncounter") && !this.TempFlags.get("NighttimeEncounterShown"))
				{
					if (!this.World.getTime().IsDaytime)
					{
						this.TempFlags.set("NighttimeEncounterShown", true);
						this.Contract.setScreen("NighttimeEncounter");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					foreach( i, a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally == null || !ally.isAlive())
						{
							this.Contract.m.Allies.remove(i);
						}
					}

					if (this.Contract.m.Allies.len() == 0)
					{
						this.Contract.setScreen("Failure");
						this.World.Contracts.showActiveContract();
						return;
					}
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (!_actor.isPlayerControlled())
				{
					this.Flags.set("IsNighttimeEncounterLost", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "NighttimeEncounter")
				{
					this.Flags.set("IsNighttimeEncounter", false);
					this.Flags.set("IsNighttimeEncounterAfermath", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "NighttimeEncounter")
				{
					this.Flags.set("IsNighttimeEncounterLost", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_SecretPassage",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Faufilez-vous dans %objective% avant que la nuit se termine",
					"Assassinez le commandant ennemi"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setOnCombatWithPlayerCallback(this.onSneakIn.bindenv(this));
					this.Contract.m.Origin.setAttackable(true);
				}
			}

			function end()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.setOnCombatWithPlayerCallback(null);
					this.Contract.m.Origin.setAttackable(false);
				}
			}

			function update()
			{
				if (this.Flags.get("IsSecretPassageWin"))
				{
					this.Contract.setScreen("SecretPassageAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsSecretPassageLost"))
				{
					this.Contract.setScreen("SecretPassageFail");
					this.World.Contracts.showActiveContract();
				}
				else if (this.World.getTime().IsDaytime)
				{
					this.Contract.setScreen("FailedToReturn");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					foreach( i, a in this.Contract.m.Allies )
					{
						local ally = this.World.getEntityByID(a);

						if (ally == null || !ally.isAlive())
						{
							this.Contract.m.Allies.remove(i);
						}
					}

					if (this.Contract.m.Allies.len() == 0)
					{
						this.Contract.setScreen("Failure");
						this.World.Contracts.showActiveContract();
						return;
					}
				}
			}

			function onSneakIn( _dest, _isPlayerAttacking = true )
			{
				if (!this.TempFlags.get("IsSecretPassageShown"))
				{
					this.TempFlags.set("IsSecretPassageShown", true);
					this.Contract.setScreen("SecretPassage");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "SecretPassage";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
					this.Contract.flattenTerrain(p);
					p.Entities = [];
					p.EnemyBanners = [
						this.Contract.m.Origin.getOwner().getBannerSmall()
					];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
					p.Entities.push({
						ID = this.Const.EntityType.Knight,
						Variant = 0,
						Row = 2,
						Script = "scripts/entity/tactical/humans/knight",
						Faction = this.Contract.m.Origin.getOwner().getID(),
						Callback = this.onEnemyCommanderPlaced
					});
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onEnemyCommanderPlaced( _entity, _tag )
			{
				_entity.getFlags().set("IsFinalBoss", true);
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsFinalBoss") == true)
				{
					this.Flags.set("IsSecretPassageWin", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "SecretPassage")
				{
					this.Flags.set("IsSecretPassageWin", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "SecretPassage" && !this.Flags.get("IsSecretPassageWin"))
				{
					this.Flags.set("IsSecretPassageFail", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReliefAttack",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Maintenez le siège de %objective%",
					"Interceptez tous ceux qui essaient de passer"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Flags.get("IsReliefAttackLost"))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
					return;
				}

				local isAlive = false;

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive() && e.getFaction() == this.Contract.m.Origin.getOwner().getID())
					{
						isAlive = true;

						if (e.getDistanceTo(this.Contract.m.Origin) <= 250)
						{
							this.onCombatWithPlayer(e, false);
							return;
						}
					}
				}

				if (this.Flags.get("IsReliefAttackWon") || !isAlive)
				{
					this.Contract.setScreen("ReliefAttackAftermath");
					this.World.Contracts.showActiveContract();
					return;
				}

				foreach( i, a in this.Contract.m.Allies )
				{
					local ally = this.World.getEntityByID(a);

					if (ally == null || !ally.isAlive())
					{
						this.Contract.m.Allies.remove(i);
					}
				}

				if (this.Contract.m.Allies.len() == 0)
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
					return;
				}
			}

			function onCombatWithPlayer( _dest, _isPlayerAttacking = true )
			{
				_dest.setPos(this.World.State.getPlayer().getPos());
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.CombatID = "ReliefAttack";
				p.Music = this.Const.Music.NobleTracks;
				p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
				p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
				p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall());
				p.EnemyBanners.push(_dest.getBanner());
				this.Contract.flattenTerrain(p);
				local alliesIncluded = false;

				for( local i = 0; i < p.Entities.len(); i = ++i )
				{
					if (this.World.FactionManager.isAlliedWithPlayer(p.Entities[i].Faction))
					{
						alliesIncluded = true;
					}
				}

				if (!alliesIncluded && _dest.getDistanceTo(this.Contract.m.Origin) <= 400)
				{
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local e = this.World.getEntityByID(id);

						if (e.isAlliedWithPlayer())
						{
							e.die();
							break;
						}
					}
				}

				this.World.Contracts.startScriptedCombat(p, false, true, true);
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "ReliefAttack")
				{
					this.Flags.set("IsReliefAttackWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "ReliefAttack")
				{
					this.Flags.set("IsReliefAttackLost", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_DefendersSallyForth",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Maintenez le siège de %objective%",
					"Interceptez tous ceux qui essaient de passer"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Origin.getDistanceTo(this.World.State.getPlayer()) >= 800)
				{
					this.Contract.setScreen("TooFarAway");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Flags.get("IsDefendersSallyForthLost"))
				{
					this.Contract.setScreen("DefendersPrevail");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsDefendersSallyForthWon"))
				{
					this.Contract.setScreen("DefendersAftermath");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.Contract.m.Origin.getOwner().addPlayerRelation(-99.0, "Took sides in the war");
					this.Contract.setScreen("DefendersSallyForth");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "DefendersSallyForth")
				{
					this.Flags.set("IsDefendersSallyForthWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "DefendersSallyForth")
				{
					this.Flags.set("IsDefendersSallyForthLost", true);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + 5.0);
			}

			function update()
			{
				if (this.Flags.get("IsPrisoners") && this.Time.getVirtualTimeF() <= this.Flags.get("WaitUntil"))
				{
					this.Contract.setScreen("Prisoners");
					this.World.Contracts.showActiveContract();
				}

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
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% welcomes you into his room. He\'s got a map laid out on a desk. It is dotted with military trinkets, little wooden emblems made to represent the armies moving back and forth across a world at war. The nobleman points to one in particular.%SPEECH_ON%I need you to go here and talk to %commander%. He is besieging the fortifications there and needs your help in finalizing an assault. You\'ll be paid %reward% crowns which I believe should be more than sufficient, no?%SPEECH_OFF% | You enter %employer%\'s war room and bring sudden silence to a throng of generals and commanders grouped around battle maps. %employer% waves you in and brings you to a side. The military men glare at you for a time before slowly returning to their strategic talks. %employer% explains his situation.%SPEECH_ON%I have commander %commander% besieging the fortifications at %objective%. He needs a few more men to start the assault which is where you come in. Go there, help him, and I will pay you a more than sufficient %reward% crowns in return. Sounds fair, no?%SPEECH_OFF% | Before you can enter %employer%\'s room, he springs out and takes you by a shoulder. He walks you down a hall and comes to a window, speaking as he stares at the courtyard.%SPEECH_ON%My generals need not see you. They don\'t find honor in your vocation. Sometimes a bit of political tact is required in hiring mercenaries.%SPEECH_OFF%You shake your head and respond tersely.%SPEECH_ON%We kill just as they do.%SPEECH_OFF%The nobleman nods.%SPEECH_ON%Of course, sellsword, but perhaps in the future you will be killing us. This keeps my generals up at night, some concerned, others angry. I understand the reality of the world we live in and so I sleep like a baby, understand? So let us conduct business. I need you to go to %objective% and aid commander %commander% in assaulting the fortification there. You will be paid %reward% crowns for your work.%SPEECH_OFF% | %employer% meets you and takes you to his garden. Given the state of things, he seems oddly at ease. He grazes a vine of tomatoes and begins to talk.%SPEECH_ON%War is a hell of a thing. Men are dying as we speak because I spoke a few words. Just like that. I don\'t want to misuse my power.%SPEECH_OFF%You jack your thumbs into your beltline and respond.%SPEECH_ON%For the sake of my men, I hope you do not.%SPEECH_OFF%%employer% nods and grabs a tomato. The vine goes taut before snapping free. He takes a bite then nods again, as though the life of a gardener is the one he\'d prefer.%SPEECH_ON%I have a commander by the name of %commander% currently sieging %objective%. He is finalizing plans to start an assault. I\'m sure that word scares you, but he has been working on this plan for some time. He just needs the last bit of men to make sure it fires off without issue. Go to him, help him, and I will pay you %reward% crowns.%SPEECH_OFF% | %employer% greets you and brings you to one of his battle maps. He points at %objective%.%SPEECH_ON%Commander %commander% is currently sieging their fortifications. I need sturdy men to help him launch the assault. Go there, help him, and I will pay you %reward% crowns. Sounds good, no?%SPEECH_OFF% | When you enter %employer%\'s room you find a bevy of commanders standing around a map. Little tokens representing nobility pepper the paper. One man uses a stick to push a wooden horse across some poorly drawn plains. %employer% welcomes you, but one of his generals takes you to a side and explains what they need: \n\n Commander %commander% is currently in %objective% conducting a siege. The defenders are about to break, but he\'s worried that relief is on its way. He wants to launch the final assault before aid can come to the defenders. Go there, help the commander with whatever he needs, and you will be paid %reward% crowns. | You stop outside %employer%\'s door and ask yourself, Do you need this shit in your life? Suddenly, a servant bumps into you with a chest of crowns. He asks if %employer% is inside because the %reward% crowns are ready for delivery to the sellsword. You quickly butt ahead of the servant and enter the room. %employer% welcomes you warmly. He explains that commander %commander% is currently sieging %objective% and is about to have a breakthrough. He just needs a few more men to push things over the edge. %employer% pretends to think and then finally adds.%SPEECH_ON%%reward% crowns will be in it for you.%SPEECH_OFF%You feign surprise at this amount. | You\'re not sure if the war is going well for %employer%, or if all his generals always appear this stressed during times like these. They look like they\'d rather fall on their swords than spend another second staring at a battle map. %employer% is sitting in the corner of the room next to a fire and a servant holding a pitcher of wine. The nobleman waves you over and begins to talk.%SPEECH_ON%Don\'t mind the grumps. The war is fine. Everything is fine. Just to show you how fine it is, I need you to go talk to commander %commander% at %objective% because his siege of that damned fortification is about to come to an end. Victory is at hand and all you have to do is help me take it! How do %reward% crowns sound?%SPEECH_OFF% | You enter %employer%\'s room to find the nobleman slunk down in a comfy looking chair. There are two large dogs napping at his feet and a purring cat in his lap. He is completely clonked out, snoring loudly with a dripping goblet somehow still wrenched in an outstretched arm. A man adorned in a general\'s attire beckons you across the room.%SPEECH_ON%Don\'t mind the lord. The war has weighed heavy on his mind. Now, listen. I\'ve got my orders, and I\'ve got yours. We need you to go to %objective% and help commander %commander% in sieging the fortifications there. That is all.%SPEECH_OFF%You inquire about pay. The general\'s face sours.%SPEECH_ON%Yes. Pay. Of course. I was to promise you %reward% crowns. I hope it is sufficient for your... honorable services.%SPEECH_OFF%Those final words seem to pain the man. It is clear he\'s been instructed to be as diplomatic as possible. | One of %employer%\'s generals meets you outside in the hall.%SPEECH_ON%The lordship is busy.%SPEECH_OFF%He plants a scroll in your chest. You unfurl it and read. Per the writing, one commander %commander% is currently sieging %objective% and needs help. No doubt this is where the %companyname% is supposed to come in. You look up at the man. He grumbles and speaks through gritted teeth.%SPEECH_ON%Your pay is to be %reward% crowns, your honorable sellsword.%SPEECH_OFF%Those last words seem coached. | You find %employer% and he takes you out to his personal kennels. He throws scraps to the dogs as he walks and talks.%SPEECH_ON%The war is going great. It is simply the greatest event I\'ve ever undertaken and I\'m in utter bliss about the whole affair.%SPEECH_OFF%He pets one of the mutts behind the ear before letting the dog lick his fingers.%SPEECH_ON%But not all is what it could be. I need you to go to %objective% to aid commander %commander% who is leading the siege there. %reward% crowns will be paid for your help.%SPEECH_OFF%A servant runs over with a live chicken. The nobleman takes it by the legs and heaves it into a cage of barking dogs. The poultry flaps madly, bouncing along a sea of jawing canines before suddenly getting snatched down. It\'s torn to shreds in mere moments. %employer% turns to you, brushing a feather off your shoulder.%SPEECH_ON%So, do we have a deal?%SPEECH_OFF% | %employer% welcomes you into his room which has, it appears, been flipped into an adhoc war room. Commanders stand dutifully over a battle map, pushing military tokens back and forth and arguing about the results of the simulacrums. %employer% brings you to a side. He turns the rings on his fingers as he talks.%SPEECH_ON%Commander %commander% needs help sieging %objective%. The birds tell me he is close to a breakthrough, but men such as yourself are needed to really push it through. Go and help him and you will have %reward% crowns waiting here upÀ votre retour.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "How many crowns, did you say?",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | Nous avons d\'autres obligations. | I won\'t grind the company in some siege.}",
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
			ID = "TheSiege",
			Title = "At the siege...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{You arrive at %commander%\'s camp to find his soldiers seemingly relaxed. They\'re playing dice on a wooden board strewn across the mud, exchanging jokes, and singing songs. All around are banners flying in the wind, most having long lost their once bright colors. A few are tethering the poles of a catapult back together. %commander% himself personally guides you to his command tent. He gives you a drink that tastes like a rat had bathed in it. He explains the situation.%SPEECH_ON%As I\'m sure you know, we\'ve been here awhile and are about to make a breakthrough. I need you on hand and at the ready. Once the time to attack comes, I\'ll give the order to begin the assault.%SPEECH_OFF% | %commander%\'s camp has ruined the earth around %objective%. The day-to-day presence of so many men has churned the ground into mud. A few of the men crank the spokes of a shoddy, shaky catapult. They slam a wormy cow\'s head into the bucket and slacken the rope spring until the pole of the war machine shoots forward, launching a spinning, bleeding black head toward the fortifications. It caroms off a crenelated bastion before rolling a sick stain down the walls. One of the defenders yells back.%SPEECH_ON%Nice shot, ya twats!%SPEECH_OFF%%commander% claps you on the shoulder. He\'s grinning.%SPEECH_ON%Welcome to the front, sellsword. The presence of you and your men is much appreciated. %objective% is cut off, but they refuse to surrender and remain feisty despite the hunger in their bellies. But that hunger... it weakens them. When the time is right, I will begin an assault, all I need is for you to be ready.%SPEECH_OFF% | %commander% welcomes you to the front. He informs you that the defenders of %objective% are tired, running low on supplies, and are about ready to break. Given these facts, he is preparing a final assault and simply needs the men of the %companyname% to be ready when the time comes. | The siege at %objective% looks more like the recreation in a large play than the efforts of a concentrated war effort. Both sides are in a state of miserable inadequacy, hurling insults back and forth over the walls, and in between quietly cursing the fact they had the poor luck to be stuck in this hellish situation. %commander%, though, comes to you with a cheery spark in his eyes.%SPEECH_ON%Ah, mercenaries. Let me fill you in on what is going on. We have cut off the food supplies to %objective% and a few nights ago one of our agents managed to burn their granary to the ground. They are hungry and soon they will be dying. Because we are so pressed for time, I\'m organizing an all-out assault to bring this siege to a quick end. Just be ready when the time comes.%SPEECH_OFF% | You come to %objective% to see the fortifications standing silhouetted against the horizon and %commander% staring through a pair of leather-wrapped ocular lenses, grimacing angrily at what he\'s glassing. He hands you the device and you take a look.\n\n The first thing you see is a man\'s ass bobbing up and down as he pats it with both hands. The soldier beside him is slackjawed and crosseyed as he yanks at his bits. You put the scope down, not bothering to see what else is going on. %commander% shakes his head.%SPEECH_ON%We cut off their food supplies and now they\'re going crazy. They think they are being funny, but soon we\'ll see who is laughing. I\'m planning an assault. I need you and the men of the %companyname% to be ready when the order comes.%SPEECH_OFF% | %commander% welcomes you to the outskirts of %objective% where his siege camp has been built. Rows of tents are filled with tired and grumbly men. They cook stews out of pots that have never been cleaned, and exchange jokes that were never clean to begin with. In the distance, diligent defenders of %objective% stare over their crenelations. The commander brings you to his tent and explains the situation.%SPEECH_ON%%objective% is out of food and starving. Unfortunately, I\'m out of time. We need to assault this damned place soon and I mean real farkin\' soon. When the time comes, and it will come sellsword, I need you to be ready.%SPEECH_OFF% | The outskirts of %objective% has become littered with tents. One of %commander%\'s bodyguards marches you through the siege city. Grumbly professional soldiers eye you with suspicion. %commander%, however, cheerily welcomes you to his tent. As you step in, you see a man hanging by both hands, his feet dangling off the ground. A second man is cleaning a knife in a bucket of reddened water. %commander% throws his hand toward the prisoner.%SPEECH_ON%Ah, sellsword. You just missed the action.%SPEECH_OFF%You ask what he was doing. The commander walks to the prisoner and cups him by the chin, lifting a tired and exhausted head.%SPEECH_ON%I was getting answers. %objective% is about to fall, but I don\'t have the time to sit around and wait for that to happen. I will be assaulting the fortifications soon and when I do, I need you and your men at the ready.%SPEECH_OFF% | You come to %commander%\'s siege camp to find soldiers loading a net of heads into a catapult and launching it over %objective%\'s fortifications. The commander himself comes to your side, soaking in the scene with a wide and satisfied smile.%SPEECH_ON%You know, some of those heads were of our own, but I figured the gits over the walls wouldn\'t be able to tell the difference. It\'s not about whose head, but how many, ya know? Come, sellsword.%SPEECH_OFF%He guides you to his command tent and there lays out a map.%SPEECH_ON%The defenders are tired and recent information tells me that they are almost out of food and beginning to fight over scraps. But I do not have the time for them to realize the futility of their situation, I must force it upon them. We are to begin an assault sometime soon. You need to be there when the order comes.%SPEECH_OFF% | As you enter %commander%\'s camp, a few of his soldiers spit on one of your men and a brawl quickly breaks out. Thankfully, the commander himself appears to put things at ease. He quickly guides you to his tent and there you talk while your men stand outside.%SPEECH_ON%I must apologize for the actions of my men. Tempers run razor thin after you\'ve been standing and sleeping in mud, day after day, while your enemies sleep in beds and hurl insults over their walls.\n\nLuckily, one of my agents managed to burn down %objective%\'s granary and stocks and the fort is without supplies. The defenders have been going hungry, but I fear my men will hardly bother to stand out here for long. I also worry that reinforcements might be coming to try and lift the siege. All of this means one thing... I\'m going to order an assault. The plans are currently being drawn, I just need you ready for when the order comes.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "The %companyname% will be ready.",
					function getResult()
					{
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TakingAction",
			Title = "At the siege...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander% greets you at the outskirts of his siege city. He\'s got a troop of horsemen with him and there\'s an awfully sour look on his face. He quickly explains the situation.%SPEECH_ON%Sellsword, you have most excellent timing. My scouts have just reported that reinforcements are coming to lift the siege on %objective%. We need to either attack, or try and burn this damned place down and smoke them out that way. Won\'t be much to take over if we go that route, though.%SPEECH_OFF%Strangely enough, the commander actually looks at you for ideas. | %objective% has been surrounded by %commander%\'s men, but it is the besiegers who seem more on edge than the defenders. %commander% himself draws you into his tent. He knuckles the table as he explains what is going on.%SPEECH_ON%My scouts have spotted a force coming to lift the siege. We do not have enough men, much less the energy, to fight them off. We can either launch an assault now, or load our catapults with fire and burn that damned place to the ground. The defenders will no doubt come out, but there won\'t be much to salvage out of the ruins.%SPEECH_OFF%And then, shockingly, the commander looks up and asks.%SPEECH_ON%What do you think we should do, sellsword?%SPEECH_OFF% | When you come to %commander%\'s tent, him and his lieutenants are standing around a map and your presence brings a quick end to an argument. The commander points at you.%SPEECH_ON%Mercenary! We\'ve gotten word that reinforcements are coming to lift the siege and we\'ve not the men to fight it off. We either assault %objective% or scorch earth this hellhole, smoke the defenders out with fire, and then take whatever ruins remain. My lieutenants are divided on the issue. What say you have the final vote?%SPEECH_OFF%The lieutenants grumble, but are oddly alright with leaving this decision in the hands of a sellsword.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "I say we do a full assault on the castle.",
					function getResult()
					{
						this.Flags.set("IsAssaultTheGate", true);
						this.Contract.setState("Running_TakingAction");
						return "AssaultTheGate";
					}

				},
				{
					Text = "I say we rain down fire on the castle and smoke them out.",
					function getResult()
					{
						this.Flags.set("IsBurnTheCastle", true);
						this.Contract.setState("Running_TakingAction");
						return "BurnTheCastle";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AssaultTheGate",
			Title = "At the siege...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander% has given the order attack.\n\n {The %companyname% and a contingent of the nobleman\'s soldiers are to assault the front gate. You all stack up underneath the hood of a battering ram that\'s more shanty on wheels than a compelling war machine. With all arms on the rowbars, you push the ram forward. The roof rattles with a series of ponk-ponk-ponks as arrows riddle across it. You look up to see a few arrowheads have pierced through. When you get to the gate, you order the men to heave the ram backward, and then on command they let it go.\n\nGroaning with heavy oaken deliberation, the ram sails forward and slams against the gate. It fractures in the middle and through the gap you can see %objective%\'s defenders waiting on the other side for you. Another order, another ramming. This time it batters straight through the gate, breaking the hinges and causing each door to fall away in a spray of splinters and metal. Arms at the ready, you and all the men rush through to the other side. | With a retinue of the commander\'s men, the %companyname% pushes a hooded battering ram toward the gates of %objective%. A few defenders bark down at you with jeers.%SPEECH_ON%{Aren\'t you going to take us out to dinner first? | Hmm, nice long ram you got there. Trying to make up for something? | Come and get it ya ugly cunts. | Hope yer praying to the old gods underneath that little roof of yours.}%SPEECH_OFF%Their barbs go quiet as you bump against the gate and, with one swing of the ram, blow it apart. Your men quickly charge through the opening. | Taking a few of the commander\'s men, you and the %companyname% push a battering ram toward the gate of %objective%. The rooftop bumbles and rattles, disturbingly appearing more shanty than shield. You pray it holds. Arrows plock above while others ricochet with sharp scratches of metal across wood. As you get ever closer to %objective%\'s gate, the arrows become rocks, cracking heavily against the war machine\'s hood. %randombrother% looks over the ram, laughing.%SPEECH_ON%Farkin\' hell, man.%SPEECH_OFF%Suddenly a horrid hiss surrounds everyone as though you\'d pitched yourself into a den of vipers. All becomes shade as hot oil runs off the sides of the roof. A stream of it pours down a nobleman\'s back and he cries out, falling forward and becoming a screaming golem of black sludge. You hurriedly order the men to start ramming. Thankfully, it only takes one swing of the ram to blow the gate of %objective% wide open. Your men quickly rush through the opening to battle what few defenders are around to meet you.} | An order to assault %objective% comes down the line. You ready the %companyname%. Your men and %commander%\'s push a battering ram toward the fortification\'s front gate. Arrows sail through the sky, blinkering in the light before whistling into the waves of attackers. Men fall aside in silent collapses, others go down clutching their wounds.\n\n The front gate is quickly bashed open and your men pour through the gap and into a courtyard where some of %objective%\'s defenders await. | %commander% gives the order to begin an assault. Your company and his army rush the fortifications, a barrage of siege shots sailing overhead like a darkly hailstorm. The walls are battered and the defenders kept ducking as %commander%\'s archers keep the pressure on. You manage to push a battering ram to the front gate and swiftly knock it open. As the %companyname% rushes through, the defenders of %objective% organize themselves in the courtyard to meet you. | The order to assault %objective%\'s fortifications comes down the line. Preparations render an apocalyptic scene of a sky darkened with siege shot and arrows. Fires pipe over the walls of %objective% and you see %commander%\'s men staging ladders against the crenelations and fighting their way up and in. Meanwhile, you and your men trundle beneath the hood of a battering ram, pushing it to a front gate and quickly knocking it open. As you rush in, defenders fill the courtyard and prepare to fight. | %commander% gives an order to assault %objective%\'s fortifications. The assault goes like this: the sky darkens with exchanges of arrows, rattling rains that fly past and ricochet off one another. Siege shots hurtle through the sky like cold comets before bouldering into walls and towers. Defenders fight to push ladders off the crenelations. Attackers climb the ladders, the highest man holding up a shield, the man beneath him stabbing forth with a pike. You and the %companyname% push a rickety battering ram to the front gate, largely left alone under the cover of all this chaos.\n\n When the front gate is bashed open, you and your men rush through just in time to meet a group of defenders who have assembled there. All autour de surrounding walls you can see %commander%\'s men desperately fighting for control. | Unfortunately, %commander% sees fit to take the fortifications of %objective% head on. You and the %companyname% are charged with taking a battering ram to the front gate. As you push the siege machine through the mud, you notice a man with a steaming cauldron waiting for you just over the gate. You glance around to see soldiers carrying ladders start rushing the walls. They quickly climb up and start battling. When you look back forward, the defender with the burning oil is gone, but there\'s a pair of legs sticking out of the cauldron.\n\n There is no issue bashing open the front gate and rushing in. You are quickly met by an assembly of defenders while all autour de surrounding walls %commander%\'s men keep on fighting.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "AssaultTheGate";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "BurnTheCastle",
			Title = "At the siege...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{A line of archers poke their arrowheads into bundled cloth and dip them in pitch. As they hold the arrows out, a young boy runs across with a torch to set them all alight. The commander holds his hand up, the archers raise their fiery weapons. He lowers his hand, the bowmen let loose. Fire arrows sail into the sky, crackling and hissing before going quiet and dimly seen. They fall over the fortification and at first that\'s all that seems to happen. A soldier calls out and points at some smoke starting to rise. Soon, fire licking up into the sky. A few minutes later and the front gate bursts open, ashen and smoky men rushing out like golems of the hells.\n\n %commander% raises his arm again, but this time there\'s a sword in the hand.%SPEECH_ON%CHARGE!%SPEECH_OFF% | Catapults, ballistae, and archers launch fire over the walls of %objective%. The shots whistle and hiss as their capes of fire stretch across the sky.\n\n The fortification is soon brimming with an orange hue. Smoke bubbles in gobs of choking black. Fingers of fire slowly crawl up after them. The front gate rattles once, twice, then bursts open. Blackened and coughing men pour out, clambering over one another for fresh air. %commander% draws his sword and points it toward the enemy.%SPEECH_ON%No prisoners!%SPEECH_OFF%The defenders of %objective% seem to have heard this as they quickly rush to formation. For a moment, you wonder if perhaps they once had a white flag of surrender somewhere amongst their blackened shapes. | An order comes down to set %objective% ablaze. You watch as %commander%\'s war camp sets the skies alight in a hellstorm of fiery siege shots and arrow showers. Fires soon start rising from behind the walls and you see men running around wrapped in flames. As the inferno begins to consume the insides of %objective%, the front gates open and a group of blackened, desperate men rush out. Seeing them, %commander% orders everyone to charge. | %commander% orders his men to set %objective% ablaze. This is done by loading catapults and trebuchets with stones wrapped in firewood and dipped in pitch. They\'re set alight and sent hurling through the air. Huge volleys of fire arrows follow suit, sailing deep into %objective%\'s bowels where you start seeing smoke rise. An inferno builds within the fortifications and it isn\'t long at all before the front gates break open and men come running out. %commander% draws his sword.%SPEECH_ON%There they are, men. Let\'s put an end to this once and for all!%SPEECH_OFF% | Archers start wrapping their arrows in cloth and dipping them into pitch. Kids run around with buckets of oil and start lathering the catapult shots. When the preparations are done, %commander% gives the order to let loose. Man perhaps once worshipped fire, but here it is fashioned into a furious terror that goes whistling through the sky, barraging %objective% with fiery ruin. Siege shots pulverize towers and crash through roofs and set the entire place alight. Defenders run around with burning arrows sticking out of them. As the inferno intensifies, the front gate opens and golems of smoke and ash come hurtling out, clambering over themselves to escape the hell which was brought upon them.\n\n Seeing this, %commander% draws his weapon.%SPEECH_ON%At \'em, men, and show them no mercy!%SPEECH_OFF% | %commander% orders his men to launch hell itself upon %objective%. You watch as catapults, trebuchets, and archers fill the sky with a flurry of fiery shots. The fortifications are quickly brimming with fires that churn into an inferno. Desperate men open the front gates and rush out, coughing and desperately clawing over one another for air. %commander% draws his weapon and laughs at the sight of this.%SPEECH_ON%There they are, there they shall fall! Charge!%SPEECH_OFF% | You watch as the siege engineers fill their catapults and trebuchets with cow carcasses and other fatty morkin. Kids with buckets of pitch run the battle line, dousing each shot before setting them alight. The second after, the engineers send the corpses flying. They blubber and drip through the sky. You watch as one shot hits a tower and explodes outward, sending fire raining into the fortification\'s courtyard. It isn\'t long until this animalistic aerial assault has %objective% churning with an inferno.\n\n The front gates burst open and a mob of men come hurtling out. They clamber over one another, looking like smoke and ash come alive, a darkly bracken unfurling before the gate. %commander% draws his weapon.%SPEECH_ON%This is what we\'ve been waiting for, men. Well, wait no more! Charge!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "BurnTheCastle";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [
							this.World.Assets.getBanner(),
							this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
						];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.getFaction(),
							Callback = this.Contract.onCommanderPlaced.bindenv(this.Contract),
							Tag = this.Contract
						});
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.m.Origin.getOwner().getID(),
							Callback = null
						});
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "AssaultTheCourtyard",
			Title = "At %objective%...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%objective%\'s gate has been taken, but there\'s more to do. The momentum needs to be maintained: you quickly order your men to push into the courtyard. | The gate has been taken, but %objective%\'s courtyard has yet to fall. You order the %companyname% to keep pressing forward. | The %companyname% has taken the gate and %commander%\'s men are currently rushing autour de walls of the fort to clean out the towers. You do not want to lose momentum here so you quickly order the men to continue the assault into the courtyard. | As you rush into the courtyard, %commander%\'s men fight above for control of the walls. | You and the %companyname% rush into %objective%\'s courtyard. Above you is the clanging of %commander%\'s men fighting for control of the walls. | The courtyard must be taken! You and the %companyname% rush into the fortifications ready to do battle. Circled all around you are %commander%\'s men fighting for control of the walls. | As you rush into %objective%\'s courtyard, slain men fall from above, killed by %commander%\'s men in a desperate bid to control the walls. | %commander%\'s men are assaulting the walls. Now you must do your part and secure the courtyard! | While %commander%\'s men secure the walls, you are to secure the courtyard. Do not fail!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "AssaultTheCourtyard";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "AssaultAftermath",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%objective%\'s fort has fallen. You watch as %commander%\'s men scrounge about, pulling dead bodies out from the nooks and crannies the frantic living had crawled to in the last of their desperations. Corpses come burnt, beheaded, missing limbs, trailing viscera as they\'re dragged, and a select few looked as though they\'d simply died in their sleep. One of the professional soldiers leans out from a tower\'s crenelations, tears down the fort\'s banner, and hoists the %noblefamily% sigil in its place to much cheering. | Dead bodies litter the courtyard and they\'re folded over the walls like wet clothes and some are in the corners with looks of shock on their faces and you see some blackened shapes wiry and crooked in the ruins of a burnt stable and amongst these dead men are horses and pigs and dogs and even fray feathered birds that all managed to get sucked into the violence which visited this place with unstoppable inertia.\n\n %commander% is going about his surviving men to congratulate them on a job well done. One of the soldiers hoists the %noblefamily% banner atop one of the towers. The wretched place has new owners. | The assault is over, the defenders of %objective% all cleared out. If anyone of them survived this place, they did so by departing it altogether. %commander% orders one of his men to hoist the sigil of %noblefamily% atop one of the towers and, just like that, ownership of %objective% changes hands, with all the finality of a banner wagging limply in the wind. | It was costly, but the assault has come to an end. %commander% steps over the dead bodies to order his men to start cleaning the place up immediately. One of his men raises the banner of %noblefamily% so that all may see who won the battle this day. | All around you are the bodies of %objective%\'s defenders. They fought hard, but history won\'t remember that. Their names will be forgotten and their existence a futile one. You watch as one of %commander%\'s soldiers unfurls their banner over one of the towers so at least that\'s nice. | A few pockets of fighting remain. You watch as %commander%\'s men throw defenders off a nearby tower, sending the poor men screaming to their deaths. When they\'re all gone, one of the soldiers flies the sigil of %noblefamily%. The banner flaps loudly in the newfound silence. | Healers rush into the fortification to tend to %commander%\'s men. A few of %objective%\'s defenders are also wounded, but they are left to fend for themselves. Any cry for help is met with a sword. The survivors soon learn no wound, no cry.\n\n %noblefamily%\'s banner is unfurled over the front gate. | %commander%\'s men go picking through the remains of %objective%\'s courtyard. A woman is found and she is taken into a tower. Young children rush after her, unfettered and howling and yet nobody pays them any mind. %commander% himself congratulates you on the job well done. He points to a soldier unfurling %noblefamily%\'s banner over the front gate.%SPEECH_ON%See that sigil? It spells victory.%SPEECH_OFF%You thought mounds of dead enemies provided a powerful lexicon for victory declarations, but a flapping piece of cloth suffices too. | The courtyard is hill-fleshed with dead bodies and there\'s blood dripping down the surrounding walls. %commander%\'s men go around collecting all the weapons they can and finishing off any wounded enemies they find. Their own wounded are tended to by frail, old healers with bags of leaves and mortar and pestle remedies. %noblefamily%\'s banner is unfurled over the walls to make sure, in case the evidence wasn\'t already abundantly clear, that %objective% has new owners. | Citizens from %objective% are made to march through its fortifications, to see its dead defenders, and its utterly defeated defenses. %commander% is standing astride them, thumbs jacked into his belt line with a smug smile on his face. When a soldier unfurls %noblefamily%\'s banner, he points to it.%SPEECH_ON%See that? That is who you bow down to now. Understand?%SPEECH_OFF% | You watch as citizens are marched through %objective%\'s defenses. %commander% seems interested in making explicitly clear how absolute his victory was and there is no room for further fighting. You can\'t blame him: defeat fosters a rebellious urgency within a conquered man, an urgency which is often deadlier than the man who takes up a sword and makes his intentions so clear that his enemies have no other way to thank him than immediately cutting him down. | %commander% has the citizens of %objective% lined up and marched through the fortifications. They are made to see the defeat of their defenders, blood still fresh and dripping. A beautiful and lathe woman is in the line and the commander pulls her out. He asks if she knows any of the dead. She points to a man whose face has been caved in. She recognizes the shriveled rose pinned to his uniform - she had given it to her husband that morning. %commander% apologizes for her loss then carefully ushers her back in line. He addresses the crowd with almost fatherly sternness.%SPEECH_ON%You people will be taken care of. We will rebuild and you will be fed. However, make no mistake, %objective% belongs to %noblefamily%. As long as we can agree on that, then all will be well for you.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Victory!",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BurnTheCastleAftermath",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Flushing %objective%\'s defenders out worked like a charm. You and the %commander% walk through the now undefended gate to see what\'s left of the place. Unfortunately, the fires burnt most of the place right to the ground. No matter, one of the professional soldiers hoists a banner of %noblefamily% atop one of the towers. You can hardly recognize the sigil through the cloud of swirling ash and smoke. | The battlefield is littered with the dead and dying. %commander%\'s men pass through the mounds of corpses, occasionally stabbing their spears down into the ground and silencing what noise had been mewling there.\n\n You and the commander head through %objective%\'s gate. The fires turned every wooden building to bony and charred frameworks. There are burnt farm animals all over the courtyard. %commander% shrugs and orders one of his men to raise the flag of %noblefamily% atop one of the towers so that all may know who won this day. | The battle is over. Flushing %objective%\'s defenders out with fire more than likely saved many lives, but the beyond the gates everything has been cleansed by flames. It will take time to rebuild to its former glory, whatever that was. %commander% seems happy enough as he orders one of his men to raise the flag of %noblefamily% atop one of the towers. Its colorful linens snap crisply amongst shades of floating ash and smoke. | %commander% steps through the ashes of %objective%\'s fortifications.%SPEECH_ON%Well, we got it. What\'s left of it anyway. I\'m not going to complain, though. Good job, sellsword.%SPEECH_OFF% | %objective%\'s citizens come out to see the remains of their defenses. The women pick through the charred bodies, looking for any sign of their loved ones. Instead, they just find their men burnt to charred and wiry skeletons, faces melted into grim visages that captured their final moments. One of %commander%\'s men unfurls %noblefamily%\'s banner over the front gate and the commander quickly points to it.%SPEECH_ON%Listen up! See that right there? That is who we are. Now, all you have to do is respect that and everything can go back to normal! Disrespect that, and I will bring you a new normal, got it?%SPEECH_OFF%The crowd of citizens quietly nod their heads. %commander% smiles and it is scarily genuine.%SPEECH_ON%Good! Now, does anyone here make a mean scrambled eggs?%SPEECH_OFF% | You and %commander% enter %objective%\'s fortifications to find the coda of a fight for air itself. Blackened shapes, either man or beast, are found having clambered over one another. One man\'s hand is pulling back the charred remains of another man, his grip stretching back a rope of seared flesh. You cover your mouth to keep from vomiting. %commander% orders his men to raise %noblefamily%\'s banner over the front gate. He claps you on the shoulder.%SPEECH_ON%Hey, good job out there, sellsword. You should breathe that stench in, though. It\'ll help you get used to it faster.%SPEECH_OFF% | You pass through %objective%\'s walls holding a cloth to your nose. %commander% walks beside you, holding his head up high with a smugness that is of a stench of its own. Inside %objective%, you find bodies wired together through melted bone and flesh, reared teeth flashing out in gritty grimaces resonating the horrid finality of a burning death. %commander% slaps you on the shoulder.%SPEECH_ON%This was quite a victory, you know that? You should get on back to %employer%, unless you want to help cleanup.%SPEECH_OFF% | You and %commander% enter %objective% with swords raised, but there is nothing to fight: the inferno consumed every living thing. If they weren\'t burned to death, they can be found caked in the ash and smoke they choked on. %commander% kicks some rubble around, a charred body tumbling over as he does so.%SPEECH_ON%Hell, there ain\'t much here but the walls.%SPEECH_OFF%He looks at you sternly.%SPEECH_ON%But walls are everything.%SPEECH_OFF%You crouch down and look at the dead man.%SPEECH_ON%Do you think he thought the same?%SPEECH_OFF%The commander shrugs. He quickly turns away and orders one of his men to unfurl %noblefamily%\'s banner over the front gate. | You step foot into %objective% and immediately regret it. There are bodies everywhere and not a one is remotely identifiable. The fire turned everything black, even the mud itself. %commander% uses his foot to try and turn over a corpse. Fleshen chips crunch and splinter as though he\'d stepped on a thin layer of ice. The man scrunches his nose.%SPEECH_ON%Now that is unsightly, don\'t you think?%SPEECH_OFF%He turns and lets out a sharp whistle before pointing at one of his soldiers.%SPEECH_ON%You! Raise the %noblefamily% banner over the gates and towers!%SPEECH_OFF%The soldier salutes and rushes off to his duty. %commander% slaps you on the shoulder and says %employer% should be most happy with these results. | There isn\'t much to recover from %objective%\'s fortifications: the fires consumed damn near everything. Those who stayed, burned. Those who rushed to the towers for safety, suffocated. The faces of the dead tell both stories in explicit terms - it was not a good way to go. But %commander% seems happy, ordering his men to start cleaning up and unfurling the %noblefamily% banners. | You pick through the remains of %objective%. The dead bodies draw your eye because you\'ve never seen so many burnt corpses in one place. One is clutching a tiny shape that, upon a closer look, is revealed to be an infant. %commander% walks up and claps you on the shoulder.%SPEECH_ON%Ah, that\'s a shame. Hey, you did a good job, sellsword. Don\'t think twice about nothing, got it?%SPEECH_OFF%You nod. The commander smiles briefly before ordering his men to start flying %noblefamily%\'s banners everywhere they can. Best to let strangers know that this burnt husk of a fort has new owners. | Inside %objective%, you find all manner of charred chaos. Dead dogs that were set aflame, their chains smoldering them long before the fires could. Horses stuck in stables with their blackened legs stiff in the air. Pigs that broke through their fences and ran wild, no doubt on fire the whole time. A faint aroma of bacon barely undercutting the otherwise horrid stench. There was no escape for any of these creatures.\n\n You open the door to a storage room and find a pile of defenders that suffocated to death. %commander% comes to stand behind you, looking in.%SPEECH_ON%Poor blokes. They look young. Probably stable hands, squires. What a shame.%SPEECH_OFF%The commander leans into the room and knocks some straw off a loaf of bread. He peels the outer layer away to reveal a fresh core.%SPEECH_ON%Hey, you hungry?%SPEECH_OFF%You politely decline the offer.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Victory!",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Origin.spawnFireAndSmoke();

				foreach( a in this.Contract.m.Origin.getActiveAttachedLocations() )
				{
					a.spawnFireAndSmoke();
					a.setActive(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "MaintainSiege",
			Title = "At the siege...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander% returns with news that the defenders might be weakening. He hopes to avoid a deadly assault and simply wait them out instead. You are instructed to stay with the siege camp until further notice. | One of %commander%\'s lieutenant informs you that the commander has elected to wait a little bit longer, hoping that the defenders will surrender instead of drawing out a fight. The %companyname% is ordered to standby until further notice. | News comes your way that the siege is going to be maintained a little while longer. You are instructed to wait some time until further notice.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "The %companyname% will be ready.",
					function getResult()
					{
						if (this.Flags.get("IsNighttimeEncounter"))
						{
							this.Contract.setState("Running_NighttimeEncounter");
						}
						else if (this.Flags.get("IsReliefAttack"))
						{
							this.Flags.set("IsReliefAttackForced", true);
							this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
							this.Contract.setState("Running_Wait");
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NighttimeEncounter",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{%commander% orders you and the men out on a patrol. While making the rounds, you spot a few of %objective%\'s defenders slipping out of a creekbed beside one of the fort\'s walls. They\'re slipping through some sort of secret passageway. Thinking fast, you order you men to charge down on them, hoping to capture the passageway before they can see you first. Make sure none of those bastards can slip back through the secret passageway! | While you wait to see where the siege goes, %commander% comes by and orders you and the %companyname% to start patrols of %objective%\'s outer defenses.\n\n Lo\' and behold, while you\'re footing about you see a few of %objective%\'s defenders sneaking through a hatch. You crouch and watch them closely. When the hatch closes, you see that the top of it has been covered in moss and grass to mask its location. If you leave now to tell %commander%, it\'s very likely that one of the men will see you and destroy the passageway. You decide to seize the moment and order an attack. The %companyname% needs to ensure that no defenders get away! | As the siege lulls on, you decide to take a bit of initiative and ask if you and the %companyname% can go on patrols. A little bit of walking will keep the men fresh and on their toes. That, or they can linger autour de camp and get into fights with the professional soldiers. %commander% agrees.\n\n No more than a few minutes into the patrol do you spot a few of %objective%\'s defenders dragging themselves up the embankment of a half-assed moat. They\'re swimming into it through a sewage hatch close to the fortification walls. %randombrother% shakes his head.%SPEECH_ON%I\'ll be farkin\' damned.%SPEECH_OFF%You tell him to stay quiet. If any of the defenders learn that their secret passageway has been found, they\'ll be sure to close it. You wait for all the defenders to get out into the open, then order an attack. None of the defenders can be allowed to get away! | A patrol is ordered and you elect the %companyname% for the job. Your men grumble and complain, but tasks like this are good for keeping the grunts fresh and on their toes.\n\n Finding a group of %objective%\'s defenders slipping out of a secret passageway is also a great way to keep things fresh! No more than a few minutes out and about do you find the defenders doing just that. You watch as the defenders collect themselves and, just as they\'re about ready to sneak out into the hinterland, do you order an attack. None of these defenders can be allowed to escape! | As the siege goes on, %commander% orders you and your men to start patrols of the fortifications around %objective%. Halfway through the rounds your men stumble upon a few defenders slipping out of a secret passageway, some shitmired grate where the moat goes up to chest level. Capturing this passageway would be an enormous tactical advantage in the days to come. You quickly order your men to attack - and that none of the defenders can be allowed to get away!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Get them!",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "NighttimeEncounter";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NighttimeEncounterFail",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Damn it all. A few of the defenders managed to sneak back through the passageway and you can already hear it being sealed up. | You just weren\'t quick enough to stop all the defenders and a few got away. They slipped back into %objective% and sealed the passageway behind them. | Well, the whole point here was to kill those sneaking out and secure the passageway. Instead, a few escaped back into %objective% and closed the passageway behind them.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Damn it!",
					function getResult()
					{
						this.Flags.set("IsNighttimeEncounter", false);
						this.Flags.set("IsReliefAttack", true);
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NighttimeEncounterAftermath",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{You managed to kill all the defenders and secure the passageway. When you report the news to %commander%, he tells you to sneak through the secret gate and assassinate %objective%\'s leading commander. You\'ll have a few hours to prepare, but time is of the essence and you\'ll have to strike before the night is over. | Killing all the defenders, you manage to secure the passageway. You Retournez à %commander% and explain the situation. He nods dutifully then turns to you.%SPEECH_ON%I want you to sneak through the secret passage, get inside the fortifications, and assassinate their leader.%SPEECH_OFF%Compared to the alternative of a frontal assault, this night operation is about as agreeable of an action that you\'ve heard in some time. | The secret passageway is secured and news of it reported to %commander%. He laughs, shaking his head.%SPEECH_ON%We\'d been looking for such a thing for so long now, and there you are, first patrol out and already finding the keys to %objective%.%SPEECH_OFF%He states that he wants you and the %companyname% to sneak through the passage and assassinate the leadership. Once that is done, the defenders will be ruined and %objective% can be taken easily. It\'s either this or try a frontal assault, the latter of which you have no interest in. You\'ll have a few hours to get ready, but the mission should be undertaken before the night is over. | One of the defenders screams out for help.%SPEECH_ON%They found ughhh-%SPEECH_OFF%%randombrother% is quick to slap a cloth over the man\'s mouth and then slit his throat. You look about %objective%\'s walls for activity, but it appears nobody heard the cry.\n\n Returning to the siege camp, you are intercepted by %commander%. He\'s looking for good news and you readily depart with it. The leader stomps his foot.%SPEECH_ON%By the gods that\'s the best news I\'ve heard in weeks! Alright, this is excellent, but we need to take action and fast. I want you and your men to slip through that passageway and assassinate %objective%\'s leadership. We need to do this as soon as possible, a few hours wait at the most, got it?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll prepare and then sneak in.",
					function getResult()
					{
						this.Flags.set("IsSecretPassage", true);
						this.Contract.setState("Running_SecretPassage");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FailedToReturn",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{You failed to kill the defender\'s leader and with their commander still at the helm %commander% had to call off the siege. Although the failure of the siege wasn\'t entirely your fault, it\'s a good bet that %employer% will see it that way. | The secret passage has been closed! With the defenders\' commander still alive, the fortifications will be far too costly to assault. %commander% has called off the siege and you\'ve received a fair bit of the blame for that. | Well, you took too long to use the secret passage. The defenders must have gotten leery of keeping it open and closed it with a pile of rocks. With the defenders still under their steady commander, attacking the fortifications will be very costly for %commander%\'s army. He has called off the siege. %employer% will not be happy.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Damnit!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Wandered off during the siege of " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SecretPassage",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{You and the %companyname% quietly slip through the passageway. The walls of the tunnel drip shit and piss and the waters you trudge through are no better. %randombrother% complains a bit, but you tell him to shut it.\n\n Coming out the other side, you spill into a courtyard, the company sneaking along a line of bushes and then lying flat as you survey the field.\n\n A few of the defenders walk about. They\'re sighing and groaning and moaning. Hunger rumbles their bellies, and curses wag their tongues. Soon enough, the commander is seen with a troop of his best guards at his side. He\'s passing through the courtyard for an inspection. You will not get a better chance than this and order the attack! | The %companyname% and yourself open the secret passageway. You find a small stable boy exiting with a list of requested goods written on a scroll. He begs for his life, but you can\'t risk anything now. %randombrother% slits his throat and drowns him in the filth pouring out of the passageway\'s tunnel. You continue on and spill out into a courtyard. The men and yourself slip along a row of bushes and observe for a time.\n\n As you wait, a man attired in a commander\'s garb comes down some steps with a band of guards behind him. You doubt you\'ll get a better opportunity than this and order the attack! | The secret passageway is dark and murky, the waters that run through the tunnels full of shite and piss. You hike up your pants and start inward. Torches would give you away, so you go in blind and feeling the walls. You know not what horrors your fingers run over and you hope to never know. Eventually, a dim light flickers at the far end and you slip out of the passageway and into a courtyard.\n\n %objective%\'s commander is assessing his troops, but stops to turn and look at you and the %companyname% making a grand, stinky entrance. His eyes widen and he points with one hand while the other reaches for his weapon.%SPEECH_ON%Assassins!%SPEECH_OFF%You order the %companyname% to attack! | The secret passageway is a surprisingly short trip to the other side of %objective%\'s walls. On the other side of the tunnels is a man standing guard. He sees the shapes of you and your men coming through the darkness. He asks.%SPEECH_ON%I hope to every farkin\' old god that you got what we requested. Remember, I asked for eggs and...%SPEECH_OFF%For a moment, he sees %randombrother%\'s face emerging from the shadows, and for another moment realizes this stranger before him is no errand boy. The guard reels back, but before he can shout for help your sellsword puts a blade through his chest and both go flying into a bush. With him out of the way, you quietly sneak into %objective% and find its commander doing drills in the courtyard.\n\n Having no better chance than this, you order the %companyname% to attack!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
					function getResult()
					{
						this.Contract.getActiveState().onSneakIn(null, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SecretPassageAftermath",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%objective%\'s commander has fallen and his men quickly lay down their arms. One lieutenant raises his hands and speaks hurriedly.%SPEECH_ON%We\'ve no interest in carrying on with this losing proposition. The only man who did is dead there. We surrender.%SPEECH_OFF%%employer% will be most happy about this turn of events. | The battle over, you find the dying commander of %objective%\'s defenses. He\'s spitting blood as you step over him.%SPEECH_ON%We\'ll never surrender. Do your worst you deplorable sellsword.%SPEECH_OFF%You put a sword through his eye socket. One of his lieutenants drops his weapon and raises his hands.%SPEECH_ON%Hey, he was the only one here who cared about defending this place. It\'s all yours. Just let us live!%SPEECH_OFF%You give %randombrother% the order to signal %commander% about the taking of the fortifications. | %objective%\'s commander is dead, and his men immediately surrender in unison. They explain that only the commander wanted to keep holding the place. Apparently he was jockeying for attention within the noble families and thought a heroic defense would purchase him a seat at the table of the powers that be. Well, now he\'s dead in the mud. You tell %randombrother% to raise the signal so that %commander% can know %objective% has surrendered. A defender asks you for mercy.%SPEECH_ON%Surely you\'ll let us live, yes?%SPEECH_OFF%You clean your blade and shrug.%SPEECH_ON%Not up to me. My benefactor and the army he heads is about to come through that door. What his intentions are is beyond me. You want mercy, pick up a weapon and my men will give it to you.%SPEECH_OFF%The defender frowns and nods.%SPEECH_ON%I suppose I\'ll take my chances with him.%SPEECH_OFF% | %objective%\'s commander is dead in the mud. His surviving troops all have their hands in the air. You order your men to shackle the defenders while you give the signal, unfurling your sigil down the side of a tower. %commander%\'s siege camp blares a horn in response. The battle is over. %employer% will no doubt be most pleased. | The battle is over and %objective%\'s leader is dead in the mud. Having ripped out their heart and soul, the defenders immediately give up. You order the %companyname% to round them up and start shackling them. %randombrother% goes to give %commander% the signal that the fort has been taken. %employer% will no doubt be happy to see you upÀ votre retour.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We did it!",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SecretPassageFail",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Unfortunately, you did not get into position to assassinate the commander and had to pull back. The defenders of %objective% jeer as you and the men slip back through the tunnels. When you get back outside, you hear the passageway being sealed off. It looks a more difficult route to capturing %objective% will have to be taken. | The battle did not carry on as you hoped. You and the %companyname% are pushed back to the passageway and enact a fighting retreat. When you get back outside, you hear stones and crashing sounds as the defenders seal it all off. You tried your best, but it looks like taking %objective% will not be as easy as you\'d hoped. | To their credit, the defenders did a great job. Tired and underfed, they fought like the cornered dogs that they are. When you retreat back outside %objective%\'s walls, you hear the distinct sound of the passageway being sealed off.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Damn it!",
					function getResult()
					{
						this.Flags.set("IsSecretPassage", false);
						this.Flags.set("IsReliefAttackForced", true);
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(15, 30));
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ReliefAttack",
			Title = "At the siege...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{%commander%\'s scouts return with news that a relief force is coming to try and end the siege of %objective%. The commander nods and orders his men to prepare for battle. You do the same. | While waiting around, a few scouts return and enter %commander%\'s tent. You go in after them and see the commander nodding and gathering his things. He looks at you and explains.%SPEECH_ON%A relief force is coming. They\'re going to try and end the siege. Get your men ready.%SPEECH_OFF% | {You watch as %randombrother% arm wrestles one of the professional soldiers. They\'re betting on a headless chicken. Winner gets a full belly, the loser a sore arm. | One of the sieging soldiers and %randombrother% are about to begin a staring contest. Whoever blinks first, loses. Whoever wins gets a chicken. | You find %randombrother% heaving large stones close to a stake in the mud. A soldier from the sieging army does the same. Apparently they\'re competing over a chicken and they\'re down to the very last throw for winner take all.} Before they can start, a scout bursts through the camp and states an army is coming to try and relieve %objective%. %commander% orders his men to get ready. You repeat it to the %companyname%. | %commander%\'s scouts have returned with news that an army is coming to try and relieve %objective%. You order the %companyname% to get ready for a large battle. | A large battle is on the horizon: %commander%\'s scouts have returned with news that a relief force is coming to try and end the siege. Get ready!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prepare for battle!",
					function getResult()
					{
						this.Contract.spawnReliefForces();
						this.Contract.setState("Running_ReliefAttack");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ReliefAttackAftermath",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_86.png[/img]{The relief force has been defeated and beaten back off the field. %objective%\'s defenders no doubt saw the whole battle and have taken a hit to their morale. It\'s likely only a matter of time until they surrender! | Hurrah! The relief force has been summarily taken care of. %commander% thanks you for the help. He glasses %objective%\'s walls with his leather-wrapped scope and smiles.%SPEECH_ON%Oh, they\'re a beaten bunch. They saw the whole thing. I\'ve never seen such a hopeless lot of men in all my life.%SPEECH_OFF%He claps you on the shoulder with a wide grin.%SPEECH_ON%Sellsword, I think this siege is almost at an end!%SPEECH_OFF% | You managed to beat back the relief force! That was probably the last hope for %objective% and their surrender is to be expected any day now. | %commander% thanks you for helping destroy the relief force. He believes %objective% is likely to surrender any moment now. | Watching your only hope in the world get annihilated is probably not the best for morale. %objective%\'s defenders got to see their relief force slaughtered and no doubt they are now on the verge of surrender. | Well, %objective%\'s great last hope has been completely defeated. You and %commander% convene and agree: the defenders are no doubt ready to surrender. It\'s just a matter of time.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "They can\'t hold out forever.",
					function getResult()
					{
						this.Flags.set("IsReliefAttackForced", false);

						if (this.Flags.get("IsSurrender"))
						{
							this.Flags.set("IsSurrenderForced", true);
						}
						else if (this.Flags.get("IsDefendersSallyForth"))
						{
							this.Flags.set("IsDefendersSallyForthForced", true);
						}

						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(10, 20));
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Surrender",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_31.png[/img]%objective% surrenders!\n\n{You walk through the opened gates to find its defenders strewn all about. Hungry men keeled over in pain, others leaning against the walls, chapped lips cracking as they beg for water. No animals are alive. They have all long since been slaughtered. Black birds do stare down from the walls, joining you in the conquest and just waiting for an opportunity to plunder. %commander% claps you on the shoulder and thanks you for the help. | The front gate rattles open and you walk through it like the victor that you are. However, the scene inside should dispel any notion that there was honor in defeating these poor souls. Dead defenders have been stacked in a corner. A few men have been crucified for cannibalism, but even those executed men show signs of being consumed. There\'s a burnt granary to one side of the courtyard. Some of the men sit with blackened mouths, apparently having tried to scarf down the charred remains of grain. Every single animal has been slaughtered and picked to the bone.\n\n %commander% laughs at the scene and tells his men to start shackling the prisoners. He turns to you.%SPEECH_ON%Thank you, sellsword. You can Retournez à %employer% now.%SPEECH_OFF% | Inside the fort you find the defenders standing in a line. Two of %commander%\'s soldiers are going down it, one hauling chains and the other taking those chains and shackling the men together. You see a corpse impaled atop a stable, having the weathervane blow out his chest and carrying his heart atop it like some visceral end to a ritual. %commander% comes over laughing.%SPEECH_ON%That was their lieutenant. {They said he refused to surrender and threw himself off the tower instead. | Apparently he refused to surrender so his men threw him off the tower.}%SPEECH_OFF%Interesting. Well, %employer% will be more than happy to see you again. | Beyond the walls, %commander%\'s men are taking the defenders\' weapons and heaving them into a great pile. The defenders themselves are huddled in a corner, each with their arms shackled behind their backs, their heads ducked low, their eyes staring at the mud. A few guards watch over them, occasionally kicking them, spitting on them, or even threatening to kill them. All in good fun.\n\n %commander% comes over and claps you on the back.%SPEECH_ON%Job well done, sellsword. Your help was much appreciated. Retournez à %employer%. Your work here is done.%SPEECH_OFF% | Walking through the gate, you find the defenders begging for mercy. Their lieutenant is dead in the mud, still leaking from dozens of stab wounds. One man explains.%SPEECH_ON%We wanted to surrender so long ago but he wouldn\'t let us! You have to understand! We want no more of this war.%SPEECH_OFF%%commander% walks up beside you and nods.%SPEECH_ON%Your work here is done, sellsword. Go on and see %employer%.%SPEECH_OFF%You ask what he\'s going to do with the prisoners. He shrugs.%SPEECH_ON%Dunno. I think I\'ll eat first. Maybe pen a letter to my loved ones. I try not to be rash about these things.%SPEECH_OFF%Fair enough. | You and %commander% walk through the opened gates. Inside, a few of the surviving defenders are keeled over, begging for food on their hands and knees. They can hardly bend their bodies upward to beg, their stomachs so pitted with pain.%SPEECH_ON%Please! Help...%SPEECH_OFF%%commander% puts a boot on one of the men and pushes him over.%SPEECH_ON%Do we look like help to you?%SPEECH_OFF%The commander turns to you.%SPEECH_ON%Good job, sellsword. Get on back to %employer. Your work here is done.%SPEECH_OFF% | Through the gate you find the defenders being rounded up and put into a corner. %commander% asks which of them is the leader. The group uniformly points across the courtyard. A dead man is hanging from one of the towers, pale faced with purpled hands and a purple nose. One of the prisoners explained.%SPEECH_ON%If we didn\'t do it, you\'d still be standing out there and we\'d still be in here starving.%SPEECH_OFF%%commander% nods.%SPEECH_ON%Alright. I won\'t punish ye all for that. Sellsword! You get on back to %employer%. Your work here is done.%SPEECH_OFF% | Going through the gate, you find the fort\'s commander swinging a longsword around as a few of %commander%\'s men corner him with spears. In one big uniform rush, they skewer him like a wild animal. Immobilized by the shafts, he gives up and keels forward, draping his arms over the wood like he was lazily leaning against some fenceposts.%SPEECH_ON%Alright, I suppose ye bastards got me.%SPEECH_OFF%He turns to his men who, it appears, were the ones to actually open the gates.%SPEECH_ON%I\'ll be seeing the lot of you in the next life.%SPEECH_OFF%Blood pours from his mouth and his body shakes once and that is all. The soldiers retrieve their spears and the leader falls straight into the mud. %commander% stands over him and addresses you.%SPEECH_ON%Alright, sellsword. Get on back to %employer%.%SPEECH_OFF% | The inside of the fort is a place of horror. Men are strewn about clutching their bellies, some already dead, some wishing they were. The commander of the place is hanging from a tower, a family banner wrapped around his neck as though that\'d bring some dignity to his death. Bones of animals litter the courtyard and there is shit and piss and vomit potholed all about. %commander% comes to your side and nods.%SPEECH_ON%Looks about right. A shame they didn\'t surrender earlier.%SPEECH_OFF%You suggest that it was probably the dead lieutenant swinging by his own sigil that was resisting surrender. The commander nods again.%SPEECH_ON%Yeah. He thought that was the honorable thing to do. I\'d probably done the same once upon a time, but having seen this, I\'m not so sure he\'s right anymore.%SPEECH_OFF% | Walking through the gate, you find the defenders bunched up outside a place of worship. There aren\'t many left and not a one is praying. The dead have been piled into a corner and there\'s evidence of cannibalism. No animals are around. The stable is so busy with flies it\'s almost roaring with their frenetic buzzing. The pig pen has been outright trampled. One of the prisoners looks up at you.%SPEECH_ON%We ate all that we could. Do you understand? We. Ate. All. That. We. Could.%SPEECH_OFF%%commander% comes up to your side.%SPEECH_ON%Don\'t let them bother ya, sellsword. Travel on back to %employer%. He\'ll no doubt be waiting for you.%SPEECH_OFF% | You and %commander% walk through the front gates. The defenders inside are more skeleton than flesh and they shamble about accordingly. One gloms onto your shoulder.%SPEECH_ON%Food! Food!%SPEECH_OFF%His breath carries the horrid stench of hunger. You throw him to the ground and there he cries out and begins stuffing his mouth with mud. %commander% comes by your side as he munches on a buttered piece of bread.%SPEECH_ON%These bastards look like a sorry lot, no?%SPEECH_OFF%Crumbs spew out of his mouth and the prisoners stare at them as if they were gold. The commander claps you on the shoulder.%SPEECH_ON%Get on back to %employer%, he\'ll be more than happy to hear the great news.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%objective% has fallen!",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "DefendersSallyForth",
			Title = "At the siege...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{A loud squall breaks over the din of the siege camp. You look out to see the gates of %objective% opening up and a band of men running out. %commander% sprints out of his tent, takes one look, then starts yelling at his men.%SPEECH_ON%Sally! Sally! They\'re coming, men, they\'re coming! Ready yourselves! Kill these rat bastards to the last man, you hear me?%SPEECH_OFF%The siege camp roars with anticipation. You quickly gather the %companyname% and prepare to join the battle. | The defenders of %objective% are sallying forth! You order you men to ready themselves and prepare to join %commander% in battle. | There isn\'t going to be any surrender! The defenders of %objective% are sallying forth. They\'re a poor, hungry looking lot, but it appears they\'d rather die out here than give themselves up. %commander% tells his men to get ready and you do the same with the %companyname%. | The gates of %objective% are opening up! At first, that\'s all that happens, then a muted roar comes and a small band of defenders start marching out. They\'re raising their arms to cheers and are singing their family\'s battlecry. They\'re bringing volume and you\'ll be bringing violence. To battle! | The squall of rusted hinges rings over the siege camp. You look to %objective% to see its gates slowly opening. A band of men marches out, carrying banners and weapons. They look like they\'ve already been beaten in one battle, shambling forward on hungry bellies. %commander% shakes his head.%SPEECH_ON%Those fools. Why don\'t they just surrender?%SPEECH_OFF%You shrug and turn to the %companyname%.%SPEECH_ON%If they wish to die, then so be it. To arms, men!%SPEECH_OFF% | %randombrother% comes to you and points at the gates of %objective%.%SPEECH_ON%Look, sir.%SPEECH_OFF%You watch as the gates slowly open up. A troop of men shambles out. They do not carry a white flag, but instead the sigils of their families. You run to %commander% and inform him that the defenders are sallying forth. He nods.%SPEECH_ON%I knew they were a resilient bunch, but this is just pathetic. No man should die so pointlessly.%SPEECH_OFF%You almost say if that were true no man would be out here doing this shite in the first place. Instead, you hold your tongue and go out to prepare the men of the %companyname% for battle.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s end this!",
					function getResult()
					{
						local tile = this.Contract.m.Origin.getTile();
						this.World.State.getPlayer().setPos(tile.Pos);
						this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "DefendersSallyForth";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Contract.flattenTerrain(p);
						p.Entities = [];
						p.AllyBanners = [
							this.World.Assets.getBanner(),
							this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
						];
						p.EnemyBanners = [
							this.Contract.m.Origin.getOwner().getBannerSmall()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.getFaction(),
							Callback = this.Contract.onCommanderPlaced.bindenv(this.Contract)
						});
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.Origin.getOwner().getID());
						p.Entities.push({
							ID = this.Const.EntityType.Knight,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/humans/knight",
							Faction = this.Contract.m.Origin.getOwner().getID(),
							Callback = null
						});
						this.Contract.setState("Running_DefendersSallyForth");
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null && e.isAlive())
					{
						e.die();
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "DefendersPrevail",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Unbelievably, the tired defenders of %objective% have won! You retreat as the siege crumbles.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "The siege has failed.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed in the siege of " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DefendersAftermath",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{The defenders of %objective% have been annihilated and the fortifications left wide open. You and %commander% walk through the open gates to find corpses, trash, and slaughtered animals all over the place, bloody signs of desperation. The commander nods and claps you on the shoulder.%SPEECH_ON%Good job, sellsword. You should get on back to %employer% now and tell him the news.%SPEECH_OFF% | The battle\'s over, the defenders of %objective% totally defeated and their fort left wide open for the taking. %commander% thanks you for your service before dismissing the %companyname%\'s services from the field. You should go and see a very happy %employer% now. | It was a spirited effort on the part of %objective%\'s defenders, but if they were going to make a play like this they should have done it weeks ago when their strengths matched their heroism. No matter now. A starving dead man looks very similar to a well fed dead man and, with enough time, they all look the same.\n\n %commander% comes and tells you that the services of the %companyname% are no longer needed. You agree and should head on back to %employer% for payment. | Sallying forth when you\'re starving and beleaguered by poor leadership is never the best of ideas. You\'re not sure if %commander% would have granted the defenders of %objective% mercy had they surrendered. As it is now, they\'re all dead in the mud and the world in which they gave up has long since passed. You gather the men of the %companyname% and order them to prepare for the march back to %employer%. Payday will be very sweet after this day. | With the defenders of %objective% out of the way, you and %commander% head into the fortifications. There\'s a reason the men were so desperate: the conditions are absolutely deplorable. Dead men had been stripped and piled into a corner. A spit holds the cooked remains of what could have been a pig, but it\'s hard to tell because they flat out consumed every single bit of that animal. A hanged man swings from one of the towers. They\'d nailed a board to his chest with \'cannibal\' written across it, possibly penned with the use of his own blood.\n\n %commander% laughs.%SPEECH_ON%Looks like a real party in here, don\'t it? Remember this scene the next time some belligerent lieutenant with a stick up his ass tells you to just keep holding out.%SPEECH_OFF% | The %companyname% and %commander%\'s army have summarily defeated the sallying defenders of %objective%. With the fortifications left free, %commander%\'s men quickly take it over. The commander himself tells you to go see %employer% for pay. | %objective%\'s defenders died on a battlefield, but if anything it was a field of mercy. Behind the walls of their fort remains almost nothing of value and, in particular, a complete and total absence of food. It is as though the world which existed behind the walls never even knew of food, the defenders had so picked the place clean. You\'re sure mere mentions of food was a crime for even a torturous word of a flavor would be like a flogging across a man\'s growling stomach. %commander% comes to your side and laughs.%SPEECH_ON%I thought I knew what it was to be hungry, but I always had an answer for it, you know? I never went hungry with no hope to fix it. What a horrible thing. But then again, they fixed it, didn\'t they?%SPEECH_OFF%You nod as the man laughs at his dark humor.%SPEECH_ON%You did a good job, sellsword. Go on and see to it that %employer% pays you well.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%objective% has fallen!",
					function getResult()
					{
						this.Contract.changeObjectiveOwner();
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Prisoners",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{A few of your men managed to capture some of %objective%\'s defenders. They stand huddled together, fenced in by your sellsword\'s weapons. Some are shaking in their boots. One doesn\'t even have boots. Another has stains down his pants. %randombrother% asks what should be done with them. | %randombrother% reports that a few defenders of %objective% have been captured. You go to find a group of men huddled together, embraced in a circled hug, but with their heads down. One calls out.%SPEECH_ON%Please, don\'t kill us! We were just doing what we were told, just as you were!%SPEECH_OFF% | Your men have managed to capture a few of %objective%\'s defenders. They\'ve been rounded up, stripped to their pants, and ordered facedown into the mud. %randombrother% asks what should be done with them.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let them go. %rivalhouse% may take it as a sign of good faith.",
					function getResult()
					{
						return "PrisonersLetGo";
					}

				},
				{
					Text = "They may be worth something. Take them to %commander% as prisoners.",
					function getResult()
					{
						return "PrisonersSold";
					}

				},
				{
					Text = "Better to kill them now than face them again in battle in the days to come.",
					function getResult()
					{
						return "PrisonersKilled";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsPrisoners", false);
			}

		});
		this.m.Screens.push({
			ID = "PrisonersLetGo",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The prisoners are of no use to you or anyone else. You cut them loose, hoping that you won\'t come to regret this decision. | You cut the prisoners loose. They cry as they thank you, but you simply hope that this was not a mistake. | You let the prisoners go. They thank you personally before taking off, hopefully to never be seen again.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Enough death for one day.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.World.FactionManager.getFaction(this.Flags.get("RivalHouseID")).addPlayerRelation(5.0, "Let some of their men go free after battle");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PrisonersKilled",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{You nod at %randombrother%.%SPEECH_ON%Kill them all.%SPEECH_OFF%The prisoners get to their feet, but there is no escaping the closure of their worlds. They are slaughtered piecemeal. | There is no use for these men in shackles, but it is quite likely that they\'ll come back to fight you another day as free men. You order their execution, a command carried out in a frenzy of pleading and throat slashing. | In wars like this, there is no food to house so many prisoners, and there\'s no use for them while you\'re still deep in enemy territory. But if you let them go it is very probable they\'ll raise their swords against you another day.\n\n With that in mind, you order their executions. The words of protest are short lived, fading into the gargle of throats being slashed, cut, and hacked.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On to more important things...",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);

						if (this.World.FactionManager.isCivilWar())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PrisonersSold",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{You take the prisoners to %commander%. The men are lined up and the commander walks up and down their arrangement.%SPEECH_ON%This one. This one. Him. And him. Kill the rest.%SPEECH_OFF%A few lucky ones, who coincidentally happen to be the biggest and most useful looking of the bunch, are pulled forward. The rest are summarily killed with spears through their chests. %commander% hands you some crowns.%SPEECH_ON%Appreciate you catching them. They\'ll be put to good, hard work.%SPEECH_OFF% | The prisoners are taken to %commander%. He orders the men shackled and ordered to some hard labor. The commander pays you a decent sum for the haul.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On to more important things...",
					function getResult()
					{
						this.World.Assets.addMoney(250);
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]250[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You report to %employer% that %objective% has been taken and is now under control. The man hides a smirk behind his hand, keeping some fair bit of composure as if nobility shouldn\'t lower themselves to the unprofessional excitement of the layman. He simply nods as though this news had been expected.%SPEECH_ON%Good. Good. Of course.%SPEECH_OFF%The man snaps his fingers and a servant hands you a satchel of %reward_completion% crowns. | Entering %employer%\'s room brings silence to a throng of commanders, lieutenants, and the nobleman himself. He straightens up.%SPEECH_ON%My birds have already reported of the capture of %objective%. Your pay is outside.%SPEECH_OFF%The leaders hardly even thank you, though %reward_completion% crowns is more than enough thanks as far as you\'re concerned. | %employer% welcomes you to his war room. A group of commanders linger around a map on a table. You watch as they push one of their tokens over %objective%. %employer% grins.%SPEECH_ON%Those men may not let it slip, but we are might happy about the work you\'ve done. The stories my spies have brought me ensured I did not make a poor investment with the likes of you.%SPEECH_OFF%The nobleman personally gives you a satchel of %reward_completion% crowns. | %employer%\'s room is a hive of business. Commanders run to and fro, arguing with one another no matter which side of the room they\'re on or how far apart, while servants duck and weave to make sure they\'re properly fed. War is no time to waste energy on pitiful things like picking up your own cloak or cooking meals. You\'re surprised there are no servants forking bites into their mouths between arguments.\n\n However, %employer% is simply off to the side. He\'s flipping through a book like he was by himself in a chirpy garden. He looks up. Glances at his generals, then at you.%SPEECH_ON%Good job. Your pay.%SPEECH_OFF%A chest is slowly pushed your way. %reward_completion% crowns rest inside. | A servant cuts you off from entering %employer%\'s room. He explains.%SPEECH_ON%I\'ve been requested to meet you here with this satchel of %reward_completion% crowns.%SPEECH_OFF%You take the satchel and nod. | You try to enter %employer%\'s room, but a guard stops you.%SPEECH_ON%Nobles only.%SPEECH_OFF%Pushing the guard\'s halberd out of your face, you state that you have business with %employer%. The guard lowers the halberd back down.%SPEECH_ON%Nobles only.%SPEECH_OFF%Just as you are about to start an argument, a servant steps out of the room with a large satchel. He sees the sigil of the %companyname% and hands you a satchel.%SPEECH_ON%Your %reward_completion% crowns. I\'m afraid my liege and his commanders are busy.%SPEECH_OFF%And just like that the servant is gone. The guard peers down at you.%SPEECH_ON%Nobles only.%SPEECH_OFF% | The reward for helping conquer %objective% is %reward_completion% crowns and a door slammed in your face. %employer% is too busy arguing with his commanders to congratulate you any more than that. | One of %employer%\'s commanders meets you in a foyer. He\'s got a servant with him that\'s carrying a large satchel. The commander speaks.%SPEECH_ON%Ah, the %companyname%. You\'ve little honor in your vocation, sellsword. You should be a real man and fight with the nobles. There is great honor in what we do. Why not join us?%SPEECH_OFF%The large satchel of %reward_completion% crowns is placed in your hands. You smile back at the commander, a gilded reflection rimming your teeth.%SPEECH_ON%Yes, why?%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective% has fallen.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Took part in the siege of " + this.Flags.get("ObjectiveName"));
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
					text = "Recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]What a disaster. The battle is lost and you retreat to spare what men you have left. %objective% will not fall anytime soon.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Damn this place!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed in the siege of " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TooFarAway",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_36.png[/img]{The passage of time as a concept seems to have eluded you. Despite your absence, the siege tried to go on, but eventually collapsed without the expected help of the %companyname%. Don\'t bother returning to %employer%. | You were hired to help the siege, not abandon it. Without the %companyname% by their side, the soldiers will likely have to withdraw from the field. | You strayed too far from the siege! Without your help, the attackers had to retreat and %objective% was spared %employer%\'s conquest. Considering that was what you were hired to help accomplish, it\'s probably for the best that you do not Retournez à the nobleman.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Right, there was this siege...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnReliefForces()
	{
		local tile;
		local originTile = this.m.Origin.getTile();

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 8, originTile.SquareCoords.X + 8);
			local y = this.Math.rand(originTile.SquareCoords.Y - 8, originTile.SquareCoords.Y + 8);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Mountains)
			{
				continue;
			}

			break;
		}

		local enemyFaction = this.m.Origin.getOwner();
		local party = enemyFaction.spawnEntity(tile, this.m.Origin.getOwner().getName() + " Army", true, this.Const.World.Spawn.Noble, 200 * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + enemyFaction.getBannerString());
		party.getSprite("banner").setBrush(enemyFaction.getBannerSmall());
		party.setDescription("Professional soldiers in service to local lords.");
		party.setFootprintType(this.Const.World.FootprintsType.Nobles);
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 5);
		party.getLoot().Ammo = this.Math.rand(0, 30);
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

		party.setAttackableByAI(false);
		this.m.UnitsSpawned.push(party.getID());
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		c.addOrder(move);
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(10.0);
		c.addOrder(wait);
	}

	function spawnSupplyCaravan()
	{
		local tile;
		local originTile = this.m.Origin.getTile();

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 7, originTile.SquareCoords.X + 7);
			local y = this.Math.rand(originTile.SquareCoords.Y - 7, originTile.SquareCoords.Y + 7);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (!tile.HasRoad)
			{
				continue;
			}

			break;
		}

		local enemyFaction = this.m.Origin.getOwner();
		local party = enemyFaction.spawnEntity(tile, "Supply Caravan", false, this.Const.World.Spawn.NobleCaravan, this.Math.rand(100, 150));
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("A caravan with armed escorts transporting provisions, supplies and equipment between settlements.");
		party.addToInventory("supplies/ground_grains_item");
		party.addToInventory("supplies/ground_grains_item");
		party.addToInventory("supplies/ground_grains_item");
		party.addToInventory("supplies/ground_grains_item");
		party.getLoot().Money = this.Math.rand(0, 100);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		move.setRoadsOnly(true);
		c.addOrder(move);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(despawn);
	}

	function spawnSiege()
	{
		this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));

		foreach( a in this.m.Origin.getActiveAttachedLocations() )
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				a.spawnFireAndSmoke();
				a.setActive(false);
			}
		}

		local f = this.World.FactionManager.getFaction(this.getFaction());
		local castles = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isMilitary())
			{
				castles.push(s);
			}
		}

		if (castles.len() == 0)
		{
			castles = clone f.getSettlements();
		}

		local originTile = this.m.Origin.getTile();
		local lastTile;

		for( local i = 0; i < 2; i = ++i )
		{
			local tile;

			while (true)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 1, originTile.SquareCoords.X + 1);
				local y = this.Math.rand(originTile.SquareCoords.Y - 1, originTile.SquareCoords.Y + 1);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) == 0)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				if (i == 0 && !tile.HasRoad && !this.m.Origin.isIsolatedFromRoads())
				{
					continue;
				}

				if (lastTile != null && tile.ID == lastTile.ID)
				{
					continue;
				}

				break;
			}

			lastTile = tile;
			local party = f.spawnEntity(tile, castles[this.Math.rand(0, castles.len() - 1)].getName() + " Company", true, this.Const.World.Spawn.Noble, castles[this.Math.rand(0, castles.len() - 1)].getResources());
			party.setDescription("Professional soldiers in service to local lords.");
			party.setVisibilityMult(2.5);

			if (i == 0)
			{
				party.getSprite("body").setBrush("figure_siege_01");
				party.getSprite("base").Visible = false;
			}
			else
			{
				party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
			}

			party.setAttackableByAI(false);
			this.m.UnitsSpawned.push(party.getID());
			this.m.Allies.push(party.getID());
			party.getLoot().Money = this.Math.rand(50, 200);
			party.getLoot().ArmorParts = this.Math.rand(0, 25);
			party.getLoot().Medicine = this.Math.rand(0, 5);
			party.getLoot().Ammo = this.Math.rand(0, 30);
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
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
			local wait = this.new("scripts/ai/world/orders/wait_order");
			wait.setTime(9000.0);
			c.addOrder(wait);
		}
	}

	function changeObjectiveOwner()
	{
		if (this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement) != null)
		{
			this.m.Origin.getOwner().removeAlly(this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement).getID());
		}

		this.m.Origin.removeFaction(this.m.Origin.getOwner().getID());
		this.World.FactionManager.getFaction(this.getFaction()).addSettlement(this.m.Origin.get());

		if (this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement) != null)
		{
			this.World.FactionManager.getFaction(this.getFaction()).addAlly(this.m.Origin.getFactionOfType(this.Const.FactionType.Settlement).getID());
		}

		if (this.m.SituationID != 0)
		{
			this.m.Origin.removeSituationByInstance(this.m.SituationID);
			this.m.SituationID = 0;
		}

		this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/conquered_situation"), 3);
	}

	function flattenTerrain( _p )
	{
		if (_p.TerrainTemplate == "tactical.hills_steppe")
		{
			_p.TerrainTemplate = "tactical.steppe";
		}
		else if (_p.TerrainTemplate == "tactical.hills_tundra")
		{
			_p.TerrainTemplate = "tactical.tundra";
		}
		else if (_p.TerrainTemplate == "tactical.hills_snow" || _p.TerrainTemplate == "forest_snow")
		{
			_p.TerrainTemplate = "tactical.snow";
		}
		else if (_p.TerrainTemplate == "tactical.hills" || _p.TerrainTemplate == "tactical.mountain")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
		else if (_p.TerrainTemplate == "tactical.hills" || _p.TerrainTemplate == "tactical.mountain")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
		else if (_p.TerrainTemplate == "tactical.forest_leaves" || _p.TerrainTemplate == "tactical.forest" || _p.TerrainTemplate == "tactical.autumn")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
		else if (_p.TerrainTemplate == "tactical.swamp")
		{
			_p.TerrainTemplate = "tactical.plains";
		}
	}

	function onCommanderPlaced( _entity, _tag )
	{
		_entity.setName(this.m.Flags.get("CommanderName"));
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
		]);
		_vars.push([
			"noblefamily",
			this.World.FactionManager.getFaction(this.getFaction()).getName()
		]);
		_vars.push([
			"rivalhouse",
			this.m.Flags.get("RivalHouse")
		]);
		_vars.push([
			"commander",
			this.m.Flags.get("CommanderName")
		]);
		_vars.push([
			"direction",
			this.m.Origin == null || this.m.Origin.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Origin.getTile())]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			foreach( id in this.m.UnitsSpawned )
			{
				local e = this.World.getEntityByID(id);

				if (e != null && e.isAlive())
				{
					local c = e.getController();
					c.clearOrders();

					if (e.isAlliedWithPlayer())
					{
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(60.0);
						c.addOrder(wait);
					}
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull())
			{
				this.m.Origin.getSprite("selection").Visible = false;
				this.m.Origin.setOnCombatWithPlayerCallback(null);
				this.m.Origin.setAttackable(false);
			}

			if (this.m.Home != null && !this.m.Home.isNull())
			{
				this.m.Home.getSprite("selection").Visible = false;
			}
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(2);
			}
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return false;
		}

		if (this.m.Origin == null || this.m.Origin.isNull() || this.m.Origin.getFaction() == this.getFaction())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
		_out.writeU8(this.m.Allies.len());

		foreach( ally in this.m.Allies )
		{
			_out.writeU32(ally);
		}
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
		local numAllies = _in.readU8();

		for( local i = 0; i < numAllies; i = ++i )
		{
			this.m.Allies.push(_in.readU32());
		}
	}

});


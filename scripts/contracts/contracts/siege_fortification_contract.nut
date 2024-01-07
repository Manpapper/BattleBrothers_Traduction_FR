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
		this.m.Name = "Siege " + this.m.Origin.getName();
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
					if (!this.Flags.get("IsNighttimeEncounterLost"))
					{
						this.Flags.set("IsNighttimeEncounterAfermath", true);
					}
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
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% vous accueille dans sa chambre. Il a une carte étalée sur un bureau. Elle est parsemée de babioles militaires, de petits emblèmes en bois représentant les armées se déplaçant à travers un monde en guerre. Le noble montre l\'un en particulier.%SPEECH_ON%J\'ai besoin que vous alliez ici et parliez à %commander%. Il assiège les fortifications là-bas et a besoin de votre aide pour finaliser une attaque. Vous serez payé %reward% couronnes, ce qui devrait être plus que suffisant, non ?%SPEECH_OFF% | Vous entrez dans la salle de guerre de %employer% et provoquez un silence soudain parmi une foule de généraux et de commandants regroupés autour de cartes de bataille. %employer% vous fait signe d\'entrer et vous emmène sur le côté. Les hommes de guerre vous dévisagent un moment avant de retourner lentement à leurs discussions stratégiques. %employer% explique sa situation.%SPEECH_ON%J\'ai le commandant %commander% assiégeant les fortifications à %objective%. Il a besoin de quelques hommes de plus pour lancer l\'assaut, et c\'est là que vous intervenez. Allez là-bas, aidez-le, et je vous paierai %reward% couronnes, ce qui devrait être plus que suffisant, non ?%SPEECH_OFF% | Avant que vous n\'entriez dans la chambre de %employer%, il surgit et vous prend par l\'épaule. Il vous emmène dans un couloir et arrive à une fenêtre, parlant en regardant la cour.%SPEECH_ON%Mes généraux n\'ont pas besoin de vous voir. Ils ne trouvent pas d\'honneur dans votre vocation. Parfois, un peu de tact politique est nécessaire pour engager des mercenaires.%SPEECH_OFF%Vous secouez la tête et répondez sèchement.%SPEECH_ON%Nous tuons tout comme ils le font.%SPEECH_OFF%Le noble hoche la tête.%SPEECH_ON%Bien sûr, mercenaire, mais peut-être que dans le futur, c\'est nous que vous tuerez. Cela perturbe mes généraux, certains inquiets, d\'autres en colère. Je comprends la réalité du monde dans lequel nous vivons, et donc je dors comme un bébé, comprenez-vous ? Alors faisons des affaires. J\'ai besoin que vous alliez à %objective% et aidiez le commandant %commander% à assiéger les fortifications là-bas. Vous serez payé %reward% couronnes pour votre travail.%SPEECH_OFF% | %employer% vous rencontre et vous emmène dans son jardin. Étant donné la situation, il semble étrangement à l\'aise. Il caresse une vigne de tomates et commence à parler.%SPEECH_ON%La guerre est une chose infernale. Des hommes meurent pendant que nous parlons parce que j\'ai prononcé quelques mots. Juste comme ça. Je ne veux pas abuser de mon pouvoir.%SPEECH_OFF%Vous mettez vos pouces dans votre ceinture et répondez.%SPEECH_ON%Pour l\'amour de mes hommes, j\'espère que vous ne le ferez pas.%SPEECH_OFF%%employer% fait un signe de tête et attrape une tomate. La vigne devient tendue avant de se détacher. Il prend une bouchée puis hoche à nouveau la tête, comme si la vie d\'un jardinier était celle qu\'il préférerait.%SPEECH_ON%J\'ai un commandant du nom de %commander% qui assiège actuellement %objective%. Il finalise les plans pour lancer un assaut. Je suis sûr que ce mot vous effraie, mais il travaille sur ce plan depuis un certain temps. Il a juste besoin du dernier groupe d\'hommes pour s\'assurer que tout se déroule sans problème. Allez là-bas, aidez-le, et je vous paierai %reward% couronnes.%SPEECH_OFF% | %employer% vous salue et vous amène à l\'une de ses cartes de bataille. Il pointe %objective%.%SPEECH_ON%Le commandant %commander% assiège actuellement leurs fortifications. J\'ai besoin d\'hommes robustes pour l\'aider à lancer l\'assaut. Allez là-bas, aidez-le, et je vous paierai %reward% couronnes. Ça a l\'air bien, non ?%SPEECH_OFF% | Lorsque vous entrez dans la chambre de %employer%, vous trouvez une série de commandants autour d\'une carte. Des petits jetons représentant la noblesse parsèment le papier. Un homme utilise un bâton pour pousser un cheval en bois à travers des plaines mal dessinées. %employer% vous accueille chaleureusement, mais l\'un de ses généraux vous emmène sur le côté et explique ce dont ils ont besoin :\n\nLe commandant %commander% assiège actuellement %objective% et a besoin d\'aide. Nul doute que c\'est là que le %companyname% est censé intervenir. Vous regardez l\'homme. Il grogne et parle entre ses dents serrées.%SPEECH_ON%Votre paiement sera de %reward% couronnes, honorable mercenaire.%SPEECH_OFF%Les derniers mots semblent douloureux pour l\'homme. Il est clair qu\'on lui a dit d\'être aussi diplomatique que possible. | Vous vous arrêtez devant la porte de %employer% et vous demandez si vous avez besoin de ces ennuis dans votre vie. Soudain, un serviteur vous percute avec un coffre de couronnes. Il demande si %employer% est à l\'intérieur car les %reward% couronnes sont prêtes pour être livrées au mercenaire. Vous dépassez rapidement le serviteur et entrez dans la pièce. %employer% vous accueille chaleureusement. Il explique que le commandant %commander% assiège actuellement %objective% et est sur le point de réussir. Il a juste besoin de quelques hommes de plus pour faire pencher la balance. %employer% fait semblant de réfléchir puis ajoute enfin.%SPEECH_ON%%reward% couronnes seront à vous.%SPEECH_OFF%Vous feignez la surprise à cette somme. | Vous n\'êtes pas sûr que la guerre se déroule bien pour %employer%, ou si tous ses généraux ont toujours l\'air aussi stressés pendant ces périodes. Ils ont l\'air de préférer tomber sur leurs épées plutôt que de passer une seconde de plus à regarder une carte de bataille. %employer% est assis dans le coin de la pièce à côté d\'un feu et d\'un serviteur tenant une cruche de vin. Le noble vous fait signe de vous approcher et commence à parler.%SPEECH_ON%Ne faites pas attention aux grognements. La guerre va bien. Tout va bien. Juste pour vous montrer à quel point tout va bien, j\'ai besoin que vous alliez parler au commandant %commander% à %objective% car son siège de cette maudite fortification est sur le point de se terminer. La victoire est à portée de main et tout ce que vous avez à faire est de m\'aider à la saisir ! Comment sonnent %reward% couronnes ?%SPEECH_OFF% | Vous entrez dans la chambre de %employer% pour trouver le noble affalé dans un fauteuil confortable. Deux gros chiens dorment à ses pieds et un chat ronronne sur ses genoux. Il est complètement assommé, ronflant bruyamment avec une gourde gouttante coincée étrangement dans un bras tendu. Un homme vêtu d\'une tenue de général vous fait signe de venir de l\'autre côté de la pièce.%SPEECH_ON%Ne faites pas attention au seigneur. La guerre a lourdement pesé sur son esprit. Maintenant, écoutez. J\'ai mes ordres, et j\'ai les vôtres. Nous avons besoin que vous alliez à %objective% et aidiez le commandant %commander% à assiéger les fortifications là-bas. C\'est tout.%SPEECH_OFF%Vous demandez le paiement. Le visage du général s\'assombrit.%SPEECH_ON%Oui. La rémunération. Bien sûr. Je devais vous promettre %reward% couronnes. J\'espère que c\'est suffisant pour vos... services honorables.%SPEECH_OFF%Les dernières paroles semblent douloureuses pour l\'homme. Il est clair qu\'on lui a dit d\'être aussi diplomatique que possible.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "Combien de couronnes avez-vous dit ?",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | Nous avons d\'autres obligations. | Je ne vais pas traîner la compagnie dans un siège.}",
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
			Title = "À the siege...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Vous arrivez au camp de %commander% pour trouver ses soldats apparemment détendus. Ils jouent aux dés sur un plateau en bois parsemé de boue, échangent des blagues et chantent des chansons. Tout autour, des bannières flottent dans le vent, la plupart ayant depuis longtemps perdu leurs couleurs vives. Quelques-unes réparent les poteaux d\'une catapulte. %commander% lui-même vous guide personnellement vers sa tente de commandement. Il vous offre une boisson qui a le goût qu\'un rat aurait pris un bain dedans. Il explique la situation.%SPEECH_ON%Comme vous le savez probablement, nous sommes ici depuis un moment et nous sommes sur le point de faire une percée. J\'ai besoin de vous prêt et prêt à l\'emploi. Une fois que le moment de l\'attaque viendra, je donnerai l\'ordre de lancer l\'assaut.%SPEECH_OFF% | Le camp de %commander% a ruiné la terre autour de %objective%. La présence quotidienne de tant d\'hommes a transformé le sol en boue. Certains hommes actionnent les manivelles d\'une catapulte branlante. Ils envoient une tête de vache vermoulue dans le seau et détendent le ressort de la corde jusqu\'à ce que le mât de la machine de guerre se lance en avant, lançant une tête noire qui tourne et saigne vers les fortifications. Elle rebondit sur un bastion crénelé avant de rouler une tache malade sur les murs. Un des défenseurs crie en retour.%SPEECH_ON%Beau tir, espèces d\'idiot !%SPEECH_OFF%%commander% vous tape sur l\'épaule. Il sourit.%SPEECH_ON%Bienvenue sur le front, mercenaire. La présence de vous et de vos hommes est très appréciée. %objective% est coupé du monde, mais ils refusent de se rendre et restent combatifs malgré la faim qui les tenaille. Mais cette faim... elle les affaiblit. Quand le moment sera venu, je donnerai le signal pour commencer l\'assaut. Tout ce dont j\'ai besoin, c\'est que vous soyez prêt.%SPEECH_OFF% | %commander% vous accueille chaleureusement sur le front. Il vous informe que les défenseurs de %objective% sont fatigués, manquent de provisions et sont sur le point de craquer. Compte tenu de ces faits, il prépare un assaut final et a simplement besoin que les hommes de la %companyname% soient prêts lorsque le moment sera venu. | Le siège de %objective% ressemble plus à une reconstitution dans une grande pièce qu\'à un effort de guerre concentré. Les deux côtés sont dans un état d\'inadéquation misérable, échangeant des insultes par-dessus les murs et maudissant silencieusement le fait d\'avoir la malchance d\'être coincés dans cette situation infernale. Cependant, %commander%, lui, vient vers vous avec une étincelle joyeuse dans les yeux.%SPEECH_ON%Ah, mercenaires. Laissez-moi vous mettre au courant de la situation. Nous avons coupé les approvisionnements alimentaires de %objective% et il y a quelques nuits, l\'un de nos agents a réussi à brûler leur grenier. Ils ont faim et bientôt ils mourront. Parce que nous manquons tellement de temps, j\'organise une attaque totale pour mettre fin rapidement à ce siège. Soyez simplement prêt quand le moment sera venu.%SPEECH_OFF% | Vous arrivez à %objective% pour voir les fortifications se dessiner en silhouette contre l\'horizon et %commander% regardant à travers une paire de lentilles oculaires en cuir, grimaçant de colère devant ce qu\'il observe. Il vous tend l\'appareil et vous y jetez un coup d\'œil.\n\n La première chose que vous voyez est le postérieur d\'un homme qui monte et descend en se tapotant avec les deux mains. Le soldat à côté de lui a la mâchoire pendante et les yeux croisés pendant qu\'il tire sur ses parties intimes. Vous posez la lunette, ne vous souciant pas de voir ce qui se passe. %commander% secoue la tête.%SPEECH_ON%Nous avons coupé leurs approvisionnements alimentaires et maintenant ils deviennent fous. Ils pensent qu\'ils sont drôles, mais bientôt nous verrons qui rit. Je prévois un assaut. J\'ai besoin que vous et les hommes de la %companyname% soyez prêts lorsque l\'ordre viendra.%SPEECH_OFF% | %commander% vous accueille aux abords de %objective% où son camp de siège a été installé. Des rangées de tentes sont remplies d\'hommes fatigués et grognons. Ils cuisinent des ragoûts dans des marmites qui n\'ont jamais été nettoyées et échangent des blagues qui n\'ont jamais été propres. Au loin, les défenseurs diligents de %objective% regardent par-dessus leurs créneaux. Le commandant vous amène à sa tente et explique la situation.%SPEECH_ON%%objective% est à court de nourriture et affamé. Malheureusement, je n\'ai plus de temps. Nous devons assaillir cet endroit maudit bientôt et je veux dire vraiment très bientôt. Quand le moment viendra, et il viendra mercenaire, j\'aurai besoin que vous soyez prêt.%SPEECH_OFF% | Les abords de %objective% sont jonchés de tentes. Un des gardes du corps de %commander% vous guide à travers la ville assiégée. Des soldats professionnels grognons vous regardent avec suspicion. %commander%, cependant, vous accueille joyeusement dans sa tente. En entrant, vous voyez un homme suspendu par les deux mains, ses pieds pendant dans le vide. Un deuxième homme nettoie un couteau dans un seau d\'eau rougeâtre. %commander% lance sa main vers le prisonnier.%SPEECH_ON%Ah, mercenaire. Vous venez de manquer l\'action.%SPEECH_OFF%Vous demandez ce qu\'il faisait. Le commandant se rend au prisonnier et lui soulève la tête fatiguée et épuisée.%SPEECH_ON%Je cherchais des réponses. %objective% est sur le point de tomber, mais je n\'ai pas le temps de rester assis et d\'attendre que cela se produise. Je vais lancer bientôt l\'assaut et quand je le ferai, j\'aurai besoin que vous et vos hommes soyez prêts.%SPEECH_OFF% | Vous arrivez au camp de siège de %commander% pour trouver des soldats chargés d\'un filet de têtes dans une catapulte et le lançant par-dessus les fortifications de %objective%. Le commandant lui-même vient à vos côtés, absorbant la scène avec un large sourire satisfait.%SPEECH_ON%Vous savez, certaines de ces têtes étaient les nôtres, mais j\'ai pensé que ces imbéciles derrière les murs ne sauraient pas faire la différence. Ce n\'est pas la tête qui compte, mais combien, vous savez ? Venez, mercenaire.%SPEECH_OFF%Il vous guide jusqu\'à sa tente de commandement et y étale une carte.%SPEECH_ON%Les défenseurs sont fatigués et des informations récentes me disent qu\'ils sont presque à court de nourriture et commencent à se battre pour des miettes. Mais je n\'ai pas le temps de les laisser réaliser l\'inutilité de leur situation, je dois la leur imposer. Nous devons commencer un assaut bientôt. Vous devez être là quand l\'ordre viendra.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "La %companyname% sera prête.",
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
			Title = "À the siege...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander% vous accueille aux abords de sa ville assiégée. Il a une troupe de cavaliers avec lui et il a l\'air terriblement mécontent. Il explique rapidement la situation.%SPEECH_ON%Mercenaire, vous avez un timing des plus excellents. Mes éclaireurs viennent de signaler que des renforts arrivent pour lever le siège de %objective%. Nous devons soit attaquer, soit essayer de brûler cette maudite place et les enfumer de cette façon. Il ne restera pas grand-chose à conquérir si nous choisissons cette voie, cependant.%SPEECH_OFF%Étrangement, le commandant vous regarde en fait pour des idées. | %objective% a été entouré par les hommes de %commander%, mais ce sont les assiégeants qui semblent plus nerveux que les défenseurs. %commander% lui-même vous entraîne dans sa tente. Il frappe la table en expliquant ce qui se passe.%SPEECH_ON%Mes éclaireurs ont repéré une force qui vient lever le siège. Nous n\'avons pas assez d\'hommes, encore moins d\'énergie, pour les repousser. Nous pouvons soit lancer un assaut maintenant, soit charger nos catapultes de feu et brûler cette maudite place jusqu\'au sol. Les défenseurs sortiront sans aucun doute, mais il n\'y aura pas grand-chose à récupérer dans les ruines.%SPEECH_OFF%Et puis, étonnamment, le commandant lève les yeux et demande.%SPEECH_ON%Que pensez-vous que nous devrions faire, mercenaire ?%SPEECH_OFF% | Lorsque vous arrivez à la tente de %commander%, lui et ses lieutenants sont autour d\'une carte et votre présence met fin rapidement à une dispute. Le commandant vous pointe du doigt.%SPEECH_ON%Mercenaire ! Nous avons appris que des renforts arrivent pour lever le siège et nous n\'avons pas les hommes pour les repousser. Nous devons soit assaillir %objective%, soit brûler cette maudite place, enfumer les défenseurs avec le feu, et prendre ensuite les ruines qui subsistent. Mes lieutenants sont divisés sur la question. Que dites-vous d\'avoir le dernier mot ?%SPEECH_OFF%Les lieutenants grognent, mais sont étrangement d\'accord pour laisser cette décision entre les mains d\'un mercenaire.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je dis que nous lançons un assaut complet sur le château.",
					function getResult()
					{
						this.Flags.set("IsAssaultTheGate", true);
						this.Contract.setState("Running_TakingAction");
						return "AssaultTheGate";
					}

				},
				{
					Text = "Je dis que nous faisons pleuvoir le feu sur le château et les enfumons.",
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
			Title = "À the siege...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander% a donné l\'ordre d\'attaquer.\n\n {Le %companyname% et un contingent des soldats du noble doivent assaillir la porte principale. Vous vous alignez tous sous le capot d\'un bélier qui ressemble plus à une charrette brinquebalante qu\'à une machine de guerre convaincante. Avec tous les bras sur les barres de roulement, vous poussez le bélier en avant. Le toit résonne avec une série de ponk-ponk-ponks alors que des flèches criblent le dessus. Vous regardez en l\'air pour voir quelques pointes de flèches transpercées. Quand vous arrivez à la porte, vous ordonnez aux hommes de reculer le bélier, et puis sur commande, ils le laissent partir.\n\nGrinçant avec une délibération de chêne lourd, le bélier vole en avant et s\'écrase contre la porte. Il se fracture au milieu et à travers l\'ouverture, vous pouvez voir les défenseurs de %objective% qui vous attendent de l\'autre côté. Un autre ordre, un autre bélier. Cette fois, il passe carrément à travers la porte, brisant les charnières et faisant tomber chaque porte dans un éclat d\'éclats et de métal. Les bras prêts, vous et tous les hommes vous précipitez de l\'autre côté. | Avec un cortège des hommes du commandant, le %companyname% pousse un bélier caparaçonné vers les portes de %objective%. Quelques défenseurs vous aboient des moqueries.%SPEECH_ON%{Vous ne nous emmenez pas d\'abord dîner? | Hmm, joli long bélier que vous avez là. Vous essayez de compenser quelque chose? | Viens le chercher, sale con. | J\'espère que vous priez les anciens dieux sous ce petit toit.}%SPEECH_OFF%Leurs traits d\'humour se taisent alors que vous heurtez la porte et, d\'un seul coup de bélier, la faites exploser. Vos hommes se précipitent rapidement à travers l\'ouverture. | Avec quelques hommes du commandant, vous et le %companyname% poussez un bélier vers la porte de %objective%. Le toit titube et s\'agite, apparaissant de manière troublante plus brinquebalant que protecteur. Vous priez pour que ça tienne. Des flèches plockent au-dessus tandis que d\'autres ricochent avec des grincements métalliques sur le bois. À mesure que vous vous rapprochez de la porte de %objective%, les flèches deviennent des rochers, se fissurant lourdement contre le capot de la machine de guerre. %randombrother% regarde par-dessus le bélier, riant.%SPEECH_ON%Putain d\'enfer, mec.%SPEECH_OFF%Soudain, un sifflement horripilant entoure tout le monde comme si vous vous étiez jeté dans une tanière de vipères. Tout devient de l\'ombre alors que de l\'huile chaude s\'écoule sur les côtés du toit. Un ruisseau en coule le long du dos d\'un noble qui crie, tombant en avant et devenant un golem hurlant de boue noire. Vous ordonnez précipitamment aux hommes de commencer à cogner. Heureusement, il ne faut qu\'un seul coup de bélier pour faire voler en éclats la porte de %objective%. Vos hommes se précipitent rapidement à travers l\'ouverture pour combattre les quelques défenseurs qui s\'y trouvent.} | Un ordre d\'assaut sur les fortifications de %objective% est transmis. Vous préparez le %companyname%. Vos hommes et ceux de %commander% poussent un bélier vers la porte principale de la fortification. Les flèches traversent le ciel, clignotant dans la lumière avant de siffler dans les vagues des assaillants. Les hommes tombent en silence, d\'autres tombent en se cramponnant à leurs blessures.\n\n La porte principale est rapidement enfoncée et vos hommes se déversent à travers l\'ouverture dans une cour où certains défenseurs de %objective% attendent. | %commander% donne l\'ordre de lancer un assaut. Votre compagnie et son armée se précipitent sur les fortifications, une salve de tirs de siège naviguant dans le ciel comme une tempête de grêle sombre. Les murs sont battus et les défenseurs se baissent en gardant la tête baissée, tandis que les archers de %commander% maintiennent la pression. Vous parvenez à pousser un bélier à la porte principale et à l\'ouvrir rapidement. Alors que le %companyname% se précipite à l\'intérieur, les défenseurs de %objective% s\'organisent dans la cour pour vous rencontrer. | L\'ordre d\'assaut sur les fortifications de %objective% est transmis. Les préparatifs laissent entrevoir une scène apocalyptique d\'un ciel assombri par des tirs de siège et des flèches. Les incendies survolent les murs de %objective% et vous voyez les hommes de %commander% poser des échelles contre les créneaux et se battre pour les monter et entrer. Pendant ce temps, vous et vos hommes roulez sous le capot d\'un bélier, le poussant vers une porte principale et l\'ouvrant rapidement. Alors que vous vous précipitez à l\'intérieur, des défenseurs remplissent la cour et se préparent à combattre. | %commander% donne l\'ordre d\'assaut sur les fortifications de %objective%. L\'assaut se déroule ainsi : le ciel s\'assombrit avec des échanges de flèches, des pluies cliquetantes qui volent et ricochent les unes contre les autres. Les tirs de siège volent dans le ciel comme des comètes froides avant de se précipiter dans les murs et les tours. Les défenseurs se battent pour faire tomber les échelles des créneaux. Les attaquants grimpent sur les échelles, l\'homme le plus haut tenant un bouclier, l\'homme en dessous poignardant avec une pique. Vous et le %companyname% poussez un bélier bancal vers la porte principale, largement laissé seul à l\'abri de tout ce chaos.\n\n Quand la porte principale est enfoncée, vous et vos hommes vous précipitez à l\'intérieur juste à temps pour rencontrer un groupe de défenseurs qui se sont rassemblés là. Tout autour des murs environnants, vous pouvez voir les hommes de %commander% se battre désespérément pour le contrôle. | Malheureusement, %commander% juge bon d\'attaquer les fortifications de %objective% de front. Vous et le %companyname% êtes chargés de prendre un bélier à la porte principale. Alors que vous poussez la machine de siège dans la boue, vous remarquez un homme avec un chaudron fumant qui vous attend juste au-dessus de la porte. Vous jetez un coup d\'œil autour de vous pour voir des soldats portant des échelles se précipiter vers les murs. Ils montent rapidement et commencent à se battre. Quand vous regardez de nouveau vers l\'avant, le défenseur à l\'huile brûlante est parti, mais il y a une paire de jambes qui dépassent du chaudron.\n\n Il n\'y a aucun problème à ouvrir la porte principale à coups de bélier et à vous précipiter à l\'intérieur. Vous êtes rapidement accueilli par un groupe de défenseurs tandis qu\'autour des murs %commander% et ses hommes continuent de se battre.}",
   "Image": ""
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chargez !",
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
			Title = "À the siege...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Une ligne d\'archers plonge leurs pointes de flèches dans un tissu lié et les trempe dans le brai. Alors qu\'ils tiennent les flèches, un jeune garçon court avec une torche pour les allumer toutes. Le commandant lève la main, les archers brandissent leurs armes enflammées. Il abaisse la main, les archers lâchent prise. Les flèches enflammées s\'élèvent dans le ciel, crépitant et sifflant avant de devenir silencieuses et à peine visibles. Elles tombent sur la fortification et au début, c\'est tout ce qui semble se passer. Un soldat crie et pointe vers une fumée qui commence à s\'élever. Bientôt, le feu lèche le ciel. Quelques minutes plus tard, la porte principale explose, des hommes cendrés et enfumés s\'en échappant comme des golems des enfers.\n\n %commander% lève de nouveau le bras, mais cette fois il tient une épée.%SPEECH_ON%À L\'ATTAQUE !%SPEECH_OFF% | Catapultes, balistes et archers lancent le feu par-dessus les murs de %objective%. Les tirs sifflent et sifflent alors que leurs capes de feu s\'étirent à travers le ciel.\n\n La fortification est bientôt remplie d\'une teinte orange. La fumée forme des amas de noir étouffant. Des doigts de feu rampent lentement après eux. La porte principale claque une fois, puis deux fois, puis éclate. Des hommes noircis et toussotants s\'en échappent, se bousculant les uns sur les autres pour trouver de l\'air frais. %commander% tire son épée et la pointe vers l\'ennemi.%SPEECH_ON%Pas de prisonniers !%SPEECH_OFF%Les défenseurs de %objective% semblent avoir entendu cela car ils se précipitent rapidement en formation. Pendant un moment, vous vous demandez si peut-être ils ont autrefois eu un drapeau blanc de reddition quelque part parmi leurs formes noircies. | Un ordre est donné pour incendier %objective%. Vous regardez le camp de guerre de %commander% mettre le ciel en feu dans une tempête infernale de tirs de siège enflammés et de douches de flèches. Les feux commencent bientôt à s\'élever derrière les murs et vous voyez des hommes courir enveloppés de flammes. Alors que l\'enfer commence à consumer l\'intérieur de %objective%, les portes avant s\'ouvrent et un groupe d\'hommes noircis et désespérés s\'en échappe. Les voyant, %commander% ordonne à tout le monde de charger. | %commander% donne l\'ordre d\'incendier %objective%. Cela se fait en chargeant les catapultes et les trébuchets avec des pierres enveloppées de bois et trempées dans du brai. Elles sont allumées et envoyées en vol. D\'énormes volées de flèches enflammées font de même, naviguant profondément dans les entrailles de %objective% où vous commencez à voir la fumée monter. Un inferno se construit à l\'intérieur des fortifications et il ne faut pas longtemps avant que les portes avant ne s\'ouvrent en grand et que les hommes sortent en courant. %commander% tire son épée.%SPEECH_ON%Les voilà, les hommes. Mettons fin à tout cela une fois pour toutes !%SPEECH_OFF% | Les archers commencent à envelopper leurs flèches dans du tissu et à les tremper dans du brai. Les enfants courent avec des seaux d\'huile et commencent à enduire les boulets de catapulte. Lorsque les préparatifs sont terminés, %commander% donne l\'ordre de lâcher prise. L\'homme a peut-être jadis vénéré le feu, mais ici il est façonné en une terreur furieuse qui siffle à travers le ciel, bombardant %objective% de ruine enflammée. Les tirs de siège pulvérisent les tours et traversent les toits, mettant tout le lieu en feu. Les défenseurs courent avec des flèches enflammées plantées en eux. Alors que l\'incendie s\'intensifie, la porte principale s\'ouvre et des golems de fumée et de cendre sortent en hurlant, se bousculant pour échapper à l\'enfer qui s\'est abattu sur eux.\n\n Voyant cela, %commander% tire son arme.%SPEECH_ON%C\'est ce que nous attendions, les hommes. Eh bien, n\'attendons plus ! Chargez !%SPEECH_OFF% | %commander% donne l\'ordre à ses hommes de lancer l\'enfer lui-même sur %objective%. Vous regardez les catapultes, les trébuchets et les archers remplir le ciel d\'une rafale de tirs enflammés. Les fortifications sont rapidement remplies de feux qui se transforment en un inferno. Des hommes désespérés ouvrent les portes avant et se précipitent dehors, toussant et griffant désespérément l\'air. %commander% tire son arme et rit à la vue de cela.%SPEECH_ON%Les voilà, là ils tomberont ! Chargez !%SPEECH_OFF% | Vous regardez les ingénieurs de siège remplir leurs catapultes et trébuchets avec des carcasses de vache et d\'autres morkin gras. Des enfants avec des seaux de brai parcourent la ligne de bataille, enduisant chaque tir avant de les allumer. Une seconde après, les ingénieurs envoient les cadavres voler. Ils barbotent et gouttent à travers le ciel. Vous regardez un tir frapper une tour et exploser vers l\'extérieur, envoyant le feu dans la cour de la fortification. Il ne faut pas longtemps avant que cette attaque aérienne animale n\'ait %objective% tourbillonnant dans un inferno.\n\n Les portes avant éclatent ouvertes et une foule d\'hommes en sortent en hurlant. Ils se bousculent les uns sur les autres, ressemblant à de la fumée et des cendres devenues vivantes, un sombre fouillis se déroulant devant la porte. %commander% tire son arme.%SPEECH_ON%C\'est ce pour quoi nous avons attendu, les hommes. Eh bien, n\'attendons plus ! Chargez !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chargez !",
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
			Title = "À %objective%...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{La porte de %objective% a été prise, mais il y a encore du travail à faire. L\'élan doit être maintenu : vous ordonnez rapidement à vos hommes de pousser dans la cour. | La porte a été prise, mais la cour de %objective% n\'a pas encore cédé. Vous ordonnez à la %companyname% de continuer à avancer. | La %companyname% a pris la porte et les hommes de %commander% se précipitent actuellement autour des murs du fort pour nettoyer les tours. Vous ne voulez pas perdre d\'élan ici, alors vous ordonnez rapidement aux hommes de poursuivre l\'assaut dans la cour. | Alors que vous vous précipitez dans la cour, les hommes de %commander% se battent au-dessus pour le contrôle des murs. | Vous et la %companyname% vous précipitez dans la cour de %objective%. Au-dessus de vous, le bruit des hommes de %commander% se battant pour le contrôle des murs. | La cour doit être prise ! Vous et la %companyname% vous précipitez dans les fortifications prêt à combattre. Tout autour de vous, les hommes de %commander% se battent pour le contrôle des murs. | Alors que vous vous précipitez dans la cour de %objective%, des hommes abattus tombent d\'en haut, tués par les hommes de %commander% dans une tentative désespérée de contrôler les murs. | Les hommes de %commander% assaillent les murs. Maintenant, vous devez faire votre part et sécuriser la cour ! | Pendant que les hommes de %commander% sécurisent les murs, vous devez sécuriser la cour. Ne faillissez pas !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chargez !",
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
			Text = "[img]gfx/ui/events/event_31.png[/img]{Le fort de %objective% est tombé. Vous regardez les hommes de %commander% fouiller, tirant les cadavres des recoins où les vivants frénétiques s\'étaient traînés dans leurs derniers désespoirs. Les cadavres sont brûlés, décapités, amputés, traînant leurs viscères alors qu\'ils sont traînés, et quelques-uns semblent simplement être morts dans leur sommeil. Un des soldats professionnels se penche depuis les créneaux d\'une tour, arrache la bannière du fort, et hisse le sigle de %noblefamily% à sa place, suscitant de nombreux applaudissements. | Des cadavres jonchent la cour et sont repliés sur les murs comme des vêtements mouillés, certains sont dans les coins avec des regards de choc sur leurs visages, et vous voyez quelques formes noircies, maigres et tordues dans les ruines d\'une écurie brûlée, et parmi ces hommes morts se trouvent des chevaux, des porcs, des chiens et même des oiseaux aux plumes ébouriffées qui ont tous réussi à être aspirés dans la violence qui a visité cet endroit avec une inertie imparable.\n\n %commander% félicite ses hommes survivants pour le travail bien fait. L\'un des soldats hisse la bannière de %noblefamily% au sommet d\'une des tours. Le misérable endroit a de nouveaux propriétaires. | L\'assaut est terminé, les défenseurs de %objective% ont tous été éliminés. Si l\'un d\'entre eux a survécu à cet endroit, c\'est en le quittant complètement. %commander% ordonne à l\'un de ses hommes de hisser le sigle de %noblefamily% au sommet d\'une des tours et, comme ça, la propriété de %objective% change de mains, avec toute la finalité d\'une bannière flottant mollement dans le vent. | Cela a été coûteux, mais l\'assaut a pris fin. %commander% marche sur les cadavres pour ordonner à ses hommes de commencer immédiatement à nettoyer l\'endroit. Un de ses hommes hisse la bannière de %noblefamily% pour que tous puissent voir qui a remporté la bataille ce jour-là. | Tout autour de vous se trouvent les corps des défenseurs de %objective%. Ils ont bien combattu, mais l\'histoire ne se souviendra pas de cela. Leurs noms seront oubliés et leur existence futile. Vous regardez l\'un des soldats de %commander% déployer leur bannière sur l\'une des tours, alors au moins c\'est bien. | Quelques poches de résistance subsistent. Vous regardez les hommes de %commander% jeter des défenseurs d\'une tour voisine, envoyant les pauvres hommes hurler vers leur mort. Lorsqu\'ils sont tous partis, l\'un des soldats hisse le sigle de %noblefamily%. La bannière claque bruyamment dans le silence retrouvé. | Les guérisseurs se précipitent dans la fortification pour s\'occuper des hommes de %commander%. Quelques-uns des défenseurs de %objective% sont également blessés, mais on les laisse se débrouiller seuls. Toute plainte est accueillie par une épée. Les survivants apprennent rapidement qu\'aucune blessure, aucun cri.\n\n La bannière de %noblefamily% est déployée au-dessus de la porte d\'entrée. | Les hommes de %commander% fouillent les restes de la cour de %objective%. Une femme est trouvée et elle est emmenée dans une tour. De jeunes enfants la suivent, sans entrave et hurlant, et pourtant personne ne leur prête attention. %commander% lui-même vous félicite pour le travail bien fait. Il montre du doigt un soldat déployant la bannière de %noblefamily% au-dessus de la porte d\'entrée.%SPEECH_ON%Voyez ce sigle ? Il annonce la victoire.%SPEECH_OFF%Vous pensiez que des tas d\'ennemis morts fournissaient un lexique puissant pour les déclarations de victoire, mais un morceau de tissu qui flotte suffit aussi. | La cour est hérissée de cadavres et du sang goutte le long des murs environnants. Les hommes de %commander% ramassent toutes les armes qu\'ils peuvent et achèvent tout ennemi blessé qu\'ils trouvent. Leurs propres blessés sont soignés par de vieux guérisseurs frêles avec des sacs de feuilles et des remèdes au mortier et au pilon. La bannière de %noblefamily% est déployée sur les murs pour s\'assurer, au cas où la preuve ne serait pas déjà suffisamment claire, que %objective% a de nouveaux propriétaires. | Les citoyens de %objective% sont contraints de traverser ses fortifications, de voir ses défenseurs morts et ses défenses complètement vaincues. %commander% se tient au-dessus d\'eux, les pouces enfoncés dans sa ceinture avec un sourire satisfait sur le visage. Lorsqu\'un soldat déploie la bannière de %noblefamily%, il pointe du doigt.%SPEECH_ON%Voyez cela ? C\'est à qui vous devez maintenant vous incliner. Vous comprenez ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Victoire !",
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
			Text = "[img]gfx/ui/events/event_68.png[/img]{Chasser les défenseurs de %objective% a parfaitement fonctionné. Vous et %commander% traversez la porte désormais sans défense pour voir ce qu\'il reste de l\'endroit. Malheureusement, les incendies ont réduit la plupart de l\'endroit en cendres. Peu importe, l\'un des soldats professionnels hisse une bannière de %noblefamily% au sommet d\'une des tours. Vous pouvez à peine reconnaître le sigle à travers le nuage de cendres tourbillonnantes et de fumée. | Le champ de bataille est jonché de morts et de mourants. Les hommes de %commander% traversent les monticules de cadavres, enfonçant occasionnellement leurs lances dans le sol et faisant taire les gémissements qui s\'y étaient faufilés.\n\n Vous et le commandant traversez la porte de %objective%. Les incendies ont transformé chaque bâtiment en ossature osseuse et carbonisée. Il y a des animaux de ferme brûlés partout dans la cour. %commander% hausse les épaules et ordonne à l\'un de ses hommes de hisser le drapeau de %noblefamily% au sommet d\'une des tours pour que tous sachent qui a remporté cette journée. | La bataille est terminée. Chasser les défenseurs de %objective% avec le feu a très probablement sauvé de nombreuses vies, mais au-delà des portes, tout a été nettoyé par les flammes. Il faudra du temps pour reconstruire à sa gloire passée, quelle qu\'elle ait été. %commander% semble assez content alors qu\'il ordonne à l\'un de ses hommes de hisser le drapeau de %noblefamily% au sommet d\'une des tours. Ses linges colorés claquent nettement parmi les nuances de cendre flottante et de fumée. | %commander% marche dans les cendres des fortifications de %objective%.%SPEECH_ON%Eh bien, nous l\'avons eu. Ce qu\'il en reste de toute façon. Je ne vais pas me plaindre, cependant. Bon travail, mercenaire.%SPEECH_OFF% | Les citoyens de %objective% sortent pour voir les restes de leurs défenses. Les femmes fouillent les corps calcinés, cherchant tout signe de leurs proches. Au lieu de cela, elles ne trouvent que leurs hommes réduits en squelettes calcinés et filiformes, les visages fondus en des grimaces sinistres capturant leurs derniers moments. Un des hommes de %commander% déploie la bannière de %noblefamily% au-dessus de la porte d\'entrée et le commandant pointe rapidement vers elle.%SPEECH_ON%Écoutez ! Vous voyez ça là-bas ? C\'est ce que nous sommes. Maintenant, tout ce que vous avez à faire, c\'est le respecter et tout peut revenir à la normale ! Manquez de respect à ça, et je vous apporterai une nouvelle normalité, vous avez compris ?%SPEECH_OFF%La foule de citoyens hoche silencieusement la tête. %commander% sourit et c\'est effrayamment authentique.%SPEECH_ON%Bien ! Maintenant, est-ce que quelqu\'un ici sait faire de bonnes œufs brouillés ?%SPEECH_OFF% | Vous et %commander% pénétrez dans les fortifications de %objective% pour découvrir la coda d\'un combat pour l\'air lui-même. Des formes noircies, soit des hommes soit des bêtes, ont clamber par-dessus les autres. La main d\'un homme tire en arrière les restes carbonisés d\'un autre homme, sa prise s\'étendant en arrière comme une corde de chair brûlée. Vous vous couvrez la bouche pour ne pas vomir. %commander% ordonne à ses hommes de hisser la bannière de %noblefamily% au-dessus de la porte d\'entrée. Il vous tape sur l\'épaule.%SPEECH_ON%Hé, bon boulot là-bas, mercenaire. Vous devriez respirer cette puanteur, cependant. Ça vous aidera à vous y habituer plus vite.%SPEECH_OFF% | Vous passez à travers les murs de %objective% en tenant un chiffon sur votre nez. %commander% marche à côté de vous, la tête haute avec une suffisance qui est d\'une puanteur propre. À l\'intérieur de %objective%, vous trouvez des corps reliés par des os et de la chair fondue, des dents acérées flashant dans des grimaces granuleuses résonnant de l\'horrible finalité d\'une mort brûlante. %commander% vous tape sur l\'épaule.%SPEECH_ON%C\'était vraiment une victoire, tu sais ça ? Tu devrais retourner chez %employer%, à moins que tu ne veuilles aider au nettoyage.%SPEECH_OFF% | Vous et %commander% entrez dans %objective% avec des épées levées, mais il n\'y a rien à combattre : l\'enfer a consumé tout être vivant. S\'ils n\'ont pas été brûlés à mort, on les trouve crottés de la cendre et de la fumée qu\'ils ont inhalées. %commander% donne un coup de pied dans les décombres, un cadavre calciné tombant pendant qu\'il le fait.%SPEECH_ON%Diable, il n\'y a pas grand-chose ici sauf les murs.%SPEECH_OFF%Il vous regarde sévèrement.%SPEECH_ON%Mais les murs, c\'est tout.%SPEECH_OFF%Vous vous accroupissez et regardez l\'homme mort.%SPEECH_ON%Tu crois qu\'il pensait la même chose ?%SPEECH_OFF%Le commandant hausse les épaules. Il se détourne rapidement et ordonne à l\'un de ses hommes de déployer la bannière de %noblefamily% au-dessus de la porte d\'entrée. | Vous mettez les pieds dans %objective% et le regrettez immédiatement. Il y a des corps partout et aucun n\'est identifiable. Le feu a tout noirci, même la boue elle-même. %commander% utilise son pied pour essayer de retourner un cadavre. Des copeaux de chair crissent et éclatent comme s\'il avait marché sur une mince couche de glace. L\'homme renifle.%SPEECH_ON%Maintenant, c\'est désagréable, tu ne trouves pas ?%SPEECH_OFF%Il se tourne et siffle bruyamment avant de pointer l\'un de ses soldats.%SPEECH_ON%Toi ! Lève la bannière de %noblefamily% au-dessus des portes et des tours !%SPEECH_OFF%Le soldat salue et se précipite vers son devoir. %commander% vous tape sur l\'épaule et dit que %employer% devrait être très heureux de ces résultats. | Il n\'y a pas grand-chose à récupérer des fortifications de %objective% : les incendies ont damné près de tout. Ceux qui sont restés, ont brûlé. Ceux qui se sont précipités vers les tours pour se mettre à l\'abri, ont suffoqué. Les visages des morts racontent les deux histoires de manière explicite - ce n\'était pas une bonne façon de partir. Mais %commander% semble heureux, ordonnant à ses hommes de commencer à nettoyer et de déployer les bannières de %noblefamily%. | Vous fouillez les restes de %objective%. Les cadavres attirent votre regard car vous n\'avez jamais vu autant de cadavres brûlés en un seul endroit. L\'un d\'eux serre une forme minuscule qui, à un examen plus approfondi, s\'avère être un nourrisson. %commander% s\'approche et vous tape sur l\'épaule.%SPEECH_ON%Ah, c\'est dommage. Hé, tu as fait du bon travail, mercenaire. Ne réfléchis pas à rien, d\'accord ?%SPEECH_OFF%Vous hochez la tête. Le commandant sourit brièvement avant d\'ordonner à ses hommes de déployer les bannières de %noblefamily% partout où ils le peuvent. Mieux vaut faire savoir aux étrangers que cette carcasse brûlée d\'un fort a de nouveaux propriétaires. | À l\'intérieur de %objective%, vous trouvez toute sorte de chaos calciné. Des chiens morts qui ont été incendiés, leurs chaînes les faisant brûler longtemps avant que les feux ne le fassent. Des chevaux coincés dans des écuries avec leurs pattes noircies raides dans l\'air. Des porcs qui ont brisé leurs clôtures et ont couru en liberté, sans doute en feu tout le temps. Une légère odeur de bacon à peine inférieure à l\'odeur autrement horribile. Il n\'y avait pas d\'échappatoire pour aucune de ces créatures.\n\n Vous ouvrez la porte d\'un débarras et trouvez un tas de défenseurs qui ont suffoqué. %commander% vient se tenir derrière vous, regardant à l\'intérieur.%SPEECH_ON>Pauvres gars. Ils ont l\'air jeunes. Probablement des palefreniers, des écuyers. Quelle honte.%SPEECH_OFF%Le commandant se penche dans la pièce et fait tomber de la paille d\'un pain. Il pèle la couche extérieure pour révéler un noyau frais.%SPEECH_ON>Hé, tu as faim ?%SPEECH_OFF%Vous déclinez poliment l\'offre.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Victoire !",
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
			Title = "À the siege...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%commander% revient avec la nouvelle selon laquelle les défenseurs pourraient s\'affaiblir. Il espère éviter une attaque mortelle et préfère simplement les attendre. On vous demande de rester avec le campement assiégé jusqu\'à nouvel ordre. | L\'un des lieutenants de %commander% vous informe que le commandant a décidé d\'attendre un peu plus longtemps, espérant que les défenseurs se rendront plutôt que de prolonger le combat. Le %companyname% est mis en attente jusqu\'à nouvel ordre. | On vous informe que le siège va se poursuivre un peu plus longtemps. On vous demande d\'attendre un certain temps jusqu\'à nouvel ordre.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "La %companyname% sera prete.",
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
			Text = "[img]gfx/ui/events/event_33.png[/img]{%commander% vous ordonne, ainsi qu\'aux hommes, de partir en patrouille. En faisant le tour, vous repérez quelques défenseurs de %objective% qui sortent d\'un lit de ruisseau à côté d\'un des murs du fort. Ils glissent à travers une sorte de passage secret. Pensant rapidement, vous ordonnez à vos hommes de se précipiter sur eux, espérant capturer le passage avant qu\'ils ne vous voient en premier. Assurez-vous que ces salauds ne puissent pas s\'échapper par le passage secret ! | Tandis que vous attendez de voir comment se déroule le siège, %commander% passe et vous ordonne, ainsi qu\'au %companyname%, de patrouiller les défenses extérieures de %objective%.\n\n Ô surprise, pendant que vous vous promenez, vous repérez quelques défenseurs de %objective% qui s\'infiltrent par une trappe. Vous vous accroupissez et les observez attentivement. Lorsque la trappe se referme, vous constatez que le dessus a été recouvert de mousse et d\'herbe pour masquer son emplacement. Si vous partez maintenant pour informer %commander%, il est très probable qu\'un des hommes vous voie et détruise le passage. Vous décidez de saisir l\'instant et d\'ordonner une attaque. Le %companyname% doit s\'assurer qu\'aucun défenseur ne s\'échappe ! | Alors que le siège s\'apaise, vous décidez de prendre un peu d\'initiative et de demander si vous et le %companyname% pouvez faire des patrouilles. Un peu de marche permettra de maintenir la fraîcheur des hommes et de les maintenir sur leurs gardes. Sinon, ils peuvent traîner autour du camp et se battre avec les soldats professionnels. %commander% est d\'accord.\n\n Pas plus de quelques minutes après le début de la patrouille, vous repérez quelques défenseurs de %objective% qui se tirent vers le haut du remblai d\'une douve à moitié faite. Ils nagent à travers une trappe d\'égout près des murs de la fortification. %randombrother% secoue la tête.%SPEECH_ON%Je serai foutu.%SPEECH_OFF%Vous lui dites de se taire. Si l\'un des défenseurs apprend que leur passage secret a été découvert, ils seront sûrs de le fermer. Vous attendez que tous les défenseurs sortent dans le champ libre, puis ordonnez une attaque. Aucun des défenseurs ne doit être autorisé à s\'échapper ! | Une patrouille est ordonnée et vous choisissez le %companyname% pour la mission. Vos hommes râlent et se plaignent, mais ce genre de tâches est bon pour maintenir les hommes frais et vigilants.\n\n Trouver un groupe de défenseurs de %objective% qui sortent d\'un passage secret est aussi un excellent moyen de maintenir les choses fraîches ! Pas plus de quelques minutes après être sorti, vous trouvez les défenseurs en train de faire exactement cela. Vous regardez les défenseurs se regrouper et, juste au moment où ils sont prêts à se faufiler dans l\'arrière-pays, vous ordonnez une attaque. Aucun de ces défenseurs ne doit être autorisé à s\'échapper ! | Alors que le siège se poursuit, %commander% vous ordonne à vous et à vos hommes de patrouiller les fortifications autour de %objective%. À mi-parcours de la ronde, vos hommes tombent sur quelques défenseurs qui sortent d\'un passage secret, une grille enlisée là où la douve monte jusqu\'à la poitrine. Capturer ce passage serait un énorme avantage tactique dans les jours à venir. Vous ordonnez rapidement à vos hommes d\'attaquer - et que aucun des défenseurs ne doit être autorisé à s\'échapper !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Attrapez-les !",
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
			Text = "[img]gfx/ui/events/event_33.png[/img]{Zut, quelques défenseurs ont réussi à se faufiler à travers le passage et vous pouvez déjà entendre qu\'il est en train d\'être scellé. | Vous n\'avez tout simplement pas été assez rapide pour arrêter tous les défenseurs et quelques-uns ont réussi à s\'échapper. Ils sont retournés dans %objective% et ont scellé le passage derrière eux. | Eh bien, l\'objectif était de tuer ceux qui s\'échappaient en douce et de sécuriser le passage. Au lieu de cela, quelques-uns ont réussi à s\'échapper dans %objective% et à refermer le passage derrière eux.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zut !"
					function getResult()
					{
						this.Flags.set("IsNighttimeEncounterLost", false);
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
			Text ="[img]gfx/ui/events/event_33.png[/img]{Vous avez réussi à tuer tous les défenseurs et à sécuriser le passage. Lorsque vous rapportez la nouvelle à %commander%, il vous dit de vous faufiler par le passage secret et d\'assassiner le commandant principal de %objective%. Vous aurez quelques heures pour vous préparer, mais le temps presse et vous devrez frapper avant la fin de la nuit. | En tuant tous les défenseurs, vous parvenez à sécuriser le passage. Vous retournez vers %commander% et expliquez la situation. Il hoche la tête avec diligence, puis se tourne vers vous.%SPEECH_ON%Je veux que vous vous faufiliez par le passage secret, entriez dans les fortifications et assassiniez leur leader.%SPEECH_OFF%Comparé à l\'alternative d\'une attaque frontale, cette opération nocturne est à peu près aussi agréable qu\'une action que vous ayez entendue depuis un certain temps. | Le passage secret est sécurisé et la nouvelle en est rapportée à %commander%. Il rit en secouant la tête.%SPEECH_ON%Ça faisait si longtemps qu\'on cherchait quelque chose comme ça, et là vous êtes, à peine sorti en patrouille et déjà en train de trouver les clés de %objective%.%SPEECH_OFF%Il déclare qu\'il veut que vous et le %companyname% vous faufiliez par le passage et assassiniez la direction. Une fois que cela est fait, les défenseurs seront ruinés et %objective% pourra être pris facilement. C\'est soit cela, soit tenter une attaque frontale, dont vous n\'avez aucun intérêt. Vous aurez quelques heures pour vous préparer, mais la mission doit être entreprise avant la fin de la nuit. | L\'un des défenseurs crie à l\'aide.%SPEECH_ON%Ils nous ont trouvés ughhh-%SPEECH_OFF%%randombrother% est rapide pour mettre un chiffon sur la bouche de l\'homme, puis lui trancher la gorge. Vous regardez les murs de %objective% à la recherche d\'activité, mais il semble que personne n\'ait entendu le cri.\n\n Revenant au camp assiégé, vous êtes intercepté par %commander%. Il cherche de bonnes nouvelles et vous vous en départez volontiers. Le leader tape du pied.%SPEECH_ON%Par les dieux, c\'est la meilleure nouvelle que j\'ai entendue depuis des semaines ! D\'accord, c\'est excellent, mais nous devons agir vite. Je veux que vous et vos hommes vous glissiez par ce passage et assassiniez la direction de %objective%. Nous devons le faire le plus tôt possible, quelques heures d\'attente au maximum, compris ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous nous préparerons, puis nous nous faufilerons."
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
			Text = "[img]gfx/ui/events/event_33.png[/img]{Vous n\'avez pas réussi à tuer le leader du défenseur et avec leur commandant toujours à la barre, %commander% a dû annuler le siège. Bien que l\'échec du siège n\'ait pas été entièrement de votre faute, il est fort probable que %employer% le voie ainsi. | Le passage secret a été fermé ! Avec le commandant des défenseurs toujours en vie, les fortifications seront bien trop coûteuses à attaquer. %commander% a annulé le siège et vous avez reçu une bonne part du blâme pour cela. | Eh bien, vous avez mis trop de temps à utiliser le passage secret. Les défenseurs ont dû se méfier de le laisser ouvert et l\'ont fermé avec un tas de rochers. Avec les défenseurs toujours sous le commandement stable, attaquer les fortifications coûtera très cher à l\'armée de %commander%. Il a annulé le siège. %employer% ne sera pas content.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zut !"
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
			Text = "[img]gfx/ui/events/event_33.png[/img]{Vous et le %companyname% glissez silencieusement à travers le passage. Les parois du tunnel gouttent de merde et de pisse, et les eaux dans lesquelles vous pataugez ne sont guère meilleures. %randombrother% se plaint un peu, mais vous lui dites de la fermer.\n\n En sortant de l\'autre côté, vous débouchez dans une cour, la compagnie se faufilant le long d\'une rangée de buissons avant de s\'allonger à plat pour observer le terrain.\n\n Quelques défenseurs se promènent. Ils soupirent, grognent et gémissent. La faim tord leurs ventres, et les malédictions agitent leurs langues. Assez rapidement, le commandant est vu avec une troupe de ses meilleurs gardes à ses côtés. Il traverse la cour pour une inspection. Vous ne trouverez pas une meilleure chance que celle-ci et ordonnez l\'attaque ! | Le %companyname% et vous ouvrez le passage secret. Vous trouvez un petit palefrenier en train de sortir avec une liste de biens demandés écrite sur un parchemin. Il supplie pour sa vie, mais vous ne pouvez rien risquer maintenant. %randombrother% lui tranche la gorge et le noie dans l\'ordure qui coule hors du tunnel du passage. Vous continuez et débouchez dans une cour. Les hommes et vous vous glissez le long d\'une rangée de buissons et observez pendant un moment.\n\n En attendant, un homme vêtu comme un commandant descend quelques marches avec une bande de gardes derrière lui. Vous doutez que vous aurez une meilleure opportunité que celle-ci et ordonnez l\'attaque ! | Le passage secret est sombre et trouble, les eaux qui traversent les tunnels pleines de merde et de piss. Vous remontez vos pantalons et entrez. Les torches vous trahiraient, alors vous avancez à l\'aveugle en tâtant les murs. Vous ne savez pas quelles horreurs vos doigts frôlent et vous espérez ne jamais le savoir. Finalement, une faible lumière vacille au loin et vous sortez du passage pour déboucher dans une cour.\n\n Le commandant de %objective% évalue ses troupes, mais s\'arrête pour se retourner et regarder vous et le %companyname% faire une entrée grandiose et puante. Ses yeux s\'élargissent et il pointe d\'une main tandis que l\'autre cherche son arme.%SPEECH_ON%Assassins !%SPEECH_OFF%Vous ordonnez au %companyname% d\'attaquer ! | Le passage secret est étonnamment court pour atteindre l\'autre côté des murs de %objective%. De l\'autre côté des tunnels se tient un homme en faction. Il voit les formes de vous et de vos hommes surgir de l\'obscurité. Il demande.%SPEECH_ON%J\'espère à tous les vieux dieux foutus que vous avez ce que nous avons demandé. N\'oubliez pas, j\'ai demandé des œufs et...%SPEECH_OFF%Pendant un moment, il voit le visage de %randombrother% émerger des ombres, et pendant un autre moment, il réalise que l\'inconnu devant lui n\'est pas un simple garçon de course. Le gardien recule, mais avant qu\'il ne puisse crier à l\'aide, votre mercenaire lui enfonce une lame dans la poitrine, et tous deux vont voler dans un buisson. Avec lui hors du chemin, vous vous glissez discrètement dans %objective% et trouvez son commandant en train de faire des exercices dans la cour.\n\n N\'ayant pas de meilleure chance que celle-ci, vous ordonnez au %companyname% d\'attaquer !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chargez !",
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
			Text = "[img]gfx/ui/events/event_31.png[/img]{Le commandant de %objective% est tombé, et ses hommes déposent rapidement leurs armes. Un lieutenant lève les mains et parle précipitamment.%SPEECH_ON%Nous n\'avons aucun intérêt à poursuivre cette proposition perdante. Le seul homme qui y croyait est mort là-bas. Nous nous rendons.%SPEECH_OFF%%employer% sera très heureux de cette tournure des événements. | La bataille terminée, vous trouvez le commandant mourant de la défense de %objective%. Il crache du sang lorsque vous passez au-dessus de lui.%SPEECH_ON%Nous ne nous rendrons jamais. Faites de votre pire, vous mercenaire déplorable.%SPEECH_OFF%Vous enfoncez une épée dans sa cavité oculaire. L\'un de ses lieutenants laisse tomber son arme et lève les mains.%SPEECH_ON%Hé, c\'était le seul ici qui se souciait de défendre cet endroit. C\'est tout à vous. Laissez-nous juste vivre !%SPEECH_OFF%Vous donnez à %randombrother% l\'ordre de signaler à %commander% la prise des fortifications. | Le commandant de %objective% est mort, et ses hommes se rendent immédiatement à l\'unisson. Ils expliquent que seul le commandant voulait continuer à tenir l\'endroit. Apparemment, il cherchait à attirer l\'attention au sein des familles nobles et pensait qu\'une défense héroïque lui assurerait une place à la table des puissants. Eh bien, maintenant, il est mort dans la boue. Vous dites à %randombrother% de hisser le signal pour que %commander% sache que %objective% s\'est rendu. Un défenseur vous demande de la clémence.%SPEECH_ON%Sûrement, vous nous laisserez vivre, n\'est-ce pas ?%SPEECH_OFF%Vous nettoyez votre lame et haussez les épaules.%SPEECH_ON%Ce n\'est pas à moi de décider. Mon bienfaiteur et l\'armée qu\'il dirige sont sur le point de passer par cette porte. Ce qu\'il a l\'intention de faire m\'échappe. Si vous voulez de la clémence, prenez une arme et mes hommes vous la donneront.%SPEECH_OFF%Le défenseur fronce les sourcils et acquiesce.%SPEECH_ON%Je suppose que je vais tenter ma chance avec lui.%SPEECH_OFF% | Le commandant de %objective% est mort dans la boue. Ses troupes survivantes ont toutes les mains en l\'air. Vous ordonnez à vos hommes d\'entraver les défenseurs pendant que vous donnez le signal, déployant votre blason le long d\'une tour. Le camp de siège de %commander% sonne une corne en réponse. La bataille est terminée. %employer% sera sans aucun doute très satisfait. | La bataille est terminée et le leader de %objective% est mort dans la boue. Ayant arraché leur cœur et leur âme, les défenseurs se rendent immédiatement. Vous ordonnez au %companyname% de les rassembler et de les enchaîner. %randombrother% va donner le signal à %commander% que le fort a été pris. %employer% sera sans aucun doute ravi de vous revoir à votre retour.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous l\'avons fait !",
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
			Text = "[img]gfx/ui/events/event_33.png[/img]{Malheureusement, vous n\'avez pas pu vous positionner pour assassiner le commandant et avez dû battre en retraite. Les défenseurs de %objective% se moquent de vous et de vos hommes alors que vous glissez à travers les tunnels. Lorsque vous revenez à l\'extérieur, vous entendez le passage secret se refermer. Il semble qu\'un itinéraire plus difficile devra être emprunté pour capturer %objective%. | La bataille ne s\'est pas déroulée comme espéré. Vous et le %companyname% êtes repoussés vers le passage secret et effectuez une retraite combative. Lorsque vous revenez à l\'extérieur, vous entendez des pierres et des bruits sourds alors que les défenseurs ferment tout. Vous avez fait de votre mieux, mais il semble que prendre %objective% ne sera pas aussi facile que vous l\'aviez espéré. | À leur crédit, les défenseurs ont fait du bon travail. Fatigués et sous-alimentés, ils ont combattu comme des chiens acculés. Lorsque vous faites retraite à l\'extérieur des murs de %objective%, vous entendez le son distinct du passage secret se refermant.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bon sang !",
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
			Title = "À the siege...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Les éclaireurs de %commander% reviennent avec la nouvelle qu\'une force de secours arrive pour tenter de mettre fin au siège de %objective%. Le commandant acquiesce et ordonne à ses hommes de se préparer au combat. Vous faites de même. | En attendant, quelques éclaireurs reviennent et entrent dans la tente de %commander%. Vous entrez après eux et voyez le commandant acquiescer tout en rassemblant ses affaires. Il vous regarde et explique.%SPEECH_ON%Une force de secours arrive. Ils vont tenter de mettre fin au siège. Préparez vos hommes.%SPEECH_OFF% | {Vous regardez %randombrother% faire de la lutte avec l\'un des soldats professionnels. Ils parient sur un poulet sans tête. Le gagnant a le ventre plein, le perdant un bras endolori. | Un des soldats assiégeants et %randombrother% s\'apprêtent à commencer un concours de regards. Celui qui cligne des yeux en premier perd. Celui qui gagne obtient un poulet. | Vous trouvez %randombrother% lançant de grosses pierres près d\'un pieu dans la boue. Un soldat de l\'armée assiégeante fait de même. Apparemment, ils rivalisent pour un poulet et ils en sont au tout dernier lancer pour remporter la mise.} Avant qu\'ils ne commencent, un éclaireur traverse le camp et annonce qu\'une armée arrive pour tenter de soulager %objective%. %commander% ordonne à ses hommes de se préparer. Vous répétez l\'ordre au %companyname%. | Les éclaireurs de %commander% sont revenus avec la nouvelle qu\'une armée arrive pour tenter de soulager %objective%. Vous ordonnez au %companyname% de se préparer pour une grande bataille. | Une grande bataille se profile à l\'horizon : les éclaireurs de %commander% sont revenus avec la nouvelle qu\'une force de secours arrive pour tenter de mettre fin au siège. Préparez-vous !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Preparez vous pour la bataille !",
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
			Text = "[img]gfx/ui/events/event_86.png[/img]{La force de secours a été défaite et repoussée du champ de bataille. Les défenseurs de %objective% ont sans aucun doute observé toute la bataille et ont subi une baisse de leur moral. Il est probable qu\'ils se rendent dans un avenir proche ! | Hourra ! La force de secours a été rapidement neutralisée. %commander% vous remercie pour votre aide. Il scrute les murs de %objective% avec sa longue-vue gainée de cuir et sourit.%SPEECH_ON%Oh, c\'est une bande battue. Ils ont tout vu. Je n\'ai jamais vu un groupe d\'hommes aussi désespéré de ma vie.%SPEECH_OFF%Il vous tape sur l\'épaule avec un large sourire.%SPEECH_ON%Sellsword, je pense que ce siège touche à sa fin !%SPEECH_OFF% | Vous avez réussi à repousser la force de secours ! C\'était probablement le dernier espoir pour %objective% et leur reddition est à prévoir d\'un jour à l\'autre. | %commander% vous remercie d\'avoir contribué à détruire la force de secours. Il pense que la reddition de %objective% est probable à tout moment maintenant. | Regarder votre seul espoir au monde se faire anéantir n\'est probablement pas le meilleur pour le moral. Les défenseurs de %objective% ont pu voir leur force de secours massacrée et il est fort probable qu\'ils soient désormais au bord de la reddition. | Eh bien, le grand dernier espoir de %objective% a été complètement anéanti. Vous et %commander% vous réunissez et êtes d\'accord : les défenseurs sont sans aucun doute prêts à se rendre. C\'est juste une question de temps.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ils ne peuvent pas tenir éternellement.",
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
			Text = "[img]gfx/ui/events/event_31.png[/img]%objective% se rend!\n\n{Vous traversez les portes ouvertes pour trouver ses défenseurs éparpillés partout. Des hommes affamés s\'effondrent de douleur, d\'autres s\'appuient contre les murs, les lèvres gercées se fissurant alors qu\'ils supplient de l\'eau. Aucun animal n\'est en vie. Ils ont tous été abattus depuis longtemps. Des corbeaux noirs observent depuis les murs, se joignant à vous dans la conquête et attendant simplement une opportunité de piller. %commander% vous tape sur l\'épaule et vous remercie pour l\'aide. | La porte principale s\'ouvre et vous la traversez comme le vainqueur que vous êtes. Cependant, la scène à l\'intérieur devrait dissiper toute notion d\'honneur dans la défaite de ces âmes malheureuses. Les défenseurs morts ont été empilés dans un coin. Quelques hommes ont été crucifiés pour cannibalisme, mais même ces hommes exécutés montrent des signes d\'avoir été consommés. Il y a une grange brûlée d\'un côté de la cour. Certains hommes sont assis avec la bouche noircie, apparemment ayant essayé d\'engloutir les restes calcinés de céréales. Chaque animal a été abattu et dépecé jusqu\'à l\'os.\n\n %commander% rit de la scène et dit à ses hommes d\'enchaîner les prisonniers. Il se tourne vers vous.%SPEECH_ON%Merci, mercenaire. Vous pouvez retourner chez %employeur% maintenant.%SPEECH_OFF% | À l\'intérieur du fort, vous trouvez les défenseurs debout en ligne. Deux soldats de %commander% descendent la file, l\'un traînant des chaînes et l\'autre prenant ces chaînes et enchaînant les hommes ensemble. Vous voyez un cadavre empalé au sommet d\'une écurie, la girouette explosant sa poitrine et portant son cœur dessus comme une fin viscérale à un rituel. %commander% vient en riant.%SPEECH_ON%C\'était leur lieutenant. {Ils ont dit qu\'il a refusé de se rendre et s\'est jeté du haut de la tour. | Apparemment, il a refusé de se rendre, alors ses hommes l\'ont jeté de la tour.}%SPEECH_OFF%Intéressant. Eh bien, %employeur% sera plus qu\'heureux de vous revoir. | Au-delà des murs, les hommes de %commander% prennent les armes des défenseurs et les jettent en un grand tas. Les défenseurs eux-mêmes sont regroupés dans un coin, chacun avec les bras enchaînés derrière le dos, la tête baissée, les yeux fixés sur la boue. Quelques gardes les surveillent, les frappant occasionnellement, crachant sur eux, ou même les menaçant de les tuer. Tout cela dans la bonne humeur.\n\n %commander% vient vous voir et vous tape dans le dos.%SPEECH_ON%Bien joué, mercenaire. Votre aide a été très appréciée. Retournez chez %employeur%. Votre travail ici est terminé.%SPEECH_OFF% | En passant par la porte, vous trouvez les défenseurs implorant la clémence. Leur lieutenant est mort dans la boue, toujours en train de fuir des dizaines de coups de couteau. Un homme explique.%SPEECH_ON%Nous voulions nous rendre il y a si longtemps, mais il ne nous laissait pas! Vous devez comprendre! Nous ne voulons plus de cette guerre.%SPEECH_OFF%%commander% vient à côté de vous et fait signe de la tête.%SPEECH_ON%Votre travail ici est terminé, mercenaire. Allez voir %employeur%.%SPEECH_OFF%Vous demandez ce qu\'il va faire des prisonniers. Il hausse les épaules.%SPEECH_ON%Dunno. Je pense que je vais manger d\'abord. Peut-être rédiger une lettre à mes proches. J\'essaie de ne pas être impulsif à ce sujet.%SPEECH_OFF%Assez juste. | Vous et %commander% traversez les portes ouvertes. À l\'intérieur, quelques-uns des défenseurs survivants s\'effondrent, suppliant de la nourriture à genoux. Ils peuvent à peine redresser leur corps pour mendier, leur estomac si ravagé par la douleur.%SPEECH_ON%S\'il vous plaît! Aidez-nous...%SPEECH_OFF%%commander% met un pied sur l\'un des hommes et le pousse par terre.%SPEECH_ON%On dirait qu\'on peut vous aider?%SPEECH_OFF%Le commandant se tourne vers vous.%SPEECH_ON%Bien joué, mercenaire. Retournez chez %employeur. Votre travail ici est terminé.%SPEECH_OFF% | À travers la porte, vous trouvez les défenseurs rassemblés et mis dans un coin. %commander% demande qui parmi eux est le leader. Le groupe pointe uniformément de l\'autre côté de la cour. Un homme mort pend d\'une des tours, le visage pâle avec des mains violettes et un nez violet. Un des prisonniers explique.%SPEECH_ON%Si nous ne l\'avions pas fait, vous seriez toujours là-bas et nous serions toujours ici en train de mourir de faim.%SPEECH_OFF%%commander% hoche la tête.%SPEECH_ON%D\'accord. Je ne vous punirai pas tous pour ça. Mercenaire! Retournez chez %employeur%. Votre travail ici est terminé.%SPEECH_OFF% | En passant par la porte, vous trouvez le commandant du fort brandissant une épée longue alors que quelques hommes de %commander% l\'encerclent avec des lances. Dans une grande ruée uniforme, ils l\'embrochent comme un animal sauvage. Immobilisé par les pointes, il abandonne et s\'effondre en avant, drapant ses bras sur le bois comme s\'il s\'appuyait paresseusement contre des poteaux de clôture.%SPEECH_ON%D\'accord, je suppose que vous m\'avez, salauds.%SPEECH_OFF%Il se tourne vers ses hommes qui, apparemment, étaient ceux qui ont réellement ouvert les portes.%SPEECH_ON%Je vous verrai tous dans la vie suivante.%SPEECH_OFF%Du sang coule de sa bouche et son corps tremble une fois et c\'est tout. Les soldats récupèrent leurs lances et le chef tombe droit dans la boue. %commander% se tient au-dessus de lui et s\'adresse à vous.%SPEECH_ON%D\'accord, mercenaire. Retournez chez %employeur%.%SPEECH_OFF% | L\'intérieur du fort est un endroit d\'horreur. Des hommes sont éparpillés, se tenant le ventre, certains déjà morts, d\'autres souhaitant l\'être. Le commandant du lieu est suspendu à une tour, une bannière familiale enroulée autour de son cou comme si cela apportait un peu de dignité à sa mort. Les os d\'animaux jonchent la cour et il y a de la merde, de l\'urine et du vomi partout. %commander% vient à vos côtés et hoche la tête.%SPEECH_ON%Cela semble juste. Dommage qu\'ils n\'aient pas capitulé plus tôt.%SPEECH_OFF%Vous suggérez que c\'était probablement le lieutenant mort se balançant par son propre blason qui résistait à la reddition. Le commandant hoche de nouveau la tête.%SPEECH_ON%Oui. Il pensait que c\'était la chose honorable à faire. J\'aurais probablement fait la même chose autrefois, mais après avoir vu cela, je ne suis plus si sûr qu\'il ait raison.%SPEECH_OFF% | En passant par la porte, vous trouvez les défenseurs regroupés devant un lieu de culte. Il n\'en reste pas beaucoup et pas un seul ne prie. Les morts ont été entassés dans un coin et il y a des preuves de cannibalisme. Aucun animal n\'est autour. L\'étable est si remplie de mouches qu\'elle rugit presque de leur bourdonnement frénétique. La porcherie a été complètement piétinée. Un des prisonniers vous regarde.%SPEECH_ON%Nous avons mangé tout ce que nous pouvions. Comprenez-vous ? Nous. Avons. Tout. Mangé.%SPEECH_OFF%%commander% vient à vos côtés.%SPEECH_ON%Ne les laissez pas vous déranger, mercenaire. Retournez chez %employeur%. Il vous attendra sans aucun doute.%SPEECH_OFF% | Vous et %commander% traversez les portes avant. Les défenseurs à l\'intérieur sont plus des squelettes que de la chair et ils se traînent en conséquence. L\'un d\'eux s\'accroche à votre épaule.%SPEECH_ON%Manger ! Manger !%SPEECH_OFF%Son haleine porte l\'odeur horrible de la faim. Vous le jetez par terre et là il crie et commence à fourrer sa bouche de boue. %commander% vient à vos côtés tout en mâchant un morceau de pain beurré.%SPEECH_ON%Ces salauds ont l\'air d\'un triste spectacle, non ?%SPEECH_OFF%Des miettes jaillissent de sa bouche et les prisonniers les fixent comme si c\'était de l\'or. Le commandant vous tape sur l\'épaule.%SPEECH_ON%Retournez chez %employeur%, il sera plus qu\'heureux d\'apprendre la bonne nouvelle.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%objective% est tombé !",
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
			Title = "À the siege...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Un fort mugissement perce le vacarme du camp assiégé. Vous regardez pour voir les portes de %objective% s\'ouvrir et un groupe d\'hommes en sortir. %commander% sprinte hors de sa tente, jette un coup d\'œil, puis commence à crier à ses hommes.%SPEECH_ON%Sally ! Sally ! Ils arrivent, les hommes, ils arrivent ! Préparez-vous ! Tuez ces salauds de rats jusqu\'au dernier, vous m\'entendez ?%SPEECH_OFF%Le camp assiégé gronde d\'anticipation. Vous rassemblez rapidement les %companyname% et vous préparez à rejoindre la bataille. | Les défenseurs de %objective% s\'aventurent dehors ! Vous ordonnez à vos hommes de se préparer et de se joindre à %commander% dans la bataille. | Il n\'y aura pas de reddition ! Les défenseurs de %objective% s\'avancent. Ils ont l\'air pauvre et affamé, mais il semble qu\'ils préféreraient mourir ici que de se rendre. %commander% dit à ses hommes de se préparer, et vous faites de même avec les %companyname%. | Les portes de %objective% s\'ouvrent ! Au début, c\'est tout ce qui se passe, puis un rugissement étouffé se fait entendre et un petit groupe de défenseurs commence à sortir. Ils lèvent les bras sous les acclamations et chantent le cri de guerre de leur famille. Ils apportent le volume, et vous apporterez la violence. À la bataille ! | Le grincement des charnières rouillées résonne dans le camp assiégé. Vous regardez %objective% pour voir ses portes s\'ouvrir lentement. Un groupe d\'hommes en sort, portant des bannières et des armes. Ils ont l\'air d\'avoir déjà été battus dans une bataille, avançant péniblement sur des ventres affamés. %commander% secoue la tête.%SPEECH_ON%Ces imbéciles. Pourquoi ne se rendent-ils pas simplement ?%SPEECH_OFF%Vous hausserez les épaules et vous tournerez vers les %companyname%.%SPEECH_ON%S\'ils veulent mourir, soit. Aux armes, messieurs !%SPEECH_OFF% | %randombrother% vient vers vous et pointe les portes de %objective%.%SPEECH_ON%Regardez, monsieur.%SPEECH_OFF%Vous observez les portes s\'ouvrir lentement. Un groupe d\'hommes en sort en titubant. Ils ne portent pas de drapeau blanc, mais plutôt les sigles de leurs familles. Vous courez vers %commander% et l\'informez que les défenseurs s\'aventurent dehors. Il hoche la tête.%SPEECH_ON%Je savais qu\'ils étaient résilients, mais c\'est juste pathétique. Aucun homme ne devrait mourir de manière aussi absurde.%SPEECH_OFF%Vous retenez presque votre langue et partez préparer les hommes de %companyname% à la bataille.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Mettons fin à cela !",
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
			Text = "[img]gfx/ui/events/event_22.png[/img] Incroyablement, les défenseurs épuisés de %objective% ont gagné ! Vous vous retirez alors que le siège s\'effondre.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Le siège a échoué.",
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
			Text = "[img]gfx/ui/events/event_31.png[/img]{Les défenseurs de %objective% ont été anéantis et les fortifications laissées grandes ouvertes. Vous et %commander% traversez les portes ouvertes pour trouver des cadavres, des débris et des animaux abattus partout, des signes sanglants de désespoir. Le commandant hoche la tête et vous tape sur l\'épaule.%SPEECH_ON%Bon travail, mercenaire. Vous devriez retourner maintenant chez %employer% et lui annoncer la nouvelle.%SPEECH_OFF% | La bataille est terminée, les défenseurs de %objective% complètement vaincus et leur fort laissé grand ouvert à la prise. %commander% vous remercie pour vos services avant de libérer les services des %companyname% du champ de bataille. Vous devriez maintenant aller voir un %employer% très heureux. | C\'était un effort plein d\'ardeur de la part des défenseurs de %objective%, mais s\'ils voulaient tenter quelque chose comme ça, ils auraient dû le faire il y a des semaines, lorsque leurs forces correspondaient à leur héroïsme. Peu importe maintenant. Un homme mort affamé ressemble beaucoup à un homme mort bien nourri et, avec assez de temps, ils se ressemblent tous.\n\n %commander% vient vous dire que les services de %companyname% ne sont plus nécessaires. Vous êtes d\'accord et devriez retourner chez %employer% pour le paiement. | S\'aventurer dehors lorsque l\'on est affamé et assiégé par un mauvais leadership n\'est jamais la meilleure des idées. Vous n\'êtes pas sûr que %commander% aurait accordé la clémence aux défenseurs de %objective% s\'ils s\'étaient rendus. Tels qu\'ils sont maintenant, ils sont tous morts dans la boue, et le monde dans lequel ils se sont rendus a depuis longtemps disparu. Vous rassemblez les hommes de %companyname% et leur ordonnez de se préparer pour le retour chez %employer%. La paie sera bien douce après cette journée. | Avec les défenseurs de %objective% écartés, vous et %commander% entrez dans les fortifications. Il y a une raison pour laquelle les hommes étaient si désespérés : les conditions sont absolument déplorables. Des hommes morts ont été dépouillés et entassés dans un coin. Une broche tient les restes cuits de ce qui aurait pu être un cochon, mais il est difficile de le dire car ils ont tout simplement consommé chaque morceau de cet animal. Un homme pendu balance depuis l\'une des tours. Ils avaient cloué une planche à sa poitrine avec \'cannibale\' écrit dessus, probablement écrit avec l\'utilisation de son propre sang.\n\n %commander% rit.%SPEECH_ON%On dirait une vraie fête ici, n\'est-ce pas ? Souvenez-vous de cette scène la prochaine fois qu\'un lieutenant belliqueux avec une idée fixe vous dira de continuer à tenir bon.%SPEECH_OFF% | Les %companyname% et l\'armée de %commander% ont définitivement vaincu les défenseurs qui sortaient de %objective%. Avec les fortifications laissées libres, les hommes de %commander% les prennent rapidement en charge. Le commandant lui-même vous dit d\'aller voir %employer% pour le paiement. | Les défenseurs de %objective% sont morts sur un champ de bataille, mais c\'était plutôt un champ de clémence. Derrière les murs de leur fort, il ne reste presque rien de valeur et, en particulier, une absence totale de nourriture. On dirait que le monde qui existait derrière les murs n\'a même jamais connu la nourriture, les défenseurs ayant tellement nettoyé l\'endroit. Vous êtes sûr que de simples mentions de nourriture étaient un crime, car même un mot torturé par une saveur serait comme un fouet sur l\'estomac grognant d\'un homme. %commander% vient à vos côtés et rit.%SPEECH_ON%Je pensais savoir ce que c\'était d\'avoir faim, mais j\'avais toujours une solution, vous savez ? Je n\'ai jamais eu faim sans espoir de le résoudre. Quelle chose horrible. Mais encore une fois, ils l\'ont résolu, n\'est-ce pas ?%SPEECH_OFF%Vous hochez la tête alors que l\'homme rit de son humour sombre.%SPEECH_ON%Vous avez fait du bon travail, mercenaire. Allez, assurez-vous que %employer% vous paie bien.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "%objective% est tombé !",
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
			Text = "[img]gfx/ui/events/event_53.png[/img]{Quelques-uns de vos hommes ont réussi à capturer certains des défenseurs de %objective%. Ils se tiennent là, regroupés, entourés par les armes de votre mercenaire. Certains tremblent dans leurs bottes. Un n\'a même pas de bottes. Un autre a des taches sur son pantalon. %randombrother% demande ce qu\'il faut faire d\'eux. | %randombrother% signale que quelques défenseurs de %objective% ont été capturés. Vous allez trouver un groupe d\'hommes regroupés, enlacés dans une étreinte circulaire, mais la tête baissée. L\'un appelle.%SPEECH_ON%S\'il vous plaît, ne nous tuez pas ! Nous faisions simplement ce que l\'on nous disait, tout comme vous !%SPEECH_OFF% | Vos hommes ont réussi à capturer quelques-uns des défenseurs de %objective%. Ils ont été rassemblés, dépouillés jusqu\'à leur pantalon, et ordonnés de se coucher dans la boue. %randombrother% demande ce qu\'il faut faire d\'eux.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Laissez-les partir. %rivalhouse% pourrait le prendre comme un signe de bonne foi.",
					function getResult()
					{
						return "PrisonersLetGo";
					}

				},
				{
					Text = "Ils peuvent valoir quelque chose. Emmenez-les en tant que prisonniers auprès de %commander%.",
					function getResult()
					{
						return "PrisonersSold";
					}

				},
				{
					Text = "Il vaut mieux les tuer maintenant que de les affronter à nouveau sur le champ de bataille dans les jours à venir.",
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
			Text =  "[img]gfx/ui/events/event_53.png[/img]{Les prisonniers ne vous sont d\'aucune utilité, ni à personne d\'autre. Vous les relâchez, espérant ne pas regretter cette décision. | Vous relâchez les prisonniers. Ils pleurent en vous remerciant, mais vous espérez simplement que ce n\'était pas une erreur. | Vous laissez partir les prisonniers. Ils vous remercient personnellement avant de partir, en espérant ne jamais les revoir.}",
			Image = "",
			List = [],
			Options = [
				{
					Text =  "Assez de mort pour aujourd\'hui.",
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
			Text = "[img]gfx/ui/events/event_53.png[/img]{Vous hochez la tête devant %randombrother%.%SPEECH_ON%Tuez-les tous.%SPEECH_OFF%Les prisonniers se lèvent, mais il n\'y a pas d\'échappatoire à la clôture de leurs mondes. Ils sont massacrés morceau par morceau. | Ces hommes enchaînés ne vous sont d\'aucune utilité, mais il est fort probable qu\'ils reviendront se battre un autre jour en hommes libres. Vous ordonnez leur exécution, une commande exécutée dans une frénésie de supplications et d\'égorgeages de gorge. | Dans des guerres comme celle-ci, il n\'y a pas de nourriture pour héberger autant de prisonniers, et il n\'y a pas d\'utilité pour eux tant que vous êtes toujours en territoire ennemi. Mais si vous les relâchez, il est très probable qu\'ils lèveront à nouveau leurs épées contre vous un autre jour.\n\n Avec cela en tête, vous ordonnez leur exécution. Les mots de protestation sont de courte durée, s\'estompant dans le gargouillis des gorges égorgées, coupées et hachées.}",
			Image = "",
			List = [],
			Options = [
				{
					Text =  "Passons à des choses plus importantes...",
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
			Text =  "[img]gfx/ui/events/event_53.png[/img]{Vous amenez les prisonniers à %commander%. Les hommes sont alignés et le commandant marche de haut en bas de leur disposition.%SPEECH_ON%Celui-ci. Celui-ci. Lui. Et lui. Tuez les autres.%SPEECH_OFF%Quelques chanceux, qui se trouvent coïncider avec les plus grands et les plus utiles du groupe, sont tirés vers l\'avant. Les autres sont sommairement tués avec des lances à travers la poitrine. %commander% vous remet quelques couronnes.%SPEECH_ON%Merci de les avoir attrapés. Ils seront mis à un bon travail, dur.%SPEECH_OFF% | Les prisonniers sont emmenés à %commander%. Il ordonne aux hommes d\'être enchaînés et de se voir confier un travail pénible. Le commandant vous paie une somme décente pour le butin.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Passons à des choses plus importantes...",
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
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]250[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous rapportez à %employer% que %objective% a été prise et est désormais sous contrôle. L\'homme cache un sourire derrière sa main, gardant une certaine prestance comme si la noblesse ne devait pas s\'abaisser à l\'excitation non professionnelle du profane. Il se contente de hocher la tête comme si cette nouvelle était attendue.%SPEECH_ON%Bien. Bien. Bien sûr.%SPEECH_OFF%L\'homme claque des doigts et un serviteur vous remet une bourse contenant %reward_completion% couronnes. | Entrer dans la pièce de %employer% instaure le silence parmi un groupe de commandants, lieutenants et le noble lui-même. Il se redresse.%SPEECH_ON%Mes oiseaux ont déjà signalé la capture de %objective%. Votre paiement est à l\'extérieur.%SPEECH_OFF%Les dirigeants ne vous remercient guère, bien que %reward_completion% couronnes soient plus que suffisantes comme remerciement à vos yeux. | %employer% vous accueille dans sa salle de guerre. Un groupe de commandants traîne autour d\'une carte sur une table. Vous les regardez déplacer l\'un de leurs jetons sur %objective%. %employer% sourit.%SPEECH_ON%Ces hommes ne laisseront peut-être pas échapper un mot, mais nous sommes très satisfaits du travail que vous avez accompli. Les histoires que mes espions m\'ont apportées m\'ont assuré que je n\'ai pas fait un mauvais investissement avec des gens comme vous.%SPEECH_OFF%Le noble vous remet personnellement une bourse contenant %reward_completion% couronnes. | La pièce de %employer% est un foyer d\'affaires. Les commandants courent de ça et là, se disputant les uns avec les autres, peu importe de quel côté de la pièce ils se trouvent ou à quelle distance, tandis que les serviteurs se faufilent pour s\'assurer qu\'ils sont correctement nourris. La guerre n\'est pas le moment de gaspiller de l\'énergie pour des choses pitoyables comme ramasser votre propre manteau ou cuisiner des repas. Vous êtes surpris qu\'il n\'y ait pas de serviteurs fourrant des bouchées dans leur bouche entre les disputes.\n\nCependant, %employer% est simplement à l\'écart. Il feuillette un livre comme s\'il était seul dans un jardin joyeux. Il lève les yeux. Jette un coup d\'œil à ses généraux, puis à vous.%SPEECH_ON%Bien joué. Votre paiement.%SPEECH_OFF%Un coffre est lentement poussé dans votre direction. %reward_completion% couronnes y reposent. | Un serviteur vous empêche d\'entrer dans la pièce de %employer%. Il explique.%SPEECH_ON%On m\'a demandé de vous rencontrer ici avec cette bourse de %reward_completion% couronnes.%SPEECH_OFF%Vous prenez la bourse et hochez la tête. | Vous essayez d\'entrer dans la pièce de %employer%, mais un garde vous arrête.%SPEECH_ON%Nobles seulement.%SPEECH_OFF%Repoussant la hallebarde du garde hors de votre visage, vous déclarez que vous avez des affaires avec %employer%. Le garde abaisse à nouveau la hallebarde.%SPEECH_ON%Nobles seulement.%SPEECH_OFF%Juste au moment où vous alliez commencer une dispute, un serviteur sort de la pièce avec une grande bourse. Il voit le sigle du %companyname% et vous remet une bourse.%SPEECH_ON%Vos %reward_completion% couronnes. J\'ai bien peur que mon seigneur et ses commandants soient occupés.%SPEECH_OFF%Et comme ça, le serviteur disparaît. Le garde vous regarde.%SPEECH_ON%Nobles seulement.%SPEECH_OFF% | La récompense pour avoir aidé à conquérir %objective% est de %reward_completion% couronnes et une porte claquée devant vous. %employer% est trop occupé à se disputer avec ses commandants pour vous féliciter davantage que cela. | L\'un des commandants de %employer% vous rencontre dans un vestibule. Il a un serviteur avec lui qui transporte une grande bourse. Le commandant parle.%SPEECH_ON%Ah, le %companyname%. Vous avez peu d\'honneur dans votre vocation, mercenaire. Vous devriez être un vrai homme et combattre avec les nobles. Il y a une grande honneur dans ce que nous faisons. Pourquoi ne pas nous rejoindre?%SPEECH_OFF%La grande bourse de %reward_completion% couronnes est placée entre vos mains. Vous souriez au commandant, un reflet doré bordant vos dents.%SPEECH_ON%Oui, pourquoi?%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective% est tombé."
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
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Quel désastre. La bataille est perdue et vous vous repliez pour épargner les hommes qu\'il vous reste. %objective% ne tombera pas de sitôt.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Que cet endroit maudit!",
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
			Text = "[img]gfx/ui/events/event_36.png[/img]{Le passage du temps en tant que concept semble vous avoir échappé. Malgré votre absence, le siège a tenté de se poursuivre, mais a finalement échoué sans l\'aide attendue de la %companyname%. Ne vous embêtez pas à retourner chez %employer%. | Vous avez été engagé pour aider au siège, pas pour l\'abandonner. Sans la %companyname% à leurs côtés, les soldats devront probablement se retirer du champ de bataille. | Vous vous êtes éloigné trop loin du siège ! Sans votre aide, les assaillants ont dû battre en retraite et %objective% a été épargné de la conquête de %employer%. Étant donné que c\'était ce pour quoi vous avez été engagé pour aider à accomplir, il vaut probablement mieux que vous ne Retournez pas chez le noble.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "C\'est vrai, il y avait ce siège...",
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
		party.setDescription("Soldats professionnels au service des seigneurs locaux.");
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
		party.setDescription("Une caravane accompagnée d'escortes armées transportant des provisions, des fournitures et du matériel entre les colonies.");
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
			party.setDescription("Soldats professionnels au service des seigneurs locaux.");
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


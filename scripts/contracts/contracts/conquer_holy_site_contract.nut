this.conquer_holy_site_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.conquer_holy_site";
		this.m.Name = "Conquer Holy Site";
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

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();
		local target;
		local targetIndex = 0;
		local closestDist = 9000;
		local myTile = this.m.Home.getTile();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && !this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					local d = myTile.getDistanceTo(v.getTile());

					if (d < closestDist)
					{
						target = v;
						targetIndex = i;
						closestDist = d;
					}
				}
			}
		}

		this.m.Destination = this.WeakTableRef(target);
		this.m.Destination.setVisited(true);
		local b = -1;

		do
		{
			local r = this.Math.rand(0, this.Const.PlayerBanners.len() - 1);

			if (this.World.Assets.getBanner() != this.Const.PlayerBanners[r])
			{
				b = this.Const.PlayerBanners[r];
				break;
			}
		}
		while (b < 0);

		this.m.Payment.Pool = 1350 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("DestinationIndex", targetIndex);
		this.m.Flags.set("MercenaryPay", this.beautifyNumber(this.m.Payment.Pool * 0.5));
		this.m.Flags.set("Mercenary", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.m.Flags.set("MercenaryCompany", this.Const.Strings.MercenaryCompanyNames[this.Math.rand(0, this.Const.Strings.MercenaryCompanyNames.len() - 1)]);
		this.m.Flags.set("MercenaryBanner", b);
		this.m.Flags.set("Commander", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.m.Flags.set("EnemyID", target.getFaction());
		this.m.Flags.set("MapSeed", this.Time.getRealTime());
		this.m.Flags.set("OppositionSeed", this.Time.getRealTime());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Reprenez %holysite% des païens du Sud",
					"Détruisez ou déroutez les régiments ennemis dans les alentours"
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
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					this.Flags.set("IsAlliedArmy", true);
				}
				else if (r <= 40)
				{
					this.Flags.set("IsSallyForth", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsMercenaries", true);
				}
				else if (r <= 80)
				{
					this.Flags.set("IsCounterAttack", true);
				}

				if (this.Contract.getDifficultyMult() >= 1.15)
				{
					this.Contract.spawnEnemy();
				}
				else if (this.Contract.getDifficultyMult() <= 0.85)
				{
					local entities = this.World.getAllEntitiesAtPos(this.Contract.m.Destination.getPos(), 1.0);

					foreach( e in entities )
					{
						if (e.isParty())
						{
							e.getController().clearOrders();
						}
					}
				}

				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(-99.0, "Took sides in the war");
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnEnterCallback(this.onDestinationAttacked.bindenv(this));
				}

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onCounterAttack.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsCounterAttack"))
					{
						this.Contract.setScreen("CounterAttack1");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Contract.isEnemyPartyNear(this.Contract.m.Destination, 400.0))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCounterAttack( _dest, _isPlayerInitiated )
			{
				if (this.Flags.get("IsCounterAttackDefend") && this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.LocationTemplate.ShiftX = -4;
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.MapSeed = this.Flags.getAsInt("MapSeed");
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onDestinationAttacked( _dest )
			{
				if (this.Flags.getAsInt("OppositionSeed") != 0)
				{
					this.Math.seedRandom(this.Flags.getAsInt("OppositionSeed"));
				}

				if (this.Flags.get("IsVictory") || this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					return;
				}
				else if (this.Flags.get("IsAlliedArmy"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("AlliedArmy");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
						p.CombatID = "ConquerHolySite";
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner(),
							this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, true, true, true);
					}
				}
				else if (this.Flags.get("IsSallyForth"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("SallyForth");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "ConquerHolySite";
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else if (this.Flags.get("IsMercenaries"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Mercenaries1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
						p.CombatID = "ConquerHolySite";
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, (130 + (this.Flags.get("MercenariesAsAllies") ? 30 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];

						if (this.Flags.get("MercenariesAsAllies"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.Flags.get("MercenaryBanner"));
						}
						else
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
							p.EnemyBanners.push(this.Flags.get("MercenaryBanner"));
						}

						this.World.Contracts.startScriptedCombat(p, true, true, true);
					}
				}
				else if (this.Flags.get("IsCounterAttack") && this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsCounterAttackDefend"))
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
						p.LocationTemplate.ShiftX = -2;
						p.CombatID = "ConquerHolySiteCounterAttack";
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "ConquerHolySiteCounterAttack";
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Attacking");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.OwnedByFaction = this.Flags.get("EnemyID");
					p.CombatID = "ConquerHolySite";
					p.MapSeed = this.Flags.getAsInt("MapSeed");
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.Music = this.Const.Music.OrientalCityStateTracks;
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, (this.Flags.get("IsCounterAttack") ? 110 : 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.AllyBanners = [
						this.World.Assets.getBanner()
					];
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];
					this.World.Contracts.startScriptedCombat(p, true, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "ConquerHolySiteCounterAttack")
				{
					this.Flags.set("IsCounterAttack", false);
					this.Flags.set("IsVictory", true);
				}
				else if (_combatID == "ConquerHolySite")
				{
					this.Flags.set("IsVictory", true);
					this.Flags.set("OppositionSeed", this.Time.getRealTime());
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "ConquerHolySite" || _combatID == "ConquerHolySiteCounterAttack")
				{
					this.Flags.set("IsFailure", true);
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
				this.Contract.m.Home.getSprite("selection").Visible = true;

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnEnterCallback(null);
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% is found surrounded by a congress of holy men, each seemingly more knowledgeable than the last about the intent and desires of the old gods. But there is a clear line of thought arrowing through the conversation: the southerners have taken %holysite% and it must be recovered. The lord points you out.%SPEECH_ON%The %companyname% shall endeavor to end this nightmare!%SPEECH_OFF%Pushing the priors out of the way, %employer% nears and his voice lowers.%SPEECH_ON%For the right price, of course. I\'ve few men to spare, but the holy lands are of great importance to the people and to myself. You must go there and drive out the heathens so that the old gods shall not leave us behind, our failures and all.%SPEECH_OFF% | The door to %employer%\'s room flies open and a line of holy men make their leave. A couple pause to glare at you, not a one seemingly happy by your presence. %employer% waves you in.%SPEECH_ON%Do not concern yourself with their pitiful, accusative eyes, sellsword. %holysite% has been lost to the southerners and it has put a whole faggot of sticks up their collective arses. Not that I blame them, even a grouser such as I carries a soft spot for the sacred lands. These priors simply wish to have %holysite% reclaimed by proper royal colors, but alas, I\'ve committed my soldiers elsewhere. You, however, can do the job just fine, for proper coin, aye?%SPEECH_OFF% | %SPEECH_ON%The old gods are no doubt looking upon this room, sellsword.%SPEECH_OFF%%employer% swirls his chalice around, the wine sloshing along the rim and leaving a purple glisten behind.%SPEECH_ON%Southerners have taken %holysite% and no doubt profaned it entirely. I\'d sooner have a dog find a piss spot on the sacred lands than watch one of those southern shits stand in the supposed sublimity of their god. What was it, the Gilder? What a load of horse shit. Go there and kill them all and return %holysite% to proper standing.%SPEECH_OFF% | %employer% is found in his garden and he\'s almost aggressively alone. Men and women autour de fenceline seem scared to even glance his way. Not that care: you freely walk in. He\'s staring at a kicked ant pile, the insects scurrying around to rebuild. The nobleman sighs.%SPEECH_ON%I sometimes wonder if the old gods look upon us in such a manner.%SPEECH_OFF%You remark that you really only notice ants when they bite. The nobleman gets to his feet.%SPEECH_ON%You should know they\'re good for the garden, sellsword. If they bite, I surmise it is without passion. It is only them doing what they know to do, just as they know to rebuild when I kick their home over. Just as it is that when I learned the southern roaches had impermanently trespassed upon %holysite% that I, by the way of the old gods, knew they must be rooted out and destroyed.%SPEECH_OFF%You half-expect the nobleman to compare you to an ant, but instead he simply offers you a large chunk of crowns to get to the holy lands and break its occupants.%SPEECH_ON%You would be like a wasp in the garden, perhaps.%SPEECH_OFF%The nobleman says, to which you respond with a stoic nod. | %SPEECH_ON%I\'m not one for pottery, sellsword, so when I say the southern farks are lower than an arsemonger\'s moonlit depravity, you should know that their trespass alone has compelled me to the way of the minstrel.%SPEECH_OFF%You think to inform %employer% that he may mean \'poetry\', but in a way he is breaking pots here. Besides, he no doubt sees you as someone with clay feet.%SPEECH_ON%The savages have taken %holysite% and rumors are they\'ve even killed all \'non-believers.\' My soldiers are spread out, the fields of battle plentiful as they are. But you are available. And you\'re a greedy fark, sure, but I also know the %companyname% is the exact sort of might and main we need to get those bastards out of the holy lands.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{I trust you\'ll pay amply for an assault like this. | We\'re ready to do our part. | Let\'s talk some more about payment.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | It\'s too long a march. | We have more pressing business to attend to. | On est demandé autre part.}",
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
			ID = "Attacking",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{The southerners have posted themselves in and around %holysite%. With time on their side, they\'ve erected a sturdy defense, but nothing the %companyname% can\'t handle. You draw out your sword and prepare your men for the attack.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Begin the assault!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AlliedArmy",
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%holysite% is already under siege by men carrying %employerfaction%\'s banner. As you come closer, a man meets you half way. He raises his hand and then puts it to his belt.%SPEECH_ON%I got word they were sending a mercenary and you appear to be it. The %companyname%, was it? Well, I am %commander%, a lieutenant of %employer%\'s. I will be joining you in rooting out these desert rats. I fear, as I\'m sure you do, that the old gods will be punish us all if we do not see to this task posthaste.%SPEECH_OFF%The lieutenant spits and runs a hand across his grizzled face.%SPEECH_ON%Well. Let the old gods see us as truly as we are, and we shall butcher these dune goons in a manner most righteous.%SPEECH_OFF% | %holysite% is already under siege by men carrying %employerfaction%\'s banner. The leader steps forward and speaks loudly.%SPEECH_ON%The %companyname%, my name is %commander%, lieutenant to %employer%\'s field army. I have come to join you, or shall I say you will be joining me, in going to %holysite% and ripping out those southern scum from every inch of the place. For the old gods watch over us all, even the likes of you sellswords, and failure today will surely doom us to every hell there is.%SPEECH_OFF%Right. You just want to be sure, help or not, that %employer% will pay you the full amount of that which will be owed. | %holysite% is already under siege by men carrying %employerfaction%\'s banner. It\'s seemingly a congress of holy men and soldiers alike, and the lieutenant leading the troop brandishes his sword before swiftly aiming it toward %holysite%.%SPEECH_ON%The southern lickspittles will either leave, or we will convert them to the hells of the old gods by the grace of our steel. There is no other choice in this matter. Come then, mercenaries!%SPEECH_OFF%It appears the %companyname% will have some help in this endeavor, though you fully expect to still see the entirety of the reward promised.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Begin the assault!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "SallyForth",
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{%holysite%\'s defenders have received reinforcements! Thankfully, there is a silver lining: the additional arms has given them the confidence to leave the natural defenses of the holy site and to approach you in the open field. | You\'re surprised to see the defenders leaving %holysite% and trekking across the open field. A quick scouting report relays that they received reinforcements sometime in the past few days and are emboldened by numbers alone. On one hand, their deep ranks are a bit unsettling, but on the other hand facing them on even ground will be much easier. Though by your honest estimation it is their mistake to face the %companyname% at all.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A field battle, then.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries1",
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_134.png[/img]{As %holysite% draws into view, a man who looks almost eerily similar to you approaches. He\'s got a paymaster and a couple of sellswords at his side.%SPEECH_ON%Evenin\', captain. I am %mercenary% of the %mercenarycompany%. I came to these lands in search of crown, just as you have. Now, I wager that fat nobleman wetted his pen in a mighty sound contract for you and your men, but what say you pay me %pay% crowns and I\'ll help you in this little endeavor? Unless, of course, you want me to offer my services to the other side over yonder.%SPEECH_OFF% | You are approached by a group of men, one of which whose gait and constitution alike seem strangely reminiscent to your own. He announces himself as %mercenary%, captain of the %mercenarycompany%.%SPEECH_ON%I thought %employer% might send his professional army to see to the holy site\'s change of hands. I will admit to you, captain, that I helped them dune loons take over this prestigious monument in the first place. However, for %pay% crowns, I\'m willing to help your side take it back. As a fellow mercenary, I\'m sure you can see how this would be a good deal for all involved.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [],
			function start()
			{
				if (this.World.Assets.getMoney() > this.Flags.get("MercenaryPay"))
				{
					this.Options.push({
						Text = "You\'re hired!",
						function getResult()
						{
							return "Mercenaries2";
						}

					});
				}
				else
				{
					this.Options.push({
						Text = "I\'m afraid we don\'t have that kind of coin.",
						function getResult()
						{
							return "Mercenaries3";
						}

					});
				}

				this.Options.push({
					Text = "Find your own work, %mercenary%. We don\'t need help.",
					function getResult()
					{
						return "Mercenaries3";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries2",
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_134.png[/img]{The captain grins and slaps your shoulder.%SPEECH_ON%Aaahhh, there it is! There it is, the noble sellsword spirit! Aye, commander of the %companyname%, let us venture forth, for a short time, and do battle together, also for a short time!%SPEECH_OFF% | With the deal made, the captain of the mercenary company sidles up next to you. Almost uncomfortably close, and assuredly within range of his breath, which is unappreciated.%SPEECH_ON%You know, men like us, fellas like us, pals, we\'re pals, right? Pals like us. We gotta stick together. And for this here battle, we\'ll be sticking together.%SPEECH_OFF%He nods and slugs one into your shoulder.%SPEECH_ON%After the fight, well, I hope we can be buddies again sometime, you know?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Begin the assault!",
					function getResult()
					{
						this.Flags.set("MercenariesAsAllies", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("MercenaryPay"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("MercenaryPay") + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries3",
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_134.png[/img]{%SPEECH_START%That\'s a shame.%SPEECH_OFF%%mercenary% says as he quickly jaunts back to the ranks of the %mercenarycompany%. He keeps backing up right into the soldiers defending %holysite%. His arms are wide and fanning, as though he were swimming against a current.%SPEECH_ON%A damn shame, I say! Well, captain of the %companyname%, let us see which side purchased the finer sellsword, yeah?%SPEECH_OFF%The mercenary draws his weapon, as do the southern soldiers at %holysite% behind them. Naturally, you draw your weapon as well. It is time to fight. | %SPEECH_ON%Aye, aye, I see. Well. I didn\'t expect much. I am, after all, also a seller of the sword. And right now...%SPEECH_OFF%He paces backward to his company, and his company to the ranks of the southern soldiers protecting %holysite%.%SPEECH_ON%Right now, the south proves to be the highest bidder.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll meet again on the battlefield. Begin the assault!",
					function getResult()
					{
						this.Flags.set("MercenariesAsAllies", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_164.png[/img]{The battle is over, but a golden gleam in the distance catches your eye. As you stare at the horizon, a troop of southerners appears, their bright appearance no doubt meant to be seen. It\'s a counter-attack! | As you sheathe your blade %randombrother% calls out. He points at the horizon. A line of southerners is on the approach, their armor glinting, their gait swaggering. The counter-attackers wish to be seen, and no doubt intend to be victorious...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll make a stand defending the site!",
					function getResult()
					{
						return "CounterAttack2";
					}

				},
				{
					Text = "We\'ll meet them in the open!",
					function getResult()
					{
						return "CounterAttack3";
					}

				},
				{
					Text = "We can\'t take another fight. Retreat!",
					function getResult()
					{
						return "Failure";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_164.png[/img]{The southerners\' approach is ever steady.%SPEECH_ON%Roaches, they just never end.%SPEECH_OFF%You look over to see %randombrother% shaking his head. He lifts up his boot and flicks a bug off the toe. He puts his foot down and nods back toward the attackers.%SPEECH_ON%Don\'t worry, captain, we\'ll have %holysite%\'s defenses in tip-top shape for them savage bastards.%SPEECH_OFF% | You order the men to defend the site.%SPEECH_ON%Making a stand in %holysite%, what a time to be alive.%SPEECH_OFF%%randombrother% says. You nod and tell him you hope it will one day be a memory for him. He laughs and asks how he could ever forget. Another sellsword chimes in that there\'s one very certain way he can forget, but you cut him off and tell the men to pay attention to the task at hand.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rally!",
					function getResult()
					{
						this.Flags.set("IsCounterAttackDefend", true);
						this.Flags.set("IsVictory", false);
						local party = this.Contract.spawnEnemy();
						party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onCounterAttack.bindenv(this.Contract.getActiveState()));
						this.Contract.m.Target = this.WeakTableRef(party);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CounterAttack3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_164.png[/img]{The defenses don\'t look as solid as they did before. You order the %companyname% to take the field in formation where no faulty constructs will get in the way of your command. The southern lieutenant greets you.%SPEECH_ON%You profane %holysite% with blood, for this the Gilder Himself has no doubt drawn you to the field to die like proper men. What have you to say to this?%SPEECH_OFF%You draw your sword.%SPEECH_ON%Wasn\'t my blood.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
					function getResult()
					{
						this.Flags.set("IsCounterAttackDefend", false);
						this.Flags.set("IsVictory", false);
						local party = this.Contract.spawnEnemy();
						party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onCounterAttack.bindenv(this.Contract.getActiveState()));
						this.Contract.m.Target = this.WeakTableRef(party);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{As you sheath your weapon and have the company set out to collect what they can from the dead, you get the strange feeling that this is not the first time %holysite% has been home to such bloodshed. Oh well, if anyone\'s gonna be dying in their ancestor\'s footsteps you\'re glad it\'s not you. A few northern soldiers come in to secure the holy tract just as you make your leave for %employer%. | The enemy is defeated and %holysite% reclaimed. A crowd of the faithful slowly trickle in, passing by the dead so they may prostrate themselves at the holiest of spots. Not a one says thanks to you. Not that it matters, that\'s %employer%\'s job. A troop of northern soldiers passes you on your way out, each of the fighters regarding you with sneers and jeers. | With the battle over, little knots of the faithful begins to congregate in the corners of %holysite%. You don\'t know where these people even came from. They don\'t mind you, and you don\'t mind them. What matters now is that %employer% will have a huge trove of crowns awaiting your return. As soon as a few northern soldiers come by, you make your leave.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Victory!",
					function getResult()
					{
						this.Contract.m.Destination.setFaction(this.Contract.getFaction());
						this.Contract.m.Destination.setBanner(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						this.updateAchievement("NewManagement", 1, 1);
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnAlly();
			}

		});
		this.m.Screens.push({
			ID = "Failure",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{%holysite% has fallen to the southerners. One sellsword shakes his head.%SPEECH_ON%Well. I suspect they\'ll be all over the place shinin\' or shittin\'.%SPEECH_OFF%Indeed. With the sacred tracts lost, there\'ll be no reason to get back to %employer% unless you\'re interested in seeing another kind of holy spectacle.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Disaster!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to conquer a holy site");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%townname%\'s priory is flush with more peasants than you\'ve ever seen before. %employer% is outside on the steps and greets you with a hand to your shoulder.%SPEECH_ON%Welcome back, sellsword. You might be a slight git seekin\' his coin, but you carry the wrath of the old gods with you. %holysite% is with whom it belongs now.%SPEECH_OFF%The nobleman snaps his fingers a few times and a few rotund monks waddle forth carrying chests of %reward% crowns. %employer% makes his leave up the steps.%SPEECH_ON%I\'ll say a word for you to the crowd, what was your name? Ah, I\'m sure you want the company take credit. I\'ll thank the %companyname% as a whole.%SPEECH_OFF% | %employer% is looking at his battle maps.%SPEECH_ON%It\'s a mite amusing that where I send my men, I am met with failures, but when the old gods raise hell I am spurred to hire a sellsword and met with... victory. Hopefully with %holysite% back within our grasps it will be drive my men to fight as the %companyname% does. For %reward% crowns, you\'ve sent them southern shits back to the hells of their desert and encouraged the war effort as a whole. I\'d almost say I shortchanged you, sellsword. Almost.%SPEECH_OFF% | %SPEECH_ON%When the scouts returned the first thing they did was visit the priory. That\'s how I knew you were successful. I also gave them each a day in the dungeon for vacating their duties to me.%SPEECH_OFF%%employer% is sitting on a strange looking cushion, perhaps one he had somehow attained during these wars with the southerners. He swishes wine around in a goblet.%SPEECH_ON%Your %reward% crowns are awaiting outside. I have to ask, when you were down there, did you hear of anything? Perhaps whispers of the old gods? Perhaps even murmurs of this one they call, what is it, the Gilder?%SPEECH_OFF%You shake your head no. The nobleman shrugs.%SPEECH_ON%A shame. One must wonder what it takes for the gods to come to us again.%SPEECH_OFF%You tell him %reward% crowns spent in a particular direction would be a good start. The nobleman smiles cheekily and grants you this wish. | %employer% is found with a young, tanned woman clearly from the southern realms. He looks her up and down.%SPEECH_ON%The old gods sent me this, just as I\'m assuming they sent me you.%SPEECH_OFF%He fumbles his words for a second and clears his throat.%SPEECH_ON%I mean, in another way, of course. Your victories at %holysite% have invigorated the men, lifting the spell of defeat from their shoulders. The monks now have the faithful back in their flock, and with good diligence we shall prove to the old gods our worth.%SPEECH_OFF%He pushes the woman away and tries to get to his feet, but the cushion is too deep, possibly too comfortable. He stays put.%SPEECH_ON%Your %reward% crowns will be out in the hall. Send for one of my servants to come and fetch this sand-lass for prayers in the priory.%SPEECH_OFF% | You find %employer% in one of the town\'s temples, standing beneath a statue of one of the old gods.%SPEECH_ON%I\'d gotten word of your successes. The town has been elated, and the region as a whole is murmuring with delight. They won\'t speak of you, of course, they\'ll speak of me.%SPEECH_OFF%The nobleman seems quite happy with himself. He turns and pats you on the shoulder.%SPEECH_ON%I hope them southern shits didn\'t trouble you much. My lieutenants will bring your %reward% crowns. Say, do you think %holysite% is worth a visit? I\'ve never been. In fact, don\'t care to. I am blessed wherever my feet go.%SPEECH_OFF%You purse your lips as the nobleman makes his leave.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Conquered a holy site");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
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
	}

	function spawnAlly()
	{
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = ++x )
		{
			for( local y = o.Y + 4; y <= o.Y + 6; y = ++y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}
			}
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + " Company", true, this.Const.World.Spawn.Noble, 170 * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Professional soldiers in service to local lords.");
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
		local occupy = this.new("scripts/ai/world/orders/occupy_order");
		occupy.setTarget(this.m.Destination);
		occupy.setTime(10.0);
		c.addOrder(occupy);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(240.0);
		c.addOrder(guard);
		return party;
	}

	function spawnEnemy()
	{
		local cityState = this.World.FactionManager.getFaction(this.getFaction());
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = ++x )
		{
			for( local y = o.Y - 4; y <= o.Y - 3; y = ++y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}
			}
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local f = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyID"));
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "Regiment of " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 140) * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Conscripted soldiers loyal to their city state.");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 5);
		party.getLoot().Ammo = this.Math.rand(0, 30);
		local r = this.Math.rand(1, 4);

		if (r <= 2)
		{
			party.addToInventory("supplies/rice_item");
		}
		else if (r == 3)
		{
			party.addToInventory("supplies/dates_item");
		}
		else if (r == 4)
		{
			party.addToInventory("supplies/dried_lamb_item");
		}

		local c = party.getController();
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(this.m.Destination.getTile());
		c.addOrder(attack);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Destination.getTile());
		c.addOrder(move);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(999.0);
		c.addOrder(guard);
		return party;
	}

	function onPrepareVariables( _vars )
	{
		local illustrations = [
			"event_152",
			"event_154",
			"event_151"
		];
		_vars.push([
			"illustration",
			illustrations[this.m.Flags.get("DestinationIndex")]
		]);
		_vars.push([
			"holysite",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"pay",
			this.m.Flags.get("MercenaryPay")
		]);
		_vars.push([
			"employerfaction",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"mercenary",
			this.m.Flags.get("Mercenary")
		]);
		_vars.push([
			"mercenarycompany",
			this.m.Flags.get("MercenaryCompany")
		]);
		_vars.push([
			"commander",
			this.m.Flags.get("Commander")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnEnterCallback(null);
			}

			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHolyWar())
		{
			return false;
		}

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && !this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					return true;
				}
			}
		}

		return false;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && _tile.ID == this.m.Destination.getTile().ID)
		{
			return true;
		}

		return false;
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

		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
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

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});


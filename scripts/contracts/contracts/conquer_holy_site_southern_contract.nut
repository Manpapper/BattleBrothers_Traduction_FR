this.conquer_holy_site_southern_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.conquer_holy_site_southern";
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

		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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
		this.m.Flags.set("Commander", this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)]);
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
					"Reprenez %holysite% des païens du Nord",
					"Détruisez ou déroutez les régiments ennemis dans les alentours"
				];
				this.Contract.setScreen("Task");
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

				local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

				foreach( n in nobles )
				{
					if (n.getFlags().get("IsHolyWarParticipant"))
					{
						n.addPlayerRelation(-99.0, "Took sides in the war");
					}
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
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "ConquerHolySiteCounterAttack";
					p.Music = this.Const.Music.NobleTracks;
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
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, (130 + (this.Flags.get("MercenariesAsAllies") ? 30 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
					p.LocationTemplate.Template[0] = "tactical.southern_ruins";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
					p.Music = this.Const.Music.NobleTracks;
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, (this.Flags.get("IsCounterAttack") ? 110 : 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
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
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_162.png[/img]{You find %employer% behind a pile of scrolls. He is busy to the task of writing and the holy men around him are just as busy paying attention, being certain to steal away a scroll the second it has captured the Vizier\'s final utterances. The man of scribbling import finally looks up.%SPEECH_ON%We\'ve a matter of %holysite% being trespassed by northern rats. I will try and temper my feelings on the matter, as it is not the Gilder\'s way to sully emotions with shades of fury, so let me just state clearly that the presence of these savages offends the rational appetite.%SPEECH_OFF%The Vizier dunks a quill pen and returns to his writing and speaking.%SPEECH_ON%However, shall the dog bark the birds will fly. I need a dog, Crownling, and one with bite. Take your company to the holy land and root out the reprobates. If we have agreement, then %reward% crowns and the Gilder\'s gleam shall await your return.%SPEECH_OFF% | %employer% welcomes you with surprising warmth.%SPEECH_ON%I knew it true that the Gilder would bring me a man of great import, a man of serious might and main. A Crownling, sure. But a warrior? Certainly!%SPEECH_OFF%Before you can ask the nature of the business, the Vizier holds up a golden chalice with half of the cupping sliced like the rim of the moon.%SPEECH_ON%Our holiest land, %holysite%, has been taken by savage northerners. Our world is threatened with darkness, and to fend the shadow we must be propitious in our endeavors. The men of my domain are plenty, but the lands beneath the Gilder\'s eye stretch far. I need soldiers such as yourself to help claim %holysite%. For it is a part of this earth which the Gilder is suzerain, and the Gilder pays us all: %reward% crowns for the task\'s completion. Do we have an arrangement?%SPEECH_OFF% | In a rare sight, you find %employer% prostrated beneath the sublimity of a glinting, shiny emblem shaped like the sun. He whispers a few words to himself then rises, then whispers again, cleans his fingertips one at a time, and turns to you.%SPEECH_ON%Whilst my troops make propitious advances elsewhere, %holysite% has been left undefended. In my wont to win this war, I have left the door open for the barbarian northerners to take it over. I request, face to face with you, a parcel of outside help. The Gilder will provide us all the gilded path, Crownling, and you are not outside His generosity. Through my hand, you shall have %reward% crowns if you take back %holysite%!%SPEECH_OFF% | A golden goblet scatters across the marbled floors and the wine sprays every which way. The Vizier yells at you, a mix of anger and need.%SPEECH_ON%Finally, someone who can be of assistance!%SPEECH_OFF%He waves off a few helpers and even a few of what appear to be his own lieutenants.%SPEECH_ON%Crownling, %holysite% has been conquered by the northern filth. I have wept at the thought of them ransacking it, and I shall weep again for every day they sully one of the Gilder\'s footprints. %reward% crowns. That is how much shall be procured and placed into your pockets. A hefty amount for you, surely, but it is true what they say, that for some the way of the gilded path is perhaps more literal than for others.%SPEECH_OFF% | %employer% is surrounded by silk-laden men. One carries fireflies in a hooded cage, the dull insect-lights winking here and there. The other has a cage with the remains of a dead bird, stripped entirely to the bone save for two feathers which seem to replicate the entirety of what were once its wings. Seeing you, the Vizier steps out between these men as one would step between the unmovable pillars of a temple.%SPEECH_ON%Crownling, you are here! My scouts have reported that we have taken a step back in this war against the dogs of the north. %holysite% has been captured and, per the Gilder\'s whispers, I must have it returned to us. Not only for my domain, but so that His sublimity may bear the slightest shade. You will be given %reward% crowns for this venture, a heavy sum for a heavy task, yes!%SPEECH_OFF% | Ordinarily ordained in opulence and surrounded by familiar profligates, you find %employer% kneeled and dressed in somewhat modest attire. He\'s wearing a headdress with corded black around his pate. The socially muted Vizier speaks to you calmly.%SPEECH_ON%Northern heathens have taken %holysite% from our lands. I do not blame them for their actions, they know not what it is they do. By my honest hands, the Gilder shall know my faults. But failure does not mean surrender. I need you to Voyagez jusqu\'à the holy grounds and return it to our realm. For this, you shall have %reward% crowns placed within your coffers.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{As the Vizier believed, the northerners have taken up positions in and around %holysite%. Most of the riffraff religious folk have long since departed, leaving only the %companyname% and the opposing force. You draw out your sword and order the men to make the attack.}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{As you near %holysite%, a man rises seemingly from the ground itself. Startled, you draw your weapon but the man reveals himself to be a camouflaged commander of %employer%.%SPEECH_ON%Easy, Crownling, you\'ll have your coin yet. The Vizier\'s birds have told my outfit of your approach and I must say, you\'re a bit late. I know this isn\'t your war, but, well, I suppose this is no time for admonishment. Let us reclaim the holy lands for the Gilder, and may both our paths forward be ever gilded by his shine.%SPEECH_OFF% | %holysite% is in sight when a man seemingly appears out of the ground. He asks if you are the commander of the %companyname%, and a slight pause must have given him the answer for he speaks straight away.%SPEECH_ON%Yes, of course you are. I am %commander%, lieutenant of %employer%. The Vizier\'s birds told you may come. You may be chasing coin, Crownling, but if we are victorious today the Gilder will shine brightly upon your morrow\'s path!%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_134.png[/img]{As %holysite% draws into view, a man who looks almost eerily similar to you approaches. He\'s got a paymaster and a couple of sellswords at his side.%SPEECH_ON%Evenin\', captain. I am %mercenary% of the %mercenarycompany%. I came to these lands in search of crown, just as you have. Now, I wager the Vizier wetted his pen in a sound contract for you and your men, but what say you pay me %pay% crowns and I\'ll help you in this little endeavor?%SPEECH_OFF% | You are approached by a group of men, one of which whose gait and constitution alike seem strangely reminiscent to your own. He announces himself as %mercenary%, captain of the %mercenarycompany%.%SPEECH_ON%I thought the Vizier might send his professional army to see to the holy site\'s change of hands. I will admit to you, captain, that I helped the northerners take over this prestigious monument in the first place. However, for %pay% crowns, I\'m willing to help your side take it back. As a fellow mercenary, I\'m sure you can see how this would be a good deal for all involved.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_134.png[/img]{The captain grins and slaps your shoulder.%SPEECH_ON%Aaahhh, there it is! There it is, the noble sellsword spirit! Aye, commander of the %companyname%, let us venture forth, for a short time, and do battle together, also for a short time!%SPEECH_OFF% | With the deal made, the captain of the mercenary company sidles up next to you. Almost uncomfortably close, and assuredly within range of his breath which is unappreciated.%SPEECH_ON%You know, men like us, fellas like us, pals, we\'re pals, right? Pals like us. We gotta stick together. And for this here battle, we\'ll be sticking together.%SPEECH_OFF%He nods and slugs one into your shoulder.%SPEECH_ON%After the fight, well, I hope we can be buddies again sometime, you know?%SPEECH_OFF%}",
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
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("MercenaryPay") + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Mercenaries3",
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_134.png[/img]{%SPEECH_START%That\'s a shame.%SPEECH_OFF%%mercenary% says as he quickly jaunts back to the ranks of the %mercenarycompany%. He keeps backing up right into the soldiers defending %holysite%. His arms are wide and fanning, as though he were swimming against a current.%SPEECH_ON%A damn shame, I say! Well, captain of the %companyname%, let us see which side purchased the finer sellsword, yeah?%SPEECH_OFF%The mercenary draws his weapon, as do the soldiers of the north around him, and you do the same. It is time to fight. | %SPEECH_ON%Aye, aye, I see. Well. I didn\'t expect much. I am, after all, also a seller of the sword. And right now...%SPEECH_OFF%He paces backward to his company, and his company to the ranks of the northern soldiers protecting %holysite%.%SPEECH_ON%Right now, the north proves to be the highest bidder.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{The battle is over, but there\'s a glint and gleam of armor winking in the distance. You slim your eyes and focus on the approaching silhouettes. Perhaps they are the faithful come to fill the holy site and - no, they\'re northeners! It\'s a counter-attack! | As you sheathe your blade an arrow zips overhead and hits the sand with a muted spiff. You look toward the source and see a young and nervous archer being slapped upside the head, and beside this man is an entire contingent of northerners! It\'s a counter-attack!}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{%SPEECH_START%Just more northerners.%SPEECH_OFF%%randombrother% says. You nod and respond.%SPEECH_ON%More logs for the Gilder\'s fire.%SPEECH_OFF%The sellsword mentions the Gilder is more keen on gold than flame, but you tell him to shutup and get prepared for what\'s coming. The defenses of %holysite% itself should serve the company well here. | You order the men to defend themselves within %holysite%. %randombrother% looks around.%SPEECH_ON%You ever wonder if the god or gods watching this get a little ornery? Ya know? Like are we making a mess of their pots and pans?%SPEECH_OFF%You slap him upside the head and tell him to focus.}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{You order the %companyname% into the field. The northern lieutenant greets you with a wave and a grin.%SPEECH_ON%Coming on out, are ye? What, tired of prayin\'?%SPEECH_OFF%You turn and spit.%SPEECH_ON%We were running out of room to bury your bodies.%SPEECH_OFF%The lieutenant\'s smile fades and he orders a charge. To battle!}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{As you sheath your weapon and have the company set out to collect what they can from the dead, you get the strange feeling that this is not the first time %holysite% has been home to such bloodshed. Oh well, if anyone\'s gonna be dying in their ancestor\'s footsteps you\'re glad it\'s not you. A few southerners arrive to secure the holy tract. With them here, you make your leave, knowing that %employer% will welcome the news you have to bring him. | The enemy is defeated and %holysite% reclaimed. Southern soldiers slowly fill the defenses. Trickling behind them is a crowd of the faithful, passing by the dead so they may prostrate themselves at the holiest of spots. Not a one says thanks to you. Not that it matters, that\'s %employer%\'s job. | With the battle over, a small crowd of the faithful begins to congregate in the corners of %holysite%. You don\'t know where these people even came from. They don\'t mind you, and you don\'t mind them. What matters now is that %employer% will have a huge trove of crowns awaiting your return. As you leave, a few southern soldiers take the post with not a thanks to their lips either.}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{You\'ve failed to protect %holysite% from the northerners. There\'s no reason to stick around, and the only reason to Retournez à %employer% is if you want your head on one of the Vizier\'s gold-encrusted platters.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% is sitting beneath the glow of a golden bauble, an enormous piece of metal like the sun with chains holding it from the ceiling. It must have been erected while you were away. When you come forward, a holy man stops you and shakes his head. He draws a circle in the air with his hand and then touches his fingertip upon your pate. Smiling, he warmly guides you to another side of the room where %reward% crowns have been stacked neatly inside wooden trays.\n\n The man bows, points his hands to the golden bauble, shaping his palms as though he carried the very construct, and then he seems to guide its sublimity upon your payment, the coins crackling with light. Some sort of trick, but the pay is real so you take it and go. | When you enter %employer%\'s room, a number of guards bow and prostrate themselves momentarily and then get to their feet. In the distance, the Vizier is silently sitting on a throne with silk-wearing holy men all around him. It seems you will not be approaching him on this day, but a group of young boys carry trays of coins to you one at a time until you have %reward% crowns. The Vizier nods and turns his hand over. You take the payment and go. | You enter the grand hall to find %employer% seemingly ensorcelled by a swirl of golden mist. He stands upon a rotating platform - revolving rather roughly with the help of nearly unseen slaves beneath the floor itself - and there are strips of cloth tied to his wrists. His harem stands off to the side filling their mouths with some golden liquid before spraying it out in lip-spattering mists. Upon closer inspection, it is not so glorious an event as you first thought walking in here. Fortunately, you will not be afforded a closer look: a large man in religious frock cuts you off and guides you to a table at the back of the room. It is lined with trays filled with coin, their entirety being your reward of %reward% crowns. With your pay in hand, you are hurriedly ushered out of the room.}",
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
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
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
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "Regiment of " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, 170 * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Conscripted soldiers loyal to their city state.");
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
			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + " Company", true, this.Const.World.Spawn.Noble, this.Math.rand(100, 140) * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Professional soldiers in service to local lords.");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
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


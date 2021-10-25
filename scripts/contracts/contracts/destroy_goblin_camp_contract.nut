this.destroy_goblin_camp_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.destroy_goblin_camp";
		this.m.Name = "Destroy Goblin Camp";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.World.State.getPlayer().getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
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
					"Détruisez " + this.Flags.get("DestinationName") + " %direction% de %origin%"
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
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.GoblinRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
				{
					this.Flags.set("IsBetrayal", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 20 && this.World.Assets.getBusinessReputation() > 1000)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsAmbush", true);
						}
					}
				}

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
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsBetrayal"))
					{
						if (this.Flags.get("IsBetrayalDone"))
						{
							this.Contract.setScreen("Betrayal2");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("Betrayal1");
							this.World.Contracts.showActiveContract();
						}
					}
					else
					{
						this.Contract.setScreen("SearchingTheCamp");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsAmbush"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Ambush");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.LocationTemplate = null;
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GoblinRaiders, 50 * this.Contract.getScaledDifficultyMult(), this.Contract.m.Destination.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
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
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_61.png[/img]{%employer%\'s reading a scroll when you enter. He waves you off, perhaps thinking you\'re just a servant. You clank your scabbard against the wall. The man glances up, then quickly drops his papers.%SPEECH_ON%Ah, sellsword! It is good to see you. I have a problem specifically for a man of your... proclivities.%SPEECH_OFF%He pauses as if expecting your input. When you\'ve none, he awkwardly continues.%SPEECH_ON%Yes, of course, the task. There are goblins %direction% of %origin% who have established something of a foothold. I\'d take myself and some of my knights to go take care of it, but as it turns out, \'killing gobbos\' is beneath those men. Hogwash, I say. I think they just don\'t want to die at the hands of the stunty little gits. Honor, valor, all that.%SPEECH_OFF%He smirks and raises a hand.%SPEECH_ON%But it\'s not beneath you, so long as the pay is right, yes?%SPEECH_OFF% | %employer%\'s yelling at a man leaving his room. When he settles down, he bids you a fair greeting.%SPEECH_ON%Farkin\' hell, it\'s good to see you. Do you have any notion as to how hard it is to get your \'loyal\' men to go kill some goblins?%SPEECH_OFF%He spits and wipes his mouth on his sleeve.%SPEECH_ON%Apparently it is not the most noble of tasks. Something about how those little gits don\'t ever fight fair. Can you believe that? Men telling me, a highborn nobleman, what is \'noble\' or not. Well, there it is anyway, sellsword. I need you to go %direction% of %origin% and root out some goblins that have set up a camp. Can you do that for me?%SPEECH_OFF% | %employer%\'s unsheathing and sheathing a sword. He seems to look at himself in the blade\'s reflection before snapping it away again.%SPEECH_ON%The peasants are badgering me again. They say there are goblins camping at a place called %location% %direction% of %origin%. I\'ve no reason to disbelieve them after a young boy was brought to my feet today, a poison dart in his neck.%SPEECH_OFF%He slams the sword into its scabbard.%SPEECH_ON%Are you willing to take care of this problem for me?%SPEECH_OFF% | Red in the face, a drunken %employer% slams a mug down when you enter his room.%SPEECH_ON%Sellsword, right?%SPEECH_OFF%His guard looks in and nods. The nobleman laughs.%SPEECH_ON%Oh. Good. More men to send to their deaths.%SPEECH_OFF%He pauses before bursting into laughter.%SPEECH_ON%I joke, what a joke, right? We are having an issue with some goblins %direction% of %origin%. I need you to go take care of them, are you -hic- up for that or should I go ask someone else to dig their own... I mean...%SPEECH_OFF%He shuts himself up with another drink. | %employer%\'s comparing two scrolls when you enter.%SPEECH_ON%My taxmen are falling a little short these days. A shame, though I guess it\'s good business for you now that I can\'t afford to send my so called \'loyal\' knights anywhere.%SPEECH_OFF%He throws the papers aside and tents his hands over his table.%SPEECH_ON%My spies are reporting goblins have set up camp at a place they call %location% %direction% of %origin%. I need you to go there and do what my bannermen refuse to do.%SPEECH_OFF% | %employer% breaks bread as you enter, but he doesn\'t share any. He dips both ends into a goblet of wine and stuffs his mouth. He speaks, but it\'s more crumbs than words.%SPEECH_ON%Good seeing you, sellsword. I have some goblins %direction% of %origin% that need rooting out. I\'d send my knights to go take care of them, but they\'re, uh, a little more important and less expendable. I\'m sure you understand.%SPEECH_OFF%He manages to stuff the rest of the bread into his ugly maw. For a moment, he chokes, and for a moment you consider shutting the door and letting this end here and now. Unfortunately, his throes of anguish garner the attention of a guard who swoops in and slams the nobleman in the chest, spilling the hazard right out in all its goopy, near-assassinating glory. | When you find %employer%, he\'s sending off a few knights, chasing them out the door with a few parting curses. The sight of you, however, seems to momentarily settle the man.%SPEECH_ON%Sellsword! Good to see you! Better you than those so-called \'men\'.%SPEECH_OFF%He takes a seat and pours himself a drink. He takes a sip, stares at it, then downs it all in one go.%SPEECH_ON%My loyal bannermen refuse to go take on the goblins which have camped %direction% of %origin%. They talk of ambushes, poison, all that...%SPEECH_OFF%His speech is increasingly slurred.%SPEECH_ON%Well... -hic-, you know all that, right? And you know what I\'m asking next, right? Of - of course you do, -hic-, I need you to hand me another drink! Ha, kidding. Go kill those goblins, wouldya?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combattre des Gobelins ne sera pas gratuit. | J\'imagine que vous allez payer chère pour ça. | Parlons argent.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | Nous avons d\'autres obligations.}",
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
			ID = "Ambush",
			Title = "Approaching the camp...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{You enter the goblin camp to find it empty. But you know better - you know you\'ve just walked into a trap. Just then, the damned greenskins emerge from all around you. With the loudest warcry you can muster, you order the men to prepare for battle! | The goblins have fooled you! They left the camp and maneuvered back around, encircling you. Prepare the men carefully, because this trap will not be easy to escape. | You should have known better: you\'ve stepped right into a goblin trap! They have their soldiers placed all around while the company is standing around like a bunch of sheep to the slaughter!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Watch out!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{As you finish the last goblin you are suddenly greeted by a heavily armed group of men. Their lieutenant steps forward, his thumbs hooked into a belt holding up a sword.%SPEECH_ON%Well, well, you really are stupid. %employer% does not forget easily - and he hasn\'t forgotten the last time you betrayed him. Consider this a little... return of the favor.%SPEECH_OFF%Suddenly, all the men behind the lieutenant charge forth. Arm yourselves, this was an ambush! | Cleaning gobbo blood off your sword, you suddenly spot a group of men walking toward you. They\'re carrying %employer%\'s banner and are drawing their weapons. The realization that you\'ve been setup dawns on you just as the men begin to charge. They let you fight the goblins first, the bastards! Let them have it! | A man seemingly from nowhere comes to greet you. He\'s well armed, well armored, and apparently quite happy, grinning sheepishly as he approaches.%SPEECH_ON%Evening, mercenaries. Good work on those greenskins, eh?%SPEECH_OFF%He pauses to let his smile fade.%SPEECH_ON%%employer% sends his regards.%SPEECH_OFF%Just then, a group of men swarm out from the sides of the road. It\'s an ambush! That damned nobleman has betrayed you! | A group of armed men wearing the colors of %faction% fall in behind you, the group fanning out to stare at your company. Their leader sizes you up.%SPEECH_ON%I\'m going to enjoy prying that sword from your cold, dead hands.%SPEECH_OFF%You shrug and ask why you\'ve been setup.%SPEECH_ON%%employer% doesn\'t forget those who doublecross him or the house. That\'s about all you need to know. Not like anything I say here will do you good when you\'re dead.%SPEECH_OFF%To arms, then, for this is an ambush! | Your men scour the goblin camp and find not a soul. Suddenly, men in the colors of %faction% appear behind you, the lieutenant of the group walking forward with ill intent. He\'s got a cloth embroidered with %employer%\'s sigil.%SPEECH_ON%A shame those greenskins couldn\'t finish you off. If you\'re wondering why I\'m here, it is to collect a debt owed to %employer%. You promised a task well done. You could not own up to that promise. Now you die.%SPEECH_OFF%You unsheathe your sword and flash its blade at the lieutenant.%SPEECH_ON%Looks like %employer% is about to have another promise broken.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Take up arms!",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", false);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Betrayal";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 140 * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{You wipe your sword on your pant leg and quickly sheathe it. The ambushers lay dead, skewered into this grotesque pose or that one. %randombrother% walks up and inquires what to do now. It appears that %faction% isn\'t going to be on the friendliest of terms. | You kick the dead body of an ambusher off the end of your sword. It appears %faction% isn\'t going to be on the friendliest of terms from now on. Maybe next time, when I agree to do something for these people, I actually do it. | Well, if nothing else, what can be learned from this is to not agree to a task you can\'t complete. The people of these land are not particularly friendly to those who fall short of their promises... | You betrayed %faction%, but that\'s not something to dwell on. They betrayed you, that\'s what is important now! And going into the future, you best be suspicious of them and anyone who flies their banner. | %employer%, judging by the dead bannermen at your feet, appears to no longer be happy with you. If you were to guess, it\'s because of something you did in the past - doublecross, failure, back-talking, sleeping with a nobleman\'s daughter? It all runs together that you try and think about it. What\'s important now is that this wedge between you two will not be easily healed. You best be wary of %faction%\'s men for a little while.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "So much for getting paid...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SearchingTheCamp",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_83.png[/img]{Having slain the last of the goblins, you take a peek about their encampment. They seem the merry sort - piles of trinkets and instruments, all of which could double as a weapon. All it\'d require would be to dip them in the giant pot of poison resting right in the middle of the ruins. You kick it over and tell the men to get ready to head back to %employer%, your employer. | The goblins put up a good, crafty fight, but you\'ve managed to kill them all. Their camp set aflame, you order the men to get ready to Retournez à %employer% with the good news. | While the short-greenskins put up a hell of a fight, your company managed a better one. The last of the goblins slain, you take a look autour deir ruined encampment. It appears they were not totally alone - there\'s evidence that other goblins ran off while the fighting was going on. Maybe family? Children? No matter, it\'s time to Retournez à %employer%, the man who hired you. | Ah, it was a good fight. %employer% will be expecting to hear word of it now. | No wonder men do not wish to fight goblins, they put up a fight far beyond their stature. A shame one could not put their minds into a man, but perhaps it is for the best that such ferocity is contained within such small beings!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Time to collect our pay.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You enter %employer%\'s room and drop a few goblin heads on the floor. He glances at them.%SPEECH_ON%Huh, they\'re actually a lot bigger than the scribes tell.%SPEECH_OFF%With a few words you report the destruction of the greenskins\' encampment. The nobleman nods, rubbing his chin.%SPEECH_ON%Excellent. Your pay, as promised.%SPEECH_OFF%He hands over a satchel of %reward_completion% crowns. | %employer%\'s throwing rocks at a skittish cat when you enter. He glances at you, giving the poor creature the slightest opening to escape out a window. The nobleman chases it out with a few rocks, thankfully missing with every one.%SPEECH_ON%Good to see you, sellsword. My spies have already told me of your doings. Here\'s your pay, as agreed upon.%SPEECH_OFF%He slides a wooden chest of %reward_completion% crowns across his table. | %employer%\'s shucking nuts when you return. He throws the shells on the ground, jawing and gnashing as he speaks.%SPEECH_ON%Oy, it\'s good to see you again. I take it you were successful, yes?%SPEECH_OFF%You lift a few goblin heads up, each one tethered to a unifying band. They twist and stare at the room and at one another. The man puts his hand up.%SPEECH_ON%Please, we are dignified people here. Put that way.%SPEECH_OFF%You shrug and hand them to %randombrother% who is waiting out in the hall. %employer% walks around his table and hands you a satchel.%SPEECH_ON%%reward_completion% crowns, as agreed upon. Good job, sellsword.%SPEECH_OFF% | %employer% laughs when he sees you come in with the goblin head.%SPEECH_ON%Hell, man, don\'t be bringing those in here. Give \'em to the dogs.%SPEECH_OFF%He\'s a bit drunk. You\'re not sure if he\'s elated that you were successful or if he\'s just naturally merry with a bit of ale in him.%SPEECH_ON%Your payment was -hic- %reward_completion% crowns, right?%SPEECH_OFF%You think to \'alter\' the details, but a guard outside looks in on the talks and shakes his head. Oh well, looks like it was %reward_completion% crowns then. | When you Retournez à %employer% he\'s got a woman over his legs. In fact, she\'s bent over and his hand is in the air. They both stare at you, pausing, then she quickly scurries under his table and he straightens up.%SPEECH_ON%Sellsword! It\'s good to see you! I take it you were successful destroying those greenskins, yes?%SPEECH_OFF%The poor lady bumps her head underneath the desk, but you try to pay it no mind as you inform the man of the expedition\'s success. He claps his hands, looks to stand, then thinks better of it.%SPEECH_ON%If you would, your payment of %reward_completion% crowns is on the bookshelf behind me.%SPEECH_OFF%He smiles awkwardly as you retrieve it.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Destroyed a goblin encampment");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.m.Origin.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/greenskins_situation"));
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

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
			}
		}
	}

	function onIsValid()
	{
		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			if (this.m.Origin.getOwner().getID() != this.m.Faction)
			{
				return false;
			}

			return true;
		}
		else
		{
			return true;
		}
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

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});


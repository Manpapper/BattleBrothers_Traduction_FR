this.hunting_sand_golems_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_sandgolems";
		this.m.Name = "Shifting Sands";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 850 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Chassez ce qui tue les gens dans le désert autour de " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10 && this.Contract.getDifficultyMult() >= 1.15)
				{
					this.Flags.set("IsEarthquake", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Desert)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 8, 12, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Ifrits", false, this.Const.World.Spawn.SandGolems, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Creatures of living stone shaped by the blistering heat and fire of the burning sun of the south.");
				party.setFootprintType(this.Const.World.FootprintsType.SandGolems);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 1; i = ++i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, disallowedTerrain);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.SandGolems, 0.75);
					}
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(8);
				roam.setMaxRange(12);
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Desert, true);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					this.Contract.setScreen("Victory");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					local tileType = this.World.State.getPlayer().getTile().Type;

					if (tileType == this.Const.World.TerrainType.Desert)
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsEarthquake"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Earthquake");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
					}
				}
				else if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% lifts his head and seemingly regards you down the bridge of his nose. It is a powerful sneer, but he does bring you in. The Vizier claps his hands and a servant comes to you with a scroll, unfurls it, and reads.%SPEECH_ON%Ifrits have been spotted in the sands. A Crownling - that is you, traveler - is to....%SPEECH_OFF%The Vizier claps his hands again.%SPEECH_ON%Could be him, servant. That COULD be him. Be mindful with your distinctions.%SPEECH_OFF%You know the servant wants to say he didn\'t write the scroll, but he keeps that to himself. He finishes the announcement.%SPEECH_ON%...is to be incentivized to dispel the scorching sands back into their natural state. Annihilation of said monsters would be compensated with %reward% crowns.%SPEECH_OFF%The scroll rolls back up, the servant catches it at the sides, and he slides back out of scene. You see the Vizier again, but he is not paying attention as a slave girl feeds him grapes. | A Vizier by the name of %employer% greets you, though all the grace in the meeting is entirely invested into the bureaucratic side of the discussion.%SPEECH_ON%Crownling, Ifrits stalk the sands. Your services have been summoned to help deal with it. If you do not agree to the compensation of %reward% crowns, then we shall summon ourselves another in your stead.%SPEECH_OFF% | You enter a room to find a number of viziers buried beneath the bodies of slave girls. There is a good deal of giggling and playful skin pulling, but most notably nobody seems to notice you are there. Save for an older man who shuffles over and bows.%SPEECH_ON%Crownling, the Vizier %employer% has summoned a Crownling for the task of hunting Ifrits.%SPEECH_OFF%The old man glances over, then straightens up. The next time he speaks it is stripped of the high falutin nonsense.%SPEECH_ON%They\'re large sandy bastards, and they are tearing up the countryside. I warn you that they are not to be trifled with, so don\'t let all this show of pomp and gold fool you into tackling something you shouldn\'t. %reward% crowns are on the table if you accept.%SPEECH_OFF%Straightening up and clearing his throat, the old man loudly asks.%SPEECH_ON%Do you accept your summons?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{I\'m interested, go on. | Hunting down an enemy like this doesn\'t come cheap. | This is going to cost you. | Hunting a mirage in the desert. What is not to like. | The %companyname% can help, for the right price.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{This doesn\'t sound like our kind of work. | I won\'t lead the men on a wild goose chase through the desert. | I don\'t think so. | I say no. The men prefer known enemies of flesh and blood.}",
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
			ID = "Banter",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{While tracking the mysterious Ifrits, you come across an old crone who has feet like leather. She bows at your appearance.%SPEECH_ON%Ah, slaves of the coin, it is the Ifrits you seek, yes? Of course. I can see it on your faces.%SPEECH_OFF%She pauses and points out toward the dunes where you are heading.%SPEECH_ON%We are of these lands, understand? We are one with them, and when we banish and harm and be cruel to one another, the sands take to the sides of those who have been wronged. Fear yourself not the monster, but the reason it has been created, for that reason permeates these sands, and in that reasoning you shall slay but one monster but not salt the waters which cause it to spring eternal.%SPEECH_OFF% | You come across a well in the desert. A man offers you a few buckets of refreshment, remarking that the water below is unending. With not a single farm in sight, you\'ve reason to believe there\'s enough water below to slake one\'s thirst for all time. The man does seem to sense you\'ve other purpose in these parts though.%SPEECH_ON%I take it is the Ifrits you seek, is it not?%SPEECH_OFF%Nodding, you ask him how he knew that. He grins.%SPEECH_ON%Cause I\'ve seen them, and what they\'ve done, and I believed it would only be a short time until a professional army or slave of the crown would come along to resolve their disputes. The Ifrit is a monster of vengeance, and it will only succumb to that which ushered it out of the earth: cruelty.%SPEECH_OFF%Finishing your drink, you thank the stranger for his words and continue on. | A few corpses in the sands. Some have slid halfway down a dune. Another rests at the base, another far from the base. Seemingly thrown that way. The bodies being uncovered by the sands hints at some recency in the deaths. It seems whatever attacked the people pulverized them with incredible force then spent a brief time mutilating what was left, sanding the flesh down to the bone in spots. The Ifrits must be close...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Watch where you step.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_153.png[/img]{At first glance, it is a mirage. The desert shifts and blurs at distance, and to the unwitting or exhausted, these sights alter and change to be whatever one wishes them to be. It is when the Ifrit turns around and rips a human body in half and slings the parts across the sands that you realize this is not an imagined monstrosity at all. It is a hellish creature, a spinning cloud of sand with stones shifting about to give it some shape of what a man might be. And as it leans forward you realize if nothing else it does share a man\'s disposition toward armed strangers on its land: murderous rage. | The sand dunes ahead slip from top to bottom, the sands curling toward you like a sheet being pulled off a bed. But a stone appears unearthed and another and another, and when the first stone rises you realize it is an Ifrit. A growl scratches out, a deep bellow that is crackling with the clash of sandy winds. The Ifrit takes some sloping, disjointed shape of a man, stones for bones, and sands for flesh, and it charges forth. | You find the Ifrit holding a distended sense of an arm down toward the earth. Sand blows out of the arm and the grains press a dead body into the desert, the force ripping away the clothes, and then peppering open the flesh, then it is stripped to the bone entirely and when the Ifrit is done it turns to you and ferociously growls.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Earthquake",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_160.png[/img]{As you reach the top of a sand dune, it immediately stretches away from your very feet. You find yourself sinking and roll out before the earth swallows you whole. As you tumble down the slopes, you find the adjacent dunes similarly receding, and in your belly there is a tremble, not of fear, but of the ground itself violently shaking. When it is over, you stand up and steady your feet. And Ifrits come to stand at the rim of the crater and look down at you. They scream at you, hissing ferocity scraping with the sound of sand crystalizing past one another. You are surrounded! | You pause and sigh. The desert just seems to go on and on, and just as you think that you find the view shrinking away. It takes a moment for you to realize the ground is shaking and as the sand shifts you are being sucked down. You roll away from danger and find yourself tumbling down the sand slopes. At the bottom you quickly jump to your feet and draw your weapon to face what you already know is there: the Ifrits. They stand at the rim of the dunes, staring down at you as though they trapped a rat. Their bodies are clouds of sand with floating stones to give a sort of staccato shape of what might be a man. They growl and descend downward!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_160.png[/img]{The battle is over, but the Ifrits do not depart entirely. The sands which made their bodies bubble, and the stones which framed their bodies shift and tremble angrily. You can hear the hiss not of some monstrosity at all, but what is clearly the sound of humans. They hiss, the sound right at your ears. You twist around to find nothing. They hiss behind you again, and this time when you turn autour de noise is gone and the sands are still and the stones earth bidden as they should be. The beasts are slain, and possibly whatever inhabited them, too. It is time to Retournez à %employer%. | The Ifrits are slain, but the bodies only seemed to serve as vessels for something far more sinister. You catch glimpses of spirits soaring toward the horizon, but perhaps it is merely the desert itself playing tricks on you. There\'s no saying, except to say that the beastly nature of the Ifrits has been defeated and %employer% needs to pay you for that alone.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "It\'s done.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{You try and enter %employer%\'s room, but a guard stops you. With a bit of a brow raiser, you tell the man that the Vizier is expecting you. The guard stares down at you.%SPEECH_ON%He expects you, he does not wish to see you. Those are two different things, Crownling. The scouts have confirmed your doings in the deserts. Here is your pay, as agreed upon. Now depart. I said depart!%SPEECH_OFF%The guard stamps his foot and all the guards posted down the hall stamp their feet and face you. Now, you are no genius, but you get the feeling that it is probably time to go. | %employer% stares down at you from a throne of pillows and women. Slave women, judging by their chains, though perhaps that is just their thing. The sad faces say otherwise. The Vizier speaks, but it is almost as if it is a show for all those listening and you\'re just playing a part.%SPEECH_ON%Crownling, my little hawks have told me of your doings. The Ifrits have been put to rest and their sorcery shall be a threat no more! Such is the power of my gold. It is work which we have agreed to, and for that %reward% crowns is your reward.%SPEECH_OFF%As a servant hands you a purse of coins, the Vizier flitters his fingers dismissively toward you.%SPEECH_ON%Begone.%SPEECH_OFF% | You find %employer% turning an hourglass one way and back again. The sands are equally pitted to the halved bulbs. There are servants all along the wall with their heads bowed. At the adjacent wall are a line of cushions upon which sit gaudy women whose hair is tended to by women in chains. The Vizier slams the hourglass down. He crouches behind it, his eyes visile to either side of the glass, the pupils staring inward. You finally notice that the sands within are not shifting as they should, but instead twirling angrily.%SPEECH_ON%The Ifrits have been dealt with, this my hawks have told me so. Crownling, you have done your job as you were summoned to do, and for that you are to be given %reward% crowns. I hope your time in the deserts rewarded you not only with experience of combat and war, but also graced you with the notion of contemplation.%SPEECH_OFF%You\'re not sure what this man means. He yanks the hourglass up and starts to tilt it side to side again. The sands thrash as they bounce from side to side. A servant hands you a purse of coins and you could not depart the room faster. | You Retournez à %employer% to find the Vizier facedown on a couch. A number of old men are knuckling his back or rubbing his feet. Across the room, a woman fans herself. She is entirely naked and her eyes never leave the Vizier\'s, nor his hers. The man talks almost as if you are not even in the room at all.%SPEECH_ON%Servants, hand this Crownling the purple purse with black thread. Crownling, you have done well in handling the spirits of the sands, these so-called Ifrits. It was my gold which ushered you into those deserts, and my gold which rewarded you, so let the scribes know that it is my gold which has settled this issue truly, and that the tool, this Crownling, was paid fairly.%SPEECH_OFF%A servant stabs a purple sack into your arms. The Vizier groans as an old man plants an elbow right into his ass crack.%SPEECH_ON%Need I tell you to depart, Crownling?%SPEECH_OFF% | An old man with no eyebrows greets you, stopping you just outside %employer%\'s door. He pushes a sack into your arms.%SPEECH_ON%There are %reward% crowns in there, as the Vizier agreed.%SPEECH_OFF%The man looks around for listeners and seems to nod when you seeing you are the only one within earshot.%SPEECH_ON%The Ifrits are not just demons, they are wronged spirits, and you have set them free. But they will likely return, because men such as %employer% have nothing to offer this world but a waterfall of gold, and they forget that beneath that waterfall many are crushed or drowned.%SPEECH_OFF%You\'re not sure what he means, but an approaching guard ends the conversation and the old man slaps you across the face.%SPEECH_ON%Begone, Crownling! Take your pay and leave my sight!%SPEECH_OFF% | Of all things, a troop of cats welcome you enter %employer%\'s room. You can just barely see the Vizier on the other side of a mesh with a crowd of equally amused onlookers.\n\n You look down and see the cats are carting around a piece of wood with a purse atop it. You look back up. The silhouettes are holding their breath. Sighing, you bend down and pick up the purse. One voyeur erupts and claps but is met by stern hushing. Their task complete, the cats fall down and spread out on the tile, dozing or grooming themselves or pawing at the shadows which flitter in the sunbeams. You\'re pretty sure %reward% crowns are in the sack, but not wanting to spend another second in the room you step outside to count.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A successful hunt.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Rid the city of Ifrits");
						this.World.Contracts.finishActiveContract();
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/mirage_sightings_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
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
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});


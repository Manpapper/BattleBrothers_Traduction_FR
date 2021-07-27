this.lawmen_after_criminal_event <- this.inherit("scripts/events/event", {
	m = {
		Criminal = null,
		OtherBro = null,
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.lawmen_after_criminal";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_90.png[/img]Riders crest a nearby hill, their silhouettes dark and oddly shaped on its rim like a reef of rippling black. Not wholly able to see who they are, you order a few of your brothers to hide away. An ambush might be needed to defend yourself otherwise you stand no chance against such a mounted force. As the selected mercenaries dip into the bushes, the horsemen begin heading down the hill. The thunder of the hooves grows louder, but you stand resolute, hoping to give your men a good show of bravery.\n\nYou see that the bannerman is carrying a sigil of %noblehousename%. Behind him another horseman is dragging a travois with a few shackled men for cargo. When the men arrive, their leader stands up between the withers of his horse and points at you before talking.%SPEECH_ON%Mercenary! We have by the lord\'s authority the right to claim the - shackled! - hands of a sir %criminal%. Said man is within your midst. He must pay for his crimes. Hand him over immediately and you will be rewarded.%SPEECH_OFF%You turn your head and spit. You nod at the lawman before asking him a question.%SPEECH_ON%And whose authority do you have? There are a lot of lords in these lands and not all of them pay me well.%SPEECH_OFF%The lawmen\'s captain sits back down in his saddle. His hands cross over his pommel, resting there with armored authority. He does not look the least bit amused and voices his displeasure as such.%SPEECH_ON%The punishment for willfully harboring a fugitive is death. You\'ve but one more chance to release this criminal to me or you shall face a fate well suited for a sword-selling dog.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "The company would only suffer if we fought over this. The man is yours.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We\'ll not give him up.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getMoney() >= 1500)
				{
					this.Options.push({
						Text = "Surely this isn\'t something that can\'t be solved with a fat purse of crowns?",
						function getResult( _event )
						{
							return "F";
						}

					});
				}

				if (this.World.Assets.getBusinessReputation() > 3000)
				{
					this.Options.push({
						Text = "You know who it is you\'re threatening? The %companyname%!",
						function getResult( _event )
						{
							return "G";
						}

					});
				}
				else
				{
					this.Options.push({
						Text = "You got a drawing of the man you\'re after? Let me take a look.",
						function getResult( _event )
						{
							return this.Math.rand(1, 100) <= 50 ? "D" : "E";
						}

					});
				}

				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_53.png[/img]You stand no chance against these men. Although it pains you mightily, you hand %criminal% over. He barks curses at you as the lawmen chain him up, and swears your name into the mud as they throw him in with the rest of the bound men. The captain of the lawmen trots his horse over to you. He sneers at you before throwing a purse of coins to the ground. His body is close and there\'s an opening in his armor. You could fit a knife in there, right between the ribs, lead the blade right to his heart. It\'d be quick. But you wouldn\'t last much long after, and all of your men would be quickly slain.\n\nInstead, you lean over and pick up the coins, swallow you pride, and say your thanks. The lawmen waste little time returning from whence they came.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "I can\'t put the whole company on the line for you.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/asset_brothers.png",
					text = _event.m.Criminal.getName() + " has left the company"
				});
				_event.m.Criminal.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Criminal);
				this.World.Assets.addMoney(100);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 100 + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_10.png[/img]As the lawman stares at you, waiting for an answer, you let out a sharp whistle. Half of the company emerges from the bushes, whooping and hollering in ambush. The steed pulling the travois bucks its rider to the ground before taking off altogether, a group of wide-eyed criminals going along for the ride. Another lawman retreats, abandoning his troop.\n\n%randombrother% plucks one man from his saddle while another brother drives a spear into a horse\'s chest, bringing both beast and man crashing to the ground. The captain falls off his horse when it rears up in wild fear. It\'s a hard tumble, but he manages to roll back to his feet only for the bucking horse to clip him in the head. It is a quick, blunt demise that leaves the captain face down in the cradle of his own helmet.\n\nThe rest of his men come to stand by his body and they look to you with vengeance in their eyes.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Charge!",
					function getResult( _event )
					{
						_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "You killed some of their men");
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.NobleTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.TemporaryEnemies = [
							_event.m.NobleHouse.getID()
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Noble, this.Math.rand(80, 100) * _event.getReputationToDifficultyLightMult(), _event.m.NobleHouse.getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_78.png[/img]The captain of the lawmen snaps his fingers at one of the bannermen. He hands over a scroll which the captain unfurls before handing it to you. The man you see looks remarkably like %criminal%, but since you\'ve been on the road the mercenary has gained a few scars that separate his visage from the one on the paper. But they won\'t buy that. So you lie instead.%SPEECH_ON%The man you\'re looking for is dead. He was a criminal, just as you said, and we found him thieving from our foods. %other_bro% ran a sword through him when we\'d found out.%SPEECH_OFF%The brother looks at you, and then the lawmen. He nods.%SPEECH_ON%That I did. He had a mouthful of my bread when I stuck him like a pig! I saved the rest of the loaf for m\'self, thank goodness.%SPEECH_OFF%The lawmen chuckle amongst themselves. Their captain looks back on them, his gaze a quieting one. He looks back to you. You can see why they shut up: his eyes are stern, unmoving, fierce, black. The man holds you in this stare for nearly half a minute before he nods and gathers his reins.%SPEECH_ON%Alright, mercenary. Thank you for letting us know.%SPEECH_OFF%The lawmen pack up and head back from whence they came. A sigh of relief passes over the company as a whole and you order the men hiding in the bushes to come out. It\'s a long road ahead and hopefully there won\'t be more problems like this one.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Phew.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
				_event.m.Criminal.improveMood(2.0, "Was protected by the company");

				if (_event.m.Criminal.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Criminal.getMoodState()],
						text = _event.m.Criminal.getName() + this.Const.MoodStateEvent[_event.m.Criminal.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_78.png[/img]The captain hands you a scroll with %criminal%\'s face on it. True, the resemblance is there. But the man has been in your company long enough to gain a scar or two. Maybe they won\'t realize it\'s him? You ask the criminal to step forward and, nervously, he does as told. You look to the captain.%SPEECH_ON%Is this the man you are after? I can see why you might think this is him, but look at these scars. The man in the drawing has none. And look at his hair! The one in the drawing is straight, and this man\'s is clearly matted and curly.%SPEECH_OFF%You stop because judging by the faces of your audience this isn\'t even coming close to working. The captain draws his sword.%SPEECH_ON%Do you take me for a fool? Kill them all.%SPEECH_OFF%Well, so much for that. Before the lawmen can charge you whistle as loud as you can. Half the company surges forth from the bushes, whooping and hollering like banshees. The sudden fright drives the horses wild, pitching their riders into the dirt and the travois-puller even runs off altogether, carrying with it a couple of very confused criminals.\n\n%randombrother% comes charging across the field of mayhem with a spear in hand. He plunges it deep into the captain\'s steed, bringing both man and beast crashing to the ground. The lawmen, what\'s left of them, gather around their captain. Seemingly growling, the man wipes blood from his face and spits out a tooth. He grins a gapped smile before ordering his men to charge.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Form up!",
					function getResult( _event )
					{
						_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "You killed some of their men");
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.NobleTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.TemporaryEnemies = [
							_event.m.NobleHouse.getID()
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Noble, this.Math.rand(80, 100) * _event.getReputationToDifficultyLightMult(), _event.m.NobleHouse.getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_04.png[/img]The captain\'s threats are cooled when you retrieve a large satchel of crowns. His men exchange glances as you hold the bag up.%SPEECH_ON%We\'ve no time for this. What I have here is %bribe% crowns. Take it and go away. Stay, and earn yourself a grave. Your choice, lawman.%SPEECH_OFF%Sensing the stares of his fellow riders, the captain is especially careful in mulling this one over. He sizes up your men, and briefly does the same to his men. He must see great losses for he finally nods. Jerking his horse\'s bridle, he drives his steed forward and the two of you come face to face. You smile as you hand the crowns over.%SPEECH_ON%Spend it well.%SPEECH_OFF%The captain takes the satchel and cinches it to the side of his saddle, looping the leather harness over the hilt of a sword while his men look on. He nods, but does not smile back.%SPEECH_ON%My daughter is to be wed in a fortnight. I\'d like to be there.%SPEECH_OFF%You nod and bid the humorless captain farewell.%SPEECH_ON%May her husband be kind, and her children bountiful.%SPEECH_OFF%The captain haws his horse and leads it back to his men. They depart, the hooves of their mounts steadily thumping into the distance until there is nothing but the scratch of wind-tickled grass to fill the air.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "What I don\'t do for you lot...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
				this.World.Assets.addMoney(-1000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + 1000 + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_12.png[/img]You walk directly toward the captain, stopping halfway between your men and his. With your fists to your hips, you call out to the captain\'s lawmen, asking if they know the name of the %companyname%. You see a few of the riders shift up on their saddles, balancing tented arms on their pommels as they stare intently at your banner. They quickly sit back down and hushed whispers trickle down and back up their battle line.\n\nOne man calls out, asking if it\'s true that you shorn the noses of those you slay. It is not true, but you\'ve no reason to spill the truth. Another man asks if %randombrother% is in your ranks, and if he has a necklace of ears and eats bonemeal for breakfast. You stifle the urge to laugh, only nodding in return. Quite naturally, the rumors overtake your opponents and they begin to cry out that this fight is not theirs to have.\n\nThe captain tells them that you\'re full of shit and to charge, but none follow his orders. Eventually, the captain is forced to turn back, heading after his men who are now in retreat.\n\nThe supposed cannibal-brother walks up, scratching his head.%SPEECH_ON%Bonemeal for breakfast?%SPEECH_OFF%A crackle of laughter rips through the company and soon a chant of \'don\'t eat me!\' is to be had.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Don\'t challenge the %companyname%!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.Characters.push(_event.m.Criminal.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		if (this.World.getTime().Days < 30 && this.World.Assets.getOrigin().getID() == "scenario.raiders")
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.FactionManager.isGreaterEvil())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.18)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		if (brothers.len() < 2)
		{
			return;
		}

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.killer_on_the_run" || bro.getBackground().getID() == "background.thief" || bro.getBackground().getID() == "background.graverobber" || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.nomad")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = this.getNearestNobleHouse(this.World.State.getPlayer().getTile());

		if (this.m.NobleHouse == null)
		{
			return;
		}

		this.m.Criminal = candidates[this.Math.rand(0, candidates.len() - 1)];

		do
		{
			this.m.OtherBro = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
		while (this.m.OtherBro == null || this.m.OtherBro.getID() == this.m.Criminal.getID());

		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"criminal",
			this.m.Criminal.getName()
		]);
		_vars.push([
			"other_bro",
			this.m.OtherBro.getName()
		]);
		_vars.push([
			"noblehousename",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"bribe",
			"1000"
		]);
	}

	function onClear()
	{
		this.m.Criminal = null;
		this.m.OtherBro = null;
		this.m.NobleHouse = null;
	}

});


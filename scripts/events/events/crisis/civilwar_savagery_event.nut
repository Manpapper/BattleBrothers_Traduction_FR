this.civilwar_savagery_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_savagery";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]{While marching down a path, you come across a lieutenant of %noblehouse% leading a band of men in a slaughter. They\'ve gathered the inhabitants of a small hamlet and are preparing to put them all to the sword. One of the laymen calls out to you, begging for you to intervene. The lieutenant glances at you. He doesn\'t have enough men to stop you, and you him, but there\'s enough on both sides to ensure everyone loses.%SPEECH_ON%Don\'t bother, mercenary. There\'s no profit here for you. Just keep on walking.%SPEECH_OFF% | The march of the %companyname% is suddenly interrupted when you come across a band of men carrying the banner of %noblehouse%. Unfortunately, carrying a banner isn\'t the only thing they are doing - they\'ve lined up peasants of a nearby hamlet and look prepared to slaughter them all. The lieutenant of the troop stares you down.%SPEECH_ON%Let\'s not get messy, mercenary. I suggest you keep on walking.%SPEECH_OFF% | You come to a hovel. A few bannermen of %noblehouse% are standing guard outside its door. Inside, you hear the screams of a woman and man. The lieutenant steps out and sees you. He fixes himself, even combing his hair back, and tells you to git.%SPEECH_ON%Don\'t start nothing, sellsword. Just keep on keeping on.%SPEECH_OFF% | You come to sort of holy temple, sacred to this old god or that. A few bannermen of %noblehouse% are boarding up the door while their lieutenant waves around a torch. People are screaming for mercy inside the building. You raise an eyebrow and the lieutenant spots it.%SPEECH_ON%Hey, sellsword. Yeah, you. Get moving. This ain\'t your show.%SPEECH_OFF% | While stepping down a path, you come across a lieutenant of %noblehouse%. He\'s got a couple of women standing on stools beneath a tree. They\'ve got ropes around their necks and tears down from their eyes. The lieutenant glares at you.%SPEECH_ON%Don\'t get any heroic ideas, sellsword. This ain\'t your business.%SPEECH_OFF% | While marching, you suddenly hear the shrill cries of children. Their baying draws you near, and you find them on one side of the road while on the other their parents are kneeling beneath about a dozen executioners\' swords. A lieutenant of %noblehouse% stands nearby, proudly holding up his noble house\'s banner. He stares at you.%SPEECH_ON%Oh, sellsword. Have you come to watch? I hope so, because you best not intervene. This is not your fight.%SPEECH_OFF% | Needing a piss, you climb a nearby hill for a little privacy, but mostly just to get your thoughts in order. Sadly, that won\'t be happening. Down the opposite slopes stand a number of men from %noblehouse%, following the barking orders of their lieutenant who squats not far from where you were going to piss. The troops are rounding up women from a couple of hovels stitched into an adjacent hillside. The men of the hamlet are already slain, dead in the grass here and there. Little more than blotchy lumps at this distance.\n\n The lieutenant looks up at you.%SPEECH_ON%Hello there, sellsword, nice day, no?%SPEECH_OFF%He must have seen the disconcerting look on your face as his own soon sours.%SPEECH_ON%Hey. Listen. Don\'t be getting any ideas of heroism, yeah? Just keep on walking. I\'ve seen that look before and if you don\'t put it away there\'ll be trouble for all of us.%SPEECH_OFF% | While walking a path, you hear the baying of some hounds. Apparently, a band of men from %noblehouse% have cleared out a few hovels and all that\'s left are the poor mongrels holed up in a kennel. There\'s a few soldiers standing outside it with torches, ready to set every mutt ablaze. A lieutenant stands nearby, a horrid grin on his face, though it quickly fades upon seeing you.%SPEECH_ON%Oh, you a dog lover or something? Don\'t give me that look. You\'d best keep to stepping, sellsword, or I\'ll treat you like one of these dogs here.%SPEECH_OFF% | During times of war, roads are often the worst places to be - they bring the terror to and fro and today is no different. You find a couple of %noblehouse% soldiers idling beside the path, staring down at someone they\'ve hogtied and hung over a fire yet to be lit. As you walk up, the soldiers\' lieutenant turns to get a look at you.%SPEECH_ON%Hey, if you don\'t like what you see, then keep on marching. This is war, what did you expect? Now get outta here, we got a fire to start.%SPEECH_OFF% | While trudging down a path off the main roads, keeping clear of the carnage that a civil war will wrought, you come to find a few soldiers of %noblehouse% torturing a man. They\'ve lit torches partially wrapped in leather and are letting the scraps of burning hot strips fall onto their poor prisoner. He\'s screaming for mercy, but they\'ve certainly have none for him. Seeing you, though, he calls out, begging for help. One of the soldiers turns to you.%SPEECH_ON%Like what you see? My father made this form of torture up. You just let the fiery leather drip all over them. Much better than just simple little embers.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "We have to put an end to this madness.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(4);

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "It isn\'t our place to intervene here.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_79.png[/img]{With a quick bark of an order, the %companyname% charges to the rescue. The men of %noblehouse% are dispatched, bloody and quick. Crying and forever thankful, the rescued laymen practically kiss your feet. You tell them to run, lest the rest of the nobility\'s army show up. | You tell the men of %companyname% to make it quick. The soldiers of %noblehouse% try and defend themselves, but they\'d spent the last few minutes preparing to kill innocents, not defend themselves against hardier stock. They are felled with little difficulty. The rescued laymen run off, they shout thanks but stick around for little else. | The %companyname% isn\'t going to stand for such atrocities this day. You order the mercenaries to kill the few unprepared soldiers of %noblehouse% and they do as much in speedy fashion. Rescued, the peasants and laymen give thanks. You simply tell them to get lost as clearly this land is no longer safe for anyone. | Against better judgment, you involve yourself. The men of %companyname% are ordered forth. Unprepared for an actual fight, the soldiers of %noblehouse% are cut down in a quick, sometimes screaming order. The peasants and common folks gives thanks for the rescue before hurrying off.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "A good deed was done here this day.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Killed some of their men");
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.5, "Helped save some peasants");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_79.png[/img]{You order your men to save the poor peasants, but the soldiers of %noblehouse% are ready for you. Not in arms - no, they do not have enough men for that - but in a couple of nearby horses. They ride off, no doubt to ruin your reputation with the nobility, but who gives a damn. The laymen, by comparison, are forever grateful. | You order the man of %companyname% to make quick work of the soldiers. A few are quickly dispatched, but the lieutenant manages to field a horse and take off. It\'s a very quick horse. You doubt you\'d be able to catch it if you had a horse yourself, which you do not. The rescued peasants are very grateful, though that probably won\'t help your reputation with the nobility of %noblehouse% now. | You failed to spot a few horses idling nearby. While a few soldiers are quickly cut down, your mercenaries can\'t catch up to the lieutenant who mounts up and rides off in a cloud of dust and, in your case, soured reputation with the nobility. Not that you\'ve two shits to give what they think. The laymen, by comparison, are almost crying in their thanks. You tell them to leave and fast. Who knows what dangers or ill intentions roam the lands these days.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Ah well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, "Attacked some of their men");
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.5, "Helped save some peasants");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates = [];

		foreach( h in nobleHouses )
		{
			if (h.isAlliedWithPlayer())
			{
				candidates.push(h);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
	}

});


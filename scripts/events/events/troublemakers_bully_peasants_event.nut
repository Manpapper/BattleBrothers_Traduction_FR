this.troublemakers_bully_peasants_event <- this.inherit("scripts/events/event", {
	m = {
		Troublemaker = null,
		Peacekeeper = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.troublemakers_bully_peasants";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%Entering %townname%, it isn\'t long until %troublemaker% is bothering the locals. He\'s slapping buckets out of their hands and kicking women into the mud. When an old man confronts him, the sellsword draws out his weapon. Other peasants beg that you put a stop to this at once.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I don\'t have time for this.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "You need to stop this, %troublemaker%. It reflects badly on the company.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Put the peasants in their place and search their homes for valuables!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Peacekeeper != null)
				{
					this.Options.push({
						Text = "%peacekeeperfull%, see if you can calm %troublemaker% with your wisdom.",
						function getResult( _event )
						{
							return this.Math.rand(1, 100) <= 70 ? "E" : "F";
						}

					});
				}

				this.World.Assets.addMoralReputation(-1);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "One of your men caused havoc in town");
				this.Characters.push(_event.m.Troublemaker.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%townImage%You shrug. %troublemaker% doesn\'t run the old man through, but he does threaten to, raising the weapon on high. When the old man cowers, the sellsword delivers a punch that knocks the elderly right out, his teeth peppering the muck like spits of white rain. This brings a few jeers from the villagers, but they know not to contest your presence any further.\n\nA few men drag the elder away while children boo and women hiss. One child even runs up to the sellsword, pointing at him as he yells \'he\'s a bad man.\' %troublemaker% shrugs as he sheathes his weapon.%SPEECH_ON%And yet the bad man still stands. Would you also like a taste of the mud, little one?%SPEECH_OFF%The kid quickly runs off.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Now on to things that actually matter...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.World.Assets.addMoralReputation(-3);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "One of your men caused havoc in town");
				_event.m.Troublemaker.improveMood(1.0, "Bullied the peasantfolk");

				if (_event.m.Troublemaker.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Troublemaker.getMoodState()],
						text = _event.m.Troublemaker.getName() + this.Const.MoodStateEvent[_event.m.Troublemaker.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%townImage%As %troublemaker% raises his weapon on high, you grab him by the forearm and bring it back down. He swings around, looking at you sternly. The cowering old man backs off, soon collected by caretakers that shuttle him back inside before he gets himself hurt.\n\nA few other peasants linger around, watching with keen interest. You tell the sellsword to back down. He\'s paid to fight who you deem he should fight, not a bunch of peasants who are minding their own.\n\n As %troublemaker% glances around, you realize you\'ve left him no \'out\' that will save face. In his eyes, there is a look that says he\'s about to kill you. It\'d be the end of him, but he\'d go out with his suicidal pride intact. But the look fades, and embarrassment and humiliation take its place. He sheathes his weapon, spits, and remarks that he was only having some fun.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Save it for when we\'re paid to do this.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				_event.m.Troublemaker.worsenMood(2.0, "Was humiliated in front of the company");

				if (_event.m.Troublemaker.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Troublemaker.getMoodState()],
						text = _event.m.Troublemaker.getName() + this.Const.MoodStateEvent[_event.m.Troublemaker.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_30.png[/img]You look at the peasant who hailed you down.%SPEECH_ON%Who are you, peasant, to tell me or my men what to do?%SPEECH_OFF%The man takes a step back, stammering something about \'only trying to help.\' Laughing, you tell your men to take what they want. If this village has no respect for the authority of armed men, then you will have to teach them that respect.\n\nWomen scream and bundle up their children as the order leaves your tongue. They run off and a few men join them. Other men stay behind, protecting their homes, but the %companyname% makes quick work of their modest defenses. Your mercenaries are soon pillaging each and every home, taking what they can with roaring laughter. Today is a good day.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'ll teach them.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.World.Assets.addMoralReputation(-5);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "You pillaged the town");
				local money = this.Math.rand(100, 500);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getBackground().isCombatBackground())
					{
						bro.improveMood(1.0, "Enjoyed raiding and pillaging");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(1.0, "Was appalled by the company\'s conduct");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
			ID = "E",
			Text = "%townImage%%peacekeeperfull% places himself between %troublemaker% and the old man. He shakes his head \'no\' in a very modest fashion, but you can\'t help but notice that his swordhand is also on the pommel of his weapon. The troublemaking sellsword briefly seems to consider cutting the man down, but then a smile snaps across his face. He laughs as he sheathes his weapon.%SPEECH_ON%Only having a bit of fun, my brother.%SPEECH_OFF%The peasants slowly start going about their business again, but they are wary and stare side-eyed at your men for the rest of your duration in %townname%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.Characters.push(_event.m.Peacekeeper.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "%townImage%%peacekeeperfull% steps in between %troublemaker% and the old man. The troublemaking sellsword laughs and sheathes his weapon. He turns back to the rest of the company, grinning and shaking his head, but you notice that this smile quickly fades. Before you can say anything, %troublemaker% wheels a fist back around and knocks %peacekeeper% out cold.\n\n Well, that\'s one way to mollify a mercenary.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I might have to do something about discipline in this company.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Troublemaker.getImagePath());
				this.Characters.push(_event.m.Peacekeeper.getImagePath());
				local injury = _event.m.Peacekeeper.addInjury(this.Const.Injury.Knockout);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Peacekeeper.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Peacekeeper.worsenMood(2.0, "Was humiliated in front of the company");

				if (_event.m.Peacekeeper.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Peacekeeper.getMoodState()],
						text = _event.m.Peacekeeper.getName() + this.Const.MoodStateEvent[_event.m.Peacekeeper.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_troublemaker = [];
		local candidates_peacekeeper = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
			{
				candidates_troublemaker.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidates_peacekeeper.push(bro);
			}
		}

		if (candidates_troublemaker.len() == 0)
		{
			return;
		}

		this.m.Troublemaker = candidates_troublemaker[this.Math.rand(0, candidates_troublemaker.len() - 1)];

		if (candidates_peacekeeper.len() != 0)
		{
			this.m.Peacekeeper = candidates_peacekeeper[this.Math.rand(0, candidates_peacekeeper.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = candidates_troublemaker.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"troublemaker",
			this.m.Troublemaker.getName()
		]);
		_vars.push([
			"peacekeeper",
			this.m.Peacekeeper != null ? this.m.Peacekeeper.getNameOnly() : ""
		]);
		_vars.push([
			"peacekeeperfull",
			this.m.Peacekeeper != null ? this.m.Peacekeeper.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Troublemaker = null;
		this.m.Peacekeeper = null;
		this.m.Town = null;
	}

});


this.deserter_in_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.deserter_in_forest";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]While trundling through the forest, birds suddenly scatter into the sky, shaking the trees and branches with the very frightful urgency of their leaving. Not a moment later does a man come barreling through a bush, looking more flash flood than flesh and blood. He seizes up, this earthen golem, and begs you to hide him.%SPEECH_ON%Look, I\'ll be perfectly honest. I\'m a deserter. That\'s that. I didn\'t, I mean, alright I don\'t really have a defense. But look, what are you? Mercenaries? Great! Hide me and I\'ll fight for you to the end of time!%SPEECH_OFF%Halfway through his pleading spiel, you hear dogs barking in the distance. The man instinctively hides away into an arboreal cubby, quickly covering himself with dirt. He nods as if to say you\'ve already come to an agreement.\n\n Bounty hunters come through the tree line, their dogs already sniffing around. Their lieutenant looks around.%SPEECH_ON%Don\'t even try to fool me, sellsword. I know that deserter came this way. Two hundred crowns for his head. Where is he?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "He\'s right there, take him.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "What? Who? Where?",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_25.png[/img]You spit and shake your head.%SPEECH_ON%I\'ve not the faintest farkin\' clue what you\'re talking about, bounty hunter.%SPEECH_OFF%The lieutenant eyes you up, staring you down with an old man\'s wisdom.%SPEECH_ON%Alright, mercenary. So be it. I know you\'re lying, but there\'s not much I can do about it.%SPEECH_OFF%The bounty hunter looses a sharp whistle and orders his band of men forth. The dogs bark briefly at the cubby where the deserter had hidden. Laughing, the lieutenant mockingly wishes you the best.\n\n With his hunters gone, the deserter emerges.%SPEECH_ON%Thank you, mercenary. I owe you my life! You\'ll not regret this, not ever!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I better not reget this. Welcome to the company.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Keep on running. We have no place for a deserter.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"deserter_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "You found %name% the deserter being chased through the forest. Though bounty hunters were hot on his trail, you elected to defend him and for that he swore an oath to you.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_25.png[/img]You nod to where the deserter is hiding. He must have kept one distrusting eye on you because he immediately jumps out of the hole and goes fleeing. The dogs run him down with ease, glomming onto him with caninal ferocity and dragging his screaming ass to the ground. Before you can even so much as laugh, the bounty hunter puts a bag of crowns into your palm.%SPEECH_ON%That\'s half my cut, but without the happenstance of your being here, I\'m not sure we would have caught that wily bastard.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Just doing my part.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(200);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]200[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.deserter")
					{
						bro.worsenMood(0.5, "You gave up a deserter to bounty hunters");

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
	}

	function onUpdateScore()
	{
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});


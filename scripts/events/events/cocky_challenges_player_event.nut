this.cocky_challenges_player_event <- this.inherit("scripts/events/event", {
	m = {
		Cocky = null
	},
	function create()
	{
		this.m.ID = "event.cocky_challenges_player";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]While joining the company at a campfire, %cocky% stands up and speaks with reddened face.%SPEECH_ON%I don\'t know about the rest of you sad clods, but I think I could run this camp better than anyone! Especially better than him!%SPEECH_OFF%He points a finger at you.\n\nYou take a seat. The men are staring at you, waiting for a response.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'re totally right. You should be in charge.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Time to cut you down to size.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "I\'m in charge here! This is my company!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]You kick your feet out, legs akimbo, and place your hands in your lap. Nodding, you speak to the man.%SPEECH_ON%Alright, %cocky%. You\'re the man now. You gotta count inventory every morning and night. I know you can\'t count for shite, but you\'ll learn. Don\'t want these fine men going into battle a few arrows short.%SPEECH_OFF%You throw a hand out to a few of the tents.%SPEECH_ON%You\'ll also need to keep a steady count on your people. They\'re not easily controlled, to which you might find some irony - or not.%SPEECH_OFF%Looking at your hands, which have grown calloused and bruised over the days, you keep talking.%SPEECH_ON%And you\'ll need to bark orders that aren\'t just there to be heard - but there to keep men alive and breathing. You know, like yourself and those who sit around you. So yeah, take the job, %cocky%. It\'s yours.%SPEECH_OFF%As soon as you finish, a group of brothers immediately stands up and begs for you to remain in charge. %cocky%, seeing this, backs down and slinks away as yells of \'you\'re in charge!\' fill the air.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'re damn right.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getMoodState() < this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Gained confidence in your leadership");

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
			Text = "[img]gfx/ui/events/event_26.png[/img]The campfire crackles an orange glow across your face. Nodding, you stand up and walk up to %cocky%. He takes a step back, but not before you throw a hand out and grab him by the shoulder. You quickly step forward, scissoring a leg back behind his knee, buckling him and throwing him onto his back. You follow him to the ground and there plant one hand around his throat while the other points an accusing finger.%SPEECH_ON%You\'re a good man %cocky%, but a stupid one, too. Now, I see some of y\'all aren\'t happy about how things are going, but let me remind you that you are all still alive! If someone like %cocky% was in charge you\'d all be dead in a fortnight!%SPEECH_OFF%Standing up, you actually help %cocky% to his feet. He sneers at you and takes off, kicking a stack of barrels over as he leaves. A wave of pain eminates from where the arrow hit you not long ago, but you clench your teeth and try not to give away anything as you sit down again.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Still got it!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				_event.m.Cocky.worsenMood(3.0, "Felt humiliated in front of the company");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cocky.getMoodState()],
					text = _event.m.Cocky.getName() + this.Const.MoodStateEvent[_event.m.Cocky.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_26.png[/img]You immediately jump back to your feet and begin shouting.%SPEECH_ON%I\'m the one in charge here! Me! Who has the money? Me! If it weren\'t for me, none of y\'all would even be here! You\'d still be in the pits of whatever old lives you had! You should be groveling before my feet for the opportunities I have provided! And %cocky%, if you contest me again I swear to the gods I will have you flogged and hanged, understand?%SPEECH_OFF%The outburst instantly quiets the camp. %cocky% nods and backs away. A few of the men murmur between themselves as you take your seat again.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That went pretty well, no?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(1.0, "Lost confidence in your leadership");

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
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];
		local grumpy = 0;

		foreach( bro in brothers )
		{
			if (bro.getMoodState() < this.Const.MoodState.Neutral)
			{
				grumpy = ++grumpy;

				if (bro.getSkills().hasSkill("trait.cocky"))
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() == 0 || grumpy < 3)
		{
			return;
		}

		this.m.Cocky = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 3 + grumpy * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cocky",
			this.m.Cocky.getName()
		]);
	}

	function onClear()
	{
		this.m.Cocky = null;
	}

});


this.disowned_noble_reminisces_event <- this.inherit("scripts/events/event", {
	m = {
		Disowned = null
	},
	function create()
	{
		this.m.ID = "event.disowned_noble_reminisces";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]You find %disowned% sitting by himself outside the camp. As the jeers and cheers of the men around the campfire crackle behind you, you approach the man and ask what he\'s sulking for. He shrugs.%SPEECH_ON%Not sulking, sir, just thinking. Though I suppose one could be easily mistaken for the other.%SPEECH_OFF%Chuckling, he offers a bit of his drink, which you take. Settling down beside him, you ask what it is he is \'thinking\' about. The disowned nobleman shrugs again.%SPEECH_ON%Ahh, nothing really. Just thinking about home. I\'m a long ways away from it now, and the last I remember of it isn\'t exactly the best, yet I still find myself wishing to be there now and again. Homesick for a land that thinks me a sort of noble sickness, go figure.%SPEECH_OFF%You hand him back to his drink as he probably needs it more than you. While you\'re still clearheaded, you try and speak your mind...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fark the old home, you\'re with us now.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "It\'s alright to think of home now and again.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				_event.m.Disowned.getFlags().set("disowned_noble_reminisces", true);
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]You speak.%SPEECH_ON%Where you\'re from is a house, not a home. You yearn for a different place in a different time, when you\'re in this place, right here, right now. The %companyname% looks after you, and you it, and only together will we persevere.%SPEECH_OFF%The man stares into his drink for a time. He chuckles, sips, and wipes the froth away.%SPEECH_ON%Yeah, I suppose that\'s one way to look at it. Thank you, captain.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Anytime.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				local resolve = this.Math.rand(1, 3);
				_event.m.Disowned.getBaseProperties().Bravery += resolve;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Disowned.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Détermination"
				});
				_event.m.Disowned.improveMood(1.0, "Had a good talk with you");

				if (_event.m.Disowned.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Disowned.getMoodState()],
						text = _event.m.Disowned.getName() + this.Const.MoodStateEvent[_event.m.Disowned.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_26.png[/img]You clap the man on his shoulder and speak.%SPEECH_ON%Hey, thinking of the old is good for the soul, even if it\'s through a thicket of shit and cruelty and evil and all else that makes any man stay up at night. But it\'s only good for a time. You look at the past, you acknowledge it, and then you move on. You have to be sure to only visit the past, not dwell in it. Everyone here has a past, %disowned%, and in that respect you will never be alone.%SPEECH_OFF%The disowned nobleman stares at the ground for a time. He slowly starts to nod.%SPEECH_ON%Yeah, yeah, that\'s right. I guess a part of me was worried that I was genuinely wanting to return there. I was picturing it with the hearth alight, smoke out of the chimney, soft candlelight beyond the windows, and my family there awaiting me. I was ignoring the locked door, the guard dogs squatting outside, and those I love telling me to never come back lest it\'s in a box to bury far beneath the earth. I wasn\'t thinking of my past so much as dreaming of it, and I think you\'ve helped me realize that, captain. Thank you. I know that, one day, I shan\'t have to dream about the %companyname%, but instead remember it clearly and fondly.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The company appreciates it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				local resolve = this.Math.rand(1, 3);
				_event.m.Disowned.getBaseProperties().Bravery += resolve;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Disowned.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Détermination"
				});
				_event.m.Disowned.improveMood(1.0, "Had a good talk with you");

				if (_event.m.Disowned.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Disowned.getMoodState()],
						text = _event.m.Disowned.getName() + this.Const.MoodStateEvent[_event.m.Disowned.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 5 && bro.getBackground().getID() == "background.disowned_noble" && !bro.getFlags().get("disowned_noble_reminisces"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Disowned = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"disowned",
			this.m.Disowned.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Disowned = null;
	}

});


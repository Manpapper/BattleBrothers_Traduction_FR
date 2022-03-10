this.anatomist_demonology_book_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_demonology_book";
		this.m.Title = "During camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{You find %anatomist% scouring a red book. He closes the book and sighs.%SPEECH_ON%As an anatomist, I am compelled to think that monsters, as you laymen would call them, do not merely appear for the sake of appearance. Instead, everything has a purpose. In a sense, and through the old gods, we can trust that these elements have in actuality a divine purpose. Yet, some of my peers have found bones of creatures that have not once been seen in the flesh. It appears that these entities have disappeared entirely. It begs the question: does such evidence entail that we, ourselves, will one day disappear? An affirmative on that front suggests, then, that the divinities above are not actually weighing their visions in our favor. We walk under the gaze of mere happenstance. A terrible thought, indeed.%SPEECH_OFF%Curious, you ask what these mysterious monsters looked like. The anatomist opens the red book and shows you a drawing.%SPEECH_ON%They are quite similar to humans, but larger with implied bulkiness around the neck and shoulders. The skulls carry these notches, similar to that of horns, and the spinal columns have extra vertebrae with three of them near the top broadening out, as if they were holding onto something, something that would extend far from the body. See? Here? The back is almost like a bony mantle.%SPEECH_OFF%Interesting. You ask the anatomist if he\'s seen one of these skeletons for himself, and he says no. He says he\'s only seen it in the text. You ask if he paid for this text and he says he did. You ask him if perhaps the notion of old, bizarre monsters was but a mere sales pitch to get him to buy a book of bullshit. The anatomist ponders for a time. He nods and agrees that it is likely that he has purchased a spoof. He grows angrier by the second and suddenly throws the tome into the campfire, pledging himself to more earthly studies going forward. He thanks you for your ability to cut through the nonsense and eminence fronts this world puts on.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Can\'t believe everything you read.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.worsenMood(0.5, "Wasted time reading a sham demonology book");
				_event.m.Anatomist.improveMood(1.0, "You helped him realize his demonology book was a farce");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});


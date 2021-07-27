this.fisherman_tells_story_event <- this.inherit("scripts/events/event", {
	m = {
		Fisherman = null
	},
	function create()
	{
		this.m.ID = "event.fisherman_tells_story";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%fisherman%, the ol\' fisherman, regals the company with tales of his fishing days.%SPEECH_ON%{T\'was this big. I swear on me mum! Fish so big that when I yanked it from the waters the whole river dried a foot! | The ocean is a beast, aye, and the skies above its master, the winds its leash, and we men the fleas. | Lost I was! A summer adrift, the whole boat run through with hunting waters, each wave having taken a sailor for itself until only I remained, aye, aye! Tis the truth! By autumn, I saw land again, and so happy I was to see the trees and the mountains and the birds that dwell above both that I smashed my ship right into the rocks and kissed the sands as debris drifted about me. T\'was the happiest day of m\'life. | Never seen a great white whale before, but a green one? Aye. Wore a coat of moss, a stolen land fur if nothing else. We hunted it down with spears and ol\' sailor spirit. Alas, it realized we were on it when %randomname% - a man with the finest harpoon aim there is - struck it in the blowhole. I did not know a whale could turn \'round so quickly, but it did, and it made short work of our ship and drowned a number of sailors in a fit of vengenace. | I once caught a bass about, yeigh, big. Can you believe that? Alright, it was this big. Okay, maybe this big. Alright I\'ve never caught a bass. Fine! I\'ve never even seen a bass! I just know they\'re out there! Leave me alone you land lovers! I fish the big seas, dammit! I know nothing of your silly ponds. Except bass, of course, I know about them.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sounds fishy to me.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fisherman.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

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
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.fisherman")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Fisherman = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fisherman",
			this.m.Fisherman.getName()
		]);
	}

	function onClear()
	{
		this.m.Fisherman = null;
	}

});


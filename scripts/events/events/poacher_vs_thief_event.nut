this.poacher_vs_thief_event <- this.inherit("scripts/events/event", {
	m = {
		Poacher = null,
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.poacher_vs_thief";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]You walk out of your tent to see %poacher% and %thief% regaling one another with stories. You\'re not sure what a poacher and a thief would have in common, but they seem to be having a good time. Laughing, %poacher% gives another story.%SPEECH_ON%One time, I was out in this pithy nobleman\'s lands hunting this buck. Shooting the damned deer was the easy part. In the middle of field dressing it, I hear hooves beating over the earth. So run a rope up a tree, tie the carcass to it, and haul that sucker up there. No more than a minute later, badda-badda-badda, there\'s the nobleman with the constable and a retinue of lawmen.%SPEECH_OFF%%thief% raises an eyebrow.%SPEECH_ON%That\'s a tight spot, sir.%SPEECH_OFF%The poacher nods.%SPEECH_ON%Tighter than a cross-legged virgin it was. So this nobleman comes wandering just underneath me and sees all the blood. He starts barking that I come out and turn myself in. I had no intention of doing that, but unfortunately, the goddam buck starts slipping. I reach out for it and I suppose the branch couldn\'t take no more and snapped. The nobleman looks up just in time to get splattered by the belly of this deer, meanwhile I\'m falling to certain death until the damned rope snags my foot and hangs me upside down before my makers. I give a bit of a wave, \'hey fellas, don\'t mean to barge in like this.\'%SPEECH_OFF%The thief laughs, but his face is a bit concerned. %poacher% waves him off.%SPEECH_ON%Oh, they had a sense of humor about it, thank the old gods. I spent a short six months in a dark pit. Nothing too bad, really.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Right.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Poacher.getImagePath());
				this.Characters.push(_event.m.Thief.getImagePath());
				_event.m.Poacher.improveMood(1.0, "Bonded with " + _event.m.Thief.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Poacher.getMoodState()],
					text = _event.m.Poacher.getName() + this.Const.MoodStateEvent[_event.m.Poacher.getMoodState()]
				});
				_event.m.Thief.improveMood(1.0, "Bonded with " + _event.m.Poacher.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Thief.getMoodState()],
					text = _event.m.Thief.getName() + this.Const.MoodStateEvent[_event.m.Thief.getMoodState()]
				});
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

		local poacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.poacher")
			{
				poacher_candidates.push(bro);
			}
		}

		if (poacher_candidates.len() == 0)
		{
			return;
		}

		local thief_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.thief")
			{
				thief_candidates.push(bro);
			}
		}

		if (thief_candidates.len() == 0)
		{
			return;
		}

		this.m.Poacher = poacher_candidates[this.Math.rand(0, poacher_candidates.len() - 1)];
		this.m.Thief = thief_candidates[this.Math.rand(0, thief_candidates.len() - 1)];
		this.m.Score = (poacher_candidates.len() + thief_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"poacher",
			this.m.Poacher.getNameOnly()
		]);
		_vars.push([
			"thief",
			this.m.Thief.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Poacher = null;
		this.m.Thief = null;
	}

});


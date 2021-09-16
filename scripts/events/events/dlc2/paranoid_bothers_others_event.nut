this.paranoid_bothers_others_event <- this.inherit("scripts/events/event", {
	m = {
		Paranoid = null
	},
	function create()
	{
		this.m.ID = "event.paranoid_bothers_others";
		this.m.Title = "During camp...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{You hear a commotion and go to find %paranoid% waving a weapon at his fellow sellswords.%SPEECH_ON%I know who you is, and I know who you ain\'t, and what you ain\'t are friends of mine!%SPEECH_OFF%%randombrother% looks over and shrugs.%SPEECH_ON%Never said you was my friend.%SPEECH_OFF%The paranoid mercenary barks on anyway, demanding everyone keep a good distance away or he\'ll cut them. You manage to calm the man down, mostly by explaining what his daily rate is and how he\'ll struggle without it, but it\'s no doubt a short term solution. | You find %paranoid% the increasingly paranoid sellsword huddled by himself with his hands around his knees. Despite the infantile posture, his eyes are steeled and he\'s keeping careful watch of everything. When you ask him how he\'s doing, he simply laughs.%SPEECH_ON%I dunno, sir, just surrounded by a mob of money-driven assholes who will stab me in the back whenever it suits them.%SPEECH_OFF%In a way, you understand where he\'s coming from, but you hope this mood is not contagious with the rest of the company.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Stop being so paranoid.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Paranoid.getImagePath());
				_event.m.Paranoid.worsenMood(0.5, "Is paranoid about his comrades");

				if (_event.m.Paranoid.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Paranoid.getMoodState()],
						text = _event.m.Paranoid.getName() + this.Const.MoodStateEvent[_event.m.Paranoid.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.paranoid"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Paranoid = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"paranoid",
			this.m.Paranoid.getName()
		]);
	}

	function onClear()
	{
		this.m.Paranoid = null;
	}

});


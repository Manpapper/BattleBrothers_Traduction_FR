this.anatomist_dissects_beetles_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_dissects_beetles";
		this.m.Title = "During camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{You find %anatomist% crouching over a piece of log. He\'s got a trio of beetles laid out. One has a needle pinning it to the wood, its little legs pedaling haplessly in the air. Another is nothing but a bodied husk, its legs removed and set beside it. The last is in a small tin of water with a stone weighing it down. %anatomist% shakes his head.%SPEECH_ON%The duress these creatures can undergo is quite impressive. Physical damage does not allude to destruction as it does with us. Take these three, for example: pierced, dismembered, and drowning. Yet they all live. The efficiency is something else, wouldn\'t you agree?%SPEECH_OFF%Sure. You ask him where he even got all those beetles. He shrugs.%SPEECH_ON%They crawl all over us when we\'re sleeping. I just happen to stay up to catch them in the act. This underwater one, for example, I caught pecking at your ear opening.%SPEECH_OFF%You tell him to continue his research and to capture as many beetles as he can.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I need to start sleeping with a helmet on.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.improveMood(1.0, "Fascinated with beetles");

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


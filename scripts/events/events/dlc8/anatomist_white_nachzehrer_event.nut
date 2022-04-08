this.anatomist_white_nachzehrer_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_white_nachzehrer";
		this.m.Title = "During camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist% hasn\'t been writing in his journals so much lately. When he does, the pen only seems to tap the pages now and again without scribbling anything of import. You inquire as to what has him so bothered. Somber in tone, he says that his primary hope in coming out to these lands was to find the White Nachzehrer, a monster that\'s larger than any of its kind. You tell him that you\'ve slain a few nachs that were quite rotund, but the anatomist shakes his head.%SPEECH_ON%Per the literature, this nachzehrer cannot be felled by any man for it has grown to such proportions that its flesh has turned white, and it is covered in great ridges of calloused skin that no steel can penetrate. It was spotted roaming these lands and I\'d hoped to find it, but it seems that, perhaps, I have been led astray. Maybe the anatomists who told me this tale have put me on a great snipe hunt. I worry, scapegrace, that I have been made a fool of.%SPEECH_OFF%You tell him that this creature sounds like the \'king\' of nachzehrers, and if that\'s the case then perhaps it no longer roams, but instead uses a small army of lesser nachzehrers to do its bidding for it. The anatomist smiles.%SPEECH_ON%Truly, this may be the case! Of course it took the scrying eye of the laity, so used to staring up at our purpled suzerains, to bring this to my clouded attention!%SPEECH_OFF%Agreeing with yourself further, you note that perhaps the \'White Nachzehrer\' is so pale cause it doesn\'t get much sun. The anatomist laughs.%SPEECH_ON%Please, scapegrace, the first observation was sufficient input from your side.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Don\'t let your White Nach\' earn you a black eye, bloody loggerhead.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.improveMood(1.5, "Had his faith in the existence of the white nachzehrer renewed");

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


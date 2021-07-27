this.cripple_pep_talk_event <- this.inherit("scripts/events/event", {
	m = {
		Cripple = null,
		Veteran = null
	},
	function create()
	{
		this.m.ID = "event.cripple_pep_talk";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]%cripple% the cripple asks how %veteran% does it. The veteran raises an eyebrow.%SPEECH_ON%Do what?%SPEECH_OFF%The cripple bounces his head around as he figuratively beats around the bush.%SPEECH_ON%You know, it. Fight. Every time I get out there, I just think I\'m not up to it, as though I were dragging you fellas down.%SPEECH_OFF%%veteran% laughs.%SPEECH_ON%Aye, I get what you mean. A cripple ain\'t fit for sellswording. But is that who you are? Just a cripple? Or are ye a man? You can choose to let your wobbles and ungainliness define who you are, or you can make your own path, as crooked and hobbled it may be.%SPEECH_OFF%Nodding, %cripple%\'s face starts to glow.%SPEECH_ON%You\'re right. I\'m not all that I could be and I got the body of a dying nun, but no man will put in more effort than I!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well said.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cripple.getImagePath());
				this.Characters.push(_event.m.Veteran.getImagePath());
				local resolve = this.Math.rand(1, 3);
				local fatigue = this.Math.rand(1, 3);
				local initiative = this.Math.rand(1, 3);
				_event.m.Cripple.getBaseProperties().Bravery += resolve;
				_event.m.Cripple.getBaseProperties().Stamina += fatigue;
				_event.m.Cripple.getBaseProperties().Initiative += initiative;
				_event.m.Cripple.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Cripple.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Détermination"
					},
					{
						id = 17,
						icon = "ui/icons/fatigue.png",
						text = _event.m.Cripple.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + fatigue + "[/color] Max Fatigue"
					},
					{
						id = 17,
						icon = "ui/icons/initiative.png",
						text = _event.m.Cripple.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] Initiative"
					}
				];
				_event.m.Cripple.improveMood(2.0, "Was motivated by " + _event.m.Veteran.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cripple.getMoodState()],
					text = _event.m.Cripple.getName() + this.Const.MoodStateEvent[_event.m.Cripple.getMoodState()]
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

		local cripple_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.cripple")
			{
				cripple_candidates.push(bro);
			}
		}

		if (cripple_candidates.len() == 0)
		{
			return;
		}

		local veteran_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 5)
			{
				veteran_candidates.push(bro);
			}
		}

		if (veteran_candidates.len() == 0)
		{
			return;
		}

		this.m.Cripple = cripple_candidates[this.Math.rand(0, cripple_candidates.len() - 1)];
		this.m.Veteran = veteran_candidates[this.Math.rand(0, veteran_candidates.len() - 1)];
		this.m.Score = cripple_candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cripple",
			this.m.Cripple.getNameOnly()
		]);
		_vars.push([
			"veteran",
			this.m.Veteran.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cripple = null;
		this.m.Veteran = null;
	}

});


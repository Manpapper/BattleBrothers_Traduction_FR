this.eunuch_vs_insecure_event <- this.inherit("scripts/events/event", {
	m = {
		Eunuch = null,
		Insecure = null
	},
	function create()
	{
		this.m.ID = "event.eunuch_vs_insecure";
		this.m.Title = "During camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%eunuch% the eunuch and %insecure% the, rather obviously so, insecure sellsword are sitting and having a chat. The eunuch shakes his head.%SPEECH_ON%Your timidity makes no sense to me, %insecure%. Look at me. I don\'t even have the only reason to live as a man. When the wind blows against my pants, all I feel is cloth against my inner thigh. Do you have any idea how awfully strange that feels? But do you see me complaining? No. When half the company goes to the local whorehouse and dogs a broad, do you see me sitting in a corner crying? Of course not!%SPEECH_OFF%%insecure% nods.%SPEECH_ON%You know what, you dickless bastard, you\'re right. If you can pound air and be happy about it, then I can not be so afraid and small.%SPEECH_OFF%The insecure sellsword gets up and leaves. %eunuch% purses his lips.%SPEECH_ON%Pound air? Did this dumb farker just tell me I pound air? Hey, hey! I\'ll pound yer mother!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Don\'t let his insecurity rub off on you, %eunuch%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Insecure.getImagePath());
				this.Characters.push(_event.m.Eunuch.getImagePath());
				_event.m.Insecure.getSkills().removeByID("trait.insecure");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_03.png",
						text = _event.m.Insecure.getName() + " is no longer insecure"
					}
				];
				_event.m.Eunuch.worsenMood(1.0, "Was disrespected");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Eunuch.getMoodState()],
					text = _event.m.Eunuch.getName() + this.Const.MoodStateEvent[_event.m.Eunuch.getMoodState()]
				});
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
		local eunuch_candidates = [];
		local insecure_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.eunuch" && bro.getSkills().hasSkill("trait.insecure"))
			{
				insecure_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.eunuch" && bro.getLevel() >= 4 && !bro.getSkills().hasSkill("trait.insecure"))
			{
				eunuch_candidates.push(bro);
			}
		}

		if (insecure_candidates.len() == 0 || eunuch_candidates.len() == 0)
		{
			return;
		}

		this.m.Eunuch = eunuch_candidates[this.Math.rand(0, eunuch_candidates.len() - 1)];
		this.m.Insecure = insecure_candidates[this.Math.rand(0, insecure_candidates.len() - 1)];
		this.m.Score = 5 * insecure_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"eunuch",
			this.m.Eunuch.getNameOnly()
		]);
		_vars.push([
			"insecure",
			this.m.Insecure.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Eunuch = null;
		this.m.Insecure = null;
	}

});


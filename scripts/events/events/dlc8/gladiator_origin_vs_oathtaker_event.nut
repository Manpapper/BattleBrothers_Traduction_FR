this.gladiator_origin_vs_oathtaker_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator = null,
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.gladiator_origin_vs_oathtaker";
		this.m.Title = "During camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%oathtaker% and %gladiator% are ruminating over the proper use of weaponry. The Oathtaker is inclined to believe that every swing of the sword is powered by an intent to do good. The gladiator retorts that keeping oneself alive is the greatest good, such that the start of a sword swing already has good intentions, therefore its finality must not be for oneself, but instead for the crowd that is watching. Raising an eyebrow, %oathtaker% says,%SPEECH_ON%You think battles are shows, gladiator?%SPEECH_OFF%%gladiator% grins as he leans in.%SPEECH_ON%Life itself is a show, Oathtaker, and I\'m its greatest star.%SPEECH_OFF%You regret listening in on the conversation.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s a horror show, truly.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				_event.m.Gladiator.improveMood(1.0, "Assured of his importance in the world");

				if (_event.m.Gladiator.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator.getMoodState()],
						text = _event.m.Gladiator.getName() + this.Const.MoodStateEvent[_event.m.Gladiator.getMoodState()]
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

		if (this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local gladiator_candidates = [];
		local oathtaker_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				oathtaker_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter"))
			{
				gladiator_candidates.push(bro);
			}
		}

		if (oathtaker_candidates.len() == 0 || gladiator_candidates.len() == 0)
		{
			return;
		}

		this.m.Gladiator = gladiator_candidates[this.Math.rand(0, gladiator_candidates.len() - 1)];
		this.m.Oathtaker = oathtaker_candidates[this.Math.rand(0, oathtaker_candidates.len() - 1)];
		this.m.Score = 3 * oathtaker_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gladiator",
			this.m.Gladiator.getName()
		]);
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
	}

	function onClear()
	{
		this.m.Gladiator = null;
		this.m.Oathtaker = null;
	}

});


this.gladiator_origin_vs_oathtaker_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator = null,
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.gladiator_origin_vs_oathtaker";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%oathtaker% et %gladiator% réfléchissent sur l\'utilisation appropriée de leurs armes. L\'Oathtaker est tenté de croire que chaque coup d\'épée est motivé par l\'intention de faire le bien. Le gladiateur rétorque que se maintenir en vie est la principale priorité, de sorte que le premier coup porté avec une épée est synonyme de bonnes intentions et que sa finalité ne doit pas être pour soi-même, mais plutôt pour la foule qui regarde. En haussant un sourcil, %oathtaker% dit,%SPEECH_ON% Vous pensez que les batailles sont de simples spectacles, gladiateur?%SPEECH_OFF%%gladiator% sourit en se penchant vers lui.%SPEECH_ON% La vie elle-même est un spectacle, Oathtaker, et je suis sa plus grande star.%SPEECH_OFF% Vous regrettez d\'avoir écouté cette conversation.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est un spectacle horrible, vraiment.",
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


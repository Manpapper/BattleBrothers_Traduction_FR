this.bright_vs_dumb_event <- this.inherit("scripts/events/event", {
	m = {
		Dumb = null,
		Bright = null
	},
	function create()
	{
		this.m.ID = "event.bright_vs_dumb";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_15.png[/img]%dumb% est peut-être l\'un des individus les plus stupides que vous ayez jamais rencontré mais, pendant un bref instant, il semble que %bright% s\'en sorte et lui enseigne une chose ou deux sur la pensée critique et la mémorisation. Vous les regardez s\'asseoir ensemble et examiner des parchemins. Tu ne sais pas trop où l\'homme intelligent a pu se procurer de tels documents, mais le sot y prête certainement beaucoup d\'attention.\n\nPendant que vous regardez, %dumb% pose des questions plutôt profondes. Des questions sur la terre et sa relation avec les gens, et sur le ciel et sa relation avec les oiseaux. Vous réalisez peu à peu que cet idiot se contente de jeter un coup d\'oeil autour de lui et de décrire ce qu\'il voit en utilisant le langage \"inquisiteur\" que %bright% lui a appris, à savoir en ajoutant une question à la fin de chaque phrase. Quand ils ont terminé, %bright% vient vers vous avec un sourire.%SPEECH_ON%Je pense qu\'on arrive vraiment à quelque chose avec lui. Il apprend, vous savez ? Avec des élèves comme ça, il faut juste être patient et prendre son temps.%SPEECH_OFF%Un peu plus loin, %dumb% frappe des fourmis avec une pierre. Vous hochez simplement la tête et laissez %bright% vivre le plus grand rêve de chaque professeur..",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tu l\'as finalement atteint.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bright.getImagePath());
				this.Characters.push(_event.m.Dumb.getImagePath());
				_event.m.Bright.improveMood(1.0, "A appris à " + _event.m.Dumb.getName() + " quelque chose");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Bright.getMoodState()],
					text = _event.m.Bright.getName() + this.Const.MoodStateEvent[_event.m.Bright.getMoodState()]
				});
				_event.m.Dumb.improveMood(1.0, "S\'est lié avec " + _event.m.Bright.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Dumb.getMoodState()],
					text = _event.m.Dumb.getName() + this.Const.MoodStateEvent[_event.m.Dumb.getMoodState()]
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

		local dumb_candidates = [];
		local bright_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.dumb"))
			{
				dumb_candidates.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.bright"))
			{
				bright_candidates.push(bro);
			}
		}

		if (dumb_candidates.len() == 0 || bright_candidates.len() == 0)
		{
			return;
		}

		this.m.Dumb = dumb_candidates[this.Math.rand(0, dumb_candidates.len() - 1)];
		this.m.Bright = bright_candidates[this.Math.rand(0, bright_candidates.len() - 1)];
		this.m.Score = (dumb_candidates.len() + bright_candidates.len()) * 2;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dumb",
			this.m.Dumb.getName()
		]);
		_vars.push([
			"dumb_short",
			this.m.Dumb.getNameOnly()
		]);
		_vars.push([
			"bright",
			this.m.Bright.getName()
		]);
		_vars.push([
			"bright_short",
			this.m.Bright.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dumb = null;
		this.m.Bright = null;
	}

});


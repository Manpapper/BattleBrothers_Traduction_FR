this.determined_delivers_peptalk_event <- this.inherit("scripts/events/event", {
	m = {
		Determined = null
	},
	function create()
	{
		this.m.ID = "event.determined_delivers_peptalk";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_58.png[/img]Vous commencez à vous inquiéter du fait qu\'une sorte de malaise s\'est abattu sur les hommes. Ils sont assis autour du feu de camp, jetant sans réfléchir des bâtons dans les flammes. Chaque visage montre une perte de contrôle, une perte de maîtrise de leur propre destin. Si un homme ne peut pas savoir si demain sera meilleur qu\'aujourd\'hui, comment peut-il continuer à aller de l\'avant ? Au moment où vous vous apprêtez à aborder cette question, %determined% se lève et l\'humeur est si décourageante que même le mouvement rapide attire l\'attention de la compagnie.%SPEECH_ON%Regardez-moi cette bande de pauvres bougres pathétiques. Vous pensez que vous êtes uniques ? Vous pensez que vous êtes les premiers à vous sentir comme une merde ? Non, bien sûr que non. Vous ne seriez pas non plus les premiers à abandonner. A vous coucher et à ne plus vous relever. C\'est la chose la plus facile à faire. C\'est ce que le monde veut que vous fassiez. Il y a assez de fils de pute, pas besoin d\'avoir des culs minables comme vous pour tout gâcher, si vous ne voulez pas participer à cette punition qu\'on appelle la vie.%SPEECH_OFF%Stimulé par ce discours, vous voyez une petite lueur se répandre sur la compagnie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cet homme a raison !",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Determined.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_58.png[/img]%determined% continue, en enfonçant presque son pouce dans sa poitrine.%SPEECH_ON%Je ne prendrai pas la merde de ce monde. Je vais faire en sorte que le monde regrette de m\'avoir ici. Je n\'ai pas demandé d\'invitation, alors je ne vais pas me la couler douce à cette putain de fête. On se voit dans la prochaine vie, les gars, mais en attendant, dansons dans celle-ci !%SPEECH_OFF%Une acclamation éclate et les hommes se lèvent, un sentiment d\'exaltation jaillit comme si le sol les avait entravés depuis le début.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ecoutez, écoutez !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Determined.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getMoodState() <= this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Inspiré par le discours de " + _event.m.Determined.getNameOnly());

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
		if (this.World.Assets.getAverageMoodState() >= this.Const.MoodState.Concerned)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getSkills().hasSkill("trait.determined"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Determined = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"determined",
			this.m.Determined.getName()
		]);
	}

	function onClear()
	{
		this.m.Determined = null;
	}

});


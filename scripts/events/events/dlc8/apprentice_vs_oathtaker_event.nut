this.apprentice_vs_oathtaker_event <- this.inherit("scripts/events/event", {
	m = {
		Apprentice = null,
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.apprentice_vs_oathtaker";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%apprentice% l\'apprenti est assis près du feu de camp quand %oathtaker% l\'Oathtaker commence à le jauger. L\'apprenti lui adresse un regard confus.%SPEECH_ON%Qu\'est-ce qu\'il y a?%SPEECH_OFF%L\'Oathtaker sourit.%SPEECH_ON%Le jeune Anselme, le Premier Oathtaker était un apprenti comme vous. Il a parcouru les terres en cherchant la connaissance et en trouvant lui-même la Voie Finale. Vous lui ressemblez beaucoup.%SPEECH_OFF%L\'apprenti sourit chaleureusement. Il semble que cette notion de lien avec le défunt Oathtaker l\'ait enhardi. Mais, en ce qui vous concerne, le crâne du jeune Anselme ne ressemble absolument pas à celui de %apprentice%. Le nez est trop gros, le front trop marqué, et les dents du Premier Oathtaker sont impeccables alors que %apprentice% a l\'air de se nettoyer les siennes avec un maillet. Mais peut-être que %apprentice% aura davantage l\'air de lui ressembler quand il sera aussi un crâne brillant choyé par un culte inébranlable.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Non pas que je veuille que ça arrive.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				local resolveBoost = this.Math.rand(1, 3);
				_event.m.Apprentice.getBaseProperties().Bravery += resolveBoost;
				_event.m.Apprentice.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Apprentice.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
				});
				_event.m.Apprentice.getFlags().add("learnedFromOathtaker");
				_event.m.Apprentice.improveMood(1.0, "Learned from " + _event.m.Oathtaker.getName());
				_event.m.Oathtaker.improveMood(0.5, "Has taught " + _event.m.Apprentice.getName() + " something");

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
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

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local apprentice_candidates = [];
		local teacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.apprentice" && !bro.getFlags().has("learnedFromOathtaker"))
			{
				apprentice_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.paladin")
			{
				teacher_candidates.push(bro);
			}
		}

		if (apprentice_candidates.len() == 0 || teacher_candidates.len() == 0)
		{
			return;
		}

		this.m.Apprentice = apprentice_candidates[this.Math.rand(0, apprentice_candidates.len() - 1)];
		this.m.Oathtaker = teacher_candidates[this.Math.rand(0, teacher_candidates.len() - 1)];
		this.m.Score = (apprentice_candidates.len() + teacher_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"apprentice",
			this.m.Apprentice.getNameOnly()
		]);
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Apprentice = null;
		this.m.Oathtaker = null;
	}

});


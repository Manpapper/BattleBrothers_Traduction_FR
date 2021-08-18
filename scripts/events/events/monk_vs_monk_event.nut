this.monk_vs_monk_event <- this.inherit("scripts/events/event", {
	m = {
		Monk1 = null,
		Monk2 = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.monk_vs_monk";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img] Ah, les feux de camp débordant de conversations et de bavardages. Les hommes profitent de la bière et de la nourriture quand soudain, les cris de deux hommes en particulier incitent tout le monde à se calmer, non pas parce qu\'ils crient plus fort que les autres, mais parce que cela ne leur ressemble pas : les moines %monk1% et %monk2% sont en plein débat théologique. \n\nVous n\'avez pas l\'éducation nécessaire pour comprendre les subtilités et les complexités de ce qu\'ils discutent, mais vous comprenez que se provoquer un autre homme et le pointer furieusement du doigt, ou un livre saint, c\'est probablement s\'attirer des ennuis d\'une manière ou d\'une autre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cela ne me concerne pas.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Une compagnie de mercenaires n\'est pas un endroit pour parler de religion !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk1.getImagePath());
				this.Characters.push(_event.m.Monk2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img] Pendant un moment, vous pensez à arrêter le débat avant qu\'il ne devienne incontrôlable et qu\'il ne se termine avec les poings, mais vous vous rappelez que ce n\'est pas la première fois que vous voyez deux hommes saints échanger de manière assez vive. C\'est juste ce qu\'ils font. Vous décidez donc de les laisser se disputer. Avec le temps, leurs voix baissent de volume et leurs visages se baissent pour vers un livre. Ils le feuillettent tranquillement, en se cognant la tête en parcourant les pages du regard. Finalement, %monk1% se lève et pointe du doigt une phrase.%SPEECH_ON%C\'est là ! Juste là ! \"Homme de la boue\", pas \"homme du sang\". L\'homme ne peut pas venir du sang, il est le sang ! L\'homme ne peut pas venir ce qu\'il est déjà, tu vois ? Maintenant est-ce que ça a un sens ? %SPEECH_OFF%Se grattant le menton, %monk2% acquiesce, mais se demande à haute voix. %SPEECH_ON%Et si...%SPEECH_OFF%Avant même qu\'il puisse terminer sa pensée %monk1% claque le livre et jette ses mains en l\'air.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les hommes saints évitent une autre crise.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk1.getImagePath());
				this.Characters.push(_event.m.Monk2.getImagePath());
				_event.m.Monk1.improveMood(1.0, "A eu un discours stimulant sur des questions religieuses");

				if (_event.m.Monk1.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk1.getMoodState()],
						text = _event.m.Monk1.getName() + this.Const.MoodStateEvent[_event.m.Monk1.getMoodState()]
					});
				}

				_event.m.Monk2.improveMood(1, "A eu un discours stimulant sur des questions religieuses");

				if (_event.m.Monk2.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk2.getMoodState()],
						text = _event.m.Monk2.getName() + this.Const.MoodStateEvent[_event.m.Monk2.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]Ce n\'est pas la première fois que vous voyez les deux moines se chamailler. La dernière fois que c\'est arrivé, les moines se sont vite réconciliés. Alors naturellement, vous pensez que ces deux-là vont faire de même. Hélas, ce n\'est pas le cas. Leurs voix deviennent de plus en plus fortes. Vous ne saviez pas que les moines pouvaient avoir la langue si bien pendue. La férocité et l\'obscénité ne décrivent même pas les insultes qui sont lancées de part et d\'autre. Ce n\'est que quelques secondes plus tard qu\'ils se retrouvent au sol, à se battre et à se frapper jusqu\'à ce que vous ordonniez à %otherguy% d\'y mettre fin. La compagnie de mercenaires et leur journée de travail sanglante ont, semble-t-il, laissé une marque sur le comportement autrefois paisible de ces deux-là.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je suppose que c\'est ce qu\'on appelle une crise de foi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk1.getImagePath());
				this.Characters.push(_event.m.Monk2.getImagePath());
				_event.m.Monk1.getBaseProperties().Bravery += 1;
				_event.m.Monk1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Détermination"
				});
				_event.m.Monk2.getBaseProperties().Bravery += 1;
				_event.m.Monk2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Détermination"
				});
				_event.m.Monk1.worsenMood(1.0, "A perdu son sang-froid et a eu recours à la violence");

				if (_event.m.Monk1.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk1.getMoodState()],
						text = _event.m.Monk1.getName() + this.Const.MoodStateEvent[_event.m.Monk1.getMoodState()]
					});
				}

				_event.m.Monk2.worsenMood(1.0, "A perdu son sang-froid et a eu recours à la violence");

				if (_event.m.Monk2.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk2.getMoodState()],
						text = _event.m.Monk2.getName() + this.Const.MoodStateEvent[_event.m.Monk2.getMoodState()]
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Monk1.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Monk1.getName() + " souffre de blessures légères"
					});
				}
				else
				{
					local injury = _event.m.Monk1.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Monk1.getName() + " souffre de " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Monk2.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Monk2.getName() + " souffre de blessures légères"
					});
				}
				else
				{
					local injury = _event.m.Monk2.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Monk2.getName() + " souffre de " + injury.getNameOnly()
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local monk_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 3)
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.monk")
			{
				monk_candidates.push(bro);
			}
			else
			{
				other_candidates.push(bro);
			}
		}

		if (monk_candidates.len() < 2)
		{
			return;
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.Monk1 = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		this.m.Monk2 = null;
		this.m.OtherGuy = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];

		do
		{
			this.m.Monk2 = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		}
		while (this.m.Monk2 == null || this.m.Monk2.getID() == this.m.Monk1.getID());

		this.m.Score = monk_candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk1",
			this.m.Monk1.getNameOnly()
		]);
		_vars.push([
			"monk2",
			this.m.Monk2.getNameOnly()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Monk1 = null;
		this.m.Monk2 = null;
		this.m.OtherGuy = null;
	}

});


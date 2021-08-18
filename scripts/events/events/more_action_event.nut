this.more_action_event <- this.inherit("scripts/events/event", {
	m = {
		Bro1 = null,
		Bro2 = null
	},
	function create()
	{
		this.m.ID = "event.more_action";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]Vous êtes assis dans votre tente, profitant de la paix et de la tranquillité qui, comme une chose tangible, semble s\'être accumulée de telle manière que chaque jour est plus agréable que le précédent. Soudain, %combatbro1% et %combatbro2% entrent. Ils vous demandent de discuter. Vous vous exécutez en balayant la table de vos mains et en les invitant à s\'asseoir. Ils le font et déclarent rapidement que cela fait longtemps qu\'ils n\'ont pas vu de combat. Pris au dépourvu, vous vous penchez littéralement en arrière sur votre chaise. %SPEECH_ON%Ce n\'est pas une bonne chose ? %SPEECH_OFF%%combatbro1% secoue la tête et lance une main déterminée dans l\'air. %SPEECH_ON%Non. Nous avons été engagés pour nous battre, et nous voulons nous battre. Nous voulons des batailles, nous voulons du carnage, et nous voulons la gloire qui vient avec les deux.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous nous verrons bientôt en bataille - vous avez ma parole !",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Vous serez payé de toute façon - et maintenant vous pouvez même vivre et dépenser les couronnes.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]Vous acquiescez.%SPEECH_ON%Je comprends. Vous êtes deux hommes qui vivent de batailles. Vous me faites même penser à moi, mais avec vos compétences, je peux vous assurer que je suis le seul à sortir grandi d\'une telle comparaison. Vous êtes de bons guerriers, mais n\'est-il pas vrai que vous serez payés de la même façon quelle que soit la bataille ? Pourquoi être si inquiet au sujet des batailles ? Elles viendront. Je ne vous ai pas payé pour vous asseoir. Je vous ai payé pour que vous soyez prêts à vous lever.%SPEECH_OFF%Les hommes échangent un regard, puis haussent les épaules et acquiescent. Ils se lèvent à l\'unisson. %SPEECH_ON%Vous avez raison, chef. Et, quand le moment sera venu, nous serons prêts à nous lever et à nous battre pour vous!%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est bien d\'avoir des hommes façonnés pour la bataille.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]Vous essayez d\'expliquer aux hommes que, qu\'ils se battent ou non, ils vont être payés. Mais l\'argent n\'est pas leur préoccupation première. Ils veulent vraiment se battre et vos paroles ont peu d\'effet sur leur attitude plutôt sérieuse.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mais...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isCombatBackground() && this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(1.0, "Perte de confiance en votre leadership");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]Vous vous levez et écrasez vos poings sur la table. %SPEECH_ON% C\'est du combat que vous voulez ? %SPEECH_OFF% Les hommes échangent un regard puis vous font rapidement un signe de tête. %SPEECH_ON% Alors c\'est du combat que vous aurez ! Ne craignez pas l\'épée rengainée, mercenaires. Je vous trouverai une bonne bataille en temps voulu !%SPEECH_OFF%Les hommes se lèvent et vous serrent la main. Ils vous remercient en quittant la tente. Une fois qu\'ils sont partis, vous consultez vos cartes et cherchez le plus proche cul à botter.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est bien d\'avoir des hommes façonnés pour la bataille.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isCombatBackground() && this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "On lui a promis une bataille pour bientôt");

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
		if (this.World.Assets.getOrigin().getID() == "scenario.trader")
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() < this.World.getTime().SecondsPerDay * 10)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().isCombatBackground() && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Bro1 = candidates[0];
		this.m.Bro2 = candidates[1];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"combatbro1",
			this.m.Bro1.getName()
		]);
		_vars.push([
			"combatbro2",
			this.m.Bro2.getName()
		]);
	}

	function onClear()
	{
		this.m.Bro1 = null;
		this.m.Bro2 = null;
	}

});


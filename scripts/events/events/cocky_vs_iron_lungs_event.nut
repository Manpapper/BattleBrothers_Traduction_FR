this.cocky_vs_iron_lungs_event <- this.inherit("scripts/events/event", {
	m = {
		Cocky = null,
		IronLungs = null
	},
	function create()
	{
		this.m.ID = "event.cocky_vs_iron_lungs";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Alors que vous roulez des cartes et les remettez dans leurs sacoches, une agitation vous attire hors de votre tente. Les hommes traînent %cocky% sur le sol. Ses vêtements sont trempés et son visage n\'est pas loin de la mort. Les hommes lui donnent quelques bonnes claques sur les joues. Finalement, il se réveille, les yeux fous, la bouche gargarisant de l\'eau comme une fontaine cassée. Il regarde autour de lui et demande ce que vous aussi souhaitiez savoir.%SPEECH_ON%Que s\'est-il passé?%SPEECH_OFF%%ironlungs% s\'avance, un visage tout aussi humide, mais avec un teint beaucoup plus coloré.%SPEECH_ON%Toi l\'espèce de connard arrogant que tu es, a voulu voir lequel d\'entre nous pouvait retenir sa respiration le plus longtemps. Tu as perdu parce qu\'ils n\'appellent pas ça des poumons d\'acier pour rien.%SPEECH_OFF%Les hommes rient tandis que %ironlungs% se frappe la poitrine avec arrogance. %cocky%, toujours chancelant, se relève. Quelques instants après avoir été complètement inconscient, il est déjà de retour à ses habitudes orgueilleuses.%SPEECH_ON%Ouais ouais, tu m\'as battu aujourd\'hui, mais je serai le meilleur, tu verras !%SPEECH_OFF%Un mercenaire lui fait remarquer avec fantaisie qu\'il a un énorme fil de morve qui pend de son nez. Il l\'essuie avec confiance malgré les rires de la compagnie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ah, la technique toujours sûre pour mesurer la virilité.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
				_event.m.Cocky.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Cocky.getName() + " suffers light wounds"
				});
				_event.m.Cocky.worsenMood(1.0, "A été humilié devant toute la compagnie");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cocky.getMoodState()],
					text = _event.m.Cocky.getName() + this.Const.MoodStateEvent[_event.m.Cocky.getMoodState()]
				});
				_event.m.IronLungs.improveMood(1.0, "A battu " + _event.m.Cocky.getName() + " dans un concours de force");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.IronLungs.getMoodState()],
					text = _event.m.IronLungs.getName() + this.Const.MoodStateEvent[_event.m.IronLungs.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Cocky.getID() && bro.getID() != _event.m.IronLungs.getID() && this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "S\'est senti amusé par " + _event.m.Cocky.getNameOnly());

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
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local cocky_candidates = [];
		local ironlungs_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.cocky"))
			{
				cocky_candidates.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.iron_lungs"))
			{
				ironlungs_candidates.push(bro);
			}
		}

		if (cocky_candidates.len() == 0 || ironlungs_candidates.len() == 0)
		{
			return;
		}

		this.m.Cocky = cocky_candidates[this.Math.rand(0, cocky_candidates.len() - 1)];
		this.m.IronLungs = ironlungs_candidates[this.Math.rand(0, ironlungs_candidates.len() - 1)];
		this.m.Score = (cocky_candidates.len() + ironlungs_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cocky",
			this.m.Cocky.getNameOnly()
		]);
		_vars.push([
			"ironlungs",
			this.m.IronLungs.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cocky = null;
		this.m.IronLungs = null;
	}

});


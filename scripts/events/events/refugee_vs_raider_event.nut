this.refugee_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		Refugee = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.refugee_vs_raider";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]%refugee%, un homme qui a déjà été forcé de partir sur les routes en tant que réfugié, regarde fixement %raider%. Le pillard, sentant qu\'on le dévisage, baisse son assiette de nourriture. %SPEECH_ON% Qu\'est-ce que tu regardes, hein ? %SPEECH_OFF%Le réfugié montre une cuillère dégoulinante. %SPEECH_ON%Tu es un pillard, non ? %SPEECH_OFF%%le pillard%hoche la tête. %SPEECH_ON%Je l\'était. Je pourrais le redevenir un jour. Qu\'est ce que ça peut te faire ?%SPEECH_OFF%Se relevant, %refugee% pointe du doigt.%SPEECH_ON%C\'est des hommes comme toi qui ont forcé de bonnes personnes à quitter leur maison. De bonnes personnes qui ont traîné leur vie entière sur cette maudite route.%SPEECH_OFF%Riant, %raider% se lève.%SPEECH_ON%Oh, c\'est vrai ? Et qu\'est-ce qui les rendait si bons ? Qu\'ils ne pouvaient pas brandir une épée ou se protéger eux-mêmes ? Crois-tu un seul instant que si la botte était sur l\'autre pied, ils ne feraient pas la même chose avec moi ? Ou à vous, aussi ? Les gens ne sont bons qu\'en fonction des options qu\'ils ont.%SPEECH_OFF%Le débat s\'emballe et certains des autres mercenaires se lèvent. Personne ne peut arrêter la bagarre initiale, les deux hommes échangeant des coups et des insultes aussi bien que n\'importe quelle bagarre de taverne que vous avez vue. Heureusement, rien de grave ne se produit.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Calmez-vous, maintenant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Refugee.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury1 = _event.m.Refugee.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury1.getIcon(),
						text = _event.m.Refugee.getName() + " souffre de " + injury1.getNameOnly()
					});
				}
				else
				{
					_event.m.Refugee.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Refugee.getName() + " souffre de blessures légères"
					});
				}

				_event.m.Refugee.worsenMood(1.0, "A eu une bagarre avec " + _event.m.Raider.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
					text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Raider.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Raider.getName() + " souffre de " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Raider.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Raider.getName() + " souffre de blessures légères"
					});
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

		local refugee_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 2 && bro.getBackground().getID() == "background.refugee")
			{
				refugee_candidates.push(bro);
				break;
			}
		}

		if (refugee_candidates.len() == 0)
		{
			return;
		}

		local raider_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 6 && bro.getBackground().getID() == "background.raider")
			{
				raider_candidates.push(bro);
			}
		}

		if (raider_candidates.len() == 0)
		{
			return;
		}

		this.m.Refugee = refugee_candidates[this.Math.rand(0, refugee_candidates.len() - 1)];
		this.m.Raider = raider_candidates[this.Math.rand(0, raider_candidates.len() - 1)];
		this.m.Score = (refugee_candidates.len() + raider_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"refugee",
			this.m.Refugee.getNameOnly()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Refugee = null;
		this.m.Raider = null;
	}

});


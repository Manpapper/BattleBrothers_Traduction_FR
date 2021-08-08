this.graverobber_vs_gravedigger_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Gravedigger = null
	},
	function create()
	{
		this.m.ID = "event.graverobber_vs_gravedigger";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_28.png[/img]Après avoir enterré un camarade mort, %gravedigger% enfonce sa pelle dans la terre et saisit le %graverobber% par sa tunique, le poussant en arrière tout en le soulevant dans les airs. Avant même qu\'un mot ou une menace puisse être échangé, l\'homme suspendu envoie un coup de pied dans l\'aine de son agresseur. Ils tombent tous les deux au sol et se mettent immédiatement à culbuter dans la boue. La boue les rend indiscernables, mais leur colère est bien audible.\n\nLe fossoyeur grimpe sur le pilleur de tombe et commence à empiler de la boue sur le visage de son adversaire.%SPEECH_ON%Qu\'est-ce que je t\'ai dit, hein ? Qu\'est-ce que j\'ai dit sur le fait de voler ceux qui ne peuvent pas voir vos sales petites mains arriver, hein ?%SPEECH_OFF%Avec un joli petit renversement qui suggère que ce n\'est pas la première fois qu\'il lutte dans la boue, le pilleur de tombes rejette son assaillant et grimpe sur lui. Il attrape de gros tas d\'herbe et de crasse et les envoie au visage du fossoyeur. Bizarrement, le pilleur de tombe pense qu\'il est temps de faire valoir ses arguments.%SPEECH_ON%C\'est seulement ses chaussures ! C\'est seulement ses gants ! Les morts n\'ont pas besoin de marcher ou de ramasser des choses, autant qu\'ils soient à moi !%SPEECH_OFF% Ah, il semble que le pilleur de tombes et le fossoyeur aient un léger différend sur ce qui entre dans le sol et ce qui n\'en ressort pas. Vous les laissez régler leurs problèmes - il n\'y a pas grand-chose à faire entre eux et c\'est un bon divertissement pour le reste de la compagnie, de toute façon.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Juste ne tombez pas dans la tombe.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				this.Characters.push(_event.m.Gravedigger.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
				}
				else
				{
					_event.m.Graverobber.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Graverobber.getName() + " souffre de blessures légères"
					});
				}

				_event.m.Graverobber.worsenMood(0.5, "S\'est battu avec " + _event.m.Gravedigger.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
				}
				else
				{
					_event.m.Gravedigger.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Gravedigger.getName() + " souffre de blessures légères"
					});
				}

				_event.m.Gravedigger.worsenMood(0.5, "S\'est battu avec " + _event.m.Graverobber.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Gravedigger.getMoodState()],
					text = _event.m.Gravedigger.getName() + this.Const.MoodStateEvent[_event.m.Gravedigger.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 1 || fallen[0].Time != this.World.getTime().Days)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_graverobber = [];
		local candidates_gravedigger = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				candidates_graverobber.push(bro);
			}
			else if (bro.getBackground().getID() == "background.gravedigger")
			{
				candidates_gravedigger.push(bro);
			}
		}

		if (candidates_graverobber.len() == 0 || candidates_gravedigger.len() == 0)
		{
			return;
		}

		this.m.Graverobber = candidates_graverobber[this.Math.rand(0, candidates_graverobber.len() - 1)];
		this.m.Gravedigger = candidates_gravedigger[this.Math.rand(0, candidates_gravedigger.len() - 1)];
		this.m.Score = 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"graverobber",
			this.m.Graverobber.getName()
		]);
		_vars.push([
			"gravedigger",
			this.m.Gravedigger.getName()
		]);
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Gravedigger = null;
	}

});


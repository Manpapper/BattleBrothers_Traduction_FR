this.farmer_vs_butcher_event <- this.inherit("scripts/events/event", {
	m = {
		Butcher = null,
		Farmer = null
	},
	function create()
	{
		this.m.ID = "event.farmer_vs_butcher";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]Vous trouvez %farmhand% et %butcher% qui se disputent un morceau de viande. Le fermier élève la voix.%SPEECH_ON%La meilleure viande est celle de l\'épaule. C\'est pour ça qu\'on la coupe en premier ! Et tu la coupes comme ça, PAS comme ça, idiot.%SPEECH_OFF%Haussant également la voix, et serrant le poing sur le côté, le boucher secoue la tête.%SPEECH_ON%Pourquoi est-ce que tu me questionnes ? Je suis un putain de boucher, tu es un paysan pitoyable ! Je fais ça pour vivre, toi tu l\'as fait parce que tu as tué une vache en attrapant son pis un peu trop fort, la confondant sans doute avec la bite de ton père !%SPEECH_OFF%Les mots déclenchent une bagarre. Quelqu\'un se fait gifler, quelqu\'un d\'autre a le nez écrasé. Les hommes sont séparés, mais pas avant que les dégâts ne soient faits.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous êtes tous les deux des mercenaires maintenant !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				this.Characters.push(_event.m.Farmer.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury1 = _event.m.Butcher.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury1.getIcon(),
						text = _event.m.Butcher.getName() + " souffre de " + injury1.getNameOnly()
					});
				}
				else
				{
					_event.m.Butcher.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Butcher.getName() + " souffre de blessures légères"
					});
				}

				_event.m.Butcher.worsenMood(0.5, "A eu une bagarre avec " + _event.m.Farmer.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Butcher.getMoodState()],
					text = _event.m.Butcher.getName() + this.Const.MoodStateEvent[_event.m.Butcher.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Farmer.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Farmer.getName() + " souffre de " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Farmer.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Farmer.getName() + " souffre de blessures légères"
					});
				}

				_event.m.Farmer.worsenMood(0.5, "A eu une bagarre avec " + _event.m.Butcher.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Farmer.getMoodState()],
					text = _event.m.Farmer.getName() + this.Const.MoodStateEvent[_event.m.Farmer.getMoodState()]
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

		local butcher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.butcher")
			{
				butcher_candidates.push(bro);
				break;
			}
		}

		if (butcher_candidates.len() == 0)
		{
			return;
		}

		local farmer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.farmhand")
			{
				farmer_candidates.push(bro);
			}
		}

		if (farmer_candidates.len() == 0)
		{
			return;
		}

		this.m.Butcher = butcher_candidates[this.Math.rand(0, butcher_candidates.len() - 1)];
		this.m.Farmer = farmer_candidates[this.Math.rand(0, farmer_candidates.len() - 1)];
		this.m.Score = (butcher_candidates.len() + farmer_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"farmhand",
			this.m.Farmer.getNameOnly()
		]);
		_vars.push([
			"butcher",
			this.m.Butcher.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Farmer = null;
		this.m.Butcher = null;
	}

});


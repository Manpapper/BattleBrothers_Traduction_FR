this.killer_on_the_run_reminisces_event <- this.inherit("scripts/events/event", {
	m = {
		Killer = null
	},
	function create()
	{
		this.m.ID = "event.killer_on_the_run_reminisces";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Semblant sortir de nulle part, %killer% mentionne avec légèreté qu\'il y a un corps enterré ici. Vous savez qu\'il s\'agit d\'un tueur en cavale, mais vous avez l\'honneur de lui demander comment il peut le savoir. Il dit carrément: %SPEECH_ON%Parce que je les ai tués et que j\'ai caché un corps par ici. Vous savez, c\'était un meurtre utile... l\'individu souffrait de maladies.%SPEECH_OFF%Le seul mot "maladies" provoque un choc chez les anatomistes, comme s\'ils étaient des faucons qui venaient de voir une souris détaler. Très vite, et à votre grand dam, le groupe médicale déterre le cadavre. Il y a beaucoup de discussions sur les maladies que le corps a pu porter. Cela vous dépasse, mais le groupe s\'accorde à dire que le fait de l\'étudier permettra de faire de grandes avancées dans leur domaine. Une fois leurs discussions terminées, %killer% s\'approche de vous avec un sourire en coin. Il dit qu\'il a tué cette personne parce qu\'il aimait ça, et que c\'était sympa de revoir le corps.%SPEECH_ON%Il est juste dommage que ces têtes d\'œuf l\'aient malmené comme ils l\'ont fait. Il méritait plus de soins, plus... de temps.%SPEECH_OFF%Vous vous éloignez de l\'homme et reprenez la route avec cette étrange compagnie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les dés sont jetés...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				_event.m.Killer.improveMood(1.0, "Reminisced about an old kill");
				local resolveBoost = this.Math.rand(1, 3);
				_event.m.Killer.getBaseProperties().Bravery += resolveBoost;
				_event.m.Killer.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Killer.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
				});

				if (_event.m.Killer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Killer.getMoodState()],
						text = _event.m.Killer.getName() + this.Const.MoodStateEvent[_event.m.Killer.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.anatomist")
					{
						bro.addXP(50, false);
						bro.updateLevel();
						this.List.push({
							id = 16,
							icon = "ui/icons/xp_received.png",
							text = bro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+50[/color] Experience"
						});
						bro.improveMood(1.0, "Got to examine an interesting blighted cadaver");

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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local killer_candidates = [];
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killer_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (killer_candidates.len() == 0 || anatomist_candidates.len() <= 1)
		{
			return;
		}

		this.m.Killer = killer_candidates[this.Math.rand(0, killer_candidates.len() - 1)];
		this.m.Score = killer_candidates.len() * 1000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"killer",
			this.m.Killer.getName()
		]);
	}

	function onClear()
	{
		this.m.Killer = null;
	}

});


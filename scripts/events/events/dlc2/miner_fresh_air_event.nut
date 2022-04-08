this.miner_fresh_air_event <- this.inherit("scripts/events/event", {
	m = {
		Miner = null
	},
	function create()
	{
		this.m.ID = "event.miner_fresh_air";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{%miner% le mineur aspire de grandes bouffées d'air et les relâche dans de longues expirations un peu sifflantes. Il acquiesce de la tête, comme s'il était satisfait de ce que tout le monde fait. Il semble que certaines personnes soient facilement satisfaites. Mais il s'explique.%SPEECH_ON%Vous savez que j'ai passé des années dans l'obscurité des mines, à respirer la poussière et les métaux. Je pense qu'avoir retrouver la surface après si longtemps a été une fortune en soi, un trésor dont je ne savais pas qu'il était là à porter de main. Merci, capitaine, parce que je ne serais pas ici en ce moment si ce n'était pas grâce à vous.%SPEECH_OFF%Vous acquiescez et le remerciez pour ses bonnes paroles.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il y a une brise fraîche qui vient de la mer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Miner.getImagePath());
				_event.m.Miner.improveMood(1.0, "Heureux d'avoir une nouvelle vie à la surface");

				if (_event.m.Miner.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Miner.getMoodState()],
						text = _event.m.Miner.getName() + this.Const.MoodStateEvent[_event.m.Miner.getMoodState()]
					});
				}

				local stamina = this.Math.rand(3, 6);
				_event.m.Miner.getBaseProperties().Stamina += stamina;
				_event.m.Miner.getSkills().update();
				_event.m.Miner.getFlags().add("fresh_air");
				this.List.push({
					id = 17,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Miner.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] de Fatigue Maximum"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
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
			if (bro.getLevel() > 3 && bro.getBackground().getID() == "background.miner" && !bro.getFlags().has("fresh_air"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Miner = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"miner",
			this.m.Miner.getName()
		]);
	}

	function onClear()
	{
		this.m.Miner = null;
	}

});


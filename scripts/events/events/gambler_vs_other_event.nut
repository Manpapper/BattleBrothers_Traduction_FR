this.gambler_vs_other_event <- this.inherit("scripts/events/event", {
	m = {
		DumbGuy = null,
		Gambler = null
	},
	function create()
	{
		this.m.ID = "event.gambler_vs_other";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]{%gambler% and %nongambler% walk up to mottled with bruises. It appears they\'ve been in a bit of a scuffle. Seeing as how neither one is dead, you don\'t really care what it was over, but they tell you anyway.\n\nApparently the gambler took some money in a bit of sly cardsmanship. You ask either man if the company\'s money was involved. They say no. You ask what the hell they want from you then. | A game of cards comes to a table-flipping end when %nongambler% jumps off his stool and launches a tirade at %gambler%. The professional gambler looks around with sheepish incredulity. How could such a man come into so much money over a game of cards, he asks, but when his hands go up to feign confusion a few \'extra\' cards slip out of his sleeves. The ensuing battle is amusing, but you put a stop to it before anyone gets seriously hurt.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Save it for battle.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gambler.getImagePath());
				this.Characters.push(_event.m.DumbGuy.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Gambler.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Gambler.getName() + " suffers light wounds"
					});
				}
				else
				{
					local injury = _event.m.Gambler.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Gambler.getName() + " suffers " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.DumbGuy.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.DumbGuy.getName() + " suffers light wounds"
					});
				}
				else
				{
					local injury = _event.m.DumbGuy.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.DumbGuy.getName() + " suffers " + injury.getNameOnly()
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

		local gambler_candidates = [];
		local dumb_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gambler")
			{
				gambler_candidates.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.bright"))
			{
				dumb_candidates.push(bro);
			}
		}

		if (gambler_candidates.len() == 0 || dumb_candidates.len() == 0)
		{
			return;
		}

		this.m.DumbGuy = dumb_candidates[this.Math.rand(0, dumb_candidates.len() - 1)];
		this.m.Gambler = gambler_candidates[this.Math.rand(0, gambler_candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"nongambler",
			this.m.DumbGuy.getName()
		]);
		_vars.push([
			"gambler",
			this.m.Gambler.getName()
		]);
	}

	function onClear()
	{
		this.m.DumbGuy = null;
		this.m.Gambler = null;
	}

});


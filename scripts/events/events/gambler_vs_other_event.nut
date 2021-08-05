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
			Text = "[img]gfx/ui/events/event_06.png[/img]{%gambler% et %nongambler% s\'avancent tachetés d\'ecchymoses. Il semble qu\'il y ait eu une petite bagarre. Vu qu\'aucun des deux n\'est mort, vous ne vous souciez pas vraiment de ce qui s\'est passé, mais ils vous le disent quand même.\n\nApparemment, le joueur a pris de l\'argent en jouant sournoisement aux cartes. Vous demandez aux deux hommes si l\'argent de la compagnie est impliqué. Ils répondent que non. Vous demandez ce qu\'ils veulent de vous alors. | Une partie de cartes se termine par un renversement de table lorsque %nongambler% saute de son tabouret et lance une tirade à %gambler%. Le joueur professionnel regarde autour de lui avec une incrédulité penaude. Comment un tel homme a-t-il pu gagner autant d\'argent avec un jeu de cartes, se demande-t-il, mais lorsque ses mains se lèvent pour feindre la confusion, quelques cartes \"supplémentaires\" sortent de ses manches. La bataille qui s\'ensuit est amusante, mais vous l\'arrêtez avant que quelqu\'un ne soit sérieusement blessé.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gardez-la pour la bataille.",
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
						text = _event.m.Gambler.getName() + " souffre de blessures légères"
					});
				}
				else
				{
					local injury = _event.m.Gambler.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Gambler.getName() + " souffre de " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.DumbGuy.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.DumbGuy.getName() + " souffre de blessures légères"
					});
				}
				else
				{
					local injury = _event.m.DumbGuy.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.DumbGuy.getName() + " souffre de " + injury.getNameOnly()
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


this.fat_guy_gets_fit_event <- this.inherit("scripts/events/event", {
	m = {
		FatGuy = null
	},
	function create()
	{
		this.m.ID = "event.fat_guy_gets_fit";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_75.png[/img]%fatguy%, autrefois un gros tas de graisse sur deux jambes, a perdu beaucoup de poids depuis qu\'il est dans la compagnie. La simple idée d\'un combat d\'entraînement ne le laisse plus sans souffle. En fait, il a plus de dynamisme dans sa démarche et fait preuve d\'une agilité que vous ne lui avez jamais vue auparavant. On dirait que toutes ces promenades ont fait des merveilles.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il pourrait devenir un bon mercenaire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.FatGuy.getImagePath());
				_event.m.FatGuy.getSkills().removeByID("trait.fat");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_10.png",
						text = _event.m.FatGuy.getName() + " n\'est plus gros"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 5 && bro.getSkills().hasSkill("trait.fat"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.FatGuy = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = candidates.len() * 5;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fatguy",
			this.m.FatGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.FatGuy = null;
	}

});


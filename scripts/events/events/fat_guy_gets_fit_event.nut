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
			Text = "[img]gfx/ui/events/event_75.png[/img]%fatguy%, once a lumbering lump of belly fat on two legs, has lost a considerable amount of weight since he\'s with the company. No longer does the mere notion of a sparring fight leave him without breath. In fact, he\'s got more bounce in his step and is showing a sort of agility you\'ve never seen from him before. Looks like all this walking about has done wonders.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "He might make a good sellsword yet.",
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
						text = _event.m.FatGuy.getName() + " is no longer fat"
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


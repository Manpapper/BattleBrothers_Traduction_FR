this.glutton_gets_fat_event <- this.inherit("scripts/events/event", {
	m = {
		Glutton = null
	},
	function create()
	{
		this.m.ID = "event.glutton_gets_fat";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_14.png[/img] You find %glutton% helping himself to a third helping of food. That\'s far too much and so you demand that it be his last. Another brother joins in, mocking the man for his habits. The glutton, enraged, slams his food down and stands up. His stomach however, sways at a different pace than the rest of him and the rather fattened man goes down in a heap of flailing limbs. While the rest of the company has a laugh, you can\'t help but wonder if the sellsword really has gotten too fat.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Drop the pork. Now.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Glutton.getImagePath());
				local trait = this.new("scripts/skills/traits/fat_trait");
				_event.m.Glutton.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Glutton.getName() + " gets fat"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() < 100)
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
			if (bro.getLevel() >= 3 && bro.getSkills().hasSkill("trait.gluttonous") && !bro.getSkills().hasSkill("trait.fat"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Glutton = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"glutton",
			this.m.Glutton.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Glutton = null;
	}

});


this.dastard_loses_trait_event <- this.inherit("scripts/events/event", {
	m = {
		Dastard = null,
		Braveman1 = null,
		Braveman2 = null
	},
	function create()
	{
		this.m.ID = "event.dastard_loses_trait";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_58.png[/img]You come across %braveman1% and %braveman2% sitting with %dastard%. The two men are pepping up the rather skittish brother, letting him know that there is nothing to fear in battle. %dastard% explains that he is fearful of a painful death. %braveman1% says he has seen many men die and by the sword, truly, is one of the fastest. %braveman2% raises his hand.%SPEECH_ON%Unless it gets you in the stomach.%SPEECH_OFF%%braveman1% nods.%SPEECH_ON%Right. But other than that, you have nothing to fear!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Growing up to become a real sellsword after all, are we?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dastard.getImagePath());
				this.Characters.push(_event.m.Braveman1.getImagePath());
				_event.m.Dastard.getSkills().removeByID("trait.dastard");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_38.png",
						text = _event.m.Dastard.getName() + " is no longer a dastard"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_dastard = [];
		local candidates_brave = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getSkills().hasSkill("trait.dastard"))
			{
				candidates_dastard.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.brave") || bro.getSkills().hasSkill("trait.fearless"))
			{
				candidates_brave.push(bro);
			}
		}

		if (candidates_dastard.len() == 0 || candidates_brave.len() < 2)
		{
			return;
		}

		this.m.Dastard = candidates_dastard[this.Math.rand(0, candidates_dastard.len() - 1)];
		this.m.Braveman1 = candidates_brave[0];
		this.m.Braveman2 = candidates_brave[1];
		this.m.Score = candidates_dastard.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dastard",
			this.m.Dastard.getName()
		]);
		_vars.push([
			"braveman1",
			this.m.Braveman1.getName()
		]);
		_vars.push([
			"braveman2",
			this.m.Braveman2.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Dastard = null;
		this.m.Braveman1 = null;
		this.m.Braveman2 = null;
	}

});


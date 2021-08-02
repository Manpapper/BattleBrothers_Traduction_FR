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
			Text = "[img]gfx/ui/events/event_58.png[/img]Vous rencontrez %braveman1% et %braveman2% assis avec %dastard%. Les deux hommes sont en train de réconforter le frère d\'arme un peu capricieux, lui faisant comprendre qu\'il n\'y a rien à craindre au combat. %dastard% explique qu\'il a peur d\'une mort douloureuse. %braveman1% dit qu\'il a vu beaucoup d\'hommes mourir et que l\'épée est vraiment l\'une des plus rapides. %braveman2% lève la main.%SPEECH_ON%A moins qu\'elle ne te touche à l\'estomac.%SPEECH_OFF%%braveman1% acquiesce.%SPEECH_ON%C\'est vrai. Mais à part ça, tu n\'as rien à craindre !%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On grandit pour devenir un vrai mercenaire après tout, n\'est-ce pas ?",
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
						text = _event.m.Dastard.getName() + " n\'est plus un bâtard"
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


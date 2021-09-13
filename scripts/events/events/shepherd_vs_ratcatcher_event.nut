this.shepherd_vs_ratcatcher_event <- this.inherit("scripts/events/event", {
	m = {
		Shepherd = null,
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.shepherd_vs_ratcatcher";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%ratcatcher% et %shepherd% sont assis près du feu de camp. Alors que leur conversation se poursuit, le chasseur de rats devient un peu confus.%SPEECH_ON%Alors, alors, alors, que je comprenne bien. T-tu utilises un bâton, et donc ils te suivent parce que tu as le bâtonnet? Tout vient du bâtonnet? %SPEECH_OFF%En hochant la tête, le berger explique.%SPEECH_ON%Je préfère l\'appeler un bâton, mais oui. Les moutons sont des créatures simples et tout ce qu\'ils demandent c\'est un chef. Le bâton est la représentation de mon rôle. Je manie le bâton, donc je suis le chef. Du moins aux yeux d\'un petit mouton. Un chien obéissant aide beaucoup, aussi. En vérité, un chien serait le vrai chef s\'il n\'avait pas la loyauté et l\'honneur que nous aimerions avoir nous-mêmes.%SPEECH_OFF%%ratcatcher% hoche la tête.%SPEECH_ON%Il faudra que j\'essaie le bâtonnet, je veux dire le bâton, avec mes rats. Et prendre un chien aussi..%SPEECH_OFF%Le berger sourit. %SPEECH_ON%Ou un chat. Quoi ? je plaisante, mon ami, je plaisante juste.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Euh ok.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Shepherd.getImagePath());
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				_event.m.Shepherd.improveMood(1.0, "Bonded with " + _event.m.Ratcatcher.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Shepherd.getMoodState()],
					text = _event.m.Shepherd.getName() + this.Const.MoodStateEvent[_event.m.Shepherd.getMoodState()]
				});
				_event.m.Ratcatcher.improveMood(1.0, "Bonded with " + _event.m.Shepherd.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Ratcatcher.getMoodState()],
					text = _event.m.Ratcatcher.getName() + this.Const.MoodStateEvent[_event.m.Ratcatcher.getMoodState()]
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

		local shepherd_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 4 && bro.getBackground().getID() == "background.shepherd")
			{
				shepherd_candidates.push(bro);
				break;
			}
		}

		if (shepherd_candidates.len() == 0)
		{
			return;
		}

		local ratcatcher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.ratcatcher")
			{
				ratcatcher_candidates.push(bro);
			}
		}

		if (ratcatcher_candidates.len() == 0)
		{
			return;
		}

		this.m.Shepherd = shepherd_candidates[this.Math.rand(0, shepherd_candidates.len() - 1)];
		this.m.Ratcatcher = ratcatcher_candidates[this.Math.rand(0, ratcatcher_candidates.len() - 1)];
		this.m.Score = (shepherd_candidates.len() + ratcatcher_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"shepherd",
			this.m.Shepherd.getNameOnly()
		]);
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Shepherd = null;
		this.m.Ratcatcher = null;
	}

});


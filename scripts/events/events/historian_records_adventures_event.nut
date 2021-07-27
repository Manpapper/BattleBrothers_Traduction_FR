this.historian_records_adventures_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.historian_records_adventures";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_15.png[/img]Carrying a leathered tome in hand, %historian% shuffles into your tent. Without a word spoken he lays the book on the table and takes a step back. You set your quill pen down and ask what it is. He says to open it. Sighing, you open the book and come to find pages littered with names and events you know well. It is a history of the company and its adventures. You flip through the pages, seeing old tales that warm the heart and some that break it. You close the book and push it back across the table. The historian asks if it is alright, and you nod. You say give it to the men to read around camp for it will surely lift their spirits.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The deeds of the %companyname% shan\'t be forgotten.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) >= 90)
					{
						continue;
					}

					bro.improveMood(1.0, "Proud of the company\'s achievements");

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

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 9 && bro.getBackground().getID() == "background.historian")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Historian = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Historian = null;
	}

});


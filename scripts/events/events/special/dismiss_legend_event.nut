this.dismiss_legend_event <- this.inherit("scripts/events/event", {
	m = {
		Fired = null
	},
	function setFired( _f )
	{
		this.m.Fired = _f;
	}

	function create()
	{
		this.m.ID = "event.dismiss_legend";
		this.m.Title = "Along the way...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]L\'homme que vous avez laissé partir n\'était pas seulement un membre de la compagnie : c\'était une légende. Beaucoup connaissaient le nom de %dismissed%, pas seulement vous et quelques mercenaires, et le voir partir revient à virer un général héroïque avant une bataille de fin de guerre. Cette décision, bien sûr, n\'est pas bien accueillie par le reste des mercenaires.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ils s\'en remettront.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.player"))
					{
						continue;
					}

					bro.worsenMood(this.Const.MoodChange.VeteranDismissed, "Vous avez renvoyé " + _event.m.Fired + ", une légende de la compagnie");

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
		if (this.World.Statistics.hasNews("dismiss_legend"))
		{
			this.m.Score = 2000;
		}

		return;
	}

	function onPrepare()
	{
		local news = this.World.Statistics.popNews("dismiss_legend");
		this.m.Fired = news.get("Name");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dismissed",
			this.m.Fired
		]);
	}

	function onClear()
	{
		this.m.Fired = null;
	}

});


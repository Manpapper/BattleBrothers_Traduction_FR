this.dismiss_injured_event <- this.inherit("scripts/events/event", {
	m = {
		Fired = null
	},
	function setFired( _f )
	{
		this.m.Fired = _f;
	}

	function create()
	{
		this.m.ID = "event.dismiss_injured";
		this.m.Title = "Sur la route...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]Les blessures de %dismissed% s\'avèrent trop lourdes : l\'homme n\'est pas mort, mais dans votre esprit, il aurait pu tout aussi bien mourir car il n\'était plus apte au combat. Vous l\'avez laissé partir. Bien que ce soit un geste altruiste qui a épargné la vie du mercenaire, le reste de la compagnie ne le voit pas de la même façon. Tout ce qu\'ils voient c\'est qu\'une blessure est tout ce qu\'il faut pour que vous abandonniez un homme. Ils craignent maintenant que s\'ils sont blessés, vous ne leur fassiez la même chose, comme un homme égoïste se débarrassant d\'un cheval boiteux.",
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

					if (bro.getSkills().hasSkillOfType(this.Const.SkillType.PermanentInjury))
					{
						bro.worsenMood(1.5, "A peur d\'être licencié en raison de sa blessure.");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(this.Const.MoodChange.BrotherDismissed, "A perdu confiance en la solidarité de la compagnie.");

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
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.hasNews("dismiss_injured"))
		{
			this.m.Score = 2000;
		}

		return;
	}

	function onPrepare()
	{
		local news = this.World.Statistics.popNews("dismiss_injured");
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


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
			Text = "[img]gfx/ui/events/event_15.png[/img]Un tome en cuir à la main, %historian% entre dans votre tente en traînant les pieds. Sans dire un mot, il pose le livre sur la table et fait un pas en arrière. Vous posez votre plume d\'oie et demandez ce que c\'est. Il vous dit de l\'ouvrir. En soupirant, vous ouvrez le livre et découvrez des pages pleines de noms et d\'événements que vous connaissez bien. Il s\'agit de l\'histoire de la compagnie et de ses aventures. Vous feuilletez les pages, voyant de vieux récits qui réchauffent le cœur et d\'autres qui le brisent. Vous fermez le livre et le repoussez sur la table. L\'historien vous demande si c\'est bien, et vous acquiescez. Vous dites de le donner aux hommes pour qu\'ils le lisent au camp, car ça leur remontera sûrement le moral.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les actes de %companyname% ne doivent pas être oubliés.",
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

					bro.improveMood(1.0, "Fier des exploits de la compagnie.");

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


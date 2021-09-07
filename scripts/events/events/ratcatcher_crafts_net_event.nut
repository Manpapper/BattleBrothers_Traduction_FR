this.ratcatcher_crafts_net_event <- this.inherit("scripts/events/event", {
	m = {
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.ratcatcher_crafts_net";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous tombez sur %ratcatcher% assis avec les mains pleines de corde. Curieux, vous demandez à l\'homme ce qu\'il fait. Comme s\'il s\'attendait à cette question, il lève rapidement son projet en l\'air et annonce qu\'il s\'est fabriqué un filet. Ah ! Vous mettez les mains sur vos hanches.%SPEECH_ON%Ça sera génial sur le champ de bataille !%SPEECH_OFF%Le chasseur de rats se pince les lèvres. Il abaisse lentement le filet.%SPEECH_ON%Oh, je voulais... l\'utiliser... pour me trouver des rats...%SPEECH_OFF%Il marque un temps d\'arrêt, puis lève la tête, un sourire effronté, sinon insolent, au visage.%SPEECH_ON%Mais je l\'utiliserai sur le champ de bataille ! Aucun rat, homme ou animal à fourrure ou autre, ne m\'échappera !%SPEECH_OFF%"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				local item = this.new("scripts/items/tools/throwing_net");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.ratcatcher")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Ratcatcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Ratcatcher = null;
	}

});


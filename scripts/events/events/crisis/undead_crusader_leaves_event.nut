this.undead_crusader_leaves_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_crusader_leaves";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]%crusader% the crusader approaches you with his armor off and his helmet tucked into the nook of his elbow.%SPEECH_ON%Good sir, I must bid the company adieu. With the undead beaten, my mission is complete.%SPEECH_OFF%You go to shake the man\'s hand, but he simply hands you his helm and weapon.%SPEECH_ON%You\'ve more use for these than I. My fighting days are over. It was a pleasure to ride them into the twilight with you by my side. Send the men my regards.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Farewell!",
					function getResult( _event )
					{
						_event.m.Dude.getItems().transferToStash(this.World.Assets.getStash());
						this.World.getPlayerRoster().remove(_event.m.Dude);
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Dude.getName() + " leaves the " + this.World.Assets.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() == 1)
		{
			return;
		}

		local crusader;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.crusader")
			{
				crusader = bro;
				break;
			}
		}

		if (crusader == null)
		{
			return;
		}

		this.m.Dude = crusader;
		this.m.Score = 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"crusader",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});


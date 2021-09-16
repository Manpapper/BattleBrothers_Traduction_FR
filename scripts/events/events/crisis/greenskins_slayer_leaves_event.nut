this.greenskins_slayer_leaves_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_slayer_leaves";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]%orcslayer% the orcslayer walks up to you.%SPEECH_ON%Well, I guess that\'s it then. There ain\'t as many orcs and goblins around to kill. I bid you farewell, sellsword.%SPEECH_OFF%You ask what he\'s going to do. He takes off his armor and puts it on the ground before you.%SPEECH_ON%My family has been avenged.%SPEECH_OFF%You nod and wish him well now that his apparent demons have been put to rest. He laughs.%SPEECH_ON%Just kidding. I don\'t have no family. I killed them bastards because I enjoyed spilling their guts, but my heart isn\'t in it anymore. Send the rest of the men my regards.%SPEECH_OFF%And with that the orcslayer, or former-orcslayer, departs the company.",
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
		if (this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() == 1)
		{
			return;
		}

		local slayer;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.orc_slayer")
			{
				slayer = bro;
				break;
			}
		}

		if (slayer == null)
		{
			return;
		}

		this.m.Dude = slayer;
		this.m.Score = 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"orcslayer",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});


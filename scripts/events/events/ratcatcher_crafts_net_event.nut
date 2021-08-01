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
			Text = "[img]gfx/ui/events/event_05.png[/img]You come across %ratcatcher% sitting with his hands full of rope. He\'s got the cords looping so ferociously - as ropes can be looped - that you worry to not put your foot close to it. Curious, you ask the man what he\'s up to. As though he were expecting just that question, he quickly raises his project into the air and announces he\'s fashioned himself a net. Ah! You put your hands to your hips.%SPEECH_ON%That shall be great on the battlefield!%SPEECH_OFF%The ratcatcher purses his lips. He slowly lowers the net.%SPEECH_ON%Oh, I meant... to use it... to snag me some rat...%SPEECH_OFF%He pauses, then throws his head up, a cheeky if not cheesy smile adorned across it.%SPEECH_ON%But I shall use it on the field of battle! No rat, man or furry or that which scurries, shall escape me!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Very good.",
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


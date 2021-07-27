this.butcher_vs_wardog_event <- this.inherit("scripts/events/event", {
	m = {
		Butcher = null
	},
	function create()
	{
		this.m.ID = "event.butcher_vs_wardog";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_27.png[/img]You hear a yelp and quickly rush to the noise. When you get there, you\'re not sure whether it was man or dog that produced it. %butcher% the butcher is holding a cleaver up and a wardog is rearing beneath him, both sides ready to lunge. The man sees you and quickly sweeps the weapon behind his back. The hound takes a squat and throws some puppy eyes your way. Raising an eyebrow, you try not to make sense of the scene.%SPEECH_ON%Play nice now.%SPEECH_OFF%The butcher scoffs.%SPEECH_ON%Oy\', me and the bitch were just having a talk that\'s all.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Uh, right.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				_event.m.Butcher.worsenMood(0.5, "Didn\'t get along with the company\'s wardogs");

				if (_event.m.Butcher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Butcher.getMoodState()],
						text = _event.m.Butcher.getName() + this.Const.MoodStateEvent[_event.m.Butcher.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local numWardogs = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.butcher")
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				numWardogs = ++numWardogs;
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		if (numWardogs < 1)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
				{
					numWardogs = ++numWardogs;
					break;
				}
			}
		}

		if (numWardogs == 0)
		{
			return;
		}

		this.m.Butcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"butcher",
			this.m.Butcher.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Butcher = null;
	}

});


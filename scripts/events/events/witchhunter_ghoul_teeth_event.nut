this.witchhunter_ghoul_teeth_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.witchhunter_ghoul_teeth";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%witchhunter% the witch hunter comes to you with a vial of unknown liquid.%SPEECH_ON%Anti-poison.%SPEECH_OFF%He explains. He pops the cork off and gives you a smell. There\'s a strong scent of piss. He nods.%SPEECH_ON%Aye, it\'s wretched, but you need the wretched to fight the wretched, and a goblin\'s poison is a real wretched matter to contend with. But this will help.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Useful.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local stash = this.World.Assets.getStash().getItems();
				local numPelts = 0;

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.ghoul_teeth")
					{
						numPelts = ++numPelts;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});

						if (numPelts >= 1)
						{
							break;
						}
					}
				}

				local item = this.new("scripts/items/accessory/antidote_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
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
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local numPelts = 0;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.ghoul_teeth")
			{
				numPelts = ++numPelts;

				if (numPelts >= 1)
				{
					break;
				}
			}
		}

		if (numPelts < 1)
		{
			return;
		}

		this.m.Witchhunter = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = numPelts * candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
	}

});


this.broken_wagon_in_swamp_event <- this.inherit("scripts/events/event", {
	m = {
		Butcher = null
	},
	function create()
	{
		this.m.ID = "event.broken_wagon_in_swamp";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_09.png[/img]Swamps are no safe place for a man\'s travels. Judging by the neverending smog and the way the trees bend, there\'s little doubt that it\'s a bubbling domicile for all things demonic. At least that\'s what the druids of these parts like to say. All you find is a couple of dead horses drowned in the mire and a wagon crushed by the mud which has seeped over its wheels and bed. %randombrother% rifles through the remains and manages to recover some items.%SPEECH_ON%Well, it\'s something. Whoever left this here left a short while ago. Probably spooked by whatever the hell lives out here in the day-to-day.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Still useful.",
					function getResult( _event )
					{
						if (_event.m.Butcher != null)
						{
							return "Butcher";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(5, 15);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Tools and Supplies."
				});
			}

		});
		this.m.Screens.push({
			ID = "Butcher",
			Text = "[img]gfx/ui/events/event_14.png[/img]%SPEECH_ON%Sir, wait.%SPEECH_OFF%The former butcher, %butcher%, says. He moves on ahead and starts hacking at the corpse of a horse. He cuts out a series of chunks, wraps them in large leaves, dries them with a bit of dirt and salt, and hands them over.%SPEECH_ON%No reason in leaving behind what can be used.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And you\'re sure this is edible still?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				local item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Swamp)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.butcher")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Butcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 9;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"butcher",
			this.m.Butcher != null ? this.m.Butcher.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Butcher = null;
	}

});


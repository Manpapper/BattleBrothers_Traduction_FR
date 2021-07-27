this.mountains_are_dangerous_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.mountains_are_dangerous";
		this.m.Title = "In the mountains...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_42.png[/img]Although deep in the mountains, you can see the peaks of the cordillera stretching further onward yet, each one piping up between the valleys of the other. It is a beautiful sight, but also an exhausting one. Hiking through the passes - and sometimes finding passes of your own - has been hard on the men. Slopes of whinstone and sediment and unruly gravel have your men clambering on hands and knees. Each slippery talus funnels the weary back down from whence they came, testing the resolve of those who are not keen on so many a repeat journey.\n\n And yet, around you there are mountain goats traipsing about. One bounds impossibly up an anticline with mocking ease and another chamfers on dry grass between confused bleats. Bridges of stone, cantilevered overhead with jurassic geology, bear the winking heads of curious mountain lions. You get the feeling they\'ve seen your kind before. They know not to attack, but they follow nonetheless. Maybe one of you will fall and break something and the maimed shall be left behind because carrying the wounded in such a place is a death for two.\n\nTaking stock of your men, you find many are suffering injuries. Shin splints. Sore calves. Throbbing knees. Probably some broken bones, but nothing fatal. Only the strong and agile can safely navigate their way through a place such as this, and indeed they are typically the first to the top of every climb.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn this place!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveEffect();
			}

		});
	}

	function giveEffect()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local result = [];
		local lowestChance = 9000;
		local lowestBro;
		local applied = false;

		foreach( bro in brothers )
		{
			local chance = bro.getHitpoints() + 20;

			if (bro.getSkills().hasSkill("trait.dexterous"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.sure_footing"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.strong"))
			{
				chance = chance + 20;
			}

			for( ; this.Math.rand(1, 100) < chance;  )
			{
				if (chance < lowestChance)
				{
					lowestChance = chance;
					lowestBro = bro;
				}
			}

			applied = true;
			local injury = bro.addInjury(this.Const.Injury.Mountains);
			result.push({
				id = 10,
				icon = injury.getIcon(),
				text = bro.getName() + " suffers " + injury.getNameOnly()
			});
		}

		if (!applied && lowestBro != null)
		{
			local injury = lowestBro.addInjury(this.Const.Injury.Mountains);
			result.push({
				id = 10,
				icon = injury.getIcon(),
				text = lowestBro.getName() + " suffers " + injury.getNameOnly()
			});
		}

		return result;
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains || this.World.Retinue.hasFollower("follower.scout"))
		{
			return;
		}

		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


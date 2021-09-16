this.lone_wolf_origin_depressing_lady_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.lone_wolf_origin_depressing_lady";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_91.png[/img]{You come across an old woman outside of the home of a nobleman. She sizes you up as though she were looking into her own past. Amused, you ask her what it is she wants. The lady smiles.%SPEECH_ON%What is it you think you\'re doing, exactly? Wandering the land as a hedge knight, killing and slaying and farkin\' the ladies now and again?%SPEECH_OFF%Politely, you inform her that you are in fact not just some tournament hopper, but a bonafide sellsword. She shrugs and throws her hand to a nobleman\'s house.%SPEECH_ON%And what of it? They\'ll never accept you. You\'ll be a fighter. You\'re out here, forever. You only go inside when they let you. This is not a world you can improve yourself in. You are what you are born as.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This world is what I make of it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.lone_wolf")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});


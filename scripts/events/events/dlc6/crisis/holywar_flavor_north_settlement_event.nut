this.holywar_flavor_north_settlement_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_north_settlement";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_41.png[/img]A wagon is stopped on the side of the road. You find a man looking at a wide variety of wares. He turns to your and speaks.%SPEECH_ON%Ah, a sellsword. I imagine you\'re apart of the holy war, huh? Well, I hope you do right by your gods. I know coin\'s important, but there\'s more to life, and more after, understand?%SPEECH_OFF% | [img]gfx/ui/events/event_97.png[/img]You find a few children playfighting each other, some dressed up in loose clothing like you\'d find in the southern deserts. The latter bunch fall easy to the preying swords of the more northern dressage.%SPEECH_ON%Ah-ha! The Gilded fall, and may the old gods take the glory we\'ve to give!%SPEECH_OFF%The kids calm down and then reset to positions. This time, they change guard, each exchanging clothes until the \'bad guys\' become \'good guys\' and then the play resumes. The holy war of the future will not be on short supply of faithful fighters, that\'s certain. | [img]gfx/ui/events/event_40.png[/img]You come across a monk reading a scroll. He states that the old gods have willed the north to victory, and that glory shall be shared in terraria and more. You ask what happens if the north loses. It is a brazen question, certainly, yet he takes it on the chin with a smile.%SPEECH_ON%Do not fool yourself, sellsword, in thinking that our holy war today is all that there will be. These wars will continue until an obvious end, and it will be at that end where we shall find most glory. I pray I live to see it, but my father and his father prayed the same, and alas I believe it will be my son who shall see the holy war brought to their righteous end.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "If you say so.",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.FactionManager.isHolyWar())
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();
			local nearTown = false;

			foreach( t in towns )
			{
				if (!t.isSouthern() && t.getTile().getDistanceTo(playerTile) <= 5 && t.isAlliedWithPlayer())
				{
					nearTown = true;
					break;
				}
			}

			if (!nearTown)
			{
				return;
			}

			this.m.Score = 10;
		}
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


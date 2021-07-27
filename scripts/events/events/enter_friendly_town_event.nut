this.enter_friendly_town_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.enter_friendly_town";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_85.png[/img]{Your arrival in %townname% seems to be cause for some celebration. One of the town\'s councilman greets you, offering refreshments. | %townname% shows its appreciation for your business there by handing you and your men a tray of refreshments. %randombrother% slams a few mugs down as a dainty, girlish server looks on in awe. He wipes his mouth.%SPEECH_ON%Appreciated. More, please.%SPEECH_OFF% | Business in %townname% has been good and the people there seem to appreciate you more and more: on today\'s arrival they gave you {plenty of useless thanks | a storm of gratitude | flowers upon flowers which you have no use for | trinkets and other things that you throw away when the peasants aren\'t looking | a tray of ale which your men quickly consume | a cask of ale which your men tactlessly criticize as \'tasting wooden\' | a few marriage proposals which you gracefully turn down | a few marriage proposals which you can\'t turn down fast enough | one marriage proposal from the town ugly. She has a face that could stop a sundial. You decline the offer | a quick celebration wherein a few people shouted incoherently. Their tone seemed cheery, anyway | a few slaps on the back. You reminded them that such a doing might leave them handless on the next go around | an offering of orphans. You\'ve no idea what gave them the notion that you\'d accept such a gift, but you return the children to their sad home, also known as the streets}.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Always nice to be in %townname%.",
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearTown = false;
		local town;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer() && t.getFactionOfType(this.Const.FactionType.Settlement).getPlayerRelation() > 80)
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
		this.m.Score = 15;
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


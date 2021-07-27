this.player_is_sent_for_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.player_is_sent_for";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]{Your company seems to have caught the attention of a messenger on the road.%SPEECH_ON%{Sirs, %settlement% to the %direction% is in dire need of help and has requested any and all able men, particularly those of the sword selling sort, to come and help. | Ah, the %companyname%, just the sort I was hunting for. %settlement% to the %direction% is requesting help with a problem. If you\'re looking for work, I wager you head that way. And make sure to tell them I sent ya, I get two extra crowns for it. | Hey there sword selling sirs, %settlement% to the %direction% is in need of your services. I suggest you head that way if you\'re looking for work. | Looking for work? You don\'t march like you got purpose, so let me tell ya that %settlement% to the %direction% has got some jobs for your lot. | Ah, a sellsword without a role in this world? Woe is ye. Well, %settlement% not far from here has got something for ya. I suggest you get on to it. | I\'m here to tell yas that %settlement% is looking for workers. Not laborers, mind. I\'m speaking to you for a reason. Take your swords and killers there if ya want some proper coin. | Hey there, ya should know that %settlement% is looking for men of your kind. Find your way there and you may have a new job yet. | Looking for work are ye? Then get on to %settlement% to the %direction%, it\'s no mystery to no one that they\'re looking for men like you.}%SPEECH_OFF%Thanking the courier, you check your maps to see if it\'s worth the trip.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Paid work, you say?",
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (this.World.Contracts.getActiveContract() != null)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearestTown;
		local nearestDist = 9000;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = t.getTile().getDistanceTo(currentTile) + this.Math.rand(0, 10);

			if (d < nearestDist && t.isAlliedWithPlayer() && this.World.FactionManager.getFaction(t.getFaction()).getContracts().len() != 0)
			{
				nearestTown = t;
				nearestDist = d;
			}
		}

		if (nearestTown == null)
		{
			return;
		}

		this.m.Town = nearestTown;

		if (this.World.getTime().Days <= 10)
		{
			this.m.Score = 30;
		}
		else
		{
			this.m.Score = 10;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"settlement",
			this.m.Town.getName()
		]);
		_vars.push([
			"direction",
			this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Town.getTile())]
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});


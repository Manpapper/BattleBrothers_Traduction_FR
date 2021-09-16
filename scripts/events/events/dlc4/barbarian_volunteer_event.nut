this.barbarian_volunteer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.barbarian_volunteer";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Unlike the south, finding travelers on the northern \'roads\' is often a cause for caution. You ever know what monstrous man or beastly barbarian you\'ll come across next. This time it is a large man limping with a dog beside him. You draw your sword halfway out of its sheath and loud enough to gain his ear. The man looks up and his dog rears to the sudden yank of a leash. The northerner can speak a bit of your tongue.%SPEECH_ON%Ahh, fighters. I\'m a fighter myself.%SPEECH_OFF%You ask why he is alone. He explains that his clan had a dispute, and that he was to duel another man to decide who would take control. You ask why he did not duel this man, you ask if he is afraid. The traveler shakes his head.%SPEECH_ON%No. The clansman was my brother. And I\'d no desire to kill kin. They gave me this bitch here as both insult and reward and threw me from the tribe. I\'ve no land or people to go to, but if you\'d have me, I\'d surely fight for you just as well as anyone else.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'ve found a new tribe, friend.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no need for you.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"barbarian_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% joined you after being exiled from his tribe in the north for refusing to kill his brother. He\'ll fight for you as well as for anyone.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().equip(this.new("scripts/items/accessory/warhound_item"));
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.7)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.raiders")
		{
			this.m.Score = 20;
		}
		else
		{
			this.m.Score = 5;
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
		this.m.Dude = null;
	}

});


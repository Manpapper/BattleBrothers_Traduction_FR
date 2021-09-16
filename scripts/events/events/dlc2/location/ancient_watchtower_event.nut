this.ancient_watchtower_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.ancient_watchtower";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_108.png[/img]{The spire is twice as tall as any castle you\'ve seen, and narrower than any tower. It is as though someone had all the material to build a fortress, and instead of building the bastion they built the spire. %randombrother% squints as he looks up at its rise.%SPEECH_ON%Like it just goes on forever, sir. Damn near right to the clouds.%SPEECH_OFF%You enter with a map and a few men. Inside you find a glass sphere sitting on a hollowed lectern. Inside the bulb sits some powdery remains. Perhaps the last issuance of magic, you know not. Your intuition tells you that whoever dwelled in this slender refuge did not always take the stairs. But you\'ll have to. The climb is brutal and long. At the top you find yet another bulb, this one jagged and shattered, and beneath the glass a skeleton. A broken staff lies nearby. You shake your head and head toward the crenelations. So far are the sights the world itself seems to curve at the horizon, a strange trick of the eye no doubt. You draw the geography upon your map, take a five minute breather, then descend back down.\n\nWhen you get to the bottom the skeleton is there with its staff beside it and the busted bulb is on the lectern. The whole group of men run out the door and you\'re hot on their heels. Looking back, you see the spire\'s gate slowly close with a mighty metal clank.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, at least we got a lay of the land.",
					function getResult( _event )
					{
						this.World.uncoverFogOfWar(this.World.State.getPlayer().getPos(), 1900.0);
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
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});


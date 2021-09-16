this.schrat_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.schrat_exposition";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{You come across a young traveler on the road. His straw hat is turned inside out as though he meant for it to catch rain. He\'s got a walking stick with its end shaved to a ball to navigate muddy roads. When you get near, he straightens up and tents his hands on the top of the staff.%SPEECH_ON%Oy\', mercenaries are ye? I\'d avoid the forests if I were ye. They say trees roam those parts now. They don\'t do so in menace, but neither does a motha\' bear when it chows down on your balls for getting too close. It\'s a matter of nature, ye know?%SPEECH_OFF%Uh, sure. | A man is found beside the road reading some tomes. He looks up, turning one of the pages for you to see, displaying a drawing of a tree with long branches extended to the ground. The trunk is lit with eyes.%SPEECH_ON%They call \'em schrats. Trees that will claw and kill anything that gets close, but I don\'t think that\'s quite right. I don\'t think they\'re animals, I think they\'re calculating and smart monsters with a vengeful attitude toward matters of trespass. So don\'t trespass upon them, understand? Stay out of the forests.%SPEECH_OFF%Not in the mood for idle tree talk, you wish the man well in his studies and quickly move on. | An elderly woman carrying a basket crosses paths with your company. She gestures toward the goods, a pile of chopped firewood.%SPEECH_ON%If ye want some fyewood, aye, best stay clear of where I got it.%SPEECH_OFF%You ask what she means. She grins all wily like.%SPEECH_ON%A schrat in the forest watched me do it, gave me propuh permission to warm meself with this here tinder. Didn\'t give my uncle permission. It tore my uncle in half and hung his flesh. Peehaps ornamental value, ye know?%SPEECH_OFF%Er, of course.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "An enemy such as this shouldn\'t be taken lightly.",
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type == this.Const.World.TerrainType.Desert || currentTile.Type == this.Const.World.TerrainType.Oasis || currentTile.TacticalType == this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		this.m.Score = 5;
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


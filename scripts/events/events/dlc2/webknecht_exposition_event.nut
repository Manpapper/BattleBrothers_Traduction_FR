this.webknecht_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.webknecht_exposition";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{You find a man beside the road churning leaves with a mortar and pestle. He\'s also chewing some of the goods himself and looks up at you with a green grin.%SPEECH_ON%I\'ve dealt with the bugs and insects all m\'life, but them webknechts are something else entirely. I ain\'t ever seen a bug move tha\' fass. Scissorin\' and zippin\' forward, grabbin\' dogs and cats and such, stealing them aways. You stay clear of them right bastard spiders, ye hear?%SPEECH_OFF%The stranger hocks a loogie and then gets on with his work as though you\'d never come by at all. | A woman in the doorway of a homestead regards the company with a series of nods. With a mug in hand she points at you, sloshing her drink around just as much as her speech.%SPEECH_ON%Ah, spiderfood comin\' thew? Eh? Well git, them eight legged farks ain\'t keen on a game of wait and see, they\'ll find ye as soon as they hungry, and they always hungry, yessir, always foamin\' at the mouth with that poison of theirs, yessir yessir.%SPEECH_OFF%She throws back a mug and falls back into the home\'s doorway with a clunk and clatter. | You come across a young man up in a poplar tree. He\'s somehow managed to construct a tiny abode the size and shape of an outhouse up in the heights. Looking down at you, he nods.%SPEECH_ON%Yeah you are incredulous about me and this here tree, well let me tell ya, them webknechts come fast. Spiders the size of dogs! And you know what I say to that? Fuck all of it. You can find me in these here trees from now on and if those damn beasts grow wings I\'ll just up and off my ownself thank ye very much.%SPEECH_OFF%Webknechts seem to be driving the locals mad, though you can\'t really blame them.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Someone ought to pay us for taking care of them.",
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

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
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


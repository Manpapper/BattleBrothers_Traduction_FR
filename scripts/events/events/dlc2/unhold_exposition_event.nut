this.unhold_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.unhold_exposition";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_126.png[/img]{An old man is drawing upon a rock with some chalk. He regards the company as though it were a distraction to his art, but when you come around the side you see he\'s been \'painting\' what look like giants looming over tribes of man. Tapping the chalk to the rock, he speaks as though in lesson.%SPEECH_ON%I wager the unhold giants have been here much longer than any man. Did you know there\'s sorts that live in the colds, others in the forests, and some in the swamps? And none of them is keen to one another. They\'re basically man at his most basic instincts, destructive toward and spiteful of its own kind, yet most animus is directed at one thing in particular.%SPEECH_OFF%The old man points the chalk at you and tips its end so that powder drifts from its tip.%SPEECH_ON%Outsiders. Stay away from them unholds, traveler.%SPEECH_OFF%He seems a bit wrong in the head and has nothing of value to rob except more chalk, so you hurry the company along. | A young child is found drawing in the mud of the path. As you draw near, you realize he\'s not actually on the path so much as inside a large divot of it where the mud cratered in the shape and size of a sarcophagus. The child is drawing along the inner walls, mostly crude shapes of dogs.%SPEECH_ON%My pa said they was \'unholds\', unholds came thew right this way and to yonder, giants of lore, except they was \'as real as your mother\'s leaving me for that bastard Birk, who I will kill\', he says that part a lot. Birk got it comin\'. So he says. A lot. I think you should stay away from the unholds, mister. My pa says so, so I will too, and you should too. By the way, is yer name Birk?%SPEECH_OFF%You shake your head no and wish the child the best. In many regards you believe what he said was fair enough advice from a kid. | An elderly man with an absolutely boulder of a body regards you from a homestead porch.%SPEECH_ON%You know, I once saw an unhold in person. That\'s right. A real bonafide giant, the size of ten men stacked, if not larger. Was straying down the steppes, chasing horses and such. They sent a militia out after it and the damn thing threw them around like dolls. Picked one man up and threw him so hard I thought he\'d fly over the damn mountains. You seem the fightin\' type, so take it from this old geezer, keep away from them unholds.%SPEECH_OFF%You nod and wish the elder the best.}",
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

		if (currentTile.Type != this.Const.World.TerrainType.Tundra)
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


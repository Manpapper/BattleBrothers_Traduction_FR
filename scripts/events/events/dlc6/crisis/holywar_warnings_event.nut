this.holywar_warnings_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holy_warnings";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 3.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{A peasant passes you on the path. He mentions off-hand that he doesn\'t understand why gods would have their followers fight each other. If it really wanted to be settled, why not do it themselves? You grab him by the shirt and ask what he\'s blathering about. He pulls away.%SPEECH_ON%Oy! Hands off, or I\'ll nip ya! And I\'m just grousing, thass\'all. Lotta talk going around about the Gilded folk and the followers of the old gods butting heads. Again. Now lemme bitch in peace!%SPEECH_OFF%The man walks off, mumbling and, ironically, getting louder in volume the further away he gets from you. | You come across a congress of Gilded and old gods\' monks alike. They\'re discussing the possibility of an upcoming war, and how to protect themselves if such a time comes to pass. It\'s admirably amicable, all told, but it does seem there\'s a hint of religious reckoning in the air. | A man fixing a wagon beside the road shakes his head.%SPEECH_ON%You know, I\'d just like to go from one spot of the world t\'another, and that be that. But no. Farking... something! Always something! Has gotta go wrong. Hey, speaking of wheels, here\'s one I hear turning: the Gilder and the old gods might be knocking heads again. Seen storm clouds of it. Holy war in the sky. Which means holy war here. I hope to get clear of it before it starts. You seen the last one? Nasty business.%SPEECH_OFF%You\'re sure it is, but nasty business means good business for the %companyname%. | %SPEECH_ON%Knees bothering me.%SPEECH_OFF%You look over to see an old man wiggling two stumps. He grins.%SPEECH_ON%That is to say, the spirit of my knee is getting ornery. When I had m\'legs, the tinge in the knee meant bad weather. Now the twinge in no-knee means something worse.%SPEECH_OFF%A young boy comes and hauls the elder into a wheelbarrow. Before he departs, you ask what he means. He turns aside, elbow cocked and hand planted on his hand, looking dapper and lively for what he is.%SPEECH_ON%A reckoning from above. The Gilder, the old gods, maybe even more than just them. I think they\'re all toying with us, spurring us folk to kill one another to appease them, so they can have a watch. You look the part of a sellsword, so I imagine business will be kind to you once them clerical colors wanna go red.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good to know.",
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.FactionManager.getGreaterEvilType() == this.Const.World.GreaterEvilType.HolyWar && this.World.FactionManager.getGreaterEvilPhase() == this.Const.World.GreaterEvilPhase.Warning)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();

			foreach( t in towns )
			{
				if (t.getTile().getDistanceTo(playerTile) <= 4)
				{
					return;
				}
			}

			this.m.Score = 80;
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


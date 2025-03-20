this.miasma_flail_company_nightmare_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.miasma_flail_company_nightmare";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{You dream of your mother. You had not seen her face in some time, and thought you\'d forgotten it, the world having ground down most memories. She is as lovely as you\'d expect, and she draws you in, hand about your hair, threading her fingers through it, the soft hiss of her touch met by the gentlest of whispers. And a moment later she offers a breast to you, and you reel back, unsure, and when you look up the Grand Diviner is there, grinning madly.%SPEECH_ON%Wombless, I ascend, sellsword. The grand nurturer...%SPEECH_OFF%A fleshy golem wraps its red appendages over his shoulders, coiling you up in its greasy grip.%SPEECH_ON%Find in my bosom the raw power of this world, sellsword! Let me mother you into the man you should have been!%SPEECH_OFF%With a snarl, you rip out of the dream and flip off your cot and hit the ground, gasping for air and slapping your face as if whatever dreamt of came back with you. The rest of the company is in an equal state of disrepair, every sellsword having been struck by the same nightmare. You glance over to inventory to see the Grand Diviner\'s flail bristling a bright green, then it fades from your stare, the slightest chuckle following it out...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Motherfarker.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.worsenMood(0.75, "Had a disturbing nightmare involving the Grand Diviner");

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local haveFlail = false;

		foreach( bro in brothers )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && item.getID() == "weapon.miasma_flail")
			{
				haveFlail = true;
			}
		}

		if (!haveFlail)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && item.getID() == "weapon.miasma_flail")
				{
					haveFlail = true;
					break;
				}
			}
		}

		if (!haveFlail)
		{
			return;
		}

		this.m.Score = 6;
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


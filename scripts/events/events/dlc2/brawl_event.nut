this.brawl_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.brawl";
		this.m.Title = "During camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]{You go out for a piss and find yourself midstream when the din of combat erupts behind you. Pinching it off, you fix your drawers and head back for the encampment. There you find the whole company engaged in battle not with any particular foe, but with itself. Sellswords are clambering over equipment and the campfire and each other to swing fists and spin elbows and wrestle one another around or tackle each other to the ground. Anyone who falls gets their ass kicked, literally, until someone else comes along to distract the ones doing the kicking, then the one who had fallen jumps to their feet and throws themselves back into the fray. The ol\' fracas eases as the men slowly realize you\'re there and they shape up and line up as though a swift reorganization would be a suitable resolution for their churlish behavior.\n\n Shaking your head, you ask what sparked it. The men shrug. Not a one can remember. You do a role call to make sure nobody\'s dead. You then tell them all to shake hands, keeping an eye on them as they do so. No bad blood to sniff out. Seems like this was just a bit of a fun tussle and wrassle, that\'s all.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nothing like a good brawl, eh?",
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
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Had a good brawl");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}
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

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 10)
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


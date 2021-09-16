this.teamplayer_is_bro_event <- this.inherit("scripts/events/event", {
	m = {
		Teamplayer = null
	},
	function create()
	{
		this.m.ID = "event.teamplayer_is_bro";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_65.png[/img]{%teamplayer%, always the sort to take one for the company, seems to have singlehandedly helped the resolve of the men. As one sellsword explains it.%SPEECH_ON%I dunno how to explain it.%SPEECH_OFF%As another more articulate mercenary says.%SPEECH_ON%It\'s like he\'s more than just a sword for hire, you know? He\'s someone we can depend on. Like a brother. But not a whole brother, obviously. More like a halfbrother. A bro, if you will.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%teamplayer% is the best.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teamplayer.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Teamplayer.getID() || this.Math.rand(1, 100) <= 10)
					{
						continue;
					}

					if (!bro.getFlags().has("IsTeamplayerInspired") && this.Math.rand(1, 100) <= 50)
					{
						bro.getFlags().set("IsTeamplayerInspired", true);
						bro.getBaseProperties().Bravery += 1;
						bro.getSkills().update();
						this.List.push({
							id = 16,
							icon = "ui/icons/bravery.png",
							text = bro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
						});
					}

					bro.improveMood(0.5, "Happy to have a bro in " + _event.m.Teamplayer.getName());

					if (bro.getMoodState() > this.Const.MoodState.Neutral)
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local numOthers = 0;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.teamplayer"))
			{
				candidates.push(bro);
			}
			else if (!bro.getFlags().has("IsTeamplayerInspired"))
			{
				numOthers = ++numOthers;
			}
		}

		if (candidates.len() == 0 || numOthers == 0)
		{
			return;
		}

		this.m.Teamplayer = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"teamplayer",
			this.m.Teamplayer.getName()
		]);
	}

	function onClear()
	{
		this.m.Teamplayer = null;
	}

});


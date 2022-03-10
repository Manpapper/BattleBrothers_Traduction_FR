this.bad_reputation_event <- this.inherit("scripts/events/event", {
	m = {
		Superstitious = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.bad_reputation";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{A few of the Oathtakers bring a piece of paper to your attention. On it is the name of the %companyname%, a rather amusing drawing of yourself that is not remotely in proportion, and a few choice descriptors of your lowly character. It seems that your reputation in this world is not nearly as high and mighty as you assumed it to be.%SPEECH_ON%We must rectify this, captain! For people to think of the Oathtakers in this manner is a great insult to us, and especially to Young Anselm!%SPEECH_OFF%You agree. | As the company camps, a few of the Oathtakers are grousing about the reputation of the %companyname%.%SPEECH_ON%Young Anselm would not be happy with the way the world sees us. We should be setting an example of how to behave!%SPEECH_OFF%You agree, though it may take some time to repair the Oathtakers\' honor. | Young Anselm founded the Oathtakers with the belief that they should be paragons reestablishing a precedence of honor, virtue, and sound character, elements which he believed the world had lost sight of. Unfortunately, you\'ve struggled to maintain these ideals, slipping the %companyname%\'s reputation a little lower than it ought to be. A few of the men are rightfully complaining, and if they\'re not outwardly complaining it is obvious that these faults are draining morale anyway. You think it best to perhaps start mending the %companyname%\'s reputation as soon as possible lest the men lose faith in its ultimate purpose.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I will lead better.",
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
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(1.0, "Is upset about the company\'s evil reputation");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "Is upset about the company\'s evil reputation");
					}

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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Assets.getMoralReputation() >= 40.0)
		{
			return;
		}

		this.m.Score = 15;
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


this.paladins_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.paladins_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{You knew the game well, and like any good game you got burned out on the rules and the rule setters. Oaths for this, Oaths for that. All you knew is you never got to hold Young Anselm\'s skull, and last you saw some Oathbringer had stolen off with the lad\'s preeminent jaw. Leaving the Oathtakers was the best decision you ever made, if only to preserve what little sanity you had left.\n\nUnfortunately, the faithful have a strong nose for the apostate\'s scent. When you opened the door this morning it was like looking at two piles of shite some prankster kid had left you: %oathtaker1% and %oathtaker2%, in the flesh. The former an older man who simply never shook his beliefs, and the latter a talented squire who reminds you of yourself. No doubt the more mawkish talker, it was the younger lad who made his plea: the Oathtakers need a man familiar with the land to help them around, completing quests and oaths. You shut the door only to find the older man\'s foot in it. He held up a pile of gold, and your nose must have wrinkled or wiggled because both men lit up.\n\nNow, you\'re only going along because times are tough, and because mercenary work – even under the guise of religious duty – can make some outstanding coin. And if someone is willing to bankroll you into such an opulent task, then so be it. There is only one condition: you will take the Oath of Captaincy, which means all the battling and rough roading will be done by others. Without pause, the Oathtakers agree, and then they show you Young Anselm\'s skull. You\'ve lost touch with the organization, but seeing that lad\'s dumb dome still brings a stir in your heart. %oathtaker2% nods.%SPEECH_ON%Let us scour these lands for the honorable, and be diligent in our tasks, and may we ever make Young Anselm whole again from the rat bastard Oathbringers who broke him!%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "For gold, glory, and Young Anselm!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The Oathtakers";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"oathtaker1",
			brothers[0].getName()
		]);
		_vars.push([
			"oathtaker2",
			brothers[1].getName()
		]);
	}

	function onClear()
	{
	}

});


this.renown_tutorial_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.renown_tutorial";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]While the company takes a short rest, you sit down to examine the wound where an arrow punctured your side not long ago. It\'s been healing slowly and still aches if you move too quickly, but things are getting better. %bro1% joins you, seizing this opportunity to talk to his captain.%SPEECH_ON%So the way I see it, nobody knows about the %companyname% yet. We don\'t want to hunt rag-tag bands of brigands through the woods forever, but we\'ll have to make a name for ourselves first as reliable swords-for-hire that can get things done before the noble houses take notice. They\'ll want to use the company for far better paying tasks, I\'m sure.%SPEECH_OFF%He adjusts his weapon belt and continues.%SPEECH_ON%Just we keep in mind that the high lords are playing a dangerous game and we don\'t want to get on their bad side. There\'s enough stories of people who crossed them only to end up quartered and fed to the pigs, and they have the means to squish even a company of sellswords.%SPEECH_OFF%He pauses a short moment and then adds another thought.%SPEECH_ON%The guildmasters and councilmen running the villages and towns, too, have a good memory. We depend on them to hire the company for now, but having some influential friends may also help us get better deals with the merchants.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'ll keep it in mind.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local bro = this.World.getPlayerRoster().getAll()[0];
				this.Characters.push(bro.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Contracts.getContractsFinished() < 2)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.tutorial")
		{
			return;
		}

		this.m.Score = 5000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bro1",
			this.World.getPlayerRoster().getAll()[0].getName()
		]);
	}

	function onClear()
	{
	}

});


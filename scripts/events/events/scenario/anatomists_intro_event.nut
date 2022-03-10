this.anatomists_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.anatomists_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_181.png[/img]{You thought them bounty hunters at first, but they were quick to correct you in that they announced themselves as \'researchers,\' not \'searchers.\' When you were still yet confused, they explained that they were \'anatomists\' which did not help their efforts. Frustrated, they called you a \'colloquial hole,\' which you were proud to retort that you knew what \'colloquial\' meant, but they laughed and said you misheard for they were referring to you in the bird-sense. With them laughing in your face, you drew your sword and at this point they put their hands in the air, each one holding a purse filled with crowns.\n\nAfter some further talk, you figured out that they\'re eggheads with a keen interest in corpses. Being that you are quite talented in creating corpses yourself, they saw fit to hire you to do exactly that for them. You will traverse the land, hiring a formidable band of mercenaries, and help these peculiar men accomplish their scientific tasks. All that you ask is that they not do funny things with your body if you happen to die. The anatomists put on warm smiles and promise they\'d never do such a thing to a man they\'re doing business with. Each one of them looks like they learned how to smile from a dead man, but you\'ll just have to take their word for it.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On second thought, promise to leave my body alone while I\'m alive, too.",
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
		this.m.Title = "The Anatomists";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


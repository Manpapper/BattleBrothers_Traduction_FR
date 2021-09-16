this.greenskins_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_intro";
		this.m.Title = "During camp...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]%randombrother% enters your tent.%SPEECH_ON%Sir, we got a group of refugees out here that\'d like to talk to you.%SPEECH_OFF%You set aside your quill pen and go to meet them. They\'re an awful mess, looking more like dishrags thrown to the mud than people. One, a man nursing a nub where his hand used to be, steps forward and speaks.%SPEECH_ON%I take it you\'re the one in charge?%SPEECH_OFF%Nodding, you ask the man what has happened and why it concerns the company. He explains, gesticulating with his one good hand.%SPEECH_ON%The greenskins are attacking.%SPEECH_OFF%Well, that\'s nothing new. You ask where they are and if they\'re goblins or orcs. The man shakes his head.%SPEECH_ON%Well, see, that\'s just the thing. It\'s both. They\'re... they\'re working together. Hordes of them as numerous as the blades of grass beneath our feet. I misspoke, in a way. What I should have said is that they aren\'t just attacking, they\'re INVADING. All of them. Together. An invasion beyond any scope or measure, don\'t you understand?%SPEECH_OFF%You look at the crowd of refugees. Children huddled beneath the skirts of their mothers, men looking lost. The man continues.%SPEECH_ON%My father fought in the Battle of Many Names. He always did say they\'d come back and now I suppose he\'s right. We hear the noble houses are panicking and might join forces, lest we all be overrun! If you want my advice, I say stay out of it. Those hordes... there\'s no stopping them. And the things they do...%SPEECH_OFF%You grab the man by his shirt.%SPEECH_ON%The things they do don\'t worry me. Get out of here, peasant, and leave the fighting to the fighters.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "War is upon us.",
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
		if (this.World.Statistics.hasNews("crisis_greenskins_start"))
		{
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_greenskins_start");
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


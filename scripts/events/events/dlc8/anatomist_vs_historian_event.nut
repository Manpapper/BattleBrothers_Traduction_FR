this.anatomist_vs_historian_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_historian";
		this.m.Title = "During camp...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]{%historian% the historian and the anatomists are getting into some sort of scribal spat. You walk over to see that %historian% is holding up a book filled with bodily descriptions and images. He states that it is the most accurate portrayal of the human body known to man, but the anatomists scoff, saying such a book doesn\'t exist for they have yet to write one. Interested, you take a look at the book. The drawings show man as a series of what look like very long worms, that flow to his heart and back out, each dedicated to one particular traversal. Other pages show the body parts laid out, showing lungs, kidneys, the liver, and more. It does seem rather detailed, but you\'re not exactly one to know who would ever be right in this case.%SPEECH_ON%Do not ascribe to that book\'s lies, captain. Let us anatomists do our work, so that such awful tomes may be put to the dust where they belong.%SPEECH_OFF%Furious, the historian snatches the book from your hand and shows a page to them. It has the human brain displayed, with numerous ropes or cords stretching out from it and down the spine. He states that this is central to the human experience, all that we are and all that we think we are is found in this organ. Again, the anatomists scoff. The historian turns to you, as though your layman\'s perspective might arbitrate the feelings of eggheads, and indeed every party present seems to wait on your word.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I think the historian is correct.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "The anatomists probably know more on this.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]{You sigh and say, without literally any knowledge about the subject at all, that the historian has the right idea. After all, if someone put it in ink, then surely it meant something important, and was presumably right. This assertion brings both parties together against you. Even the historian protests, despite your defense of him.%SPEECH_ON%Just because it\'s in ink does not in anyway mean it is therefore automatically correct.%SPEECH_OFF%Sighing again, you ask who would waste ink on the wrong idea? Both the historian and the anatomists laugh at you for doubling down on such an absurd notion. They walk off together shaking their heads and muttering something about the laity. For a brief moment, you picture yourself running them all through with a sword and the image is grossly satisfying, but that\'s where you leave it.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Getting bullied by eggheads.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]{You tell the historian that the anatomists are well traveled and surely they have seen other books greater and grander than the one he has. The anatomists turn to you. They speak plainly.%SPEECH_ON%No, we haven\'t.%SPEECH_OFF%Not sure what they mean, you try and press the fact that you\'re defending them on this issue, reiterating that surely they\'ve read plenty on the subject. Again, they scoff at you.%SPEECH_ON%Read plenty? READ? Do you not see that we have come out this way not in the interest of reading, but of doing. We are men of action, and by action we will find the truth of all matters of this world, particularly those regarding its men and beasts alike. The idea that we read our way to this position is something we take offense to.%SPEECH_OFF%Sighing, you try to amend the issue, but now %historian% the historian jumps in.%SPEECH_ON%Captain, do you also see me in this light? That I have merely read my way to this position? I, too, can fight, you know? That is why I am here. I hope you do not see me as someone of minor use to read a book here and there and do little else.%SPEECH_OFF%You\'ve enough of this lot and turn and leave, hearing mutterings of how insulting it is that you think of them as mere eggheads and not the warriors that any sellsword company would hire. A thought of challenging them to martial combat arises, but you leave it be. Another thought of simply slaughtering them in their sleep also comes to mind. You dwell on it for a minute, but also let it go.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Getting bullied by eggheads.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local historianCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.historian")
			{
				historianCandidates.push(bro);
			}
		}

		if (historianCandidates.len() == 0 || anatomistCandidates.len() <= 1)
		{
			return;
		}

		this.m.Historian = historianCandidates[this.Math.rand(0, historianCandidates.len() - 1)];
		this.m.Score = 5 * historianCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian.getName()
		]);
	}

	function onClear()
	{
		this.m.Historian = null;
	}

});


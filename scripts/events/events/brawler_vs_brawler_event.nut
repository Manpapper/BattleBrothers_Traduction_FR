this.brawler_vs_brawler_event <- this.inherit("scripts/events/event", {
	m = {
		Brawler1 = null,
		Brawler2 = null
	},
	function create()
	{
		this.m.ID = "event.brawler_vs_brawler";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]As you sit with the men around the fire, a discussion across the flames starts to get a little loud. %brawler% the brawler stands up and points at his own chest with a hearty laugh.%SPEECH_ON%You? You think you could take me?%SPEECH_OFF%The other brawler, %brawler2%, jumps to his feet.%SPEECH_ON%Take you? I could put ya under the ground ya farkin\' pillowfisted fool!%SPEECH_OFF%The slightest suggestion that %brawler%\'s fists weren\'t made of jaw-demolishing bricks kicks off a brutal fight. The brawlers grab one another and swing their free hands in looping undercuts. Each punch lands with cracking ferocity. Surely no man could take so much damage and stay on his feet, but here you\'re witnessing two fellas doing just that. You order the company to break up the fight.\n\n%brawler% pinches a nostril and shoots blood out of the other. He shrugs.%SPEECH_ON%Just havin\' a bit o\' a scrap, sir.%SPEECH_OFF%Popping a shoulder back into socket, %brawler2% nods.%SPEECH_ON%Aye, no harm no foul.%SPEECH_OFF%You watch as the two men shake hands and clap one another on the shoulder, each congratulating the other on how nasty their punches were.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'s one way to come together.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler1.getImagePath());
				this.Characters.push(_event.m.Brawler2.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury1 = _event.m.Brawler1.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury1.getIcon(),
						text = _event.m.Brawler1.getName() + " suffers " + injury1.getNameOnly()
					});
				}
				else
				{
					_event.m.Brawler1.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Brawler1.getName() + " suffers light wounds"
					});
				}

				_event.m.Brawler1.improveMood(2.0, "Bonded with " + _event.m.Brawler2.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Brawler1.getMoodState()],
					text = _event.m.Brawler1.getName() + this.Const.MoodStateEvent[_event.m.Brawler1.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Brawler2.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Brawler2.getName() + " suffers " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Brawler2.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Brawler2.getName() + " suffers light wounds"
					});
				}

				_event.m.Brawler2.improveMood(2.0, "Bonded with " + _event.m.Brawler1.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Brawler2.getMoodState()],
					text = _event.m.Brawler2.getName() + this.Const.MoodStateEvent[_event.m.Brawler2.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.brawler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local idx = this.Math.rand(0, candidates.len() - 1);
		this.m.Brawler1 = candidates[idx];
		candidates.remove(idx);
		idx = this.Math.rand(0, candidates.len() - 1);
		this.m.Brawler2 = candidates[idx];
		this.m.Score = candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brawler",
			this.m.Brawler1.getNameOnly()
		]);
		_vars.push([
			"brawler2",
			this.m.Brawler2.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Brawler1 = null;
		this.m.Brawler2 = null;
	}

});


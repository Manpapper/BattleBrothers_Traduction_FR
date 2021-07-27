this.flagellation_event <- this.inherit("scripts/events/event", {
	m = {
		Flagellant = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.flagellation";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%otherguy% approaches with a pained look on his face. His helmet is in hand as he wipes his brow.%SPEECH_ON%Sir, uh, you should come and see this.%SPEECH_OFF%You inquire as to what it is you are going to see.%SPEECH_ON%I don\'t have the words for it. You\'d best come and see with your own eyes.%SPEECH_OFF%You look down at your work - plotting the march for the coming days - but, judging by the look on the brother\'s face, it can wait.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Show me, then.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]You get up and have him lead you to whatever it is that\'s causing an issue. You come across a throng of brothers circled around something or someone. Breaking your way through the crowd, the company quiets as you come into the clearing to find %flagellant_short% the flagellant unconscious on the ground.\n\nHis back is stripped raw and you think you can even see a rib or two. Thorns have broken off his brutish whip, embedding themselves in his flesh, and his skin hangs in strands where it hangs at all. It is good he has passed out. Not because he would be horrible in pain, but because you think he might not otherwise have stopped. You order the men to clean him up, dress his wounds, and hide his tools of misery.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "À least he didn\'t kill himself.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury = _event.m.Flagellant.addInjury(this.Const.Injury.Flagellation);
					this.List = [
						{
							id = 10,
							icon = injury.getIcon(),
							text = _event.m.Flagellant.getName() + " suffers " + injury.getNameOnly()
						}
					];
				}
				else
				{
					_event.m.Flagellant.addLightInjury();
					this.List = [
						{
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = _event.m.Flagellant.getName() + " suffers light wounds"
						}
					];
				}
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
			if ((bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Flagellant = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = candidates.len() * 10;

			foreach( bro in brothers )
			{
				if (bro.getID() != this.m.Flagellant.getID())
				{
					this.m.OtherGuy = bro;
					break;
				}
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"flagellant",
			this.m.Flagellant.getName()
		]);
		_vars.push([
			"flagellant_short",
			this.m.Flagellant.getNameOnly()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Flagellant = null;
		this.m.OtherGuy = null;
	}

});


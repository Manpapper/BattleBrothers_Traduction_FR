this.flagellant_vs_monk_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.flagellant_vs_monk";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]The campfire shines bright, twisting the faces of men in flowing orange as though they themselves were of burning stock.\n\n It is here you find %monk% and %flagellant% talking to one another. Their discussion is, at first, an easy one. The monk pleads with the flagellant to set aside his whip. While you don\'t necessarily wish to step in, you can\'t help but agree that destroying your own body on a glorified gore-schedule is not the best way to live. But then the flagellant retorts with something that gives you both pause. It is a phrase so well crafted that to think it might justify the man\'s personal habits has you pushing the notion out of your head as fast as possible. Disturbing, too, was the ease with which he said it. That such a soothing voice could be so warmly bundled in that scarred husk of flesh. What could muster it?\n\n The monk stammers for a moment, but then puts his hands to the flagellant\'s shoulders, holding him to keep their eyes on one another. He whispers, words which tickle your ears, but don\'t pronounce themselves loud enough to have real meaning. You can only assume they are meant to, once again, persuade the flagellant to a better, less violent life.\n\n But, again, the flagellant begins to respond and so back and forth they continue to go.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This is fascinating. Let\'s see where it goes.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Alright that\'s enough. We\'ve got actual work to do.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]Deciding to let the men talk, you step away for a time. When you return, you find the flagellant sitting next to the monk. The two saw back and forth on a log, their hands clasped in prayer as whispers of heavenly words part their lips. You\'ve no urge to get closer to hear what they are saying for it is a comforting sight in and of itself. While you have no dog in what way is best to appease the gods, you can\'t help but feel a little better seeing the flagellant put down his tools of self-torture.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "May the man find his peace now.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local background = this.new("scripts/skills/backgrounds/pacified_flagellant_background");
				_event.m.Flagellant.getSkills().removeByID("background.flagellant");
				_event.m.Flagellant.getSkills().add(background);
				_event.m.Flagellant.m.Background = background;
				background.buildDescription();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Flagellant.getName() + " is now a Pacified Flagellant"
					}
				];
				_event.m.Monk.getBaseProperties().Bravery += 2;
				_event.m.Monk.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Détermination"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Deciding to let the men talk, you step away for a time.\n\nWhen you come back, the monk is naked and bent over with tears in his eyes. His shape is craven, but his face is gutting as though this is always what he wanted. With a gulp of air he straightens up and flicks his wrist over his shoulder. The flagellant\'s whip is in hand and you hear the leather slap against the monk\'s back. He pulls the tool away and the sound of glass and barbs tearing flesh causes a ringing in your ears. The flagellant himself says nothing. He has set himself down by the monk\'s side. He stares out across the land, but there is hardly a shimmer of life in his eyes, though you certainly see the blood of his life leaving his backside as he treats himself to a beating.\n\nYou step away once more, but the grass beneath your feet doesn\'t have the same crunch to it and the air carries a copper scent. Little leather snickers follow you all the way back to your tent.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A man left to torture himself can find the truest of horrors.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local background = this.new("scripts/skills/backgrounds/monk_turned_flagellant_background");
				_event.m.Monk.getSkills().removeByID("background.monk");
				_event.m.Monk.getSkills().add(background);
				_event.m.Monk.m.Background = background;
				background.buildDescription();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Monk.getName() + " is now a Monk turned Flagellant"
					}
				];
				_event.m.Flagellant.getBaseProperties().Bravery += 2;
				_event.m.Flagellant.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Flagellant.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Détermination"
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

		local flagellant_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.flagellant")
			{
				flagellant_candidates.push(bro);
			}
		}

		if (flagellant_candidates.len() == 0)
		{
			return;
		}

		local monk_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				monk_candidates.push(bro);
			}
		}

		if (monk_candidates.len() == 0)
		{
			return;
		}

		this.m.Flagellant = flagellant_candidates[this.Math.rand(0, flagellant_candidates.len() - 1)];
		this.m.Monk = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk.getName()
		]);
		_vars.push([
			"flagellant",
			this.m.Flagellant.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.Flagellant = null;
	}

});


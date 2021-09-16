this.alp_nightmare1_event <- this.inherit("scripts/events/event", {
	m = {
		Victim = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.alp_nightmare1";
		this.m.Title = "During camp...";
		this.m.Cooldown = 300.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{The men are talking around the campfire when %spiderbro% suddenly jumps to his feet screaming. He bounds backward, and lit by the flames you see a spider the size of a helmet glommed onto his boot!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Someone slash it off!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Burn it in the fire!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]{You draw your blade, but %otherbro% has already beaten you to the punch. He yells at %spiderbro% to stand still which he reluctantly does. But the armed sellsword swings his blade far too high and cuts straight through the man\'s neck. The headless body buckles and the rest of the company screams in horror and rage.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What the fuck!",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.Characters.push(_event.m.Other.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Victim.getName() + " has died"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Victim.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_39.png[/img]{You run toward %otherbro% looking to choke the very life out of him, only for your hands to sift through the flesh like fingers into fog and your momentum sails you into the ground.%SPEECH_ON%Uh, you alright captain?%SPEECH_OFF%Looking back, you see a perfectly healthy %spiderbro% sitting beside the fire. Far off in the distance, something pale and sleek steps back from a tree trunk. When you blink, it\'s gone. You tell the men to mind the perimeter and then return to your tent, shaking your head and pinching your eyes.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Just a bad dream.",
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
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%spiderbro% nods and stiffly walks toward the campfire with the spiderling looking up at him with oddly trusting eyes. He puts the critter to the pit and it is immediately set ablaze. At first, you think he\'s done it, he\'s in the clear, but the fiery spiderling sprints up the man\'s pantleg, setting his attire alight, and gloms onto his head. Set afire, the man throws his hands out and begins to run around for help. The beast burrows its fangs into his skull and the screaming ceases in sudden paralysis and the sellsword falls into the campfire like a board of wood.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get his body out of there!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Victim.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Victim.getName() + " has died"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Victim.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						continue;
					}

					local mood = this.Math.rand(0, 1);
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[mood],
						text = bro.getName() + this.Const.MoodStateEvent[mood]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_39.png[/img]{You scream at the mercenaries to do their part, but when you jump toward the campfire and %spiderbro% there\'s a wash of embers and sparks and when they fade you find the sellsword calmly sitting beside the flames.%SPEECH_ON%Ah, captain, did you say something?%SPEECH_OFF%Looking around, you find the rest of the company engaged in idle chat. When you look back at %spiderbro% you thought you saw a white shadow passing behind him, but upon second glance it is gone. You tell the men to keep a vigilant eye for intruders and then return to your tent.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I need to get more rest.",
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		foreach( i, bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				brothers.remove(i);
				break;
			}
		}

		if (brothers.len() < 3)
		{
			return;
		}

		this.m.Victim = brothers[this.Math.rand(0, brothers.len() - 1)];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Victim.getID())
			{
				other_candidates.push(bro);
			}
		}

		this.m.Other = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"spiderbro",
			this.m.Victim.getName()
		]);
		_vars.push([
			"otherbro",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Victim = null;
		this.m.Other = null;
	}

});


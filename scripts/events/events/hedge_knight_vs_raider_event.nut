this.hedge_knight_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.hedge_knight_vs_raider";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%raider% is sitting out beside the campfire, his eyes set deep into the flames. A few moments ago, a couple of the men were heard yelling at him. A past as a raider isn\'t winning the man many friends. The hedge knight, %hedgeknight%, walks over and stands there beside him. As the two exchange glances, you\'re suddenly worried a fight you can\'t stop is going to break out. Instead, the hedge knight takes a seat. He speaks calmly, though his deep voice is still soundly scary.%SPEECH_ON%You raided coasts, yes? Killed women and children? Stole from the clergy?%SPEECH_OFF%The raider nods.%SPEECH_ON%Aye, and worse.%SPEECH_OFF%%hedgeknight% picks up a chunk of smoldering wood from the fire. He crushes it in his hand, the flames hissing into ash and smoke. He lets it crumble out of a calloused palm.%SPEECH_ON%You shouldn\'t mind what others say, raider. This is a nasty, hungry world, and you mind its teeth well. Let the weak cry out and die. We can only armor ourselves by our very being, wreathed in the envy of the dead who would gladly crush an infant\'s skull for a mere sip of the breath our lungs draw.%SPEECH_OFF%The raider grabs his own chunk of firewood and grinds it up. They shake hands and say nothing more.",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This world favors the strong.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());
				_event.m.HedgeKnight.improveMood(1.0, "Bonded with " + _event.m.Raider.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.HedgeKnight.getMoodState()],
					text = _event.m.HedgeKnight.getName() + this.Const.MoodStateEvent[_event.m.HedgeKnight.getMoodState()]
				});
				_event.m.Raider.improveMood(1.0, "Bonded with " + _event.m.HedgeKnight.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Raider.getMoodState()],
					text = _event.m.Raider.getName() + this.Const.MoodStateEvent[_event.m.Raider.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local hedge_knight_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hedge_knight_candidates.push(bro);
			}
		}

		if (hedge_knight_candidates.len() == 0)
		{
			return;
		}

		local raider_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.raider")
			{
				raider_candidates.push(bro);
			}
		}

		if (raider_candidates.len() == 0)
		{
			return;
		}

		this.m.HedgeKnight = hedge_knight_candidates[this.Math.rand(0, hedge_knight_candidates.len() - 1)];
		this.m.Raider = raider_candidates[this.Math.rand(0, raider_candidates.len() - 1)];
		this.m.Score = (hedge_knight_candidates.len() + raider_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight.getNameOnly()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.HedgeKnight = null;
		this.m.Raider = null;
	}

});


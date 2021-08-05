this.refugee_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		Refugee = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.refugee_vs_raider";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]%refugee%, a man who once forced onto the roads as a refugee, stares blankly at %raider%. The raider, sensing he\'s being stared at, lowers his plate of food.%SPEECH_ON%Whatcha farkin\' looking at, huh?%SPEECH_OFF%The refugee points a dripping spoon.%SPEECH_ON%Yer a raider, right?%SPEECH_OFF%%raider% nods.%SPEECH_ON%Was. Might be again someday. What\'s it to you?%SPEECH_OFF%Standing up, %refugee% points.%SPEECH_ON%It were men like you who forced good people out of their homes. Good people to drag their whole lives onto the damned road.%SPEECH_OFF%Laughing, %raider% gets to his feet.%SPEECH_ON%Oh, is that right? And what made them so good? That they couldn\'t swing a sword or protect themselves? Do you believe for one moment that were the boot on the other foot they wouldn\'t do the same to me? Or to you, too? Folk are only as good as their options.%SPEECH_OFF%The spate\'s getting wild and some of the other mercenaries get to their feet. Nobody can stop the initial scuffle, the two men exchanging blows and curses as good as any tavern brawl you\'ve seen. Thankfully, nothing too serious comes of the fight.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take it easy now.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Refugee.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury1 = _event.m.Refugee.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury1.getIcon(),
						text = _event.m.Refugee.getName() + " souffre de " + injury1.getNameOnly()
					});
				}
				else
				{
					_event.m.Refugee.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Refugee.getName() + " souffre de blessures légères"
					});
				}

				_event.m.Refugee.worsenMood(1.0, "Got in a brawl with " + _event.m.Raider.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
					text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Raider.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Raider.getName() + " souffre de " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Raider.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Raider.getName() + " souffre de blessures légères"
					});
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

		local refugee_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 2 && bro.getBackground().getID() == "background.refugee")
			{
				refugee_candidates.push(bro);
				break;
			}
		}

		if (refugee_candidates.len() == 0)
		{
			return;
		}

		local raider_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 6 && bro.getBackground().getID() == "background.raider")
			{
				raider_candidates.push(bro);
			}
		}

		if (raider_candidates.len() == 0)
		{
			return;
		}

		this.m.Refugee = refugee_candidates[this.Math.rand(0, refugee_candidates.len() - 1)];
		this.m.Raider = raider_candidates[this.Math.rand(0, raider_candidates.len() - 1)];
		this.m.Score = (refugee_candidates.len() + raider_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"refugee",
			this.m.Refugee.getNameOnly()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Refugee = null;
		this.m.Raider = null;
	}

});


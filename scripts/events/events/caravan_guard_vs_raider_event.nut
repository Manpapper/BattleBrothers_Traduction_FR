this.caravan_guard_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		CaravanHand = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.caravan_guard_vs_raider";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]While you expect the men you hire to leave their old lives behind, sometimes it is not so. It appears that %caravanhand% and %raider% are well acquainted: the caravan hand once dealt with the raider personally in some sort of battle that ended with no victors. Now they seek to finish what they\'d started long ago, the two tumbling about on the ground, throwing punches and elbows and some spit if an eye or cheek calls for it. You separate the two yourself, pulling them apart and making it quite clear that they are sellswords now, not enemies. You force the two to shake hands and they do so. The caravan hand nods.%SPEECH_ON%Nice left, %raider%.%SPEECH_OFF%The raider nods back, wiping away a bit of blood running clear of his nose.%SPEECH_ON%Yer stronger than I remember.%SPEECH_OFF%The two men go off together to get fixed up, going as men do, their troubles so easily left behind.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Small world...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.CaravanHand.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.CaravanHand.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.CaravanHand.getName() + " suffers light wounds"
					});
				}
				else
				{
					local injury = _event.m.CaravanHand.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.CaravanHand.getName() + " suffers " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Raider.addLightInjury();
					this.List.push({
						id = 11,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Raider.getName() + " suffers light wounds"
					});
				}
				else
				{
					local injury = _event.m.Raider.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Raider.getName() + " suffers " + injury.getNameOnly()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img]While you expect the men you hire to leave their old lives behind, sometimes it is not so. It appears that %caravanhand% and %raider% are well acquainted: the caravan hand once dealt with the nomad raider personally in some sort of battle that ended with no victors. Now they seek to finish what they\'d started long ago, the two tumbling about on the ground, throwing punches and elbows and some spit if an eye or cheek calls for it. You separate the two yourself, pulling them apart and making it quite clear that they are sellswords now, not enemies. You force the two to shake hands and they do so. The caravan hand nods.%SPEECH_ON%Nice left, %raider%.%SPEECH_OFF%The nomad nods back, wiping away a bit of blood running clear of his nose.%SPEECH_ON%Yer stronger than I remember.%SPEECH_OFF%The two men go off together to get fixed up, going as men do, their troubles so easily left behind.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Small world...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.CaravanHand.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.CaravanHand.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.CaravanHand.getName() + " suffers light wounds"
					});
				}
				else
				{
					local injury = _event.m.CaravanHand.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.CaravanHand.getName() + " suffers " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Raider.addLightInjury();
					this.List.push({
						id = 11,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Raider.getName() + " suffers light wounds"
					});
				}
				else
				{
					local injury = _event.m.Raider.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Raider.getName() + " suffers " + injury.getNameOnly()
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

		local candidates_caravan = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 7 && bro.getBackground().getID() == "background.caravan_guard" && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates_caravan.push(bro);
			}
		}

		if (candidates_caravan.len() == 0)
		{
			return;
		}

		local candidates_raider = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 7 && (bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.nomad") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates_raider.push(bro);
			}
		}

		if (candidates_raider.len() == 0)
		{
			return;
		}

		this.m.CaravanHand = candidates_caravan[this.Math.rand(0, candidates_caravan.len() - 1)];
		this.m.Raider = candidates_raider[this.Math.rand(0, candidates_raider.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onDetermineStartScreen()
	{
		if (this.m.Raider.getBackground().getID() == "background.raider")
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"caravanhand",
			this.m.CaravanHand.getName()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getName()
		]);
	}

	function onClear()
	{
		this.m.CaravanHand = null;
		this.m.Raider = null;
	}

});


this.sellsword_vs_raider_event <- this.inherit("scripts/events/event", {
	m = {
		Sellsword = null,
		Raider = null
	},
	function create()
	{
		this.m.ID = "event.sellsword_vs_raider";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]The raider, %raider%, is sharpening his weapon beside the campfire. He tells stories of his days raiding coasts and making off with piles of loot, his crooked smile grinning in the blade\'s sharpened sheen. %sellsword% the sellsword listens for a time then gets up laughing.%SPEECH_ON%Oh, fella, them quite the stories you tell. Here\'s mine: I earned my keep killing men, whether in their homes or in battle, but men nonetheless. You run about in yer boats, waitin\' for the menfolk to be gone, then ya scamper across the beaches to kick the little lads, rape the lasses, and steal from old friars. You got nothing to boast of, raider.%SPEECH_OFF%%raider% lowers his blade.%SPEECH_ON%We islanders at least have honor amongst us, whereas you\'d stab the %companyname% in the back for an extra crown in your purse. Speak ill of my past again, sellsword, and I\'ll have that mouth of yours gnawing dirt.%SPEECH_OFF%An exchange of fightin\' words leads to just that: a fight. Blades flash and blood is spilled. The rest of the company jumps in before too much damage can be done.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I don\'t give a rat\'s ass where you came from, stop fighting.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sellsword.getImagePath());
				this.Characters.push(_event.m.Raider.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury1 = _event.m.Sellsword.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury1.getIcon(),
						text = _event.m.Sellsword.getName() + " suffers " + injury1.getNameOnly()
					});
				}
				else
				{
					_event.m.Sellsword.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Sellsword.getName() + " suffers light wounds"
					});
				}

				_event.m.Sellsword.worsenMood(0.5, "Got in a fight with " + _event.m.Raider.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Sellsword.getMoodState()],
					text = _event.m.Sellsword.getName() + this.Const.MoodStateEvent[_event.m.Sellsword.getMoodState()]
				});

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Raider.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Raider.getName() + " suffers " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Raider.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Raider.getName() + " suffers light wounds"
					});
				}

				_event.m.Raider.worsenMood(0.5, "Got in a fight with " + _event.m.Sellsword.getName());
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
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local sellsword_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 6 && bro.getBackground().getID() == "background.sellsword")
			{
				sellsword_candidates.push(bro);
				break;
			}
		}

		if (sellsword_candidates.len() == 0)
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

		this.m.Sellsword = sellsword_candidates[this.Math.rand(0, sellsword_candidates.len() - 1)];
		this.m.Raider = raider_candidates[this.Math.rand(0, raider_candidates.len() - 1)];
		this.m.Score = (sellsword_candidates.len() + raider_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sellsword",
			this.m.Sellsword.getName()
		]);
		_vars.push([
			"raider",
			this.m.Raider.getName()
		]);
	}

	function onClear()
	{
		this.m.Sellsword = null;
		this.m.Raider = null;
	}

});


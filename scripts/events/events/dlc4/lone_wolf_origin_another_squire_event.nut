this.lone_wolf_origin_another_squire_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.lone_wolf_origin_another_squire";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%squire% comes up to you scratching the back of his head. He looks like he has something on his mind, and you prod him to let it out. Sighing, he asks why %squire2% was hired onto the company.%SPEECH_ON%He\'s a squire, I\'m a squire, are we both your squires?%SPEECH_OFF%You inform the lad that %squire2% was squire to another man, but things changed in his life to lead him here. For all intents and purposes, he is a sellsword now and %squire% is indeed still your squire. %squire% lights up with a smile, but it quickly goes awry.%SPEECH_ON%Wait, does that mean I\'m more sellsword than squire?%SPEECH_OFF%You press a ledger into the kid\'s chest and tell him to go count inventory.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And to think I used to roam these lands alone...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.worsenMood(0.5, "Confused about his role as your squire");
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.lone_wolf")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() < 3)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local squire;
		local other_squire;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.squire")
			{
				if (bro.getFlags().get("IsLoneWolfSquire"))
				{
					squire = bro;
				}
				else
				{
					other_squire = bro;
				}
			}
		}

		if (squire == null || other_squire == null)
		{
			return;
		}

		this.m.Dude = squire;
		this.m.Other = other_squire;
		this.m.Score = 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"squire",
			this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"squire2",
			this.m.Other.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Other = null;
	}

});


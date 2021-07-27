this.beggar_begs_event <- this.inherit("scripts/events/event", {
	m = {
		Beggar = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.beggar_begs";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{As you take stock of the inventory, you can\'t help but notice %beggar% lingering in your peripheral. Sighing, you finally turn to the former beggar and ask what he wants. Like the poorest of the poor he holds a hand out, asking if maybe you could spare a few crowns. | With practiced theatrics, %beggar% approaches you and lets loose a long tale of troubles and squabbles and empty bottles. The former beggar is down on his luck, apparently, and just needs a few extra crowns to get by. | %otherguy% tells you that %beggar% is going around the camp asking for crowns. Apparently the former beggar just needs a little more, expressing a longwinded sob story to anyone who\'ll listen. Hearing this news, you go to see the man yourself but before you can even get a word out the man lets loose his long narrative. Finished, he looks you in the eye, trying to gauge whether or not you\'ll give him something. | Apparently %beggar% the former beggar needs some help. He\'s come to you, begging for a few crowns to help him get by. The man looks like he\'s in a poor state, but he\'s had plenty of practice of actually being poor so it\'s hard to tell if he\'s being honest or not.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get back to work!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Here you go, have a few crowns.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beggar.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You tell the beggar you\'ll cross his hands with a sword if he doesn\'t get back to work. The man shrugs and pretty much does as told. That was easier than expected. | The beggar\'s shoulders sag as you tell him to get back to work. You feel a little bad, but then remember that\'s how they get ya.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ok.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beggar.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{The beggar takes the crowns and with a smile gets right back to work. | Tired of his games, you give the beggar a few crowns and tell him to get back to work. He bows and thanks you and, surprisingly, actually gets back to work.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ok.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beggar.getImagePath());
				this.World.Assets.addMoney(-10);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]10[/color] Crowns"
				});
				_event.m.Beggar.improveMood(0.5, "Got a few extra crowns from you");

				if (_event.m.Beggar.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Beggar.getMoodState()],
						text = _event.m.Beggar.getName() + this.Const.MoodStateEvent[_event.m.Beggar.getMoodState()]
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

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beggar")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Beggar = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;

		do
		{
			local bro = brothers[this.Math.rand(0, brothers.len() - 1)];

			if (bro.getID() != this.m.Beggar.getID())
			{
				this.m.OtherGuy = bro;
			}
		}
		while (this.m.OtherGuy == null);
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beggar",
			this.m.Beggar.getNameOnly()
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
		this.m.Beggar = null;
		this.m.OtherGuy = null;
	}

});


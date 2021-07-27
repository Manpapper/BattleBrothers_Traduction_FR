this.bowyer_crafts_masterwork_event <- this.inherit("scripts/events/event", {
	m = {
		Bowyer = null,
		OtherGuy1 = null,
		OtherGuy2 = null
	},
	function create()
	{
		this.m.ID = "event.bowyer_crafts_masterwork";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%bowyer% the bowyer comes to you with a bit of request: he wishes to build a weapon for the ages. Apparently, the man has been attempting to build a bow of legendary qualities for many years, but now that he has been on the road he\'s picked up a few things to fill in his gaps of knowledge. Truly, he believes he can get it right this time. All he needs is a few resources to help procure the elements needed to construct it. A sum of 500 crowns is what he humbly requests, and the quality wood you carry.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Build me a bow of legends!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "B" : "C";
					}

				},
				{
					Text = "We don\'t have time for this.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{The bow isn\'t quite legendary, but it is quite good. It\'s light in the grip, easily spun from side to side with the air whistling as it whirls. You test the draw. A strong man will be required to wield it that is for sure. When you loose an arrow, the shaft travels unbelievably straight and the shot almost seems to aim itself. A brilliant weapon if you ever saw one! | The bow was constructed with a mix of woods whose names you do not know. Colors of this tree and that spiral through the curve of the weapon, looking arboreally damascened. Testing the draw, the string proves itself mighty. You\'re no marksman, but when you loose an arrow it almost seems to guide itself to its target. A terrific weapon, if for no other reason it made you look better than you really are. You congratulate the bowyer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A masterwork!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Crowns"
				});
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.quality_wood")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						break;
					}
				}

				local item = this.new("scripts/items/weapons/masterwork_bow");
				item.m.Name = _event.m.Bowyer.getNameOnly() + "\'s " + item.m.Name;
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				_event.m.Bowyer.improveMood(2.0, "Created a masterwork");

				if (_event.m.Bowyer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Bowyer.getMoodState()],
						text = _event.m.Bowyer.getName() + this.Const.MoodStateEvent[_event.m.Bowyer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Is this thing a wild experiment? The wood cricks and cracks when bent, the string frizzes and goes wiry every time you draw it back, and you swear you saw a termite poking its head out of the shaft. Every tested arrow goes haywire, skirting this way or that, anywhere but its supposed target.\n\nYou ease the bowyer\'s pain by blaming yourself for how inaccurate the weapon is, but %otherguy1% and %otherguy2% both give it a try and come to even worse results. The bowyer eventually shuffles off, cradling his construction in his arms before tossing it onto the stockpile of weapons where you\'d wish it\'d look just like any other bow, but its obscene ugliness makes it stick out like a hot coal on a haystack. Surely no man will be accidentally wielding that thing!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I see now why you\'re no longer working as a bowyer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Crowns"
				});
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.quality_wood")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						break;
					}
				}

				local item = this.new("scripts/items/weapons/wonky_bow");
				item.m.Name = _event.m.Bowyer.getNameOnly() + "\'s " + item.m.Name;
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				_event.m.Bowyer.worsenMood(1.0, "Failed in creating a masterwork");

				if (_event.m.Bowyer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Bowyer.getMoodState()],
						text = _event.m.Bowyer.getName() + this.Const.MoodStateEvent[_event.m.Bowyer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]You tell the bowyer that the %companyname% has no resources to spare. The man grinds his teeth, and apparently whatever words he had to say, for he says nothing and turns on his heels and stomps off. In the distance you finally hear what kindness he had in store for you - a litany of swearing and cursing and eventually moaning disappointment.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pull yourself together.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bowyer.getImagePath());
				_event.m.Bowyer.worsenMood(2.0, "Was denied a request");

				if (_event.m.Bowyer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Bowyer.getMoodState()],
						text = _event.m.Bowyer.getName() + this.Const.MoodStateEvent[_event.m.Bowyer.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 2000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.bowyer")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local numWood = 0;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.quality_wood")
			{
				numWood = ++numWood;
				break;
			}
		}

		if (numWood == 0)
		{
			return;
		}

		this.m.Bowyer = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 4;
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Bowyer.getID())
			{
				this.m.OtherGuy1 = bro;
				break;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Bowyer.getID() && bro.getID() != this.m.OtherGuy1.getID())
			{
				this.m.OtherGuy2 = bro;
				break;
			}
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bowyer",
			this.m.Bowyer.getNameOnly()
		]);
		_vars.push([
			"otherguy1",
			this.m.OtherGuy1.getName()
		]);
		_vars.push([
			"otherguy2",
			this.m.OtherGuy2.getName()
		]);
	}

	function onClear()
	{
		this.m.Bowyer = null;
		this.m.OtherGuy1 = null;
		this.m.OtherGuy2 = null;
	}

});


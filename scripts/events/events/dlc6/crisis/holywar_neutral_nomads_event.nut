this.holywar_neutral_nomads_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.holywar_neutral_nomads";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_170.png[/img]{You come across a band of nomads. Despite the severity of a war going on, they do not treat you as a threat. One welcomes you with a drink and the shade of an umbrella which you accept.%SPEECH_ON%I hope your travels have been kind, Crownling. You share a similarity with us dune runners, that of the interloper. The grievances between the north and south need not concern us.%SPEECH_OFF%He sips his own drink and nods.%SPEECH_ON%Though I suspect you have made a great deal of coin in the conflict. Some of my countrymen would consider you most faithful to the Gilder because of it.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "You don\'t follow the beliefs of your countrymen?",
					function getResult( _event )
					{
						return "B";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "What is %wildmanfull% doing over there?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "And I\'m about to make even more after you\'re dead.",
					function getResult( _event )
					{
						return "C";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_170.png[/img]{The nomad laughs.%SPEECH_ON%In matters of faith, why would anyone think alike?%SPEECH_OFF%He gathers up his rugs and umbrellas.%SPEECH_ON%I have heard in the north that there are wildmen like us.%SPEECH_OFF%You purse your lips, holding back a laugh.%SPEECH_ON%We\'ve men of the forest who have absconded civilization, aye. But they\'re a more... peculiar sort compared to you and yours. They are not so much like you.%SPEECH_OFF%Nodding, the nomad gives you a gift.%SPEECH_ON%But maybe they are and you just have not been listening to them.%SPEECH_OFF%He touches his chest with a fist then the nomads continue on their journey.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Thank you for your hospitality.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/supplies/dates_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.worsenMood(0.5, "Enjoyed the hospitality of nomads");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_170.png[/img]{You finish your drink and tell the man your time with him was all very interesting. He goes to shake your hand at which point you put the sword through him. The rest of the company joins in and the battle is as short-lived as your sense of hospitality. The nomads have little worthwhile in their holding, but no one will know of what you\'ve done here, though it\'s unlike they would care anyway.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take anything we can use.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local money = 150;
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
					}
				];
				local item = this.new("scripts/items/supplies/dates_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/supplies/rice_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(0.75, "Disliked that you killed and robbed your hosts");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_170.png[/img]{%wildman% the wildman steps beneath the umbrella. The nomad stares at him, and the wildman at the nomad. You ask if they know each other. The nomad smiles.%SPEECH_ON%No, but yes. We\'ve kindred spirits. I can see it in his eyes.%SPEECH_OFF%The wildman hoots and grunts, then turns and leaves. When you return your gaze to the nomad he is holding out a gilded dagger.%SPEECH_ON%Treasures, golds, those things which shine and catch a man\'s eye, they carry little value to me. I found this upon one of the Vizier\'s guards. We had slain him and his caravan for their food and water, the things which I believe most important. You may have the dagger, as nothing more than a gift.%SPEECH_OFF%You take it, but warn him that if he ambushes you the way he did the Vizier\'s men that you will perhaps use the very same dagger against him. The nomad nods.%SPEECH_ON%And yet it is still my gift. I would find the occasion to be of such irony that it could only be a pleasure to die in such a manner. There are worse ways to go here in the desert, friend.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Thank you for your generosity.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				local item = this.new("scripts/items/weapons/oriental/qatal_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.worsenMood(0.5, "Enjoyed the hospitality of nomads");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.manhunters" || this.World.Assets.getOrigin().getID() == "scenario.gladiators" || this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart")
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_wildman = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
		}

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"wildmanfull",
			this.m.Wildman != null ? this.m.Wildman.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
	}

});


this.come_across_burial_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.come_across_burial";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 130.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_28.png[/img]While on the road, you come across a crowd of people huddled around a mound of earth. Getting closer, you realize that it\'s a funeral. One of the attendees turns to look at you.%SPEECH_ON%Did you know him? Did you fight by his side?%SPEECH_OFF%You shake your head and start cutting into the crowd to see the man himself. You find a man looking about as old as the dead can look. He\'s got a terrifically sharp and glinting sword running along his chest with his grubby, wormfood fingers clutching the pommel. %randombrother% joins your side and whispers.%SPEECH_ON%That\'s, uh, a pretty nice lookin\' weapon there, just saying.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s make it ours.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 35 ? "B" : "C";
					}

				},
				{
					Text = "Leave them be.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_36.png[/img]You draw out your sword and the rest of the company does the same. The mercenaries push the crowd back, but there isn\'t as much resistance as you expected. One of the attendees steps forward.%SPEECH_ON%It\'s the sword you want, isn\'t it? Go on, take it. That there dead man spoke of someone like you. Said you\'d need it more than he ever would.%SPEECH_OFF%Sheathing your sword, you ask him if that\'s why they were all standing around. The man laughs.%SPEECH_ON%Naw, he also said he\'d never die, so we were curious to know if that part of his sayings would come true.%SPEECH_OFF%You slowly take the sword, now curious if there was some saying about butchering the man who laid his hands upon it. Thankfully, ostensibly, the mighty dead man said no such thing.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "He won\'t be needing that anymore.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/longsword");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_28.png[/img]You reach through the crowd and grab the dead man\'s sword. One of the attendees screams out. %randombrother% uncorks a punch and sends the peasant astral planing. The rest of the company draw out their weapons to make sure any further protests don\'t get far. An elderly woman cuts through the crowd as well as an elderly woman can, wobbling and shaking.%SPEECH_ON%Sir, that don\'t belong to you. Put it back.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It does now.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "The crone is right, we shan\'t disturb the burial any further.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_36.png[/img]You tell the old lady to crawl her crotchety ass into a hole and die there. The dead man\'s sword is put in with your inventory and the %companyname% get back on the road.\n\nUpset, the peasants cry out that word of what you\'d done would travel the winds like the shitting farts of a thousand cows. You simply laugh and appreciate their imaginativeness.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'s how the world works.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-3);
				local item = this.new("scripts/items/weapons/longsword");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_28.png[/img]You put the sword back into the dead man\'s hands. The old lady nods.%SPEECH_ON%So there are good men who will still listen to the wise.%SPEECH_OFF%Another peasant hails your honor and others follow suit. It appears that simply taking the weapon and then putting it back was enough to warrant a manner of celebratory prestige in the eyes of the laymen. Perhaps you should feign theft more often.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We didn\'t need it anyway.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(5);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.Forest || currentTile.Type == this.Const.World.TerrainType.LeaveForest || currentTile.Type == this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		this.m.Score = 2;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


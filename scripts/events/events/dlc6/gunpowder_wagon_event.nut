this.gunpowder_wagon_event <- this.inherit("scripts/events/event", {
	m = {
		Bought = 0
	},
	function create()
	{
		this.m.ID = "event.gunpowder_wagon";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_171.png[/img]{A series of camels come into view. They\'ve dozens of satchels and knapsacks bobbing at their sides, and large umbrellas hoisted above. The camels are guided by a singular jockey riding the lead mount: an old man seated side-saddle with one foot in a stirrup and the other balancing a plate. He\'s eating nuts and berries and enjoying a cool beverage. He is nonplussed at the sight of you.%SPEECH_ON%Crownlings, yes? I can tell by your swagger, the braggadocio alchemists, transmuting raw gold in the copper of his fellow man\'s blood. I do not look down upon you, Crownling, and you shan\'t look upon me as prey to the brigandage that I know pulses whimsically in your heart.%SPEECH_OFF%He holds up a stick with a black mark at the top, his thumbnail pressed into it.%SPEECH_ON%I carry saltpeter for the Viziers\' various war machines. You see, the great cast iron shots do not travel high and far without my ingredient, this here gentle dust which fills my camels\' every bag. Were you to think yourself a brave robber I will set alight my wares and make us all together shine so bright the Gilder Himself shall shade His very eyes.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'ve made your point. Do you sell anything?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We\'ll leave you to your travels.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_171.png[/img]{The merchant grins.%SPEECH_ON%I\'m glad you have asked for I do at times tire of dealing with the Viziers\' feathery liveries. The blackguards and blaggards.%SPEECH_OFF%He snaps his fingers and points at you with fatherly sincerity.%SPEECH_ON%Conversation quickly becomes confabulation. As my father used to say, business is balladry. And we all need a bit of poetry in the dullness of our lives.%SPEECH_OFF%He nods and speaks with a tone you know he uses upon his fellow merchants.%SPEECH_ON%I have an expectation with the Viziers, but being robbed or losing items is also an expectation of this expectation. Upon this, I do have things to offer, which if agreed upon, will be \'stolen\' from me at your expense. But you can only have one of these availabilities: a Handgonne for but 2,500 crowns, or a Fire Lance for a mere 500 crowns. You may have only one of the two on offer.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll take the handgonne for 2,500 crowns.",
					function getResult( _event )
					{
						_event.m.Bought = 1;
						return "C";
					}

				},
				{
					Text = "The firelance at 500 crowns for sure.",
					function getResult( _event )
					{
						_event.m.Bought = 2;
						return "C";
					}

				},
				{
					Text = "For that price, none are of interest.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_171.png[/img]{You and the merchant come to an agree upon the items. After you make an exchange of coin and goods, he gets back up on his camel and thumbs his nose at you.%SPEECH_ON%I\'m so sorry to have been stolen from, this has truly been an awful day. Woe, the Viziers will be just as sad as I am.%SPEECH_OFF%The merchant sits sidesaddle again and begins to feast on his berries and nuts. He doesn\'t take up his reins, yet the camels seem to move as though on command.%SPEECH_ON%May your path be ever Gilded, Crownling, and may my abrogated goods provide you the shine you seek.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And may you find shine as well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				switch(_event.m.Bought)
				{
				case 1:
					local item = this.new("scripts/items/weapons/oriental/handgonne");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
					item = this.new("scripts/items/ammo/powder_bag");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
					this.World.Assets.addMoney(-2500);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]2500[/color] Crowns"
					});
					break;

				case 2:
					local item = this.new("scripts/items/weapons/oriental/firelance");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
					this.World.Assets.addMoney(-500);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Crowns"
					});
					break;
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_171.png[/img]{The merchant puts his hands out as though you are robbing him.%SPEECH_ON%It is no matter that you do not wish to have my goods, truly.%SPEECH_OFF%He crosses his legs to sit sidesaddle once more and the camels immediately begin to move as though this was their command. The merchant talks as he eats his nuts and berries.%SPEECH_ON%May your path be ever Gilded, Crownling, and may the Viziers of these deserts put you to good use.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I hope they do as well.",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_171.png[/img]{You nod and wish the man good luck in his travels. He bows respectively.%SPEECH_ON%May your path be ever Gilded, Crownling.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "As yours.",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.FactionManager.isHolyWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills && currentTile.Type != this.Const.World.TerrainType.Oasis)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 2500)
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 1)
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Bought = 0;
	}

});


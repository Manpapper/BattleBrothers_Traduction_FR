this.collector_wants_trophy_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null,
		Reward = 0,
		Item = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.collector_wants_trophy";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_01.png[/img]{While browsing the town\'s markets, a man in silk approaches. He\'s wearing a grin with more glitter than chomp, and each of his fingers are adorned to glint. | As you take a look at the local market\'s wares, a strange man approaches. He has baubles of strange liquids hanging from his hip and there\'s a strange wood taking the place of most of his teeth. | It\'s not a true trip to the markets without some strange fella accosting you. This time it\'s a man with a large face, his mouth a bear trap of jagged teeth, and his cheeks set high as though they were meant to be shelves. Features aside, he swings his weight around like someone of import and wealth.}%SPEECH_ON%{Ah sellsword, I see you have some interesting trophies with ya. How about I take that %trophy% for, say, %reward% crowns? | That\'s an interesting trophy you got there, the %trophy%. I\'ll give you %reward% crowns for it, hand over fist, easy money! | Hmm, I see you are of the adventuring sort. You wouldn\'t come by that %trophy% without some guile in ya. Well I got some gold in me, and I\'ll give you %reward% of it for that trinket.}%SPEECH_OFF%You consider the man\'s offer.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Deal.",
					function getResult( _event )
					{
						if (_event.m.Peddler != null)
						{
							return "Peddler";
						}
						else
						{
							this.World.Assets.addMoney(_event.m.Reward);
							local stash = this.World.Assets.getStash().getItems();

							foreach( i, item in stash )
							{
								if (item != null && item.getID() == _event.m.Item.getID())
								{
									stash[i] = null;
									break;
								}
							}

							return 0;
						}
					}

				},
				{
					Text = "No deal.",
					function getResult( _event )
					{
						if (_event.m.Peddler != null)
						{
							return "Peddler";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Peddler",
			Text = "[img]gfx/ui/events/event_01.png[/img]{%peddler% steps forward and pushes you back as though you were a random customer and not the company captain. He yells at the buyer and throws a hand up and the buyer responds and it\'s like two dogs barking at one another and it\'s all so fast and with so many numbers being thrown around it may as well be another language. After a minute passes, the peddler returns.%SPEECH_ON%Alright. He\'s now offering %reward% crowns. I\'m off to look at some pots and pans, good luck.%SPEECH_OFF%He pats you on the shoulder and walks off.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Deal.",
					function getResult( _event )
					{
						this.World.Assets.addMoney(_event.m.Reward);
						local stash = this.World.Assets.getStash().getItems();

						foreach( i, item in stash )
						{
							if (item != null && item.getID() == _event.m.Item.getID())
							{
								stash[i] = null;
								break;
							}
						}

						return 0;
					}

				},
				{
					Text = "No deal.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				_event.m.Reward = this.Math.floor(_event.m.Reward * 1.33);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local candidates_items = [];

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Crafting) && item.getValue() >= 400)
			{
				candidates_items.push(item);
			}
		}

		if (candidates_items.len() == 0)
		{
			return;
		}

		this.m.Item = candidates_items[this.Math.rand(0, candidates_items.len() - 1)];
		this.m.Reward = this.m.Item.getValue();
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_peddler = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates_peddler.push(bro);
			}
		}

		if (candidates_peddler.len() != 0)
		{
			this.m.Peddler = candidates_peddler[this.Math.rand(0, candidates_peddler.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler != null ? this.m.Peddler.getName() : ""
		]);
		_vars.push([
			"reward",
			this.m.Reward
		]);
		_vars.push([
			"trophy",
			this.m.Item.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Peddler = null;
		this.m.Reward = 0;
		this.m.Item = null;
		this.m.Town = null;
	}

});


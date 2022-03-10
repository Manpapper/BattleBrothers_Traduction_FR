this.incense_trade_event <- this.inherit("scripts/events/event", {
	m = {
		Dancer = null
	},
	function create()
	{
		this.m.ID = "event.incense_trade";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_144.png[/img]{As you\'re clearing a path through the snowy wastes, a strange figure steps out onto the road. You can see strings of rope attached to their shoulders, and far above them fly black kites which twirl and whirl as though he\'d seen to himself a puppet of his own construction. His face looks the sort of man to make such a thing, a twist of madness, sneering with some joke that he thought of years ago and never stopped laughing about. His dark complexion is not usual to the north, and when he speaks he knows your tongue.%SPEECH_ON%You\'ve oddities on you, good smelling oddities at that. What is that, though, what is it? It is not meat. It is not tender human meat. It is not meat of the birds, nor of the pups that go under the ice. It, well, is it even meat at all? Oh my, that is incense! Look, lemme have a whiff of that sweet spice and I\'ll give you something in return for it. Just a little sniff, that\'s all, I\'ll even pay for it.%SPEECH_OFF%You put your hand on your sword.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Uh, alright.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 66 ? "B" : "C";
					}

				},
				{
					Text = "I don\'t think so.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Dancer != null)
				{
					this.Options.push({
						Text = "%bellydancer% the belly dancer, do you know this man?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_144.png[/img]{You tell him that he may take a smell of that which he desires, so long as he pays you for it in the end. He agrees, and shuffles over to your wagon, his long kites following above like eternal buzzards winking in and out of the snowy blinds. He leans into the wagon and sniffs around, his cold, red nose honking with every breath. He gets to the incense jars and a smile crosses his face.%SPEECH_ON%Ah yes. I have not smelled such magnificence in many, many years.%SPEECH_OFF%He rides up his jacket and slams a large purse of coins onto the tailgate. You count them out, seeing far more than you\'d ever get for selling this incense anywhere. He turns to you, the incense cradled in his arms.%SPEECH_ON%Fair deal?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A man knows what he loves.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local crowns = 0;
				local stash = this.World.Assets.getStash().getItems();
				local incense_lost = 3;

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.incense")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						crowns = crowns + item.getValue() * 2;
						stash[i] = null;
						incense_lost--;

						if (incense_lost <= 0)
						{
							break;
						}
					}
				}

				this.World.Assets.addMoney(crowns);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + crowns + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_144.png[/img]{You take your hand off your sword and agree with the wily albeit seemingly harmless request. You say he may have a whiff of your wagon if he pays upfront for it. The man nods, and gives out a few crowns. Before cycling around to the back of the cart. He puts his bulbous nose in, snorting around like a pig rooting up the ground.\n\nSuddenly, he snatches up a few jars of incense and tears off the covers. All the dust and powder goes flying, the snowy wastes briefly vibrant, and the chortling man dances through it. You go to knock him out, but he throws the cables of kites at you, knotting you up in their wiry grasps, all the while himself making a daring escape, cackling as the incense drifts off his shoulders like some wayward transient passing a celestial meridian. Furious, and cutting yourself loose of the damned kites, you take inventory of the damage wrought.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What in the hells.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local stash = this.World.Assets.getStash().getItems();
				local incense_lost = 3;

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.incense")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						stash[i] = null;
						incense_lost--;

						if (incense_lost <= 0)
						{
							break;
						}
					}
				}

				this.World.Assets.addMoney(15);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]15[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_144.png[/img]{%bellydancer% the belly dancer steps forward, peers into the snow, and rather unexpectedly wonders aloud if that is his father. The crazed man comes forward, his black kites following after him like buzzards in the tailwind of the doomed, then his face lights up and the two embrace. The man is apparently %bellydancer%\'s long lost father, an incense merchant who had headed far north only to be ambushed and enslaved by the savage barbarians there whom he has since escaped. He smiles madly.%SPEECH_ON%It had been so long since I had seen good incense I could smell your wagon from miles away. My wife, your mother, %bellydancer%, how is she?%SPEECH_OFF%The belly dancer\'s smile fades. He mentions that she held out hope for as long as she could. The kite-kitted man nods solemnly, but also expectedly. He says it wouldn\'t be right for her to be married to a specter of what once was, and that he himself, with no hope of making a return home, moved on as well. The man pulls out an ornate weapon with a blade unlike anything you\'ve seen before. He says that it is a long held relic of the family, and that he kept it buried and safe all his years in the north.%SPEECH_ON%Best you take it and make use of it before one of the savages here eats me and uses it as a toothpick.%SPEECH_OFF%The man smiles fondly and the two embrace for a time. Curious, you ask him why the kites. He responds that they are tools of fear meant to ward off dangerous animals and the like, including the more superstitious of the barbarians. You bid the man goodbye and suggest to %bellydancer% that he can leave if he needs to as well, but he shakes his head.%SPEECH_ON%The son and father mustn\'t share the gilded path, for we know that we shall be together at its end as we were at its beginning.%SPEECH_OFF%He says a few words to his father in his native tongue, and then the two depart and that is that.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn this incense is some good stuff.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dancer.getImagePath());
				local item = this.new("scripts/items/weapons/named/named_qatal_dagger");
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_144.png[/img]{You tell the man to step aside or else. He does as told, though he stands there with both hands reaching, fingers prying emptily at whatever scent his nose had picked up. You take a few looks back, making sure he isn\'t following. He stands in the snowy wastes staring at your wagon. Then he is but a sliver of black. Then he is gone, and his kites dance above where you know him to be, and then they are gone.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Can\'t escape these strange bastards.",
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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local candidates_items = [];

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.incense")
			{
				candidates_items.push(item);
			}
		}

		if (candidates_items.len() < 3)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_dancer = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.belly_dancer")
			{
				candidates_dancer.push(bro);
			}
		}

		if (candidates_dancer.len() != 0)
		{
			this.m.Dancer = candidates_dancer[this.Math.rand(0, candidates_dancer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bellydancer",
			this.m.Dancer != null ? this.m.Dancer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Dancer = null;
	}

});


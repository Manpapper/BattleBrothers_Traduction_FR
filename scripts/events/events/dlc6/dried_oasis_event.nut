this.dried_oasis_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Slayer = null
	},
	function create()
	{
		this.m.ID = "event.dried_oasis";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{The desert is so awash in similarity that seeing a bit of greenery immediately draws the eye. Such is the magnetism of an oasis. You spot it at great distance, and upon approach you realize the green is not a tree at all, but a banner flying from the catch of a dead, dried tree. Around it are more dead trees, some having crumpled into the sands which eat at them from every side. And in the midst of this passed oasis sets a skeleton with its face down in a small bowl of earth where, perhaps, water once was. To the skeleton\'s side is a pile of treasures. All the crowns in the world, but not a single drop of water with which to spend it on.\n\n You move to get the gold, but the coins move with you, sliding apart as a black snake rises up and hisses at you. Green poisons slickly drip from its fangs.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Someone go fetch it!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				});

				if (_event.m.Slayer != null)
				{
					this.Options.push({
						Text = "%beastslayer% can handle this puny monster.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "This is not worth our trouble.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{%brother% walks forward with his weapon in hand. The snake rears up and the man stabs it clean through, instantly killing the creature. He holds it up at the end of his steel, wriggling its flesh before tossing it aside.%SPEECH_ON%Easiest pay I\'ve ever had.%SPEECH_OFF%He says as the treasure is taken into the company\'s inventory.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				local money = this.Math.rand(100, 300);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{%brother% walks forward with his weapon in hand. The snake rears up and the man laughs and stabs down with his weapon. The snake deftly sidewinders around the steel and strikes up the shaft and nicks the man across his knuckles. Screaming, he falls backwards, and the men collect him and drag him off. Soon he is convulsing and frothing and his entire hand bulbs and spews pus.\n\nYou believe he\'ll survive, but it will be a great deal of time until he is ready to fight again. As for the treasure, it shifts in the sands and you can only watch as it slowly slips into the dune itself like a boat sinking into water. When you lean to see the last of it go, more black snakes emerge as if to warn you just who it belongs to: it\'s the desert\'s treasure now and forever.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nice try.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.addHeavyInjury();
				_event.m.Dude.worsenMood(1.5, "Was bitten by a desert snake");
				local injury = _event.m.Dude.addInjury([
					{
						ID = "injury.pierced_hand",
						Threshold = 0.25,
						Script = "injury/pierced_hand_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Dude.getName() + " suffers " + injury.getNameOnly()
				});
				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Dude.getSkills().add(effect);
				this.List.push({
					id = 11,
					icon = effect.getIcon(),
					text = _event.m.Dude.getName() + " is sick"
				});

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 12,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{%beastslayer% looks down at the snake. He nods as though recollecting an old lesson.%SPEECH_ON%You only see these in the dunes. Highly venomous.%SPEECH_OFF%The serpent hisses at him. The man nods back before shooting a hand out and snatching the snake by its head.%SPEECH_ON%Your venom begin and ends in your mouth, little one, but I can use it everywhere. I trust that you will be understanding of the trade.%SPEECH_OFF%The man cracks the snake\'s head before cutting it clean off with a small blade and he pinches his finger over the reptile\'s stringy corpse. He nods again.%SPEECH_ON%I\'ll make use of the snake, and I trust you captain to make use of the treasure.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Glad you were here.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Slayer.getImagePath());
				local money = this.Math.rand(100, 300);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
					}
				];
				local item = this.new("scripts/items/accessory/antidote_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Slayer.improveMood(1.0, "Applied his expertise on creatures");

				if (_event.m.Slayer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Slayer.getMoodState()],
						text = _event.m.Slayer.getName() + this.Const.MoodStateEvent[_event.m.Slayer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "%terrainImage%{You\'ve heard of such snakes killing men outright. With that threat on the table, you do not feel it worth the trouble and leave the treasure behind.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We move on!",
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
			if (t.getTile().getDistanceTo(currentTile) <= 8)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local candidates_slayer = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_slayer.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];

		if (candidates_slayer.len() != 0)
		{
			this.m.Slayer = candidates_slayer[this.Math.rand(0, candidates_slayer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beastslayer",
			this.m.Slayer != null ? this.m.Slayer.getName() : ""
		]);
		_vars.push([
			"brother",
			this.m.Dude.getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Slayer = null;
	}

});


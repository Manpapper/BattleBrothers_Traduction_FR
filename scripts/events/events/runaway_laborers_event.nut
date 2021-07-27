this.runaway_laborers_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.runaway_laborers";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]As you walk along the roads, a throng of ragged-looking men speed past you. They clear off the path and jump down into an embankment and hide behind a wall of bushes.\n\nWith the shrubbery still swaying, another group of men soon appears. Before the first man even speaks you already know what\'s coming. Apparently some laborers had agreed in union to abandon a project over what the pursuing overseers simplify as \'issues\'. They ask if you have seen these ne\'er do wells.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "They\'re right over there!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We haven\'t seen anyone around these parts.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);

						if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return this.Math.rand(1, 100) <= 70 ? "C" : "D";
						}
						else
						{
							return this.Math.rand(1, 100) <= 70 ? "E" : "D";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_59.png[/img]The overseers nod and draw clubs and pitchforks and even some nets. They scramble off the road and converge onto the bushes like a bunch of raiders would a wagon. It is a wild, though one-sided, fight. Men are beaten and battered like fish in a bush. Even far up the hillside you can hear the unmistakable clonking of wood on skull. You see one man fatally stabbed with a spear, perhaps the resolution of a conflict of a somewhat more personal matter. When the battle ends, the head overseer returns to you, a line of prisoners behind him looking rather worse for the wear. He hands you a purse of coins, clapping you on the shoulder and thanking you for keeping \'order\'.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Easy crowns.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				this.World.Assets.addMoney(50);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]50[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_59.png[/img]With your finger still pointing the wrong way, the overseers take off. Their angry barking fades into the distance. When they are gone, the laborers slowly emerge. They appear rather surprised that a sellsword didn\'t sell word of them in the bushes. One by one they take off their hats and bless you for your mercy. One even calls it \'justice\', a strange word in a mercenary\'s ear.\n\nWhile most of them make off, one man stands idly behind. He asks if maybe he can join your company if, you know, you got room for him.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "This is no place for you.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx(this.Const.CharacterLaborerBackgrounds);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_59.png[/img]All of the overseers take off in the wrong direction - except one. He stands still the by roadside, looking down the embankment. For a brief moment you consider taking a cool blade across his neck, drawing the words out of his throat instead of his mouth. The man quickly turns to his comrades and yells and points down the hillside. Sensing their being seen, the laborers dash out of the bushes going this way and that. They must be malnourished for most move with the speed of a skeleton climbing a flight of stairs.\n\nThe ensuing battle is rather gruesome and uncalled for, the overseers being quite punitive in their capturing measures. When it\'s all said and done they begin to depart just as quickly as they came, the laborers now tied up in rope and their heads covered with sacks. Before he leaves, the head overseer shares a word of contempt for you. With your blade slowly coming out of its sheathe, you ask the man if he has anything else he wishes to add. He spits and shakes his head no.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Then move out of my sight!",
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
			Text = "[img]gfx/ui/events/event_59.png[/img]With your finger still pointing the wrong way, the overseers take off. Their angry barking fades into the distance. When they are gone, the laborers slowly emerge. They appear rather surprised that a sellsword didn\'t sell word of them in the bushes. One by one they take off their hats and bless you for your mercy. One even calls it \'justice\', a strange word in a mercenary\'s ear.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Farewell.",
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
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});


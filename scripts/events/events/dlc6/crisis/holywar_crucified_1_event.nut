this.holywar_crucified_1_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_crucified_1";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_161.png[/img]{In the middle of the desert wastes one has to be somewhat suspicious of anything they come across, especially if it\'s a lone man on a cross. The crucified figure looks entirely dead, given the buzzards clerically perched on each shoulder, but as you draw near the birds take flight and the man lifts is head. Despite gruesome injuries to hands and feet, he\'s rather lively and asks for water. Instead of giving it to him, you ask why he\'s here. The man sighs.%SPEECH_ON%I was a crusader. Came in with the army looking to gain glory for the old gods. Except when I got down here, and got to talking with the locals and the priests, I had a change of heart.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The other crusaders did this to you?",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "{[img]gfx/ui/events/event_161.png[/img]{The man nods.%SPEECH_ON%Aye, that they did. Mind, I was there when they crucified someone else on account of the same reason. So in part I\'m not the brightest fella to follow in his footsteps, nor am I clean of heart, for I cheered it on when they did it to him. But perhaps the Gilder will see the true light I carry within, you know?%SPEECH_OFF%He turns his head to the skies, and to the buzzards cycling above.%SPEECH_ON%I\'m still one open to fight, no matter who it is, south, north, doesn\'t matter. I\'ve the Gilder in my heart.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'re welcome with us.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Only thing you\'ve in your heart are these buzzards.",
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
			Text = "{[img]gfx/ui/events/event_161.png[/img]{You draw out your dagger and cut the man down. He\'s got injuries aplenty but is no doubt of strong enough constitution to one day recover. He thanks you with remarkable mildness given the doom which awaited him.%SPEECH_ON%Glad to stretch. I mean, you know, stretch on my terms. Lead the way, captain of the Gilder\'s circumstance, captain of His mighty sublimity.%SPEECH_OFF%Many in the company do not care for taking in a man who has turned his back not only on his fellow man, but his own gods.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ah, he\'ll fit in with the rest of the misfits.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"crucified_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "You found %name%, a former crusader from the north, crucified in the middle of the desert after turning his back to the old gods. After cutting him down, he pledged his services to you. Despite his attempts to conceal it, he doesn\'t seem to be in the most stable mental condition.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/deathwish_trait");

				foreach( id in trait.m.Excluded )
				{
					_event.m.Dude.getSkills().removeByID(id);
				}

				_event.m.Dude.getSkills().add(trait);
				_event.m.Dude.setHitpointsPct(0.33);
				_event.m.Dude.improveMood(3.0, "Saw the light and accepted the sublimity of the Gilder");
				_event.m.Dude.worsenMood(3.0, "Was crucified");
				this.Characters.push(_event.m.Dude.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(1.0, "Disliked that you prevented rightful punishment for betraying the old gods");

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
			Text = "{[img]gfx/ui/events/event_161.png[/img]{You tell the man he\'ll be talking to his god or gods real soon. He sighs.%SPEECH_ON%In a manner, I deserve this, but I am at peace with it.%SPEECH_OFF%There\'s mixed reactions about the company on it, and by mixed it is mostly varying levels of exuberance. After all, the man is a traitor to both terra and celestial, making him easily hated by anyone and everyone.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Serves him well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.25, "Gained confidence in your leadership");

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

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.Type != this.Const.World.TerrainType.Oasis && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		this.m.Score = 10;
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


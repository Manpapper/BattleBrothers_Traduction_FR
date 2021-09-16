this.sled_race_event <- this.inherit("scripts/events/event", {
	m = {
		Sledder = null,
		Fat = null,
		Blind = null
	},
	function create()
	{
		this.m.ID = "event.sled_race";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]{As the snow and stiff winds beat down upon your face, it seems almost miraculous that there\'s someone on this mountain waving you down. But there he is, a bearded fella with two sleds in hand. He yells out if you\'re interested in a race.%SPEECH_ON%First one to split them two rocks shaped like cocks is the winner!%SPEECH_OFF%You ask what it is that\'s on the line. When he looks at you like a dog spoken to in the wrong language, you ask what you\'re betting. He laughs.%SPEECH_ON%Ain\'t no bet! Just a matter of fun!%SPEECH_OFF%Fair enough. Maybe one of the %companyname% would like to try?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Someone step forward and do it!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Fat != null)
				{
					this.Options.push({
						Text = "Looks like %fat% is volunteering.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Blind != null)
				{
					this.Options.push({
						Text = "Looks like %shortsighted% is volunteering.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Options.push({
					Text = "We have more important things to take care of.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_143.png[/img]{%sledder% takes the sled from the mountain man.%SPEECH_ON%I\'ll beat ya to them rock dicks in proper time.%SPEECH_OFF%Everyone raises an eyebrow as he sets the sled down. He jacks his boots against its front and tips it toward the edge of the hillside.%SPEECH_ON%Ready when you are.%SPEECH_OFF%The mountain man gives a signal to start the race and the two zip down the snow in an instant. You\'re not sure if your sellsword played cheap, but the mountain man suddenly turns sideways and flips his sled and he goes rolling through the powder in a flail of beard and limbs. %sledder% meanwhile coasts to an easy victory. The company roars to the victory and carry him up the mountain on their shoulders. If the mercenary did cheat it doesn\'t show on the mountain man\'s face, he is just happy to have had raced at all.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nice one!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sledder.getImagePath());
				_event.m.Sledder.getBaseProperties().Initiative += 1;
				_event.m.Sledder.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Sledder.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Initiative"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

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
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_143.png[/img]{%sledder% takes the sled from the mountain man.%SPEECH_ON%I\'ll beat ya to them rock dicks in proper time.%SPEECH_OFF%Everyone raises an eyebrow as he sets the sled down. He jacks his boots against its front and tips it toward the edge of the hillside.%SPEECH_ON%Ready when you are.%SPEECH_OFF%The mountain man gives a signal to start the race and the two zip down the snow in an instant. Rooster tails of powder shower in their wake and it seems like %sledder% is going to win until he angles incorrectly and smashes right into one of the rock cocks. The sled shatters to pieces and the sellsword goes flying over the stone and lands limply into the snow. Laughing, the company rushes to his aide and brings him back to his feet. He\'s got some raspberries and something is clicking, but he\'ll live. The mountain man cheers.%SPEECH_ON%Ye almost had me, but yer s\'posed to split the dicks, not ride up them!%SPEECH_OFF%This brings your men to their knees in crying laughter.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ouch.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sledder.getImagePath());
				local injury = _event.m.Sledder.addInjury(this.Const.Injury.Mountains);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Sledder.getName() + " suffers " + injury.getNameOnly()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Sledder.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

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
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_08.png[/img]{%fat%, the fattest man in the company, elects to give it a try. You like his chances - given his weight it\'s likely he\'ll blow right down the mountainside. The mountain man readily accepts the challenge, sets the ground rules, and starts the race proper. The two rip through the snow with ease and, just as you thought, the fat man roars through the powder like lightning through a cloud. But he doesn\'t seem to slow. He plows right between the two cock rocks, signaling his win, but he\'s unable to seize the reins or slow down. He barrels over an escarpment and that\'s about the last of you see of him. The mountain man grimaces and runs toward the hillside.%SPEECH_ON%He\'s alive! Little busted up, but alive!%SPEECH_OFF%Though you\'re mightily concerned, you look back to see that the company whole is doubled over or on their knees choking with laughter.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Holy smokes!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fat.getImagePath());
				local injury = _event.m.Fat.addInjury(this.Const.Injury.Mountains);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Fat.getName() + " suffers " + injury.getNameOnly()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Fat.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

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
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_143.png[/img]{%shortsighted% volunteers to race the mountain man. You are reluctant to allows that, given the sellsword\'s poor eyesight, but he is pretty diligent about the matter. As he squats on the sled and takes up the reins you can\'t help but notice that he is already squinting downhill as though he wouldn\'t tell a mountainside from a red barn.%SPEECH_ON%Ready!%SPEECH_OFF%The mountain man sets the rules and starts the race. Almost immediately the shortsighted sellsword veers off course. Thankfully he\'s not even full speed when he slams head first into a rock formation. The sled shatters like a tomato against a pillory and the man himself pancakes against the stone. You rush to his aide and get him to his feet, but there you find your foot stepping on something metallic. A treasure chest! You tell the company to get the man some proper help while you dig out what you can.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Blind leading the seeing.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Blind.getImagePath());
				local injury = _event.m.Blind.addInjury(this.Const.Injury.Mountains);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Blind.getName() + " suffers " + injury.getNameOnly()
				});
				local item = this.new("scripts/items/loot/ancient_gold_coins_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_fat = [];
		local candidates_blind = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.fat"))
			{
				candidates_fat.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.short_sighted"))
			{
				candidates_blind.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Sledder = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_fat.len() != 0)
		{
			this.m.Fat = candidates_fat[this.Math.rand(0, candidates_fat.len() - 1)];
		}

		if (candidates_blind.len() != 0)
		{
			this.m.Blind = candidates_blind[this.Math.rand(0, candidates_blind.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sledder",
			this.m.Sledder.getNameOnly()
		]);
		_vars.push([
			"fat",
			this.m.Fat ? this.m.Fat.getNameOnly() : ""
		]);
		_vars.push([
			"shortsighted",
			this.m.Blind ? this.m.Blind.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Sledder = null;
		this.m.Fat = null;
		this.m.Blind = null;
	}

});


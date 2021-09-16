this.desert_well_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.desert_well";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{You come to a watering hole. The well\'s walled exterior is embroidered with animal skulls and similarly stitched with their ribs. As you draw near, there\'s a faint hiss from the depths. Staring in, you see a tiny orange glow snaking left to right.%SPEECH_ON%You might want to try not looking down there.%SPEECH_OFF%You turn around to see a man dressed in rags. His hair is spiked backwards in black chevrons. Dark splotches pepper his face and he\'s got bruises on every fingernail and a tarred smile.%SPEECH_ON%It\'s about to blow.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What\'s about to blow?",
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
			Text = "%terrainImage%{The man nods.%SPEECH_ON%That ain\'t no watering hole, that\'s a cannon. I got a pile of fire powder in the bottom. The chute is armed with buckets, and fishing rods, all manner of cutlery, some soldier\'s metal boots, a broken sword, couple of scabbards, I think a few animals fell in but they no doubt dead now, if not they\'re going for a ride.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oh no, don\'t do that!",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "The gods talk to you, %monk%, now you talk to him!",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{The man grins.%SPEECH_ON%You don\'t know a damn thing about me, stranger. Maybe I aim to kill myself cause I done a terrible crime. I mean, I haven\'t, but what\'re you doing going off about \'don\'t do it\'? You\'ve seen my preparation, were I of the mind to pause wouldn\'t I have done it at any prior moment? Now you set back there and watch this.%SPEECH_OFF%He turns and leaps into the hole. There\'s a clatter of his crashing, some murmuring about how there\'s more debris than he remembers. When you look down he yells at you to clear out and the orange glow zips into a hole. The man bows.%SPEECH_ON%I bid you good stranger, a strange farewe-%SPEECH_OFF% The explosion blows out your ears and puts you on the ground. The earth rolls beneath you in tremble that can be felt through the deafness which you are now submerged. A pluming cloud of fire spears into the sky and growls with the clinking and clanking of metals and the dull plops of leather and other goods, and you roll to your belly and cover your head as it all comes down like the scraps of some god\'s hellstorm.\n\n Absolutely none of the debris is of any use. As for the man himself, well, he got his wish. He no doubt died in the blink of an eye, all that remains are charred chunks here and there and broiled lungs and seared strips of sinews and more. You check to make sure your eyebrows are still there and, satisfied, prepare to move on.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sometimes you wish these things were just mirages.",
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
			ID = "D",
			Text = "%terrainImage%{%monk% the monk steps forward.%SPEECH_ON%That\'s a lotta work to end yourself, friend.%SPEECH_OFF%The man shrugs.%SPEECH_ON%I\'m not really your friend.%SPEECH_OFF%The monk nods.%SPEECH_ON%Turn of phrase, nothing more. In truth I know nothing about you. In truth you likely have a good reason to be doing this. How much time have you spent putting this together?%SPEECH_OFF%The strange man thinks for a time, then says he thinks it\'s been months. %monk% smiles.%SPEECH_ON%Now that\'s good, hard work.%SPEECH_OFF%The man says.%SPEECH_ON%You trying to coddle me?%SPEECH_OFF%The monk shakes his head.%SPEECH_ON%No Sir.%SPEECH_OFF%The man slims his eyes and stares incredulously.%SPEECH_ON%Sounds to me like motherly talk. Like you\'re trying to sweet talk me into not killing myself. Well I won\'t have it!%SPEECH_OFF%%monk% shrugs.%SPEECH_ON%Again, no sir. You go on and end yourself if that\'s what you wish. Today or later, the old gods will be waiting.%SPEECH_OFF%The man turns and spits.%SPEECH_ON%No old gods down here. Only the Gilder\'s gleam and glow.%SPEECH_OFF%%monk% nods then turns to look at you.%SPEECH_ON%To be frank, captain, I really only got one thing left to say. Can I say it? I just wanna tell it to the stranger, tell it to him straight.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Go on ahead.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Let him end himself if that\'s what he wants.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "%terrainImage%{The monk nods with your approval then suddenly swings around and cold cocks the stranger. He falls off the well wall and collapses into the dirt, staring up with his eyes wonked.%SPEECH_ON%What\'d you go and do that for?%SPEECH_OFF%He asks, touching his lip. %monk% crouches down.%SPEECH_ON%How\'s that feel?%SPEECH_OFF%The stranger sneers and spits blood. He says it hurts. The monk nods.%SPEECH_ON%Feel alive?%SPEECH_OFF%The stranger gets to his feet and dusts himself off. He nods.%SPEECH_ON%A little, yeah.%SPEECH_OFF%The two talk for a time and when it is over the man is willing to join the company free of charge. He also says that there are a number of goods in the well if they want to be used, though to be mindful to not drop any fire in there cause it\'ll blow sky high.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome aboard, I suppose.",
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
				this.Characters.push(_event.m.Monk.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"peddler_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "A string of bad fortune led the former arms-peddler %name% to attempt to end his life by blowing himself up, but " + _event.m.Monk.getName() + " intervened and convinced him to join your company instead to make a new life for himself.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/deathwish_trait");

				foreach( id in trait.m.Excluded )
				{
					_event.m.Dude.getSkills().removeByID(id);
				}

				_event.m.Dude.getSkills().add(trait);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.5, "Had a string of bad fortune and lost everything");
				this.Characters.push(_event.m.Dude.getImagePath());
				local item = this.new("scripts/items/loot/silverware_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "%terrainImage%{You tell the monk to stand down. He shrugs and returns to your side. When you look back at the man you realize he\'s lit a fire and watch just as he leaps into the well.\n\n The explosion blows out your ears and puts you on the ground. The earth rolls beneath you in tremble that can be felt through the deafness which you are now submerged. A pluming cloud of fire spears into the sky and growls with the clinking and clanking of metals and the dull plops of leather and other goods, and you roll to your belly and cover your head as it all comes down like the scraps of some god\'s hellstorm.\n\n Absolutely none of the debris is of any use. As for the man himself, well, he got his wish. He no doubt died in the blink of an eye, all that remains are charred chunks here and there and broiled lungs and seared strips of sinews and more. You check to make sure your eyebrows are still there and, satisfied, prepare to move on.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sometimes you wish these things were just mirages.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
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

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
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
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				candidates_monk.push(bro);
			}
		}

		if (candidates_monk.len() != 0)
		{
			this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Monk = null;
	}

});


this.abandoned_village_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.abandoned_village_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_178.png[/img]{A recently destroyed village... with no bodies. Only a breeze swirls through, kicking up ash and hissing it through the ruins. But there survives one element: an enormous stone statue masterfully sculpted in the image of a man. Or at least you think it is a man. Its face has been removed with the sort of accuracy that suggests careful intention and not mere vandalism.\n\nSuddenly, mud-squelching footsteps approach from all corners. Bulbous silhouettes limp into the light: slouching hunchbacks of formed of most dishonest stitching, torsos haphazardly sewn together with organs vaguely gated behind strands of flesh, additional arms attached with hands wiggling wildly from all sides, and atop the puttied horrors groan multiple heads like some fleshen totem that knows itself, the maws slackened open and gargling at the realized horrors, eyes aplenty and eyes agog, staring at you and the ground and at each other. Your men gasp and arm themselves. The monsters growl and start picking tools and weapons off the ground. One monster reaches down and picks up two cleavers. It trundles forward and faces smeared across its skin turn their misshapen gazes upon you and their mouths open and yell, their shrieks sucking in and out from one mouth to the next, air howling through their internal chambers as the faces take turns breathing so that another may scream.\n\nYou\'ve still a chance to run - it is unlikely that these things can keep pace with any man, but what would you be leaving behind, aside from your dignity and pride?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To battle!",
					function getResult( _event )
					{
						local location = this.World.State.getLastLocation();

						if (location != null)
						{
							location.setVisited(false);
							location.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
							_event.registerToShowAfterCombat("Victory", "Defeat");
							this.World.State.startScriptedCombat(_event.buildEventCombatProperties(_event, location), false, false, false);
						}

						return 0;
					}

				},
				{
					Text = "Let\'s get out of here!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Statistics.getFlags().get("AbandonedVillageFightDefeated"))
				{
					this.Text = "[img]gfx/ui/events/event_178.png[/img]{As expected, the Flesh Golems are still meandering around the town\'s faceless statue. Judging by the range of freshness and decay, it seems they have had some new members added to the roster, while the older ones are falling apart. But they are all one-minded when their gooey eyes clap down on you and the company. You draw your sword and order in the formations. If this town has a secret, you are going to find it!}";
					this.Options = [
						{
							Text = "To battle!",
							function getResult( _event )
							{
								local location = this.World.State.getLastLocation();

								if (location != null)
								{
									location.setVisited(false);
									location.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
									_event.registerToShowAfterCombat("Victory", "Defeat");
									this.World.State.startScriptedCombat(_event.buildEventCombatProperties(_event, location), false, false, false);
								}
							}

						}
					];
				}
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_178.png[/img]{You stand over one of the...things you just fought. %randombrother% curls a blade underneath the goop and holds it up. A great mop of flesh elongates in stitched segments, arms spindling out like it they were the branches of a tree, fat chunks sliiding down the appendages like sap. The rest are incongruencies left and right: here a foot hanging from a torso like a doorhandle, there a face spreading apart as if melting into a river of sinews and ligaments. When your sellsword lets it slide off his blade, the fleshbag slops into the ground, the bones rattling like a collapsing rope ladder. %randombrother2% walks up with a quiver of arrows and a small book.%SPEECH_ON%Got this quiver of, uh, interesting arrows. Looks like some sort of reservoir in the bottom of it is for dipping the arrowheads. The old gods know what that material is. I also found this here book tethered to one of their heads. Seems important.%SPEECH_OFF%Opening the book, you find lists of villages with lines crossing them out one by one, and beside each is a simple number. Fifty. Sixty. Seventy. At the back of the book you find a map to another location, what appears to be some sort of estate.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hurry it up, too.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "After the battle...";
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/ammo/legendary/quiver_of_coated_arrows");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				local locations = this.World.EntityManager.getLocations();

				foreach( location in locations )
				{
					if (location.getTypeID() == "location.artifact_reliquary")
					{
						location.setVisibilityMult(1.0);
						this.World.uncoverFogOfWar(location.getTile().Pos, 700.0);
						location.setDiscovered(true);
						this.World.getCamera().moveTo(location);
						location.onUpdate();
						break;
					}
				}

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_178.png[/img]{The fight is being lost. You know these monstrosities must, in part, be made of those who have fallen before them already. Not wishing to suffer such a fate, you order a retreat. The Flesh Golems are not quick enough to give chase and lumberingly peel off the rearguard and disappear.\n\nYou might still yet return to this place, for why are those things even here at all?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll be back.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "After the battle...";
				this.World.Statistics.getFlags().set("AbandonedVillageFightDefeated", true);
			}

		});
	}

	function onUpdateScore()
	{
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

	function buildEventCombatProperties( _event, _location )
	{
		local properties = this.Const.Tactical.CombatInfo.getClone();
		properties.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[_location.getTile().TacticalType];
		properties.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
		properties.CombatID = "AbandonedVillage";
		properties.Music = this.Const.Music.UndeadTracks;
		properties.LocationTemplate.Template[0] = "tactical.golems_village";
		properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineCenter;
		properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
		properties.IsWithoutAmbience = true;
		properties.Parties.push(_location);
		local weather = this.Tactical.getWeather();
		local time = this.World.getTime().TimeOfDay;
		weather.setAmbientLightingColor(this.createColor(this.Const.Tactical.AmbientLightingColor.Time[time]));
		weather.setAmbientLightingSaturation(this.Const.Tactical.AmbientLightingSaturation.Time[time]);
		local clouds = weather.createCloudSettings();
		clouds.Type = this.getconsttable().CloudType.Fog;
		clouds.MinClouds = 20;
		clouds.MaxClouds = 20;
		clouds.MinVelocity = 10.0;
		clouds.MaxVelocity = 30.0;
		clouds.MinAlpha = 0.35;
		clouds.MaxAlpha = 0.45;
		clouds.MinScale = 2.0;
		clouds.MaxScale = 3.0;
		weather.buildCloudCover(clouds);
		properties.Entities = [];
		local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();
		properties.BeforeDeploymentCallback = function ()
		{
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 7, 8, 7, 8, true);

			for( local i = 0; i < 2; i = ++i )
			{
				_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", f, 6, 9, 6, 9, false);
			}

			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 6, 9, 6, 9, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 7, 8, 25, 26, true);

			for( local i = 0; i < 2; i = ++i )
			{
				_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", f, 6, 9, 24, 27, false);
			}

			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 6, 9, 24, 27, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 24, 25, 15, 16, true);

			for( local i = 0; i < 2; i = ++i )
			{
				_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", f, 23, 26, 14, 17, false);
			}

			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 23, 26, 14, 17, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 13, 15, 3, 5, false);
			_event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", f, 13, 15, 26, 28, false);
		};
		properties.AfterDeploymentCallback = function ()
		{
			this.Tactical.getWeather().setAmbientLightingPreset(5);
			this.Tactical.getWeather().setAmbientLightingSaturation(0.9);
		};
		return properties;
	}

	function spawnEntityWithinBounds( _entity, _faction, _xLower, _xUpper, _yLower, _yUpper, _raiseTile, _maxAttempts = 200 )
	{
		local attempts = 0;
		local spawned = false;

		do
		{
			attempts++;
			local x = this.Math.rand(_xLower, _xUpper);
			local y = this.Math.rand(_yLower, _yUpper);
			local tile = this.Tactical.getTileSquare(x, y);

			if (!tile.IsEmpty)
			{
			}
			else
			{
				if (_raiseTile)
				{
					tile.Level = 1;

					for( local i = 0; i != 6; i = ++i )
					{
						if (!tile.hasNextTile(i))
						{
						}
						else
						{
							local next = tile.getNextTile(i);

							if (next.Level == 1)
							{
								tile.Level = 2;
								break;
							}
						}
					}
				}

				local e = this.Tactical.spawnEntity(_entity, tile.Coords);
				e.setFaction(_faction);
				e.assignRandomEquipment();
				spawned = true;
			}
		}
		while (!spawned && attempts <= _maxAttempts);

		return spawned;
	}

});


this.artifact_reliquary_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.artifact_reliquary_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_182.png[/img]{The estate towers over the area with pure cut stoneworks and colored roofing tiles. It has something most royalty cannot afford, which is a sense of taste. With grass trimmed low, the lawn seemed almost like a footprint unto an unkept land. Statues of people dot the landscape, capturing poses both regaling and regretful. Amidst the crowd of sculptures are hedges cut into the shapes of animals and fountains with clear water in them. The company stands outside a black fence, idling and staring through the bars like farm animals. %randombrother% shakes his head and spits.%SPEECH_ON%Yeah, it\'s all quite pretty and all, but no deep pocket fark is just gonna leave the front gate open like this for no reason, ya know? I think either somebody has already ran through the place, or something awful is inside and it don\'t mind the occasional innocent passerby.%SPEECH_OFF%You agree. When looking further in, you can see the path leads to a bowled out decline, as if the gods had knuckled a bit of the earth itself with overhangs and escarpments encircling the area. If you\'re going to explore such a place, you know in your heart that you might not make it back. You could still leave now and return later...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Onward, men.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Let\'s come back later.",
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
				if (this.World.Statistics.getFlags().get("ReliquaryFightDefeated"))
				{
					this.Text = "[img]gfx/ui/events/event_182.png[/img]{You venture into the bowled soil, and in turn the flesh golems predictably take to this \'venue\' and settle about the rim of the escarpment. The Grand Diviner stands center, unusual staff in hand, and a grin on his face.%SPEECH_ON%Welcome back. Let the mothering continue.%SPEECH_OFF%}";
					this.Options = [
						{
							Text = "This motherfarker...",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_182.png[/img]{You order the company into the moon-like escarpment. Suddenly, a man wearing a tall black helm swings himself around a statue. He wield an unusual staff, a trail of green mist wafting behind its glassy top.%SPEECH_ON%Welcome! Have you come to understand my work? It is in the warmth of mothering that one finds the primal instincts, the flashes of intellect which all creatures, from the feeblest worms to the most soaring birds, understand, and without which man shall never have supremacy over all things. I, a man, am mother now. I, a man, have broken the order, and on this instinct native to all creatures, I shall rise, wombless, ascending above the architecture of nature herself, and become nurturer to all! I, the Grand Diviner, the one who shall moisten this dry earth with manifestations...%SPEECH_OFF%Monologuing madmen wielding strange staffs rarely have good intentions. You draw your sword and, seeing your blade, the Grand Diviner goes quiet. He nods and swings his arms wide, a flash of green sparking from his staff. Creatures like those you’ve seen before – gelatinous, bulbous assemblages of vague appendages – all start shuffling out from behind the statues. More yet encircle the entire company, occupying spaces on high, saddling themselves onto the lip of the escarpments like visitors in a coliseum, ever-ready to watch a good fight. The Grand Diviner grins and points his staff at you.%SPEECH_ON%Smile, sellsword, for when you die I shall mother you back into this world, and you shall find nurture in the bosom of my power!%SPEECH_OFF%}",
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

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_182.png[/img]{The Diviner is found in the mire of his creatures, a wounded man strewn across the afterbirth of his own manifestations. His heavy helmet guards his neck, but you simply crouch down and lever the point of your sword under it, like lifting a bucket with a dagger. He coughs and says.%SPEECH_ON%You can\'t truly kill me no more than you can kill mother nature.%SPEECH_OFF%You nod and drive the steel through his chin until you hear its tip touch the top of his helm. Blood spews over the neckguard. Standing, you say,%SPEECH_ON%I am mother nature.%SPEECH_OFF%%randombrother% laughs.%SPEECH_ON%Nice line, captain. Sorta dumb if you think about it too much but-%SPEECH_OFF%You cut the sellsword off and tell him and the rest of the men to loot the place. Surely the gothic estate has some valuables that will have made this venture worthwhile. As for the Diviner\'s curious staff still yet swirling with a faint green glow, you have it taken to inventory. As you prepare to leave, a report comes in that a number of the \'flesh golems\' ran out of the gothic estate and fled into the wild. Their progenitor is dead, but it seems you may still yet continue to find his creations.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "At least the most monstrous of the lot is dead.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "After the battle...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/weapons/legendary/miasma_flail");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_182.png[/img]{You\'re losing the fight, and you\'d rather not lose more - for it seems against the Grand Diviner that death may not be the end of you. Cutting your losses, you call a retreat and break your way out of the encirclement. The \'watchful\' flesh golems mockingly groan at you like a displeased coliseum audience.\n\nChoking on laughter, the Grand Diviner holds his ground and fades into the background. A lick of wispy green mist reaches for you, forming the shape of a mouth that grins, and then all is gone and you are back out of the place. Returning is a large ask, but you now feel determined to see this madman slain.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Will probably have to kill him to get him out of our dreams anyway.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "After the battle...";
				this.World.Statistics.getFlags().set("ReliquaryFightDefeated", true);

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
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
		properties.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
		properties.CombatID = "ArtifactReliquary";
		properties.TerrainTemplate = "tactical.golems";
		properties.LocationTemplate.Template[0] = "tactical.golems_lair";
		properties.Music = this.Const.Music.UndeadTracks;
		properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
		properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
		properties.IsFleeingProhibited = true;
		properties.IsWithoutAmbience = true;
		properties.IsFogOfWarVisible = false;
		properties.Parties.push(_location);
		local weather = this.Tactical.getWeather();
		local time = this.World.getTime().TimeOfDay;
		weather.setAmbientLightingColor(this.createColor(this.Const.Tactical.AmbientLightingColor.Time[time]));
		weather.setAmbientLightingSaturation(this.Const.Tactical.AmbientLightingSaturation.Time[time]);
		local clouds = weather.createCloudSettings();
		clouds.Type = this.getconsttable().CloudType.Fog;
		clouds.MinClouds = 20;
		clouds.MaxClouds = 20;
		clouds.MinVelocity = 3.0;
		clouds.MaxVelocity = 9.0;
		clouds.MinAlpha = 0.15;
		clouds.MaxAlpha = 0.25;
		clouds.MinScale = 2.0;
		clouds.MaxScale = 3.0;
		weather.buildCloudCover(clouds);
		properties.Entities = [];
		local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();
		properties.BeforeDeploymentCallback = function ()
		{
			local sorcerers = [];
			local greaterGolems = [];
			local entity;
			entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/grand_diviner", f, 16, 18, 10, 14, 0, true, sorcerers);

			if (entity != null)
			{
				sorcerers.push(entity);
			}

			for( local i = 0; i < 4; i = ++i )
			{
				entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", f, 18, 21, 6, 24, 0, true, sorcerers);

				if (entity != null)
				{
					sorcerers.push(entity);
				}
			}

			for( local i = 0; i < 4; i = ++i )
			{
				_event.spawnGuardEntity("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed_bodyguard", f, sorcerers);
			}

			for( local i = 0; i < 3; i = ++i )
			{
				entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/greater_flesh_golem", f, 15, 17, 6, 24, i + 1, true, greaterGolems);

				if (entity != null)
				{
					greaterGolems.push(entity);
				}
			}
		};
		properties.AfterDeploymentCallback = function ()
		{
			local playersAndFleshCradles = [];
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

			foreach( bro in brothers )
			{
				playersAndFleshCradles.push(bro);
			}

			local entity;

			for( local i = 0; i < 10; i = ++i )
			{
				entity = _event.spawnEntityWithinBounds("scripts/entity/tactical/enemies/flesh_cradle", f, 4, 24, 4, 24, 0, true, playersAndFleshCradles);

				if (entity != null)
				{
					playersAndFleshCradles.push(entity);
				}
			}

			this.Tactical.getWeather().setAmbientLightingPreset(5);
			this.Tactical.getWeather().setAmbientLightingSaturation(0.9);
		};
		return properties;
	}

	function spawnEntityWithinBounds( _entity, _faction, _xLower, _xUpper, _yLower, _yUpper, _useVariant = 0, _avoidEntities = false, _entitiesToAvoid = [], _maxAttempts = 500 )
	{
		local attempts = 0;
		local entity;

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
				if (_avoidEntities)
				{
					local scrapTile = false;

					foreach( entityToAvoid in _entitiesToAvoid )
					{
						if (tile.getDistanceTo(entityToAvoid.getTile()) < 3)
						{
							scrapTile = true;
							break;
						}
					}

					if (scrapTile)
					{
						  // [050]  OP_JMP            0     21    0    0
					}
				}

				entity = this.Tactical.spawnEntity(_entity, tile.Coords);
				entity.setFaction(_faction);
				entity.assignRandomEquipment();

				if (_useVariant > 0)
				{
					entity.setVariant(_useVariant);
				}
			}
		}
		while (entity == null && attempts <= _maxAttempts);

		return entity;
	}

	function spawnGuardEntity( _guardEntity, _guardFaction, _wards, _maxAttempts = 500 )
	{
		local attempts = 0;
		local entity;

		do
		{
			attempts++;
			local entityToProtect;
			local tile;

			foreach( ward in _wards )
			{
				if (ward.getType() != this.Const.EntityType.FaultFinder)
				{
					continue;
				}

				local alreadyHasGuard = false;

				for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
				{
					if (!ward.getTile().hasNextTile(i))
					{
					}
					else
					{
						local nextTile = ward.getTile().getNextTile(i);

						if (nextTile.IsEmpty)
						{
						}
						else if (nextTile.IsOccupiedByActor && nextTile.getEntity().getType() == this.Const.EntityType.LesserFleshGolem)
						{
							alreadyHasGuard = true;
							break;
						}
					}
				}

				if (alreadyHasGuard)
				{
					continue;
				}

				entityToProtect = ward;
			}

			if (entityToProtect == null)
			{
			}
			else
			{
				for( local i = this.Const.Direction.COUNT - 1; i >= 0; i = --i )
				{
					if (!entityToProtect.getTile().hasNextTile(i))
					{
					}
					else
					{
						local nextTile = entityToProtect.getTile().getNextTile(i);

						if (nextTile.IsEmpty)
						{
							tile = nextTile;
							break;
						}
					}
				}

				entity = this.Tactical.spawnEntity(_guardEntity, tile.Coords);
				entity.setFaction(_guardFaction);
				entity.assignRandomEquipment();
			}
		}
		while (entity == null && attempts <= _maxAttempts);

		return entity;
	}

});


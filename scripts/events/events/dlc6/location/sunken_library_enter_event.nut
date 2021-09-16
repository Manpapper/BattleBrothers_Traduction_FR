this.sunken_library_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.sunken_library_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_173.png[/img]{The shine and shimmer is so bright you almost think the Gilder Himself has ordained you a proper visit - unfortunately or fortunately, what you\'ve stumbled across is actually a great gilded dome protruding ever so slightly from the sands. Immediately, you test if you can pull some of the gold away, but it has no give. %randombrother% calls you over to a slab of stone which is gapped. Perhaps a belltower at one point? Light fades quick and you can see very little inside. Above the entryway a relief depicts men pulling carts of scrolls.\n\n There\'s a set of words repeatedly scrawled across the relief. None of the languages look remotely familiar to anything you\'ve ever heard or seen. It takes a bit of time until you can find a hurriedly etched translation left by someone approximal to your era: \'the Library, the Labyrinth of the Night, the Labyrinth of the Mind, Leave here as you would Leave a Dream, Tread here as you would Tread a Dream, Leave to Dwell upon the Horror of not Knowing, Enter to be One with Knowing, and in Knowing the Dream, Know the Nightmare\'.%SPEECH_ON%Fair bit ominous, captain, but if you wanna go down in there we got the rope and torches to see to it.%SPEECH_OFF%%randombrother% tells you this, and the look on his face suggests he\'s hoping you decline the proposition.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rappel down into the dark!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Let\'s not disturb what rests here.",
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
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_89.png[/img]{The climb down is a perilous one, the dark so thick you can\'t even see your own boots. But eventually you hit a marbled floor and quickly light up some torches. You find yourself in a massive hall around which spiral rows and rows of bookcases. Every shelf is adorned with piles of scrolls, many dwelling within glass enclosures. The shelves are stacked upon each other and seem to ascend to the very ceiling from which you descended. Rolling ladders rest at each level, but even further up runs a floating mezzanine with metal chutes stationed here and there. It seems as though once upon a time one was meant to pass these scrolls up and down, though now everything is rusted, and the mezzanine has collapsed in parts.\n\n %randombrother% calls your attention. He points to an enormous scroll flattened behind a sheet of glass. Drawings sprawl over the paper, and upon closer inspection it appears they are blueprints for seemingly everything: the human body, the bodies of many animals, castles, towers, windmills, ships, weapons and armor, boots and gloves, alignments of the stars, and a great number of drawings of things which you have never seen before, things which don\'t make sense.%SPEECH_ON%Captain, this place is not meant for us. The languages, the halls, we should go.%SPEECH_OFF%One of the sellswords expresses the mood in the air. You have absolutely trespassed to a place few have gone before. And if they have gone before, where are they? A place like this surely can\'t stay hidden, right?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What was that noise?",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_89.png[/img]{%SPEECH_START%Interlopers in the Library.%SPEECH_OFF%The voice scratches along the marbled floor and rises up to meet your ears and continues on, the word \'Libraryyy\' slithering into the dark behind you. Suddenly, a number of the glass cases begin to glow, the phylacteries holding some sort of ethereal energy, and as the light widens it unveils the torso of a black skeleton, its body captured in air. The ribcage holds a book, hooked into place by the sickly folds of its own ribs as a spider would clutch a meal. The skull of the creature stares at you with peerless sockets.%SPEECH_ON%Your kind has already stolen from me, now you dare profane these halls again?%SPEECH_OFF%The phylacteries grow brighter and in turn the skeleton\'s torso grows flesh, weeds of vein and the pulp of skin blossoming outward to cover bone. But it is only the torso which is ensconced. You stare at the phylacteries and they are brimming with energy now, and in staring you can see the ghostly faces smearing along the glass like streaks of rain. You hear a loud clap and turn back to see the Loremaster in full, its eyes aflame with white fire, its limbs skinny yet with smoky muscles winding around its frame, and its lower half is pluming with black ash as it glides forward. The brighter the glass bulbs get, the stronger and faster it becomes!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fight for your lives! Fight like you\'ve never fought before!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "SunkenLibrary";
						p.TerrainTemplate = "tactical.sinkhole";
						p.LocationTemplate.Template[0] = "tactical.sunken_library";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.IsWithoutAmbience = true;
						p.Entities = [];

						for( local i = 0; i < 4; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.SkeletonHeavyBodyguard);
						}

						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}

						p.BeforeDeploymentCallback = function ()
						{
							local phylacteries = 10;
							local phylactery_tiles = [];

							do
							{
								local x = this.Math.rand(10, 28);
								local y = this.Math.rand(4, 28);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local skip = false;

									foreach( t in phylactery_tiles )
									{
										if (t.getDistanceTo(tile) <= 5)
										{
											skip = true;
											break;
										}
									}

									if (skip)
									{
									}
									else
									{
										local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/phylactery", tile.Coords);
										e.setFaction(f);
										phylacteries = --phylacteries;
										phylactery_tiles.push(tile);
									}
								}
							}
							while (phylacteries > 0);

							local toRise = 5;

							do
							{
								local r = this.Math.rand(0, phylactery_tiles.len() - 1);
								local p = phylactery_tiles[r];

								if (p.SquareCoords.X > 14)
								{
									p.Level = 3;
									toRise = --toRise;
								}

								phylactery_tiles.remove(r);
							}
							while (toRise > 0 && phylactery_tiles.len() > 0);

							local lich = 1;

							do
							{
								local x = this.Math.rand(9, 10);
								local y = this.Math.rand(15, 17);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_lich", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									lich = --lich;
								}
							}
							while (lich > 0);

							local treasureHunters = 3;

							do
							{
								local x = this.Math.rand(9, 11);
								local y = this.Math.rand(11, 21);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie_treasure_hunter", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									local item = e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
									item.setCondition(this.Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
									treasureHunters = --treasureHunters;
								}
							}
							while (treasureHunters > 0);

							local heavy = 4;

							do
							{
								local x = this.Math.rand(9, 14);
								local y = this.Math.rand(8, 20);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_heavy", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									local item = e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
									item.setCondition(this.Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
									heavy = --heavy;
								}
							}
							while (heavy > 0);

							local heavy_polearm = 4;

							do
							{
								local x = this.Math.rand(12, 14);
								local y = this.Math.rand(12, 26);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
								}
								else
								{
									local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_heavy_polearm", tile.Coords);
									e.setFaction(f);
									e.assignRandomEquipment();
									local item = e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
									item.setCondition(this.Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
									heavy_polearm = --heavy_polearm;
								}
							}
							while (heavy_polearm > 0);
						};
						p.AfterDeploymentCallback = function ()
						{
							this.Tactical.getWeather().setAmbientLightingPreset(5);
							this.Tactical.getWeather().setAmbientLightingSaturation(0.9);
						};
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
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
			Text = "[img]gfx/ui/events/event_89.png[/img]{The Lorekeeper collapses onto the ground a pile of ash and the phylacteries slowly fade back to dark. You walk over with torch in hand. Its black skull resides atop the book that once dwelled in its chest.%SPEECH_ON%Captain, I don\'t think we should be touching anything here.%SPEECH_OFF%You ignore one of your men and pick the book up. Its leather covering is stitched together, and as you look closer you can see the flesh of ears and noses encompassing the cover. Immediately, the bones of the slain undead scratch across the marbled floor. One zips between your legs and flies into the pile of ash. A dull white fire alights inside the socket of the skull. That\'s more than enough for you: with a quick command, you get the men to climb back up the rope, yourself the last to leave. As you near the light of the earth above, you take one moment to stare back down and - the black skull is already in your face! It floats alone, eyes burning white, capturing your sight in a cone of fire you cannot understand, and as you stare into it you can hear the voices of your men fade away. The skull floats alone, and you almost feel the urge to let the rope go. The skull speaks to your mind:%SPEECH_ON%It is but one of its gifts, Interloper, and you are not the first to have it. There is many who have taken it, and in the many there is but one end, the one who awaits us all!%SPEECH_OFF%The skull\'s fire snuffs out and it drops away into the dark where you hear a brief clatter. The voices of your men rush back in, louder than ever and you look up to see %randombrother%\'s hand. Grabbing hold, they pull you out. As you exit, the entrance sinks into the sand, and all you have of the place is a strange, fleshen book filled with writings you cannot ever hope to decipher.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What did I just take?",
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
				local item = this.new("scripts/items/special/black_book_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Flags.set("IsLorekeeperDefeated", true);
				this.updateAchievement("Lorekeeper", 1, 1);
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_173.png[/img]The men run and hastily climb up again.%SPEECH_ON%Perhaps another time?%SPEECH_OFF%One sellsword says. %randombrother% nods.%SPEECH_ON%Another time, aye. Maybe a time far away from now, when I\'m out retired and farkin\' whoors, then y\'all can dip down into the darkness and go gallivanting with dead wizards. Does that time work for y\'all?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Perhaps one day...",
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

});


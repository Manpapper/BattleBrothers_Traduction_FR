this.icy_cave_enter_event <- this.inherit("scripts/events/event", {
	m = {
		Champion = null
	},
	function create()
	{
		this.m.ID = "event.location.icy_cave_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A1",
			Text = "[img]gfx/ui/events/event_144.png[/img]{You discover a cave in the ice with its maw shielded by a gate of thick icicles. Looking through the icy bars, you find the cave quickly declines down a steep slope and toward what may be an underground riverbank that has long since frozen. Something is huddled beside it hitting the ice with a pickaxe over and over again. The wind whistles as it grates against the teeth of the cave. You call out to the huddled man, but there is no response.\n\nIt will take some time to chop through this thick ice and get in there. Fortunately, one of the sellswords reports that there may be a rear entrance. It is blocked just as well, but a strong enough man just might be able to squeeze through and face any dangers within.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "As you approach...";
				local raw_roster = this.World.getPlayerRoster().getAll();
				local roster = [];

				foreach( bro in raw_roster )
				{
					if (bro.getPlaceInFormation() <= 17)
					{
						roster.push(bro);
					}
				}

				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "I need you to scout ahead, " + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
					  // [057]  OP_CLOSE          0      6    0    0
				}

				$[stack offset 0].Options.push({
					Text = "We should leave this place.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_144.png[/img]{You followed the mysterious messenger\'s footsteps to a cave in the ice. This time it has not been recently trespassed as a thick gate of icicles keep your entrance well stayed. To the side of the cavern\'s maw is the old man face down in the snow, dead as can be, and with one arm stretched out pointing into the cave.\n\n Looking through the icy bars, you find the cave quickly declines down a steep slope and toward what may be an underground riverbank that has long since frozen. Something is huddled beside it hitting the ice with a pickaxe over and over again. The wind whistles as it grates against the teeth of the cave. You call out to the huddled man, but there is no response.\n\nIt will take some time to chop through this thick ice and get in there. Fortunately, one of the sellswords reports that there may be a rear entrance. It is blocked just as well, but a strong enough man just might be able to squeeze through and face any dangers within.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "As you approach...";
				local roster = this.World.getPlayerRoster().getAll();
				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "I need you to scout ahead, %champion%.",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
					  // [036]  OP_CLOSE          0      5    0    0
				}

				$[stack offset 0].Options.push({
					Text = "We should leave this place.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_144.png[/img]{%chosen% heads off while you and the rest work on the front of the cave. You knock a few of the thick icicles out letting you see into the cave with better eyes. Just as you do, %chosen% comes tumbling down an adjacent slope and lands right in the middle of the cave and slides across the frozen river and rides up its embankment. He hops to his feet and dusts himself off with a childish grin.\n\n In a flash the huddled man slams the pickaxe into the ice with unhinted power and the shards splinter from one side of the embankment to the other. The clank of the metal and shattered ice reverberates as though lightning itself had struck. Now you can finally see the stranger: he is a barbarian shelled in broken armor that rattles as he moves. The icy walls mirror his steps, scattering his presence all around the cave in transient sheens. Jittery and jutting, his walk is seemingly going backwards despite his advance as though his shadow were his true self and his flesh the afterimage. Despite being in a cave, his loud voice echoes not at all.%SPEECH_ON%An interloper in my midst, a mere moment from the mist, these things I shall not miss.%SPEECH_OFF%He approaches the sellsword like a cold spider unfurling from its trapdoor. You see that his face is half-frozen, and a wry smile squeezes across the half that could still be called flesh.%SPEECH_ON%I long to leave this body, my dear fighter. Will you help guide me out and to something higher?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BeastsTracks;
						properties.Entities = [];
						properties.Entities.push({
							ID = this.Const.EntityType.BarbarianMadman,
							Variant = 0,
							Row = 0,
							Script = "scripts/entity/tactical/humans/barbarian_madman",
							Faction = this.Const.Faction.Enemy
						});
						properties.Players.push(_event.m.Champion);
						properties.IsUsingSetPlayers = true;
						properties.IsFleeingProhibited = true;
						properties.IsAttackingLocation = true;
						properties.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();

							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = this.Math.min(1, tile.Level);
								}
							}
						};
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(properties, false, false, false);
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "As you approach...";
				this.Options[0].Text = "You can take him, %chosen%!";
				this.Characters.push(_event.m.Champion.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_144.png[/img]{%chosen% cuts the madman down. His chest armor shatters and flies off his body, chunks of plate spinning and warbling into the air and yet tethered together by some strange blue tendrils.\n\n Your men finally break through the icy cavern\'s entrance and slide down the declination. %chosen% is quite alright, nodding smugly as he sheathes his weapon.%SPEECH_ON%Just a crazy fuck, captain.%SPEECH_OFF%You crouch beside the body. Ice contorts half the flesh, twisting it into nubs of black, and what isn\'t frozen is flaked by strangely sparkling rime. Despite his grisly state, the mad man died with a wild grin still on his face. The eyes are a bright blue and you see yourself in their gaze, a faceless silhouette. And then the color slowly slips away, not like you\'ve seen before, but as though someone were dragging a curtain through a window, slowly sucking all color right into the sockets. The corpse grins at you, but you refuse to believe that is what you saw.\n\n One of the mercenaries picks up the mad man\'s bizarre armor and holds it at length.%SPEECH_ON%What do you figure this is?%SPEECH_OFF%The plates dangle from one another by some strange blue gelatin, and the insides of the metal slats are coated in bubbling, twirling blues as though it were the work of some celestial blacksmith. It is cool to the touch and gives beneath the slightest push of your finger. You\'ve never seen or felt anything like it, but the armor itself is currently in an unusable state. You have the goop and armor put into inventory, scour the cave for more goods which there are none. Before you leave the cave, you glance at the corpse one last time. You think you saw it move again, but surely it is the cold of the frozen north that is playing tricks on you.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You did well, %chosen%.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "After the battle...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(true);
				}

				this.Characters.push(_event.m.Champion.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/broken_ritual_armor_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_144.png[/img]{Through the icicles you can see the madman cutting down %chosen%. Even as he lies dead on the ground, the stranger continues to hack away at him, and each time a muffled thump echoes through the cave. What will you do now?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Title = "After the battle...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				local roster = this.World.getPlayerRoster().getAll();
				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "I need you to go in there, " + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B";
						}

					});
					  // [057]  OP_CLOSE          0      5    0    0
				}

				$[stack offset 0].Options.push({
					Text = "This isn\'t worth it. We should leave this place.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_144.png[/img]{As you depart the cave, a local northerner covered in bear furs stands across the company. He looks at you and then the cave entrance. He asks.%SPEECH_ON%Do you speak the southern or native tongue?%SPEECH_OFF%Keeping your guard, you confirm the former. He nods.%SPEECH_ON%And what did you see in that cave? Did you see it?%SPEECH_OFF%You tell him you found nothing, only a madman. The stranger smirks.%SPEECH_ON%A madman. A madman, that is what you think you saw. It is within us all to speak warily of the unnatural, but not within us to recognize when nature herself takes a step back. Horrors are easier said than seen. That was no ordinary man, you fool, but the Ijirok, a transient spirit that shifts from one vessel to another. No one really knows what it looks like, the whole world is simply a series of masks and it will happily go from one to the other, usually taking the shape of animals, sometimes a man if he is so weak. It is a being of absolute malice. It cannot be killed, no, it sees death, even its own, as entertainment. It remembers those who escape it, it remembers those it wishes to play with. I pray you\'ve a face worth forgetting.%SPEECH_OFF%You put your hand on the pommel of your sword and tell him that whatever mysticism and mythmaking he\'s got left he can keep to himself. You saw the madman in the cave, and that\'s all he was, a man. The stranger nods again and backs off.%SPEECH_ON%As you wish, and may you travel well.%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Travel well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "After the battle...";
				this.World.Flags.set("IjirokStage", 4);
				local locations = this.World.EntityManager.getLocations();

				foreach( v in locations )
				{
					if (v.getTypeID() == "location.tundra_elk_location")
					{
						v.setVisibilityMult(0.8);
						v.onUpdate();
						break;
					}
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
		_vars.push([
			"chosen",
			this.m.Champion != null ? this.m.Champion.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.World.Flags.get("IjirokStage") == 3)
		{
			return "A2";
		}
		else
		{
			return "A1";
		}
	}

	function onClear()
	{
		this.m.Champion = null;
	}

});


this.undead_necrosavant_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_necrosavant";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]A pile of rubble stands off the side of the path. There before it is a studious greybeard looking keenly at the stones. He\'s so deep in thought he probably wouldn\'t notice if you simply walked on.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s see what he\'s up to.",
					function getResult( _event )
					{
						if (_event.m.Witchhunter != null)
						{
							if (this.Math.rand(1, 100) <= 50)
							{
								return "B";
							}
							else
							{
								return "D";
							}
						}
						else if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Let\'s keep moving.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img]You\'re not about to leave this poor old sod out here by himself. You sidle over to him and ask what he\'s up to. He looks over at you, what must be at least seventy winters having weathered his skin into a leathery and permanent wince. He laughs.%SPEECH_ON%Trying to make sense of it all. The dead are rising up out of the earth and, seeing as how I\'m about to shuffle off to a grave of my own any day now, I figured why not be sure I\'m not one to join their ranks? This here was a temple where I was offered purgation as a child. I was also wedded here and saw my only son wedded here as well.%SPEECH_OFF%Curious, you ask what destroyed the building. The man laughs again.%SPEECH_ON%People came here asking the same questions I did. Godly questions in a world where the earth has manifested itself deific and rebirthed the dead. Violence was the answer they found - and so they decided to dismantle it stone by stone. I\'d admonish them for that, but it\'d be a ruse. I\'d probably do the same as they did had I the means, but, you know, I\'m old as shite and can\'t do much beyond lifting my own fingers. It\'s quite easy to be the pacifist when even a fly can lick your nose free of punishment.%SPEECH_OFF%His hearty laugh returns. He offers you a silver bowl.%SPEECH_ON%Found this in my search. Monks used to splash water in it to cleanse the sick. It ain\'t the answer I was looking for, but here, take it. I\'ve no use for such things. Not now. Not in any sense. Good luck out there and if you, you know, see me again like \'that\', please put me out of my misery.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Godspeed, stranger.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/silver_bowl_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_29.png[/img]These are dangerous times for even men of strong stock, it sure as hell isn\'t safe for an old fart who has probably lost a couple of marbles. You go over and call out to him. Instantly, he jerks his head around, eyes flared, the pupils bloated to make his sight a starless abyss. He points a finger right at you.%SPEECH_ON%Your blood. Give it to me.%SPEECH_OFF%The stranger slowly rises to his feet. His cloak falls off his body, revealing a naked skeleton with only the thinnest veneer of flesh. He shambles toward you. His mouth is open, but there are no articulations. He seems to be speaking from some other world entirely.%SPEECH_ON%My reckoning, your crimson, my reckoning, your crimson.%SPEECH_OFF%%randombrother% jumps forward, weapon in hand.%SPEECH_ON%He\'s a sorcerer!%SPEECH_OFF%The men arm themselves as the necromancer leans back, his cloak lifting up off the ground and clothing him as though the wind itself were at his beck and call. Suddenly, bodies emerge from the earth, growling and mewling. He stares at you from beneath the rim of hat slowly lowering over his eyes.%SPEECH_ON%So be it.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnPartyDestroyed);
						}

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.UndeadTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Zombies, this.Math.rand(80, 120), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						properties.Entities.push({
							ID = this.Const.EntityType.Necromancer,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/necromancer",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID(),
							Callback = null
						});
						this.World.State.startScriptedCombat(properties, false, false, true);
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
			Text = "[img]gfx/ui/events/event_76.png[/img]Suddenly, a crossbow aims over your shoulder and fires so closely you can feel the air rushing past the twang of its rope. The bolt pierces the old man\'s skull and he tips forward, head to the mud, arse in the air, hands still beside himself in dispirited supination.\n\nYou turn to see %witchhunter% the witch hunter standing behind you. He lowers the crossbow and walks over to the corpse, grabbing it by the nape of the neck and putting a stake through its back. The body wretches with a shriek and the clothing bloats as the body implodes, a swirling dust hurriedly exiting out the cloak as though it had been caught impersonating a man.\n\n The witch hunter turns to you.%SPEECH_ON%Necrosavant. Rare. Extremely dangerous.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Uh huh.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local item = this.new("scripts/items/misc/vampire_dust_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				_event.m.Witchhunter.improveMood(1.0, "Killed a Necrosavant on the road");

				if (_event.m.Witchhunter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Witchhunter.getMoodState()],
						text = _event.m.Witchhunter.getName() + this.Const.MoodStateEvent[_event.m.Witchhunter.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Witchhunter = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
	}

});


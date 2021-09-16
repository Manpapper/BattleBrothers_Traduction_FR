this.wild_dog_sounds_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		Wildman = null,
		Expendable = null
	},
	function create()
	{
		this.m.ID = "event.wild_dog_sounds";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]{As the company camps, %randombrother% stops stropping a blade and looks up.%SPEECH_ON%Y\'all hear that?%SPEECH_OFF%You do. Wild dogs are yipping and howling. You shrug and say it\'s nothing, but in that moment there\'s a yelp and the yips turn into snarling and you hear the distinct sound of animalistic struggle. The snarls turn to whines. Something is losing the fight. %randombrother% turns to you.%SPEECH_ON%Sounds close, should we check it out? I don\'t wanna sleep with that around.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Just ignore it.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Hunter != null)
				{
					this.Options.push({
						Text = "You\'re a hunter, %hunter%, go take a look.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "You are a man of the wilds, %wildman%, go take a look.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				if (_event.m.Expendable != null)
				{
					this.Options.push({
						Text = "Looks like a job for the new guy. Go take a look, %recruit%!",
						function getResult( _event )
						{
							return this.Math.rand(1, 100) <= 40 ? "F" : "G";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]{You tell the company to ignore the sounds. That\'s a hard task to oblige as the cries of the wild dogs only grow louder and louder until, just like that, they stop. Your men stand still as though making any noise could bring the hell of whatever horror it is that\'s out there. Nothing comes to pass, but a number of the men have a hard time sleeping through the night.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Grow a pair, you gits.",
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
					if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_hunter")
					{
						continue;
					}

					if (bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.worsenMood(0.5, "Didn\'t get a good night\'s sleep");
						local effect = this.new("scripts/skills/effects_world/exhausted_effect");
						bro.getSkills().add(effect);
						this.List.push({
							id = 10,
							icon = effect.getIcon(),
							text = bro.getName() + " is exhausted"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]{You tell the company to plug their ears if it bothers them so much. As the cries of the wild dogs grow louder the men turn to impromptu ear candling to keep the sounds at bay. Eventually, the sense deprived sellswords are awkwardly walking around like animatronics. You look to join the muted, plugging a waxball into your ear, but before you can get the second ear a loud crash sends inventory flowing and a tent billows as it collapses. You drain your ear and bark orders to the mercenaries who are scattered all over the camp.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms, you deaf fools!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.Entities = [];
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Unhold, this.Math.rand(80, 100), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
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
			Text = "[img]gfx/ui/events/event_14.png[/img]{It does appear the men will not be assuaged by telling them to grow a pair. %hunter% elects to go seek out the noise, as he\'s sure it\'s nothing more than the wild dogs squabbling over primacy over the pack. You send him on his way, the man venturing into the dark all by his lonesome. Just as soon as he\'s gone the canines cease their crying and you hear a growl that seems as though it came from a much higher ground. The whole camp is dead silent, daring not to even move.\n\n An hour later and the hunter walks into camp, nobody having heard him come in. He\'s camouflaged himself in mud slaked with twigs and leaves. He\'s grafted stems into a hood which he wears like some arboreal abbess. With hushed tones, the sellswords ask what he saw. He shrugs.%SPEECH_ON%Well. I seen about a dozen dead dogs. Some ripped apart. Found a few in the pit of very large footprints and they\'d not found the print but had been stomped there, you know. And I saw something move along in the shadows between the tree tops and it went the other way and I did not follow. I found a deer dead on its feet leaning against a tree. Heart faltered by whatever it saw, I suppose. I harvested everything I could.%SPEECH_OFF%The man turns and slings forward a rack of meat strung to a paneling of wood and leaves.%SPEECH_ON%Anyone hungry?%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hell of a haul, I suppose.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hunter.getImagePath());
				local item = this.new("scripts/items/supplies/cured_venison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				_event.m.Hunter.getBaseProperties().Bravery += 1;
				_event.m.Hunter.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Hunter.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_hunter")
					{
						continue;
					}

					if (bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 15)
					{
						bro.worsenMood(0.5, "Concerned that there\'s something big out there");
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Fear comes over the camp, but you fetch %wildman% to your side. The wildman snorts and runs his hand along his nose as though you\'ve inconvenienced whatever inexplicable notion he has of his own time. He raises an eyebrow as you suggest, to the best of your pantomiming abilities, that he go and seek out the noise. With little further suggestion, the man grunts and takes off into the woods.\n\n You swear he\'s a good hundred meters off but you can still hear him barreling through the bushes making all the goddam noise in the world. The wild dogs quit their baying and in their place you hear a loud growl and the hoots of a smaller one. They bandy back and forth and you notice you can feel the ground tremoring beneath your feet. The vibrations falter and fade and the screaming halts altogether. Just as you begin to worry, the wildman walks back into camp. He sits beside the campfire, yawns, turns over, and falls asleep. It is as though he\'d never left at all.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Problem good as solved, I guess.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.improveMood(1.0, "Had a good night\'s sleep");

				if (_event.m.Wildman.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Wildman.getMoodState()],
						text = _event.m.Wildman.getName() + this.Const.MoodStateEvent[_event.m.Wildman.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_33.png[/img]{You look about the company. A young %recruit% looks back. He looks down, as though to look within himself, and then hurriedly gets to his feet.%SPEECH_ON%Say no more, captain. I will find out what this disturbance is.%SPEECH_OFF%The fresh recruit gathers his things and then stands at the edge of the camp\'s light, a very dark forest looking back at him. The man stares down again and clenches and unclenches his hands.%SPEECH_ON%Alright. Alright.%SPEECH_OFF%He looks up.%SPEECH_ON%Let\'s do this.%SPEECH_OFF%The man is never seen again.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Perhaps sending a greenhorn wasn\'t the best idea.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Expendable.getImagePath());
				local dead = _event.m.Expendable;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Went missing",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Expendable.getName() + " went missing"
				});
				_event.m.Expendable.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Expendable);
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_33.png[/img]{You look about the company. A young %recruit% looks back. He looks down, as though to look within himself, and then hurriedly gets to his feet.%SPEECH_ON%Say no more, captain. I will find out what this disturbance is.%SPEECH_OFF%The fresh recruit gathers his things and then stands at the edge of the camp\'s light, a very dark forest looking back at him. The man stares down again and clenches and unclenches his hands. He huffs and then steps forth, immediately slipping into the shadows. Hours pass. Finally, he returns. His clothes are in tatters. His weapons are gone. He spits forth story after story. Magic rings, volcanoes, giant eagles, absolute nonsense. Whatever he saw, it\'s clear the blubbering sellsword needs to clear his head with some well earned beauty sleep. Which he\'ll get since all that awful noise has ceased.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get your sleep, kid.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Expendable.getImagePath());
				_event.m.Expendable.addXP(200, false);
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Expendable.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				_event.m.Expendable.improveMood(3.0, "Had an excellent adventure");

				if (_event.m.Expendable.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Expendable.getMoodState()],
						text = _event.m.Expendable.getName() + this.Const.MoodStateEvent[_event.m.Expendable.getMoodState()]
					});
				}

				local items = _event.m.Expendable.getItems();

				if (items.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null && items.getItemAtSlot(this.Const.ItemSlot.Mainhand).isItemType(this.Const.Items.ItemType.Weapon) && !items.getItemAtSlot(this.Const.ItemSlot.Mainhand).isItemType(this.Const.Items.ItemType.Legendary) && !items.getItemAtSlot(this.Const.ItemSlot.Mainhand).isItemType(this.Const.Items.ItemType.Named))
				{
					this.List.push({
						id = 10,
						icon = "ui/items/" + items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getIcon(),
						text = "You lose " + this.Const.Strings.getArticle(items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getName()) + items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getName()
					});
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
				}

				if (items.getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					items.getItemAtSlot(this.Const.ItemSlot.Head).setCondition(this.Math.max(1, items.getItemAtSlot(this.Const.ItemSlot.Head).getConditionMax() * this.Math.rand(10, 40) * 0.01));
				}

				if (items.getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					items.getItemAtSlot(this.Const.ItemSlot.Body).setCondition(this.Math.max(1, items.getItemAtSlot(this.Const.ItemSlot.Body).getConditionMax() * this.Math.rand(10, 40) * 0.01));
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen || !this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_hunter = [];
		local candidates_wildman = [];
		local candidates_recruit = [];
		local others = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.beast_hunter")
			{
				candidates_hunter.push(bro);
			}
			else if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
			else if (bro.getXP() == 0)
			{
				candidates_recruit.push(bro);
			}
			else
			{
				others.push(bro);
			}
		}

		if (candidates_hunter.len() == 0 && candidates_wildman.len() == 0 && candidates_recruit.len() == 0 || others.len() == 0)
		{
			return;
		}

		if (candidates_hunter.len() != 0)
		{
			this.m.Hunter = candidates_hunter[this.Math.rand(0, candidates_hunter.len() - 1)];
		}

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		if (candidates_recruit.len() != 0)
		{
			this.m.Expendable = candidates_recruit[this.Math.rand(0, candidates_recruit.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hunter",
			this.m.Hunter.getName()
		]);
		_vars.push([
			"wildman",
			this.m.Wildman ? this.m.Wildman.getName() : ""
		]);
		_vars.push([
			"recruit",
			this.m.Expendable ? this.m.Expendable.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Hunter = null;
		this.m.Wildman = null;
		this.m.Expendable = null;
	}

});


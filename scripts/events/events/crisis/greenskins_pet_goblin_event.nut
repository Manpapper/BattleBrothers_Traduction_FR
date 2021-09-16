this.greenskins_pet_goblin_event <- this.inherit("scripts/events/event", {
	m = {
		HurtBro = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_pet_goblin";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]While walking through the forest, you come into a clearing where a small little hut sits. There are bear traps hanging from its walls, squirrel pelts from the eaves, and the windows are dressed with wet leaves in their corners. An old man is on the porch, rocking in his chair. He has a crossbow aimed at you.%SPEECH_ON%This is my property.%SPEECH_OFF%There\'s a chain running from the arm of his chair to a hatch on the bottom of the cabin door. It moves slightly to the man\'s speaking and he turns and butts the crossbow against the door.%SPEECH_ON%Hush, you! Now you, man with the sword, and all yer friends, get going. Another the step the wrong way, which would be my way, and I\'ll put a bolt up yer arse.%SPEECH_OFF%%randombrother% eases up to your side.%SPEECH_ON%What should we do, sir?%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Let\'s take a closer look.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "We\'ve got no time for crazies.",
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
			Text = "[img]gfx/ui/events/event_25.png[/img]You\'ve no reason to further transgress upon this old man\'s day, and so you tell the company to give him and his hut a wide berth. The elder eyes you suspiciously every step of the way.%SPEECH_ON%Mmhmm, y\'all have a good day now.%SPEECH_OFF%You nod and respond.%SPEECH_ON%Yeah, you too.%SPEECH_OFF%The chain moves again and is met with another hushing. Who knows what the hell was going on here, but the company has places to be.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Have a nice day. ",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_25.png[/img]You take a step forward. The old man springs off his chair and spits.%SPEECH_ON%Sonuvabitch.%SPEECH_OFF%He lifts the crossbow and shoots it from the hip. The shot goes wide and into the trees where it clacks and clatters off branches and shrubs. %randombrother% rushes the porch and tackles the man to the ground.%SPEECH_ON%Get your whoremongering hands off me you, you, you whoremonger!%SPEECH_OFF%While the man spits and kicks, you calmly walk up to the porch and open the door to his hut. The chain shoots across the floorboards and goes taut. A dark shape takes to the corner, scuttling up its walls trying to get further than its shackles will allow. You take a torch and wave it into the darkness. There you see the prisoner. The old man shouts from the porch.%SPEECH_ON%You leave us alone! Go on now, you leave us alone!%SPEECH_OFF%There, shrinking away from your torch, is a goblin.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Why would you keep a goblin chained up here?",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Better to kill that thing now.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_25.png[/img]You take a step forward. The old man springs off his chair and spits.%SPEECH_ON%Sonsabitches, I warned ye! I warned ye good and clear!%SPEECH_OFF%He lifts the crossbow and shoots it from the hip. The shot sails over your shoulder and shoots clear through %hurtbro%\'s arm. The sellsword looks down, a feather of a shot teetering from one end of the hole, a bloodied shaft wiggling from the other. He takes a seat.%SPEECH_ON%Well fark me.%SPEECH_OFF%%randombrother% screams and rushes ahead. As the old man tries to reload, the mercenary kicks the crossbow away and throws the shooter to the ground. You tell the sellsword to keep the man alive. While the man spits and kicks, you calmly walk up to the porch and open the door to his hut. As the door swings wide, the chain shoots across the floorboards and goes taut. A dark shape takes to the corner, scuttling up its walls trying to go further than its shackles will allow. You take a torch and wave it into the darkness. There you see the prisoner. The old man shouts from the porch.%SPEECH_ON%You leave us alone! Go on now, you leave us alone!%SPEECH_OFF%There, shrinking away from your torch, is a goblin.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Why would you keep a goblin chained up here?",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Better to kill that thing now.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HurtBro.getImagePath());
				local injury = _event.m.HurtBro.addInjury(this.Const.Injury.PiercedArm);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.HurtBro.getName() + " suffers " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_25.png[/img]You take out your sword and step into the cabin. The old man calls out to you. All the threat and posturing is gone. He\'s almost manically pleading for you to not hurt the goblin. But you do just that, thrusting a blade through the greenskin\'s chest. It heaves against the metal, gripping it with its slimy, disgusting fingers. Its grip weakens as the light leaves its eyes. You draw out the blade and wipe the blood on your pants. As though grief renewed him with unseen power, the old man cries out and manages to wrestle to his feet. He draws a dagger and comes after you, but %randombrother% stops him with a dagger of his own, bedding the blade just beneath the man\'s breast. Blood spews over the hilt as his heart rapidly beats the last of its life. The old man\'s knees buckle and slides down, clutching at his killer\'s arms.%SPEECH_ON%Cruel creatures... cruel...%SPEECH_OFF%He collapses onto the floorboard. You tell the company to search the cabin and take what they can.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Rest in peace, hermit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local item = this.new("scripts/items/weapons/light_crossbow");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/weapons/dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/supplies/roots_and_berries_item");
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
			Text = "[img]gfx/ui/events/event_25.png[/img]Keeping the goblin in sight at all times, you ask the man why he has a greenskin tied up in his cabin. The hermit cries into the floorboards.%SPEECH_ON%He\'s a friend! My only friend!%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "You\'ve gone mad, hermit. Mad!",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Who chains up a friend?",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "That goblin will only get free and report to its true friends!",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_25.png[/img]You retreat from the cabin and crouch before the old man. He wriggles and begs.%SPEECH_ON%Please, don\'t kill \'im!%SPEECH_OFF%The man has gone mad and you tell him as much. He sobs into the porch floorboards, his breath powdering sawdust into the air. Finally, he eases his breathing and calms down.%SPEECH_ON%Yer right. I\'m not all there in the head. I found the goblin in a trap a few days ago and took him in, healed him. I\'ve no company in these parts. It gets lonely, you understand.%SPEECH_OFF%You take and reload the crossbow and then offer it to the old man.%SPEECH_ON%Can you do it?%SPEECH_OFF%The old man stares at the crossbow. He blinks a number of times and nods. Your sellswords let him up. He takes the crossbow and steps into the cabin. His aim is shaky and he\'s muttering apologies under his breath. The goblin is curled into a ball, shielding itself with its sickly hands.%SPEECH_ON%I\'m so sorry. So very sorry.%SPEECH_OFF%The old man readies the crossbow\'s release, slides his finger over the trigger, and then puts the bolt beneath his chin and fires. He buckles to the floor, the shot twanging as it slams into the ceiling, scant blood dripping off its feathers. You shake your head and step into the cabin and kill the goblin off yourself. Finished, you tell the men to search the hut and take what they can.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Goddammit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/light_crossbow");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/supplies/roots_and_berries_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_25.png[/img]Cautiously, you go back to the old man. You pick up the chain and rankle it, asking the man.%SPEECH_ON%A friend you keep shackled? If it were your true friend, you wouldn\'t need the chains, no?%SPEECH_OFF%The hermit shrugs.%SPEECH_ON%Yer right. Lemme go and I\'ll prove to you he\'s a real friend.%SPEECH_OFF%You let the man up and tell him to \'prove\' it. He pats the dust off his clothes and steps into the cabin. The chain slackens a bit as the goblin takes a step away from the fall. Crouching before the greenskin, the hermit extends a hand.%SPEECH_ON%Hey there, buddy.%SPEECH_OFF%As he reaches to unshackle the greenskin, the goblin growls and launches forward, sinking its teeth into the man\'s face. You rush into the cabin and kick the goblin back. It lands against the corner, flesh and blood hanging from its lips. %randombrother% stabs a sword through the creature\'s face. The old man cries out, his face a visage of gore.%SPEECH_ON%You were right, I knew it true, but my heart... it\'s in so much pain.%SPEECH_OFF%Getting a better look, you now see a seeping crimson chasm where his nose should be. As the hermit crawls into a ball, he points across the cabin.%SPEECH_ON%Beneath the floorboards there, where the dust is unsettled. I\'ve no use for it anymore.%SPEECH_OFF%You nod and tell %randombrother% to fix the man up. The rest of the company starts ripping out the floorboards to look beneath the crawlspace. After getting what they need, you tell the men it\'s time to leave. The hermit returns to his rocking chair and takes a seat. He\'s got his hands face up on his knees, blood running down the lengths of the fingers, and more blood dripping from a wound that is sure to fester. You can hear the blood choking him on every breath.%SPEECH_ON%I should\'ve hidden away. That\'s what I always do. Why didn\'t I hide?%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Take it easy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getMedicine() >= 2)
				{
					this.World.Assets.addMedicine(-2);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_medicine.png",
						text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-2[/color] Medical Supplies."
					});
				}

				local r = this.Math.rand(1, 4);
				local item;

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/named/named_axe");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/named/named_spear");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/helmets/named/wolf_helmet");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/armor/named/black_leather_armor");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_25.png[/img]You back out of the cabin and yell at the man.%SPEECH_ON%What in the old hells do you think you\'re doing? If that thing gets loose, it will run to the nearest greenskin encampment and bring their wrath upon this land!%SPEECH_OFF%The old man nods toward the chain.%SPEECH_ON%My very good friend is very safe, stranger, you shouldn\'t worry. You know nothing about who he is or his character!%SPEECH_OFF%You knock down the man with a punch and crouch low so he hears you good and proper.%SPEECH_ON%That thing is not your friend. It is a danger.%SPEECH_OFF%You nod to %randombrother% who promptly enters the cabin and kills the goblin with a quick stab. The old man cries out, blood already clotting between his teeth like crimson rinds.%SPEECH_ON%But why? What did he ever do to you? Have you no honor, killing a creature such as he?%SPEECH_OFF%You shake your head at the madman and order the rest of the company to fan out and search for items. When they\'re done, you leave the old man to his cabin and dead friend.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "What a madman.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/light_crossbow");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/knife");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/supplies/roots_and_berries_item");
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
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.HurtBro = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hurtbro",
			this.m.HurtBro.getName()
		]);
	}

	function onClear()
	{
		this.m.HurtBro = null;
	}

});


this.creepy_guy_event <- this.inherit("scripts/events/event", {
	m = {
		Thief = null,
		Minstrel = null,
		Butcher = null,
		Killer = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.creepy_guy";
		this.m.Title = "A %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]While walking the streets of %townname%, you come upon a crowd standing around a hanged man. He must have been of some notoriety: the folks are muscling one another to try and get a turn to cut a toe or finger off as a sort of hanging-heirloom. An old man is quickly elbowed out of the mob. He turns to you, voice raspy, his bony fingers tented like sickly ribs.%SPEECH_ON%Ahh, sellsword are ye? O\'course, I can smell your business, the purchases ye have made. Say, would you do a bit of work for me? I need a number of that dead man\'s fingers and toes. It\'s for m\'work, ye shall see. I\'ll give you five hundred crowns in return for it.%SPEECH_OFF%You ask why he needs that particular man\'s appendages. The crooning, shoulder-cowed man laughs, a heckle if there ever was one.%SPEECH_ON%Aye, good question. The man earned his walk to the hangman\'s noose with a penchant for violence and an unerring strength to see his desires through. The toes and fingers of a simpleton won\'t do. I need a man of uncinched cruelty, and the only one I see right now is swinging by that there rope. So, what say ye? Five hundred crowns, remember?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Alright, I\'ll go and find them.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 30 || this.World.Assets.getMoney() <= 1000)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "Our thief, %thief%, seems to have an idea.",
						function getResult( _event )
						{
							return "Thief";
						}

					});
				}

				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "%minstrel% is grinning ear to ear...",
						function getResult( _event )
						{
							return "Minstrel";
						}

					});
				}

				if (_event.m.Butcher != null)
				{
					this.Options.push({
						Text = "It seems that %butcher% wants to give you a hand.",
						function getResult( _event )
						{
							return "Butcher";
						}

					});
				}

				this.Options.push({
					Text = "We\'d rather not get involved.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_43.png[/img]You muscle your way into the crowd, looking for fingers and toes or bloodied pockets. One man\'s got a good, lumpy sag in his pocket. You drive him into a corner and shake him down with a dagger to his throat.\n\n After him, you see a woman with a sickly grin on her face prancing along the cobbled stones. That\'s a scornful wench if you\'ve ever seen one. Pulling her aside, you quickly find the a finger and a toe in the linens of her frock. She lies and says they\'re just cooking ingredients. You tell her if that\'s the case then you\'ll report her to the guards for cannibalism. She gives them up.\n\n Returning the grossly extremities to the old man, you are promptly paid the five hundred crowns. He hardly even thanks you for your \'work\' before rushing away. He never did explain what, exactly, such things were for. You don\'t care. Five hundred crowns is five hundred crowns.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Easy as it gets.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_43.png[/img]You agree to the creepy old man\'s task and start going through the crowd, keeping a careful eye out for toes and fingers being where they shouldn\'t be, or lumpy pockets freshly and redly wet. It doesn\'t take long: a woman prances down the road, the front of her frock bubbling rather curiously with whatever she\'s got in the pocket. You pull her into an alleyway, drawing a dagger to keep her quiet. A finger and toe are found. As you go to take them, a man suddenly tackles you from behind. Crowns from your purse and the appendages go skittering across the cobblestones. A child takes one, a rat the other, where either runs off to is quickly obscured by a frenzy of peasants going after your coins. The man who tackled you loads up a punch.%SPEECH_ON%Sumbitch, you want her you gotta pay!%SPEECH_OFF%You cross your arms, block the strike, and twist your body to put him on the ground. He\'s about to say something else, but you momentarily replace his teeth with your knuckles and he goes quiet. Unfortunately, you won\'t be able to finish what you started and you\'ve lost a few coins in the process.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn it!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(200, 400);
				this.World.Assets.addMoney(-money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + money + "[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "Thief",
			Text = "[img]gfx/ui/events/event_43.png[/img]%thief% laughs.%SPEECH_ON%Hell, this\'ll be easy.%SPEECH_OFF%He goes off to the crowd and you lose sight of him in an instant. The old man chews on his gums for awhile before raising his voice.%SPEECH_ON%This feller, he is one to trust?%SPEECH_OFF%Before you can answer, %thief% emerges from behind the old man\'s shoulder and drops a bloody bandage into his palms. The creepy man unwraps the linens to discover freshly strewn extremities. The thief smugly smiles.%SPEECH_ON%Any thief worth his salt learns to pickpocket before anything else. I usually go after keys instead of toes, but a job is a job. Also \'picked\' some other things of interest here and there. Take a look.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				this.World.Assets.addMoney(500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Crowns"
					}
				];
				local initiative = this.Math.rand(2, 4);
				_event.m.Thief.getBaseProperties().Initiative += initiative;
				_event.m.Thief.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Thief.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] Initiative"
				});
				_event.m.Thief.improveMood(1.0, "Has used his unique talents to great success");

				if (_event.m.Thief.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Thief.getMoodState()],
						text = _event.m.Thief.getName() + this.Const.MoodStateEvent[_event.m.Thief.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Minstrel",
			Text = "[img]gfx/ui/events/event_92.png[/img]%minstrel% the minstrel grabs the old man by his shoulders.%SPEECH_ON%Say, what mighty muscles you seem to have, my burly friend. I shan\'t ask why you need the toes and fingers of that dead man...%SPEECH_OFF%The old man nods and says he\'d never tell anyway. The minstrel continues.%SPEECH_ON%...but if you want a good, strong, and violent man, then am I not looking at it? It\'s you, old man! Take yer own fingers and toes and go with them to complete the task - ahem, whatever weird shite that might be, ahem - and you\'ll find the \'reward\' you\'re after. You are the hero of this story, can\'t you see?%SPEECH_OFF%The old man spits and shakes his head.%SPEECH_ON%You take me for a fool, don\'t ya? Our business here is through! Get out of my way you sorry sellswords.%SPEECH_OFF%The old man leaves. You ask the minstrel what the hell he\'s doing. He shrugs and holds up a purse of crowns.%SPEECH_ON%Sleight of hand.%SPEECH_OFF%Nicely done. But you ask where your own purse is. %minstrel% raises another sack.%SPEECH_ON%Really, really good sleight of hand.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Very funny. Now hand it back.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.World.Assets.addMoney(500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Crowns"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]1000[/color] Crowns"
				});
				local initiative = this.Math.rand(2, 4);
				_event.m.Minstrel.getBaseProperties().Initiative += initiative;
				_event.m.Minstrel.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Minstrel.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] Initiative"
				});
				_event.m.Minstrel.improveMood(1.0, "Has used his unique talents to great success");

				if (_event.m.Minstrel.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Minstrel.getMoodState()],
						text = _event.m.Minstrel.getName() + this.Const.MoodStateEvent[_event.m.Minstrel.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Butcher",
			Text = "[img]gfx/ui/events/event_19.png[/img]%butcher% the butcher spits and says he\'ll do it. You tell him that he\'s not exactly the thieving sort. He shakes his head.%SPEECH_ON%Naw. I mean I\'ll give him a finger. Just one, but it\'ll be a doozy and worth its weight in gold as far as this old fart\'s concerned. As far as you\'re concerned, captain, I want half the reward.%SPEECH_OFF%The creepy stranger nods as a smile crackles his dried, flaky skin.%SPEECH_ON%Yes... yes! A man who would do this would certainly fit the profile of the ingredients I need. Do it. Do it!%SPEECH_OFF%Before you can even agree to this, the butcher grabs a tong hanging off a nearby wall, leverages it atop an anvil, wedges a finger between the pincers, and presses his knee to the handle, promptly severing a finger all in one go. He wraps the hand before giving up the extremity to the stranger.%SPEECH_ON%There you have it: one especially cruel man\'s finger.%SPEECH_OFF%The stranger grabs it as though it were the key to the world. \'Marvelous!\', you think he says, but it\'s hard to hear as he hurriedly gives you some crowns and runs off. It\'s actually more than you originally agreed to. The butcher has certainly \'earned\' his half and you hand it over.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Insane.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				this.World.Assets.addMoney(250);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]250[/color] Crowns"
				});
				_event.m.Butcher.improveMood(1.0, "Has made a tidy sum selling one of his fingers");

				if (_event.m.Butcher.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Butcher.getMoodState()],
						text = _event.m.Butcher.getName() + this.Const.MoodStateEvent[_event.m.Butcher.getMoodState()]
					});
				}

				local injury = _event.m.Butcher.addInjury([
					{
						ID = "injury.missing_finger",
						Threshold = 0.0,
						Script = "injury_permanent/missing_finger_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Butcher.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Butcher.getBaseProperties().Bravery += 3;
				_event.m.Butcher.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Butcher.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] Détermination"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() >= 2 && t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_thief = [];
		local candidates_minstrel = [];
		local candidates_butcher = [];
		local candidates_killer = [];

		foreach( b in brothers )
		{
			if (b.getBackground().getID() == "background.thief")
			{
				candidates_thief.push(b);
			}
			else if (b.getBackground().getID() == "background.minstrel")
			{
				candidates_minstrel.push(b);
			}
			else if (b.getBackground().getID() == "background.butcher" && !b.getSkills().hasSkill("injury.missing_finger"))
			{
				candidates_butcher.push(b);
			}
			else if (b.getBackground().getID() == "background.killer_on_the_run")
			{
				candidates_killer.push(b);
			}
		}

		if (candidates_thief.len() != 0)
		{
			this.m.Thief = candidates_thief[this.Math.rand(0, candidates_thief.len() - 1)];
		}

		if (candidates_minstrel.len() != 0)
		{
			this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		}

		if (candidates_butcher.len() != 0)
		{
			this.m.Butcher = candidates_butcher[this.Math.rand(0, candidates_butcher.len() - 1)];
		}

		if (candidates_killer.len() != 0)
		{
			this.m.Killer = candidates_killer[this.Math.rand(0, candidates_killer.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getName() : ""
		]);
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getName() : ""
		]);
		_vars.push([
			"butcher",
			this.m.Butcher != null ? this.m.Butcher.getName() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Thief = null;
		this.m.Minstrel = null;
		this.m.Butcher = null;
		this.m.Killer = null;
		this.m.Town = null;
	}

});


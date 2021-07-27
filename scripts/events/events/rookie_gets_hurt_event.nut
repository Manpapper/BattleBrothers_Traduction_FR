this.rookie_gets_hurt_event <- this.inherit("scripts/events/event", {
	m = {
		Rookie = null
	},
	function create()
	{
		this.m.ID = "event.rookie_gets_hurt";
		this.m.Title = "After battle...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_22.png[/img]After the battle is over, you find %noncombat% on his knees, his body swaying back and forth as he nurses a wound. You hear muffled cries in between all-too-loud moans. Approaching, you ask the man if he is alright. He shakes his head and explains that this was his first taste of real, vicious combat. It was not what he expected and isn\'t sure if he can continue.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Suck it up!",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 30 ? "B" : "C";
					}

				},
				{
					Text = "There is not a soul out here who isn\'t scared.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "D" : "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_22.png[/img]You tell the mercenary to man up. When he pauses, stifling a cry, you tell him again. This time, he brings a leg out and plants a foot, steadying himself. With true grit, he manages to get himself standing again. His shirt is bloodslaked, his face covered in mud and crimson and other viscera battle makes of the living. But his eyes show a sign of resolve they did not before. He nods at you before walking back to join the rest of the men.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Iron sharpens iron.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.improveMood(1.0, "Had an encouraging talk");
				_event.m.Rookie.getBaseProperties().Bravery += 3;
				_event.m.Rookie.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Rookie.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] Détermination"
					}
				];

				if (_event.m.Rookie.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_22.png[/img]Unfortunately, telling the man to \'suck it up\' gets him nowhere. He turns to you, face covered in the blood and gore of battle, but before any words can come out his lip quivers and keels over again. You ask the man if he wishes to be cut from the company, but he shakes his head no. He\'ll get better, he explains. You nod and walk off, but there\'s little doubt that this poor show of resolve has hurt the man\'s pride.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "He will be steeled by combat, or he will be killed by it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.getBaseProperties().Bravery -= 3;
				_event.m.Rookie.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Rookie.getName() + " loses [color=" + this.Const.UI.Color.NegativeEventValue + "]-3[/color] Détermination"
					}
				];
				_event.m.Rookie.worsenMood(1.0, "Lost confidence in himself");

				if (_event.m.Rookie.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_22.png[/img]The man looks around him, at the bodies, at the land, at the sky. He nods and gets to his feet. Before heading back to camp, he thanks you for your words.%SPEECH_ON%Thankee, captain. I\'ll do a better job of hiding my fears.%SPEECH_OFF%You nod back with a terse smile before putting your fist to your chest.%SPEECH_ON%Bottle it all up right here and don\'t let anybody else see it. Half of any battle is convincing your opponent that you\'re crazier than they are. Being fearless is impossible, but faking it for a time is not.%SPEECH_OFF%The man nods again and heads back to camp with his head held a little bit higher.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'s the spirit!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.improveMood(1.0, "Had an encouraging talk");
				_event.m.Rookie.getBaseProperties().Bravery += 2;
				_event.m.Rookie.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Rookie.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Détermination"
					}
				];

				if (_event.m.Rookie.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_22.png[/img]The man turns to you, tears cutting through the crusts of blood on his cheeks. He shakes his head and asks how is it that he\'s the only one out here crying. You shrug and ask the man if he wishes to leave the company. He shakes his head again.%SPEECH_ON%I\'ll get better. I just.. I just need some time to do it, that\'s all.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "He will be steeled by combat, or he will be killed by it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Rookie.getImagePath());
				_event.m.Rookie.worsenMood(1.0, "Realized what being a mercenary means");

				if (_event.m.Rookie.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Rookie.getMoodState()],
						text = _event.m.Rookie.getName() + this.Const.MoodStateEvent[_event.m.Rookie.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 10.0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() == 1 && !bro.getBackground().getID() == "background.slave" && !bro.getBackground().isCombatBackground() && bro.getPlaceInFormation() <= 17 && bro.getLifetimeStats().Battles >= 1)
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Rookie = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noncombat",
			this.m.Rookie.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Rookie = null;
	}

});


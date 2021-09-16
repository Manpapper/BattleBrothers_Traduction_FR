this.undead_outro_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_outro";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]You take a nap.\n\n Blackness. Darkness. All what a dream should be, save for one small fact: you know you\'re in it. Standing in the void like a lost thought. A voice breaks over you, dripping down from all sides as though you were in the very mouth that produced it.%SPEECH_ON%Why did you forsake us, Emperor?%SPEECH_OFF%You spin about, or at least think you do, for there is nothing around with which to base even the faintest of movements.%SPEECH_ON%You promised me, don\'t you remember? You said it would be okay if it all fell apart. You said you had a plan, that you had made a deal with that ugly, ugly man. What happened?%SPEECH_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "I was not the chosen one.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Rest easy, my love. There is nothing to fear in death.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Who was the ugly man?",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]You raise your voice.%SPEECH_ON%I am not the chosen one.%SPEECH_OFF%Before the admission even clear the air, she begins sobbing. Her words burst through the weeps like hiccupped honesty.%SPEECH_ON%I-I know... I did not wish to admit it, but I know. The Empire dies with us. Sy\'leth daef\'nya, my Emperor.%SPEECH_OFF%\'Emperor\' echoes, fainter by the repeat, until you are left with darkness and silence.",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Wake up!",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]At first, you say nothing. She begins to cry. You hear the tears, each drop reverberating all around you.%SPEECH_ON%Are you there, my Emperor?%SPEECH_OFF%You clear your throat and answer.%SPEECH_ON%Yes, I am. The Empire will not rise again. We must go. There is nothing to fear in Death.%SPEECH_OFF%The woman weeps, but slowly steadies herself.%SPEECH_ON%I am not afraid. On the other side, ish\'nyarh ishe\'yarn, my Emperor.%SPEECH_OFF%As her words fade from the black, and perhaps your mind, all you are left with is silence.",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Wake up!",
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
			Text = "[img]gfx/ui/events/event_33.png[/img]You turn about.%SPEECH_ON%Who is the ugly man?%SPEECH_OFF%The woman\'s voice stutters in shock.%SPEECH_ON%You, you don\'t remember?%SPEECH_OFF%Clearing your throat, you feign the honesty of lost memories.%SPEECH_ON%I remember nothing, my love.%SPEECH_OFF%A great sigh falls over the darkness. You can feel its frustration. She talks with exasperation.%SPEECH_ON%I knew we should not have trusted him... The ugly man came to us in the night when our child was born still. He said if he could take our blood, as well as that of our dead child, he would ensure that the Empire would never die, us its eternal rulers. But... it had a cost.%SPEECH_OFF%You quickly figure it out and respond.%SPEECH_ON%He made you barren.%SPEECH_OFF%The woman sobs.%SPEECH_ON%We should have never trusted him! I will have that ugly man! Have no doubt, kearem su\'llah. I will treat him to eternity, an eternity of pain and suffering!%SPEECH_OFF%The once black void glows red, flashing a world of crimson, ferocity in color. You throw a hand up, shielding your eyes. She screams, piercing your ears until all you hear is a harsh ringing.",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Wake up!",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]You wake. A rough wind bends the tent, curling the leather and rolling tides across the ceiling. Faint candlelight flicks and dashes darkness and light all the same. %dude% is standing there, watching you, shadows crossing back and forth across his chest. He shifts on his feet, an uneasy look on his face.%SPEECH_ON%Who were you talking to?%SPEECH_OFF%Rolling out of bed, you put your boots to the ground, wanting to be sure of this reality before you dare parlay with it. Dirt rustles and crunches beneath your feet. You answer.%SPEECH_ON%I\'m not sure. I think... I think the invasion is over.%SPEECH_OFF%The mercenary nods and turns a hand to the tent\'s entrance.%SPEECH_ON%Aye, that\'s why I\'m here. A noble messenger arrived just a minute ago. He says the undead have ceased erupting from the ground. The scribes believe it is over. Are you alright, sir?%SPEECH_OFF%You rub your head. Is it time to retire? What can you make of this world now that you know what you do? It is either go live out the rest of your days in peace, or say damn it all and command the %companyname% to further glory.\n\n%OOC%You\'ve won! Battle Brothers is designed for replayability and for campaigns to be played until you\'ve beaten one or two late game crises. Starting a new campaign will allow you to try out different things in a different world.\n\nYou can also choose to continue your campaign for as long as you want. Just be aware that campaigns are not intended to last forever and you\'re likely to run out of challenges eventually.%OOC_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "The %companyname% needs their commander!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "It\'s time to retire from mercenary life. (End Campaign)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.updateAchievement("BaneOfTheUndead", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.Undead;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_undead_end"))
		{
			local brothers = this.World.getPlayerRoster().getAll();
			local highest_hiretime = -9000.0;
			local highest_hiretime_bro;

			foreach( bro in brothers )
			{
				if (bro.getHireTime() > highest_hiretime)
				{
					highest_hiretime = bro.getHireTime();
					highest_hiretime_bro = bro;
				}
			}

			this.m.Dude = highest_hiretime_bro;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_undead_end");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});


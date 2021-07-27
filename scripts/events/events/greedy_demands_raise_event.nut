this.greedy_demands_raise_event <- this.inherit("scripts/events/event", {
	m = {
		Greedy = null
	},
	function create()
	{
		this.m.ID = "event.greedy_demands_raise";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%bro% enters your tent with a scroll at his side. He unfurls it, revealing a literal list of things he has killed. You inquire as to what he wants you to do with that. The scroll is tossed onto your desk and he responds.%SPEECH_ON%Compensate me. Higher pay starting right now. %newpay% crowns a day.%SPEECH_OFF% | %bro% apparently wants higher pay, %newpay% crowns a day instead of the %oldpay% crowns he earns now, stating that he has slain a great deal of enemies while in the company of the %companyname%.\n\nKilling lots of things is a good bargaining chip when that\'s the business you are in, you\'ll give him that much. | It appears that %bro% wants more pay on account of killing lots of, well, everything on your behalf. You tell him that none of it was on your personal behalf, just that you simply paid him to do it. He nods.%SPEECH_ON%Right. And now I want more pay. %newpay% crowns a day.%SPEECH_OFF% | %bro% feels as though his services for the company aren\'t being well compensated. He\'s asking for more pay, %newpay% crowns a day instead of the %oldpay% crowns he earns now, on account of how good he is at that whole mercenary business. | %bro% is demanding you pay him more, %newpay% crowns a day instead of the %oldpay% crowns he earned so far, now that he has proven himself more than capable of fighting for the %companyname%.\n\nHe\'s got a bit of a point, though you\'re not sure you\'re ready to hand the crowns over quite yet.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Very well, you\'ve earned it.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "You\'ll get what we agreed upon and no more.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Greedy.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]{You agree to %bro%\'s terms. He\'s very unsurprisingly happy about it and you get on with your day. | %bro%\'s demands aren\'t too much and you are happy to fork him a few extra crowns a day. He gives you a handshake. It\'s firm, but not too firm. | %bro% wavers on his feet as he readies for your answer. You tell him to relax as you\'ve agreed to his terms. He finally sighs in relief.%SPEECH_ON%Thank you, sir. I thought I might have to, I dunno.%SPEECH_OFF%You raise an eyebrow.%SPEECH_ON%I hope that wasn\'t a threat.%SPEECH_OFF%The man awkwardly laughs and shakes his head.%SPEECH_ON%No, no of course not!%SPEECH_OFF% | You tell %bro% you\'ll increase his pay under one condition: he do a little dance.%SPEECH_ON%A victory dance?%SPEECH_OFF%You shrug.%SPEECH_ON%Any dance.%SPEECH_OFF%He raises his arms and swings them a little. You burst into laughter.%SPEECH_ON%No number of kills would amount to whatever that was.%SPEECH_OFF%The man snickers.%SPEECH_ON%Thank you, sir.%SPEECH_OFF% | You agree to give %bro% a higher wage.%SPEECH_ON%It would be my privilege.%SPEECH_OFF%The man raises an eyebrow.%SPEECH_ON%Spare me the ceremony. I\'m here to kill, let\'s not dance around it.%SPEECH_OFF%You nod.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'ve earned it!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Greedy.getImagePath());
				_event.m.Greedy.getBaseProperties().DailyWage += 8;
				_event.m.Greedy.improveMood(2.0, "Received a pay raise");
				_event.m.Greedy.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Greedy.getName() + " is now paid " + _event.m.Greedy.getDailyCost() + " crowns a day"
				});

				if (_event.m.Greedy.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Greedy.getMoodState()],
						text = _event.m.Greedy.getName() + this.Const.MoodStateEvent[_event.m.Greedy.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]{You decline %bro%\'s request. He purses his lips, wrings his hands, then nods, turns and leaves. The silence is a bit harsh, but the message well received: he ain\'t a happy man. | Declining %bro%\'s request leads to a sudden outburst.%SPEECH_ON%Well, fark this shit. I\'ll still fight fer ya, but don\'t expect the best out of me!%SPEECH_OFF%You nod, but tell him he\'d be dead without putting forth his best, so you\'ll get what you want regardless. | %bro% winces when you decline the suggestion.%SPEECH_ON%Alright then, I see how this place is run. In we go, out we go. No matter to you, right? We\'re just the pawns you use to get what you want. That\'s fine. That\'s absolutely fine.%SPEECH_OFF%He turns and leaves. You get the feeling it is not at all \'fine.\' | You tell %bro% that you do not agree with his estimations of how much he should get paid. He responds with a few swears with an estimated volume of \'loud.\' When he\'s finished, he nods.%SPEECH_ON%But that\'s alright. I get the business. And I\'m sure you understand that you get why I must look after the business that is myself, too.%SPEECH_OFF% | %bro% presses for more pay, but you put your foot down.%SPEECH_ON%You\'ll get what we agreed upon, no more.%SPEECH_OFF%He nods and then slowly back out of the tent.%SPEECH_ON%As you say, sir.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We can\'t always get what we want.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Greedy.getImagePath());
				_event.m.Greedy.worsenMood(this.Math.rand(2, 3), "Was denied a pay raise");

				if (_event.m.Greedy.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Greedy.getMoodState()],
						text = _event.m.Greedy.getName() + this.Const.MoodStateEvent[_event.m.Greedy.getMoodState()]
					});

					if (_event.m.Greedy.getMoodState() == this.Const.MoodState.Angry)
					{
						if (!_event.m.Greedy.getSkills().hasSkill("trait.loyal") && !_event.m.Greedy.getSkills().hasSkill("trait.disloyal"))
						{
							local trait = this.new("scripts/skills/traits/disloyal_trait");
							_event.m.Greedy.getSkills().add(trait);
							this.List.push({
								id = 10,
								icon = trait.getIcon(),
								text = _event.m.Greedy.getName() + " gets disloyal"
							});
						}
						else if (_event.m.Greedy.getSkills().hasSkill("trait.loyal"))
						{
							_event.m.Greedy.getSkills().removeByID("trait.loyal");
							this.List.push({
								id = 10,
								icon = "ui/traits/trait_icon_39.png",
								text = _event.m.Greedy.getName() + " is no longer loyal"
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Retinue.hasFollower("follower.paymaster"))
		{
			return;
		}

		if (this.World.Assets.getMoney() < 4000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 8)
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.greedy"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Greedy = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bro",
			this.m.Greedy.getName()
		]);
		_vars.push([
			"oldpay",
			this.m.Greedy.getDailyCost()
		]);
		_vars.push([
			"newpay",
			this.m.Greedy.getDailyCost() + 8
		]);
	}

	function onClear()
	{
		this.m.Greedy = null;
	}

});


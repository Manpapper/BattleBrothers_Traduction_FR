this.noble_more_pay_lowborn_event <- this.inherit("scripts/events/event", {
	m = {
		Noble = null,
		Lowborn = null
	},
	function create()
	{
		this.m.ID = "event.noble_more_pay_lowborn";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img] %noble% suddenly enters your tent. He\'s attired in armor and his weapon is at his side. It almost seems as if he dressed up for this occasion, and he does indeed stand upright and proper. You ask what it is he wants, and he speaks with his head held high and his eyes looking straight ahead.%SPEECH_ON%It has come to my attention that %lowborn% is paid more than I. While I\'ve no issue with the man personally, I do want to point out that he is a man with no birthright to anything but his own two feet. You can\'t possibly have a lowborn being paid more than a man of the purple. We noblemen deserve more.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I will see to it you are paid no less than him.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We pay by veterancy and skill, not bloodline.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "How about we lower your pay instead?",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]You don\'t necessarily agree with him, but at the same time you can see that denying this request may cause some heretofore unseen problems. With a few dashes of your quill pen across the roster scroll, you assign %noble% a higher salary and tell him to expect a heavier purse come next payday. The man finally looks at you and bows from the waist.%SPEECH_ON%You\'ve made the good and proper decision.%SPEECH_OFF%He turns on his heels and marches back out with as much gusto as he did coming in.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Equal pay will keep the peace.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.Noble.getBaseProperties().DailyWage += this.Math.max(0, _event.m.Lowborn.getDailyCost() - _event.m.Noble.getDailyCost());
				_event.m.Noble.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Noble.getName() + " is now paid " + _event.m.Noble.getDailyCost() + " crowns a day"
				});
				_event.m.Noble.improveMood(1.0, "Got a pay raise");

				if (_event.m.Noble.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]You tell the man to look at you. He slowly shifts his eyes to yours. Having his attention, you explain how it is around here.%SPEECH_ON%I pay on seniority and veterancy, not who you were before you signed the dotted line. You could be a goatfarmer for all I care, if you can swing a sword you\'ll get paid, and if you can swing it better than the next man then I\'ll be damned, you\'ll be getting paid more than the next man! Anything in that you don\'t understand?%SPEECH_OFF%%noble%\'s jowls quiver as he bottles a sudden spurt of rage. He speaks through clenched teeth.%SPEECH_ON%No, sir.%SPEECH_OFF%With a flick of a wrist, you tell him to get out of your sight. He leaves in a hurry, his upright stance falling into a seething slouch.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "If you want to see more crowns, earn them.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.Noble.worsenMood(2.0, "Was denied satisfaction over a lowborn");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]You stand up out of your chair and yell at the man to look at you. He does as told and so you explain what is going to happen.%SPEECH_ON%%lowborn% made it through this world by dragging himself out of the mud. You were born with a silver spoon, but this isn\'t where you were born now is it? So from today consider your pay effectively lowered. You want the right to a higher salary? Earn it.%SPEECH_OFF%The noble\'s stance falters. He opens his mouth, but you quickly raise your hand.%SPEECH_ON%No more words. Get out of my sight.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get out!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.Noble.getBaseProperties().DailyWage -= _event.m.Noble.getDailyCost() / 2;
				_event.m.Noble.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Noble.getName() + " is now paid " + _event.m.Noble.getDailyCost() + " crowns a day"
				});
				_event.m.Noble.worsenMood(2.0, "Was humiliated by the captain");
				_event.m.Noble.worsenMood(2.0, "Was denied satisfaction over a lowborn");
				_event.m.Noble.worsenMood(2.0, "Got a pay cut");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}

				if (!_event.m.Noble.getSkills().hasSkill("trait.greedy"))
				{
					local trait = this.new("scripts/skills/traits/greedy_trait");
					_event.m.Noble.getSkills().add(trait);
					this.List.push({
						id = 10,
						icon = trait.getIcon(),
						text = _event.m.Noble.getName() + " gets greedy"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 500)
		{
			return;
		}

		if (this.World.Retinue.hasFollower("follower.paymaster"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local lowestPay = 1000;
		local lowestNoble;

		foreach( bro in brothers )
		{
			if (bro.getDailyCost() < lowestPay && bro.getBackground().isNoble())
			{
				lowestNoble = bro;
				lowestPay = bro.getDailyCost();
			}
		}

		if (lowestNoble == null)
		{
			return;
		}

		local lowborn_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getDailyCost() > lowestPay && bro.getBackground().isLowborn())
			{
				lowborn_candidates.push(bro);
			}
		}

		if (lowborn_candidates.len() == 0)
		{
			return;
		}

		this.m.Noble = lowestNoble;
		this.m.Lowborn = lowborn_candidates[this.Math.rand(0, lowborn_candidates.len() - 1)];
		this.m.Score = 7 + (lowestNoble.getSkills().hasSkill("trait.greedy") ? 9 : 0);
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noble",
			this.m.Noble.getName()
		]);
		_vars.push([
			"lowborn",
			this.m.Lowborn.getName()
		]);
	}

	function onClear()
	{
		this.m.Noble = null;
		this.m.Lowborn = null;
	}

});


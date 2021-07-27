this.more_action_event <- this.inherit("scripts/events/event", {
	m = {
		Bro1 = null,
		Bro2 = null
	},
	function create()
	{
		this.m.ID = "event.more_action";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]You\'re sitting in your tent enjoying the peace and quiet which, like some increasable quantity, seemingly has accrued in such a way that each day is more enjoyable than the last. Suddenly, %combatbro1% and %combatbro2% enter. They demand you have a talk. You oblige, fanning your hands across your table and inviting them to sit. They do and quickly state that it has been a long while since they last saw combat. Taken aback, you quite literally lean back in your chair.%SPEECH_ON%Isn\'t that a good thing?%SPEECH_OFF%%combatbro1% shakes his head and cuts a determined hand through the air.%SPEECH_ON%No. We were hired to fight, and fighting is what we want. We want battles, we want carnage, and we want the glory that comes with both.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll see battle soon - you have my word!",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "You\'re getting paid either way - and now you even get to live and spend the crowns.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]You nod.%SPEECH_ON%I understand. You are two battle-earnest men. You even remind me of myself though, with your skills, I can assure you that only I come out looking better by such a comparison. You are fine warriors, but is it not true that you will be paid the same regardless of this battle or that? Why be so worried about battles? They will come. I\'ve not paid you to sit. I\'ve paid you to be ready to stand.%SPEECH_OFF%The men exchange a glance and then shrug and nod. They stand up in unison.%SPEECH_ON%You are right, sir. And, when the time comes, we will be ready to stand and fight for you!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good to have the men burn for battle like this.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]You try and explain to the men that, regardless of whether or not they\'re fighting, they are going to be getting paid. But money is not their primary concern. They truly wish to fight and you words have little effect on their rather earnest attitudes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "But...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isCombatBackground() && this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(1.0, "Lost confidence in your leadership");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]You stand up and flatten your knuckles on the table.%SPEECH_ON%Is it fighting you want?%SPEECH_OFF%The men exchange a glance then quickly nod at you.%SPEECH_ON%Then it is fighting you shall have! Fear not the sheathed sword, mercenaries. I will find you a good battle in due time!%SPEECH_OFF%Rising to their feet, the men shake your hand. They thank you as they leave the tent. Once they\'re gone, you go to your maps and look for the nearest ass to kick.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good to have the men burn for battle like this.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isCombatBackground() && this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Was promised a battle soon");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.trader")
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() < this.World.getTime().SecondsPerDay * 10)
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
			if (bro.getBackground().isCombatBackground() && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Bro1 = candidates[0];
		this.m.Bro2 = candidates[1];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"combatbro1",
			this.m.Bro1.getName()
		]);
		_vars.push([
			"combatbro2",
			this.m.Bro2.getName()
		]);
	}

	function onClear()
	{
		this.m.Bro1 = null;
		this.m.Bro2 = null;
	}

});


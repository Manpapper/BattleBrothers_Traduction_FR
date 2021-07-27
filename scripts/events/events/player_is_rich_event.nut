this.player_is_rich_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.player_is_rich_event";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_04.png[/img]Over time, you\'ve come to acquire a great deal of money. While you keep the war chest under lock and key, you can\'t help but notice a few brothers have gotten a bit greedier over the time they\'ve spent in your company. Now you hear rumors of the men demanding higher pay.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aye, it\'s fine time you all get a raise.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "You all signed the dotted line and get paid according to it.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_04.png[/img]Preempting any sort of mutiny or raise requests, you announce that the group shall have a company-wide raise. Three crowns a day for everyone. As it turns out, the men are quite fond of this move and cheer your name with a huzzah!",
			Image = "",
			List = [],
			Options = [
				{
					Text = "You\'ve earned it, boys!",
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
					if (bro.getSkills().hasSkill("trait.player") || bro.getFlags().get("IsPlayerCharacter") || bro.getBackground().getID() == "background.slave")
					{
						continue;
					}

					bro.getBaseProperties().DailyWage += 4;
					bro.improveMood(2.0, "Got a pay raise");

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

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Before anyone gets any ideas, you step up before the whole company and announce that there will be no raises. As far as you are concerned, every man present signed the contract. Any prospect of earning more pay shall be done by experience only, and that is only done by doing what sellswords do best: kill.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'s how it works with the %companyname%.",
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
					if (bro.getSkills().hasSkill("trait.player") || bro.getFlags().get("IsPlayerCharacter") || bro.getBackground().getID() == "background.slave")
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.greedy"))
					{
						bro.worsenMood(2.0, "Was denied a pay raise");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (!bro.getBackground().isExcluded("trait.greedy"))
					{
						if (this.Math.rand(1, 100) <= 20)
						{
							local trait = this.new("scripts/skills/traits/greedy_trait");
							bro.getSkills().add(trait);
							this.List.push({
								id = 10,
								icon = trait.getIcon(),
								text = bro.getName() + " gets greedy"
							});
						}
						else
						{
							bro.worsenMood(1.0, "Was denied a pay raise");

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
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() <= 30000)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() < 5)
		{
			return;
		}

		if (this.World.Retinue.hasFollower("follower.paymaster"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local numBros = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.slave")
			{
				numBros = ++numBros;
			}
		}

		if (numBros < 2)
		{
			return;
		}

		this.m.Score = (this.World.Assets.getMoney() - 30000) * 0.0005;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


this.player_is_rich_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.player_is_rich_event";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_04.png[/img]Au fil du temps, vous avez acquis une grande quantité d\'argent. Bien que vous gardiez le trésor de guerre sous clé, vous ne pouvez vous empêcher de remarquer que quelques frères d\'armes sont devenus un peu plus avides au fil du temps qu\'ils ont passé dans votre compagnie. Vous entendez maintenant des rumeurs selon lesquelles les hommes exigent un salaire plus élevé.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Oui, il est grand temps que vous soyez tous augmentés.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Vous avez tous signé la ligne pointillée et êtes payés en fonction de celle-ci.",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]Anticipant toute sorte de mutinerie ou de demande d\'augmentation, vous annoncez que le groupe aura une augmentation pour toute la compagnie. Trois couronnes par jour pour tout le monde. Il s\'avère que les hommes apprécient beaucoup cette initiative et acclament votre nom avec un hourra !",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Vous l\'avez mérité, les gars !",
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
					bro.improveMood(2.0, "A eu une augmentation de salaire");

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
			Text = "[img]gfx/ui/events/event_05.png[/img]Avant que quiconque ne se fasse des idées, vous vous présentez devant toute la compagnie et annoncez qu\'il n\'y aura pas d\'augmentation. En ce qui vous concerne, chaque homme présent a signé le contrat. Toute perspective de gagner plus de salaire ne se fera que par l\'expérience, et cela ne se fait qu\'en faisant ce que les mercenaires font le mieux : tuer.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est comme ça que ça marche avec %companyname%.",
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
						bro.worsenMood(2.0, "On lui a refusé une augmentation de salaire");

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
								text = bro.getName() + " devient cupide"
							});
						}
						else
						{
							bro.worsenMood(1.0, "On lui a refusé une augmentation de salaire");

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


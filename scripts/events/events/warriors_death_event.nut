this.warriors_death_event <- this.inherit("scripts/events/event", {
	m = {
		Gravedigger = null,
		Casualty = null
	},
	function create()
	{
		this.m.ID = "event.warriors_death";
		this.m.Title = "After the battle...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_87.png[/img]The battle over, you look around at the destruction it had wrought. %deadbrother% is on his back, staring blankly at the skies with glazed eyes. Other brothers litter the battleground. They are ill-shaped, ragged, fractured and fragmented and soon fermented. It is a collectively cruel end. And now the flies are gathering, dotting the dead like skittering moles. They copulate on cold skin with shameless abandon and set about burrowing the next brood in the still-warm gore. %randombrother% walks up and asks what it is you wish to do with the bodies.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Just leave them there.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Let us honor the dead!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Gravedigger != null)
				{
					this.Options.push({
						Text = "Let %gravedigger% the gravedigger handle it.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_87.png[/img]You take a look up at the skies. Crows and archcrows circle overhead. They squall and sqwuak and bicker amongst one another as they await your departure. Sheathing your sword, you nod at the battleground.%SPEECH_ON%Loot the bodies. Leave the dead to the birds.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tis a hungry world, after all.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local r;
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local chance = 25;

					if (bro.getBackground().getID() == "background.monk")
					{
						chance = 100;
					}
					else if (bro.getSkills().hasSkill("trait.fainthearted") || bro.getSkills().hasSkill("trait.craven") || bro.getSkills().hasSkill("trait.dastard") || bro.getSkills().hasSkill("trait.pessimist") || bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.insecure") || bro.getSkills().hasSkill("trait.disloyal"))
					{
						chance = 75;
					}
					else if (bro.getSkills().hasSkill("trait.cocky") || bro.getSkills().hasSkill("trait.loyal") || bro.getSkills().hasSkill("trait.optimist") || bro.getSkills().hasSkill("trait.deathwish"))
					{
						chance = 10;
					}

					if (this.Math.rand(1, 100) > r)
					{
						continue;
					}

					bro.worsenMood(0.5, "Dismayed that fallen comrades were left to rot on the battlefield");

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

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_28.png[/img]You nod toward the dead.%SPEECH_ON%Those were some fine men and fine men get a fine burial. We\'ll honor them just as we should: a good hole to sleep in, crowns which they can spend in the next world, and a feast to celebrate. I\'d expect the same to be done for me!%SPEECH_OFF%The surviving men cheer and begin preparations.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Now we can leave them to find their final rest.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local r;
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local chance = 50;

					if (this.Math.rand(1, 100) > r)
					{
						continue;
					}

					bro.improveMood(0.5, "Glad to see fallen comrades receive a fine farewell");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}

				this.World.Assets.addMoney(-60);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]60[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_28.png[/img]You assign the duty of burials to %gravedigger%, a man well-practiced for this particular trade. It doesn\'t take him long to shovel perfectly squared holes into the ground. He wraps the bodies in linens before carefully placing them into their final rests. When it\'s all said and done, the graves lay across the ground as though they were an earthly fenceline knocked astray. Each mound of dirt has a stake before it with the dead brother\'s name carved into the wood. %gravedigger% stands his shovel and tents his hands on the handle. He nods at his work.%SPEECH_ON%They\'re in deep.%SPEECH_OFF%The man spits.%SPEECH_ON%Only thing after \'em now be the worms. Hope that don\'t bother ya - but anywhere a man goes once he\'s dead there be a mouth in need of new feed. Lest you burn the bodies, I s\'pose, but they say even then the spirits have their licks. Snortin\' smoke is a spirit\'s spice or some such thing.%SPEECH_OFF%Picking up his shovel, the gravedigger turns and leaves as though both his work and words were but dreams upon dreams.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well... may they rest in peace.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gravedigger.getImagePath());
				local r;
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local chance = 75;

					if (this.Math.rand(1, 100) > r)
					{
						continue;
					}

					bro.improveMood(0.5, "Glad to see fallen comrades receive a fine farewell");

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
	}

	function onUpdateScore()
	{
		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 6.0)
		{
			return;
		}

		local fallen = [];
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 3)
		{
			return;
		}

		local f0;
		local f1;

		foreach( f in fallen )
		{
			if (f.Expendable)
			{
				continue;
			}

			if (f0 == null)
			{
				f0 = f;
			}
			else if (f1 == null)
			{
				f1 = f;
			}
			else
			{
				break;
			}
		}

		if (f0 == null || f1 == null)
		{
			return;
		}

		if (f0.Time < this.World.getTime().Days || f1.Time < this.World.getTime().Days)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_gravedigger = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gravedigger")
			{
				candidates_gravedigger.push(bro);
			}
		}

		this.m.Casualty = f0.Name;

		if (candidates_gravedigger.len() != 0)
		{
			this.m.Gravedigger = candidates_gravedigger[this.Math.rand(0, candidates_gravedigger.len() - 1)];
		}

		this.m.Score = 500;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gravedigger",
			this.m.Gravedigger != null ? this.m.Gravedigger.getNameOnly() : ""
		]);
		_vars.push([
			"deadbrother",
			this.m.Casualty
		]);
	}

	function onClear()
	{
		this.m.Gravedigger = null;
		this.m.Casualty = null;
	}

});


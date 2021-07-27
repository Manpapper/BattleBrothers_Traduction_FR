this.lend_men_to_build_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.lend_men_to_build";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]While approaching %townname%, a local man waves you down. He\'s standing beside the skeleton of what appears to be a mill. Exasperated, he explains that his laborers didn\'t show up today and he needs to finish the mill before a local baron arrives. If he doesn\'t finish it, the baron might not ever give him another contract. You do have a few former laborers in the company. Perhaps they can be used to help the man?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You build, we kill. Find someone else.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Alright, I can spare a man or few.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_79.png[/img]You agree to lend a few of the %companyname%\'s finest to the project. They fall back into their old roles like a glove, quickly bandying about to collect resources, hammering, bricking, dooring? Whatever it is to put a door in, they do it and quickly. When it\'s all said and done, the local man comes to you grinning ear-to-ear. He hands a satchel over.%SPEECH_ON%You\'ve earned this, good sir! And more, you\'ve earned my word - I shall spread your benevolence whenever I can!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Don\'t get too used to this kind of work, men.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationFavor, "You lend some men to help build a mill");
				this.World.Assets.addMoney(150);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]150[/color] Crowns"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " is exhausted"
							});
						}

						if (this.Math.rand(1, 100) <= 50)
						{
							bro.improveMood(0.5, "Helped build a mill");

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
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_79.png[/img]You agree to help the man. Unfortunately, it appears as though he didn\'t plan things out too well. The rooftop collapses the second one of your \'laborers\' steps foot on it, sending the man through a sinkhole of shingles. Another man hammers a nail into place only for the wooden support to splinter right in two, catching him in the face with shards of wood. Loose bricks find freedom, wet mud has men slipping, and all manner of workplace hazards ends the whole project in disaster.\n\n The local man apologizes profusely in between biting his nails and wondering how he\'s going to deal with the baron. Snapping his fingers, he exclaims that he\'ll just pay him the crowns.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Those crowns belong to us!",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Good luck with the baron, then.",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]As the man\'s mind drifts off into a satisfactory conclusion of his problem, you snap your fingers to bring him back down to cruel reality.%SPEECH_ON%Those crowns belong to us, peasant. That was the deal.%SPEECH_OFF%The man\'s jowls flip and flop as he shakes his head.%SPEECH_ON%But the mill... it\'s not even finished!%SPEECH_OFF%You shrug.%SPEECH_ON%Not our problem. Now hand it over, before I make you our problem.%SPEECH_OFF%Nodding solemnly, the man obeys and gives you his satchel of crowns.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Better luck next time.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(-this.Const.World.Assets.RelationFavor, "You pressed hard an important citizen to get paid for helping build a mill");
				this.World.Assets.addMoney(200);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]200[/color] Crowns"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " is exhausted"
							});
						}

						if (this.Math.rand(1, 100) <= 50)
						{
							bro.improveMood(0.5, "Helped build a mill");

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
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_79.png[/img]For a brief moment, you see an image of yourself running the squinty-eyed man through with your sword. It\'d really wake him up to the reality of the world, but instead you give him a break. The laborers who took part in the disaster of a project aren\'t too happy. Hopefully, the lessons learned will steel them anyway.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Godspeed.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationFavor, "You lend some men to help build a mill");
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					local id = bro.getBackground().getID();

					if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
					{
						if (this.Math.rand(1, 100) <= 33)
						{
							local effect = this.new("scripts/skills/effects_world/exhausted_effect");
							bro.getSkills().add(effect);
							this.List.push({
								id = 10,
								icon = effect.getIcon(),
								text = bro.getName() + " is exhausted"
							});
						}

						if (this.Math.rand(1, 100) <= 33)
						{
							bro.worsenMood(1.0, "Helped build a mill without getting paid");

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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() > 3000)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
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
		local candidates = [];

		foreach( bro in brothers )
		{
			local id = bro.getBackground().getID();

			if (id == "background.daytaler" || id == "background.mason" || id == "background.lumberjack" || id == "background.miller" || id == "background.farmhand" || id == "background.gravedigger")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});


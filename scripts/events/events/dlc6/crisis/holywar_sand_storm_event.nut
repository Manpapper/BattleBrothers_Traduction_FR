this.holywar_sand_storm_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.holywar_sand_storm";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_161.png[/img]{You come across a troop of men half-buried in sand. Northerners caught in a sandstorm over night. They\'re writhing in pain, the ones alive at least. Some have had their flesh rent from bone, and others are already being picked at by scorpions and buzzards. It seems some have killed themselves. Not one of the souls can be saved, they\'re just clinging on to the end.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Kill them with dignity.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Leave them to the sands.",
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
			Text = "[img]gfx/ui/events/event_161.png[/img]{Drawing your sword, you ask the men if they will accept the dignity of a swift death by your steel. They\'re too parched and starved to speak, but a few nod. One dies before he can even answer. You go to each, crouch, wish them well, and push the sword in. The skin cracks beneath the blade, and the dying men are briefly revivified by the piercing pain, and then they are relinquished from this world. A few in the company have varying opinions about this matter.\n\nYou have the sellsword pick up what things they can, though much of the equipment has been laid to waste by the fury of the desert.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Better they don\'t suffer any longer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(10, 20);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Tools and Supplies."
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						continue;
					}

					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(1.0, "Approved of your decision to end the suffering of fellow northerners");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(0.75, "Disliked that you ended the suffering of northern invaders");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_161.png[/img]{You order the sellswords to strip the dying men of any useful gear. The crusaders can only mumble and groan as they are stripped of arms and armor. Their naked bodies are left to the burning sands, and as you depart with whatever scraps of useful gear the animals of the waste already begin to move in and feed. Mixed feelings run through the %companyname% about this decision, but ultimately contentions or support alike stay quiet.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The Gilder has judged them.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local amount = this.Math.rand(10, 20);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Tools and Supplies."
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						continue;
					}

					if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(1.0, "Disliked that you left fellow northerners to suffer a slow death");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(0.75, "Approved of your decision to leave northern invaders judged by the Gilder");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 7)
			{
				return;
			}
		}

		this.m.Score = 10;
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


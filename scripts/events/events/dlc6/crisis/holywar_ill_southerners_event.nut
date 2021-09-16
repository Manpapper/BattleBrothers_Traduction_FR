this.holywar_ill_southerners_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.holywar_ill_southerners";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_71.png[/img]{You come across a homestead and think to pass it but all of a sudden the door swings open and a man falls out, legs scissoring across the porch until he falls flat in the front yard. Drawing your sword, you investigate him. Turning him over reveals a green and purple face, a mouth caked with vomit and dried blood, and hair falling out of his head. You leave the body and enter the homestead where you find more men like him. They\'re all southerners and seem to have come down with some northern illness that they are perhaps uninitiated to. Judging by the slovenly state of their equipment, they\'ve been holed up here for quite some time.\n\n One of the southerners reaches out to you with a decrepit hand.%SPEECH_ON%Please, send us to the Gilder. The light of this world is no more.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let us end them with dignity",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "May the flies feast upon your decrepit flesh.",
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
			Text = "[img]gfx/ui/events/event_71.png[/img]{The southerners are killed with dignity, or at least as much dignity a sword can afford. Of course, you kill them at length, not daring to lay a hand on their diseased bodies. After each is laid to rest, you take a look around the homestead. To your luck, and probably because the material was rubbing their skins raw, the sickly had lain some equipment off to the side. You have the brothers scrub it clean and take it with you onto the road. While leaving, there\'s some grousing about how maybe these men deserved worse, but others are quite fine with the mercy killings.}",
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

					if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(1.0, "Approved of your decision to end the suffering of fellow Gilded");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(0.75, "Disliked that you ended the suffering of southern invaders");

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
			Text = "[img]gfx/ui/events/event_71.png[/img]{Some of the southerners\' gear has been taken off and placed about the room. You have the sellswords take these and scrub them clean. Going to the front door, you light a torch and tell them the Gilder shall be seeing them in his true self real soon. The soldiers beg for mercy, a writhing mass of silhouettes crawling toward you, groaning in weakness and fear. You close the door and set the rooftop alight before pitching the torch through a window.\n\nYou\'ve taught your men well to not take it personal on these sorts of decisions, but you suspect some in the %companyname% might not care for this one.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "They have no place invading the north.",
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

					if (bro.getEthnicity() == 1 && this.Math.rand(1, 100) <= 66)
					{
						bro.worsenMood(1.0, "Disliked that you left fellow Gilded to suffer a slow death");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 0 && this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(0.75, "Approved of your decision to leave southern invaders to die");

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

		if (currentTile.Type == this.Const.World.TerrainType.Desert || currentTile.Type == this.Const.World.TerrainType.Steppe || currentTile.TacticalType == this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local closest = 9000;

		foreach( t in towns )
		{
			local d = t.getTile().getDistanceTo(currentTile);

			if (d < closest)
			{
				closest = d;
			}
		}

		if (closest < 7 || closest > 20)
		{
			return;
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


this.holywar_outro_south_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_outro_south";
		this.m.Title = "During camp...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_84.png[/img]{You recall the followers of the Gilder to once be united in their pursuit of leveling the old gods. Some misplaced notion that, were they to satisfy their God enough, He would put his powerful eye upon all enemies of His faithful and obliterate them. Instead, the Gilded find their resolve greatly tested: they have lost the holy war. Cities and towns have been burned, holy totems desecrated, and sacred grounds looted.\n\n Crowds of people listlessly shift about in the streets, wailing now and again, not with purpose, but as though they\'ve lost all language to articulate the pain they must now endure. On occasion, a body will plummet from above, or you find the guards pulling corpses out of the well only for an onlooker to pitch herself in. A few prostrate themselves before golden relics, letting themselves cook in the sun struck glare of the shiny emblems, the grief stricken crawling beneath the simmering reflections until their skins turn to crust and their throats choke on their own flesh, and as the sun comes and goes, bodies lay in the wake of its stare. As for the %companyname%, you\'ve put yourself to one side or the other, and regardless of winners or losers, you made a small fortune. For the future you need not wish to have the opportunity again, either: if there\'s one thing you know about a man of faith it\'s that defeat is only but one strike upon the hardening iron. With all that you\'ve achieved, perhaps now would be a good time to put up the sword and enjoy your crowns?\n\n%OOC%You\'ve won! Battle Brothers is designed for replayability and for campaigns to be played until you\'ve beaten one or two late game crises. Starting a new campaign will allow you to try out different things in a different world.\n\nYou can also choose to continue your campaign for as long as you want. Just be aware that campaigns are not intended to last forever and you\'re likely to run out of challenges eventually.%OOC_OFF%}",
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
				this.World.Combat.abortAll();
				this.World.FactionManager.makeEveryoneFriendlyToPlayer();
				this.World.FactionManager.createAlliances();
				this.updateAchievement("CulturalMisunderstanding", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.HolyWar;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_84.png[/img]{Faith placed in the Gilder has been rewarded: the holy war is over, and the southerners stand victorious. The Vizier, councilmen, and clergy alike are found in the streets, each riding great wagons which, in place of wheels, are lofted on the backs of slaves. Northern slaves, particularly, indebted to the Gilder for their crimes. You can hardly see the men, just their legs black in shadow as though a procession of swaying beetles was on the go. The wealthy and profligate men take great chalices and hurl what looks like golden water upon the cheering faithful. You yourself lean into one of these splashes, but find it is merely just tinted water.\n\n While the faux fortunes served only to slake your thirst, the very real war between the followers of the old gods and the Gilded themselves served to fill the %companyname%\'s treasury. As a Crownling, you\'ll never find the respect of bared heads and bowed bodies, nor the prostrations of peasants, nor the gleam of gold too heavy for any one man to carry. That is the reality for you, but that won\'t stop the company from being ready the next time the pious wanna have a squabble over righteousness. Or perhaps now would be a good time to put up the sword and enjoy your crowns?\n\n%OOC%You\'ve won! Battle Brothers is designed for replayability and for campaigns to be played until you\'ve beaten one or two late game crises. Starting a new campaign will allow you to try out different things in a different world.\n\nYou can also choose to continue your campaign for as long as you want. Just be aware that campaigns are not intended to last forever and you\'re likely to run out of challenges eventually.%OOC_OFF%}",
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
				this.World.Combat.abortAll();
				this.World.FactionManager.makeEveryoneFriendlyToPlayer();
				this.World.FactionManager.createAlliances();
				this.updateAchievement("CulturalMisunderstanding", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.HolyWar;
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.SquareCoords.Y > this.World.getMapSize().Y * 0.18)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Contracts.getActiveContract() != null)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_holywar_end"))
		{
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_holywar_end");
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local north = 0;
		local south = 0;
		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0)
				{
					if (this.World.FactionManager.getFaction(v.getFaction()).getType() == this.Const.FactionType.NobleHouse)
					{
						north = ++north;
					}
					else
					{
						south = ++south;
					}
				}
			}
		}

		if (north >= south)
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onClear()
	{
	}

});


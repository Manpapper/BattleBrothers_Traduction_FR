this.holywar_outro_north_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_outro_north";
		this.m.Title = "During camp...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_84.png[/img]{Faith placed in the old gods has been rewarded: the holy war is over, and the northerners stand victorious. Songs fill the air as crowds move as a mob, fists pumping, flags flying, becoming briefly uniform in a shared sense of piety. You stand by the wayside, your shoulders already wreathed in adornments, beads, necklaces, things of no material value, and yet they bear some weight which the wearer can only find by looking into the eyes of those who hand them out.\n\n Of course, certain dignities go unrealized in the celebration: the bodies of the defeated are put on display, thrashed in ways meant to satisfy the old gods that are watching, and holy totems of the Gilder are mocked, desecrated, and ultimately burned. And it is indeed certain that not a joyful soul will recognize you as a force in this cheerful culmination. You\'ve merely slipped right into the background once more, sellsword, crownling, interloper. But the %companyname% made a small fortune in the religious endeavors. Despite the smiles and laughs, you know that strife such as this is buried in the mind, not in the earth, and someday someone or something will come and resurrect it, and there the company will await another glorious payday. Or perhaps now would be a good time to put up the sword and enjoy your crowns?\n\n%OOC%You\'ve won! Battle Brothers is designed for replayability and for campaigns to be played until you\'ve beaten one or two late game crises. Starting a new campaign will allow you to try out different things in a different world.\n\nYou can also choose to continue your campaign for as long as you want. Just be aware that campaigns are not intended to last forever and you\'re likely to run out of challenges eventually.%OOC_OFF%}",
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
			Text = "[img]gfx/ui/events/event_84.png[/img]{Uttering their name is to draw words from tongue to intemporal: the old gods. They are beyond time, and their vast number invoke awe over specificity. Endearing as this is to any listener familiar or not with the faith, it also brings greater weight to any defeat of those who follow these unbranded beings. The crusades are over, and the northerners have lost.\n\n You watch as the northerners try and explain it to one another how it came to pass. It was not a terrestrial defeat here, nor even a victory by the southerners - no, this was punishment. Northerners have grazed far from the holy lands, they have meadowed in the material world, priories and churches dot the realm, empty and hollow for far too long. Naturally, inquiries about the nature of this southern \'Gilder\' have also come, but they quickly pass. To even dwell on Him is to invite doubt, and right now doubt is as dangerous as any poison. Of course, the %companyname% stays at a distance. Sellswords that you are, you put faith in your sword and in the purse, and both got their dues in this war. The only philosophizing you\'ll be doing in the days to come is pondering just how soon the north and south will resume stating their differences. Perhaps now would be a good time to put up the sword and enjoy your crowns?\n\n%OOC%You\'ve won! Battle Brothers is designed for replayability and for campaigns to be played until you\'ve beaten one or two late game crises. Starting a new campaign will allow you to try out different things in a different world.\n\nYou can also choose to continue your campaign for as long as you want. Just be aware that campaigns are not intended to last forever and you\'re likely to run out of challenges eventually.%OOC_OFF%}",
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

		if (currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.18)
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


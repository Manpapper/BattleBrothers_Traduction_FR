this.civilwar_outro_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_outro";
		this.m.Title = "During camp...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_96.png[/img]You\'re in your tent when %dude% makes an entrance. He speaks bluntly.%SPEECH_ON%Nobles be talking. Big fancy tent setup yonder and they\'re in there.%SPEECH_OFF%Putting your quill pen down, you respond.%SPEECH_ON%Just talking?%SPEECH_OFF%The mercenary shrugs.%SPEECH_ON%It\'s quiet. So they\'re either talking, or killing one another real quiet like.%SPEECH_OFF%You get up and step outside. A brisk air hits you, and on it is the scent of spices and flavors. Looking upwind, you spot the tent. Cooks and chefs are hurrying about with orders of food and other makings. Servants carry platters of meats, vegetables, and fruits. An opulent tent, black with gold embroidering, houses the nobles. Bannermen stand outside. They take no part in the festivities. They\'re mostly playing cards while occasionally glancing at one another. Some are bandaged with blood splotched linens. One man stands on crutches with a haggard, half-cocked knee. You ask %dude% what the news is. He nods toward the scene.%SPEECH_ON%Well, they rolled up about an hour ago while you were checking the maps. We didn\'t want to bother ya, but, well, they seemed intent on staying so, you know.%SPEECH_OFF%You get a good look at the noble tent. Through its opening, you can see the faint glisten of crowned heads passing back and forth. %dude% spits and asks.%SPEECH_ON%Well, who do you think won the war?%SPEECH_OFF%You hock a loogie, spit, and shake your head.%SPEECH_ON%Who gives a shite?%SPEECH_OFF%All that matters to you is that peace means fewer contracts. Perhaps now would be a good time to put up the sword and enjoy your crowns? Or maybe say to hell with all that sentimental crap and just keep pressing forward, leading the company to even greater things?\n\n%OOC%You\'ve won! Battle Brothers is designed for replayability and for campaigns to be played until you\'ve beaten one or two late game crises. Starting a new campaign will allow you to try out different things in a different world.\n\nYou can also choose to continue your campaign for as long as you want. Just be aware that campaigns are not intended to last forever and you\'re likely to run out of challenges eventually.%OOC_OFF%",
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
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Combat.abortAll();
				this.World.FactionManager.makeEveryoneFriendlyToPlayer();
				this.World.FactionManager.createAlliances();
				this.updateAchievement("Kingmaker", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.CivilWar;
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
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_civilwar_end"))
		{
			local brothers = this.World.getPlayerRoster().getAll();
			local highest_hiretime = -9000.0;
			local highest_hiretime_bro;

			foreach( bro in brothers )
			{
				if (bro.getHireTime() > highest_hiretime)
				{
					highest_hiretime = bro.getHireTime();
					highest_hiretime_bro = bro;
				}
			}

			this.m.Dude = highest_hiretime_bro;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_civilwar_end");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"randomnoblehouse",
			nobles[this.Math.rand(0, nobles.len() - 1)].getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});


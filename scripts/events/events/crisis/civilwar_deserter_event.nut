this.civilwar_deserter_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_deserter";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_02.png[/img]{While on the road you come across two soldiers of %noblehouse%\'s army and they\'re stringing up what it appears to be one of their own. The man\'s head is put through a noose, but upon seeing you he calls out.%SPEECH_ON%They wanted me to kill children! This is what I get for not following orders?%SPEECH_OFF%%randombrother% looks at you with a \'maybe we can do something\' face. | You find two men of %noblehouse%\'s army stringing up a man who has been blindfolded. Curious, you ask what his crime was. One of the executioners laughs.%SPEECH_ON%He was ordered to burn a small village and refused. You don\'t refuse the nobility, lest this happen.%SPEECH_OFF%The blindfolded man spits.%SPEECH_ON%To the hells with you all. I\'ll at least have my dignity and honor to the end.%SPEECH_OFF% | To the side of the path you see a man slinging a rope around a tree branch. A second man pushes a blindfolded prisoner forward, slipping the noose about his neck. The executioners see you and put their hands up.%SPEECH_ON%Step back, sellswords. This man is to be executed under the orders of %noblehouse%. Interfere, and you will be dealt with in a similar fashion.%SPEECH_OFF%The prisoner barks out.%SPEECH_ON%They wanted me to murder women and children. This is the price I pay for ignoring such orders, but at least I will leave this horrid world with my honor intact.%SPEECH_OFF% | The path opens to a shackled man sitting in the grass while two men angrily string a rope along a tree branch. They test it with a few good pulls before nodding and putting a barrel beneath it, presumably for the prisoner to stand on. The prisoner sees you and calls out.%SPEECH_ON%Sellswords, save me! All I did was refuse to burn a temple to the ground!%SPEECH_OFF%One of the executioners kicks the man.%SPEECH_ON%That temple was housing rebels, rebels that killed our lieutenant, you fool! You deserve this fate more than anyone. If %noblehouse% is to win this war, we cannot have rats such as you in our midst.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Free that man!",
					function getResult( _event )
					{
						local roster = this.World.getTemporaryRoster();
						_event.m.Dude = roster.create("scripts/entity/tactical/player");
						_event.m.Dude.setStartValuesEx([
							"deserter_background"
						]);
						_event.m.Dude.setTitle("the Honorable");
						_event.m.Dude.getBackground().m.RawDescription = "Once a soldier of a noble army, %name% was almost hanged for refusing orders, until rescued by you and the %companyname%.";
						_event.m.Dude.getBackground().buildDescription(true);

						if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
						{
							_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
						}

						if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
						{
							_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
						}

						if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
						{
							_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
						}

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "This is none of our business.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_02.png[/img]{You order the executioners to let the man go. They laugh and draw out their swords, but that\'s about the last thing they do as the %companyname% descends upon them with liberating fury, hacking the two soldiers down in mere seconds. The prisoner thanks you and, in return for his rescue, offers to serve you in battle. | You won\'t stand for such an execution and order the men of the %companyname% to intervene. They quickly draw their weapons and descend upon the soldiers, slaughtering them in but a moment. The freed prisoner falls to his feet before you.%SPEECH_ON%Please, let me fight in your ranks, it is the least I can offer!%SPEECH_OFF% | You order the %companyname% to save the prisoner. It is an odd series of sights and sounds to see men who thought themselves the executioners be so suddenly put to the blade. Such turns of fortune bring out wild, womanly-like screaming. Your men would have made it quick had they not tried to run, but a man who is intent on saving himself oft dies the slowest. The prisoner, meanwhile, falls to your feet and offers allegiance.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Welcome to the %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Go home to your family, soldier.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationUnitKilled);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_02.png[/img]{You order the man rescued. One of the soldiers draws his sword and is immediately cut down for his misplaced confidence. The other soldier, seemingly sharper of mind, has already run off. No doubt he\'ll tell %noblehouse% of what you have done here. The rescued prisoner comes to you personally, going to one knee as he bows.%SPEECH_ON%Thank you, sellsword. You have my blade for this day until my last.%SPEECH_OFF% | In your mind, it is unlikely that the two executioners would abandon their noble flags to join you. But it is quite probable that the prisoner would fight on your side, were you to free him. So you order his rescue. One of the soldiers draws his sword and pledges allegiance to the %noblehouse%. It\'s the last thing he does. The other soldier flees. Maybe you could have recruited him, but it\'s unlikely he\'ll come back given the prompt killing of his partner. Most likely he will tell his superiors of your actions here.\n\n You go to the freed prisoner. He hurriedly bows and offers to fight for the %companyname%. | You order the soldiers to let the man go. One laughs and simply tightens the noose about his neck and starts to hang him. %randombrother% jumps forward and knocks an executioner to the ground. He beats his face in with a rock while the second soldier runs off. No doubt he\'ll tell his commanders what you\'ve done here.\n\n Freed, the prisoner comes to you personally and bows, offering allegiance in return for his rescue.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Welcome to the %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Go home to your family, soldier.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Killed one of their men");
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_02.png[/img]{Though you can\'t necessarily fault the man for ignoring his orders, the decision was his, not yours, just as his punishment will be his, and not yours. You order the %companyname% to keep marching. | You\'ve no reason to involve the %companyname% in the politics of the quarreling nobles. The prisoner nods, understandingly. He lifts his head high before they hang him straight. | The executioners glance at you, perhaps sensing that you might step in to absolutely ruin their day. Instead, you tell the prisoner that it was his choice that got him here. He nods solemnly. The executioners rush to hang him, lest this dangerous stranger crossing their path have a sudden change of heart.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "His war was not ours.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.deserter")
					{
						bro.worsenMood(0.75, "You didn\'t help a deserting lieutenant");

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
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Dude = null;
	}

});


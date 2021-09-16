this.goblin_city_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.goblin_city_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_119.png[/img]{%randombrother% shakes his head.%SPEECH_ON%May the old gods have mercy upon us for allowing such a sight.%SPEECH_OFF%The goblin city is sequestered between opposing mountains. Saying the goblins built their city around the mountains is like saying a soldier sheathed his sword in his enemy\'s chest. The gibbering greenskins didn\'t add to the terrain, they desecrated the place whole, putting mines where trees used to be, constructing a maze of rusted shanties and lean-tos, raising cultish totems and digging primitive sacrificial pits, piling unused timber as though the mutilation of the mountain was not truly finished without blatant waste.\n\n But beyond the goblin rubbish does stand a central core of the city, a number of towers unambiguously set apart from the riffraff. These are clearly ancient requisitions, the stonework being unlike anything you\'ve ever seen and surely beyond the greenskin\'s scope of construct. The goblins walking amongst the walls are upright and boastful as though invigorated by being allowed to stride such hallowed grounds. Nestled inside the fortress seem to be of some sort of higher nobility, well dressed goblins with servants mucking about, which means the same thing it does when it comes to humans: there\'s good loot to be had.\n\n A rare sight are the little ones running about. Families, if that\'s what the greenskins truly have, will mean that a fight here will be a vicious one. The little maggots will have more to protect than just their savageness and greed, and that which must extend itself beyond its own vices is also that which has been weakened.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What\'s the plan?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Let\'s leave for now.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsGoblinCityVisited", true);

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_119.png[/img]{After observing the city for a time, you know that you can\'t simply assault it head on. There are far too many to take on and with the numbers already on their side it is even likely the families of the goblins will partake in your slaughter, and you will have only enshrined the city whole with further experience in slaughtering humans. So you wait. And think. And then the man approaches.\n\n He\'s bound in light armor with a leafy hood used to camouflage the metal beneath and a multitude of swords clank from his hip and a spear yokes across his back one way and an axe the other and bandolier of potions chime as he comes to a halt. You can\'t see his face, much less his eyes, and he\'s dripping with the blood of recent action.%SPEECH_ON%Despite their cruelties and cruel appearance, the goblins are in a way a civilized group. They will respond to violence that is at its base nothing more than senseless savagery. If you wish to draw them out, then you must do as the orcs do. My plan was to slaughter as many as I could find in the fields, raiding parties, scouts, the like, but it is just as well that their encampments are destroyed in great number. Together, the carnage will be a pincer upon their fears, for they fear reckless orcs more than anything and will seek to preemptively snuff them out.%SPEECH_OFF%The man nods as though you\'ve already agreed to something.%SPEECH_ON%So choose, traveler, the manner in which you wish to have this city laid flat. Slaughter their raiding parties and scouts, or burn their forward posts? Whatever you do, I\'ll do the other, alone, and we shall meet here when the summary of our actions is obvious.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll slaughter their scouts and raiding parties.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "We\'ll take on the forward posts.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_119.png[/img]{You tell him that the %companyname% will slaughter the goblins in the fields. The man nods.%SPEECH_ON%Ah, traveler, that is a good choice. The disappearances of these parties will put a strain upon the greenskins\' beliefs. They\'re natural scouts and raiders, so when those in that ilk go missing it unnerves them to the core. The forward posts will retreat and spread rumors to this city and out shall come an expeditionary force. While you take them in the fields, I shall see to it that many of the encampments are destroyed. By my own experience, you need to destroy somewhere around %goblinkillcount% parties of them and that shall be sufficient.%SPEECH_OFF%He heads off, but you call out asking who he is, or if perhaps it would be a better idea to join together. He ignores you completely and walks away.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll return after %goblinkillcount% goblin parties have been destroyed.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsGoblinCityScouts", true);
				this.World.Flags.set("GoblinCityCount", 0);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_119.png[/img]{You tell the stranger that the %companyname% will pursue the destruction of the encampments. He nods.%SPEECH_ON%Excellent, traveler, excellent! The goblins send raiding parties frequently and when they come home to ashes they will return here, spread word of destruction, and be lead out. Very well. We have a plan and by my own experiences you need only march down around %goblinpostcount% encampments. You take their posts, I will take their parties.%SPEECH_OFF%He heads off, but you call out asking who he is, or if perhaps it would be a better idea to join together. He ignores you completely and walks away.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll return after five outposts have been razed.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsGoblinCityOutposts", true);
				this.World.Flags.set("GoblinCityCount", 0);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_119.png[/img]{You return to the city, but the stranger you met earlier is nowhere to be seen. However, what is seen is an enormous contingent of goblin forces marching out of their city. They\'re in lockstep and chittering loudly. Their leaders sit atop saddled wolves with their war banners tilting side to side as though it were a fleet set to sea. Goblin families stand perched at the gates. They\'re throwing handfuls of bones upon the marchers, and sometimes you see a dog or human limb get tossed down and whichever goblin catches it holds it up like a trophy and the surrounding troop cheers. It takes a full hour for the army to pass at which time the goblins at the gates recede back into the city and a few guards mill about.\n\nThere\'s still plenty yet to put up a good fight, but not enough to handle the %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prepare the attack.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().m.IsShowingDefenders = true;
						}

						this.World.Events.showCombatDialog(true, true, true);
						return 0;
					}

				},
				{
					Text = "Fall back for now.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_119.png[/img]{The goblin city remains guarded by a horde of the little greenskins. You recall that the %companyname% will have to destroy a couple more of their patrols and scouts to draw the army away from the city.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll return after %goblinkillcount% goblin parties have been destroyed.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_119.png[/img]{The goblin city remains guarded by a horde of the little greenskins. You recall that the %companyname% will have to destroy a couple more of their encampments and forward posts to draw the army away from the city.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll return after %goblinpostcount% outposts have been razed.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"goblinkillcount",
			"ten"
		]);
		_vars.push([
			"goblinpostcount",
			"five"
		]);
	}

	function onDetermineStartScreen()
	{
		if (!this.World.Flags.get("IsGoblinCityVisited"))
		{
			return "A";
		}
		else if (this.World.Flags.get("IsGoblinCityOutposts") && this.World.Flags.get("GoblinCityCount") >= 5 || this.World.Flags.get("IsGoblinCityScouts") && this.World.Flags.get("GoblinCityCount") >= 10)
		{
			return "E";
		}
		else if (this.World.Flags.get("IsGoblinCityScouts"))
		{
			return "F";
		}
		else if (this.World.Flags.get("IsGoblinCityOutposts"))
		{
			return "G";
		}
		else
		{
			return "A";
		}
	}

	function onClear()
	{
	}

});


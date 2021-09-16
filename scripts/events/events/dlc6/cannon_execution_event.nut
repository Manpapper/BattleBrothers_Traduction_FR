this.cannon_execution_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.cannon_execution";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_177.png[/img]{You come across a man in military garb with a pair of similarly dressed guards. Between them is a man with his arms and legs tied akimbo to a giant mortar, his torso facing into the barrel, his head resting atop its sights. He looks up at you with a side eye.%SPEECH_ON%Ah, traveler. I\'m in quite the predicament. You see, these fine, muted gentlemen wish to splash me across the sands using the greatest technical marvel of our age. Whilst I can see the benefit of avoiding the executioner\'s rusted sword, I must confess that to have my final moment be one of watching my own body parts bomb the desert creatures to be one of severe embarrassment. A fair penalty for some crimes, no doubt, but I am a mere thief.%SPEECH_OFF%The military executioner glances at you, but just as the thief said, he appears to be a mute. Or possibly deaf, as his role as mortarman might imply on its own.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What is your crime, exactly?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "This doesn\'t concern us.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_177.png[/img]{The executioner surprisingly answers, plugging one ear with a finger as he talks.%SPEECH_ON%Crownling, this does not concern you. Move along.%SPEECH_OFF%The thief tries to turn his head again.%SPEECH_ON%Ah, ah! He speaks! Wonderful. Let us hash this out like good gentlemen with sensibilities kind to but also ahead of our current era.%SPEECH_OFF%The executioner ignores the thief\'s articulate pleas.%SPEECH_ON%I shall make a deal for your neutrality, Crownling. When this thief is splashed across the desert, you may have whatever is inside of him for, you see, it is said that he carries a heart of gold.%SPEECH_OFF%The thief nervously speaks.%SPEECH_ON%That means something else where I\'m from.%SPEECH_OFF%You ask the executioner to explain. He states that the Gilder \'touches\' those who oppose Him, condemning and dooming the hated with insides made of gold. The condemnation is a level beyond being merely indebted. It sounds rather fantastical, even for you.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Carry on with the execution then.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "You need to stop this execution.",
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
			Text = "[img]gfx/ui/events/event_177.png[/img]{You\'re interested to see if what the executioner says is true and stand aside. The thief sighs.%SPEECH_ON%Well. Alright then. Just make sure that when they write about me, that this execution isn\'t canon. That\'s \'canon\' spelled with one-%SPEECH_OFF%The explosion disintegrates the man and the pulverizing force shunts a wave of sand clear of the mortar itself, expelling a cloud of dust and gore, swirling through the air like some storm of viscera, and a few moments later the body parts begin to pitter-patter about the ground. None of these bits and pieces are golden. In fact, most are charred black or vibrantly red, freshly bared to the world to see. The executioner wipes the gunpowder from his face.%SPEECH_ON%It appears we were wrong. The thief shall be compensated by the Gilder Himself, oh to be that lucky.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Guess that\'s that.",
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_177.png[/img]{You inform the guards and executioner that you\'ll be stopping the execution. They immediately stand back from the mortar. The executioner plugs his ear again.%SPEECH_ON%A stay of execution? Or did you say to start it?%SPEECH_OFF%The thief nervously laughs.%SPEECH_ON%Yes, Crownling, please clear that up for our friend here.%SPEECH_OFF%The matter is settled slowly and for all to hear. Surprisingly, the guards agree. They see you not as a random intervention, but as one sent from the Gilder Himself, for why else would you be there? The thief is cut free from the device and he is handed over to the company. He holds his hand out.%SPEECH_ON%All funny business aside, I\'ll fight for you, uh, hmmm... the %companyname%. Quaint. But I\'m no ordinary thief, I\'m a man of pride, and a man with a sense of duty, and a man with a sense of crowns!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the company, I suppose.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We saved your life. That doesn\'t mean you\'re welcome with us.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"thief_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Only by your timely intervention was %name% saved from execution by being shot at with a giant mortar. An eccentric thief, his latest failed attempt to burglarize a Vizier\'s palace was deemed a good reason to set a very clear deterrent for anyone else harboring similar plans.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head));
				_event.m.Dude.worsenMood(1.0, "Almost got executed by a technological marvel in spectacular fashion");
				this.Characters.push(_event.m.Dude.getImagePath());
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

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});


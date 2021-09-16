this.pirates_event <- this.inherit("scripts/events/event", {
	m = {
		Fisherman = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.pirates";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_157.png[/img]{You come across a line of men being marched in chains. Their leader remarks that they are a part of the \'indebted,\' but one of the men, clearly a northerner, yells out that they\'re merchant mariners who have been captured by pirates. The supposed manhunter at the head of this troop laughs.%SPEECH_ON%Don\'t believe his lies, traveler, those who are deeply indebted to the Gilder fear the long journey to redemption. He\'d rather die and face hellfire than trouble himself with salvation. Is there nothing more human than that?%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Let these men go free at once!",
					function getResult( _event )
					{
						return "B";
					}

				});

				if (_event.m.Fisherman != null)
				{
					this.Options.push({
						Text = "It looks like %fisherman% has something to say on the matter.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				if (this.World.Assets.getOrigin().getID() == "scenario.manhunters")
				{
					this.Options.push({
						Text = "Hand over the indebted to me and I will pursue their salvation accordingly.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "Be on your way then, manhunters.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_157.png[/img]{You draw your sword and demand the \'indebted\' be set free. The manhunter looks around, incredulous.%SPEECH_ON%Kind traveler, I am merely obeying the laws of the Gilder. These men have debts to pay, and hellfire awaits the ones who shall go unremitted.%SPEECH_OFF%Shaking your head, you tell him you won\'t repeat yourself. He sighs and goes about unshackling the men. Most immediately take off running, however one stays behind. But he\'s not there to join you, he stays with the manhunter, holding his wrists out.%SPEECH_ON%Please, let me into the Gilder\'s light.%SPEECH_OFF%Another man also stays behind, but mostly to convene with you. He announces himself with clear intentions: he\'ll join and fight for the %companyname%.%SPEECH_ON%If I\'ve debts to pay off, it\'s with you, sir.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I hope you know how to use a weapon.",
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
					Text = "You\'re free, but you\'ll have to find your way back home on your own.",
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
				this.World.Assets.addMoralReputation(2);
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"fisherman_background"
				]);
				_event.m.Dude.setTitle("the Sailor");
				_event.m.Dude.getBackground().m.RawDescription = "You rescued %name% from a life in slavery after he was taken by pirates operating out of the city states.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.0, "Got taken captive by manhunters");
				this.Characters.push(_event.m.Dude.getImagePath());
				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Heard rumors of you freeing indebted");
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_157.png[/img]{%fisherman% the fisherman steps forward.%SPEECH_ON%Wait, I know this man! He\'s not indebted to no one, we used to sail together many winters ago.%SPEECH_OFF%The sailor nods.%SPEECH_ON%Yes, yes that\'s right!%SPEECH_OFF%The manhunter looks over, then walks forward and frees the sailor.%SPEECH_ON%I am no stranger the circumstances and complexities of the Gilder and can see the machinations of his designs. No doubt he wanted these two to meet. Please, have the man, and his salvation shall be true.%SPEECH_OFF%The manhunter continues on with his train of captured men. One turns to you.%SPEECH_ON%Real shame we don\'t farkin\' know each other, yeah?%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome. I hope you know how to use a weapon.",
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
					Text = "You\'ll have to find your way back home on your own.",
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
				this.Characters.push(_event.m.Fisherman.getImagePath());
				this.World.Assets.addMoralReputation(2);
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"fisherman_background"
				]);
				_event.m.Dude.setTitle("the Sailor");
				_event.m.Dude.getBackground().m.RawDescription = "You rescued %name% from a life in slavery after he was taken by pirates operating out of the city states.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.0, "Got taken captive by manhunters");
				_event.m.Dude.improveMood(0.5, "Got saved from a life in slavery by " + _event.m.Fisherman.getName());
				_event.m.Fisherman.improveMood(2.0, "Saved " + _event.m.Dude.getName() + " from a life in slavery");
				this.Characters.push(_event.m.Dude.getImagePath());
				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Heard rumors of you freeing indebted");
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_157.png[/img]{You rattle a chain and bring a few of your indebted forward. Flexing your indebted-wrangling cred, you tell the manhunter that you\'ve experience in these matters and you can tell these unruly sailors will find a moment to ambush and kill him.%SPEECH_ON%Hand them over to me and I will pursue their salvation accordingly. Keep them in your stead, and the Gilder Himself will not be able to protect you from the evil which lies in their hearts.%SPEECH_OFF%The manhunter thinks for a time, then nods in agreement.%SPEECH_ON%You\'re right. This was a good haul, but the Gilder shall see my deeds have already been enough and my intents true. Take them for yourself and may the Gilder shine sublimity upon your life and theirs.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The Gilder is most benevolent to let you pay off your debt.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getPlayerRoster().add(_event.m.Fisherman);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Fisherman.onHired();
						_event.m.Dude = null;
						_event.m.Fisherman = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Dude.setTitle("the Sailor");
				_event.m.Dude.getBackground().m.RawDescription = "%name% was working the seas as a sailor when pirates of the city states boarded his vessel and took him as captives along with his crew. By some happenstance, he made his way into your care to work off his debt to the Gilder.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.0, "Got taken captive by manhunters");
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Fisherman = roster.create("scripts/entity/tactical/player");
				_event.m.Fisherman.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Fisherman.setTitle("the Mariner");
				_event.m.Fisherman.getBackground().m.RawDescription = "%name% was working the seas as a sailor when pirates of the city states boarded his vessel and took him as captives along with his crew. By some happenstance, he made his way into your care to work off his debt to the Gilder.";
				_event.m.Fisherman.getBackground().buildDescription(true);
				_event.m.Fisherman.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Fisherman.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Fisherman.worsenMood(2.0, "Got taken captive by manhunters");
				this.Characters.push(_event.m.Fisherman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_157.png[/img]{The manhunter bows briefly.%SPEECH_ON%May your road be ever gilded, traveler.%SPEECH_OFF%He continues on his way while the supposed sailor yell out that they\'re not even from these lands, that they don\'t know anything about this \'Gilder\' they\'re indebted to in the first place.}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "As yours.",
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

		if (this.World.Assets.getOrigin().getID() == "scenario.manhunters")
		{
			if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax() - 1)
			{
				return;
			}
		}
		else if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_fisherman = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.fisherman" && bro.getEthnicity() == 0)
			{
				candidates_fisherman.push(bro);
			}
		}

		if (candidates_fisherman.len() != 0)
		{
			this.m.Fisherman = candidates_fisherman[this.Math.rand(0, candidates_fisherman.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fisherman",
			this.m.Fisherman != null ? this.m.Fisherman.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Fisherman = null;
		this.m.Dude = null;
	}

});


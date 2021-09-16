this.manhunters_origin_capture_prisoner_event <- this.inherit("scripts/events/event", {
	m = {
		LastCombatID = 0,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.manhunters_origin_capture_prisoner";
		this.m.Title = "After the battle...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "Nobles",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | %SPEECH_ON%Slaving shit, do your worst.%SPEECH_OFF%Despite being the last man standing, the northerner\'s still got some fight in him. He may do well in the %companyname%. | You find the last man standing, hurt but alive. He\'s a northerner and would look good in chains. Perhaps fetch a solid price in the south, or serve as fodder on the frontlines? | The northern troop has been cut down to its last, a pale man who seems to not dwell long in defeat.%SPEECH_ON%Southern shits, your \'Gilder\' can suck my balls. C\'mon, give me a weapon, I\'ll show you how a northerner dies!%SPEECH_OFF%You can\'t help but like his gusto. Instead of serving worms in the grave, perhaps he could serve the company as one of the indebted?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take him as an indebted to the Gilder so that he may earn his salvation.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Lost a battle and was taken a captive");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
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
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Formerly a soldier loyal to noble lords, his company was slaughtered by your men and %name% was taken as an indebted. It didn\'t take much to break his spirit and force him to fight for you.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Civilians",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take him as an indebted to the Gilder so that he may earn his salvation.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Lost a battle and was taken a captive");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
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
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% was taken as an indebted after barely surviving a battle against your men. His spirit was broken and he was forced to fight for you, so that he may pay his debt to the Gilder.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Bandits",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | The lone bandit survivor yells out for the old gods as you weigh a chain in your hand, wondering how it will fit around his neck. | %SPEECH_ON%Is this the penalty for banditry?%SPEECH_OFF%The northerner asks as you weigh a chain in your hand. You\'re still not sure yet of how you\'ll handle him, but answer anyway.%SPEECH_ON%This isn\'t punitive at all, it\'s merely business.%SPEECH_OFF% | The bandit tries to hide, but as the last survivor he\'s about as easy to spot as a white rabbit on a bloodslaked battlefield. He yells out that the old gods wouldn\'t abide by men such as yourself. You shrug.%SPEECH_ON%The old gods aren\'t standing where I am, now are they?%SPEECH_OFF%And you hold out the chain, sizing it with his neck.%SPEECH_ON%But I wonder, how much would you give up, to swap spots with one of your gods, hm?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take him as an indebted to the Gilder so that he may earn his salvation.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Lost a battle and was taken a captive");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
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
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% was taken as an indebted after barely surviving a battle against your men. His spirit was broken and he was forced to fight for you, so that he may pay his debt to the Gilder.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Nomads",
			Text = "[img]gfx/ui/events/event_172.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | You hold the chain out to the nomad, sizing his head from a distance in the swing of its closed gate.%SPEECH_ON%Sometimes in the sands, a man may come across those he should not have trifled with. Sometimes he walks away.%SPEECH_OFF%You grasp the chain firmly.%SPEECH_ON%Sometimes he just walks.%SPEECH_OFF% | The sands shift and slide as the wounded nomad tries to escape. You easily put a boot on him and hold him down, your other hand sizing up his neck with the slave chain. | The nomad prays for forgiveness.%SPEECH_ON%By parting our shadows, the shine of the Gilder brighten the both of us!%SPEECH_OFF%You hold up a chain and tell him not every shadow is born a part of us.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take him as an indebted to the Gilder so that he may earn his salvation.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Lost a battle and was taken a captive");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
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
					"slave_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% was taken as an indebted after barely surviving a battle against your men. His spirit was broken and he was forced to fight for you, so that he may pay his debt to the Gilder.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CityState",
			Text = "[img]gfx/ui/events/event_172.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | %SPEECH_ON%The Gilder wouldn\'t have it.%SPEECH_OFF%He is the last of the southern troop, a wounded pitiful man begging for his life. You hold up the chain.%SPEECH_ON%Just because this is on you does not mean your path is shadowed, fellow traveler. Just means mine is a little bit brighter.%SPEECH_OFF% | %SPEECH_ON%Ah, please don\'t!%SPEECH_OFF%You have your boot on the last of the southern troop, and you are sizing him up to join the indebted. He begs for his life, or for freedom, and eventually to simply die free. You shake your head.%SPEECH_ON%Gold cannot live or die, traveler, it is merely weighed. Heavy. Or light. My considerations do not concern you. You beg about something you lost the moment you crossed paths with me.%SPEECH_OFF% | The last of the southern troop is at your feet. He\'s praying to the Gilder to bring light to his path. Unfortunately, the only one with say here is yourself, and you\'ve got a spot in chains for the man if you wish him to \'join\' the %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take him as an indebted to the Gilder so that he may earn his salvation.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Lost a battle and was taken a captive");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
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
					"slave_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% was taken as an indebted after barely surviving a battle against your men. His spirit was broken and he was forced to fight for you, so that he may pay his debt to the Gilder.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Barbarians",
			Text = "[img]gfx/ui/events/event_145.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | Ah, the last survivor. He\'s a large man, the barbarian, and could perhaps do well for you. In chains, of course. | The %companyname% rarely comes across stock such as these northern barbarians. With one last survivor left on the field, you ponder if taking him as an indebted would be to your benefit. | The last barbarian standing. He speaks to you in a language you\'d never have the time to learn. Grunts, growls, things which other languages would take for threats, but here you know he is articulating something of import. But, all you have to respond with is the chain, and this barbarian might just make a very good indebted for the %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take him as an indebted to the Gilder so that he may earn his salvation.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Lost a battle and was taken a captive");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
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
					"slave_barbarian_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% was taken as an indebted after barely surviving a battle against your men. His spirit was broken and he was forced to fight for you, so that he may pay his debt to the Gilder.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function isValid()
	{
		if (!this.Const.DLC.Desert)
		{
			return false;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.manhunters")
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatID") <= this.m.LastCombatID)
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 5.0 || this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 1)
		{
			return false;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return false;
		}

		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));

		if (f == null)
		{
			return false;
		}

		if (f.getType() != this.Const.FactionType.NobleHouse && f.getType() != this.Const.FactionType.Settlement && f.getType() != this.Const.FactionType.Bandits && f.getType() != this.Const.FactionType.Barbarians && f.getType() != this.Const.FactionType.OrientalCityState && f.getType() != this.Const.FactionType.OrientalBandits)
		{
			return false;
		}

		this.m.LastCombatID = this.World.Statistics.getFlags().get("LastCombatID");
		return true;
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));

		if (f.getType() == this.Const.FactionType.NobleHouse)
		{
			return "Nobles";
		}
		else if (f.getType() == this.Const.FactionType.Settlement)
		{
			return "Civilians";
		}
		else if (f.getType() == this.Const.FactionType.Bandits)
		{
			return "Bandits";
		}
		else if (f.getType() == this.Const.FactionType.Barbarians)
		{
			return "Barbarians";
		}
		else if (f.getType() == this.Const.FactionType.OrientalCityState)
		{
			return "CityState";
		}
		else if (f.getType() == this.Const.FactionType.OrientalBandits)
		{
			return "Nomads";
		}
		else
		{
			return "Civilians";
		}
	}

	function onClear()
	{
		this.m.Dude = null;
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU32(this.m.LastCombatID);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 54)
		{
			this.m.LastCombatID = _in.readU32();
		}
	}

});


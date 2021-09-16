this.helped_caravan_event <- this.inherit("scripts/events/event", {
	m = {
		LastCombatID = 0
	},
	function create()
	{
		this.m.ID = "event.helped_caravan";
		this.m.Title = "After the battle...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_60.png[/img]{The caravan\'s lead merchant comes to you with thanks for saving him. Naturally, he provides more than just words: a number of goods are given, some of which will be of use. | %SPEECH_ON%Thank you, traveler, thank you!%SPEECH_OFF%The caravan\'s merchant master clasps his hands and shakes them up and down as though to thank you and the old gods alike. He also says thanks with material goods, providing the %companyname% with an assortment of rewards straight off the wagons. | It is rare for strangers in this world to see one another in good grace, but even a wily merchant understands that if he is saved from total annihilation then perhaps he best reward his saviors. The caravan lightens its load by rewarding you with a number of goods. | Had you not arrived this caravan surely would have met doom. It rewards you properly for your impromptu \'services.\' | %SPEECH_ON%Oh by any higher power which may or may not exist to you, but whatever it is, it now reigns over me!%SPEECH_OFF%The merchant is clearly in shock. And, like any disturbed peddler, he immediately goes to the one thing he knows how to do.%SPEECH_ON%Look, we\'ve goods to offer, how about these? Tokens of our gratitude, free of charge.%SPEECH_OFF% | Though the battle is over, the hysteria of the saved merchants is just as loud as the carnage which has just passed.%SPEECH_ON%Sellswords, sellswords! Our saviors!%SPEECH_OFF%Suddenly, you find the merchants swarming with goods as thanks for saving them.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Glad to be of help.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local n = 1;

				if (this.World.Statistics.getFlags().getAsInt("LastCombatKills") > this.Math.rand(11, 14))
				{
					n = ++n;
				}

				for( local i = 0; i < n; i = ++i )
				{
					local item = this.new("scripts/items/" + this.World.Statistics.getFlags().get("LastCombatSavedCaravanProduce"));
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + item.getName()
					});
				}
			}

		});
	}

	function isValid()
	{
		if (this.World.Statistics.getFlags().get("LastCombatSavedCaravan") && this.World.Statistics.getFlags().get("LastCombatWasOngoingBattle") && this.World.Statistics.getFlags().get("LastCombatID") > this.m.LastCombatID && this.World.Statistics.getFlags().getAsInt("LastCombatKills") >= this.Math.rand(4, 6))
		{
			this.m.LastCombatID = this.World.Statistics.getFlags().getAsInt("LastCombatID");
			return true;
		}

		return false;
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

	function onClear()
	{
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


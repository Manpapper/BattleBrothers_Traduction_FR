this.lindwurm_slayer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.lindwurm_slayer";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]{You\'re enjoying a drink at one of %townname%\'s cozy taverns. Naturally, this comfort doesn\'t last long as a man struts into the place with his armor clinking and clanking. You make the error of glancing at him and catching his eye. He immediately heads over. Sighing, you put your opposite hand onto your sword and await what this could possibly be. The man stomps to the end of your table and straightens up.%SPEECH_ON%Let me introduce myself, in case rumor and myth have not done it already. I am %dragonslayer%. My chosen life in this world is to hunt and slay dragons.%SPEECH_OFF%You take a drink and set it down, telling the man that dragons don\'t exist. He grins.%SPEECH_ON%That is because my father slew them all. In truth, I am a killer of lindwurms, and I hear you are the captain of the %companyname%, an outfit some renown, almost as much as renown as yours truly. What would you say to combining our skills and talents, hm? I\'d be willing to join you for %price% crowns.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Very well, I\'ll pay your %price% crown fee.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "No, thanks, we\'re good.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"lindwurm_slayer_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "{%name% is a supposedly famous monster hunter with a particular talent for slaying lindwurms. He says he is the son of Dirk the Dragonslayer, the monster hunter who ostensibly slew the last living dragon.}";
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

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				_event.m.Dude.getItems().equip(this.new("scripts/items/weapons/fighting_spear"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/shields/buckler_shield"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/helmets/heavy_mail_coif"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/armor/named/lindwurm_armor"));
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_35.png[/img]{You and the Oathtakers are walking the streets of %townname% when a man in glinting, Oathtaker-worthy armor suddenly appears. He strides right for you, and despite the company half-drawing their weapons as a sort of warning, the man continues unfaltered and holds his hand out.%SPEECH_ON%Hail! I am %dragonslayer%, son of the most famous dragonslayer in all the land.%SPEECH_OFF%Your men sheathe their weapons and everyone glances around. You shake the man\'s hand and ask what it is he wants. He steps back, straightens up as though for presentation, and peacocks his doings: that he\'s slain monsters of all sizes, and women of all sizes, and that he has a particular fondness for slaying dragons, and another fondness for bigger lasses because they remind him of- you cut him off, telling him that dragons no longer exist. He nods.%SPEECH_ON%That is correct! Dragons no longer exist, because my father is the one who killed the last one. I shall be honest, I am a lindwurm slayer, and I am quite good at it. And I have sought out you Oathtakers because of the renown and fame you have achieved, and of course because I wish to be a part of it.%SPEECH_OFF%This supposedly famous lindwurm slayer offers to join the %companyname% free of charge.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Very well, join us.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "No, thanks, we\'re good.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"lindwurm_slayer_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "{%name% is a supposedly famous monster hunter with a particular talent for slaying lindwurms. He says he is the son of Dirk the Dragonslayer, the monster hunter who ostensibly slew the last living dragon.}";
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

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				_event.m.Dude.getItems().equip(this.new("scripts/items/weapons/fighting_spear"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/shields/buckler_shield"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/helmets/heavy_mail_coif"));
				_event.m.Dude.getItems().equip(this.new("scripts/items/armor/named/lindwurm_armor"));
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_35.png[/img]{You reach into your pockets and put the purse on the table. The man takes it up, picking through the change. He nods and cinches the pursestrings.%SPEECH_ON%Very well. You have my services, captain of the %companyname%, and by my father\'s good name you shall not regret it.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Welcome to the company!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(-5000);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]5000[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_35.png[/img]{The man will either prove himself to be worthy of his stated accomplishments, or he\'ll end up dead meat. If he\'s willing to join without any upfront cost to you, what does it hurt to see how he fares? You hold your hand out and the man shakes it. His armor clinks and clanks as his arm bounces up and down.%SPEECH_ON%Your Oathtakers will not be disappointed, that I can promise you.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Welcome to the company, %dragonslayer%.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 2000)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 6000 && this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dragonslayer",
			this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"price",
			"5000"
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.paladins")
		{
			return "B";
		}

		return "A";
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Town = null;
	}

});


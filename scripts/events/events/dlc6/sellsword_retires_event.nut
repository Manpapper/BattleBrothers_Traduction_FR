this.sellsword_retires_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null
	},
	function create()
	{
		this.m.ID = "event.sellsword_retires";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{While on the path, you come across a man sitting beside the path. He\'s clad in some beaten armor and there\'s an even more beaten weapon in his lap. He regards you with the limpest of waves.%SPEECH_ON%Evening. If you ain\'t sellswords, then I never set my pa\'s pants afire.%SPEECH_OFF%That seems to be an interesting tale in and of itself, but you instead ask the man what he\'s doing in the middle of the road. More important, you ask this rather able-bodied fella if he\'s looking for work.%SPEECH_ON%A job? No. I don\'t need one. I already done that sword-selling bit and I\'m done with it. You know what, here.%SPEECH_OFF%He starts undoing his armor and throws it on the ground before you.%SPEECH_ON%Take it. I\'ve no need for that life anymore. Take the weapon, too. I\'m leaving all this shite behind. You should, too, but I knew ya won\'t. Not before it\'s too late, anyway. I\'m walking the earth until my feet are ground into nubs. As for yourself, godspeed.%SPEECH_OFF%And just like that, the stranger goes.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Good luck.",
					function getResult( _event )
					{
						if (_event.m.Peddler != null)
						{
							return "B";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
				local item;
				local stash = this.World.Assets.getStash();
				item = this.new("scripts/items/weapons/arming_sword");
				item.setCondition(item.getConditionMax() / 2 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/armor/basic_mail_shirt");
				item.setArmor(item.getArmorMax() / 2 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%peddler% the peddler, always having a good nose for gold, asks if the man earned any crowns while working as a sellsword. When the stranger nods, the peddler notes that if that\'s true then he can always \'buy\' his way back into the life. The sellsword thinks for a minute, then nods again.%SPEECH_ON%You know what? That\'s right. So long as I\'ve got the crowns, I\'ve still got a lifeline back to that damned business. Here, take it.%SPEECH_OFF%The retiring, and ostensibly soon-to-be-hermit, fishes into his pockets and happily throws you a sack of crowns like a man ridding himself of an old burden.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll put these to good use.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				local money = this.Math.rand(20, 100);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crown"
					}
				];
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

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Peddler = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler != null ? this.m.Peddler.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Peddler = null;
	}

});


this.oathbreaker_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.oathbreaker";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{You come across a man in a sort of disparate state: on one hand, he is covered in ornate armor that seems befitting a man sitting on a horse ready to joust at a grand tournament. On the other hand, he is laid out on the ground, legs scissoring back and forth in a drunken stupor, his arms slung out as if they were around the shoulders of friends but instead only find the comfort of mud.%SPEECH_ON%I beseech ye, traveler, buy m\'armors and m\'weapons, and leave me the crowns suitably worthy of both, such that I may seek redemption another way, for them martial matters are no longer kin to my path in this world, and -hic- I\'d sooner buy m\'way to Young Anselm\'s graces than see to it with the swing of a sword, may the old gods smite me for admittin\' it aloud but I\'ll admit it aloud!%SPEECH_OFF%It seems he is offering his weapons and armor for a price of, if you get his babblings right, 9,000 crowns.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll take the armor for 9,000 crowns.",
					function getResult( _event )
					{
						return "BuyArmor";
					}

				},
				{
					Text = "Not interested.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getOrigin().getID() == "scenario.paladins")
				{
					this.Options.push({
						Text = "Young Anselm has other plans for you. Join us!",
						function getResult( _event )
						{
							return "Oathtaker";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "BuyArmor",
			Text = "[img]gfx/ui/events/event_180.png[/img]{You crouch down with the purse of crowns in hand.%SPEECH_ON%Take it off.%SPEECH_OFF%The man nods and starts shucking off the armor, wriggling out of it, sniffing now and again. He holds it all out, and the armor with it. You have it taken and put into inventory, then give the monies as agreed. His fingers clutch and grip and touch the purse like a spider\'s legs rolling up its prey, his drunken eyes darting left to right. He gets up and hobbles away. You have a feeling that he will not find the redemption he thinks he will with that money. %randombrother% puts a hand on your shoulder.%SPEECH_ON%Don\'t dwell on him, captain. There\'s certain people in this world that you just don\'t want to be the last person who forgets them, understand?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Safe travels.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local stash = this.World.Assets.getStash();
				local weapons = [
					"weapons/arming_sword",
					"weapons/military_pick",
					"weapons/hand_axe",
					"weapons/pike",
					"weapons/warbrand"
				];
				item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(item.getConditionMax() / 3 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/armor/adorned_heavy_mail_hauberk");
				item.setCondition(item.getConditionMax() / 3 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/helmets/adorned_full_helm");
				item.setCondition(item.getConditionMax() / 3 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				this.World.Assets.addMoney(-9000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]9,000[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Oathtaker",
			Text = "[img]gfx/ui/events/event_183.png[/img]{Instead of giving a hand out, you give out your hand.%SPEECH_ON%Sir, Young Anselm knew full well that no oath could be respected forever. To falter is to live, and to live is to falter. Do you think being here in the mud is error? Do you think your failures are something mended by money?%SPEECH_OFF%The man looks up. He asks if you, too, know Young Anselm. He still hasn\'t taken your hand, so you take his and pull him to his feet.%SPEECH_ON%Oathtaker, who do you think sent me?%SPEECH_OFF%The man stumbles a second, staring at you in disbelief. Then he cracks a wide grin and gives you a firm hug, embracing you and the company together. Wherever an Oathtaker is in the world, he is not alone, that was Young Anselm\'s first message.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome aboard!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
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
					"paladin_background"
				]);
				_event.m.Dude.setTitle("the Oathbreaker");
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.m.PerkPoints = 0;
				_event.m.Dude.m.LevelUps = 0;
				_event.m.Dude.m.Level = 1;
				_event.m.Dude.m.XP = this.Const.LevelXP[_event.m.Dude.m.Level - 1];
				local trait = this.new("scripts/skills/traits/drunkard_trait");
				_event.m.Dude.getSkills().add(trait);
				local dudeItems = _event.m.Dude.getItems();

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				local weapons = [
					"weapons/arming_sword",
					"weapons/military_pick",
					"weapons/hand_axe",
					"weapons/pike",
					"weapons/warbrand"
				];
				local item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(item.getConditionMax() / 3 - 1);
				dudeItems.equip(item);
				item = this.new("scripts/items/helmets/adorned_full_helm");
				item.setCondition(item.getConditionMax() / 3 - 1);
				dudeItems.equip(item);
				item = this.new("scripts/items/armor/adorned_heavy_mail_hauberk");
				item.setCondition(item.getConditionMax() / 3 - 1);
				dudeItems.equip(item);
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

		if (this.World.Assets.getMoney() < 10500)
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 3)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.paladins" && this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
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


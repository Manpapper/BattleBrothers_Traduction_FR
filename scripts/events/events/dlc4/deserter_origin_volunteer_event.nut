this.deserter_origin_volunteer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude1 = null,
		Dude2 = null,
		Victim = null
	},
	function create()
	{
		this.m.ID = "event.deserter_origin_volunteer";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_88.png[/img]{A pair of men looking disheveled and weary emerge from some bushes beside the road. They hold their hands up as if they\'d come to surrender themselves.%SPEECH_ON%Are ye the %companyname%? We\'d heard you were a band of deserters. And I don\'t mean that as an insult. We\'re runners, too, but we got nowhere else to go. Everywhere we turn there are bounty hunters and executioners. Let us fight for you. It ain\'t the fight that ever scared us, we swears by that.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We could use fighting men like you.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "B" : "C";
					}

				},
				{
					Text = "We have no need for you.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude1 = null;
						_event.m.Dude2 = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude1 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude1.setStartValuesEx([
					"deserter_background"
				]);
				_event.m.Dude1.getBackground().m.RawDescription = "Running from bounty hunters and executioners from some time, %name% bumped into your company on the road and promptly volunteered.";
				_event.m.Dude1.getBackground().buildDescription(true);
				_event.m.Dude2 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude2.setStartValuesEx([
					"deserter_background"
				]);
				_event.m.Dude2.getBackground().m.RawDescription = "%name% deserted an army regiment together with " + _event.m.Dude1.getNameOnly() + " before he volunteered to join your company.";
				_event.m.Dude2.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude1.getImagePath());
				this.Characters.push(_event.m.Dude2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_88.png[/img]{It would be almost satisfyingly ironic to string these men up and hang them for what they\'d done, but you are not about to set that tone for the company. You welcome them to the band, sending them forth to the inventory. %victim% keeps an eye on them for a time, but he reports that the men are true to their word and will fight.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude1);
						this.World.getPlayerRoster().add(_event.m.Dude2);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude1.onHired();
						_event.m.Dude2.onHired();
						_event.m.Dude1 = null;
						_event.m.Dude2 = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude1.getImagePath());
				this.Characters.push(_event.m.Dude2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{It would be almost satisfyingly ironic to string these men up and hang them for what they\'d done, but you are not about to set that tone for the company. You welcome them to the band, sending them forth to the inventory with %victim% keeping an eye on them. Except you don\'t see your sellsword for a suspicious length of time. When you go looking, he\'s found knocked out on the ground and the inventory ransacked. The two men are nowhere to be seen!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn those scroundels!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.getTemporaryRoster().clear();
				_event.m.Dude1 = null;
				_event.m.Dude2 = null;
				local injury = _event.m.Victim.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Victim.getName() + " suffers " + injury.getNameOnly()
				});
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					local food = this.World.Assets.getFoodItems();
					food = food[this.Math.rand(0, food.len() - 1)];
					this.World.Assets.getStash().remove(food);
					this.List.push({
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "You lose " + food.getName()
					});
				}
				else if (r == 2)
				{
					local amount = this.Math.rand(20, 50);
					this.World.Assets.addAmmo(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_ammo.png",
						text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Ammunition"
					});
				}
				else if (r == 3)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addArmorParts(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_supplies.png",
						text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Tools and Supplies"
					});
				}
				else if (r == 4)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addMedicine(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_medicine.png",
						text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Medical Supplies"
					});
				}

				this.Characters.push(_event.m.Victim.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.deserters")
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() + 1 >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local roster = this.World.getPlayerRoster().getAll();
		this.m.Victim = roster[this.Math.rand(0, roster.len() - 1)];
		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"victim",
			this.m.Victim.getName()
		]);
	}

	function onClear()
	{
		this.m.Dude1 = null;
		this.m.Dude2 = null;
		this.m.Victim = null;
	}

});


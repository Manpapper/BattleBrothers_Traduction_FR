this.butcher_wardogs_event <- this.inherit("scripts/events/event", {
	m = {
		Butcher = null
	},
	function create()
	{
		this.m.ID = "event.butcher_wardogs";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_27.png[/img]You open a crate of food to find the last of your reserves. An apple rolls across the bottom, sounding not unlike the grumble of an empty stomach as it totters about. A few loaves of bread give it some company and there is a piece of meat wrapped in a thick leaf. That\'s it.\n\nWhen you close the lid and turn around, %butcher% the butcher is standing there.%SPEECH_ON%Hey there boss. I see we got a problem. So how about I... fix it?%SPEECH_OFF%Just then, he thumbs over his shoulder, right in the direction of two war dogs chained up to a stake.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do what is necessary.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "I will not have our trusty hounds be butchered and eaten.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_14.png[/img]The dogs are sitting rather studiously, panting and looking pretty content, so durable is their sense of happiness. But you\'ve mouths to feed and battles to fight. You give %butcher% the go ahead to do what is right for the company.\n\nThe butcher meanders his way toward the mutts, holding out one hand to pet them as the other clutches a knife behind his back. You do not stick around to watch what happens next, but a short yelp quickly followed by another turns your already empty stomach.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "À least the men won\'t go hungry tonight.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				local numWardogsToSlaughter = 2;
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
					{
						numWardogsToSlaughter = --numWardogsToSlaughter;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});

						if (numWardogsToSlaughter == 0)
						{
							break;
						}
					}
				}

				if (numWardogsToSlaughter != 0)
				{
					local brothers = this.World.getPlayerRoster().getAll();

					foreach( bro in brothers )
					{
						local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

						if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
						{
							numWardogsToSlaughter = --numWardogsToSlaughter;
							bro.getItems().unequip(item);
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "You lose " + item.getName()
							});

							if (numWardogsToSlaughter == 0)
							{
								break;
							}
						}
					}
				}

				local item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_27.png[/img]You shake your head no.%SPEECH_ON%Absolutely not. They are as part of the company as any man, and certainly some men would rather starve than eat their own.%SPEECH_OFF%The butcher shrugs.%SPEECH_ON%They\'re just dogs, sir. Mutts. Mongrels. Ain\'t nothing but a beast that knows its name and little else. There are plenty of pups to find when we need them.%SPEECH_OFF%Again, you shake your head.%SPEECH_ON%We\'re not killing the dogs, %butcher%. And don\'t think I don\'t see the glint in your eye. There\'s more to slaughtering them animals than just feeding a few mouths.%SPEECH_OFF%%butcher% can only shrug again.%SPEECH_ON%I can\'t pick and choose what gives me pleasure, sir, but I\'ll follow yer orders.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll find something else.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				_event.m.Butcher.worsenMood(1.0, "Was denied a request");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Butcher.getMoodState()],
					text = _event.m.Butcher.getName() + this.Const.MoodStateEvent[_event.m.Butcher.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() > 25)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local numWardogs = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.butcher")
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				numWardogs = ++numWardogs;
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		if (numWardogs < 2)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
				{
					numWardogs = ++numWardogs;

					if (numWardogs >= 2)
					{
						break;
					}
				}
			}
		}

		if (numWardogs < 2)
		{
			return;
		}

		this.m.Butcher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"butcher",
			this.m.Butcher.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Butcher = null;
	}

});


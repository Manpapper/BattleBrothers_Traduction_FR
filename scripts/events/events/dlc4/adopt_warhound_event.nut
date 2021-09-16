this.adopt_warhound_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.adopt_warhound";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{You come across a caldera the bottom of which you find a few sheep nuzzling something. As you draw close, you see that there is an enormous hound there, its fur matted with blood, its collar shredded, and its paws wiry where the claws have come apart. It regards you with a growl, but can\'t maintain it for long as it simply puts its head down with an exhausted huff. The sheep depart and beyond them you find a man leaning against a rock. His chest has been ripped open and whatever killed him did it with such force as to spray his innards all along the rocks. Following the trail, you do find a monstrous Nachzehrer whose throat has been ripped out. %randombrother% nods.%SPEECH_ON%I think that pup might be worth having in the company.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "He\'ll fit right in with us.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "%houndman%, you\'ve dealt with hounds before, right?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "Just put it out of its misery.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{You reach out to the hound and it lifts it head to you as though you were another threat. Its eyes peer blackly from a long-matted mane that still drips with blood. The sheep, having seen what carnage this beast has already wrought, bay nervously as they watch you. But you won\'t be deterred. You put your hand forth, palm supinated, and the weary dog slowly lowers into it. You nod.%SPEECH_ON%There\'s more fight in you yet, friend.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'ll call you \'Warrior\'.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/warhound_item");
				item.m.Name = "Warrior the Warhound";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{You move to take the hound, but as you crouch down one of the sheep bays and charges, knocking you over. The men laugh and by the time you get to your knees another sheep crushes you from behind to many cheers. Drawing out your sword emits a sharp twang that sends the sheep scurrying. When you look back at the hound its nose is to the dirt and its eyes peerless. It has died and the sheep slowly collect around it bleating and crying out. You sheathe your sword and tell the company to move on.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Brave little guy.",
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
			Text = "%terrainImage%{%houndman% steps forward.%SPEECH_ON%I know this breed. It is of northern stock, a sturdy creature. There is one thing it shall respect in a man and it is strength.%SPEECH_OFF%The sellsword crouches before the dog and without pause puts its hands around the scuff of its neck and starts to scratch. Despite the sudden movements, the dog responds positively and when the man stops scratching the dog lifts up off the ground and lopes forward and follows the man. %houndman% stares back at you as he roughs the dog up with some heavy petting.%SPEECH_ON%Yeah he\'ll fight for us. Fightin\' is what he\'s made for. He just needed someone to watch him rip and tear.%SPEECH_OFF%What a lovely creature this is. And the dog is fine, too.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lets call him \'Warrior\' then.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				local item = this.new("scripts/items/accessory/warhound_item");
				item.m.Name = "Warrior the Warhound";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.7)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.houndmaster" || bro.getBackground().getID() == "background.barbarian")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"houndman",
			this.m.Houndmaster != null ? this.m.Houndmaster.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Houndmaster = null;
	}

});


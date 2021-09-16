this.tundra_elk_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.tundra_elk_destroyed";
		this.m.Title = "After the battle...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_146.png[/img]{With the killing blow well placed, the Ijirok clambers side to side gripping its final wound. It lets out a howl of pain and buckles at the knees and can only barely hold itself up with one hand as its body doubles over and vomits into the ground. But the whole thing seems like a charade and the beast at times looks over as though to make sure you are watching. It is a drama. A poorly acted show put on by that which does not know death in any sense. The eyes lock with yours and that unsettling grin returns, then the monstrosity flashes a blinding strobe of blue and when the natural light of the world returns the corpse is frozen solid and flakes of snow drizzle from the sky.\n\n That can\'t be it. You just know it. You walk up to the iced remains and start chopping away. As you hew into the ice, a blue ooze drips from channels and gaps. One final swing smashes the ice apart and a blob of goo runs every which way. As the men looked on rather concerned, you grab the shattered armor from the cave and throw it into the Ijirok\'s blood. The strange tendrils which held its pieces together instantly brighten and you watch as they begin to twist taut and pull the plates together. Matted elk fur conjoins with the metal as though they were one being coming to heal old wounds. Blood snakes over the plates like moss twirling beneath a riverbed, curling to and fro before flattening out and painting the armor a slick red. \n\nPicking it up, you feel a buzz on your fingertips.%SPEECH_ON%I hope you don\'t suggest I wear that, captain.%SPEECH_OFF%%randombrother% says, shaking his head with a nervous smile. You\'re not yet sure what the armor is capable of, but no doubt have the mind to keep it in inventory to see. As for the Ijirok, you\'ve no doubt it is still out there somewhere. Its corpse is already decaying rapidly and the bones which remain are not that of a giant beast but simply that of a poor elk.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Still, we prevailed.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IjirokStage", 5);
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.broken_ritual_armor")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						break;
					}
				}

				this.World.Assets.getStash().makeEmptySlots(2);
				local item = this.new("scripts/items/helmets/legendary/ijirok_helmet");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				local item = this.new("scripts/items/armor/legendary/ijirok_armor");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_146.png[/img]{With the killing blow well placed, the Ijirok clambers side to side gripping its final wound. It lets out a howl of pain and buckles at the knees and can only barely hold itself up with one hand as its body doubles over and vomits into the ground. But the whole thing seems like a charade and the beast at times looks over as though to make sure you are watching. It is a drama. A poorly acted show put on by that which does not know death in any sense. The eyes lock with yours and that unsettling grin returns, then the monstrosity flashes a blinding strobe of blue and when the natural light of the world returns the corpse is frozen solid and flakes of snow drizzle from the sky.\n\n That can\'t be it. You just know it. You walk up to the iced remains and start chopping away. As you hew into the ice, a blue ooze drips from channels and gaps. One final swing smashes the ice apart and a blob of goo runs every which way.\n\nYou\'ve no doubt that this thing is still out there somewhere. Its corpse is already decaying rapidly and the bones which remain are not that of a giant beast but simply that of a poor elk.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Still, we prevailed.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IjirokStage", 5);
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local stash = this.World.Assets.getStash().getItems();

		foreach( i, item in stash )
		{
			if (item != null && item.getID() == "misc.broken_ritual_armor")
			{
				return "A";
			}
		}

		return "B";
	}

	function onClear()
	{
	}

});


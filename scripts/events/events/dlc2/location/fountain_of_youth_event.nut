this.fountain_of_youth_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.fountain_of_youth";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_114.png[/img]{You stand at the edge of a forest clearing and the sight therein beggars belief.\n\n A trunk of a human body runs up out of the earth like a slender tree, naked and bristling, goosebumps for bark, continuing upward until it is twice as tall as yourself. There are no branches. There are no hands. There are, instead, a series of human heads bound in a bunch where a tree crown should be. From left to right they are babyish and beautifully present, ambiguously sexless, malformed creations of time it seems, where the shadows they themselves author turn their faces from ones oddly familiar to strangely naive, as they stare about as though they knew not how they got there and seem ever ready to ask it of you. It reminds you of a drowning you happened upon, the face contorting beneath the running river water, the flesh suffering nothing short of constant conjecture as to what put it there.\n\n Whispers sift in from the trees. They riffle over the ground as if spoken by the bugs, and they clamber up your arms until they scratch at your very ears. They ask you to stay.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s see what this is.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We need to get the hell out of here. Fast.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_114.png[/img]{Upon entering the clearing, the bizarre creature straightens up, swaying its heads from side to side like a peacock readying a display. They speak to you.%SPEECH_ON%The. Elder. Yes. Here. Yes. Him. We. Know. Him. We. Knew.%SPEECH_OFF%The faces warp and discolor as though blemished in the wake of the words leaving their very mouths. Slowly they reform to speak again, a grotesque panoply punctuating itself one head at a time.%SPEECH_ON%Drink. Little. Heal. All. Drink. All. Become. One.%SPEECH_OFF%You look down to see an earthen overhang curving across a puddle the size of a plate. There\'s a faint trickle as water drips into it from the overhang, and from where that water comes is anyone\'s idea. You look up to see the faces looking down, their appearances molding from anguish to happiness to surprise to fear to confusion.%SPEECH_ON%Familiar. Always. Familiar. Drink. Little. Yes. No. Drink. All.%SPEECH_OFF%Looking back down, you take out your waterskin and pop the cork.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'ll just take a little.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "I\'ll drink it all!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_114.png[/img]{You crouch beneath the grotesque tree. The heads sway downward, the shade coming with them as though someone were placing the lid upon a basket. When you look up, they stare from a foot away, rippling and forever moving. Yet, one on the far end is very still. Its face is stuck on an old man\'s grimace, the brow furrowed, the jowls taut, the elderly lines ever creased as if the fury was folding upon itself like a well-crafted sword. A bulb of darkness surrounds it, the penumbra pulsing, as if the head was staring in from another world altogether.\n\n Hands firm, you take the waterskin and pour out its contents. Emptied, you put it beneath the dripping overhang and listen to each drop hit its bottom. The faces lean in ever closer, surrounding you in a cone of chaos. As they draw near, you can hear the tearing of their reality as they come to and fall out of shape. The waterskin shakes in your hand as if you had to hold it against the surge of a waterfall. You yank it out from the overhang and as you tumble backward you realize the heads have long since reared upright. Rolling over, you crawl your way to your feet and run out of the clearing. Seemingly safe you look back to see the creature is gone. There is nothing there at all. No tree. No fountain. The waterskin, however, remains.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Best keep this somewhere safe.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().die();
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/special/fountain_of_youth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_114.png[/img]{You throw the waterskin aside and put your mouth into the puddle and drink. The world beneath the puddle\'s surface is empty and silent. Your lips move, your throat gulps, but there is nothing to drink here. You scream. There is nothing. Not even a feeling. Just the notion of fear, a tickle with no means to scratch it. When you put your hands to the earth to try and remove yourself, you find that you cannot leave the puddle.\n\n Faint faces wink in and out of the void. They are like the tree\'s, dramatically inanimate, painfully issued from past to present to future, and here they approach, gathering in number, bubbling and jostling forward, turning this black hell into a frothy white. As they near, you realize you\'ve been not looking right. Individually, they are but faces without presence. Taken as a whole, as the great white sheet on the approach, you realize that they make up one large face: yours. And it is laughing.\n\n Screaming, you finally fall back out of the puddle. %randombrother% has you under his arm and he\'s looking at you with concern.%SPEECH_ON%Sir, are you alright? You was napping then your head slid into the water there.%SPEECH_OFF%You look up, thinking to see the grotesque tree and its awful faces. It is not there and no matter how many times you look or in how many places, it is never there again.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I... don\'t... understand.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().die();
						}

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
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});


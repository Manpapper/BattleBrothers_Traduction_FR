this.kraken_cult_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.kraken_cult_destroyed";
		this.m.Title = "After the battle";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_105.png[/img]{Tentacles chain across the swamp in a corrupted mass such that you didn\'t slay the kraken so much as annihilate the very place it called home. Each wormy vestige is wimpled with swamp moss, a stretch of profitable farmland to hatch the very mushrooms you saw the woman eating time and time again. You crouch beside one unharvested batch, poking at their caps like a cat at a wingless moth. The fungi deflate at the touch. %randombrother% looks at them.%SPEECH_ON%Mycologist might know what those are.%SPEECH_OFF%You nod. Yeah. Might. You move along, crushing the shrooms underfoot and wading through limbs and bloodied cloaks floating along the swamp and the tentacles\' faceless heads with their leafy maws folded over each other and their tongues lolled like whips. You find the woman nestled behind a cast of kudzu, yourself parting the vines like a man seeking his fortune. She regards you with a grin.%SPEECH_ON%Did you hear it? Did you hear its beauty?%SPEECH_OFF%Sighing, you tell her that the shrooms overtook her mind, and the shrooms were likely there for a reason and that the kraken had her well before it ever rose, that it used her to bring everyone here. Grinning ever more, she only asks again if you heard its beauty. You tell her you heard it die. Her brow furrows.%SPEECH_ON%A cry of death? Is that what you think? Oh my, oh no. Stranger, that was a cry for help. Don\'t you get it? That means more are out there! More! Perhaps hundreds! And now they are awake! Now they are all awake!%SPEECH_OFF%You step back and close the kudzu curtain. %randombrother% tells you that the company has found something. For a moment, you think to save this woman, but you know better. You know the grip she is in and leave her be.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, show me what\'s been found.",
					function getResult( _event )
					{
						if (this.World.Flags.get("IsWaterWheelVisited"))
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_105.png[/img]{The creature was almost too large to die properly on its side and instead tilts forward with its horrid mouth gaping like a hole blasted into a leaning bastion. One sellsword sits crosslegged atop the kraken\'s dome like a monk deep in study. Another is poking the creature in its eyes until one pops and the corners of the socket slurp the liquid in a frothy gargle. You ask the mercenaries what of import has been found and one waves you over to the creature\'s maw. With slackened gums the teeth now hang downward, limp crenellations to a tower of horror, the slew of razors coated in clothes and flesh and so large that whole limbs are wedged between them. And so is the blade.\n\n You reach into the mouth and wrench out the blade and wipe it down with a cloth. Turning the blade, you spot glyphs in the fuller with numbers beside them, a suggestion of smithing eternal yet purposed particular to a time and place. The steel is so vibrant it seems to have been fashioned by the light of the stars themselves. Unfortunately, there is no handle for it. The magnificence of the blade suggests it is not to be accommodated by any mere hilt. Putting the blade in inventory, you tell the men to collect what they can from the \'Beast of Beasts\' and to get ready to leave this wretched place.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We prevailed.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/legendary_sword_blade_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_105.png[/img]{The creature was almost too large to die properly on its side and instead tilts forward with its horrid mouth gaping like a hole blasted into a leaning bastion. One sellsword sits crosslegged atop the kraken\'s dome like a monk deep in study. Another is poking the creature in its eyes until one pops and the corners of the socket slurp the liquid in a frothy gargle. You ask the mercenaries what of import has been found and one waves you over to the creature\'s maw. With slackened gums the teeth now hang downward, limp crenellations to a tower of horror, the slew of razors coated in clothes and flesh and so large that whole limbs are wedged between them. And so is the blade.\n\n You reach into the mouth and wrench out the blade and wipe it down with a cloth. Turning the blade, you spot glyphs in the fuller with numbers beside them, a suggestion of smithing eternal yet purposed particular to a time and place. The steel is so vibrant it seems to have been fashioned by the light of the stars themselves. Unfortunately, there is no handle for it and you immediately do the math on that: a sword of unseen magnificence with no handle and one strange old man in a secluded wheelhouse with a blade-less handle. You think you know just where to take this. You put it in the inventory and order the company to plunder whatever else is worth taking, including from the so-called \'beast of beasts.\'}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We prevailed.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/legendary_sword_blade_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		this.World.Flags.set("IsKrakenDefeated", true);
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


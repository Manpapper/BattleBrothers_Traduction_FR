this.traveler_south_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.traveler_south";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_171.png[/img]{You come across a man wandering the desert with a family of younger men by his side. He welcomes you to a campfire and asks if you\'d like to hear tales of the desert and of the south in general.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Happy to join you at the campfire.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "No, keep your distance.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]{The man goes on to talk about the Ancient Empire - at least what he is aware of it.%SPEECH_ON%It\'s hard to say exactly what it was, you know? And it is hard to say what exactly came before. I had gotten a glimpse into the libraries of %randomcitystate% and was rather astonished and what I was able to find. You know what the oldest texts we have are? Ancient texts. Do you know what these ancient texts write about? Other ancient texts. We have no idea how far back our timeline really goes. We just exist in the here and now, and perhaps one day in the future our progeny will come to find that we are the mystery, and those that were mysteries to us?%SPEECH_OFF%He scissors his fingers through the air.%SPEECH_ON%Gone.%SPEECH_OFF% | He prods the campfire with an iron poker.%SPEECH_ON%They say that the Ifrits are manifestations of man\'s cruelty. That when we are evil to one another there is a force, some unseen force, which we are pressing against. When we attack and slaughter on a larger scale, this force is bent across the entire seam, but when we do ill against one individual, to such horrible ends, it is when this force snaps. And a hole is made, and out of that hole comes a correction. A correction which we call the Ifrit. A correction that will seek to make amends, by literally mending these invisible forces with the corpses of those who dared to open them in the first place.%SPEECH_OFF%The man sets the iron poker aside. He smiles somberly.%SPEECH_ON%So it is said, anyway.%SPEECH_OFF% | Despite being an old man, he crosses his legs with the limberness and agility of a younger fellow. He\'s no doubt sat before many a campfire. He speaks as warmly as the flames before you.%SPEECH_ON%I\'ve been around these sands for many summers. But my sons, who I have outlasted, I must sadly say, they would ask, how do we go on about telling the time from one season to the next? To which marker do we signify the years?%SPEECH_OFF%A wrinkly finger is raised, and it points further above. He winks at you.%SPEECH_ON%The stars. They wheel across the sky in patterns one can recognize if one is willing to pay attention. I also imagine that those stars may be beings of another aether, another unimaginable place. Perhaps somewhere we will go when we die, but this is hearsay, of course, and just between us musing travelers, yes?%SPEECH_OFF% | The man sips at a drink from a cup of unknown make and material. He smells the drink and sips it again before setting it down and stretching out.%SPEECH_ON%You know, I somewhat look forward to the end of my Gilded path. It has been good to me, all these years, but I can tell that I stride between the withers of this horrible world and the sooner I can make my leave the better. I have the notion that if I stick around too long then the world is going to find out I slipped by, receipt in hand, and have been getting away with a good life while I supposedly got suffering on the docket.%SPEECH_OFF%You ask him why he thinks this. He shrugs.%SPEECH_ON%Instinct. You got it too, Crownling, this I have no doubt. After all, how do you make it so far when others, just like you, trundle into terrors and horrors and, eventually, death? There\'s a ticker somewhere in this world, a great accountant, perhaps it is the Gilder, perhaps it is something else, but life is not meant for unending good. At some point, eventually, there\'s gonna be one big, bad moment.%SPEECH_OFF% | Once you settle down, the old man leans back as though you were an old friend and begins to talk.%SPEECH_ON%It\'s interesting to me to see you here, Crownling, dressed in the regalia of brigandage as it were. Here are, simple men in simple times. But I take it you\'re as aware of a much greater past as I am. The sense that there was a long, long time of events that came before us.%SPEECH_OFF%You nod. It seems obvious. The man nods back.%SPEECH_ON%That is good. It shows an inquisitive nature to your side, even just in recognizing that there was much that walked these sands before us both. Many... many do not even take this into consideration. They live in the here and now. In some ways, I envy them. How it must be to exist as oneself and only oneself with the whole world beneath your feet.%SPEECH_OFF%He lays back and stares up at the sky.%SPEECH_ON%I think most people don\'t really believe they\'ll die.%SPEECH_OFF% | You set down and the old man leans back with a book in hand that is part scrolls and part binding. He reads, occasionally looking up. You have no idea if he\'s speaking from the text or if his nature is capable of holding two different studies at once.%SPEECH_ON%Did you know how it is the Ancient Empire was felled? They say it was a great blast from the earth itself.%SPEECH_OFF%He mimics with his hands an explosion from the sands.%SPEECH_ON%A volcano. But that seems far too simple, doesn\'t it? One volcano wipes out the entire empire?%SPEECH_OFF%You remark that the best sellsword you have could be crippled with a small nick to the back of his heels. No longer able to walk well, turn, pivot, or put weight on his feet, he\'d fall apart from the bottom up. The old man stares at you.%SPEECH_ON%Hmm, that may be right then. Perhaps this volcano obliterated what little grasp this empire had on its own control. After that... who knows what happened. Chaos, presumably. That sweet little thing.%SPEECH_OFF% | You set down and the man begins to speak almost immediately.%SPEECH_ON%I\'ve heard rumors of a cult running about. Something about \'Davkul\'. Well, I will say this: they\'re an earnest sort by the sounds of it.%SPEECH_OFF%You ask if he has any knowledge beyond just rumors. He shrugs.%SPEECH_ON%Only that is a cult of death and it did not originate here. At least, you\'ll never hear a southerner admit to this Davkul creation starting here. No, no, must have been those scoundrels to the north to come up with such a gruesome idea as this death god.%SPEECH_OFF%He grins whimsically. You take it he has no real skin in the game with this topic and only threw it out there to see your response. | %SPEECH_ON%Yes yes, have a seat already.%SPEECH_OFF%You sit down and the man begins speaking immediately.%SPEECH_ON%One of the strange natures of the desert is that will both preserve and erase all things. Do you understand what I mean? If you were to die, the sands would swallow you whole, but you, your body, would never really disappear. It would be submerged. If we were to start clawing our way into the desert around us we would surely find bodies and treasures and some say even entire cities.%SPEECH_OFF%You wave off the notion, but the man raises a finger.%SPEECH_ON%Tsk tsk tsk, don\'t be so dismissive, Crownling. This is a hungry world and, may my path be Gilded, it is entirely possible that all these cities we know today will soon be gone.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "May your path be ever gilded.",
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

		if (currentTile.SquareCoords.Y >= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				return;
			}
		}

		this.m.Score = 10;
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

});


this.dead_bodies_on_road_event <- this.inherit("scripts/events/event", {
	m = {
		Hunter = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.dead_bodies_on_road";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_02.png[/img] {A wagon, tipped over. Dead horses by its side. One dead donkey with evidence of having put up a fight. Women. Children. A couple of older men. Most mutilated in a fashion unsuitable for being found by anyone, but you figure your company was probably the best fit to come across such ruin. You\'ve got the stomach for it, for you have created worse. It is the innocence of the dead that turns the gut, though, and in a feeble effort to rectify that moral illness you go ahead and bury the dead. Sadly, nothing of value is found in their remains. | Blood in the ditch by the side of the road. Blood all across the road. Blood in the ditch on the other side of the road. Blood up on the canvas of the wagon. Blood in the dead\'s eyes and blood in their mouth. One poor farmer, deceased, seemingly happened upon by a band of thieves for nothing of value he carried remains in the ruin you\'ve stumbled upon. | The birds were the first hint: cycling and turning over a distant calamity. You figured whatever they saw was still alive, but by the time you got to it the flock had landed and you stumbled across a dead man leaning up against a sidepost.\n\nYou try and scare the birds away. The black buzzards only hop a few steps in the opposite direction where they then turn to stare at you. The corpse is fresh, the means to its death a slow one: a few arrows stick out of his side. A rope on his hip suggests he had a purse there. Someone robbed him - twice. | You stumble across a few hanged criminals. They swing from a tree by the side of the road, their faces mere impressions beneath the woolsacks over their heads. A few of them show signs of torture: gashes here and there, the glaring muscles turning purple and some already grey. Blood beneath one\'s feet, suggesting someone had a go at him while he suffocated. Naturally, they have nothing of value so you get back on the road. | A goat with a bell cradled in the arms of a dead shepherd. You found the pair by the side of the road. The animal\'s throat is open, and the man\'s body has no wounds. Maybe he died of a broken heart. %randombrother% rifles through the dead man\'s pockets and comes up empty handed. You decide to leave the two where they were. | Two buzzards clasp a string of intestine between the two of them, slowly chomping it down until their beaks clack together. You\'d be humored if it weren\'t for where this meal had come from: a dead child, he or she lying face down on the ground. The back had been torn away, a lurid ribcage glistening in the sun.\n\nYou scare off the birds - though they are quite reluctant to be scared at all - and then bury the body. Moving back onto the road, you see the two birds squatting over the grave, picking and prodding at the dirt {in some sort of avian angst | as if to somehow recreate the process they\'d seen but in reverse}. Giving up, they eventually take flight, circling above your band of men for a mile or two before heading elsewhere. | The fires crackle and pop as they consume the last of the wagon. %randombrother% picks through the blackened mess, but comes up empty handed. A few hands can be found sticking up out of the ash and soot, their forms as equally black. The bodies are completely gone, buried or burned away or buried beneath that which was burned away. Seeing as how there is nothing to salvage, you quickly get the company back on the road. | A dead horse. Its rider is across the road, having crawled to his final resting spot. Broken arrows litter the path, the heads of them ripped off and salvaged. The man is missing his scalp, the cap of his head glinting and red. After a quick search you realize there\'s nothing here to take and decide to move on. | You come across a pile of naked bodies by the side of the road. Some of them look ghastly, as though they\'ve been dead for a great long while, though rather fresh blood is in some of their mouths. A few of the corpses carry color in their flesh, but they have what look like bite marks here and there. Preemptive measures were taken, it seems, for every one of them has had his or her neck slashed. Naked as they are, you naturally find nothing but what is natural to nature itself. You move on. | You feel as though you are being stared at and stop, quickly turning to the side of the road with a hand on your sword. A head stares back at you with its eyes barely peeping over some grass. %randombrother% walks over and picks it up. The face carries the visage of a rather jarring death, being so slackjawed and slanted. You tell the sellsword to put the head down for you\'ve better things to do.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rest in peace.",
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local myTile = this.World.State.getPlayer().getTile();

		foreach( s in this.World.EntityManager.getSettlements() )
		{
			if (s.getTile().getDistanceTo(myTile) <= 6)
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

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});


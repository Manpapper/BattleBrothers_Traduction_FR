this.goblin_land_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.goblin_land";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 16.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_46.png[/img]{You find a dead goblin. But it\'s no ordinary goblin - this is an elder. He or she\'s showing signs of dying of old age. There\'s also ceremonial trinkets all about it. This here goblin didn\'t get here by accident: it died and received a proper burial. Which means only one thing: you\'re in those damned greenskins\' territory. | You come across a dead dog on a hillside. Its tongue hangs out, its eyes almost ready to pop from the skull. A number of darts are sticking out of its fur. %randombrother% plucks one and looks at the tallowed tips of metal.%SPEECH_ON%Goblin poison.%SPEECH_OFF%You inquire as to why the dog, though. The man shrugs.%SPEECH_ON%A scared dog makes for good target practice, I suppose.%SPEECH_OFF% | A wreath of odd and discolored flowers, weeds, and tree limbs. Amongst them, dozens of large beetles rattle as their shells bump into one another. They seem to be feasting on the sap or other oddity seeping from the vegetative collection. %randombrother% wonders aloud.%SPEECH_ON%I think I\'ve seen one of these before. It\'s some sort of marking.%SPEECH_OFF%You glance at him.%SPEECH_ON%We need to be keeping an eye out for bored spinsters or something?%SPEECH_OFF%The man shakes his head.%SPEECH_ON%Naw. This here is a goblin\'s fabrication. We\'re in their land now.%SPEECH_OFF% | While marching through the land, you come across a dead orc. He seems almost unhurt, as though you\'d stumbled across him sleeping. But when you get a closer look, you spot almost a dozen small darts sticking out of his side. You immediately get a good look at your surroundings, then turn to your men.%SPEECH_ON%Step carefully, men, we\'re in goblin territory now.%SPEECH_OFF% | You find a number stones arranged into a circle. In the middle of this oddity is a human skull with its top cut away. Inside the brainpan are a number of what appear to be dice and chicken bones. Such shamanistic designs aren\'t found by accident - you\'re in goblin lands. | You come across a dead deer ensnared by a horrifying trap. It would have all the markings of an ordinary trap - one that intends to kill via spikes - were it not for the obvious poison tips it came laden with. Poison that is unique to one group only: goblins. Best step carefully from now on. | A smoldering fire. Sticks and stones arranged for this or that. One standing armory stocked with blowguns. Curved blades. And one dead wolf pup with a leash around its neck. Having observed this evidence, you quickly inform the men of what circumstances are before them.%SPEECH_ON%This is goblin territory, men, and by the look of things they aren\'t far, either.%SPEECH_OFF% | A litter of dead wolf pups. Their open-bellied mother is by them, a collar around her neck. There\'s a line of gore trailing away from the scene, some tiny footsteps in the grass.%SPEECH_ON%The goblins been gettin\' more of their mounts.%SPEECH_OFF%%randombrother% is by your side. He points at the pups.%SPEECH_ON%They say the gobbos like the wild ones. They look for the freshest litters and only take the strongest.%SPEECH_OFF%All you\'re hearing is that you are in goblin territory. You advise the men to keep a close eye on their surroundings, lest the tricky gits get the drop on you.} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Be on your guard.",
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
		local myTile = this.World.State.getPlayer().getTile();
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (s.getTile().getDistanceTo(myTile) <= 10)
			{
				return;
			}
		}

		local goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements();
		local num = 0;

		foreach( s in goblins )
		{
			if (s.getTile().getDistanceTo(myTile) <= 8)
			{
				num = ++num;
			}
		}

		if (num == 0)
		{
			return;
		}

		this.m.Score = 20 * num;
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


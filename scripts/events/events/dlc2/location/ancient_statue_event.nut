this.ancient_statue_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.ancient_statue";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_116.png[/img]{A golden man the size of a castle sits atop his stone throne with such august stature it seems even he, as inanimate as he is, should rule the land. And perhaps the world would be better for it, this nonspeaking entity with such awesome presence would make a finer ruler than the lot of skunks you constantly run into. The bulk of the statue rests upon an enormous disc made of spiraling square stones. Were they coffins it\'d take all of two bricks to store the %companyname% whole. %randombrother% tilts his helm up.%SPEECH_ON%If it ain\'t the biggest thing I ever seen I don\'t know what is.%SPEECH_OFF%%randombrother2% smirks and makes a reach for the sellsword\'s crotch.%SPEECH_ON%I thought the womenfolk said that little worm was the biggest thing to ever seen!%SPEECH_OFF%As the company laughs, you step forward and look up. You\'re not much for kneeling, but you feel the urge here. The statue\'s staring out at the world with firm authority, and its hands are out at the sides, one upon a sword staked into the earth, and the other supinated as though to weigh justice herself. You nod at the golden sheen present before you. That there is not a single scratch of a wouldbe robber suggests its austere presence still has some ethereal grip on the world. But that doesn\'t make sense. Any smart man would be nicking a fair share from the statue\'s shins alone. A few mercenaries ask if they can have a stab at collecting some gold for themselves.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "There\'s no harm in it.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_116.png[/img]{The statue is so huge perhaps it scared off the lesser scapegraces by superstition alone. You\'ve no reason to let a good thing go, like a nearly endless pile of gold shaped into something \'pretty.\' To hell with history and the artistry. You tell the men to have it. They leap to the task with the tools available, but the second %randombrother% makes contact he falls limp and slumps against the statue. Another mercenary goes to help him, brushes the enormous toe there, and collapses atop the sellsword. Just as the company begins to panic, the two mercenaries bolt back to their feet and start screaming about amazing sights, sights beyond this world, sights of the future itself!\n\n Invigorated by this, the company gladly runs themselves into the statue, the lot banging against its giant toes and falling backward like mimes unexpectedly finding a very real wall. It\'s the most ridiculous thing you\'ve ever seen, but each man springs back to his feet spilling out fantastic stories. You shrug and walk up to the statue yourself, standing before the big toe with its big toenail. The men urge you forward. Sighing, you put your hand out and touch the toenail. Nothing. Nothing happens. You fist the gap between the nail and golden flesh. You angrily put both hands to the toe like it owes you money. Nothing. Well then. Looks like you\'ve riches to harvest. You draw your sword out...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Time to strike gold.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_116.png[/img]{You swing the sword but the second steel touches gold the sheen of the world flashes over you as though you\'d struck the sun itself and drew blood. The sword continues on into the darkness like a star across the night sky and it cuts a world of its own into reality, as though you\'d slashed the magician\'s cloth off his trick, revealing a room with pillared corners and beautiful silk curtains, and the sword continues on until it slams against a spear shaft. You look down to see a man with gilded armor and red eyes holding his guard with a grimace. He slides across the tiled floor to his right and lets your momentum fall to the ground, then he twirls the spear around his back and strikes it forward. You throw your arm wide and close rank with the killer, catching the spear shaft beneath your armpit and driving forward to stab him just beneath his pauldron, driving the sword into the heart. The man\'s red eyes drain to a pure white and he goes limp and slides right off the steel.\n\n As he clatters to the ground, you quickly look around. Against the far wall stands an enormous bed with corners of marble, each statue shaped to a woman or man, each of them adorned submissively to what looks like a rising sun. There\'s an elderly man in the bed who is looking at you. Bearded. Eyes dim, weathered. Familiarity in his stare. He smiles, but it quickly fades. He yells, but you don\'t understand the words. A shadow slides across the room and you wheel around to see a large knight with fire in his eyes bearing down with a two-hander.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Parry!",
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_116.png[/img]{You step back and flip your sword crosswise and crouch at the knees to brace for impact. The killer\'s two-hander slams against your sword and just like that the world snaps away and still frozen in a parry you can feel the issuance of time and space fly by your sides like a plow wind, and ungodly amounts of suffering, screaming, living and dying, and in the far distance a speck of light that fast approaches until you arrive back in your body and your sword hits the statue and swings backward so hard it flies out of your hands and sails through the air until stabbing into the earth with an earthen chunk. The men look about one another. You go and fetch your sword.%SPEECH_ON%I think you broke it, sir.%SPEECH_OFF%Says %randombrother% as he gets handsy with the pinky toe. You tell him and the rest of the men to pack their things, it\'s time to leave this place. Looking at the statue, you see that it is all rusted bronze now. You think to ask one of the mercenaries if it had been gold earlier, but you already know the answer to that. Instead, you stare at the head of the statue. At the face. At the very familiar face.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s not dwell on this.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.5, "Impressed by a magnificent statue of old");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
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


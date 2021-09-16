this.monolith_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.monolith_destroyed";
		this.m.Title = "After the battle";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_101.png[/img]{%SPEECH_START%It\'s disappointing.%SPEECH_OFF%%randombrother% says as he looks at the slain corpses. He snorts and spits.%SPEECH_ON%Don\'t think disappointing is the word for it, though. They\'re just lying there, bones and coats, like we\'d fought a closet. No flesh, no blood. It\'s unsatisfying. And knowing that, thinking it true, well that unnerves me.%SPEECH_OFF%You got nothing to say to such things other than there\'s a kernel of truth in the matter. If it weren\'t the issuances of its lust, why else the vigor for violence? Another sellsword calls you over, interrupting any solemn introspection.%SPEECH_ON%Sir, come have a look.%SPEECH_OFF%You head over and spot a skull sitting in the bed of pauldrons like an egg in the bosom of a well-endowed southerner. The rest of its body is battered and thrown to the winds as far as you can tell. What remains is a decadent slab of chest armor. It is covered in glyphs and treatments, fortunes and historical retellings, and is embroidered with red tassels and combs made of bristly hair. You touch the metal and the second you do the skull beside it powders and blows away. The mercenary seeing this shrugs rather sheepishly.%SPEECH_ON%If you got magical powers I won\'t tell no one.%SPEECH_OFF%You slug the sellsword in the shoulder and tell him to the load armor into the inventory for later allocation.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I should take a closer look at that armor.",
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
			Text = "[img]gfx/ui/events/event_101.png[/img]{As the men pack up to leave, you hear a voice behind you.%SPEECH_ON%...never were...%SPEECH_OFF%You turn back and the world darkens in a shrouded tunnel, your men and their voices fading into the dark until all that remains is an elderly man and a light at the end of all that black, an unsteady flicker and a warble of flesh trying to hold it. You approach slowly, getting bearing on the speaker. It is a shrewd, elderly man, bent at the waist and bent again at the back, and his arms are thinner than a sword\'s hilt. You look back to see the world of dark had followed you forward, nothing behind but blackness. Looking forward again, the man is suddenly before you. He looks so similar, like someone you had seen in the past and yet had forgotten, perhaps someone you had seen in your childhood, a dying uncle glimpsed on your fourth winter and his last. He is holding the candlestick with the wax drooping over his knuckles and rolling down his wrist.%SPEECH_ON%You never were meant to be... never were... never were... never were meant to be, you, the one they call the False King%SPEECH_OFF%You wake on the ground. A mercenaries are looking down at you with concerned stares.%SPEECH_ON%Uhh, you alright captain?%SPEECH_OFF%Getting up, you tell them that you were just fell into a quick nap. You look back at the Black Monolith and you can see yourself in the obelisk\'s reflection, and it is your reflection alone.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'m alright.",
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


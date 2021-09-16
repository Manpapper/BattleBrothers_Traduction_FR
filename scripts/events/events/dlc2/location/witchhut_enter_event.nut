this.witchhut_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.witchhut_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{You pause at the forest clearing. The hut before you stands like a mere crumb. It\'s so quaint and easily forgotten you wondered how it could survive, but perhaps its total banality and unassuming nature is itself a sort of armor. But you\'ve been around this world long enough to know to trust your instinct, and right now your instinct is to wait.\n\n Soon enough, the hut\'s door pops open and an elderly woman hobbles out. She immediately waves in your direction.%SPEECH_ON%You, and only you.%SPEECH_OFF%Confused, you ask why just yourself, or more particularly why would you ever trust her to begin with. She smiles.%SPEECH_ON%Because I know what the False King dreams of at night.%SPEECH_OFF%The mercenaries around you turn about and ask what she said. You put a hand up and tell them to stay their ground while you go have a talk with the mysterious woman.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Stay here and stay on guard.",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{You come in with your sword drawn just to find the woman offering you a bowl of stew. She suggests it is only rabbit and potatoes, and more the former than the latter. Sheathing your sword, you take the bowl and have a seat at a table with her opposite you. A couple of candles burn nearby, and there are glyphs painted on the walls in white, and similar shapes hang from the ceiling as dreamcatchers. The woman puts her elbows on the table. There are trinkets wound into her hair, clips of bird bones and feathers. She carries a weathered face, though her eyes are starkly young like pearls glimmering from the depths of a swamp.%SPEECH_ON%I knew you would come in, a phantom of a friend, like a moth to the flame, seeking truth which cannot be tamed.%SPEECH_OFF%Pushing the bowl back across the table, you ask if she is a witch. She nods affirmatively and stares at you before nodding again.%SPEECH_ON%Good. You haven\'t killed me which means you\'re thinking now. I am indeed a so-called witch, but I am alone. Entirely alone. And hounded by the others. You might call them my \'sisters\', but these others know who you are, just as I do, and they want your blood. They can smell it and that is why I want to talk.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What is it you want?",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{The woman draws a long object wrapped in table cloth and sets it on the table. She throws back its linens to reveal a jagged obsidian blade with a leather strips for a grip.%SPEECH_ON%Cut your flesh and bleed upon the black. The hexen and their lowly craft shall come, and then you shall kill them all. After that, we can talk. Sellsword and witch, witch and sellsword.%SPEECH_OFF%You ask what is in it for you. The witch cackles.%SPEECH_ON%Oh sellsword, you are not in the business of allegiance, but in the business of gold, and with a clever turn of coin you know friend can turn to foe. But I offer something more. A truth which cannot be seen, a truth for the False King.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ve already come this far.",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{The black blade rests in your hand, and your reflection rests jaggedly in its stony grooves, stretched and pulled into every divot and edge. Tis a simple stone. A simple dagger. That is all. Not the least bit heavy, but you can feel the import, like dust tossed upon a grave, there is not so much weight in the sand as there is in the throw itself. This blade is either loss or gain and there\'s only one way to see to which. The witch nods. You nod back and slash your upper arm. The blood pools onto the stone and your reflections disappear beneath the crimson. Almost growling, the witch eagerly leans in and presses the blade against the skin.%SPEECH_ON%More. More, sellsword. More!%SPEECH_OFF%You slash again and flex. A spurt hits the stone. She takes the knife and slaps a spotless cloth onto the wound.%SPEECH_ON%Well enough, sellsword. Go to your men and prepare.%SPEECH_OFF%You stand and look at the woman. You ask.%SPEECH_ON%And once I kill your enemies, then we talk again?%SPEECH_OFF%She smiles.%SPEECH_ON%In so many words, yes.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Then I will do so.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_115.png[/img]{When you step outside and inform the company that hostiles are coming. Soon enough, the haggard women are spotted walking between the trees of the forest, their long fingernails scratching across the bark and their drooling lips sniveling up to snort and cackle. The first to come through has a long head shaped like a canoe. An infant\'s skull dangles from her necklace, and a leather bag bounces at her hip, two rabbit feet sticking out of the pouch. She glares at the hut and sniffs the air, then shifts her eyes upon you.%SPEECH_ON%Ah, you have made covenant with that bitch?%SPEECH_OFF%You nod.%SPEECH_ON%The deal\'s been made, aye, and it will end with you dying on the end of this blade. And I believe she prefers to just be called \'witch.\'%SPEECH_OFF%Another hexen steps forward.%SPEECH_ON%We prefer to call her cunt. Kill the sellswords. Take the captain alive, but remove his eyes and that lousy tongue.%SPEECH_OFF%The throng of witches rush forward, some already shifting into licentious looking younglings while others revolve their arms in ritual rites.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To battle!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
						}

						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Events.showCombatDialog(true, true, true);
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


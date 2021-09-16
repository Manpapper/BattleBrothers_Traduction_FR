this.waterwheel_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.waterwheel_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_109.png[/img]{The waterwheel totters at the hinges as its buckets dip and draw water. Attached to its side is a stonewalled abode with a chimney piping bulbs of black. There are pelts and traps hanging outside on the walls, and an oaken chair sets on the porch. Its windows are too blurry to look through, but you can hear the mill inside rising and churning with wooden groans. Drawing your sword, you step up to the porch and open the door.\n\n A man welcomes you in the first and only room there is. He\'s standing beside the mill well, running his hand through the grains. He is an elderly fellow yet of modest stature, as though time had no warrant for his posture or abilities. There is a sword hilt hanging above the fireplace. Its glint is unmistakably rich and the old man regards your stare with a warm smile.%SPEECH_ON%Only those who are worthy may have the hilt of the %weapon%. You, stranger, are not.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This old man ain\'t stopping me.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "What would make me worthy?",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_109.png[/img]{You step forward and threaten the man to stand aside or face your steel. He waves his hand and your feet leave the ground. A rush of wind slams you against the wall with such force you hear silverware clattering and dust streams down from the ceiling. The old man looks at you as calmly as the second you walked through his door.%SPEECH_ON%Only the worthy. Do you understand?%SPEECH_OFF%There\'s no other answer here than to nod in agreement. The old man\'s hand goes to his side and you fall to the floor. You pick up your sword, making sure he understands you\'re only sheathing it. You ask what would make you worthy. The old man smiles again.%SPEECH_ON%My only son was worthy. He left to fight the great beast. Avenge him and ye shall be worthy.%SPEECH_OFF%You\'re shunted from the home and the door slams behind you. Seems you have a quest, though you\'ve not even the faintest notion of a compass\'s northern point to know where to go with it.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll have to resolve it ourselves.",
					function getResult( _event )
					{
						this.World.Flags.set("IsWaterWheelVisited", true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_109.png[/img]{The old man stares into the mill. His hand rises up and a swarm of grain revolves around his fingertips like bees around the buds of sugarcane.%SPEECH_ON%My only son departed to slay the great beast. His squire returned the hilt to me, but the blade was gone. Avenge my son, and you shall be worthy yet, stranger.%SPEECH_OFF%You ask where the beast is and the man puts his hand into the millwork again.%SPEECH_ON%If only I knew. I trust you will find out, sellsword.%SPEECH_OFF%Your feet suddenly slide back across the floor and to the porch and onto the grass. The door slams in front of you and won\'t be opened again. Seems you\'ve unwittingly taken up a quest, or perhaps one to keep on the side.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll have to resolve it ourselves.",
					function getResult( _event )
					{
						this.World.Flags.set("IsWaterWheelVisited", true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{The elderly man is already waiting for you when you enter. He turns rather rapidly as though interrupted.%SPEECH_ON%So you have returned! And have you succeeded? Have you avenged my boy? Are you, sellsword, worthy?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Would this make me worthy?",
					function getResult( _event )
					{
						return "C2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{The waterwheel totters at the hinges as its buckets dip and draw water. Attached to its side is a stonewalled abode with a chimney piping bulbs of black. There are pelts and traps hanging outside on the walls, and an oaken chair sets on the porch. Its windows are too blurry to look through, but you can hear the mill inside rising and churning with wooden groans. Drawing your sword, you step up to the porch and open the door.\n\n A man welcomes you in the first and only room there is. He\'s standing beside the mill well, running his hand through the grains. He is an elderly fellow yet of modest stature, as though time had no warrant for his posture or abilities. There is a sword hilt hanging above the fireplace, and its glint is unmistakably rich and the old man regards your stare with a warm smile.%SPEECH_ON%Only those who are worthy may have the hilt of the %weapon%. Only those who avenge my son and bring me his blade will be worthy. To do that, you would need to find the beast.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Would this make me worthy?",
					function getResult( _event )
					{
						return "C2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{The blade of the %weapon% vibrates and hums. You hold it forward in both hands, the steel wobbling ever so slightly on your fingers. Smiling once more, the elder nods and turns his hand to the hanging hilt. It lifts up off its holder and floats across the room to your hands. There it turns aside and melds with the steel, becoming whole with a flash of orange and blue. It is one of the most incredible blades you\'ve ever seen with glyphs of moons and stars flaring along the fuller. When you look up, you can see through the elder\'s chest as he steadily fades away.%SPEECH_ON%My son has been avenged. His spirit can rest, and now so can mine.%SPEECH_OFF%You watch as the finished sword lifts into the air and rotates with the steel pointed down. The cupboards burst open and strips of leather fly out and clasp shots of bindings that draw together to complete a sheathe.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'ll take it.",
					function getResult( _event )
					{
						return "D2";
					}

				}
			],
			function start( _event )
			{
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.legendary_sword_blade")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose a " + item.getName()
						});
						break;
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{The %weapon% then falls and you reach to catch it, but a ghostly hand steals it away. You look up to see the elder unsheathing the blade, revealing its fire and ice as though he brokered a new day and gloomy night in the very spectrum of its steel. He chokes with laughter.%SPEECH_ON%\'Avenge my son!\' \'Be worthy!\' Idle doings for simpletons. You did well to chase the carrot, sellsword, and for that I will kill you quick.%SPEECH_OFF%Pauldrons and bracers and a chest plate rise out of the mill well, sheets of grain streaming off them to reveal their garish shapes, and the metals twist and float to the elder, fiercely striking his body as though they meant to armor the very anvil that helped craft them. The suit of steel comes together as its occupant croaks with laughter. Hands grab you by your shoulders and drag you out of the house. You are shielded by the %companyname%. The elder geist turns his head.%SPEECH_ON%A mob of morons, is it? Depart, the lot of you, and you shall be spared. I only ask that you leave me the captain as I have already promised his demise.%SPEECH_OFF%%randombrother% draws his weapon and the rest of the company follows suit. The elder holds up the crepuscular sword in return. Though the steel is firmly real, the elder\'s body is rippling to and fro like a thinly veiled curtain on a moonlit night. He sighs and parts of blue ether drift from his lips. He turns the blade so its edge faces you.%SPEECH_ON%So be it.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To battle!",
					function getResult( _event )
					{
						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID());
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
		_vars.push([
			"weapon",
			"Reproach of the Old Gods"
		]);
	}

	function onDetermineStartScreen()
	{
		local hasBlade = false;
		local hasBeenHereBefore = this.World.Flags.get("IsWaterWheelVisited");
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.getID() == "misc.legendary_sword_blade")
			{
				hasBlade = true;
				break;
			}
		}

		if (hasBlade)
		{
			if (hasBeenHereBefore)
			{
				return "A2";
			}
			else
			{
				return "C2";
			}
		}
		else
		{
			return "A";
		}
	}

	function onClear()
	{
	}

});


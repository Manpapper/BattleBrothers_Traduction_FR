this.ancient_temple_enter_event <- this.inherit("scripts/events/event", {
	m = {
		Volunteer = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.location.ancient_temple_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_111.png[/img]{Only half of the temple\'s entrance is visible, the rest long since sunk into the earth as though unsure whether to be coffin or mausoleum. Along a visible frieze you can see a stony relief of tables being thrown and monied men running from what looks like an armored skeleton with a whip. A few of the mercenaries seem uncomfortable with the idea of going in, but you\'ve the notion that others have felt that way as well and have thus left the place unmolested.\n\n You take out a torch and enter with a sellsword\'s spirit and robber\'s resolve. After gathering supplies, you crouch and enter the temple by slinging your legs over the earth and jumping into the steps below. The clap of your boots snickers into the marbled halls and you wave the torch before you as if to watch the echoes go. Looking back, the light between the shelf of earth and the temple top silhouetting your company as though they were a throng of sextons satisfied at their work. %volunteer% shakes his head and says he\'s coming with. The rest of the company mutually agrees to keep watch.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll go in.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Forget those ruins, we\'re moving on.",
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
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_111.png[/img]{The sides of the halls are blanketed in military mosaics so large they\'re more fit to a whole campaign than any single battle. One parcel in particular stretches seemingly forever down the hall, a scene of armored men running roughshod over what looks like a barbarian horde so thick in number they lose humanity and begin to look indiscernible from bugs. Your torch bulbs and dims in the dark, the light bringing an artist\'s battlefield to an orangish life and in the corners you find depictions of righteous torture and outrage. Between the lockstep forces and the disassembled mob, it looks like order and chaos have come to clash, and while order is surely set to win, it is chaos itself which is driving the way to victory.\n\n %volunteer% whistles. You look to see his torch flaring in the distance like an ignis fatuus. You run over to find him holding a vial with a strange liquid inside. The sellsword swings his torch to an alcove in the wall. A marbled post hold the center and there\'s a throng of skeletons at its base.%SPEECH_ON%I found the vial on the pedestal there. And I see two more like it yonder, but they\'re behind gates.%SPEECH_OFF%You ask the sellsword why he didn\'t tell you about the bodies. He shrugs.%SPEECH_ON%They ain\'t breathing, then I ain\'t caring. You wanna make a try for the other two flasks or no?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s do it.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
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
			Text = "[img]gfx/ui/events/event_111.png[/img]{You find the next vial set behind a chest-high gate. The flask itself is grasped by the stone claw of a wingless gargoyle hanging down from the ceiling. There are a few glyphs on a slab in front of the gate, but the words are ancient and even if they weren\'t you\'re not sure how well you\'d be able to read them anyway. Suddenly, a voice booms overhead.%SPEECH_ON%A flock of birds are in a field when a hunter comes along. The hunter draws an arrow and yells out as though in pain. A few birds fly up. The hunter kills them. More birds fly up, the hunter kills them just as well and he begins to cry as he collects their bodies. More birds fly at the sound of him. The hunter\'s crying and killing. He can hardly nock arrows fast enough and he has to pause to wipe his eyes. One bird turns to his friend and says he should go console the man. What does the bird\'s friend say in return?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nevermind his tears, watch his hands!",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "From the brink a broken man must be saved.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Chirp. Chirp chirp chirp?",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "What?",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_111.png[/img]{The voice is silent for a moment, then returns.%SPEECH_ON%Correct!%SPEECH_OFF%Jolting with ancient engineering, the gate slides down and the gargoyle lowers within arm\'s reach, the vial\'s rigid guardian staring with stoic aplomb. You grab the vial and hold it close as though the monstrous stonework might come alive to take it back. You wave your torch around and demand to know who is speaking. The voice laughs, but that is all. %volunteer% looks at you and shrugs.%SPEECH_ON%Well, we got the treasure did we not? No harm in trying for another.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Might as well see.",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Seems dangerous. Let\'s get out now.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_111.png[/img]{You shake your head no. The first vial was circumstance, and probably the end result of another robber\'s failure. You were lucky. The second vial comes attached with a voice that asks you nonsensical shite. That\'s enough. You order %volunteer% out of the temple and you quickly depart with the two vials and the common sense to find happiness in that alone.\n\n Outside, you find the %companyname% kicking and poking at a corpse still freshly leaking. They say the man came running out of the temple while you were down there. One mercenary produces a scrap of paper. Drawings on it depict the vials, and they show the liquids expunging wiedergangers like molten metal poured on an ant. %volunteer% laughs.%SPEECH_ON%Well I guess that explains what these are for.%SPEECH_OFF%Nodding, you ask if the dead fella had anything else on him. Another sellsword shrugs.%SPEECH_ON%He walked up out where you went in. He said \'an armed man, a steel companion, for you I have a riddle\', and then I cut him down. He seemed a dangerous sort.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Probably the best way to answer a riddle yet.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_111.png[/img]{The last vial is behind another gate, an unsettling one to look at just by an architectural standpoint. There are not mere stone bars here, but twisted iron spires scarred with scoria and slag, and the gate is not at chest level, but at your shins. The vial itself is on a further rise, meaning you\'d have to reach under the wall and then up again to get it. The voice returns.%SPEECH_ON%From me all comes to being, from me all shall be in the end. When man crosses the earth, I follow in his footsteps.%SPEECH_OFF%You stand in the silence and look over at %volunteer%. He shrugs.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dust.",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Go fark yourself!",
					function getResult( _event )
					{
						return "I";
					}

				},
				{
					Text = "Help me kick in that gate, %volunteer%!",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_111.png[/img]{As soon as the word leaves your lips the gate jolts up. You pensively stare at the remaining gap. %volunteer% crouches down and slings his arm under the gateway\'s top and gets up at the vial. His fingers scrape its glass while the gate\'s spires rattle in their catches like a bear reluctantly letting someone brush its teeth. The man finally pinches the vial between two fingers and scissor-flips it into the safe embrace of his palm. He stands up and hands it over.%SPEECH_ON%Simple enough, eh?%SPEECH_OFF%You nod but then turn around with your torch and yell out, demanding to know who was talking. There is no answer. A brief search in the darkness turns up no hidey-holes or dugouts, but you do find scraps and notes with drawings on them. The pages seem to indicate the vials are capable of killing wiedergangers with but a single touch of the liquid within each flask. There is also a sticky paper with a crudely drawn woman on it. Whoever was here, you don\'t care. You take the vials back out and return to the %companyname%. They draw swords at the sound of you, then sheepishly sheathe them once they see your face.%SPEECH_ON%Sorry captain, thought ya a mite dead. And walking. A walking dead man.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, we got vials for just that problem now.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_111.png[/img]{As soon as the word leaves your lips the gate jolts up. You pensively stare at the remaining gap. %volunteer% crouches down and slings his arm under the gateway\'s top and gets up at the vial. His fingers scrape its glass while the gate\'s spires rattle in their catches. The voice suddenly booms back in.%SPEECH_ON%G-go fark myself? How about fark you, uh, pal!%SPEECH_OFF%With that, the gate\'s catch fails and its tips sink down and spear %volunteer%\'s arm. The man yells out and you drop to your knees and yank the gate back up. It\'s heavier than expected and when you let go it slams with unnerving finality, a strip of the sellsword\'s arm here, a gush of his veins there. You wrap the wound and help the man toward the exit, all the while waving the torch around to ward off any would be ambush. However, while heading out, you pause and look at the skeleton\'s you found beside the first flask. You take a drop from the vial and touch it to your fingertips. No response. You then put your finger on one of the bones and it sizzles and smokes. %volunteer% laughs.%SPEECH_ON%That\'s why you\'re captain, sir. Intuition like that can take you far!%SPEECH_OFF%You never hear the mysterious voice again and, not wanting to sound insane, make no reference of the riddler to the %companyname%.\n\n %volunteer%\'s wounds won\'t be the end of him. Tis but a small price to pay for the ancient vials.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Glad someone else paid that price, though.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
				local injury = _event.m.Volunteer.addInjury([
					{
						ID = "injury.pierced_arm_muscles",
						Threshold = 0.25,
						Script = "injury/pierced_arm_muscles_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Volunteer.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Volunteer.worsenMood(1.0, "Got injured navigating an ancient mausoleum");
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_111.png[/img]{You\'ve had enough of this shit. If the voice is that of an ancient or that of some jester, you might as well find out fully. You take a step back and smash the gate with your boot. The rails crank into chevrons at the first strike, and snap apart on the second. Briefly, and rather squeakily, the voice returns.%SPEECH_ON%H-hey! You can\'t do that!%SPEECH_OFF%Clearing out the rusted pieces and the sharp spires, you crouch to look at the vial. Just then you see a man jumping down into the vial\'s tiny room. He lands like a baby deer falling off a cliff and knocks the flask from its hold. You watch it tumble to the floor with a pitiful, glassy crash. You grab the man by his foot and drag him out through the spines of the gate and all. He holds shaking hands before himself as %volunteer% presses a sword against his throat.%SPEECH_ON%I-I-I didn\'t mean nothing by nothing. I meant nothing at all. Just nothing.%SPEECH_OFF%You ask who he is. You ask if he killed those men at the first vial.%SPEECH_ON%M\'name\'s %idiot% a-a-and them there fellas ain\'t no skellies. They the walking dead, and then they sniffed that there flask and went down like drunks. Look, sir, I\'d not meant anything by nothin\'! Just having a bit of fun, that\'s all. I-I\'ll do anything for a reprieve! Well, almost anything.%SPEECH_OFF%He looks worried. You look at %volunteer% who shrugs.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, fine. You can join us.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return "K";
					}

				},
				{
					Text = "No, that\'s not happening.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return "L";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cripple_background"
				]);
				_event.m.Dude.getSprite("head").setBrush("bust_head_12");

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.Volunteer.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "K",
			Text = "[img]gfx/ui/events/event_111.png[/img]{The man\'s eyes gleam in the dark and each glance is like an ember scattered.%SPEECH_ON%Ya mean it? I can join ya? Alright!%SPEECH_OFF%He slowly gets to his feet as though quick action might lead to even quicker reneging. He puts a hand out, which you do not shake.%SPEECH_ON%My name\'s %idiot%. I\'ve got half a brain, rest is wood and pulp. I\'m kindling, of course. Kidding. Kindling. Get it?%SPEECH_OFF%You look at %volunteer% who stabs the man in the chest. The idiot\'s face goes tense as he looks down at the sword impaling his heart.%SPEECH_ON%Hey. I think you killed me.%SPEECH_OFF%%volunteer% nods.%SPEECH_ON%Aye. I did. You got seconds. Speech?%SPEECH_OFF%The riddler thinks briefly.%SPEECH_ON%Well, I didn\'t prepare one, but... since... ya... asked...%SPEECH_OFF%He dies on the word and the blade. The sellsword cleans the blood and picks through the body, finding only musty rat bones in his pockets. When he lets the corpse go it clunks the tile rather hollowly. You crouch and feel the man\'s skull and find he actually wasn\'t kidding, its half made of wood! You look at %volunteer% who shrugs.%SPEECH_ON%He could have shat gold for all I care, I ain\'t putting up with his mouth. Besides, look at his eyes! That fool was blind as a bat.%SPEECH_OFF%The riddler\'s eyes are a blank grey. Who knows how long he spent in this temple.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ah well. Two of the vials are ours.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "L",
			Text = "[img]gfx/ui/events/event_111.png[/img]{You\'ve no time for the idiot. You let him go and he runs off and you listen to his footsteps snickering through the dark like the flaps of a bat through a familiar cave. It\'s not long until you hear him making an exit, and no sooner does he get that far does the %companyname% cut him down in a series of hollers and one short-lived scream. By the time you surface you find the sellswords kicking the idiot\'s corpse and robbing anything worth having, which is mostly a pile of poorly written riddles.\n\n %volunteer% laughs and puts the seemingly magical flasks into the inventory. You order the men to get ready to head out again.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Still a successful go, all things considered.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Volunteer.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.Injury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Volunteer = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		else
		{
			this.m.Volunteer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"volunteer",
			this.m.Volunteer != null ? this.m.Volunteer.getNameOnly() : ""
		]);
		_vars.push([
			"idiot",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Volunteer = null;
		this.m.Dude = null;
	}

});


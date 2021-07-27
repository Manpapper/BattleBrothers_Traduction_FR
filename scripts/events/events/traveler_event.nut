this.traveler_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.traveler";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{You eye a traveler in the distance bobbing forth, slouched and crooning like a wingless gargoyle. His walking stick bobs and prods in front of him and even far away you hear the snicker and snacker of stones being tapped. You give an order for your men to hold and wait, letting the stranger come to you.\n\nWhen he finally nears, he looks up. At first, his nose is all that you see, the rest of him hidden in a cloak. He sniffs gingerly like a blind mole come across a bizarre impasse. Just as you begin to ask if the man is alright, he throws the cloak back, revealing himself. That which faces you is a tired figure. Hobbled. Sleepless days pinch creases about his eyes. Reddened cheeks spread as he smiles. He asks if he might stay with your party for a time. | A traveler hails your party from the roadside. He says he\'s on his way to %randomtown% but that he wouldn\'t mind a rest. The next question he has is an obvious one: he wonders if it\'d be alright to stay with your party for the night. | A traveler carrying a cart of personal goods heads your way. You let him approach, holding your hand up to warn him to go no further. He states that he is a simple wanderer and that he\'s only looking to get to %randomtown%. First showing that he is completely unarmed, he asks if maybe he can stay the night with your company. | A whistling man ambles down the road, a cheery dog huffing at his side with its tongue aloll. Seeing your troop, he stabs his walking stick into the dirt and tents his hands atop it. Some small talk is made of the weather, notably that rain is in the belly of some oncoming clouds. He asks if mayhaps he could dodge the rain in the company of sellswords. A strange request, not one usually made to men who earn blood money. | A man walks the road with a shovel bobbing over one shoulder and a sack of dirt swinging in the other hand. When you inquire as to what he is doing, he says he\'s just buried his brother and he\'s on his way back to %randomtown%. The sack holds some of the dirt where his kin was laid to rest. Respectable. The man looks weary, as weary as a man who has buried his sibling would understandably be. Perhaps sensing your pitying gaze, he asks if maybe he can stay with your company for a time. | You spot a strange man hobbling along the road. He\'s dressed in a long cloak and he\'s got a knapsack yoked over one of his shoulders. His eyes stare at the ground until they come to your feet at which point he finally looks up. Seeing your company, the man is surprisingly unalarmed. In fact, he\'s quite receptive of your presence and asks if maybe he could spend the night with sellswords before continuing his journey to %randomtown%. | A man with a pitchfork is crossing a field where the crops have failed. His feet scuff up the deadened ground and you see tufts of ash being pitched wind-wise. When he gets to the road, you hail him down and ask where he\'s coming from. The man is a daytaler only trying to get back home. All the work around here is dried up, literally. Licking his cracked lips, the man wonders if maybe he could stay the night with your company. He certainly looks like he could use some rest, anyway. | A man carrying a bucket of tools crosses paths with your company. The roads seem ill-fit to place one man against a company of sellswords, and this stranger appraises the situation correctly by placing his wares down and putting his hands up.\n\nYou tell him to calm and ask where he is going. He explains that he is a mason from %randomtown%, but that his work there is done. He\'s only on his way back to his family located on a homestead a good day\'s walk from where you stand. Looking rather thirsty and tired, the man asks if maybe he could spend the night with your company to help him rest for the coming walk. | A figure appears on the horizon, blurred and shimmering in a heat haze. It appears to have paused, no doubt having seen you, too. With little fear, you press the men onward and soon come across a man toting a few bags of this or that. He\'s sitting down on the ground and doesn\'t bother getting up when you near. He explains he\'s been on the road for days and could use a good night\'s rest. Naturally, he asks if he can spend that rest in the company of your men. | You come across a man who is weak and weary. He explains that he has been searching for his lost dog, but that he\'s just about given up. Before he heads home, he wonders quite loudly if maybe a night\'s rest in your company could help him find the energy to seek out his mutt for one more day. | A man tracked by buzzards is found on the side of the road. He\'s not hurt or wounded, just exhausted. He asks with a cracking voice if maybe he could spend the night in the company of your men.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Join us at the campfire for tonight.",
					function getResult( _event )
					{
						this.World.Assets.removeRandomFood(3);
						local n = this.Math.rand(1, 18);

						switch(n)
						{
						case 1:
							return "B1";

						case 2:
							return "C1";

						case 3:
							return "D1";

						case 4:
							return "E1";

						case 5:
							return "F1";

						case 6:
							return "G1";

						case 7:
							return "H1";

						case 8:
							return "I1";

						case 9:
							return "J1";

						case 10:
							return "K1";

						case 11:
							return "L1";

						case 12:
							return "M1";

						case 13:
							return "N1";

						case 14:
							return "O1";

						case 15:
							return "P1";

						case 16:
							return "Q1";

						case 17:
							return "R1";

						case 18:
							return "S1";
						}
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
			ID = "B1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%Man is treated to war the day he is born. It is his mother who is with him for that first battle, and to his mother whom he calls in his last. If only the evil we see in others could be seen in ourselves, then the call to swords might fall on deaf ears. How sad that men are so uncomfortable looking inward, and how sad that when the call for swords is made our ears hear better than ever.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "T\'was my call to answer, traveler.",
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
			ID = "C1",
			Text = "[img]gfx/ui/events/event_26.png[/img]You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%I\'d found myself nearing the top of a mountain a few months ago. Highest I\'ve ever been! Traveled there in the company of an expedition. Some man smarter than I reckoned it might be worthwhile so he could point his big glasses to the skies. Anyway, I looked down at the land and could see what had been done to it. Cities and towns and roads, little moles of gritty patchwork. Wagons scuttling like ants, selling what could be pilferaged from this man or this animal or this land. Holes in the forests where trees used to be.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Man has certainly made an impression.",
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
			ID = "D1",
			Text = "[img]gfx/ui/events/event_26.png[/img]You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%Thank you for offering the fish, sirs, but I will have to turn it down. Let me explain. Just the other day I tried diggin\' a hole for m\'kin as he\'d passed away as folks requiring holes in the earth tend to do. T\'was a distant cousin that stood close. Lived next door, actually. Feller died of illness, something we don\'t know of, but none but he got so I guess we is alright. He was all green when he passed. Y\'all know what that might have been?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "I don\'t know.",
					function getResult( _event )
					{
						return "D2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D2",
			Text = "[img]gfx/ui/events/event_26.png[/img]%SPEECH_ON%No? Damn. Well anyway, I dug his grave for him, as he surely wasn\'t going to do it himself. I got far into the ground when I come across a big ol\' stone. Pick hit it hard, broke the shaft in two and made chalk of my pickaxe. I said horseshit, I\'ve gone too far to stop here so get out of the way, stone! But that rock had bones in it. Not on it, in it. Strange looking ones, but bones nonetheless. Death is remarkably familiar from an outsider\'s perspective.\n\nAnyway, the skull seemed to be looking at me, judging me, saying \'what is it you think yer doing here?\' So I got up out of that hole and ran to m\'home, my cousin\'s remains yoked over my shoulders like I\'d stolen them. I was bothered. Couldn\'t sleep. Felt like I was laying over what must\'ve been hundreds of fellers right then, some so old they\'d taken shape with rocks of all things. Dead fellers. All the way down. Nothing but dead, all the way down I say! And I didn\'t know what to do and I suppose it still bothers me now if it ain\'t obvious.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A little, aye.",
					function getResult( _event )
					{
						return "D3";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D3",
			Text = "[img]gfx/ui/events/event_26.png[/img]%SPEECH_ON%Later on I decided I wouldn\'t bury m\'cousin. Instead, I burned his remains and threw the heap of what was left stewing and smoking into\'a\'pond. Said to m\'self, \'cousin, you ain\'t gonna be no rock\'.\n\nBut the other day I found them bones washed ashore, and there was a fat bellied fish caught in the ribs. Caged himself there on account of good eats, I guess. I picked that fish up and held it, and my cousin I s\'pose, in my hand. T\'was limp. Bugeyed as fish are without their watery lids. But then a dog ran by and took it from me. Gobbled it right quick for it knew the nature of its crime, I think. That\'s where a piece of my cousin ran off to. Dodged the earth on account of the hungry rocks only to be eaten by a squire of a fish that served itself to a righteous dog of all things. So now you know why I don\'t eat fish no more.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Huh. Interesting story.",
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
			ID = "E1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%I took part in the eastern campaigns. Drove the supply wagons, carrying untold numbers of armor, weapons, horses, foods, you name it. Hell, that\'s an age ten years past now, I believe. T\'was the last time men truly stood together, and I suppose the last time the greenskins did the same. No mystery that when the two forces met they shattered against one another. Now we dwell in a time of chaos and rumor and superstition and idle talk amongst strangers.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "May you find peace on the roads, traveler.",
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
			ID = "F1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%Ten years ago I fought in the Battle of Many Names. Orc against man. The end of a war that struck its name across an entire age. I rode with the cavalry, if you want to know. Southern flank in the mud and swamp and aye, neither are well fit for horseriding but our commander was having none of that. An orc drove a polearm through that commander\'s horse, and on through the commander himself. Taking horses into that muck.. a terrible idea. I heard the northern flank fared better, but it\'s no matter. Neither side won that damned fight.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "May you find peace on the roads, traveler.",
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
			ID = "G1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%Ever seen a greenskin cleave a horse\'s head off? Quite the sight. But I\'ve also seen a horse kick an orc\'s teeth out and bury him in mud with stomping madness. We forget, I think, that the horse is more akin to fancy a war than we are. Frightful, curious animals, sure, but violent. They say, left to themselves they oft kill one another, kill each other\'s children and their children\'s children. It\'s a damned thing that women love us both.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "May you find peace on the roads, traveler.",
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
			ID = "H1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%Ah, the Battle of Many Names. Aye, I took part. Vanguard. Front and center. No, I do not wish to talk about it.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "May you find peace on the roads, traveler.",
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
			ID = "I1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%The Battle of Many Names? Who did not take part in that? Half the world was on the march then, I swear it. I stood with the infantry. Footman to a lord, to be precise. Protected him well until the orcs released their berserkers. After that, everybody sought to protect themselves, a job which proved quite difficult. I used to lie about how I made it out. Now I don\'t. The truth is my lord had his face crushed by a chain and his mount flipped and fell atop me, its poor heart struck dead in fright.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Then what happened?",
					function getResult( _event )
					{
						return "I2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "I2",
			Text = "[img]gfx/ui/events/event_26.png[/img] The traveler pauses, staring into the campfire. He prods the edge of it with a stick.%SPEECH_ON%That\'s the last thing I remembered as far the fightin\' was concerned. I eventually woke to the rains coming up to my nose. Nearly drowned me in my dozing. I wiggled my way out from under the horse and crawled to god knows where. Orcs and men lay everywhere, dead, dying, drowning. Lots of screaming. Couldn\'t tell who or what it was coming from. I remember the mud. I remember it clutching at me. A maiden, strong-armed like an ox, saved me from it. She threw me on a cart and the last thing I saw was the battlefield and, I\'m sorry. I must stop. Thank you for having me for the night.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "May you find peace on the roads, traveler.",
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
			ID = "J1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%I led a company in the Battle of Many Names. It was a righteous affair. Man against orc! Oh, what a sight. Half of my men died on those fields, but their sacrifice saved the whole land! I look fondly on those times. What man doesn\'t?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A noble tale, stranger.",
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
			ID = "K1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%Out in %randomtown% they had a father up for trial. He\'d murdered two brothers on account of knocking his cart over. And then apparently the taste of it had him murdering some more. All told, he took the lives of at least seven people. Naturally, they hanged the man. But I ran into his son the other day and he told me the hanging was merely some clerical mistake. His father was an upstanding man, not the least bit self-serving and the people he killed had it coming. What\'s more curious, this youngin\' is now mayor! Now, the way I remember it the man slaughtered seven folks outright. Just like that! But last time I was in town they\'d moved his long-necked bones to a proper cemetery and I\'ll be damned if I didn\'t see some flowers on the tombstone. Not sure what to make of these things.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "People try to see the best in themselves.",
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
			ID = "L1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%You ain\'t the only mercenary company out here. I\'m sure you know that, and I don\'t mean to sound threatening, but I only wish to tell ya something.\n\nA couple weeks past some two or three companies of men, standing like your own, met at a crossroads and apparently the path wasn\'t big enough for all of \'em, so they fought. If any survived, it wasn\'t enough to carry off those who didn\'t. I like your men. They is good people. But please do be careful out there. Killing raiders and brigands and the gods know what else isn\'t the only thing you\'ll be doing. You kill in a market of competitors, sellsword.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll keep an eye out.",
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
			ID = "M1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%A boy stole my lunch the other day, but he\'d done not do anything but stand there and eat it in front of me. I said, \'give me back my lunch ya scamp\', but he said no. I reached for it but his scrawny legs proved to be more cat than chicken. I said, no, I asked why he\'d done have to eat it in front of me. This was torture, you see. He said \'because I\'m hungry\'. I told \'im, \'I\'m hungry too, now give it back\'. Naturally, he done said no. And so naturally when he\'d done turned around I cracked him with a stone and that slackened his speed a bit and I got m\'lunch back. \n\n But then yonder comes a footman of the mayor who says don\'t do that. I asked \'im why not, he said \'because that\'s the mayor\'s boy\'. My punishment was nothing, but I was warned t\'not do it again. I told \'im, I said, \'tell the boy to not steal again!\'. And they said they had, and that I was more likely to yield to a command than he and that\'s t\'way it t\'was. Farkin\' small towns, I swear on m\'sack those places are more billy than hill.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Revenge, the sweetest of spices.",
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
			ID = "N1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%Death was strange on the battlefield of Many Names. Orcs don\'t kill like men do, they make it fast. They leave you little wait between the now and the then. I got a good look at their handiwork after it was all said and done. Men strewn in pieces. Whole parts, legs, arms, bodies split in seams most unnatural. Instant death. Swing, head gone! And the body crumples and stiffens. Most of the dead looked like that, like they\'d just been scared and sat frozen in their embarrassment. Most looked nothing like men at all. A man should look asleep when he\'s dead, you know?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aye.",
					function getResult( _event )
					{
						return "N2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "N2",
			Text = "[img]gfx/ui/events/event_26.png[/img]He continues.%SPEECH_ON%A few received the courtesy of a slow death, of a pause to get ready and make themselves comfortable and find peace, to curl up into a ball and depart this place in a similar shape to how they\'d come in. But I will say one man, taken apart at the beltline, managed to hang on. I found him myself. I told him to close his eyes because I thought if he went to sleep maybe death\'d wake up. But he didn\'t go to sleep. He just kept breathing, and talking. Talking about this chicken he had as a boy, and how he got upset when his father slaughtered it. Talked about a girl, and then a wife and a mother. Talked about two mothers, actually.%SPEECH_OFF%The man pauses, staring into the campfire. He looks up at you.%SPEECH_ON%I did not know half a man could live for so long.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "May you find peace in your travels, stranger.",
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
			ID = "O1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler does speak some words which reside within your mind long after he\'s gone.%SPEECH_ON%I saw\'r man cut down by lightning a few months ago. %randomname% was his name. He had a lumber mill for a mouth, a wooden bite from side-to-side. Termites for teeth we used to say! Anyway, I\'d found his head aflame, grinning hot fire back at me, his flesh curled down in strips of black and purple. The ground around him was scorched, smoke drifting around and little fires crackling. But he was still alive. So I ran off to get some help when I heard a horrid noise behind me. Damned lightning struck him again! Smote by the gods through and through.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Well, may he rest in peace.",
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
			ID = "P1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. The traveler speaks of some idle news.%SPEECH_ON%They hanged some lady in %randomtown%. Didn\'t see her drop, but I did see her swing. They said she stove a man\'s head in while he slept. What a wench.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Interesting.",
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
			ID = "Q1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. The traveler speaks of a crime and its punishment.%SPEECH_ON%Out in %randomtown% they hanged a boy for killin\' a merchant. Said he threw a stone at the trader to knock him off his cart. He then ran over to steal his things, but the stoned man wasn\'t knocked out, so he drew his dagger and the boy drew his and I guess the boy was the one left standing when it was all said and done, o\'course, he now just be left swinging. Talk of the execution say he kicked good and long, wouldn\'t stop kicking even after he was dead. Maybe his cold feet were lookin\' for warmth.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Interesting.",
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
			ID = "R1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. Much talk is made about this or that, but the traveler gets a little skittish and you ask what is on his mind.%SPEECH_ON%I\'ve heard rumors of graveyards turning up earth-empty. They hanged a man out in %randomtown% for gravedigging, unfortunately they kept finding deadless graves anyway. Now, I\'m no superstitious man, but the way I hear it the dead\'re stepping out of the ground.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "It\'s just hearsay. You have nothing to fear.",
					function getResult( _event )
					{
						return "R2";
					}

				},
				{
					Text = "What you heard is true.",
					function getResult( _event )
					{
						return "R3";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "R2",
			Text = "[img]gfx/ui/events/event_26.png[/img] %SPEECH_ON%Whew. Yeah I suppose you is right. Dead walking the earth? Ha! I\'ll leave such ideas to the children.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Indeed.",
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
			ID = "R3",
			Text = "[img]gfx/ui/events/event_26.png[/img] %SPEECH_ON%May the old gods have mercy for if my damned mother-in-law walks the earth she\'ll certainly have none for me.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A frightening prospect.",
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
			ID = "S1",
			Text = "[img]gfx/ui/events/event_26.png[/img] You sit about a fire. The rather unfortunate looking man stares into the fire as he talks.%SPEECH_ON%I hear the rich folk have got these things that let them see what they look like. Mirrors! Aye, that\'s the name. Wish I had one. I hadn\'t seen my own face in.. well, ever. Maybe a bit of a look when staring into a pond, I guess.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Some things are best left unseen.",
					function getResult( _event )
					{
						return "S2";
					}

				},
				{
					Text = "We got a mirror right here.",
					function getResult( _event )
					{
						return "S3";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "S2",
			Text = "[img]gfx/ui/events/event_26.png[/img] The man\'s brow furrows.%SPEECH_ON%Oh yeah thanks, sellsword, that makes me feel so much better. Farkin\' cunt.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "You\'re welcome.",
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
			ID = "S3",
			Text = "[img]gfx/ui/events/event_26.png[/img] The man stares into the mirror like he was watching his own death. He rubs his chin and turns his head, desperately looking for some angle that won\'t disappoint.%SPEECH_ON%I\'ll be damned if my mother ain\'t the biggest liar that ever walked the earth. Look at that ugly mug!%SPEECH_OFF%He hands the mirror back and can\'t help but laugh at his unfortunate visage.%SPEECH_ON%Well, I suppose I no longer have to wonder why the womenfolk run from me.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "You\'re welcome.",
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
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Wildmen && currentTile.SquareCoords.Y > this.World.getMapSize().Y * 0.7)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		this.m.Score = 15;
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


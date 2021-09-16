this.undead_hoggart_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_hoggart";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]Marching through a foggy, hot rain, you spot a figure standing in the middle of the path. He\'s holding a metal-wreathed torch, no doubt the fire of a man wanting to be seen. As you draw near, he puts the torch down, giving light to an oddly familiar face, though you can\'t quite put your finger on it. You order him to announce himself.%SPEECH_ON%Are ye a lot of sellswords, hm?%SPEECH_OFF%You tell him that is not a name. He clears his throat, a soft orange glow of his face peering through the storm\'s dark.%SPEECH_ON%My name is Barnabas. Are ye sellswords or not?%SPEECH_OFF%Carefully, you cross the path and come close to the man. He waves the torch aside.%SPEECH_ON%Yeah, I figured as much. My brother, I need someone... I mean, I can\'t...%SPEECH_OFF%You nod and speak for him.%SPEECH_ON%He\'s come up out of the grave and now you want someone to take care of him.%SPEECH_OFF%The man nods, he waves the torch to a yonder spot where a dim light burns in the distance.%SPEECH_ON%He\'s thataway. I\'ll pay you %reward% crowns, seeing as how you\'re sellswords and all.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, show the way.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "This is not our problem.",
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
			Text = "[img]gfx/ui/events/event_76.png[/img]You tell the man to show the way, bringing %chosenbrother% with you and leaving another sellsword in charge while you\'re gone. Barnabas leads you down a hillside and to the fence line of a property home to a decently sized stone house. Candlelight flickers beyond the windows. Barnabas stares forward.%SPEECH_ON%Nobody\'s there. The only one here is Hoggart.%SPEECH_OFF%That name... Barnabas\'s face... You grab the man and push him into the fence, demanding to know if he is the bandit\'s brother. Barnabas quickly nods.%SPEECH_ON%Aye, that I am! What of it?%SPEECH_OFF%You tell him that Hoggart nearly wiped out the %companyname% and that, in return, you slew the man dead. Barnabas holds his hands up.%SPEECH_ON%If that\'s so, it is what it is. Hoggart was only doing what he needed to keep the property in the family. After our father died, we took on debts - debts we could not pay.%SPEECH_OFF%You draw a dagger and put it to the man\'s throat. He shakes his head.%SPEECH_ON%I\'m not here to ambush or rob you. The home\'s been sold. It\'s out of the family. But Hoggart... he\'s come back and he won\'t leave.%SPEECH_OFF%You look over Barnabas\'s shoulder. There\'s a dark figure standing before the home, its silhouette lit by the windowlight.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fine. Let\'s take a look.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "I\'ll end this right here.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "This is not our problem anymore.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_76.png[/img]Bloodlines are not easily broken. Whatever Barnabas is saying, it\'s likely that he\'ll come after the company someday, someday when it\'s cold and quiet and the fires of vengeance can\'t be so easily quenched.\n\n You tell the man to lead the way, and the second he turns about you stab him just beneath the armpit, piercing his heart. He doesn\'t say anything. He simply goes to his knees, facing the back of his brother and the home he grew up in. He sits there, crumpled and dying, the rain pattering against the torch until it sizzles dead. %chosenbrother% spits.%SPEECH_ON%Good call, sir.%SPEECH_OFF%He rifles through the body and finds a shiny dagger. Perhaps the tool to an assassin, perhaps the last heirloom of a dead family name. Either way, you take it and return to the %companyname%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'s that.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local item = this.new("scripts/items/weapons/named/named_dagger");
				item.m.Name = "Barnabas\' Dagger";
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_76.png[/img]This is not your problem, nor should it ever be. Hoggart is dead and that\'s all you need, or want, to know about him or any of his family name. You leave Barnabas there in the rain and return to the %companyname% to plan for the next trip.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We got enough undead problems on our hands.",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_76.png[/img]Against better judgment, you go and see if this really is Hoggart. Marching toward him, he growls and peers over his shoulder. It is indeed Hoggart, but he does little more than snarl at you before turning to stare at the home again. Taking out your sword, you approach carefully. From closer up, you can see that the man\'s head has been stitched back onto someone else\'s body, perhaps a knight\'s based upon the armored crest it is wearing.\n\n But enough lollygagging. You swing your sword back and bring it down upon Hoggart for one final blow - but a faint, blue hand launches out, stopping the blade as though you\'d struck a slab of stone. Slowly, a spectral face turns, independent of Hoggart, and looks at you. He shrieks before disappearing back into the dead man\'s lent body.\n\n Barnabas stands beside you.%SPEECH_ON%If I could do it that easily, I would have done it myself.%SPEECH_OFF%It appears there\'s a powerful, malevolent force at play here. You will need to find a different solution.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We need to burn down the house.",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "%chosenbrother%, distract the specter!",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Witchhunter != null)
				{
					this.Options.push({
						Text = "Let\'s get %witchhunter%. Vile spirits are his forte.",
						function getResult( _event )
						{
							return "H";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_76.png[/img]Hoggart reaches a hand out to his home, gripping at it from a distance. His growls turn to soft moans. A disfigured and desiccated tongue rolls a few words out.%SPEECH_ON%Ours... ours... always...%SPEECH_OFF%You glance at the house, then at %chosenbrother%. He nods. The house has to be ridden of. You go about setting the place aflame from the inside, pitching torches through its windows and setting alight its thatched roof. Even in the rain it catches ablaze. Hoggart growls and his body lurches forward, arms out, hands reached to the furthest fingertips. The specter spawns out of his shoulders, its translucent arms grabbing Hoggart by the head and trying to hold him back. The dead man growls and tries to run forward, his head tearing at the seams of his stitches. He screams.%SPEECH_ON%OURS! I TRIED. SO. HARD!%SPEECH_OFF%The stitches snap free and his body somersaults backwards, his head torn asunder and falling into the mud. The blue specter, wrenched free from the neck, screams and soars into the night sky, a mere shimmer against the rain until it is gone.\n\n Barnabas goes and sits beside Hoggart, the dead man\'s eyes staring blankly at the inferno consuming their childhood home. %chosenbrother% retrieves the armor from the body upon which Hoggart\'s head had rested. You try and talk to Barnabas, but he refuses to speak. Understanding, you do not prod him and leave the place behind, the fires still unerring against the rain when you depart.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Guess that\'s that.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/armor/named/black_leather_armor");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_76.png[/img]You whisper to %chosenbrother% to attack Hoggart, but only to try and distract the specter inhabiting his body. The sellsword nods and immediately gets to work, drawing out his weapon and charging forward. Predictably, a blue arm shoots out, crossing its unerring yet translucent shape with %chosenbrother%\'s weapon. He looks over the interlocking and screams.%SPEECH_ON%Now!%SPEECH_OFF%You jump forward and swing your sword. The specter whips around, screaming, but it is too late. Your blade passes through Hoggart\'s neck, rending his head free with a quick slash, his dome rolling down his chest into the mud while the body flails backward. Ushered into the world all by itself, the specter shrieks and swirls around in the sky, finding naught but chaos in its newfound freedom. %chosenbrother% looks at the chest armor that had been on Hoggart\'s body and shakes his head. Damn thing broke.\n\n A group of men suddenly start across the yard, holding out torches and swords alike. One especially opulent fellow leads them.%SPEECH_ON%Is that you Barnabas? I thought I told you to never step foot on my property again!%SPEECH_OFF%You explain to them what happened. The man, ostensibly the buyer of the land, nods, saying he\'d brought with him a cleric to solve the issue, but now that you have he pays you a tidy sum of crowns. When you turn back around, Barnabas and Hoggart\'s head are both gone.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That was one fast contract.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(300);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]300[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_76.png[/img]%chosenbrother% says that %witchhunter% probably knows what to do here. You agree and run to go get the witch hunter. On your return, he assesses the situation before consulting a thick book that\'d been hidden away in a pocket. He nods, murmuring to himself as he reads. Finally, he snaps his fingers.%SPEECH_ON%This is a Gespenst von Zwei, a haunting of two souls. In this case, Hoggart\'s and that of the man whose body his head now rests upon. One soul egregiously cast out is simple enough, but two combined is a malevolent and angry force. If we simply destroy the body or the head, the souls will be bound together and will haunt the lands forever. Some even blunder into the skies. Unfortunately, instead of finding the heavens, they find a hell of unending confusion and the fury that brings. I believe Hoggart\'s soul, or whatever binds him to this world, is stronger than that of the other man\'s. The struggle he had in life was too great to simply end on his final breath and that is why he stands at his old home.%SPEECH_OFF%You stop the witch hunter and ask the most pertinent question...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "How do we stop him?",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_76.png[/img]%witchhunter% forces a smile.%SPEECH_ON%Apologize to him.%SPEECH_OFF%Not sure you heard him right, you echo his phrase and the witch hunter nods.%SPEECH_ON%Aye, apologize. And mean it, too. Many men are so filled with hate, or so filled with desire, that any failure contextualizes itself as an energy beyond the mortal coil. You killed this man. It is you who upended a life which could not brook even the slightest of pauses, much less the ultimate defeat that is death. It is you who can end his struggle now. I believe apologizing would do this.%SPEECH_OFF%Barnabas steps forward and explains, again, that Hoggart only worked to ensure that the estate stayed within the family. All that he did was for the family. He was not an evil or cruel man, he was only doing what he thought was right. %witchhunter% throws a hand out as if to say \'see\'.%SPEECH_ON%Well, there ya go. Captain, listen. Whatever feud there was between you two is over. This is something else. No man deserves this fate. Apologize to him from the heart and you can end his suffering once and for all.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright. Here goes nothing",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_76.png[/img]You step toward Hoggart. He growls and eyes you for a moment before staring back at the home. With another cautionary step, you come to stand in front of him. His glazed, desiccated eyes glare at you, but he doesn\'t look away this time. You speak.%SPEECH_ON%Hoggart...%SPEECH_OFF%The undead man leans back, his eyes slimming incredulously, his hand touching his chest. His voice seems to unfurl, strained from the depths of a borrowed body.%SPEECH_ON%Ho...ggart... I... tried...%SPEECH_OFF%Nodding, you jack your thumbs into your belt line.%SPEECH_ON%I know you tried. I mean, I didn\'t know you were trying to begin with, but now I know. Look, your brother told me everything. Had I known, I wouldn\'t have taken that contract. You didn\'t...%SPEECH_OFF%You glance at %witchhunter% who nods. You continue.%SPEECH_ON%Hoggart, you didn\'t deserve to die. Not like that. Were I in your shoes, I would have been doing the same. But I wasn\'t in your shoes. I could not have understood who you were or what you were doing. I was only doing what I was paid to do. I can\'t take back what\'s been done, all I can do is say... I\'m sorry. You don\'t deserve this pain and I am sorry.%SPEECH_OFF%Hoggart\'s glazed, drooping eyes stare at you a moment longer, then suddenly his body wobbles and falls forward. Two spirits emerge, one twisting and shooting across the muddied land, wimpling stones with tears of its blue spectra as it streaks straight to the horizon. But the other spirit remains, glowing a faint gold now, and it simply floats toward the home. Barnabas follows after it and you after him. Together, you round a corner and head toward the back end of the property where Hoggart\'s ghost pauses.%SPEECH_ON%All I did, for this. No longer mine. Yours.%SPEECH_OFF%The spirit fades away as Barnabas reaches out to it, glistening dust floating away from his touch. You notice that the earth has been upturned here and a crate is sinking into the rainwater. Dragging it up and opening it, you find an enormous sword with decorations of Hoggart\'s family name. Baranabas looks as shocked as you about it.%SPEECH_ON%The family heirloom. He said he\'d never sell it to save the estate, he thought one couldn\'t be without the other. When I told him it had to be done he took it town and then came back and told me he lost it gambling... I never talked to him again. Last thing I said to him was that he was a no good vagrant and the worst brother anyone could ever have. Now I know the truth. You have brought me and my brother peace, sellsword, and that peace is all I want to remember. Please, as my brother said, take the heirloom.%SPEECH_OFF%You take the sword and wish Barnabas the best. The last you see of him he is sitting in the mud, body hunched, tottering and weeping with the rain all around him until there\'s no man at all, just a warm home and a storm booming with golden lightning.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rest in peace, Hoggart.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local item = this.new("scripts/items/weapons/named/named_greatsword");
				item.m.Name = "Hoggart\'s Heirloom";
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (!this.World.Flags.get("IsHoggartDead") == true)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_witchhunter = [];
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				candidates_witchhunter.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		if (candidates_witchhunter.len() != 0)
		{
			this.m.Witchhunter = candidates_witchhunter[this.Math.rand(0, candidates_witchhunter.len() - 1)];
		}

		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"chosenbrother",
			this.m.Other.getName()
		]);
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
		_vars.push([
			"reward",
			"300"
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
		this.m.Other = null;
	}

});


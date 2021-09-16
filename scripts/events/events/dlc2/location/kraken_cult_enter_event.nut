this.kraken_cult_enter_event <- this.inherit("scripts/events/event", {
	m = {
		Replies = [],
		Results = [],
		Texts = [],
		Hides = 0,
		Dust = 0,
		IsPaid = false
	},
	function create()
	{
		this.m.ID = "event.location.kraken_cult_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Texts.resize(4);
		this.m.Texts[0] = "And who are you?";
		this.m.Texts[1] = "So what all do you know?";
		this.m.Texts[2] = "You\'re a full on nutbar.";
		this.m.Texts[3] = "So, how can I help?";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_120.png[/img]{You stumble across a woman in the swamps, alone and with a rucksack and a pannier with rolls of what may be maps, and there\'s a dagger to her left hip and pots and pans to her right. There\'s a kicked campfire nearby and a pile of tomes shoed into a velvet sock. Everything she is and everything she has is covered in the greenery of the mire. She\'s standing there staring at you and you at her. It is not exactly ordinary for a woman to be out alone in the bog. She smiles quaintly, hesitantly.%SPEECH_ON%Hello.%SPEECH_OFF%With a hand on the handle of your sword, you eye the surrounding parts for an ambush. You ask her what she\'s doing out this way and she says you wouldn\'t believe her. You\'ve seen enough to lend credence to even the edges of whatever insanity she could respond with. The woman nods.%SPEECH_ON%Well, alright then. Come on over and I\'ll show ya.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s have a look.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We\'re fine.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsKrakenCultVisited", true);
				this.World.Flags.set("KrakenCultStage", 0);

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_120.png[/img]{You tell the company to keep vigilant for scapegraces hiding in the swamp, but they only laugh and say you should have stopped at the whorehouse if you were so up and in a fit. Ignoring them, you head toward the woman. You find her on a log, a mushroom cap twisting in her hands, and she speaks rather honestly.%SPEECH_ON%I\'m in search of a monster and whether real or farce, to me it is a monster all the same. Understand?%SPEECH_OFF%In a way, you do. Not all monsters are real, and a bog broad like this could be crazy. You ask her what this supposed beast is. She eats the mushroom and then grabs a book and throws it your way. There\'s a page held by a leaf and you open to it. Drawn there is what looks like an octopus with limbs the size of longships. It is in battle with a whole navy and seems to even be winning. The woman leans forward, her limp green hands hanging like kudzu between her knees.%SPEECH_ON%The monster I\'m seeking is the kraken.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B0",
			Text = "[img]gfx/ui/events/event_120.png[/img]{The woman leans back. She eats another mushroom and turns and stabs her dagger into a bug that had been scuttling across the log. Without so much as a pause she eats it off the tip and speaks between mashing its carapace.%SPEECH_ON%Ordinarily, I\'d be short on details and already waving this here dagger at your pecker, but I think you\'re keen on helping. I can see it in your eyes. You\'re a killer, a murderer, a lech, a fancier of the coin, and a crazy sumbitch.%SPEECH_OFF%She swallows the remains of the insect and spits out its remains like the shells of a sunflower seed. She nods.%SPEECH_ON%I\'m the daughter of a wealthy nobleman, but I\'m clearly far away from that life.%SPEECH_OFF%That she is.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[0] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_120.png[/img]{She turns to her tomes and stares at them as though they were gravestones.%SPEECH_ON%My father owns one of the largest libraries in all the land. In those halls I discovered stories of these very swamps. Stories by authors who, unwittingly, were repeating themselves. Ten years ago. A hundred. A thousand. All the same tale. A tale of men coming here, and men disappearing. Resolution is not sought and the answers are ambiguous. Bandits. Diseases. One scholar simply said the men experienced such wonder at the beauties of the swamp that they decided to stay there. Can you believe that? Beauties of the swamp?%SPEECH_OFF%Smirking, you say you\'re looking at one. She laughs.%SPEECH_ON%I haven\'t seen myself in months, but I\'m serious, stranger. I\'ve searched these parts and I haven\'t found a goddam thing.%SPEECH_OFF%She points a finger at her books.%SPEECH_ON%Twenty disappearances with up to three hundred men, armored, with horses, some with caravans, some with protected highborn, and yet I look around out here and I don\'t see a single goddam thing.%SPEECH_OFF%You suspect if you fucked off and died in a swamp no one would give a shit about you either, but that many tales is a little suspicious.}}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[1] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_120.png[/img]{She shrugs.%SPEECH_ON%Maybe, but at least I didn\'t hire a company full of assholes.%SPEECH_OFF%You look back at the %companyname% who on one side of the camp are having fistfights and in the middle someone is slipping a swamp snake up a sleeping sellsword\'s pants and on the closer side of things a few are pointing at you two and grabbing their crotches and humping the air. You turn back and tell her they aren\'t so bad. Just then, a mercenary screams across the swamp.%SPEECH_ON%Tell her about the time everyone fucking died and so we made you captain cause there was no one else! Ladies love heroics!%SPEECH_OFF%Grinning, you repeat yourself.%SPEECH_ON%Honestly, not the worst.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[2] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_120.png[/img]{The woman rummages through her rucksack and produces a signet unlike any you\'ve seen before. She flips it to you as though it were a shite counterfeit coin.%SPEECH_ON%Got plenty more where that came from. Well, not here exactly. Wouldn\'t want you get any ideas about robbing and ravaging, you know. But you do what I ask and I\'ll dump a chest of those on ya.%SPEECH_OFF%You pocket the signet and ask her what\'s needed. She answers.%SPEECH_ON%That I\'m not entirely yet sure of. Sailors talk of the krakens as being natural enemies to whales, but well, there are no whales around these parts given we\'re on land and all. But there is something close. An unhold of the bog. I suspect the krakens, through eons of time, moved inland and fed upon what they could and, like when they were in the seas, found an enemy here just as well. Bring me %hides% unhold hides and I may be able to lure the beast out of its slumber yet.%SPEECH_OFF%Out of its slumber? Where the hell would it even be sleeping? You shrug and figure if she\'s willing to rid herself of such magnificent jewelry then you\'d be more than happy to oblige her.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'ll bring you the hides.",
					function getResult( _event )
					{
						this.World.Flags.set("KrakenCultStage", 1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				if (!_event.m.IsPaid)
				{
					_event.m.IsPaid = true;
					local item = this.new("scripts/items/loot/signet_ring_item");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_120.png[/img]{You bring the woman her unhold hides only to find there are more people now. A few men and women milling about, poking around the swamp, eating mushrooms. They ask if you are here to help find the kraken. You sternly ask if they\'re here to get paid as well because you are sure as shite not sharing the goods. The woman calls out to you and runs over. She turns her head and scrunches swamp slush out of her hair as though it were a dirty rag.%SPEECH_ON%Are those the, they are!%SPEECH_OFF%She snaps her fingers and a few helpers take the hides away. You ask who the hell these people are. She shrugs.%SPEECH_ON%They just started arriving, I guess. Said it was in the stars for them to be here and I ain\'t one to question that. And no, I ain\'t going to pay them what I owed you. They\'re just happy to be here, away from everywhere else, away from everything always.%SPEECH_OFF%You raise an eyebrow.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "So the deal is done then?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local items = this.World.Assets.getStash().getItems();
				local num = 0;

				foreach( i, item in items )
				{
					if (item == null)
					{
						continue;
					}

					if (item.getID() == "misc.unhold_hide")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + this.Const.Strings.getArticle(item.getName()) + item.getName()
						});
						items[i] = null;
						num = ++num;

						if (num >= _event.m.Hides)
						{
							break;
						}
					}
				}

				_event.m.IsPaid = false;
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_120.png[/img]{With the hides delivered, you ask for what you\'re owed. She flips you another signet as though you were a beggar and then waves for you toward her books. As you walk over, you see the helpers cutting up the unholds\' hides. They seem to be tailoring them as cloaks. The woman talks.%SPEECH_ON%I think we\'re closer to the awakening. The helpers here said they saw stars, but I think what they really saw were fireflies. I see them sometimes myself. Little bugs that glow in the dark. I\'ve tried to capture a few, but they keep winking away.%SPEECH_OFF%Right. You ask for your payment. Again. She answers by reopening that old tome and looking at the drawing of the sailors being attacked by the kraken.%SPEECH_ON%With so much help around I have had more time to delve into the books, and in that time I noticed something. What do you see in this picture? Look closely now.%SPEECH_OFF%You stare at it, but shrug. She drags her finger across the particularities of the drawing, as though her narration were etching it there and then.%SPEECH_ON%Moonlight. This battle occurred at night. What are these here, flying above the fight? Seagulls? No. Those are bats. What in the hells are bats doing flittering around in the middle of the ocean? And then there\'s this man here, at the helm of the ship, with the long ears and the black cloak. An interesting figure, no? And then there\'s this, a few pages down, a record of, I quote, \'a vagabond who threw bats out of his cloak to mask his escape\'. Rather particular, no? I think these were called Necrosavants. Ancient ones. And I think they weren\'t ambushed by the kraken. I think they were hunting it.%SPEECH_OFF%Sighing, you ask what she needs. The woman claps the book closed.%SPEECH_ON%Depends if they exist or not, for with mine own eyes I have not witnessed them, but in my days I have seen the shamans and the magicians with their strange glittery ashes. Perhaps trickery, perhaps not. Bring me %remains% ash piles of these nightmen and we may have our kraken yet.%SPEECH_OFF%The woman excitedly stuffs her face with more mushrooms. She pauses, grinning with black caps for teeth.%SPEECH_ON%And then you\'ll have your crowns, too, of course.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "From dust to finding dust.",
					function getResult( _event )
					{
						this.World.Flags.set("KrakenCultStage", 2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}

				if (!_event.m.IsPaid)
				{
					_event.m.IsPaid = true;
					local item = this.new("scripts/items/loot/signet_ring_item");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_120.png[/img]{With all the time spent there, you thought this place an increasingly familiar mire, but the swamp suddenly feels strange and foreign, like walking into an old bedroom only to know something has been moved around.\n\nYou find the woman standing at a distance, a formation of her helpers behind her. They\'re all wearing cloaks made of unhold hides. They\'re crouching before bulbs of green lights, cupping them in their hands, and you can see slivers of grins brokered in each viridian sheen, rinds of lips hissing softly in fading sanity. The woman\'s books and tomes and papers are littered all around. A fog lingers, and it has brought with it a horrible stench. You ask where your money is. The woman grins and her eyes are jaundiced and her lips parched and splintered and mushrooms bits are smattered across her cheeks.%SPEECH_ON%The sellsword wants his crowns! There is nothing here but escape! Escape from everything everywhere!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What is going on here?",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "I demand to be paid right now.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_103.png[/img]{You watch as one of the helpers suddenly lifts into the air, and in the green light you see the slick tentacle drag him backward and it seems as though the earth itself opens up, and a thousand wet boughs and branches crinkle and drip, and rows upon rows of fangs bristle, clattering against one another as though shouldering for a slice, and the helper is thrown into it the maw and the gums twist and he is disrobed and defleshed and delimbed and destroyed. The woman chomps on another mushroom and then her hands caress bulbs of green, and you can see the tentacles slithering beneath each.%SPEECH_ON%Join us, sellsword! Let the Beast of Beasts have its feast!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To formation!",
					function getResult( _event )
					{
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

	function addReplies( _to )
	{
		local n = 0;

		for( local i = 0; i < 3; i = ++i )
		{
			if (!this.m.Replies[i])
			{
				local result = this.m.Results[i];
				_to.push({
					Text = this.m.Texts[i],
					function getResult( _event )
					{
						return result;
					}

				});
				  // [028]  OP_CLOSE          0      4    0    0
			}
		}

		if (n == 0)
		{
			_to.push({
				Text = $[stack offset 0].m.Texts[3],
				function getResult( _event )
				{
					return "C";
				}

			});
		}
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		this.m.Replies = [];
		this.m.Replies.resize(3, false);
		this.m.Results = [];
		this.m.Results.resize(3, "");

		for( local i = 0; i < 3; i = ++i )
		{
			this.m.Results[i] = "B" + i;
		}

		if (this.m.Hides == 0)
		{
			local stash = this.World.Assets.getStash().getItems();
			local hides = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.unhold_hide")
				{
					hides = ++hides;
				}
			}

			this.m.Hides = hides + 3;
		}
		else if (this.m.Dust == 0)
		{
			local stash = this.World.Assets.getStash().getItems();
			local dust = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.vampire_dust")
				{
					dust = ++dust;
				}
			}

			this.m.Dust = dust + 3;
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hides",
			this.m.Hides
		]);
		_vars.push([
			"remains",
			this.m.Dust
		]);
	}

	function onDetermineStartScreen()
	{
		if (!this.World.Flags.get("IsKrakenCultVisited"))
		{
			return "A";
		}
		else if (this.World.Flags.get("KrakenCultStage") == 0)
		{
			return "B";
		}
		else if (this.World.Flags.get("KrakenCultStage") == 1)
		{
			local stash = this.World.Assets.getStash().getItems();
			local hides = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.unhold_hide")
				{
					hides = ++hides;
				}
			}

			if (hides >= this.m.Hides)
			{
				return "D";
			}
			else
			{
				return "C";
			}
		}
		else if (this.World.Flags.get("KrakenCultStage") == 2)
		{
			local stash = this.World.Assets.getStash().getItems();
			local dust = 0;

			foreach( item in stash )
			{
				if (item != null && item.getID() == "misc.vampire_dust")
				{
					dust = ++dust;
				}
			}

			if (dust >= this.m.Dust)
			{
				return "F";
			}
			else
			{
				return "E";
			}
		}
	}

	function onClear()
	{
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU8(this.m.Hides);
		_out.writeU8(this.m.Dust);
		_out.writeBool(this.m.IsPaid);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 43)
		{
			this.m.Hides = _in.readU8();
			this.m.Dust = _in.readU8();
			this.m.IsPaid = _in.readBool();
		}
	}

});


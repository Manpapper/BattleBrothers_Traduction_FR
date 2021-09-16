this.witchhut_destroyed_event <- this.inherit("scripts/events/event", {
	m = {
		Replies = [],
		Results = [],
		Texts = []
	},
	function create()
	{
		this.m.ID = "event.location.witchhut_destroyed";
		this.m.Title = "After the battle";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Texts.resize(7);
		this.m.Texts[0] = "Who are you?";
		this.m.Texts[1] = "How do you know who I am?";
		this.m.Texts[2] = "Who were the ancients?";
		this.m.Texts[3] = "What is Davkul?";
		this.m.Texts[4] = "Were the greenskins human?";
		this.m.Texts[5] = "Why did you call me the False King?";
		this.m.Texts[6] = "What is it that I dream of?";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{The last of the witches is slain and you have their corpses mutilated for good measure. Ears. Lips. Noses. Toes. All of them cut off. Their bags are emptied out and the items crushed into powder and covered in dust. Fleshy bits or animal parts are dumped into a pile and promptly burned. As the fire rises, the hexen from the hut seemingly appears out of nowhere and takes you by the arm. Your men draw their swords, but you hold your hand up. You tell them to keep salting the earth, so to speak, and as you enter the hut you take a look back to see a few of the men pissing on the embers of the fire.\n\n Inside the hut you sit where you had before. On the table you find something rolled up in a handkerchief and the witch pinches its corner and rolls it between her finger and thumb. She looks up and tips her chin forward and turns her hands palms up.}",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{The witch smiles.%SPEECH_ON%An old hag in a forest hut. Everything else is hearsay.%SPEECH_OFF%You stare at her long enough to see there\'s little fruit to bear in chasing this question further.}",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{She stares at the wrapped item.%SPEECH_ON%I don\'t even know your name, sellsword, and I haven\'t the slightest inclination to begin to care. It is not a matter of who you are, but what you are.%SPEECH_OFF%She turns her hands as though they were following a tune.%SPEECH_ON%The blood of the ancients resides within you. It resides within us all, but you in particular, well.%SPEECH_OFF%Her nose crinkles as she snorts, and she exhales she grins madly.%SPEECH_ON%It is ever so there. And if I can smell it, then the whole world can smell it.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_115.png[/img]{She taps the handkerchief and whatever is beneath raps the table. She answers.%SPEECH_ON%The ancients were men before our time. Truly, truly before our time. Imagine a kingdom, now imagine a kingdom that ruled kingdoms. An empire, that\'s correct. Now imagine an empire that ruled empires. Unfathomable power such as that leaves the world with great vengeance, and will spend its dying days ruining those which have ruined it.%SPEECH_OFF%You ask if the empire is dead. The witch smiles.%SPEECH_ON%I suspect not, but I do not truly know.%SPEECH_OFF%}",
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
			ID = "B3",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Shrugging and leaning back, the hexen asks you to repeat the name. \'Davkul.\' She shakes her head.%SPEECH_ON%I have heard nothing about this Davkul. A supposed god you say? Well, he has not spoken to me.%SPEECH_OFF%You stare at her and try to pry a hidden truth from her eyes, but she seems earnest in her response and you change the subject.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[3] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B4",
			Text = "[img]gfx/ui/events/event_115.png[/img]{The hexen cackles.%SPEECH_ON%I wish! Have you seen what orcs got between their legs? Wouldn\'t mind a ride on that if I knew it wouldn\'t tear me in half and fark one end while wearing the other for a glove!%SPEECH_OFF%You raise an eyebrow and nod as though to say \'of course.\'}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[4] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B5",
			Text = "[img]gfx/ui/events/event_115.png[/img]{For the first time there is a crack in the witch\'s facade. She purses her lips.%SPEECH_ON%When did I call you that?%SPEECH_OFF%You point to the door and then to the table. You answer.%SPEECH_ON%I walked in here and you said I\'d seek the truth, that you know what the False King dreams of.%SPEECH_OFF%The hexen taps the handkerchief rather mindlessly. She looks up.%SPEECH_ON%Then you have my apologies, sellsword, I remember no such thing. I am but a fragile and old woman, older than I look, and I\'m not being cheeky about that.%SPEECH_OFF%You press her on the matter, but she only stonewalls you further.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[5] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "Dream",
			Text = "[img]gfx/ui/events/event_115.png[/img]{The hexen leans forward. She puts her hands to your face and you feel the leathery fingers press deep into your cheeks like a half-dozen walnuts. They rub the corners of your eyes and tap your temples. All the while she is smiling, and then she pulls back.%SPEECH_ON%You go to the noblemen and the rich and they pay you gold and in return you risk life and limb and you slaughter and murder and kill all that you can, and there you are day after day, wondering if that\'s all you are good for, and afterward the highborn shut the door on you and your deeds, and you hear them inside having a grand time, music playing, womenfolk laughing, jesters joking, the festivities are riotous, and you are outside with a bag of gold in hand and its bloodslaked receipt, and you go down to the pub and buy yourself a whore and tip a coin to the minstrel for a song and you can taste a fine wine in even the cheapest of cellars, but there is no escape from that horrible feeling in the back of your head, that feeling you were born into fever and all this violence and death is not a means to an end, but the end itself. It is what you are and what you always will be.%SPEECH_OFF%She pauses. Sighs. Continues.%SPEECH_ON%Sellsword, the power of a lie is only equaled by one\'s desire to believe in it. You live a powerful lie, and such power will not go easily. I beg of you, be only what you can understand.%SPEECH_OFF%It was not yourself, or your weaponry, or the presence of your company whole which brought her fear, but only the dawning of some unknown realization as she speaks to you now.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Who am I?!",
					function getResult( _event )
					{
						return "WhoAmI";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "WhoAmI",
			Text = "[img]gfx/ui/events/event_115.png[/img]{You stand up yelling at the woman for answers. She slaps you in the face and you stiffen and falter back a step. A drop of blood slips down your cheek and you catch it in your cuff. The witch grabs the handkerchief and throws it off, revealing the obsidian blade beneath. It is sharper than you remember, a vivid sliver of yourself running down the edge as though you cracked a door toward a mirror. The hexen sits back down and pushes the weapon across the table.%SPEECH_ON%No more questions, sellsword. There\'s only so much I know, and so much you need to know. We\'ve made a deal and this is the end of it.%SPEECH_OFF%Taking the dagger, you ask what she did to it, but she refuses to answer. You then ask if there are more out there like her. She grins playfully.%SPEECH_ON%I pray there are not.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'re done, then, and I shall take my leave.",
					function getResult( _event )
					{
						return "Leave";
					}

				},
				{
					Text = "You\'ve served your purpose, then. Die, witch!",
					function getResult( _event )
					{
						return "Kill";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/weapons/legendary/obsidian_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Leave",
			Text = "[img]gfx/ui/events/event_115.png[/img]{You bid the witch adieu and she says nothing more. Outside, the men ask what she said, while others making reference to sexual escapades. You think you\'re smirking, but you really don\'t know. The conversation has left you in a fog and from within the mist you only depend upon what you know: ordering the company back on the road.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Time to go.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsWitchhutLeft", true);
			}

		});
		this.m.Screens.push({
			ID = "Kill",
			Text = "[img]gfx/ui/events/event_115.png[/img]{The witch folds her fingers and nods. You nod back. And then grab the obsidian dagger and plunge it into her chest. She bleeds like any man or woman you know. She coughs and chokes on her blood like any living being you know. And she reels backward, eyes wide with fear, like many you\'ve known before. You draw the dagger out and kick her. She goes wailing and her hands reach out and drag down fistfuls of dreamcatchers and cobwebs alike and her elbow slaps a board of wooden cutlery and the utensils scatter all over the hut with hollow clattering. Weak fingers clasp a butterknife, her eyes piercing yours. She coughs once, twice. She drops the butterknife to pound her chest with a fist and a spurt of blood spurts onto her chin. She looks up.%SPEECH_ON%We had a deal, sellsword.%SPEECH_OFF%You sheathe the dagger and nod.%SPEECH_ON%Aye, you had a deal with a mercenary and you got what you wanted out of it. Myself? I had a deal with the world to get rid of you and your ilk whole. Nice talk and have a good life.%SPEECH_OFF%Gargling, the hexen\'s head lowers to the floor and her body goes limp. When you head outside the company asks what happened. You tell them to burn the hut and prepare to get back on the road.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Time to go.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsWitchhutKilled", true);
			}

		});
	}

	function addReplies( _to )
	{
		local n = 0;

		for( local i = 0; i < 6; i = ++i )
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
				n = ++n;

				if (n >= 4)
				{
					break;
				}

				  // [034]  OP_CLOSE          0      4    0    0
			}
		}

		if (n == 0)
		{
			_to.push({
				Text = $[stack offset 0].m.Texts[6],
				function getResult( _event )
				{
					return "Dream";
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
		this.m.Replies.resize(6, false);
		this.m.Results = [];
		this.m.Results.resize(6, "");

		for( local i = 0; i < 6; i = ++i )
		{
			this.m.Results[i] = "B" + i;
		}
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


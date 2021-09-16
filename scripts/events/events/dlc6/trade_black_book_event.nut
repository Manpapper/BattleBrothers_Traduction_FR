this.trade_black_book_event <- this.inherit("scripts/events/event", {
	m = {
		Translator = null
	},
	function create()
	{
		this.m.ID = "event.trade_black_book";
		this.m.Title = "During camp...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_174.png[/img]{A man has approached the camp. You leave your tent to find him standing with his hands atop a golden spear, the shaft of which branches out with sharpened points. As threatening as the weapon looks, a pair of water jugs and golden curios have weighted it with other purposes. The man himself throws back a cloak to reveal a very peculiar and pale face that has not a single hair upon the flesh. He introduces himself with flawless articulation.%SPEECH_ON%Hello stranger, my name is Yuchi Eveohtse. I\'m looking for two things in these lands, one of which I\'ve come to understand is in your possession. It is a profound text on the nature, no, the existence of death. I believe one of your men has already unlocked a partial set of its mysteries and, at this point, it is of little further use to you.%SPEECH_OFF%%translator% nods, stating that as long as he stares at the pages, he can make nothing more of it and doubts anyone can. Yuchi whistles and you look back at him. The man holds out three fingers.%SPEECH_ON%In exchange for the book, I\'ve one of these to offer: either a golden shield the faithful of these lands call the Gilder\'s Embrace, my two jugs which, when imbibed, will strengthen a man in ways beyond your imagining, or, being that you are mercenaries, a sum of 50,000 crowns.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We trade the book for the golden shield.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We trade the book for the two jugs.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "We trade the book for 50,000 crowns.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Translator.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_174.png[/img]{A man has approached the camp. You leave your tent to find him standing with his hands atop a golden spear, the shaft of which branches out with sharpened points. As threatening as the weapon looks, a pair of water jugs and golden curios have weighted it with other purposes. The man himself throws back a cloak to reveal a very peculiar and pale face that has not a single hair upon the flesh. He introduces himself with flawless articulation.%SPEECH_ON%Hello stranger, my name is Yuchi Eveohtse. I\'m looking for two things in these lands, one of which I\'ve come to understand is in your possession. It is a profound text on the nature, no, the existence of death.%SPEECH_OFF%The man holds out three fingers.%SPEECH_ON%In exchange for the book, I\'ve one of these to offer: either a golden shield the faithful of these lands call the Gilder\'s Embrace, my two jugs which, when imbibed, will strengthen a man in ways beyond your imagining, or, being that you are mercenaries, a sum of 50,000 crowns.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We trade the book for the golden shield.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We trade the book for the two jugs.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "We trade the book for 50,000 crowns.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi bows for the briefest moment and when he stands he is holding a shield. At first glance, it appears to be nothing more than steel with ornate gildings around the edges, but suddenly an orb of yellow light cycles around the outer rim, dancing around and around.%SPEECH_ON%They call it the Gilder\'s Embrace for the God\'s very divinity is said to be partitioned within its framing. See, if you were to turn this against your enemies, the light would grow to such blinding rays that your foes shall not see. And as you can tell, the light now is dull, for we are not enemies, stranger.%SPEECH_OFF%The man holds out his hand. You give him the book, and he gives you the shield. He does not even stare at the book, simply stows it away and gathers up his spear. You ask him what he intends to do with the text. He smiles.%SPEECH_ON%Who knows. Maybe I will simply return it, hm? Or maybe not.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What was the second thing you came for?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local book;

				foreach( item in this.World.Assets.getStash().getItems() )
				{
					if (item != null && item.getID() == "misc.black_book")
					{
						book = item;
						break;
					}
				}

				this.World.Assets.getStash().removeByID("misc.black_book");
				this.List.push({
					id = 10,
					icon = "ui/items/" + book.getIcon(),
					text = "You lose " + book.getName()
				});
				local item = this.new("scripts/items/shields/legendary/gilders_embrace_shield");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain the " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi tips his gilded spear forward. It sharpness is incredible, like something a blacksmith may dream of but never manifest by any mortal hand. The pair of jugs slide off and he catches them by their straps and holds them out. You give him the book and he lets go of the jugs. Not wanting to be poisoned, you ask that he take a drink of both jugs which he does so willingly. Wiping his mouth, he nods.%SPEECH_ON%I\'m quite partial to its flavors and its effects, please do not waste anymore of it on your suspicions and hesitancies.%SPEECH_OFF%The man stows the book somewhere into his cloak, picks up his gear, and begins to walk away. You ask what he plans to do with the text. He smiles.%SPEECH_ON%Who knows. Maybe I will simply return it, hm? Or maybe not.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What was the second thing you came for?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local book;

				foreach( item in this.World.Assets.getStash().getItems() )
				{
					if (item != null && item.getID() == "misc.black_book")
					{
						book = item;
						break;
					}
				}

				this.World.Assets.getStash().removeByID("misc.black_book");
				this.List.push({
					id = 10,
					icon = "ui/items/" + book.getIcon(),
					text = "You lose " + book.getName()
				});
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/trade_jug_01_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain a " + item.getName()
				});
				item = this.new("scripts/items/special/trade_jug_02_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain a " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi nods.%SPEECH_ON%Give me the book and bring me your warchest.%SPEECH_OFF%You throw him the text and then have the company\'s treasury brought before the man. He holds out both arms of his cloaks and slowly tips them forward. Crowns stream out of the sleeves seemingly without end and then on an instant the man tips both arms up.%SPEECH_ON%Your %reward% crowns should be there.%SPEECH_OFF%You have the coin counted and it is the exact amount. You look up to say he\'s quite lucky, but the man is already picking up his things and preparing to leave.%SPEECH_ON%Take care, stranger.%SPEECH_OFF%Before he goes, you ask what he plans to do with the text. He smiles.%SPEECH_ON%Who knows. Maybe I will simply return it, hm? Or maybe not.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What was the second thing you came for?",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local book;

				foreach( item in this.World.Assets.getStash().getItems() )
				{
					if (item != null && item.getID() == "misc.black_book")
					{
						book = item;
						break;
					}
				}

				this.World.Assets.getStash().removeByID("misc.black_book");
				this.List.push({
					id = 10,
					icon = "ui/items/" + book.getIcon(),
					text = "You lose " + book.getName()
				});
				this.World.Assets.addMoney(50000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]50,000[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Yuchi turns around.%SPEECH_ON%Hm?%SPEECH_OFF%You explain that he said he had come to these lands looking for two things. One was the book, what was the other? He smiles.%SPEECH_ON%There is a town in these parts by the name of Dagentear. The town is no more, but something that lived there still wanders. A being they call the \'Wight.\' I wish to find it and speak with it.%SPEECH_OFF%When you ask for more information he simply parts with a graceful bow.%SPEECH_ON%Thank you for your gentle dealings, stranger.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I hope we did the right thing giving him that book...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("IsLorekeeperTradeMade", true);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.Flags.get("IsLorekeeperDefeated"))
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasBlackBook = false;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.black_book")
			{
				hasBlackBook = true;
				break;
			}
		}

		if (!hasBlackBook)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.militia")
		{
			local brothers = this.World.getPlayerRoster().getAll();
			local candidates_mad = [];

			foreach( bro in brothers )
			{
				if (bro.getSkills().hasSkill("trait.mad"))
				{
					candidates_mad.push(bro);
					break;
				}
			}

			if (candidates_mad.len() == 0)
			{
				return;
			}

			this.m.Translator = candidates_mad[this.Math.rand(0, candidates_mad.len() - 1)];
		}

		this.m.Score = 150;
	}

	function onPrepare()
	{
	}

	function onDetermineStartScreen()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.militia")
		{
			return "A2";
		}
		else
		{
			return "A";
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"translator",
			this.m.Translator != null ? this.m.Translator.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Translator = null;
	}

});


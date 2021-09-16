this.belly_dancer_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.belly_dancer";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{A belly dancer magnetizes %townname%\'s center plaza. Rhythmic movements on their own can coerce a beggar to donating a crown, but with the stage of the whole plaza it is enough to draw crowds and with it heaps of gold. Masked by green silk, nearly see through, and clothed in thin silks with the whole mid rift exposed, the dancer is no doubt an expert in her field. She whirls, hips hypnotic, elbows bowed, hands clapping little cymbals, her feet tiptoeing as she spins a spot so tight there very well may be an invisible god above holding her in place as she razzles and dazzles.\n\n Someone throws an apple through the air and the dancer spins around and shoots a tiny dagger through it, plugging it dead center and dropping the fruit to the ground. Another apple soars in and this time a large saber is produced and slashes the stem off and she catches the rest and takes a bite. The crowd claps gently to this.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done, have a crown.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Time to leave.",
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
			Text = "[img]gfx/ui/events/event_163.png[/img]{You take out a crown and flip it to the dancer. Her eyes catch its glint, but she doesn\'t break the dance. She drops her weapons and sashays over, cymbals clattering, hips gyrating, her knees hardly bending, her feet almost mystically carrying her across the ground. She gets near. The face is narrow, but the jaw broad. Her temples deep. She grins. It\'s a man. She\'s a man. He claps the cymbals in your face, then swings around, briefly gracing your groin with his ass, and starts to dance back to the middle. He picks up your coin with a toe and flips it up and it lands in a clay pot. The crowd cheers.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maybe we can make use of this man?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Time to leave.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-1);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]1[/color] Crown"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_163.png[/img]{After the mannish belly dancer takes your crown you wait around for the show to end. You approach as he picks up his things. He looks at you with a wry smile.%SPEECH_ON%Ah, an admirer. Sorry, only one show tonight, good stranger.%SPEECH_OFF%You shake your head and ask if he knows anything about fighting. He nods.%SPEECH_ON%Of course I do. The Gilded One\'s gleam is upon us all, but not at all hours or days. Sometimes we must find our own way through the dark. I take it by your dress that you are a Crownling, putting that blade of yours where it does and sometimes does not belong.%SPEECH_OFF%You nod and ask him if he\'d be interested in joining. He goes bowlegged and sinks to the ground like a collapsing truss. He counts his crowns.%SPEECH_ON%I\'m not sure if you have a good eye for the wandering nature of men such as myself. Perhaps you saw a vocational tiredness not even I was aware of until this present moment. That said, you\'ll have to try harder to get me to go around killing for coin.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'ve talent with the blade like I\'ve never seen before.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "E" : "D";
					}

				},
				{
					Text = "I\'ll pay you 500 crowns right now if you join us.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"belly_dancer_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "You found %name% in " + _event.m.Town.getName() + ", masked by green silk and drawing crowds with rhythmic movements and impressively precise fruit slicing. The latter skill is a boon to any mercenary company, and so you didn\'t hesitate to recruit him.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/dexterous_trait");
				_event.m.Dude.getSkills().add(trait);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You assuage his ego by saying he\'s one of the best with the blade you\'ve seen. The dancer turns his hands to the dust, his fingers sliding beneath each coin and flipping it into his clay pot. His left hand reaches across the ground, but as this catches your eye, his right hand snatches a blade that had been entirely buried beneath the sands. He holds it toward your crotch.%SPEECH_ON%I\'m deadly with the blade, as I\'m sure you are with that stinger there. Now, I know you are merely petting things which shall make me purr, preying upon my pride as the hunter does the lions, and I will say this: it has worked. I will fight for you, captain of the Crownlings, and I will fight well.%SPEECH_OFF%Nodding, you ask that he lower the blade. He spins it in his hand and sheathes it in one swift motion. He gets to his feet, stripping himself down until he is buck naked.%SPEECH_ON%This life I will leave behind in total, and to the Crownling\'s life I will be devoted in whole.%SPEECH_OFF%You shake the man\'s hand. A passerby glances over and scratches his head.%SPEECH_ON%Wait a minute, you\'ve a snake down there! I thought you were a lady of the dance, but this...%SPEECH_OFF%He dabs his forehead with a cloth and lowers his voice.%SPEECH_ON%This makes it even better.%SPEECH_OFF%The dancer looks at you and laughs.%SPEECH_ON%We\'ve all dangers to confront in our respective vocations, Crownling, and I look forward to seeing yours.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the company!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You tell the dancer that he is one of the best you\'ve seen with a blade. He laughs.%SPEECH_ON%A truly well intentioned attempt on your part, Crownling, to drag me to your ways of life. But you know well that there is nothing you could say or do that would take me away from this life. Yes, the blade suits me well, but so does flittering about for the crowd, earning praise without spilling blood to do it. You go play gladiator on the sands and earn you coin, Crownling, and I will be here earning mine.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I had to ask.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You offer five hundred crowns to the dancer. He keeps picking up coins - one at a time - and putting them in his clay pot. It is almost a silent affair, coins clapping loudly as they fall into a nearly empty barrel of clay. He looks up, looks down. He puts in one more crown then gets to his feet. He strips off his clothes and holds out his hand.%SPEECH_ON%The Gilded One must be gleaming upon us both, for you to have earned such keep, and no doubt He has guided your purse here to bring it to me.%SPEECH_OFF%You nod and shake his hand. A passerby glances over and scratches his head.%SPEECH_ON%Wait a minute, you\'ve a snake down there! I thought you were a lady of the dance, but this...%SPEECH_OFF%He dabs his forehead and lowers his voice.%SPEECH_ON%This makes it even better.%SPEECH_OFF%Sighing, the dancer asks that he take a look at your inventory.%SPEECH_ON%A body like mine, anything will fit, inside or out, I\'ll make it work.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the company!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.PositiveEventValue + "]500[/color] Crowns"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 750)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer())
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
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
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Dude = null;
	}

});


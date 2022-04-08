this.black_market_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Price = 0,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.black_market";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_01.png[/img]{%townname%\'s fruit carts are laden with all manner of delicious albeit grossly overpriced treats. You side-eye one of their owners, trying to time his looking away with your own little five finger discount. Right as you\'re about to sneak a swipe, %anatomist% the anatomist runs up in a hurry, and more importantly gathering all the attention in the world. You put your petty thieving aside and ask what it is he wants. He grins.%SPEECH_ON%We have found the %townname%\'s black market.%SPEECH_OFF%You head to the place and find a scrawny man leaning in a chair. On the desk in front of him is an assortment of \'goods\', if they can be called that. To you, it looks like a pile of nondescript shite, but to the anatomist it may as well be a gift from the old gods. Yawning, the scrawny man says take your pick. %anatomist% leans in close, appraising the goods, and finds three that look to be of questionable quality and eventually dubious purpose. He cautions that perhaps the company should only purchase one.%SPEECH_ON%If the town guards find us with too many, they may confuse us with peddlers instead of mere purchasers, and peddling such goods is quite the criminal offense.%SPEECH_OFF%You take a look at the options.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get that brain-looking thing for 100 crowns.",
					function getResult( _event )
					{
						_event.m.Price = 100;
						return this.Math.rand(1, 100) <= 85 ? "Brain" : "Bunk";
					}

				},
				{
					Text = "I\'ll take the big heart for...550 crowns, is it?",
					function getResult( _event )
					{
						_event.m.Price = 550;
						return this.Math.rand(1, 100) <= 95 ? "Heart" : "Bunk";
					}

				},
				{
					Text = "I\'ll pay the 200 crowns for that...some kind of gland?",
					function getResult( _event )
					{
						_event.m.Price = 200;
						return this.Math.rand(1, 100) <= 90 ? "Gland" : "Bunk";
					}

				},
				{
					Text = "We can\'t afford such indulgences.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Brain",
			Text = "[img]gfx/ui/events/event_14.png[/img]{You purchase what looks like a slab of condensed noodles, the spongy ropes grey with black dots mottling the cushy texture. Rather disgustingly, %anatomist% puts his whole palm upon the substance and presses in. When he takes his hand away, the print lingers, the flesh popping as it unsticks and reforms. He smiles.%SPEECH_ON%I believe we can make much use of this in our studies.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gross, but alright.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired a promising research specimen");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Crowns"
				});
				local part = this.new("scripts/items/misc/ghoul_brain_item");
				this.World.Assets.getStash().add(part);
				this.List.push({
					id = 10,
					icon = "ui/items/" + part.getIcon(),
					text = "You gain " + part.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Heart",
			Text = "[img]gfx/ui/events/event_14.png[/img]{A wheelbarrow is needed to haul the huge organ. %anatomist% claims it is the heart of an Unhold and will be of plenty use as a specimen of study. The wheelbarrow is lowered and you both take a look at it, yourself an uncultured and uneducated layman looking at something gross and unsightly, and the anatomist an uncultured and educated layman looking at something gross and fascinating. What has you uneasy is that something so massive could be at the core of beast. The heart of man is small, yet it pumps with the fire and determination to bring all under his domain. Yet this heart...\n\nDisturbingly, %anatomist% balls up his fist and punches it into one of the heart\'s chambers. You can see the muscle moving, seemingly pumping and throbbing like it may have once done. He takes his hand back out and looks upon the grime there: black tissues and a filmy layer of mold or blood or molding blood.%SPEECH_ON%Our studies will gain much from this specimen.%SPEECH_OFF%He looks at you as though for confirmation. You look at the weighted wheelbarrow and tell him if it\'s his specimen then it\'ll be his spine that gets broken hauling the damn thing around.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Remember, bend with your knees.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired a promising research specimen");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Crowns"
				});
				local part = this.new("scripts/items/misc/unhold_heart_item");
				this.World.Assets.getStash().add(part);
				this.List.push({
					id = 10,
					icon = "ui/items/" + part.getIcon(),
					text = "You gain " + part.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Gland",
			Text = "[img]gfx/ui/events/event_14.png[/img]{To you, the purchase has all the appearance of ashen peapods twisted around one another. Grey lumps curve and flatten repeatedly across the organ as its muscles contour and twist like sailor\'s ropes. The ripples end in a fat bulb of tissue. %anatomist% explains.%SPEECH_ON%It is believed that this is the organ which gives the direwolf so much energy. Even its shape carries a sort of ferocious structure, as if the organ itself meant to replicate its very purpose.%SPEECH_OFF%He cuts into the tissue and pulls it back, revealing a web of fleshen tunnels and channels that end in a bizarre complex of chambers. There\'s no telling what use a human could make of this part, but as %anatomist% starts fingering around the holes you quickly leave, only warning him to not do that so publicly lest he arise within the peasantry a form of lynch-hungry disgust.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And cut your nails.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Acquired a promising research specimen");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Crowns"
				});
				local part = this.new("scripts/items/misc/adrenaline_gland_item");
				this.World.Assets.getStash().add(part);
				this.List.push({
					id = 10,
					icon = "ui/items/" + part.getIcon(),
					text = "You gain " + part.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Bunk",
			Text = "[img]gfx/ui/events/event_14.png[/img]{When you get back to the company, %anatomist% seems a little bummed with the purchase. He tries to divest from it something of use, something which perhaps no one else before has seen, but it seems his venture is ending with naught all. He complains that he knows these parts already, that they have already been written about, and that other people have already been made famous on their discoveries of it. Chowing down on some food, you nod as you listen, and pretend to care when he looks at you with sad eyes. He says.%SPEECH_ON%This substance is what the orcs eat, and sometimes it is cut of orc itself. We\'ve known this for years. I thought I might take something out of it that had not been yet learned, yet my overconfidence has only led to the wastage of crowns.%SPEECH_OFF%You take a spoon of chicken grit and shove it in your mouth. You take out the spoon and stare at your misshapen reflection in it. Nodding, you say.%SPEECH_ON%It\'s all so fascinating. Now, have you tried eating it?%SPEECH_OFF%The anatomist stares at the strange meat. He confesses that he does not think anyone has, at least not for the purpose of study. He stares at the meat a while longer. He mumbles.%SPEECH_ON%It would be a scientific matter, would it not?%SPEECH_OFF%You take another bite of grit and nod. %anatomist% digs his hand into the strange meat and pulls out a rib dripping with soggy flesh. He begins to dry heave and quickly gets up and runs off. You take the strange rib and toss it off the table and the second it touches the ground a pack of wild dogs emerge from an alley and fight one another to eat it. You point at the dogs and yell after the anatomist.%SPEECH_ON%Hey I think I just did an experiment!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Look at \'em fight over it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(0.5, "A promising research specimen turned out to be useless");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.World.Assets.addMoney(-_event.m.Price);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Price + "[/color] Crowns"
				});
				local food = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins || !this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		if (this.World.Assets.getMoney() < 650)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Price = 0;
		this.m.Town = null;
	}

});


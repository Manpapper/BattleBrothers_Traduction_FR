this.graverobber_finds_item_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Historian = null,
		UniqueItemName = null,
		NobleName = null
	},
	function create()
	{
		this.m.ID = "event.graverobber_finds_item";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]The weather is nice. A fine evening, if any, for the moon to be where it is: an orange rind of it slipping in and out of the clouds - clouds that pass by on the seemingly innocuous gesture that a light breeze can have. So bright is this rim of a moon you wonder if any flowers might bloom, mistaking the evening light for its brighter cousin. You wonder if the millmoths and flies and armor-backed beetles see the moon and dance toward it as they would any candle or torch. Do they have that quiet desperation? That inescapable cruelty of realizing that, when your stock is placed against the greater whole, you have and are nothing... and the hatred that realization can bring, and the jealousy...\n\n Suddenly, %graverobber% the graverobber appears by your side, his smell skewering your thoughts with miasmic proficiency. He\'s hardly a man at all, but a golem, mudslaked and grass-peppered with two white eyes peering out. Sighing, you ask what he wants. He thumbs over one shoulder, the other occupied by a shovel.%SPEECH_ON%Went digging through a grave or three. Found somethin\' and I don\'t mean just what them graves are for. Wanna come take a look?%SPEECH_OFF%Of course you do...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s see...",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());

				if (_event.m.Historian != null)
				{
					this.Options.push({
						Text = "Let\'s fetch %historian% the Historian, he\'ll know about buried treasure.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]%graverobber% brings you to a big hole in the ground. The top half of a skeleton is at the bottom, its arms loose over the earth as though it had bedded there for a night\'s rest. Empty eye sockets look up at you. The graverobber crouches and grabs something. He wipes the mud and worms off it and hands it over.%SPEECH_ON%I think we can use that.%SPEECH_OFF%You nod, but tell the man to quickly fill the grave before anyone sees what he\'s done.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "He won\'t be needing that anymore.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local r = this.Math.rand(1, 8);
				local item;

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/bludgeon");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/falchion");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/weapons/shortsword");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}
				else if (r == 7)
				{
					item = this.new("scripts/items/weapons/scramasax");
				}
				else if (r == 8)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]While looking down at the goods, %historian% the rather astute scholar and historian sidles up next to you. He\'s rubbing his chin and a faint hum ruminates deeply within him.%SPEECH_ON%Yes, yes...%SPEECH_OFF%You turn to him to ask what he\'s going on about. He snaps his fingers and points down at what the graverobber had found. He explains that this isn\'t just any chest plate or weapon, but indeed the gear of a famous fighter, nobleman, and womanizer, %noblename%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fascinating.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local item;
				local i = this.Math.rand(1, 8);

				if (i == 1)
				{
					item = this.new("scripts/items/shields/named/named_bandit_kite_shield");
				}
				else if (i == 2)
				{
					item = this.new("scripts/items/shields/named/named_bandit_heater_shield");
				}
				else if (i == 3)
				{
					item = this.new("scripts/items/shields/named/named_dragon_shield");
				}
				else if (i == 4)
				{
					item = this.new("scripts/items/shields/named/named_full_metal_heater_shield");
				}
				else if (i == 5)
				{
					item = this.new("scripts/items/shields/named/named_golden_round_shield");
				}
				else if (i == 6)
				{
					item = this.new("scripts/items/shields/named/named_red_white_shield");
				}
				else if (i == 7)
				{
					item = this.new("scripts/items/shields/named/named_rider_on_horse_shield");
				}
				else if (i == 8)
				{
					item = this.new("scripts/items/shields/named/named_wing_shield");
				}

				item.m.Name = _event.m.UniqueItemName;
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_graverobber = [];
		local candidates_historian = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				candidates_graverobber.push(bro);
			}
			else if (bro.getBackground().getID() == "background.historian")
			{
				candidates_historian.push(bro);
			}
		}

		if (candidates_graverobber.len() == 0)
		{
			return;
		}

		this.m.Graverobber = candidates_graverobber[this.Math.rand(0, candidates_graverobber.len() - 1)];

		if (candidates_historian.len() != 0)
		{
			this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
		this.m.NobleName = this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)];
		this.m.UniqueItemName = this.m.NobleName + "\'s Shield";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"graverobber",
			this.m.Graverobber.getName()
		]);
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
		_vars.push([
			"noblename",
			this.m.NobleName
		]);
		_vars.push([
			"uniqueitem",
			this.m.UniqueItemName
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Historian = null;
		this.m.UniqueItemName = null;
		this.m.NobleName = null;
	}

});


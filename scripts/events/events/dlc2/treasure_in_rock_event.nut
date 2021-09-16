this.treasure_in_rock_event <- this.inherit("scripts/events/event", {
	m = {
		Miner = null,
		Tiny = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.treasure_in_rock";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_66.png[/img]%randombrother% brings you to a crack in the side of a caliche berm. You can see something glinting in the dark. Whatever it is, its earthen hold would be hard going to dig through. The sellsword nods.%SPEECH_ON%I know it\'s in there good and solid, but I reckon that\'s something worth fetching. Whatchu think?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s dig!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "DigGood";
						}
						else
						{
							return "DigBad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Miner != null)
				{
					this.Options.push({
						Text = "Some miner\'s expertise could be of use here.",
						function getResult( _event )
						{
							return "Miner";
						}

					});
				}

				if (_event.m.Tiny != null)
				{
					this.Options.push({
						Text = "Any of you tiny enough to fit into that hole?",
						function getResult( _event )
						{
							return "Tiny";
						}

					});
				}

				this.Options.push({
					Text = "That\'s not what we\'re after. Get ready to move on.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Miner",
			Text = "[img]gfx/ui/events/event_66.png[/img]%miner% nods at your request. He gathers his tools and surveys the berm for a few minutes. He spits at the rock and nods and gets to work. A few minutes time and this stone hewer\'s already weeding out the weakspots and bringing the hard soil to crumbling dust. The hidden treasure reveals itself and the man pulls it free and hands it over.%SPEECH_ON%A nice workout, captain, and I\'d say well worth the time. Appreciate you depending on me, I mean that honestly.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good work.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Miner.getImagePath());
				local item = this.new("scripts/items/trade/uncut_gems_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/trade/uncut_gems_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				_event.m.Miner.improveMood(2.0, "Used his mining experience to benefit the company");

				if (_event.m.Miner.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Miner.getMoodState()],
						text = _event.m.Miner.getName() + this.Const.MoodStateEvent[_event.m.Miner.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Tiny",
			Text = "[img]gfx/ui/events/event_66.png[/img]The ever tiny %tiny% walks up to the crack in the berm and stares into it. He turns \'round like a top.%SPEECH_ON%Now I ain\'t one to assume, but I\'ve the sense of being slighted here.%SPEECH_OFF%You assure him that you mean nothing at all by asking he make use of his comical size. He nods and gets to the task as though he were born for it, easily wiggling his way into the crack until it\'s just a pair of boots sticking out the earth. One of the sellswords glances over and quietly asks if it\'s weird that he feels the urge to tickle the feet. You ask what in the fark does that mean with no intention of attaining an answer. Thankfully, %tiny% yells out that he\'s got the item and the men help yank him back out. %tiny% flips over with the treasure held aloft in his tiny hands.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good work.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Tiny.getImagePath());
				local item = this.new("scripts/items/armor/ancient/ancient_breastplate");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain an " + item.getName()
				});
				item = this.new("scripts/items/weapons/ancient/ancient_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain an " + item.getName()
				});
				_event.m.Tiny.improveMood(2.0, "Used his unique stature to benefit the company");

				if (_event.m.Tiny.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Tiny.getMoodState()],
						text = _event.m.Tiny.getName() + this.Const.MoodStateEvent[_event.m.Tiny.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "DigGood",
			Text = "[img]gfx/ui/events/event_66.png[/img]You order the sellswords to use whatever tools are available to dig into the berm. It takes a good clip of time to make headway into the caliche, but eventually %randombrother% manages to loosen the earth enough to reach in and take the hidden treasure right out. It\'s a golden chalice and a scattering of other items one could sell on the market.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Luck smiles upon us today.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(5, 15);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Tools and Supplies."
				});
				local item = this.new("scripts/items/loot/golden_chalice_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "DigBad",
			Text = "[img]gfx/ui/events/event_66.png[/img]You order a few of the mercenaries to set upon the berm with whatever tools are good for the task. They get to it to the best of their abilities, but they\'ve barely started the dig when a chunk of caliche slides free and clips %hurtbro%, knocking him out cold. The desired treasure rolls out after him and you come to find it\'s a rusted and rusticated piece of metal of almost no use to anyone.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Goddammit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local amount = this.Math.rand(5, 10);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Tools and Supplies."
				});
				local injury = _event.m.Other.addInjury(this.Const.Injury.Accident3);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " suffers " + injury.getNameOnly()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Steppe && currentTile.TacticalType != this.Const.World.TerrainTacticalType.SteppeHills)
		{
			return;
		}

		if (this.World.Assets.getArmorParts() < 20)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_miner = [];
		local candidates_tiny = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.miner")
			{
				candidates_miner.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.tiny"))
			{
				candidates_tiny.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.lucky") && !bro.getSkills().hasSkill("trait.swift"))
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_miner.len() != 0)
		{
			this.m.Miner = candidates_miner[this.Math.rand(0, candidates_miner.len() - 1)];
		}

		if (candidates_tiny.len() != 0)
		{
			this.m.Tiny = candidates_tiny[this.Math.rand(0, candidates_tiny.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"miner",
			this.m.Miner != null ? this.m.Miner.getNameOnly() : ""
		]);
		_vars.push([
			"tiny",
			this.m.Tiny != null ? this.m.Tiny.getNameOnly() : ""
		]);
		_vars.push([
			"hurtbro",
			this.m.Other.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Miner = null;
		this.m.Tiny = null;
		this.m.Other = null;
	}

});


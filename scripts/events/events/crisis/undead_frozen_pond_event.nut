this.undead_frozen_pond_event <- this.inherit("scripts/events/event", {
	m = {
		Lightweight = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.undead_frozen_pond";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]While traversing the cold wastes, you come to the lip of a frozen pond. %randombrother% spots something sticking out its middle. You see that it\'s a knight whose body has been frozen hip-deep, but the upper body is still moving around. The eyes glow red and its fingers, jet black from frost bite, still manage to clench and grip. Its jaw is held together by ice for muscles as though with decaying and translucent tendons.\n\n %randombrother% points to the giant wiederganger with the frozen visage.%SPEECH_ON%Hey, look! That farker\'s got a big ol\' sword on him. That might be worth trying to nab, no?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Any volunteers?",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Lightweight != null)
				{
					this.Options.push({
						Text = "You are quick on your feet, %lightweightfull%. Give it a try?",
						function getResult( _event )
						{
							return "Lightweight";
						}

					});
				}

				this.Options.push({
					Text = "It\'s not worth it.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_143.png[/img]%chosenbrother% elects to try and make a run on getting the dead knight\'s sword. His first step on the pond sends an icy warble clear across the underbelly of the frozen sheet. He tests his footing again. The ice shifts and chitters, but it does not crack. With every step, the sellsword measures his own weight and its likelihood to collapse the ice - all the meanwhile, making sure he doesn\'t step on one of the corpses littered about. \n\n He successfully gets to the undead knight. Icicles dangle off its sword, the blade itself encapsulated in a layer of ice. The sellsword grabs the blade and yanks. The undead knight\'s arm lurches forward and breaks off at the elbow, sending the sellsword arse-skating backward across the pond. He slides up against the edge where your men help him up. The sword will need to be heated to get the ice off, but the weapon is definitely usable.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local item = this.new("scripts/items/weapons/greatsword");
				item.setCondition(11.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_143.png[/img]%chosenbrother% tries the ice, putting a foot right on the edge of the pond. A soft warble echoes across the pondwater\'s cold underbelly, as though someone had skipped a drumming rock across a barreled surface. He looks back at the party and shrugs.%SPEECH_ON%Seem\'s aight.%SPEECH_OFF%His next step sends him crashing through the ice. Shards break into a sort of chevron entrapment and when he reaches out to grab one it slices his hands. The men quickly throw him a rope and drag him out.\n\n Bloodied and shivering, %chosenbrother% shakes his head as he\'s wrapped in blankets.%SPEECH_ON%I-I-I-I believe that was aw-aw-aw-awful. Aw-aw-awful idea, sir.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You tried your best.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury([
					{
						ID = "injury.split_hand",
						Threshold = 0.5,
						Script = "injury/split_hand_injury"
					}
				]);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Other.getName() + " suffers " + injury.getNameOnly()
					}
				];
				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Other.getSkills().add(effect);
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Other.getName() + " is sick"
				});
			}

		});
		this.m.Screens.push({
			ID = "Lightweight",
			Text = "[img]gfx/ui/events/event_143.png[/img]%lightweight% steps forward.%SPEECH_ON%Ice? Ice is nothing. You can glide on it like this.%SPEECH_OFF%Without even a pause, the man leaps out onto the frozen pond and skates across its surface. Cracks emerge out from behind him like a wake of imminently bad news, but he remains unperturbed. He swings by the undead knight and grabs the frozen sword. The wiederganger groans as its arm breaks off at the elbow. The man merrily skates his way back to the edge of the pond and presents the sword to you. %otherbrother% steps forward and cracks the wiederganger\'s frozen arm off the handle like a man breaking a crab claw.%SPEECH_ON%Would ya look at that?%SPEECH_OFF%He crushes the fingers into fragments and in the powdered remains there is a signet. A sword and jewelry, what\'s not to love about this result?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Impressive.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Lightweight.getImagePath());
				local item = this.new("scripts/items/weapons/greatsword");
				item.setCondition(11.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
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

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (currentTile.HasRoad)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				nearTown = true;
				break;
			}
		}

		if (nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_lightweight = [];
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getCurrentProperties().getInitiative() >= 130)
			{
				candidates_lightweight.push(bro);
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

		this.m.Lightweight = candidates_lightweight[this.Math.rand(0, candidates_lightweight.len() - 1)];
		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"chosenbrother",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"lightweight",
			this.m.Lightweight != null ? this.m.Lightweight.getNameOnly() : ""
		]);
		_vars.push([
			"lightweightfull",
			this.m.Lightweight != null ? this.m.Lightweight.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Lightweight = null;
		this.m.Other = null;
	}

});


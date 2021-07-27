this.juggler_entertains_townsfolk_event <- this.inherit("scripts/events/event", {
	m = {
		Juggler = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.juggler_entertains_townsfolk";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]As the men wander through %townname% looking for things to do, %juggler% the juggler takes it upon himself to provide his own entertainment. He takes a message barker\'s scroll and folds it into a paper hat with horns. Placing it upon his head, he then glides into a crowd of peasants and asks for anything with which to juggle. They toss him all manner of objects from carrots to knives and one man even offers a newborn infant before the mother slaps him for even suggesting it. Whatever is thrown up there, the juggler easily hurls through the air, his own body twisting and turning, his feet alternating between hands to kick things back into the air. It\'s dexterous poetry in motion - and a boon for the town\'s downtrodden. You get the feeling that the juggler has represented the %companyname% well this day.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done, well done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());

				if (_event.m.Town.isSouthern())
				{
					_event.m.Town.getOwner().addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "One of your men entertained the masses");
				}
				else
				{
					_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "One of your men entertained the townsfolk");
				}

				_event.m.Juggler.improveMood(2.0, "Entertained townsfolk with his juggling");

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.juggler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary())
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

		this.m.Juggler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"juggler",
			this.m.Juggler.getNameOnly()
		]);
		_vars.push([
			"town",
			this.m.Town.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Juggler = null;
		this.m.Town = null;
	}

});


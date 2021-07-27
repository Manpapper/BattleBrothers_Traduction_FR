this.eunuch_ladies_event <- this.inherit("scripts/events/event", {
	m = {
		Eunuch = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.eunuch_ladies";
		this.m.Title = "À %town%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_85.png[/img]Word is spreading about %eunuch% the eunuch. Apparently, him and some brothers visited the town brothel. The whores and brothers alike initially made fun of the eunuch, but he demanded only five minutes with the most experienced of the ladies. She came back out after two minutes and the rumors about %eunuch%\'s bedroom prowess has only exploded from there.\n\nNow, half the town, more precisely its women, speak highly of the %companyname% and would love to see it visit again. %eunuch% himself gives you a wink and a smile. You notice that he\'s rather warty around the lips.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A hidden talent.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Eunuch.getImagePath());

				if (_event.m.Town.isSouthern())
				{
					_event.m.Town.getOwner().addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "One of your men got a reputation with the ladies");
				}
				else
				{
					_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "One of your men got a reputation with the ladies");
				}

				_event.m.Eunuch.improveMood(1.5, "Got friendly with some ladies in " + _event.m.Town.getName());

				if (_event.m.Eunuch.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Eunuch.getMoodState()],
						text = _event.m.Eunuch.getName() + this.Const.MoodStateEvent[_event.m.Eunuch.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.eunuch")
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

		this.m.Eunuch = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"eunuch",
			this.m.Eunuch.getNameOnly()
		]);
		_vars.push([
			"town",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Eunuch = null;
		this.m.Town = null;
	}

});


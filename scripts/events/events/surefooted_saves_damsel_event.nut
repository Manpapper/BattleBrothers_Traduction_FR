this.surefooted_saves_damsel_event <- this.inherit("scripts/events/event", {
	m = {
		Surefooted = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.surefooted_saves_damsel";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_85.png[/img]A few brothers come back to you with the most curious of stories. Apparently %surefooted%, the ever surefooted sellsword, managed to make a bit of a name for himself in %townname%.\n\n While carousing with ladies on a tavern staircase, the bannister broke and a damsel went careening downward. With a horn of ale in one hand and a wench wrapped in the tender grip of the other, the mercenary stuck his foot out and managed to catch the falling mistress on the toe of his boot, quite literally bringing her to heel much to the roaring applause of the inebriated crowd below. You ask where he is now. The mercenaries laugh.%SPEECH_ON%Dropping trou with the easily impressed, what else?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Of course, of course.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Surefooted.getImagePath());

				if (!_event.m.Town.isSouthern())
				{
					_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "One of your men got a reputation with the ladies");
				}

				_event.m.Surefooted.improveMood(2.0, "Had a bit of a partie carree");

				if (_event.m.Surefooted.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Surefooted.getMoodState()],
						text = _event.m.Surefooted.getName() + this.Const.MoodStateEvent[_event.m.Surefooted.getMoodState()]
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
			if (bro.getLevel() >= 2 && bro.getSkills().hasSkill("trait.sure_footing"))
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

		this.m.Surefooted = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"surefooted",
			this.m.Surefooted.getNameOnly()
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
		this.m.Surefooted = null;
		this.m.Town = null;
	}

});


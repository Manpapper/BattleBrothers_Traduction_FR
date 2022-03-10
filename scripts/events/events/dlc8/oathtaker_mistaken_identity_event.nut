this.oathtaker_mistaken_identity_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.oathtaker_mistaken_identity";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%{A boy suddenly runs up to the company. He practically gloms onto %oathtaker%\'s leg and the Oathtaker\'s countenance takes on an appearance of confusion. He asks the runt if he is lost. The boy springs back.%SPEECH_ON%Lost? No, I\'m not lost! I thought I\'d never see your sort again, the vaunted Oathbringers!%SPEECH_OFF%%oathtaker%\'s eye twitches, his hands tightens around the handle of his weapon. You\'re not sure when his screaming started and when the boy ended up on the ground with a blackened eye, but the righteous rage cracked from the Oathtaker like a bolt of holy fury, and you watch as he pushes the boy into the mud screaming and frothing that he is an Oathtaker, not some horrible, ugly, and inglorious Oathbringer, and he smooshes the boy\'s face into the grass and drags him into a pile of horse dung and sleds him across the road on the rolls of ordure until the boy cries out and runs for his life. Finished, %oathtaker% straightens up, affixing his attire, regirding his disheveled weaponry.%SPEECH_ON%Let us leave this hellhole of filthy degenerates, captain.%SPEECH_OFF%As he struts off, you turn around to see the townspeople staring at you in horror.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s pretty much what it looks like.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				this.World.Assets.addMoralReputation(-1);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "One of your men beat up a kid");
				_event.m.Oathtaker.worsenMood(2.0, "Was mistaken for an Oathbringer");

				if (_event.m.Oathtaker.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()],
						text = _event.m.Oathtaker.getName() + this.Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
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
		local oathtaker_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				oathtaker_candidates.push(bro);
			}
		}

		if (oathtaker_candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = oathtaker_candidates[this.Math.rand(0, oathtaker_candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 3 * oathtaker_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
		this.m.Town = null;
	}

});


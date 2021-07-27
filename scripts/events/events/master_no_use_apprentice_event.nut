this.master_no_use_apprentice_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.master_no_use_apprentice";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%While walking about %townname%, you run into an old man dragging a youthful man by the ear.%SPEECH_ON%You want to be a master, it takes time! Blood! Sweat! Tears if yer of the cryin\' sort and there\'s no shame in that if ya are. Here, look! A sellsword! If you want to fight so bad, why not go to him?%SPEECH_OFF%You hold your hands out and ask for an explanation before getting offloaded some annoying git. The elderly man calms himself and lets the kid\'s ear go.%SPEECH_ON%Aye, I suppose you are owed more of an explanation. I\'m the fencing master of this town, but I teach discipline and patience before anyone so much can touch a sword! And this damned student of mine has neither! So I told him, if you want to fight so bad, get the hell out!%SPEECH_OFF%You look at the kid. He\'s got a fresh face, but there is in fact some impatient eagerness in his eyes. You ask him if what the swordmaster says is true. The kid nods.%SPEECH_ON%Yessir. And I\'d be more than happy to fight for you, too.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, we\'ll take him.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "No, thanks. He\'s all yours.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"apprentice_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "An impatient student of a fencing and swordmaster, %name% didn\'t have the mental aptitude to stick with the trials and tribulations of becoming a master of the blade himself. But what he lacks in mental fortitude he more than makes up for in effort. You \'hired\' him simply by taking him off the old man\'s hands.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() <= 1)
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

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
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
		this.m.Dude = null;
		this.m.Town = null;
	}

});


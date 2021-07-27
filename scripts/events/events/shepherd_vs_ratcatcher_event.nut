this.shepherd_vs_ratcatcher_event <- this.inherit("scripts/events/event", {
	m = {
		Shepherd = null,
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.shepherd_vs_ratcatcher";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%ratcatcher% and %shepherd% are sitting beside the campfire. As their conversation carries on, the ratcatcher becomes a bit confused.%SPEECH_ON%Lemme, lemme, lemme get this straight. Y-you use a stick, and so they follow because you have the stick? It\'s all about the stick?%SPEECH_OFF%Nodding, the shepherd explains.%SPEECH_ON%I prefer to call it a staff, but yes. Sheep are simple creatures and all that they demand is a leader. The staff is an itemization of my role. I wield the staff, therefore I am the leader. At least in a little sheep\'s eyes. An obedient dog helps a lot, too. Truthfully, a dog would be the true leader did they not have the loyalty and honor we wished we had ourselves.%SPEECH_OFF%%ratcatcher% nods.%SPEECH_ON%I\'ll have to try the stick, I mean staff, with my rats. And get a dog, too.%SPEECH_OFF%The shepherd smiles.%SPEECH_ON%Or a cat. What? I\'m joking, friend, just joking.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Like peas in a pod. Or pigs in a pen?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Shepherd.getImagePath());
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				_event.m.Shepherd.improveMood(1.0, "Bonded with " + _event.m.Ratcatcher.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Shepherd.getMoodState()],
					text = _event.m.Shepherd.getName() + this.Const.MoodStateEvent[_event.m.Shepherd.getMoodState()]
				});
				_event.m.Ratcatcher.improveMood(1.0, "Bonded with " + _event.m.Shepherd.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Ratcatcher.getMoodState()],
					text = _event.m.Ratcatcher.getName() + this.Const.MoodStateEvent[_event.m.Ratcatcher.getMoodState()]
				});
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

		local shepherd_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 4 && bro.getBackground().getID() == "background.shepherd")
			{
				shepherd_candidates.push(bro);
				break;
			}
		}

		if (shepherd_candidates.len() == 0)
		{
			return;
		}

		local ratcatcher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.ratcatcher")
			{
				ratcatcher_candidates.push(bro);
			}
		}

		if (ratcatcher_candidates.len() == 0)
		{
			return;
		}

		this.m.Shepherd = shepherd_candidates[this.Math.rand(0, shepherd_candidates.len() - 1)];
		this.m.Ratcatcher = ratcatcher_candidates[this.Math.rand(0, ratcatcher_candidates.len() - 1)];
		this.m.Score = (shepherd_candidates.len() + ratcatcher_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"shepherd",
			this.m.Shepherd.getNameOnly()
		]);
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Shepherd = null;
		this.m.Ratcatcher = null;
	}

});


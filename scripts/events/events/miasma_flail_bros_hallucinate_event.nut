this.miasma_flail_bros_hallucinate_event <- this.inherit("scripts/events/event", {
	m = {
		Bro1 = null,
		Bro2 = null
	},
	function create()
	{
		this.m.ID = "event.miasma_flail_bros_hallucinate";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Upon hearing some sellswords yelling at each other, you reluctantly set aside your quill pen and step outside your tent. There you find %hauntedbrother1% and %hauntedbrother2% in each other\'s faces - and between them they\'re pulling at the Grand Diviner\'s flail. What is being screamed between them are obscenities of a most graphic nature, and just as you\'re about to step in the flail glows a bright green and both sellswords drop the weapon to lunge at each other. The fight is ended fast, but not without injuries.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Just what did they see?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());
				this.Characters.push(_event.m.Bro2.getImagePath());
				_event.m.Bro1.addLightInjury();
				_event.m.Bro2.addLightInjury();
				_event.m.Bro1.worsenMood(1.0, "Was ensorcelled by the Grand Diviner\'s Flail");
				_event.m.Bro2.worsenMood(1.0, "Was ensorcelled by the Grand Diviner\'s Flail");
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Bro1.getName() + " suffers light wounds"
				});
				this.List.push({
					id = 11,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Bro2.getName() + " suffers light wounds"
				});

				if (_event.m.Bro1.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 12,
						icon = this.Const.MoodStateIcon[_event.m.Bro1.getMoodState()],
						text = _event.m.Bro1.getName() + this.Const.MoodStateEvent[_event.m.Bro1.getMoodState()]
					});
				}

				if (_event.m.Bro2.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 13,
						icon = this.Const.MoodStateIcon[_event.m.Bro2.getMoodState()],
						text = _event.m.Bro2.getName() + this.Const.MoodStateEvent[_event.m.Bro2.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local haveFlail = false;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			candidates.push(bro);
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && item.getID() == "weapon.miasma_flail")
			{
				haveFlail = true;
			}
		}

		if (!haveFlail)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && item.getID() == "weapon.miasma_flail")
				{
					haveFlail = true;
					break;
				}
			}
		}

		if (!haveFlail)
		{
			return;
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local idx = this.Math.rand(0, candidates.len() - 1);
		this.m.Bro1 = candidates[idx];
		candidates.remove(idx);
		idx = this.Math.rand(0, candidates.len() - 1);
		this.m.Bro2 = candidates[idx];
		this.m.Score = 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hauntedbrother1",
			this.m.Bro1.getNameOnly()
		]);
		_vars.push([
			"hauntedbrother2",
			this.m.Bro2.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Bro1 = null;
		this.m.Bro2 = null;
	}

});


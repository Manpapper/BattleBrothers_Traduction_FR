this.miasma_flail_spooks_bro_2_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.miasma_flail_spooks_bro_2";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{You find %hauntedbrother% staring into the Grand Diviner\'s flail. The glassy bulb is filled with mist, and the sellsword is raking his tongue to suck up the condensation. Hand to your sword, you ask what he\'s doing, and the man freezes, and his eyes open and he jerks back like a man snorting awake knowing he\'s late for work.%SPEECH_ON%Augh! What the fark? How did... I was sleeping, when... what the fark!%SPEECH_OFF%Some of the men have said the weapon has been murmuring when nobody\'s looking, and it seems every so often it does capture someone\'s ear...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s only a weapon, you fools.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.worsenMood(1.0, "Was ensorcelled by the Grand Diviner\'s Flail");

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}

				_event.m.Dude.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Dude.getName() + " suffers light wounds"
				});
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

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hauntedbrother",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});


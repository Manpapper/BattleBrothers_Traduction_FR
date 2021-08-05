this.shortsighted_shoots_bro_event <- this.inherit("scripts/events/event", {
	m = {
		Shortsighted = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.shortsighted_shoots_bro";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img] You take a good, long look at the men, a gaze that flickers from one to the other and then back again, all the while shaking your head. %shortsightedtarget% is holding his head, a rather large lump cresting at the hairline. He looks at %shortsighted% then to you. Both men shrug. You ask %shortsighted% what happened. He explains.%SPEECH_ON%Thought I saw somethin\' that wasn\'t there.%SPEECH_OFF%Incredulously, %shortsightedtarget% throws his hand out.%SPEECH_ON%I said, \'Hey, it\'s me\' and you clocked me anyway.%SPEECH_OFF%Throwing out his own hands, %shortsighted% defends himself.%SPEECH_ON%\'Hey it\'s me\' aren\'t words beholden to ya! Any man can say them words! I reckon any man of ill-will would say them very words before he followed them with a sword, I bet he would!%SPEECH_OFF%It appears that %shortsighted%\'s poor eyesight has led to something of an accident.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get that wound looked at, %shortsightedtargetshort%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Shortsighted.getImagePath());
				this.Characters.push(_event.m.OtherGuy.getImagePath());
				local injury = _event.m.OtherGuy.addInjury(this.Const.Injury.PiercingBody, 0.4);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.OtherGuy.getName() + " souffre de " + injury.getNameOnly()
				});
				_event.m.Shortsighted.worsenMood(1.0, "Shot at " + _event.m.OtherGuy.getName() + " by accident");
				_event.m.OtherGuy.worsenMood(1.0, "Got shot at by " + _event.m.Shortsighted.getName());

				if (_event.m.OtherGuy.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.OtherGuy.getMoodState()],
						text = _event.m.OtherGuy.getName() + this.Const.MoodStateEvent[_event.m.OtherGuy.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_shortsighted = [];

		foreach( bro in brothers )
		{
			if (!bro.getBackground().isNoble() && bro.getSkills().hasSkill("trait.short_sighted") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates_shortsighted.push(bro);
			}
		}

		if (candidates_shortsighted.len() == 0)
		{
			return;
		}

		this.m.Shortsighted = candidates_shortsighted[this.Math.rand(0, candidates_shortsighted.len() - 1)];
		this.m.Score = candidates_shortsighted.len() * 5;

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Shortsighted.getID() && bro.getBackground().getID() != "background.slave")
			{
				this.m.OtherGuy = bro;
				break;
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"shortsighted",
			this.m.Shortsighted.getName()
		]);
		_vars.push([
			"shortsightedtarget",
			this.m.OtherGuy.getName()
		]);
		_vars.push([
			"shortsightedtargetshort",
			this.m.OtherGuy.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Shortsighted = null;
		this.m.OtherGuy = null;
	}

});


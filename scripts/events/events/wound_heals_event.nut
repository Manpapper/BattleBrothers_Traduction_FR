this.wound_heals_event <- this.inherit("scripts/events/event", {
	m = {
		Injured = null
	},
	function create()
	{
		this.m.ID = "event.wound_heals";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{Good to have you back. | Good as new.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local bg = _event.m.Injured.getBackground().getID();

				if (bg == "background.monk" || bg == "background.flagellant" || bg == "background.pacified_flagellant" || bg == "background.monk_turned_flagellant" || bg == "background.cultist")
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]{You go to check on %hurtbrother% - he\'d suffered a terrible wound not long ago and sometimes it can lift a man\'s spirits just to let him know others care. Thinking you\'ll find the man nursing his injuries, you instead are surprised to see that he is in good health. The wounds have apparently healed in such speedy fashion that others might call it a miracle. | %hurtbrother% was injured in battle and you figure it\'d be best to go see how he is doing. Surprisingly, he\'s doing quite well. His wounds have healed in such quick fashion you almost want to believe he consulted some dark arts while no one was looking. There are no signs of black magics around, just one sturdy and hard to kill man of flesh and blood. | %hurtbrother% enters your tent and flashes his wound - or what\'s left of it. The garish thing has seemingly healed entirely. The mercenary looks at you with a giddy smile.%SPEECH_ON%They\'ll have to try harder to take me out of this world, captain.%SPEECH_OFF% | %hurtbrother% comes into your tent and shows off an old wound. He speaks excitedly.%SPEECH_ON%Is that a miracle or what?%SPEECH_OFF%The injury has healed almost completely. You tell the man that he\'s made of hardier things and the gods had nothing to do with it. He shakes his head.%SPEECH_ON%You need to have more faith.%SPEECH_OFF% | You go looking for %hurtbrother% - the mercenary had taken quite the injury last you saw. The man, however, is in high spirits. He turns to you, taking a break from sharpening some steel.%SPEECH_ON%Need something, sir?%SPEECH_OFF%You inquire about his injury. He shrugs.%SPEECH_ON%I don\'t die easy. {I ate a lot of them pointy orange things when I was young. | I ate a lot of lettuce growing up. One might say I\'m hard to... kale.}%SPEECH_OFF%}";
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]{You go to check on %hurtbrother% - he\'d suffered a terrible wound not long ago and sometimes it can lift a man\'s spirits just to let him know others care. Thinking you\'ll find the man nursing his injuries, you instead are surprised to see that he is in good health. The wounds have apparently healed in such speedy fashion that others might call it a miracle. | %hurtbrother% was injured in battle and you figure it\'d be best to go see how he is doing. Surprisingly, he\'s doing quite well. His wounds have healed in such quick fashion you almost want to believe he consulted some dark arts while no one was looking. There are no signs of black magics around, just one sturdy and hard to kill man of flesh and blood. | %hurtbrother% enters your tent and flashes his wound - or what\'s left of it. The garish thing has seemingly healed entirely. The mercenary looks at you with a giddy smile.%SPEECH_ON%They\'ll have to try harder to take me out of this world, captain.%SPEECH_OFF% | %hurtbrother% comes into your tent and shows off an old wound. He speaks excitedly.%SPEECH_ON%Is that a miracle or what?%SPEECH_OFF%The injury has healed almost completely. You tell the man that he\'s made of hardier things and the gods had nothing to do with it. He nods.%SPEECH_ON%Yeah, I know. But it\'d be nice if they were looking out for me, too. Just in case...%SPEECH_OFF% | You go looking for %hurtbrother% - the mercenary had taken quite the injury last you saw. The man, however, is in high spirits. He turns to you, taking a break from sharpening some steel.%SPEECH_ON%Need something sir?%SPEECH_OFF%You inquire about his injury. He shrugs.%SPEECH_ON%I don\'t die easy. {I ate a lot of them pointy orange things when I was young. | I ate a lot of lettuce growing up. One might say I\'m hard to... kale.}%SPEECH_OFF%}";
				}

				this.Characters.push(_event.m.Injured.getImagePath());
				local injuries = _event.m.Injured.getSkills().query(this.Const.SkillType.TemporaryInjury);
				local injury = injuries[this.Math.rand(0, injuries.len() - 1)];
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Injured.getName() + " no longer suffers from " + injury.getNameOnly()
					}
				];
				injury.removeSelf();
				_event.m.Injured.updateInjuryVisuals();
				_event.m.Injured.getSkills().update();
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.slave" && bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Injured = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hurtbrother",
			this.m.Injured.getName()
		]);
	}

	function onClear()
	{
		this.m.Injured = null;
	}

});


this.apprentice_vs_anatomist_event <- this.inherit("scripts/events/event", {
	m = {
		Apprentice = null,
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.apprentice_vs_anatomist";
		this.m.Title = "During camp...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You find %apprentice% the apprentice under the wings of %anatomist% the anatomist. It\'s a bit of a frightful sight, as you briefly wonder if the egghead is planning something nefarious. But %apprentice% is only learning things from him, as he is wont to do with most in the company. This time around it is not martial matters to which the anatomist is privy and the apprentice not, but instead methods of how to think, how to remember, and how to recall. You see %anatomist% tap his own head.%SPEECH_ON%Now remember, the faintest of inks is infinitely stronger than the most incredible of minds. All that you remember, you write down, but also recall this: your mind shall remember things you think you\'ve forgotten. If in a moment of need, do not dwell on your thoughts, but let them come to the fore on their own, as they will usher themselves into the light without aid, but if sought they will only go deeper, and wish to be forgotten.%SPEECH_OFF%The apprentice nods attentively and takes notes. So long as these conversations stay within the bounds of not dissecting animals and questioning the old gods, you\'ve no real qualm about it.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Just don\'t spend too much time together.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local effect = this.new("scripts/skills/effects_world/new_trained_effect");
				effect.m.Duration = 3;
				effect.m.XPGainMult = 1.35;
				effect.m.Icon = "skills/status_effect_76.png";
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Apprentice.getName() + " gains Training Experience"
				});
				_event.m.Apprentice.getSkills().add(effect);
				_event.m.Apprentice.getFlags().add("learnedFromAnatomist");
				_event.m.Apprentice.improveMood(1.0, "Learned from " + _event.m.Anatomist.getName());
				_event.m.Anatomist.improveMood(0.5, "Has taught " + _event.m.Apprentice.getName() + " something");

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
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

		local brothers = this.World.getPlayerRoster().getAll();
		local apprentice_candidates = [];
		local teacher_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.apprentice" && !bro.getFlags().has("learnedFromAnatomist") && !bro.getSkills().hasSkill("effects.trained"))
			{
				apprentice_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.anatomist")
			{
				teacher_candidates.push(bro);
			}
		}

		if (apprentice_candidates.len() == 0 || teacher_candidates.len() == 0)
		{
			return;
		}

		this.m.Apprentice = apprentice_candidates[this.Math.rand(0, apprentice_candidates.len() - 1)];
		this.m.Anatomist = teacher_candidates[this.Math.rand(0, teacher_candidates.len() - 1)];
		this.m.Score = (apprentice_candidates.len() + teacher_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"apprentice",
			this.m.Apprentice.getNameOnly()
		]);
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Apprentice = null;
		this.m.Anatomist = null;
	}

});


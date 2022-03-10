this.gladiator_origin_vs_anatomist_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Gladiator = null
	},
	function create()
	{
		this.m.ID = "event.gladiator_origin_vs_anatomist";
		this.m.Title = "During camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{You see %anatomist% and %gladiator% sitting together near the campfire. The anatomist and gladiator seem ill-suited for conversation, and in little time does the latter rise to his feet with great fury.%SPEECH_ON%Enhancements? You think I take enhancements? You foolish, stick-shaped, daisy-pulling, corpse-chasing fool! My muscles are made out of sweat and blood! No pain, no gain!%SPEECH_OFF%The gladiator kicks a pile of ash onto the anatomist and storms off. %anatomist% cleans himself off, then takes out a ream of notes. He remarks that the \'subject\' is experiencing flashes of hot anger. You ask the man if he\'s secretly doing something to the gladiator. %anatomist% snaps his notebook closed.%SPEECH_ON%Captain! I would never!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A strangely terse retort, %anatomist%...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Gladiator.getImagePath());
				_event.m.Anatomist.getFlags().set("IsExperimentingOnGladiator", true);
				_event.m.Gladiator.getFlags().set("IsJuiced", true);
				_event.m.Gladiator.getBaseProperties().Hitpoints += 1;
				_event.m.Gladiator.getBaseProperties().Bravery += 1;
				_event.m.Gladiator.getBaseProperties().Stamina += 1;
				_event.m.Gladiator.getBaseProperties().Initiative += 1;
				_event.m.Gladiator.getBaseProperties().MeleeSkill += 1;
				_event.m.Gladiator.getBaseProperties().RangedSkill += 1;
				_event.m.Gladiator.getBaseProperties().MeleeDefense += 1;
				_event.m.Gladiator.getBaseProperties().RangedDefense += 1;
				_event.m.Gladiator.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Hitpoints"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Fatigue"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Initiative"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Melee Skill"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Ranged Skill"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Melee Defense"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.Gladiator.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Ranged Defense"
				});
				_event.m.Gladiator.worsenMood(0.5, "Was accused of taking artificial enhancements");

				if (_event.m.Gladiator.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator.getMoodState()],
						text = _event.m.Gladiator.getName() + this.Const.MoodStateEvent[_event.m.Gladiator.getMoodState()]
					});
				}

				_event.m.Anatomist.improveMood(0.5, "Experiments on " + _event.m.Gladiator.getName() + " are progressing nicely");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
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

		if (this.World.Assets.getOrigin().getID() != "scenario.gladiators")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local gladiator_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && !bro.getFlags().has("IsExperimentingOnGladiator"))
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.gladiator" && bro.getFlags().get("IsPlayerCharacter") && !bro.getFlags().has("IsJuiced"))
			{
				gladiator_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0 || gladiator_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Gladiator = gladiator_candidates[this.Math.rand(0, gladiator_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"gladiator",
			this.m.Gladiator.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Gladiator = null;
	}

});


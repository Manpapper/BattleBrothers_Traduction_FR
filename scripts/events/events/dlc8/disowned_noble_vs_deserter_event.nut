this.disowned_noble_vs_deserter_event <- this.inherit("scripts/events/event", {
	m = {
		Deserter = null,
		Disowned = null
	},
	function create()
	{
		this.m.ID = "event.disowned_noble_vs_deserter";
		this.m.Title = "During camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%deserter% the deserter and %disowned% the disowned nobleman are staring at each other over a campfire. Being that the camp is a rather romanceless place, such a thing usually precedes one thing: a barn burner of a fight. But, instead, and rather whimsically, both men slowly start to smile. %deserter% points a finger.%SPEECH_ON%You were commanding %randomname%\'s levy out west, right?%SPEECH_OFF%The disowned nobleman laughs and smacks his knee.%SPEECH_ON%Sonuvabitch. I knew you looked familiar! You little deserter, you, do you have any idea how long we looked for your damn arse? One whole week! We did catch the rest, but you, you got away.%SPEECH_OFF%The deserter laughs.%SPEECH_ON%And now look at us, fighting for the same mercenary company! What are the odds, right? What\'d you do with the guys you did catch, by the way?%SPEECH_OFF%%disowned% shrugs.%SPEECH_ON%Oh, we hanged them, of course. In fact, it reminds me of an old trick that...well, let\'s just say, those were the days!%SPEECH_OFF%%deserter% stares into the fire for a moment. He looks up.%SPEECH_ON%Haha, yeah.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s a small world, at least for outcasts.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Deserter.getImagePath());
				this.Characters.push(_event.m.Disowned.getImagePath());
				_event.m.Deserter.getFlags().add("reminiscedWithDisowned");
				_event.m.Disowned.getFlags().add("reminiscedWithDeserter");
				_event.m.Disowned.improveMood(1.0, "Reminisced about old times");

				if (_event.m.Disowned.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Disowned.getMoodState()],
						text = _event.m.Disowned.getName() + this.Const.MoodStateEvent[_event.m.Disowned.getMoodState()]
					});
				}

				local attack_boost = this.Math.rand(1, 3);
				_event.m.Disowned.getBaseProperties().MeleeSkill += attack_boost;
				_event.m.Disowned.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Disowned.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + attack_boost + "[/color] Melee Skill"
				});
				_event.m.Deserter.improveMood(1.0, "Reminisced about old times");

				if (_event.m.Deserter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Deserter.getMoodState()],
						text = _event.m.Deserter.getName() + this.Const.MoodStateEvent[_event.m.Deserter.getMoodState()]
					});
				}

				local resolve_boost = this.Math.rand(2, 4);
				_event.m.Deserter.getBaseProperties().Bravery += resolve_boost;
				_event.m.Deserter.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Deserter.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve_boost + "[/color] Resolve"
				});
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
		local deserter_candidates = [];
		local disowned_candidates = [];

		foreach( bro in brothers )
		{
			if ((bro.getBackground().getID() == "background.disowned_noble" || bro.getBackground().getID() == "background.regent_in_absentia") && !bro.getFlags().has("reminiscedWithDeserter"))
			{
				disowned_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.deserter" && !bro.getFlags().has("reminiscedWithDisowned"))
			{
				deserter_candidates.push(bro);
			}
		}

		if (disowned_candidates.len() == 0 || deserter_candidates.len() == 0)
		{
			return;
		}

		this.m.Deserter = deserter_candidates[this.Math.rand(0, deserter_candidates.len() - 1)];
		this.m.Disowned = disowned_candidates[this.Math.rand(0, disowned_candidates.len() - 1)];
		this.m.Score = 3 * disowned_candidates.len() + 3 * deserter_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"deserter",
			this.m.Deserter.getName()
		]);
		_vars.push([
			"disowned",
			this.m.Disowned.getName()
		]);
	}

	function onClear()
	{
		this.m.Deserter = null;
		this.m.Disowned = null;
	}

});


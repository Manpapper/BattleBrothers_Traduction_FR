this.disowned_noble_vs_deserter_event <- this.inherit("scripts/events/event", {
	m = {
		Deserter = null,
		Disowned = null
	},
	function create()
	{
		this.m.ID = "event.disowned_noble_vs_deserter";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%deserter% le déserteur et %disowned% le noble désavoué se regardent fixement autour d\'un feu de camp. Le camp étant un endroit peu romantique, il est évident qu\'il va se passer autre chose: un affrontement de type \"combat de taverne\". Mais, au lieu de cela, et de façon plutôt étrange, les deux hommes commencent lentement à sourire. %deserter% lève son doigt.%SPEECH_ON%Vous commandiez le régiment %randomname% à l\'ouest, non?%SPEECH_OFF%Le noble désavoué rit et se frappe le genou.%SPEECH_ON%Connard. Je savais que vous me disiez quelque chose! Vous, petit déserteur, vous savez combien de temps on a cherché votre cul? Une semaine entière! Nous avons attrapé tout le monde, mais vous, vous vous êtes échappé!.%SPEECH_OFF%Le déserteur rigole.%SPEECH_ON%Et maintenant, regardez-nous, combattant pour la même compagnie de mercenaires! Quelles sont les chances, hein? Qu\'est-ce que vous avez fait des gars que vous avez attrapés, au fait?%SPEECH_OFF%%disowned% hausse les épaules.%SPEECH_ON%Oh, on les pendait, bien sûr. En fait, ça me rappelle un vieux truc... disons que c\'était le bon temps!%SPEECH_OFF%%deserter% regarde fixement le feu pendant un moment. Il lève les yeux.%SPEECH_ON%Haha, ouais.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le monde est petit, du moins pour les parias.",
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
			this.m.Deserter.getNameOnly()
		]);
		_vars.push([
			"disowned",
			this.m.Disowned.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Deserter = null;
		this.m.Disowned = null;
	}

});


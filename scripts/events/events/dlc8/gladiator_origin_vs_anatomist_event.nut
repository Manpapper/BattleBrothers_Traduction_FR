this.gladiator_origin_vs_anatomist_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Gladiator = null
	},
	function create()
	{
		this.m.ID = "event.gladiator_origin_vs_anatomist";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Vous voyez %anatomiste% et %gladiator% assis ensemble près du feu de camp. L\'anatomiste et le gladiateur semblent peu enclins à la conversation, et peu de temps après, ce dernier se lève avec une grande fureur.%SPEECH_ON%Des produits? Vous pensez que je prends des produits? Espèce d\'idiot en forme de bâton, tireur de marguerite, chasseur de cadavres! Mes muscles sont faits de sueur et de sang! Pas de douleur, pas de gain!%SPEECH_OFF%Le gladiateur jette un tas de cendres sur l\'anatomiste et part en trombe. %anatomiste% se nettoie, puis sort un carnet. Il remarque que le \"sujet\" a des bouffées de colère. Vous lui demandez si il a fait secrètement quelque chose au gladiateur. L\'anatomiste referme son carnet de notes.%SPEECH_ON%Capitaine! Je ne ferais jamais ça!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une réplique étrangement laconique, %anatomist%...",
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


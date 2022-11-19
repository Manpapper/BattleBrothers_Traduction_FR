this.apprentice_vs_anatomist_event <- this.inherit("scripts/events/event", {
	m = {
		Apprentice = null,
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.apprentice_vs_anatomist";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous trouvez %apprentice% l\'apprentie sous les ordres de %anatomist% l\'anatomiste. C\'est un spectacle un peu effrayant, car vous vous demandez brièvement si le crâne d\'œuf ne prépare pas quelque chose d\'infâme. Mais %apprentice% ne fait qu\'étudier, comme il a l\'habitude de le faire avec la plupart des membres de la compagnie. Cette fois, il ne s\'agit pas de questions martiales auxquelles l\'anatomiste initie l\'apprenti, mais plutôt de méthodes de réflexion, de mémorisation et de comment se souvenir des choses. Vous voyez %anatomist% se taper la tête.%SPEECH_ON%Maintenant, souvenez-vous, la plus faible des encres est infiniment plus forte que le plus incroyable des esprits. Tout ce dont vous vous souvenez, vous l\'écrivez, mais rappelez-vous aussi ceci: votre esprit se souviendra des choses que vous pensez avoir oubliées. Si vous êtes dans un moment de détresse, ne vous attardez pas sur vos pensées, mais laissez-les venir d\'elles-mêmes car elles se frayeront un chemin vers la lumière toutes seules. Mais si on les cherche, elles ne feront que s\'enfoncer davantage et souhaiteront être oubliées.%SPEECH_OFF%L\'apprenti acquiesce attentivement et prend des notes. Tant que ces conversations restent dans les limites de la dissection des animaux et de la remise en question des anciens dieux, vous n\'avez pas de réel problème.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ne passez pas trop de temps ensemble.",
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
				
				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
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


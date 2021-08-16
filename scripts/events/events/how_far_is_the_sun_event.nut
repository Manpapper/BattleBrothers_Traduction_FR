this.how_far_is_the_sun_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null,
		Monk = null,
		Cultist = null,
		Archer = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.how_far_is_the_sun";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Alors qu\'ils se reposent, les hommes entament une conversation sur la distance à laquelle se trouve le soleil. %otherbrother% regarde en l\'air, grimaçant et serrant les dents alors qu\'il est presque aveuglé en essayant d\'évaluer la distance. Finalement, il baisse les yeux : %SPEECH_ON% Je parie qu\'il est à environ dix ou quinze miles. %SPEECH_OFF% Il acquiesce à son propre résumé, vraisemblablement exact : %SPEECH_ON% Oui, probablement même pas aussi loin. J\'ai entendu une histoire à propos d\'un archer dans un pays lointain qui l\'a touché avec une flèche.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				if (_event.m.Historian != null)
				{
					this.Options.push({
						Text = "%historianfull%, qu\'as-tu à dire ?",
						function getResult( _event )
						{
							return "Historian";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Je parie que %monkfull% connaît la vérité.",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "Je te vois pensif, %cultistfull%. Qu\'en dis-tu ?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				if (_event.m.Archer != null)
				{
					this.Options.push({
						Text = "%archerfull%, pourquoi ne pas tenter le coup ?",
						function getResult( _event )
						{
							return "Archer";
						}

					});
				}

				this.Options.push({
					Text = "Assez parlé d\'étoiles. Retournons sur la route.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Historian",
			Text = "[img]gfx/ui/events/event_05.png[/img]%historian% l\'historien se joint à la conversation. %SPEECH_ON%Je doute de la véracité de cette affirmation concernant le tir à l\'arc. Écoutez, voici une histoire beaucoup plus plausible que j\'ai lue : il y a des hommes dans les montagnes de l\'est qui ont de grosses longues-vues pour regarder le ciel nocturne. Ils pensent que le soleil est très loin. Au moins 15 000 km, et même plus. Ils pensent aussi que les lumières de la nuit sont d\'autres soleils et pas les âmes des héros morts.%SPEECH_OFF%%otherbrother% se lève.%SPEECH_ON%Fais attention à ce que tu dis, idiot, et ne dis pas de mal de nos ancêtres.%SPEECH_OFF%L\'historien hoche la tête.%SPEECH_ON%Bien sûr ! Ce n\'était qu\'une idée.%SPEECH_OFF% Quelle foutaise. Quelle connerie pour un homme supposé \"intelligent\" comme %historian%. Quelques-uns des frères se moquent des idées stupides de l\'historien.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il est vraiment très drôle.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Historian.getID() || bro.getBackground().getID() == "background.historian" || bro.getSkills().hasSkill("trait.bright"))
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Diverti par les notions stupides à propos du soleil de " + _event.m.Historian.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_05.png[/img]%monk% le moine se joint à la conversation. %SPEECH_ON%Le soleil n\'est ni lointain ni proche. C\'est l\'œil de beaucoup de dieux, la lunette à travers laquelle ils nous surveillent.%SPEECH_OFF%%otherbrother% acquiesce, mais ensuite, curieux, il pose une question sur la lune. Le moine sourit avec confiance. %SPEECH_ON%Pensez-vous que les dieux nous éclairent à toute heure ? Bien sûr, ils tamisent un peu les lumières, pour que nous, les mortels, ayons une bonne nuit de sommeil.%SPEECH_OFF%Vous acquiescez. Vraiment, les vieux dieux veillent toujours sur nous.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bénissez-les.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getEthnicity() == 1 || bro.getID() == _event.m.Monk.getID() || bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist" || bro.getBackground().getID() == "background.historian")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Encouragé par le sermon de " + _event.m.Monk.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Cultist",
			Text = "[img]gfx/ui/events/event_05.png[/img]%cultist% le cultist se lève et regarde le soleil. Alors qu\'il continue à le fixer, une ombre se dessine lentement sur son visage, comme si une entité le protégeait de la lumière. Soudain, il lève une main et commence à dessiner des rites aériens avec sa main. On jurerait que l\'obscurité sur son visage se déplace comme une empreinte de ses dessins, une sorte de tatouage mouvant. Quand il a fini, il s\'assied.%SPEECH_ON%Le soleil se meurt.%SPEECH_OFF%Les hommes ont l\'air inquiets. L\'un d\'eux intervient. %SPEECH_ON%Mourir ? Qu\'est-ce que tu veux dire ? %SPEECH_OFF%%cultist% le regarde fixement.%SPEECH_ON%Davkul le souhaite afin que toute chose meure.%SPEECH_OFF%Un homme demande si ce supposé \'Davkul\' va mourir aussi. Le cultist fait un signe de tête.%SPEECH_ON%Quand il n\'y aura plus rien à mourir, Davkul pourra enfin se reposer. Un dieu plus cruel serait déjà parti. C\'est par les bonnes grâces de Davkul qu\'il partira en dernier, et c\'est pour cela pour cela nous le glorifions.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ehhh, d\'accord.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Cultist.getID())
					{
						bro.improveMood(1.0, "A profité de l\'occasion pour parler de la mort du soleil.");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().getID() == "background.cultist")
					{
						bro.improveMood(0.5, "A apprécié le discours de " + _event.m.Cultist.getName() + " à propos de la mort du soleil");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 1)
					{
						bro.worsenMood(1.0, "En colère contre les divagations hérétiques de " + _event.m.Cultist.getName());

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.mad"))
					{
						bro.worsenMood(1.0, "Terrifié par la perspective d\'un soleil mourant");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Archer",
			Text = "[img]gfx/ui/events/event_05.png[/img]%archer% relève le défi, prend son arc et quelques flèches. Il se lèche le doigt et le tient en l\'air. %SPEECH_ON%Le vent est bon pour un bon tir sur une étoile. %SPEECH_OFF%L\'archer encoche une flèche, tire et vise. La lumière foudroyante est instantanément aveuglante.%SPEECH_ON%Merde, je n\'y vois rien.%SPEECH_OFF%Sa visée vacille alors que des taches sombres envahissent sa vision. La flèche est décochée et passe à côté du soleil. Vraiment très loin. Il regarde la compagnie, les yeux éteints, les mains tendues pour essayer de se stabiliser pendant que sa vue revient.%SPEECH_ON%Est-ce que je l\'ai touché?%SPEECH_OFF%otherbrother% cache son rire.%SPEECH_ON%En plein dans le mille!%SPEECH_OFF%Les hommes éclatent de rire.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon tir",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Diverti par la tentitive de tirer sur le soleil de " + _event.m.Archer.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_historian = [];
		local candidate_monk = [];
		local candidate_cultist = [];
		local candidate_archer = [];
		local candidate_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.historian")
			{
				candidate_historian.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidate_cultist.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.sellsword")
			{
				candidate_archer.push(bro);
			}
			else if (bro.getEthnicity() != 1 && bro.getBackground().getID() != "background.slave")
			{
				candidate_other.push(bro);
			}
		}

		if (candidate_other.len() == 0)
		{
			return;
		}

		local options = 0;

		if (candidate_historian.len() != 0)
		{
			options = ++options;
		}

		if (candidate_monk.len() != 0)
		{
			options = ++options;
		}

		if (candidate_cultist.len() != 0)
		{
			options = ++options;
		}

		if (candidate_archer.len() != 0)
		{
			options = ++options;
		}

		if (options < 2)
		{
			return;
		}

		if (candidate_historian.len() != 0)
		{
			this.m.Historian = candidate_historian[this.Math.rand(0, candidate_historian.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		if (candidate_cultist.len() != 0)
		{
			this.m.Cultist = candidate_cultist[this.Math.rand(0, candidate_cultist.len() - 1)];
		}

		if (candidate_archer.len() != 0)
		{
			this.m.Archer = candidate_archer[this.Math.rand(0, candidate_archer.len() - 1)];
		}

		this.m.Other = candidate_other[this.Math.rand(0, candidate_other.len() - 1)];
		this.m.Score = options * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
		_vars.push([
			"historianfull",
			this.m.Historian != null ? this.m.Historian.getName() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"monkfull",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"cultistfull",
			this.m.Cultist != null ? this.m.Cultist.getName() : ""
		]);
		_vars.push([
			"archer",
			this.m.Archer != null ? this.m.Archer.getNameOnly() : ""
		]);
		_vars.push([
			"archerfull",
			this.m.Archer != null ? this.m.Archer.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Historian = null;
		this.m.Monk = null;
		this.m.Cultist = null;
		this.m.Archer = null;
		this.m.Other = null;
	}

});


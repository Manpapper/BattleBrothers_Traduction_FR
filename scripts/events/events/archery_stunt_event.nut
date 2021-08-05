this.archery_stunt_event <- this.inherit("scripts/events/event", {
	m = {
		Clown = null,
		Archer = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.archery_stunt";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Une certaine agitation vous fait sortir de votre tente. Vos hommes sont assis sur quelques souches ou sur le sol, observant avidement quelque chose au loin. En plissant les yeux, vous repérez %clown% et %archer% qui font quelque chose de bizarre. Une pomme est posée sur la tête d\'un homme, tandis que l\'autre s\'éloigne, un arc à la main.\n\nVous demandez à %otherguy% ce qui se passe et il vous explique que les deux hommes vont essayer une sorte de cascade ou de tour qui consiste à tirer sur un fruit sur la tête d\'un homme. Choqué, vous vous exclamez que ce n\'est pas sûr du tout, ce à quoi le frère sourit et explique que c\'est le but.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Arrêtez immédiatement!",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Et bien... Ça pourrait être intéressant.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= _event.m.Archer.getCurrentProperties().RangedSkill)
						{
							return "C";
						}
						else
						{
							return "B1";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Clown.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_10.png[/img]Vous réfléchissez à la situation. Vos frères d\'arme se tournent vers vous, s\'attendant à un arrêt, mais au lieu de cela, vous prenez un siège parmi eux. Cela déclenche une brève acclamation de la foule qui se transforme rapidement en chuchotements étouffés alors que %clown% et %archer% se préparent.%SPEECH_ON%Assure-toi de toucher la pomme!%SPEECH_OFF%Un frère hurle. Les rires fusent dans le groupe.%SPEECH_ON%De cette distance, le nez de %clown_short% ressemble un peu à une pomme pour moi.%SPEECH_OFF%Encore des rires, mais ils sont nerveux car le tour est sur le point de commencer.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ohh!",
					function getResult( _event )
					{
						return "B2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Clown.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_10.png[/img]%archer% positionne ses épaules en fonction de %clown% et bande son arc, la silhouette de l\'homme n\'étant plus qu\'un ensemble de bois, de corde et de bras. Vous ne voyez pas le visage de %clown% mais vous supposez que ses yeux sont fermés. Le tir est libéré. Il s\'envole. Il disparaît. %clown% part en arrière, en se tenant le visage. Ça ne se présente pas bien. L\'homme crie. La foule oohs. %archer% abaisse lentement son arc et le regarde comme s\'il était le responsable.\n\n Finalement, %clown% est porté devant vous, une flèche sortant de sa tête. Un autre frère d\'arme reste à l\'arrière, mangeant tranquillement une pomme dans tout ce chaos.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cela va laisser des traces...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Clown.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
				local injury = _event.m.Clown.addInjury(this.Const.Injury.Archery);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Clown.getName() + " souffre de " + injury.getNameOnly()
				});
				_event.m.Archer.worsenMood(2.0, "Gravement blessé " + _event.m.Clown.getName() + " par accident");

				if (_event.m.Archer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer.getMoodState()],
						text = _event.m.Archer.getName() + this.Const.MoodStateEvent[_event.m.Archer.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Clown.getID() || bro.getID() == _event.m.Archer.getID())
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.bright") || bro.getSkills().hasSkill("trait.fainthearted"))
					{
						bro.worsenMood(1.0, "Felt for " + _event.m.Clown.getName());

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
			ID = "C",
			Text = "[img]gfx/ui/events/event_10.png[/img]Les hommes applaudissent quand vous faites un signe de tête affirmatif. Vous prenez place parmi eux tandis que %archer% et %clown% se préparent, le premier encochant une flèche tandis que le second tient une pomme en équilibre sur sa tête. Lorsque le fruit est bien placé et stable, l\'archer tend son arc, ne formant qu\'une silhouette d\'homme, de bois et de corde, un croissant de détermination tandis qu\'il vise. Les hommes échangent des paris sur le fait qu\'il rate ou non. Vous voulez détourner le regard, mais le spectacle est vraiment impressionnant.\n\n Un grand silence suit la libération de la flèche, comme si un événement sinistre longtemps prédit s\'était finalement produit. Les hommes chancellent sur leurs sièges, grimaçant et serrant les dents. La pomme part de la tête de %clown%, le fruit et la flèche s\'envolent. Après un bref silence, les hommes se mettent à applaudir. %clown% s\'incline, tandis que %archer% se détend et semble un peu soulagé.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'était parfait.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Clown.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Clown.getBaseProperties().Bravery += 1;
				_event.m.Clown.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Clown.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Détermination"
				});
				_event.m.Archer.getBaseProperties().RangedSkill += 1;
				_event.m.Archer.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Archer.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Maîtrise à Distance"
				});
				_event.m.Clown.improveMood(1.0, "A participé dans un tour");

				if (_event.m.Clown.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Clown.getMoodState()],
						text = _event.m.Clown.getName() + this.Const.MoodStateEvent[_event.m.Clown.getMoodState()]
					});
				}

				_event.m.Archer.improveMood(1, "Il a démontré ses talents de tireur à l\'arc");

				if (_event.m.Archer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer.getMoodState()],
						text = _event.m.Archer.getName() + this.Const.MoodStateEvent[_event.m.Archer.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Clown.getID() || bro.getID() == _event.m.Archer.getID())
					{
						continue;
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 10 && !bro.getSkills().hasSkill("trait.bright"))
					{
						bro.improveMood(1.0, "Felt entertained");

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
			ID = "D",
			Text = "Vous secouez la tête \'non\' en vous déplaçant vers le terrain et en vous plaçant entre les deux hommes.%SPEECH_ON%Si vous vouliez faire des tours, vous auriez dû rejoindre un cirque. Maintenant, retournez au travail avant que quelqu\'un ne soit sérieusement blessé.%SPEECH_OFF%Une vague de déception déferle sur les hommes. Quelques-uns se mettent même à huer et à vous faire un signe du pouce vers le bas ou d\'autres gestes plus bruyants.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est pour leur propre bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Clown.getImagePath());
				this.Characters.push(_event.m.Archer.getImagePath());
				_event.m.Clown.worsenMood(1.0, "On lui a refusé une demande");

				if (_event.m.Clown.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Clown.getMoodState()],
						text = _event.m.Clown.getName() + this.Const.MoodStateEvent[_event.m.Clown.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Clown.getID())
					{
						continue;
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 10 && !bro.getSkills().hasSkill("trait.bright") && !bro.getSkills().hasSkill("trait.fainthearted"))
					{
						bro.worsenMood(1.0, "Il n\'a pas eu le divertissement qu\'il espérait.");

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

		local clown_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.bright") || bro.getSkills().hasSkill("trait.hesitant") || bro.getSkills().hasSkill("trait.craven") || bro.getSkills().hasSkill("trait.fainthearted") || bro.getSkills().hasSkill("trait.insecure"))
			{
				continue;
			}

			if ((bro.getBackground().getID() == "background.minstrel" || bro.getBackground().getID() == "background.juggler" || bro.getBackground().getID() == "background.vagabond") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				clown_candidates.push(bro);
			}
		}

		if (clown_candidates.len() == 0)
		{
			return;
		}

		local archer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.bright") || bro.getSkills().hasSkill("trait.hesitant") || bro.getSkills().hasSkill("trait.craven") || bro.getSkills().hasSkill("trait.fainthearted") || bro.getSkills().hasSkill("trait.insecure"))
			{
				continue;
			}

			if ((bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.bowyer") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				archer_candidates.push(bro);
			}
		}

		if (archer_candidates.len() == 0)
		{
			return;
		}

		this.m.Clown = clown_candidates[this.Math.rand(0, clown_candidates.len() - 1)];
		this.m.Archer = archer_candidates[this.Math.rand(0, archer_candidates.len() - 1)];
		this.m.Score = clown_candidates.len() * 3;

		do
		{
			this.m.OtherGuy = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
		while (this.m.OtherGuy == null || this.m.OtherGuy.getID() == this.m.Clown.getID() || this.m.OtherGuy.getID() == this.m.Archer.getID());
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"clown",
			this.m.Clown.getName()
		]);
		_vars.push([
			"clown_short",
			this.m.Clown.getNameOnly()
		]);
		_vars.push([
			"archer",
			this.m.Archer.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onClear()
	{
		this.m.Clown = null;
		this.m.Archer = null;
		this.m.OtherGuy = null;
	}

});


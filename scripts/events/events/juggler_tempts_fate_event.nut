this.juggler_tempts_fate_event <- this.inherit("scripts/events/event", {
	m = {
		Juggler = null,
		NonJuggler = null
	},
	function create()
	{
		this.m.ID = "event.juggler_tempts_fate";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%juggler% le jongleur au pied léger et à la main rapide fait le tour de ses frères d\'armes pour leur demander de lui lancer des couteaux. Il semble qu\'il cherche à montrer son numéro.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons ce que tu peux faire !",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "C" : "Fail1";
					}

				},
				{
					Text = "Ce n\'est pas pour ça que je te paie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.getFlags().add("juggler_tempted_fate");
			}

		});
		this.m.Screens.push({
			ID = "Fail1",
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonjuggler% lance un couteau à travers le camp. La lame tourne au soleil et vous voyez un éclat de lumière réfléchie traverser les yeux du jongleur. Il cligne des yeux juste assez longtemps pour que l\'arme se loge dans son épaule. Il cligne à nouveau des yeux, juste assez longtemps pour que la douleur commence à se faire sentir. En un instant, %juggler% est renversé, serrant sa blessure en hurlant de douleur. Quelques hommes le soignent tandis que d\'autres ne peuvent que rire.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça doit faire mal !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local injury = _event.m.Juggler.addInjury([
					{
						ID = "injury.injured_shoulder",
						Threshold = 0.25,
						Script = "injury/injured_shoulder_injury"
					}
				]);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Juggler.getName() + " souffre de " + injury.getNameOnly()
					}
				];
				_event.m.Juggler.worsenMood(1.0, "Il a raté son tour et s\'est blessé");

				if (_event.m.Juggler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Fail2",
			Text = "[img]gfx/ui/events/event_05.png[/img]La hache que %juggler% a demandée est ramassée et lancée vers lui. Elle tourne dans un angle bizarre, comme si l\'homme qui l\'a lancée l\'avait intentionnellement fait vaciller de façon indéterminée. Ne s\'attendant pas à cela, le jongleur s\'ajuste pour essayer d\'attraper le manche de la hache détraquée, mais l\'arme se heurte à l\'une des dagues et lui coupe l\'épaule. Il tombe au sol en un instant, une pluie de couteaux tombant tout autour de lui. Alors que certains hommes soignent ses blessures, d\'autres ne peuvent s\'empêcher de se réjouir de sa souffrance.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Est-ce qu\'il va bien ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local injury = _event.m.Juggler.addInjury(this.Const.Injury.Accident4);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Juggler.getName() + " souffre de " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "Fail3",
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonjuggler% ramasse le fléau demandé et, après un moment d\'hésitation, le lance vers %juggler%. En plein vol, la chaîne de l\'arme s\'enroule autour du manche. Le jongleur semble s\'y habituer, mais au dernier moment, la chaîne se déploie et revient avec une intention mortelle. Vous voyez les yeux du jongleur s\'écarquiller alors qu\'il voit une calamité qu\'il ne peut empêcher d\'arriver. Le fléau le frappe au visage. Assommé, il tourne sur ses pieds et s\'effondre sur le sol. Une dague qui tombe pénètre sa jambe et la hache se plante dans sa hanche. Les hommes halètent d\'horreur et bientôt chacun d\'entre eux se lève et se précipite à son secours.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il est vivant ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local injury = _event.m.Juggler.addInjury(this.Const.Injury.BluntHead);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Juggler.getName() + " souffre de " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous vous asseyez et laissez les hommes lancer quelques couteaux et dagues à %juggler%. Ils arrivent de toutes les formes et de toutes les tailles, et de tous les angles, mais il les attrape avec facilité et commence à les lancer en l\'air, leurs rotations scintillantes et étincelantes dans la lumière du soleil. Comme chaque arme a un poids différent, vous êtes impressionné par sa capacité à les faire tourner à l\'unisson. Bien sûr, cela ne pourrait pas s\'arrêter là. D\'une main, il fait signe aux hommes entre deux jongles et demande à quelqu\'un de lui lancer une hache.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cela devrait être intéressant !",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "D" : "Fail2";
					}

				},
				{
					Text = "C\'est suffisant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 10)
					{
						bro.improveMood(1.0, "S\'est amusé");

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
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonjuggler% se lève et lance une hache dans en direction de l\'incroyable numéro de %juggler%. L\'anneau d\'armes dangereuses du jongleur semble manger la hache en un instant, l\'arme rejoignant simplement le reste des couteaux et des dagues dans une transition sans faille. Les hommes applaudissent et acclament, bien que certains sourient comme s\'ils attendaient que ce jeu de cartes incroyablement tranchant s\'effondre. Mais ce n\'est pas la fin du numéro, apparemment. Cette fois, sans faire signe à personne, mais en se concentrant simplement sur les armes qui tournoient autour de lui, le jongleur demande un fléau. Quelqu\'un se lève.%SPEECH_ON%Il a dit un fléau?%SPEECH_OFF%Le jongleur tape du pied.%SPEECH_ON%Oui, un fléau ! Lancez-moi un fléau !%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Impossible et pourtant... Je veux le voir !",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "E" : "Fail3";
					}

				},
				{
					Text = "C\'est tout. Terminez ça maintenant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.getBaseProperties().Bravery += 1;
				_event.m.Juggler.getBaseProperties().MeleeSkill += 1;
				_event.m.Juggler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Juggler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Détermination"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Juggler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Maîtrise de Mêlée"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 20)
					{
						bro.improveMood(1.0, "S\'est amusé");

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
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]Un fléau est récupéré et lancé vers %juggler%. Tout le monde grimace alors que le fléau serpente, virevolte et ondule vers la tempête d\'armes tournoyante que le jongleur appelle son \"numéro\". Mais, tout comme la hache, le fléau est rapidement absorbé par le maelström de métal. Plus fort que jamais, les hommes se lèvent et applaudissent. Quelques-uns soupirent de soulagement, essuyant la sueur de leur front, tandis que d\'autres ne peuvent que sourire et applaudir, plutôt déçus que rien de spectaculaire ne se soit produit, mais tout de même impressionnés.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bravo!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.getBaseProperties().Bravery += 2;
				_event.m.Juggler.getBaseProperties().RangedDefense += 2;
				_event.m.Juggler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Juggler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] de Détermination"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.Juggler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] de Défense en Mêlée"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 30)
					{
						bro.improveMood(1.0, "S\'est amusé");

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

		local juggler_candidates = [];
		local nonjuggler_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.juggler")
			{
				if (!bro.getFlags().has("juggler_tempted_fate"))
				{
					juggler_candidates.push(bro);
				}
			}
			else if (bro.getBackground().getID() != "background.slave")
			{
				nonjuggler_candidates.push(bro);
			}
		}

		if (juggler_candidates.len() == 0 || nonjuggler_candidates.len() == 0)
		{
			return;
		}

		this.m.Juggler = juggler_candidates[this.Math.rand(0, juggler_candidates.len() - 1)];
		this.m.NonJuggler = nonjuggler_candidates[this.Math.rand(0, nonjuggler_candidates.len() - 1)];
		this.m.Score = juggler_candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"juggler",
			this.m.Juggler.getNameOnly()
		]);
		_vars.push([
			"nonjuggler",
			this.m.NonJuggler.getName()
		]);
	}

	function onClear()
	{
		this.m.Juggler = null;
		this.m.NonJuggler = null;
	}

});


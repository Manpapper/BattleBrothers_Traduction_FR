this.combat_drill_event <- this.inherit("scripts/events/event", {
	m = {
		Teacher = null
	},
	function create()
	{
		this.m.ID = "event.combat_drill";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous sortez de votre tente pour observer les hommes. Un grand nombre d\'entre eux sont des grognards fraîchement embauchés, qui s\'associent nerveusement les uns aux autres ou s\'essaient à certaines armes. %oldguard% vient à vos côtés.%SPEECH_ON%Je sais ce que vous pensez. Vous pensez que vous venez d\'engager un tas de viande pour l\'abattoir. Et si je donnais un coup de fouet à ces garçons pour qu\'ils ne se mangent pas une lame d\'orc à leur premier combat sur le terrain ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très bien, voyez si vous pouvez leur apprendre à se battre comme des hommes.",
					function getResult( _event )
					{
						return "B1";
					}

				},
				{
					Text = "Très bien, faites en sorte qu\'ils sachent se servir d\'un arc et de flèches.",
					function getResult( _event )
					{
						return "C1";
					}

				},
				{
					Text = "Très bien, mettez-les en forme pour porter de vraies armures.",
					function getResult( _event )
					{
						return "D1";
					}

				},
				{
					Text = "Non, ils ont besoin de garder le peu de force qu\'ils ont pour la bataille.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_05.png[/img]%oldguard% dit aux recrues de prendre des armes. Lorsque chacune d\'entre elles prend une épée, le vieux garde leur crie dessus, déclarant que tous les ennemis qui veulent vous voir mort ne vont pas forcément brandir la même lame. Quelques-uns acquiescent avant de changer précipitamment leurs épées contre des haches et des lances. Une fois tout le monde équipé, l\'entraînement commence. %oldguard% leur enseigne surtout les bases, comme le fait qu\'une formation permet de se défendre plus facilement, non seulement les uns les autres, mais aussi soi-même.%SPEECH_ON%Vous n\'avez pas besoin de surveiller partout si vous savez qu\'un frère d\'armes à vos côtés. Mais si vous êtes séparés, si vous vous retrouvez seuls, alors vous risquez d\'avoir des ennuis avec une lame que vous ne connaissez pas.%SPEECH_OFF%L\'entraînement passe à l\'offensive où %oldguard% montre quelques tours avec des armes variées.%SPEECH_ON%Avec les épées, vous pouvez trancher, couper, poignarder et riposter. Difficile de rater son coup avec une épée, vu que chaque côté de celle-ci est un côté qui tue. Si je vois l\'un d\'entre vous essayer de couper une flèche en deux avec une épée comme le disent les contes de fées, je vous battrai moi-même. Ce n\'est pas vrai, alors arrêtez de faire semblant !\n\nLes lances sont bonnes pour garder la distance. Elles ne font pas grand-chose aux armures, mais elles vous protègent. Pointez juste le bout pointu loin de vous. Si une brute en armure arrive à passer le bout pointu, vous êtes probablement foutu, alors ne le laissez pas faire.\n\nEnfin, il y a la hache. Imaginez que l\'autre homme est un arbre et coupez-le en deux. Maintenant, on s\'entraîne !%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Montrez-moi ce que vous savez faire!",
					function getResult( _event )
					{
						return "B2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				_event.m.Teacher.improveMood(0.5, "A entrainé les nouvelles recrues");
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_50.png[/img]L\'entraînement se passe assez bien à partir de là, même si quelques hommes en ressortent avec quelques bosses et quelques bleus.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() > 3)
					{
						continue;
					}

					local meleeSkill = this.Math.rand(0, 2);
					local meleeDefense = meleeSkill == 0 ? this.Math.rand(0, 2) : 0;
					bro.getBaseProperties().MeleeSkill += meleeSkill;
					bro.getBaseProperties().MeleeDefense += meleeDefense;
					bro.getSkills().update();

					if (meleeSkill > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/melee_skill.png",
							text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] de Maîtrise de Mêlée"
						});
					}

					if (meleeDefense > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/melee_defense.png",
							text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeDefense + "[/color] de Maîtrise à Distance"
						});
					}

					local injuryChance = 33;

					if (bro.getSkills().hasSkill("trait.clumsy") || bro.getSkills().hasSkill("trait.drunkard"))
					{
						injuryChance = injuryChance * 2.0;
					}

					if (bro.getBackground().isCombatBackground())
					{
						injuryChance = injuryChance * 0.5;
					}

					if (bro.getSkills().hasSkill("trait.dexterous"))
					{
						injuryChance = injuryChance * 0.5;
					}

					if (this.Math.rand(1, 100) <= injuryChance)
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " souffre de blessures légères"
							});
						}
						else
						{
							local injury = bro.addInjury(this.Const.Injury.Accident1);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " souffre de " + injury.getNameOnly()
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C1",
			Text = "[img]gfx/ui/events/event_05.png[/img] %oldguard% rassemble les hommes et commence à leur donner des arcs d\'entraînement.%SPEECH_ON%Maintenant, cette arme n\'est pas faite pour tuer, à moins que vous n\'ayez l\'intention de vous en servir contre nouveau-né, ce qui est le cas de certains d\'entre vous j\'en suis sûre, mais pour l\'instant nous allons juste les utiliser pour nous entraîner.\n\nVoici comment fonctionne cet engin. Oh, vous le savez déjà ? Vous n\'êtes pas une bande d\'idiots ? Eh bien, allez-y, montrez-moi ce que vous valez comme tireurs d\'élite.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons si vous pouvez toucher quelque chose.",
					function getResult( _event )
					{
						return "C2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				_event.m.Teacher.improveMood(0.5, "A entrainé les nouvelles recrues");
			}

		});
		this.m.Screens.push({
			ID = "C2",
			Text = "[img]gfx/ui/events/event_10.png[/img]Les hommes s\'entraînent à tirer en direction du champ de tir, les flèches s\'éparpillant tout autour de leurs cibles, quelques rares flèches chanceuses allant là où elles doivent aller. %oldguard% passe le reste de la journée à faire tirer les hommes, encore et encore, jusqu\'à ce que la chance soit complètement éliminée de l\'équation.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() > 3)
					{
						continue;
					}

					local rangedSkill = this.Math.rand(0, 2);
					bro.getBaseProperties().RangedSkill += rangedSkill;
					bro.getSkills().update();

					if (rangedSkill > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/ranged_skill.png",
							text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + rangedSkill + "[/color] de Maîtrise à Distance"
						});
					}

					local exhaustionChance = 33;

					if (bro.getSkills().hasSkill("trait.asthmatic"))
					{
						exhaustionChance = exhaustionChance * 4.0;
					}

					if (bro.getSkills().hasSkill("trait.athletic"))
					{
						exhaustionChance = exhaustionChance * 0.0;
					}

					if (bro.getSkills().hasSkill("trait.iron_lungs"))
					{
						exhaustionChance = exhaustionChance * 0.0;
					}

					if (this.Math.rand(1, 100) <= exhaustionChance)
					{
						local effect = this.new("scripts/skills/effects_world/exhausted_effect");
						bro.getSkills().add(effect);
						this.List.push({
							id = 10,
							icon = effect.getIcon(),
							text = bro.getName() + " est épuisé"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D1",
			Text = "[img]gfx/ui/events/event_05.png[/img]%oldguard% émet un sifflement aigu, rassemblant les nouvelles recrues autour de lui. Il regarde autour de lui en souriant, puis fait un signe de tête.%SPEECH_ON%Très bien, vous, bande de couilles molles, suceurs de tétines, bras cassés nous allons faire une marche !%SPEECH_OFF%Le vétéran passe le reste de la journée à faire courir les recrues aussi loin qu\'il le peut jusqu\'à ce que la dernière tombe d\'épuisement.%SPEECH_ON%Respirez, bande de bébés, respirez ! Inspirez profondement. Il y en a assez pour tout le monde, ne vous sentez pas mal ! Avalez ça comme votre mère vous aurait du vous avalé. Maintenant, j\'ai déjà tiré sur des taches qui couraient plus vite que vous tous, donc je vous reverrai tous demain à l\'heure habituelle. C\'est avant que le soleil ne se lève, bande de merdeux.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous le ferons encore demain !",
					function getResult( _event )
					{
						return "D2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				_event.m.Teacher.improveMood(0.5, "A entrainé les nouvelles recrues");
			}

		});
		this.m.Screens.push({
			ID = "D2",
			Text = "%oldguard% ne montre guère de pitié et fait courir les hommes encore et encore les jours à venir. Après tout, dit-il, c\'est pour leur propre bien.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() > 3)
					{
						continue;
					}

					local stamina = this.Math.rand(0, 3);
					local initiative = stamina == 0 ? this.Math.rand(0, 3) : 0;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Initiative += initiative;
					bro.getSkills().update();

					if (stamina > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/fatigue.png",
							text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] de Fatigue Maximum"
						});
					}

					if (initiative > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/initiative.png",
							text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] d\'Initiative"
						});
					}

					local exhaustionChance = 75;

					if (bro.getSkills().hasSkill("trait.asthmatic"))
					{
						exhaustionChance = exhaustionChance * 2.0;
					}

					if (bro.getSkills().hasSkill("trait.athletic"))
					{
						exhaustionChance = exhaustionChance * 0.5;
					}

					if (bro.getSkills().hasSkill("trait.iron_lungs"))
					{
						exhaustionChance = exhaustionChance * 0.5;
					}

					if (this.Math.rand(1, 100) <= exhaustionChance)
					{
						local effect = this.new("scripts/skills/effects_world/exhausted_effect");
						bro.getSkills().add(effect);
						this.List.push({
							id = 10,
							icon = effect.getIcon(),
							text = bro.getName() + " est epuisé"
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local numRecruits = 0;

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().isCombatBackground() && !bro.getBackground().isNoble())
			{
				candidates.push(bro);
			}
			else if (bro.getLevel() <= 3 && !bro.getBackground().isCombatBackground())
			{
				numRecruits = ++numRecruits;
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		if (numRecruits < 3)
		{
			return;
		}

		this.m.Teacher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10 + numRecruits * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oldguard",
			this.m.Teacher.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Teacher = null;
	}

});


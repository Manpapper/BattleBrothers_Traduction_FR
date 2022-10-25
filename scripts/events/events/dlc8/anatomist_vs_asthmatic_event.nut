this.anatomist_vs_asthmatic_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Asthmatic = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_asthmatic";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous tombez sur %anatomist% l\'anatomiste qui parle à %asthmatic%, un homme qui est notoirement mauvais dans le simple fait de respirer. Presque au bon moment, l\'homme vient vous voir avec une requête. Il dit que l\'anatomiste a un moyen de guérir ses pauvres poumons. %anatomist% hoche la tête.%SPEECH_ON%Ce n\'est qu\'une petite procédure, bien que douloureuse. Ce sujet audacieux - excusez-moi, cet animal audacieux - bonté divine, excusez-moi, ce patient audacieux a relevé le défi et est prêt à le remplir entièrement. Avec votre accord, je peux commencer le processus et le faire en un rien de temps.%SPEECH_OFF%Vous n\'en êtes pas sûr, mais ce serait bien si %asthmatic% pouvait arrêter de siffler au milieu de la nuit comme un lapin à qui on a retiré la vie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faites-le, mais soyez prudent.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Faites-le, et utilisez tous les moyens nécessaires.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Non, je ne veux pas risquer sa vie pour ça.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous approuvez la procédure et les deux disparaissent pendant un certain temps. Peu de temps après, %asthmatic%, l\'homme dont les poumons ressemblent à ceux d\'un chien mort sur lequel on marche, vient vous voir avec un large sourire. Il se tient droit, gonfle sa poitrine et prend une longue et profonde inspiration, son corps se gonflant comme un crapaud, ses joues également, puis il laisse lentement, lentement, sortir l\'air. Il n\'y a pas de respiration sifflante. Il n\'y a pas de grattement dans la gorge. Son visage ne devient pas rouge. Ses bras se relâchent, mais il n\'a pas de vertige.%SPEECH_ON%Cet anatomiste m\'a bien rafistolé. C\'est un miracle sur pattes.%SPEECH_OFF%L\'homme se retourne, révélant une série de trous dans sa chair qui aspirent et se froncent lorsqu\'il respire. %anatomist% vient nettoyer un étrange ustensile en métal. Il secoue la tête.%SPEECH_ON%Au moins l\'un d\'entre nous est satisfait des résultats tels qu\'ils sont arrivés.%SPEECH_OFF%Vous ne savez pas trop pourquoi l\'anatomiste est contrarié, mais vous pouvez jeter un coup d\'œil à l\'un de ses textes qui révèle une opération d\'ablation du poumon par scalpel et cuillère. Ce n\'est sûrement pas ce qu\'il a fait à %asthmatic%. Sûrement pas.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sûrement pas...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Asthmatic.getSkills().removeByID("trait.asthmatic");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_22.png",
					text = _event.m.Asthmatic.getName() + " is no longer Asthmatic"
				});
				_event.m.Asthmatic.addHeavyInjury();
				this.List.push({
					id = 11,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Asthmatic.getName() + " suffers heavy wounds"
				});
				_event.m.Asthmatic.improveMood(1.0, "Is no longer asthmatic");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 11,
						icon = this.Const.MoodStateIcon[_event.m.Asthmatic.getMoodState()],
						text = _event.m.Asthmatic.getName() + this.Const.MoodStateEvent[_event.m.Asthmatic.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous acceptez la procédure. %asthmatic% se retourne pour le dire à l\'anatomiste, qui s\'empresse de planter une broche métallique profondément dans la poitrine de l\'homme. L\'homme grimace et glapit, ses doigts se recroquevillent comme pour saisir la douleur elle-même. Il recule tandis que l\'Anatomiste tient l\'ustensile comme un manche. Alors que l\'anatomiste fait un pas en avant pour donner un autre coup, vous sautez en avant et l\'arrêtez. Il vous regarde avec confusion.%SPEECH_ON%Cela fait partie du processus, vous ne comprenez pas? Maintenant, je dois continuer avec la perforation. Nous allons lui faire huit autres trous.%SPEECH_OFF%%asthmatic% crie, plutôt indigne dans sa protestation du processus. Vous dites à l\'anatomiste que c\'est terminé. Il soupire et baisse l\'outil.%SPEECH_ON%Tout ce qui est important nécessite de la souffrance, mercenaire. Que ce soit vous, qui achetez des têtes à vendre pour des couronnes, ou moi, qui cherche un remède. Si la douleur n\'était pas un élément critique, nous ne bouleverserions pas l\'ordre naturel à notre manière.%SPEECH_OFF%Vous lui dites de la fermer et que c\'est terminé. Il soupire et s\'en va, nettoyant l\'ustensile avec un chiffon. %asthmatic% siffle un remerciement pour votre intervention.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Calmez-vous un peu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Asthmatic.addInjury([
					{
						ID = "injury.pierced_lung",
						Threshold = 0.0,
						Script = "injury/pierced_lung_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Asthmatic.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Asthmatic.worsenMood(0.5, "Was injured by a madman");

				if (_event.m.Asthmatic.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 11,
						icon = this.Const.MoodStateIcon[_event.m.Asthmatic.getMoodState()],
						text = _event.m.Asthmatic.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 11,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous vous dites pourquoi ne pas faire l\'âne complètement et prendre la voie expérimentale? %asthmatic% est d\'accord.%SPEECH_ON%Si ça doit faire mal, autant que ça en vaille la peine.%SPEECH_OFF%Alors qu\'ils partent tous les deux vers une tente, une partie de vous envisage de les suivre. Une autre partie réalise que vous n\'avez probablement pas assez de cran pour ça, quoi qu\'il en soit, vous ne voulez pas que votre seule présence interfère avec le travail de l\'anatomiste. Cela dit, il ne faut pas longtemps pour que les deux réapparaissent. %asthmatic% se tient droit, inspire longuement et lourdement, puis expire tout d\'un seul coup.%SPEECH_ON%Je ne me suis jamais sentie aussi bien.%SPEECH_OFF%C\'est ce qu\'il dit puis serre la main de %anatomist%. L\'homme guéri s\'en va. %anatomist% se nettoie les mains.%SPEECH_ON%Malheureusement, il y a eu quelques complications. Laissez-moi voir, qu\'est-ce que nous avons...%SPEECH_OFF%L\'anatomiste déploie un parchemin avec des notes écrites à la hâte, dont certaines sont couvertes de sang. Vous lisez...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oh. Oh non.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Asthmatic.getSkills().removeByID("trait.asthmatic");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_22.png",
					text = _event.m.Asthmatic.getName() + " is no longer Asthmatic"
				});
				local trait = this.new("scripts/skills/traits/iron_lungs_trait");
				_event.m.Asthmatic.getSkills().add(trait);
				this.List.push({
					id = 11,
					icon = trait.getIcon(),
					text = _event.m.Asthmatic.getName() + " gains Iron Lungs"
				});
				local new_traits = [
					"scripts/skills/traits/bloodthirsty_trait",
					"scripts/skills/traits/brute_trait",
					"scripts/skills/traits/cocky_trait",
					"scripts/skills/traits/deathwish_trait",
					"scripts/skills/traits/dumb_trait",
					"scripts/skills/traits/gluttonous_trait",
					"scripts/skills/traits/impatient_trait",
					"scripts/skills/traits/irrational_trait",
					"scripts/skills/traits/paranoid_trait",
					"scripts/skills/traits/spartan_trait",
					"scripts/skills/traits/superstitious_trait"
				];
				local num_new_traits = 2;

				while (num_new_traits > 0 && new_traits.len() > 0)
				{
					local trait = this.new(new_traits.remove(this.Math.rand(0, new_traits.len() - 1)));

					if (!_event.m.Asthmatic.getSkills().hasSkill(trait.getID()))
					{
						_event.m.Asthmatic.getSkills().add(trait);
						this.List.push({
							id = 12,
							icon = trait.getIcon(),
							text = _event.m.Asthmatic.getName() + " gains " + trait.getName()
						});
						num_new_traits = num_new_traits - 1;
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Asthmatic.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous dites non à %anatomist%. L\'anatomiste serre les lèvres et avance un argument absurde sur la valeur de la médecine et de la science,  vous lui parlez de la valeur d\'un mercenaire qui n\'est pas un imbécile qui joue avec les poumons des autres.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ouais ouais, allez pleurer dans vos manuels.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local asthmaticCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.asthmatic"))
			{
				asthmaticCandidates.push(bro);
			}
		}

		if (asthmaticCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Asthmatic = asthmaticCandidates[this.Math.rand(0, asthmaticCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * asthmaticCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"asthmatic",
			this.m.Asthmatic.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Asthmatic = null;
	}

});


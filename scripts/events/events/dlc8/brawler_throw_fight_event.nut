this.brawler_throw_fight_event <- this.inherit("scripts/events/event", {
	m = {
		Brawler = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.brawler_throw_fight";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Sans vous prévenir, il semblerait que %brawler% le bagarreur se soit inscrit de lui-même à un tournoi et qu\'il soit déjà arrivé jusqu\'à la finale. Il a si facilement écrasé tous ses adversaires au premier tour qu\'il est le grand favori pour remporter le tournoi. Cependant, quelques courtiers en paris très influents sont mécontents que %brawler% leur ait déjà fait perdre une tonne d\'argent. Sachant qu\'il est avec vous, ils vous ont demandé de dire à %brawler% de faire une chute et de perdre le match. En retour, vous obtiendrez un pourcentage de leurs gains, qui seront sans doute assez importants...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous devez simuler une chute.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Il ne se couchera pas.",
					function getResult( _event )
					{
						local outcome = this.Math.rand(1, 100);

						if (outcome <= 39 + _event.m.Brawler.getLevel())
						{
							return "D";
						}
						else if (outcome <= 80)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				},
				{
					Text = "Quoi? Il n\'y aura pas de combat du tout!",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Vous ordonnez à %brawler% de simuler une chute. Comme prévu, il refuse, mais vous lui rappelez que vous êtes le capitaine de la compagnie, et que même si la bagarre est son domaine, le business est le vôtre. Il soupire et acquiesce. Lorsque le combat a lieu, %brawler%, comme il en a reçu l\'ordre, prend quelques coups puis simule un KO venant d\'un direct digne d\'un amateur. La foule hurle, l\'outsider applaudit et court autour de la fosse de combat les mains levées. Après le combat, les courtiers en paris viennent vous donner des couronnes %reward% pour la chute. L\'un d\'eux regarde le %brawler%. %SPEECH_ON%Dieu du ciel, mec, tu aurais pu déclencher une émeute si quelqu\'un avait fait attention. Tu devrais t\'entraîner au théâtre, parce que ce coup gagnant n\'aurait pas fait chuter une pute. La prochaine fois, attends une croix ou un crochet solide, veux-tu? Le bagarreur ri nerveusement. Il s\'est humilié pour quelques couronnes. Quelque part dans %townname%, vous pouvez entendre les habitants de la ville acclamer le nom du vainqueur.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il s\'en remettra.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				this.World.Assets.addMoney(400);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]400[/color] Crowns"
				});
				_event.m.Brawler.worsenMood(0.5, "Was told to throw a fight");
				_event.m.Brawler.worsenMood(2.0, "Lost a fighting tournament");

				if (_event.m.Brawler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Vous ordonnez à %brawler% de simuler une chute. Comme prévu, il refuse, mais vous lui rappelez que vous êtes le capitaine de la compagnie, et que même si la bagarre est son domaine, le business est le vôtre. Il soupire et acquiesce. Lorsque le combat a lieu, %brawler% simule un KO venant d\'un direct digne d\'un amateur. À terre, il vous regarde fixement, vous voyez la haine dans ses yeux. Vous lui dites de rester à terre, mais au lieu de cela, il se relève et détruit rapidement l\'autre combattant avec une rafale de crochets et d\'uppercuts. Il gagne le combat et est porté hors de l\'arène par la foule. Vous essayez de les suivre et de voir où il est allé... vous le trouvez dans une ruelle, réduit en bouillie. Il vous sourit. Les courtiers qui ont parié n\'étaient pas contents, mais qu\'ils aillent se faire voir. Ils auraient dû parier sur ma fierté. Il tombe inconscient.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon, j\'ai assez parié pour le moment, moi aussi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				_event.m.Brawler.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Brawler.getName() + " suffers heavy wounds"
				});
				_event.m.Brawler.worsenMood(0.5, "Was told to throw a fight");
				_event.m.Brawler.improveMood(2.0, "Handily won a fighting tournament");

				if (_event.m.Brawler.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Vous dites aux courtiers que %brawler% se battra comme il l\'entend. Les courtiers, qui ne veulent pas se frotter à un mercenaire, ne discutent pas davantage. Ils partent simplement avant que vous ne puissiez même parier sur votre homme. Maintenant que vous savez que le match va avoir lieu, %brawler% va tout simplement éclater le meilleur bagarreur de %townname% sans l\'ombre d\'un doute. Il était tellement évident que la raclée allait se produire que tout le monde a parié sur %brawler% et les courtiers en jeux d\'argent se sont rués dessus. Des bagarres éclatent et certains parieurs et courtiers commencent à se frapper les uns les autres. Le combat ne rapporte rien, mais %brawler% est ravi d\'être le champion de %townname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				local resolve_boost = this.Math.rand(2, 4);
				local initiative_boost = this.Math.rand(2, 4);
				local melee_skill_boost = this.Math.rand(1, 3);
				local melee_defense_boost = this.Math.rand(1, 3);
				_event.m.Brawler.getBaseProperties().Bravery += resolve_boost;
				_event.m.Brawler.getBaseProperties().Initiative += initiative_boost;
				_event.m.Brawler.getBaseProperties().MeleeSkill += melee_skill_boost;
				_event.m.Brawler.getBaseProperties().MeleeDefense += melee_defense_boost;
				_event.m.Brawler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve_boost + "[/color] Resolve"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative_boost + "[/color] Initiative"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_skill_boost + "[/color] Melee Skill"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_defense_boost + "[/color] Melee Defense"
				});
				_event.m.Brawler.improveMood(0.5, "Was allowed to fight on his own terms");
				_event.m.Brawler.improveMood(2.0, "Handily won a fighting tournament");

				if (_event.m.Brawler.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Vous dites aux courtiers que %brawler% se battra comme il l\'entend. Ne voulant pas s\'embrouiller avec un capitaine mercenaire, ils acquiescent simplement et se retirent. Comme prévu, %brawler% gagne le combat haut la main. Comme il est le sujet de conversation de %townname%, vous le laissez aller faire la fête avec les paysans. Mais quelques heures passent et vous réalisez que vous ne l\'avez pas vu depuis longtemps. Vous vous aventurez en ville pour le trouver dans une ruelle, les genoux fracassés, sa main de fer réduite en bouillie et ses yeux tuméfiés. Vous hurlez et courez vers lui. Il se relève difficilement.%SPEECH_ONCapitaine? Oui, capitaine, c\'est bon d\'entendre votre voix. Ne vous inquiétez pas pour moi. Ça en valait la peine.%SPEECH_OFF%Il s\'évanouit. Vous le ramenez à la compagnie et envisagez de traquer les courtiers, mais vous savez qu\'ils n\'auraient pas fait une telle chose sans se préparer à quitter la ville par la suite.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Merde.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				local injury = _event.m.Brawler.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Brawler.getName() + " suffers " + injury.getNameOnly()
				});
				injury = _event.m.Brawler.addInjury([
					{
						ID = "injury.broken_knee",
						Threshold = 0.0,
						Script = "injury_permanent/broken_knee_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Brawler.getName() + " suffers " + injury.getNameOnly()
				});
				local initiative_boost = this.Math.rand(2, 4);
				local melee_skill_boost = this.Math.rand(1, 3);
				_event.m.Brawler.getBaseProperties().Initiative += initiative_boost;
				_event.m.Brawler.getBaseProperties().MeleeSkill += melee_skill_boost;
				_event.m.Brawler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative_boost + "[/color] Initiative"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Brawler.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_skill_boost + "[/color] Melee Skill"
				});
				_event.m.Brawler.improveMood(0.5, "Was allowed to fight on his own terms");
				_event.m.Brawler.improveMood(2.0, "Handily won a fighting tournament");

				if (_event.m.Brawler.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Vous dites aux courtiers que %brawler% se battra comme il l\\'entend. Les courtiers, qui ne veulent pas se frotter à un mercenaire, ne discutent pas davantage. Ils partent simplement avant que vous ne puissiez même parier sur votre homme. Maintenant que vous savez que le match va avoir lieu, vous vous y rendez. %brawler% commence le combat en lançant des crochets du gauche et du droit sans se soucier de l\'habileté de son adversaire. L\'adversaire de %brawler% tient bon, il s\'élance, puis crie et lance un crochet désespéré à la tête de %brawler% qui se tord et il tombe au sol, inconscient. La foule est en délire, du moins ceux qui n\'ont pas perdu une seule couronne. L\'un des parieurs s\'approche de vous alors qu\'il compte son argent. Il sourit.%SPEECH_ON%Vous devriez aller chercher votre garçon.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça aurait pu mieux se passer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				local injury = _event.m.Brawler.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Brawler.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Brawler.improveMood(0.5, "Was allowed to fight on his own terms");
				_event.m.Brawler.worsenMood(2.0, "Got badly beaten in a fighting tournament");

				if (_event.m.Brawler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_64.png[/img]{You shock both parties with an announcement that %brawler% won\'t be fighting at all. The brokers wipe their brows and sigh. They\'ve lost a great deal of money, but at least now there\'s some vague reason to stop the bleeding. As for %brawler%, he is wildly upset with your decision. You explain to him that the %companyname% needs all its fighters in the best shape for actual mercenary work. You can\'t risk his health in some bodunk championship brawl.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "There\'ll be plenty of other opportunities to fight, %brawler%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Brawler.getImagePath());
				_event.m.Brawler.worsenMood(2.0, "Was denied participation in a fighting tournament");

				if (_event.m.Brawler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Brawler.getMoodState()],
						text = _event.m.Brawler.getName() + this.Const.MoodStateEvent[_event.m.Brawler.getMoodState()]
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local brawler_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.brawler" && !bro.getSkills().hasSkill("injury.severe_concussion") && !bro.getSkills().hasSkill("injury.broken_knee"))
			{
				brawler_candidates.push(bro);
			}
		}

		if (brawler_candidates.len() == 0)
		{
			return;
		}

		this.m.Brawler = brawler_candidates[this.Math.rand(0, brawler_candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 3 * brawler_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brawler",
			this.m.Brawler.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"reward",
			400
		]);
	}

	function onClear()
	{
		this.m.Brawler = null;
		this.m.Town = null;
	}

});


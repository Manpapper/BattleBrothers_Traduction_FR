this.anatomist_confronts_healer_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Monk = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_confronts_healer";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Vous entrez dans %townname% pour trouver le doyen à la barbe blanche qui s\'occupe d\'une famille dont l\'enfant est malade. Pour vous, cette situation n\'a rien d\'inhabituelle. Pour %anatomist% l\'anatomiste, cependant, cette affaire est loin d\'être anodine. Il traverse si rapidement la route vers le doyen que vous vous jetez devant lui, sentant que ce qu\'il cherche à faire pourrait donner une mauvaise image de la compagnie %companyname% dans son ensemble. %anatomist% se tient droit.%SPEECH_ON%Excusez-moi, cet homme donne de mauvais conseils en matière de soins médicaux. Il a besoin d\'être corrigé.%SPEECH_OFF%Conscient des autochtones, vous le prévenez qu\'il peut être imprudent d\'essayer de s\'immiscer dans les coutumes locales, dont un ancien est presque certainement le fer de lance. Il pourrait encore être de plus grande importance, comme peut-être le superviseur de la milice locale. L\'anatomiste, cependant, est plutôt assidu dans sa tâche, il cherche à utiliser ses propres connaissances comme une arme, même si cela déchire la politique locale.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Allez-y et corrigez-le alors.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Ça ne vaut pas la peine de contrarier les gens du coin.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "%monk%, pouvez-vous lui faire entendre raison?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img]{Vous y réfléchissez un moment, et décidez de laisser l\'anatomiste faire ce qu\'il veut. En faisant un pas de côté, vous vous retournez pour observer ce qui se passe, en espérant que ce ne sera pas un événement qui ternira le nom de la compagnie %companyname% plus que ce charlatan ne semble déjà déterminé à le faire. %anatomiste% se place à côté du vieil homme, ils se regardent un moment, quelques paysans les regardent aussi. L\'anatomiste s\'accroupit et demande au vieil homme s\'il sait que les informations qu\'il donne sont incorrectes.\n\nÉtonnamment, le vieil homme est réceptif à la remarque, et les deux s\'assoient et parlent pendant un long moment. Au lieu d\'être offensés par la présence d\'un étranger, les habitants de la ville sont tout aussi fascinés par les connaissances qu\'il peut avoir. Il y a bien quelques désaccords sur des questions triviales, mais %anatomist% est si heureux de l\'accueil des autochtones qu\'il les évacue et ment même en disant que ces questions ne sont pas encore connues médicalement parlant. Lorsque tout est terminé, l\'anatomiste remet quelques notes au vieil homme, et le village lui offre à son tour une série de cadeaux en guise de remerciement.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça s\'est bien passé.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Gave medical advice to a receptive audience");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(100, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+100[/color] Experience"
				});
				local food;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					food = this.new("scripts/items/supplies/cured_venison_item");
				}
				else if (r == 2)
				{
					food = this.new("scripts/items/supplies/pickled_mushrooms_item");
				}
				else if (r == 3)
				{
					food = this.new("scripts/items/supplies/roots_and_berries_item");
				}

				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_141.png[/img]{Vous y réfléchissez un moment, et décidez de laisser l\'anatomiste faire ce qu\'il veut. En faisant un pas de côté, vous vous retournez pour observer ce qui se passe, en espérant que ce ne sera pas un événement qui ternira le nom de la compagnie %companyname% plus que ce charlatan ne semble déjà déterminé à le faire. %anatomiste% s\'installe à côté du vieil homme, ils se regardent un moment, quelques paysans les regardent également. L\'anatomiste s\'accroupit et demande au vieil homme s\'il se rend compte qu\'il est un charlatan. Vous mettez votre tête dans vos mains. Le vieil homme se lève et pousse l\'anatomiste vers l\'arrière.%SPEECH_ON%Et vous êtes qui, vous? Un voyageur avec un vocabulaire fantaisiste en guise de boite à camembert, hein?%SPEECH_OFF%L\'anatomiste tend les mains et explique clairement qu\'il est un homme intelligent, très bien éduqué, originaire de... avant même qu\'il ne puisse terminer, un paysan s\'approche et le frappe, le faisant tomber dans la boue. La comapgnie %companyname% intervient pour sauver l\'anatomiste et dans la bagarre, quelques coups sont échangés, mais heureusement, cela ne va pas plus loin. Vous faites revenir %anatomist% dans vos rangs et ordonnez à tout le monde de se calmer avant que le côté sombre de la compagnie %companyname% ne soit exposé au grand jour devant tous les laïcs. Le vieux acquiesce et dit qu\'il ne souhaite pas inviter la milice dans ses affaires. Il semble que tout le monde ait échappé de justesse à une affaire bien plus sordide. L\'%anatomiste% se contente de regarder le sang qui coule de son nez et se demande si quelqu\'un calculer le temps qu\'il a mis avant de coaguler.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Espèce d\'idiot.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Had his medical advice rejected");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Anatomist.getName() + " suffers light wounds"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 10)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%anatomiste% se démène pour vous dépasser, mais vous l\'attrapez et le maintenez là où il est. Vous expliquez que critiquer les locaux sur leurs propres coutumes et croyances est un terrain dangereux, et qu\'en tant que mercenaire, vous êtes déjà mal vu à la base. La dernière chose dont vous avez besoin, c\'est de quelques braises soufflées sur le bois sec que sont les traditions locales. L\'anatomiste proteste, mais vous tenez bon. S\'il veut corriger tout le monde toute la journée, il peut retourner dans les écoles ou les universités d\'où il vient. Finalement, %anatomist% s\'éclipse. Vous vous retournez vers l\'ancien juste à temps pour le voir arracher la tête d\'une grenouille et verser son sang dans un bol pour de futures divinations.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reprenons la route.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied the chance to correct improper medical practice");

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
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Alors que %anatomist% tente de vous dépasser, %monk% le moine intervient. Il se tient aux côtés de l\'anatomiste et lui explique calmement que ce n\'est pas parce que quelqu\'un a tort qu\'un tiers doit intervenir pour le corriger. Le fait de critiquer l\'individu sur sa manière de soigner va, tout simplement, exposer la compagnie et non le vieillard. %anatomiste% réfléchit un moment.%SPEECH_ON%Êtes-vous en train de me dire que l\'erreur ici ne réside pas dans les mauvais conseils donnés, mais dans le fait que la communauté dans son ensemble est tellement entachée de mensonges qu\'une entrée de la vérité ne ferait qu\'attiser le feu pour protéger ce qu\'ils croient à tort?%SPEECH_OFF%Le moine se pince les lèvres et hausse les épaules.%SPEECH_ON%Bien sûr.%SPEECH_OFF%L\'anatomiste ne se soucie pas davantage de la question et s\'en va, réfléchissant peut-être à un élément scientifique de cette histoire. Après son départ, le moine secoue la tête.%SPEECH_ON%Je ne veux pas qu\'il fasse l\'imbécile et qu\'il mette la compagnie %companyname% dans le pétrin.%SPEECH_OFF%Vous êtes d\'accord, et vous remerciez le moine de l\'avoir exprimé mieux que vous ne pourriez le faire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Merci, %monk%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(0.5, "Learned something about dealing with the peasantry");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(50, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+50[/color] Experience"
				});
				_event.m.Monk.improveMood(1.0, "Stopped " + _event.m.Anatomist.getName() + " from sullying the company\'s reputation");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}

				local resolveBoost = this.Math.rand(1, 2);
				_event.m.Monk.getBaseProperties().Bravery += resolveBoost;
				_event.m.Monk.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Monk.getImagePath());
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
		local anatomistCandidates = [];
		local monkCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				monkCandidates.push(bro);
			}
		}

		if (monkCandidates.len() > 0)
		{
			this.m.Monk = monkCandidates[this.Math.rand(0, monkCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() > 0)
		{
			this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		}
		else
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 10;
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
			"monk",
			this.m.Monk.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Monk = null;
		this.m.Town = null;
	}

});


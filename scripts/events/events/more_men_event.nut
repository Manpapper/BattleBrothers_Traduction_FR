this.more_men_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.more_men";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]La compagnie entière - une petite équipe hétéroclite si vous deviez la décrire vous-même - entre dans votre tente en même temps. Une troupe de mercenaires apparaissant de la sorte n\'est pas le plus beau des spectacles et pendant une fraction de seconde, vous pensez à saisir votre épée. Mais vous remarquez alors qu\'aucun d\'entre eux n\'a sorti son arme et qu\'ils n\'ont pas le visage d\'hommes sur le point de commettre un meurtre. Bien qu\'ils ne semblent pas former une mutinerie pour s\'emparer de votre tête, vous gardez néanmoins cette idée à l\'esprit.\n\nVous êtes d\'autant plus soulagé qu\'ils ne commencent pas immédiatement à parler, attendant plutôt que vous parliez en premier. C\'est une preuve de respect, et l\'idée de prendre votre épée s\'éloigne. Croisant les bras au-dessus de la table, vous leur demandez ce qui les préoccupe.\n\nIls vous expliquent que la compagnie est trop faible. Partout où ils vont, il y a du danger et les hommes craignent maintenant que chaque nouvelle bataille soit leur dernière. Enfin, ils déclarent carrément ce qu\'ils veulent : s\'ils veulent survivre, ils vont avoir besoin de plus de frères d\'armes à leurs côtés.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'embaucherais plus d\'hommes si seulement nous pouvons nous le permettre.",
					function getResult( _event )
					{
						if (this.World.Assets.getMoney() >= 3000)
						{
							return "D";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "E" : "F";
						}

						return "E";
					}

				},
				{
					Text = "Nous renforcerons bientôt la compagnie avec de nouveaux hommes - vous avez ma parole.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Il n\'y a pas besoin d\'embaucher des hommes, on se débrouille bien comme ça.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous vous levez immédiatement et frappez la table avec vos poings. %SPEECH_ON%Les meilleurs esprits doivent vraiment se penser de la même façon car j\'ai déjà mis de côté quelques couronnes pour engager de nouveaux frères d\'armes !%SPEECH_OFF%Les visages anxieux, presque tristes des hommes commencent lentement à changer. Ils sourient, hochent la tête et disent des choses comme \"bien\" et \"c\'est bien\". Quand ils se tournent pour partir, vous remarquez qu\'ils ont des poignards rangés derrière leur dos.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Time to hire new men.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Malheureusement, vous n\'êtes pas d\'accord.%SPEECH_ON%Vous êtes parmi les meilleurs soldats que j\'ai jamais vus. Je pense que vous n\'avez rien à craindre. Nos ennemis craignent pour leurs propres vies quand ils vous voient !%SPEECH_OFF%Mais vos paroles ne sont pas bien reçues. Un homme se penche en avant avec un bras derrière le dos, mais un autre homme lui tape sur l\'épaule et secoue rapidement la tête. Il vous regarde seulement et dit : %SPEECH_ON% C\'est une nouvelle très inquiétante, monsieur, mais nous allons continuer.%SPEECH_OFF% Lorsqu\'ils se tournent pour partir, vous remarquez que le fermoir de la dague rengainée d\'un homme a été déverrouillé.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça pourrait devenir un problème...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(this.Math.rand(1, 3), "Perte de confiance en votre leadership");

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
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous mentez en écartant les bras et en affichant un sourire qui ne vendrait pas d\'eau à un homme assoiffé. %SPEECH_ON%Nous n\'avons tout simplement pas les fonds nécessaires pour engager plus d\'hommes. %SPEECH_OFF%Les hommes ne le prennent pas bien. L\'un d\'entre eux fait immédiatement demi-tour et sort de la tente, laissant derrière lui un sillage d\'insultes et de jurons. Un autre frère d\'armes passe momentanément la main derrière son dos. Vous regardez à nouveau votre épée. Il vous voit faire cela, puis remet ses mains en place, là où vous pouvez les voir. Finalement, il hoche la tête.%SPEECH_ON%Je ferai ce qu\'on me dit, monsieur. Pour l\'instant.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça pourrait devenir un problème...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.worsenMood(this.Math.rand(1, 6), "On lui a menti et il n\'a plus confiance en votre leadership.");
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]Lorsque vous faites savoir aux hommes que vous n\'avez pas assez de couronnes pour en engager d\'autres, ils acquiescent.%SPEECH_ON%Nous savions que vous alliez dire ça, alors voici notre suggestion, et nous ne le disons pas à la légère, mais chacun de nous vous donnera une partie de ce qu\'il a économisé pour sa retraite afin que vous puissiez embaucher d\'autres hommes. Et vous nous rembourserez en augmentant nos salaires.%SPEECH_OFF%Vous levez rapidement les yeux au ciel, la suggestion semblant venir de nulle part.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est ainsi que nous procéderons alors - merci à tous pour votre sacrifice.",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Ce ne sera pas nécessaire.",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous faites savoir aux hommes que vous n\'avez pas les couronnes pour prendre plus de mercenaires. Ils soupirent collectivement et hochent la tête.%SPEECH_ON%C\'est bon, monsieur. C\'était seulement une suggestion. Comme toujours, nous marcherons sur vos ordres.%SPEECH_OFF%Les hommes se retournent et partent, un peu plus courbés et plus silencieux qu\'avant.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les choses vont s\'améliorer pour la compagnie, j\'en suis sûr.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 20)
					{
						bro.worsenMood(1, "Perte de confiance en votre leadership");

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
			ID = "G",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous vous levez et serrez la main de chaque homme. Tout en déclarant à voix haute que vous souhaitiez ne pas en arriver là, vous vous réjouissez secrètement du fait que vous avez maintenant plus de couronnes à votre disposition.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Allons embaucher quelques hommes de plus pour la compagnie !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(1000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + 1000 + "[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.getBaseProperties().DailyWage += 3;
					bro.getSkills().update();
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_daily_money.png",
						text = bro.getName() + " est maintenant payé " + bro.getDailyCost() + " Couronnes par jour"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous regardez les hommes. Ce sont des personnes solennelles, pas celles que vous avez vues la dernière fois, souriant et riant de leur dernière victoire ou triomphe. Bien que vous ne puissiez pas encore vous permettre de leur donner plus d\'hommes, il n\'y a vraiment pas besoin de piocher dans leur retraite.%SPEECH_ON% J\'apprécie l\'altruisme et la bravoure qu\'il a fallu pour suggérer une telle chose, mais je ne peux pas me considérer comme un homme d\'honneur et vous accorder cette requête. Vos économies ne seront pas touchées.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'apprécie l\'offre, néanmoins.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 20)
					{
						bro.improveMood(1.0, "Confiance accrue en votre leadership");

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
		if (this.World.Assets.getOrigin().getID() == "scenario.lone_wolf" || this.World.Assets.getOrigin().getID() == "scenario.gladiators")
		{
			return;
		}

		if (this.World.getTime().Days <= 10)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() == 1 || brothers.len() > 5)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


this.ruined_priory_event <- this.inherit("scripts/events/event", {
	m = {
		InjuryBro = null
	},
	function create()
	{
		this.m.ID = "event.ruined_priory";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Vous rencontrez un moine debout devant un prieuré. Les murs du bâtiment ont été détruits, des dalles de pierre se détachant des fondations, les plus petites pierres étant réduites en poudre dans l\'effondrement qui a suivi. Il explique qu\'un tremblement de terre a entièrement ébranlé le site, brisant des morceaux et faisant presque s\'effondrer l\'ensemble. Il soupire.%SPEECH_ON%Le pire, ce ne sont pas seulement les dégâts matériels, le pire, c\'est que le tremblement de terre a secoué les fidèles eux-mêmes. Ils ne sont pas encore revenus vers moi car ils craignent que les anciens dieux n\'aient choisi notre terre comme point de punition pour quelques erreurs non commises dans le passé.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous avons de l\'or. Pourriez-vous reconstruire avec 2500 couronnes?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "B" : "C";
					}

				},
				{
					Text = "Nous avons des outils. Je pense que 40 devrait suffire?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 75 ? "D" : "E";
					}

				},
				{
					Text = "Ce n\'est pas notre problème.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Vous versez l\'argent au moine pour qu\'il répare le prieuré. Il fond en larmes, disant qu\'il ne s\'attendait pas à ce que de tels hommes d\'honneur existent en ce monde, et encore moins qu\'ils viennent le rencontrer personnellement. Le fait même que vous soyez là, et que vous soyez si généreux, est sûrement un signe que les anciens dieux ne le punissent pas.%SPEECH_ON%Non seulement ces couronnes me permettront de reconstruire, mais une telle générosité sera vue par les habitants comme un signe que les anciens dieux ne nous punissent pas en fait! Tenez, prenez ça. Il a tout juste survécu aux décombres, mais peut-être qu\'il sera plus utile qu\'à nous.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tout cela en une journée de travail.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(6);
				this.World.Assets.addMoney(-2500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]2500[/color] Crowns"
				});
				local item = this.new("scripts/items/weapons/noble_sword");
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(60, 80) * 0.01));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.improveMood(0.75, "The company helped restore a priory");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "The company helped restore a priory");
					}

					if (bro.getMoodState() > this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 11,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous posez votre main sur l\'épaule du moine. Il vous regarde, les larmes aux yeux, puis jette un coup d\'œil à la bourse de couronnes que vous lui tendez. Il la prend et la tient tendrement comme s\'il n\'avait jamais reçu de cadeau de toute sa vie.%SPEECH_ON%C\'est... c\'est pour le prieuré?%SPEECH_OFF%En hochant la tête, vous lui dites de l\'utiliser pour reconstruire le site. Vous commencez à suggérer d\'ajouter un modeste clocher, mais au moment où vous vous lancez dans des références architecturales médiocres, un homme arrive en hurlant sur la route.%SPEECH_ON%Ne faites pas confiance à ce rat! C\'est un bon à rien de mendiant!%SPEECH_OFF%Lorsque vous vous retournez, le prétendu moine qui se trouvait sur les marches du prieuré est déjà en train de s\'enfuir, de sprinter le long de la route avant de sauter au dessus d\'un fossé et de disparaître dans les broussailles l\'argent à la main. L\'homme qui descend la route lève les mains en l\'air.%SPEECH_ON%Ce misérable joue à \"pauvre de moi\" depuis des semaines maintenant. Ce bâtiment est mort et enterré, il n\'a pas été occupé depuis que les peaux vertes l\'ont détruit il y a dix ans. Je sais que vous vouliez juste faire le bien, mais il y a beaucoup de gens dans ce monde qui voient votre générosité comme une cible. Désolé que vous vous soyez fait avoir, les gars.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fait chier..",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-2500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]2500[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" && this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "The company had its kindness taken advantage of");
					}
					else
					{
						bro.worsenMood(0.75, "The company was duped out of crowns by a charlatan");
					}

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

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_85.png[/img]{Vous pensez que la compagnie %companyname% a les outils et la main d\'œuvre pour accomplir les travaux. En souriant, vous dites au moine qu\'ils vont se mettre en route et rectifier le presbytère. Le saint homme est hors de lui tandis que vous et les Oathtakers rassemblez vos équipement et commencez les réparations. Cela prend quelques heures mais cela en vaut la peine. Lorsque vous avez terminé, une foule de paysans est apparue. Ils repartent non seulement avec les anciens dieux en tête, mais aussi avec le nom de la %companyname% sur la langue. Nul doute que beaucoup entendront parler des Oathtakers dans les jours à venir!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voilà du travail bien fait",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(6);
				this.World.Assets.addBusinessReputation(100);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
				this.World.Assets.addArmorParts(-40);
				this.List.push({
					id = 11,
					icon = "ui/icons/asset_supplies.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]40[/color] Tools and Supplies"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.improveMood(1.0, "Helped repair a damaged priory");
					}
					else
					{
						bro.improveMood(0.75, "Helped repair a damaged priory");
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 11,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_40.png[/img]{Vous attrapez le moine et le remettez debout. Vous lui dites que la compagnie %companyname% va réparer le prieuré. Il est en larmes mais il vous prévient qu\'il est peut-être impossible de le sauver. En souriant, vous lui dites que rien n\'est trop difficile pour les Oathtakers. Un instant plus tard, %injurybro% intervient sur mur défoncé mais tout s\'écroule en quelques secondes, l\'enterrant rapidement sous un tas de gravats. Tout le monde pousse un cri d\'horreur et va le sortir de là. Pendant ce temps, le reste du bâtiment s\'effondre dans un flot de pierres en poudre. %injurybro% est sauvé des débris, mais avec un bon nombre de blessures.%SPEECH_ON%Eh bien, je suppose que c\'est l\'intention qui compte...%SPEECH_OFF%En se grattant l\'arrière de la tête, le moine dit%SPEECH_ON%Peut-être que les anciens dieux ont vraiment cherché à nous punir ici. Mais peu importe, je pense que vous avez bien fait, n\'est-ce pas? Je parlerai en bien de vous, %companyname%.%SPEECH_OFF%}",
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
				this.World.Assets.addMoralReputation(3);
				this.World.Assets.addBusinessReputation(35);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
				_event.m.InjuryBro.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.InjuryBro.getName() + " suffers heavy wounds"
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Vous décidez que cette affaire ne vous appartient pas. Ce choix amène quelques hommes à s\'interroger sur votre leadership. Bien sûr, les Serments ne peuvent pas tous être suivis à la lettre, mais ne pas dépenser une goutte de sueur ou une once de couronne pour aider un saint homme et son troupeau? C\'est en négligeant les petites choses, celles qui ne demandent aucun effort, qu\'un homme peut devenir un sauvage impitoyable.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ouais, ouais.",
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
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(0.75, "You refused to help a monk in need");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "You refused to help a monk in need");
					}

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

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Assets.getMoney() < 3000)
		{
			return;
		}

		if (this.World.Assets.getArmorParts() < 40)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		this.m.InjuryBro = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"injurybro",
			this.m.InjuryBro.getName()
		]);
	}

	function onClear()
	{
		this.m.InjuryBro = null;
	}

});


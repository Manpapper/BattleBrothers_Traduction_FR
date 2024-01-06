this.civilwar_savagery_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_savagery";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]{En marchant sur un chemin, vous tombez sur un lieutenant de la maison noble %noblehouse% menant un groupe d'hommes dans un massacre. Ils ont rassemblé les habitants d'un petit hameau et s'apprêtent à les mettre tous à l'épée. Un des laïcs vous appelle, vous supplie d'intervenir. Le lieutenant vous jette un coup d'œil. Il n'a pas assez d'hommes pour vous arrêter, et vous pas assez pour l'arrêter, mais il y en a assez des deux côtés pour s'assurer que tout le monde perd.%SPEECH_ON%Ne vous embêtez pas, mercenaire. Il n'y a aucun profit ici pour vous. Continuez juste de marcher.%SPEECH_OFF% | La marche de la %companyname% est soudainement interrompue lorsque vous tombez sur un groupe d'hommes portant la bannière de %noblehouse%. Malheureusement, porter une bannière n'est pas la seule chose qu'ils font - ils ont aligné des paysans d'un hameau voisin et semblent prêts à tous les massacrer. Le lieutenant de la troupe vous fixe du regard.%SPEECH_ON%Ne compliquons pas les choses, mercenaire. Je vous suggère de continuer à marcher.%SPEECH_OFF% | Vous arrivez à une chaumière. Quelques porteurs de bannière de %noblehouse% montent la garde devant sa porte. À l'intérieur, vous entendez les cris d'une femme et d'un homme. Le lieutenant sort et vous voit. Il se redresse, se coiffe même les cheveux en arrière, et vous dit de déguerpir.%SPEECH_ON%Ne commencez rien, mercenaire. Continuez simplement.%SPEECH_OFF% | Vous arrivez à une sorte de temple sacré à cet ancien dieu ou à un autre. Quelques porteurs de bannière de %noblehouse% barricadent la porte pendant que leur lieutenant agite un flambeau. Les gens crient à l'intérieur du bâtiment. Vous levez un sourcil et le lieutenant le remarque.%SPEECH_ON%Hé, mercenaire. Ouais, toi. Avance. Ce n'est pas ton spectacle.%SPEECH_OFF% | En marchant, vous entendez soudain les cris perçants d'enfants. Leur aboiement vous attire, et vous les trouvez d'un côté de la route tandis que de l'autre leurs parents sont à genoux sous une douzaine d'épées d'exécution. Un lieutenant de %noblehouse% se tient à proximité, brandissant fièrement la bannière de sa noble maison. Il vous regarde.%SPEECH_ON%Oh, mercenaire. Es-tu venu pour regarder ? Je l'espère, car tu ferais mieux de ne pas intervenir. Ce n'est pas ton combat.%SPEECH_OFF% | Ayant besoin de faire pipi, vous montez une colline voisine pour un peu d'intimité, mais surtout pour remettre vos pensées en ordre. Malheureusement, cela ne se produira pas. Des pentes opposées se tiennent un certain nombre d'hommes de la %noblehouse%, suivant les ordres aboyés de leur lieutenant qui squatte non loin de l'endroit où vous alliez faire pipi. Les troupes rassemblent des femmes de quelques chaumières cousues dans une colline adjacente. Les hommes du hameau sont déjà tués, morts dans l'herbe ici et là. Pas plus que des amas tachetés à cette distance.\n\nLe lieutenant lève les yeux vers vous.%SPEECH_ON"Hello there, sellsword, nice day, no?"%SPEECH_OFF%Il a dû voir le regard déconcertant sur votre visage car le sien se gâte bientôt.%SPEECH_ON%Hé. Écoutez. N'allez pas vous faire des idées d'héroïsme, d'accord ? Continuez simplement à marcher. J'ai vu ce regard auparavant et si vous ne le mettez pas de côté, il y aura des ennuis pour nous tous.%SPEECH_OFF% | En marchant sur un chemin, vous entendez les aboiements de quelques chiens. Apparemment, un groupe d'hommes de la %noblehouse% a vidé quelques chaumières et tout ce qui reste sont les pauvres bâtards retranchés dans un chenil. Il y a quelques soldats dehors avec des torches, prêts à mettre chaque clébard en feu. Un lieutenant se tient à proximité, un horrible sourire sur le visage, bien qu'il disparaisse rapidement en vous voyant.%SPEECH_ON"Oh, tu es amoureux des chiens ou quelque chose comme ça ? Ne me regarde pas comme ça. Tu ferais mieux de continuer à marcher, mercenaire, ou je te traiterai comme l'un de ces chiens ici.%SPEECH_OFF% | Pendant les périodes de guerre, les routes sont souvent les pires endroits où se trouver - elles apportent la terreur de part et d'autre et aujourd'hui ne fait pas exception. Vous trouvez quelques soldats de la %noblehouse% qui traînent à côté du chemin, regardant vers le bas quelqu'un qu'ils ont ligoté et suspendu au-dessus d'un feu pas encore allumé. En vous approchant, le lieutenant des soldats se tourne pour vous regarder.%SPEECH_ON"Eh bien, si ça ne vous plaît pas, continuez à marcher. C'est la guerre, que pouviez-vous attendre ? Maintenant, dégagez d'ici, on doit allumer un feu.%SPEECH_OFF% | Tout en marchant sur un chemin hors des routes principales, évitant les carnages qu'une guerre civile peut causer, vous découvrez quelques soldats de la %noblehouse% torturant un homme. Ils ont allumé des torches partiellement enveloppées de cuir et laissent les morceaux de bandelettes brûlantes tomber sur leur pauvre prisonnier. Il crie grâce, mais ils n'en ont certainement aucune pour lui. En vous voyant, cependant, il vous appelle, suppliant de l'aide. Un des soldats se tourne vers vous.%SPEECH_ON"Ça te plaît ? Mon père a inventé cette forme de torture. Tu laisses simplement le cuir enflammé goutter partout sur eux. Beaucoup mieux que de simples petits charbons.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Nous devons mettre fin à cette folie.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(4);

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
					Text = "Ce n'est pas à nous d'intervenir ici.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Avec un ordre rapide, la %companyname% se précipite au secours. Les hommes de la %noblehouse% sont éliminés, ensanglantés et rapidement. Pleurant et à jamais reconnaissants, les laïcs sauvés vous embrassent presque les pieds. Vous leur dites de courir, de peur que le reste de l'armée de la noblesse n'arrive. | Vous dites aux hommes de la %companyname% de faire vite. Les soldats de la %noblehouse% tentent de se défendre, mais ils ont passé les dernières minutes à se préparer à tuer des innocents, et non à se défendre contre des adversaires plus coriaces. Ils sont abattus sans grande difficulté. Les laïcs sauvés s'enfuient, ils crient des remerciements mais ne restent pas longtemps. | La %companyname% ne tolérera pas de telles atrocités aujourd'hui. Vous ordonnez aux mercenaires de tuer les quelques soldats non préparés de la %noblehouse% et ils le font rapidement. Les paysans et les laïcs sauvés expriment leur gratitude. Vous leur dites simplement de déguerpir, car il est clair que cette terre n'est plus sûre pour personne. | Contre un meilleur jugement, vous vous impliquez. Les hommes de la %companyname% sont ordonnés d'avancer. Pas préparés pour un véritable combat, les soldats de la %noblehouse% sont abattus rapidement, parfois en criant. Les paysans et les gens ordinaires expriment leur gratitude avant de s'éloigner rapidement.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Un bon acte a été accompli ici aujourd'hui.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Killed some of their men");
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "La compagnie a acquis une renommée"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.5, "Helped save some peasants");

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
			ID = "C",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Vous ordonnez à vos hommes de sauver les pauvres paysans, mais les soldats de la %noblehouse% sont prêts pour vous. Pas avec des armes - non, ils n'ont pas assez d'hommes pour ça - mais avec quelques chevaux à proximité. Ils s'enfuient, sans aucun doute pour ruiner votre réputation auprès de la noblesse, mais on s'en fout. Les laïcs, en revanche, sont éternellement reconnaissants. | Vous ordonnez à l'homme de la %companyname% de faire rapidement le travail sur les soldats. Certains sont rapidement tués, mais le lieutenant parvient à monter à cheval et à s'enfuir. C'est un cheval très rapide. Vous doutez que vous seriez capable de le rattraper même si vous aviez un cheval vous-même, ce qui n'est pas le cas. Les paysans sauvés sont très reconnaissants, bien que cela ne vous aidera probablement pas maintenant avec la noblesse de la %noblehouse%. | Vous n'avez pas repéré quelques chevaux qui traînaient à proximité. Alors que quelques soldats sont rapidement abattus, vos mercenaires ne parviennent pas à rattraper le lieutenant qui monte en selle et s'enfuit dans un nuage de poussière et, dans votre cas, une réputation ternie auprès de la noblesse. Ce n'est pas comme si vous vous souciez de ce qu'ils pensent. Les laïcs, en revanche, sont presque en larmes de gratitude. Vous leur dites de partir vite. Qui sait quels dangers ou mauvaises intentions errent dans les terres de nos jours.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Eh bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, "Attacked some of their men");
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "La compagnie a acquis une renommée"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.5, "Helped save some peasants");

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
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates = [];

		foreach( h in nobleHouses )
		{
			if (h.isAlliedWithPlayer())
			{
				candidates.push(h);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
	}

});


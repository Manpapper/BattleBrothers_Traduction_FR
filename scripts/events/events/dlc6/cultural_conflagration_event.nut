this.cultural_conflagration_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.cultural_conflagration";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_175.png[/img]{Des cris et des hurlements vous empêche de compter l\'inventaire. Vous trouvez quelques-uns des hommes debout aux extrémités opposées du feu de camp, pointant du doigt et même une arme ou deux. Il semble qu\'il y ait une petite querelle pour savoir qui des femmes sont les plus belles : les sudistes ou les nordistes. Ironiquement, les nordistes votent pour les sudistes et vice versa. Quelques ordres sévères ramènent l\'ordre dans la compagnie, mais les tensions demeurent. | Il y a eu quelques bagarres entre certains hommes. Apparemment, il y a eu un désaccord sur les rites de mariage entre hommes et femmes. Les nordistes pensent qu\'il faut être seul et unique, tandis que les sudistes préfèrent épouser autant de femmes que possible. Tu dis aux hommes d\'arrêter de se battre comme des femmes et de se concentrer sur la tâche à accomplir, de terminer un travail pour obtenir de l\'argent à dépenser ensuite pour une femme, mais ce n\'est n\'est pas la moment. | Quelques hommes se disputent à propos de différences religieuses. Un conflit sur les anciens dieux et le Doreur, chaque homme étant un petit ambassadeur de sa foi, mettant diplomatiquement les poings dans la figure des opposants. Vous leur dites à tous d\'arrêter et de mettre de l\'ordre dans leur tête. S\'ils veulent se disputer pour savoir quels dieux sont les meilleurs, ils peuvent le faire dans l\'au-delà. | Un couple d\'hommes se dispute sur des questions de... sable ? Il semble que les nordistes de la compagnie se moquent des sudistes, demandant à quel point il faudrait être stupide pour s\'installer dans une terre où il n\'y a que du sable.%SPEECH_ON%Qui regarde autour de lui dans une dune de sable au cul chaud et pense, aye, ce sera ma maison. Je parie que vous aimeriez que vos ancêtres aient l\'esprit assez vif pour réaliser qu\'il y a autre chose dans le monde qu\'un coup de soleil éternel.%SPEECH_OFF%Ceci entraîne le premier coup de poing. La bagarre fait quelques blessés, mais vous ramenez les hommes à l\'ordre, en leur ordonnant de garder pour eux leurs opinions géographiques. | Une dispute éclate lorsque les Sudistes de la compagnie commencent à se moquer du manque d\'articulation de leurs frères du Nord. L\'un d\'entre eux imite la scène en plaçant ses mains sur ses oreilles : Nous parlons tous comme ça, oui, oui, vous n\'êtes pas prêts à vous lancer dans une telle histoire, oui ? Des coups de poing mettent fin à la plaisanterie. Quelques-uns sont meurtris dans l\'échange, mais vous parvenez à les séparer avant que cela ne devienne plus sérieux. | Bien que normalement dédaigneux de leurs suzerains, les gens du nord et du sud prennent la défense des seigneurs et des vizirs de leurs terres respectivement. Il semble que le fait d\'avoir une certaine opposition culturelle a suscité des alliances jusqu\'alors inconnues. Les arguments se transforment en un véritable combat à mains nues, sans qu\'aucun seigneur ne soit impressionné. Vous l\'interrompez, en leur disant que la seule personne qu\'ils doivent chercher à impressionner, c\'est vous ou l\'autre, en tant que frères de bataille.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pourquoi ne pouvons-nous pas tous nous entendre ?",
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
					if (this.Math.rand(1, 100) <= 33)
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							bro.improveMood(0.5, "Ils se sont battus pour des différences culturelles");
						}
						else
						{
							bro.worsenMood(0.5, "Ils se sont battus pour des différences culturelles");
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

					if (this.Math.rand(1, 100) <= 40)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() <= 5)
		{
			return;
		}

		local northern = 0;
		local southern = 0;

		foreach( bro in brothers )
		{
			if (bro.getEthnicity() == 0)
			{
				northern = ++northern;
			}
			else
			{
				southern = ++southern;
			}
		}

		if (northern <= 1 || southern <= 1)
		{
			return;
		}

		this.m.Score = this.Math.min(northern, southern) * 2;
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


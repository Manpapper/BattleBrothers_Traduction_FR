this.civilwar_hungry_hamlet_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_hungry_hamlet";
		this.m.Title = "Le long du chemin...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]{En parcourant les routes, vous tombez sur un petit hameau avec, apparemment, toute la population debout à l\'extérieur. Leur chef s\'avance, tend les mains, suppliant, bien qu\'il ait à peine la force de garder les mains jointes.%SPEECH_ON%S\'il vous plaît, pourriez-vous nous aider ? Nous sommes sans nourriture depuis presque une semaine maintenant. Nous sommes en train de manger de la terre ! Vous devez comprendre, nous n\'avons rien ! La guerre nous a tous pris.%SPEECH_OFF% | Un petit hameau émerge lors de vos voyages, un peu plus qu\'un clin d\'oeil superficiel s\'il n\'y avait pas le grand groupe de villageois qui se tenaient à l\'extérieur et qui semblaient vous attendre. Leur chef s\'avance.%SPEECH_ON%Mercenaire, je sais que vous n\'êtes probablement pas celui à qui demander cela, mais avez-vous de la nourriture à vendre ? La guerre a ravagé nos récoltes et les soldats qui parcourent cette terre ont pris tout ce qu\'il y a d\'autre à prendre ! S\'il vous plaît, aidez-nous !%SPEECH_OFF% | Les routes vous mènent à un petit hameau. Les villageois sont accroupis devant leurs masures, la tête entre les genoux, l\'air maigre et grisâtre. Les enfants sont avec eux, frêles et nerveux, mais avec l\'éclat de la jeunesse encore dans leurs yeux. Le chef du hameau vient vous voir personnellement.%SPEECH_ON%Monsieur... puis-je vous dire un mot ? Oui, merci. S\'il vous plaît, nous sommes sans nourriture depuis une semaine maintenant. Nous avons survécu grâce à nos animaux de compagnie, des insectes... même la saleté. Avez-vous quelque chose pour nous aider ?%SPEECH_OFF% | Alors que vos hommes se reposent au bord de la route, des villageois d\'un hameau voisin viennent vers vous. Ils trébuchent vers l\'avant, leurs jambes nerveuses les traînant d\'un côté à l\'autre. Le chef du groupe lève et baisse la main comme pour bénir votre présence.%SPEECH_ON%Oh mercenaire, s\'il vous plaît, avez-vous quelque chose à manger ? Nous n\'avons pas mangé un morceau depuis deux jours ! Et ce que nous avons mangé sont des choses à ne pas dire à voix haute ! La guerre entre nobles a ruiné cet endroit, mais peut-être pouvez-vous nous aider ?%SPEECH_OFF%}",
			Characters = [],
			Options = [
				{
					Text = "Très bien, donnons à manger à ces pauvres gens.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(3);
						local r = this.Math.rand(1, 3);

						if (r == 1)
						{
							return "B";
						}
						else if (r == 2)
						{
							return "C";
						}
						else if (r == 3)
						{
							return "D";
						}
					}

				},
				{
					Text = "Trouvez votre propre chemin, paysans.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Contre le jugement typique des mercenaires, vous choisissez de donner de la nourriture aux pauvres villageois. On dit à %randombrother% de donner ce qu\'il peut, mais évidemment pas trop. Le peuple est éternellement reconnaissant, comme s\'il allait murmurer une vérité immense et inoubliable. Le chef de la petite ville dit qu\'il fera connaître votre bonne volonté. Vous n\'êtes en fait pas sûr que les nouvelles d\'altruisme soient bonnes pour un groupe de mercenaires... | Choquant les villageois, vous ordonnez à %randombrother% de distribuer de la nourriture. Pas trop, juste assez pour que ces gens puissent manger. Et évidemment, ne donnez rien de trop beau !\n\n Le chef de la ville vient vers vous en vous serrant la main en tapant sur vos épaules.%SPEECH_ON%Vous n\'avez aucune idée de ce que cela signifie pour nous ! Tout le monde entendra parler du bien dans le...%SPEECH_OFF%Il vous regarde, puis votre bannière. Vous acquiescez.%SPEECH_ON%Le %companyname%.%SPEECH_OFF%L\'homme rit.%SPEECH_ON%Bien sûr ! Tout le monde entendra parler de %companyname%!%SPEECH_OFF%}",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Feront-ils mieux dans les jours à venir.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.distributeFood(this.List);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "La compagnie a gagné en renommée"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_79.png[/img]{La bonté prend le dessus sur vous : vous commandez %randombrother% pour commencer à distribuer de la nourriture. Il s\'exécute, mais dès qu\'il commence à distribuer, la foule devient presque enragée, l\'arrachant les uns aux autres. Les tempéraments fougueux sont vite nourris par l\'air des ventres vides. Le mercenaire essaie de maintenir l\'ordre, mais tout ce qu\'il dit ne fait qu\'inciter les masses affamées à penser que tout est de sa faute. La violence déborde, renversant ironiquement toute la nourriture dans la boue. Vos frères doivent tirer leurs épées et à la fin, des paysans sont morts tandis que les survivants regardent les cadavres avec des yeux cannibales.\n\nVous ordonnez rapidement à %companyname% de partir avant que cela n\'empire. | Pour une raison quelconque, peut-être pour mieux dormir la nuit, vous ordonnez à %randombrother% de distribuer des colis de nourriture. Il ne fait que commencer le processus lorsqu\'un villageois s\'empare rapidement d\'un sac de nourriture. Un autre paysan frappe la tête de cet homme et prend le sac pour lui. Cela dégénère rapidement en une mêlée totale et vos mercenaires doivent dégainer leurs armes pour protéger le reste des chariots. À la fin de la bagarre, quelques paysans sont morts et vos frères sont un peu marqués. Ne voyant aucune raison de traîner, vous ordonnez à la compagnie de reprendre la route. Le chef qui a demandé votre aide est repéré au loin, regardant l\'horizon alors qu\'un vent glacial enroule son souffle fin autour de ses tibias.}",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "C\'est parti en vrille bien trop rapidement",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.distributeFood(this.List);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_79.png[/img]Bien. Ce monde est un endroit terrible et si vous pouvez faire un peu pour le soulager de sa nature horrible, pourquoi pas ? Vous commandez %randombrother% pour commencer à distribuer de la nourriture, mais pas trop, et rien ne manquera à vos goûts. Mais alors qu\'il vaque à ses occupations, quelques soldats brandissant la bannière %noblehouse% apparaissent. Ils passent au crible la foule affamée, prenant de la nourriture et tirant des épées chaque fois que quelqu\'un résiste. Leur chef supposé s\'exprime.%SPEECH_ON%Cette nourriture est nécessaire au bras de %noblehouse%. Ne résistez pas à sa saisie.%SPEECH_OFF%Vous expliquez à l\'homme que c\'est en fait votre nourriture et vous venez de la lui donner.%SPEECH_ON%Si c\'est votre nourriture, pourquoi est-elle entre leurs mains ? Allez, messieurs, prenez tout ce que vous pourrez ! Et n\'essayez rien, mercenaire, ou il y aura de la violence.%SPEECH_OFF%%randombrother% vous regarde comme pour dire, que devons-nous faire ?",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "C\'est notre nourriture et nous décidons de ce que nous en faisons !",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
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
					Text = "C\'est notre nourriture, mais ce n\'est pas notre combat.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.distributeFood(this.List);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_79.png[/img]Le lieutenant se retourne vers ses hommes, les dirigeant dans leur vol. Vous tirez votre épée et boitillez, la douleur dans votre côté persiste, mais il ne faut pas beaucoup d\'efforts pour se faufiler derrière un homme. Avec une lame rapide autour de son cou, vous appelez le reste de ses hommes.%SPEECH_ON%C\'est vraiment de la violence que vous voulez ?%SPEECH_OFF%En levant les mains, le lieutenant grince quelques mots.%SPEECH_ON%Attendez, attendez, attendez. Je pense que nous, euh, avons fait une erreur. Ce n\'est pas le bon village, les gars.%SPEECH_OFF%Vous l\'avez entaillé avec l\'épée avant de le relâcher. Les paysans se réjouissent car la nourriture leur revient. Sans aucun doute, la noblesse entendra parler de vos \'bonnes\' actions accomplies ici, mais le commun des mortels aussi.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Parfois, être stupide fait du bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Vous avez menacé certains de leurs hommes");
				this.World.Assets.addMoralReputation(3);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "La compagnie a gagné en renommée"
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_79.png[/img]Vous attrapez le lieutenant par l\'épaule et l\'attirez contre vous. Il vous attrape par le bras et vous projette, dégainant son épée dans le même mouvement. Vous sautez à ses côtés, bloquant le tirage, et à votre tour tirez un poignard rapide et le plongez dans son cou. Ses soldats se précipitent dans la foule, mais vos mercenaires les abattent et les paysans les achèvent avec une brutalité pure que seule la faim peut créer. Le lieutenant glisse lentement de votre emprise. Vous fixez ses yeux noircis.%SPEECH_ON%Oui, il y aura de la violence.%SPEECH_OFF%Les paysans applaudissent le résultat, bien que vous leur recommandiez d\'enterrer les corps ou, mieux encore, de ne plus être là. Nul doute qu\'une armée se demandera où sont passés ces hommes.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Nous devrions aussi y aller.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, "Tu as tué certains de leurs hommes");
				this.World.Assets.addMoralReputation(1);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "La compagnie a gagné en renommée"
				});
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				local injury = bro.addInjury(this.Const.Injury.Accident1);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = bro.getName() + " souffre " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_79.png[/img]Vous demandez à vos hommes de se retirer. Les gens du peuple se lamentent alors que leur nourriture leur est à nouveau enlevée. C\'est un cri horrible et beaucoup vous damnent, déclarant qu\'ils préféreraient que vous ne vous soyez jamais présenté du tout plutôt que d\'être torturé de cette manière. | Donner à manger est une chose, se quereller avec des soldats en est une autre. Vous informez les soldats qu\'il n\'y aura pas de combat et qu\'ils peuvent continuer. Les paysans crient, vous suppliant d\'y mettre un terme. Certains sont trop faibles pour dire quoi que ce soit, cette tournure soudaine des événements ayant été un coup plus dur que n\'importe quelle longue semaine de faim.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Désolé...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Assets.addBusinessReputation(-this.Const.World.Assets.ReputationOnContractSuccess);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "La compagnie a perdu en renommée"
				});
			}

		});
	}

	function distributeFood( _list )
	{
		local food = this.World.Assets.getFoodItems();

		for( local i = 0; i < 2; i = ++i )
		{
			local idx = this.Math.rand(0, food.len() - 1);
			local item = food[idx];
			_list.push({
				id = 10,
				icon = "ui/items/" + item.getIcon(),
				text = "Vous donnez " + item.getName()
			});
			this.World.Assets.getStash().remove(item);
			food.remove(idx);
		}

		this.World.Assets.updateFood();
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

		local food = this.World.Assets.getFoodItems();

		if (food.len() < 3)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= bestDistance)
			{
				bestDistance = d;
				bestTown = t;
				break;
			}
		}

		if (bestTown == null)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
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


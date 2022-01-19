this.civilwar_conscription_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_conscription";
		this.m.Title = "À %town%";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Les soldats de %noblehouse% tentent d\'enrôler les habitants. Les paysans, naturellement, ne veulent pas participer à la guerre et refusent d\'y aller de leur plein gré. Un lieutenant des bannerets, ses hommes manifestement en sous-effectif pour cette situation, vous demande de l\'aide. | Vous rencontrez une foule de paysans criant à quelques soldats de %noblehouse%. Ils déclarent qu\'ils ne prendront pas part aux guerres entre maisons nobles.%SPEECH_ON%Qu\'ont fait les seigneurs pour nous !%SPEECH_OFF%Un homme demande, acclamé par beaucoup. Un lieutenant aboie.%SPEECH_ON%Il vous a honoré de sa terre, afin que vous et vos familles puissiez prospérer !%SPEECH_OFF%Un vieil homme crache en retour.%SPEECH_ON%Ce n\'était pas la terre de ce vieux con. Ce n\'était la terre de personne jusqu\'à ce que ce voyou le dise. Et pourquoi? Parce qu\'il a fait croire à des crétins en armures qu\'il avait raison ?%SPEECH_OFF%La foule applaudit de plus en plus fort.%SPEECH_ON%Vous nous en avez déjà pris beaucoup, alors partez ! Si vos vies ne peuvent pas résoudre leurs querelles de nobles, qu\'est-ce qui pousserait le dernier d\'entre nous à y participer ?%SPEECH_OFF%Le lieutenant se tourne vers vous et demande de l\'aide, comme si vous pouviez être particulièrement convaincant pour faire mourir des gens pour des causes dont ils se moquent. | Une foule de paysans occupés encombre la route qui traverse %town%. En vous rapprochant, vous vous rendez compte qu\'un groupe de bannerets de %noblehouse% essaie d\'enrôler les jeunes et, clairement, ce n\'est pas un combat auquel ces gens souhaitent participer. N\'ayant pas assez d\'hommes pour gérer la situation par lui-même, le lieutenant des soldats se tourne vers vous.%SPEECH_ON%Ah, mercenaire. Auriez-vous la gentillesse de faire venir ces avortons avec nous ? Les nobles entendront parler de votre acte...%SPEECH_OFF% | Apparemment, chaque villageois se démarque sur la route qui serpente à travers %town%. En vous frayant un chemin à travers la foule, vous arrivez à un petit groupe de soldats abasourdis et effrayés de %noblehouse%. Leur lieutenant a les mains en l\'air, un parchemin brandit.%SPEECH_ON%Ce ne sont pas mes ordres, mais j\'ai l\'intention de les exécuter !%SPEECH_OFF%Un paysan crache.%SPEECH_ON%Ouais, emmenez-les dans la tombe !%SPEECH_OFF %En vous voyant, le lieutenant implore votre aide.%SPEECH_ON%Mercenaire ! Nous avons besoin de soldats pour la grande guerre entre les maisons nobles... Ces... imbéciles, ne suivent pas les ordres. L\'ordre des seigneurs ! Aidez-nous et je veillerai personnellement à ce que les nobles entendent parler de votre travail ici.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Très bien. Vous devez faire votre part, paysans !",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);

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
					Text = "Ce n\'est pas leur combat, lieutenant.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);

						if (this.Math.rand(1, 100) <= 50)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				},
				{
					Text = "Ce n\'est pas du tout notre combat.",
					function getResult( _event )
					{
						return "E";
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{Bien que ce ne soit pas votre combat et qu\'ils n\'aient presque rien à voir avec vous, vous ne pouvez pas vous empêcher de penser que de la bonne volonté avec les nobles portera ses fruits à l\'avenir. Dans cet esprit, vous ordonnez à vos hommes de commencer à rassembler les paysans, en séparant les jeunes des vieux et les faibles des forts. Étant donné que vos hommes ont l\'air de n\'avoir aucune inhibition à abattre les gens du commun, les gueux se conforment à vos ordres. Le lieutenant en cueille quelques-uns dans ce « lot » et les pousse sur la route. Il vous remercie grandement pour votre travail et vous affirme que les nobles entendront parler du %companyname%. | Dégainant votre épée, vous commandez aux paysans de se ranger du fort au faible. Vous jetez un coup d\'oeil au lieutenant.%SPEECH_ON%Femmes?%SPEECH_OFF%Il secoue la tête. Vous revenez dans la foule.%SPEECH_ON%Hommes uniquement ! Du plus fort au plus faible. Allez-y.%SPEECH_OFF%Avec des grognements épars et des pleurs insignifiants, les gens obéissent. Le lieutenant vous informe que les nobles entendront parler de vos agissements ici.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Ravi d\'être utile.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A aidé à enrôler des paysans");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "A aidé à enrôler leur population");
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Ce n\'est pas votre guerre, mais vous pensez que gagner la faveur des nobles vous aidera sur la route. Vous ordonnez à vos hommes de commencer à séparer la foule, en séparant les plus forts des plus faibles. Mais les paysans ne coopèrent pas - une pierre passe en sifflant devant votre visage. %randombrother% charge dans la foule et poignarde l\'agresseur à travers la poitrine. Quelques paysans ripostent en sortant des fourches et des torches. Le reste de %companyname% sort les armes et, après quelques meurtres rapides, la foule se calme. Vous cherchez le lieutenant, mais lui et ses hommes sont introuvables. | Sortant votre épée, vous ordonnez au village de commencer à s\'aligner, du plus fort au plus faible. Au lieu de cela, un vieil homme les rassemble avec un discour anti-guerre inopportun. %randombrother% se dirige vers le fou et balance un coup de poing pour le faire taire et tomber dans la boue. Malheureusement, cela ne fait qu\'énerver davantage la foule et une grande mêlée éclate. Vos mercenaires sont sans pitié, abattant quiconque ose s\'opposer à la compagnie. Une fois que tout est dit et fait, il y a des morts et des mourants dans la boue, tous soignés par des femmes aux visages confus et attristés, et le lieutenant et ses soldats sont toujours introuvables.}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "C\'est rapidement partie en vrilles",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "A tué leur population");
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
					{
						candidates.push(bro);
					}
				}

				local numInjured = this.Math.min(candidates.len(), this.Math.rand(1, 3));

				for( local i = 0; i < numInjured; i = ++i )
				{
					local idx = this.Math.rand(0, candidates.len() - 1);
					local bro = candidates[idx];
					candidates.remove(idx);

					if (this.Math.rand(1, 100) <= 50)
					{
						local injury = bro.addInjury(this.Const.Injury.Brawl);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " souffre " + injury.getNameOnly()
						});
					}
					else
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " souffre de blessures légères"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Vous vous tournez vers le lieutenant.%SPEECH_ON%Ce n\'est pas notre combat, et si vous n\'arrivez pas à convaincre quelques hommes bien de se battre pour vous, ce n\'est peut-être pas votre combat non plus. Rentrez chez vous.%SPEECH_OFF%Le lieutenant ferme son armure et se redresse.%SPEECH_ON%Avec ou sans vous, ils viennent avec nous.%SPEECH_OFF%Au moment où il termine, une pierre lui frappe la tête, le faisant perdre connaissance. Deux de ses soldats se précipitent à ses côtés et commencent à l\'éloigner. L\'un d\'entre eux vous crache.%SPEECH_ON%Ne pensez pas que nous l\'oublierons.%SPEECH_OFF%Vous faites un signe de tête au lieutenant.%SPEECH_ON%Oui, vous feriez mieux de vous en souvenir, car il ne le fera certainement pas.% SPEECH_OFF% | Le lieutenant croise les bras comme pour dire « bien ? ». Vous secouez la tête.%SPEECH_ON%Cherchez quelqu\'un d\'autre pour matter les paysans. Si vous ne pouvez pas le faire vous-même, peut-être que votre camp n\'est pas assez en forme pour gagner en premier lieu ?%SPEECH_OFF%Il souffle et s\'avance, cognant sa poitrine avec la vôtre. Quelques paysans s\'approchent de toutes parts, soudain armés de fourches et de faux. Le lieutenant jette un coup d\'oeil à vos renforts inattendus, puis à vous. Il se calme.%SPEECH_ON%Très bien, je suppose que je n\'ai pas le choix. Les nobles entendront parler de vos fautes ici, mercenaire.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Allez vous faire foutre",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "A empêcher leurs hommes d\'enrôler des paysans");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationFavor, "A sauvé leur population de la conscription");
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Vous dites au lieutenant que vous ne prendrez aucune part à sa campagne de recrutement qui s\'est révélée infructueuse. Il hoche la tête et sort son épée, ses hommes lui emboîtant le pas.%SPEECH_ON%Très bien alors, si on ne prend pas ces connards par la main, on les prendra par le cou. Quiconque nie le droit d\'appel des seigneurs meurt ici aujourd\'hui.%SPEECH_OFF%La foule recule avec un froissement de pauvres vêtements et de timides murmures. %randombrother% vous jette un coup d\'oeil.%SPEECH_ON%Monsieur, devrions-nous faire quelque chose ? Ce paon là-bas va faire tuer beaucoup de gens à cause de sa fierté.%SPEECH_OFF% | Le lieutenant tape le sol de sa botte.%SPEECH_ON%Eh bien, vas-tu m\'aider ou pas ?%SPEECH_OFF%Tu regardes la foule, pieds nus et en haillons, bien que quelques hommes forts se tiennent parmi les faibles, comme des arbres à côté d\'une clôture frêle. Retournant au lieutenant, vous secouez de la tête un non. Il hausse les épaules.%SPEECH_ON%Très bien messieurs. Nous ne reviendrons sûrement pas sans eux. Nous repartirons avec leurs têtes s\'il le faut !%SPEECH_OFF%L\'homme tire son épée et les soldats emboîtent le pas. La foule se cabre comme un nuage de mouches chassées. %randombrother% vient à vos côtés.%SPEECH_ON%Faut-il faire quelque chose ? Ces idiots sont en infériorité numérique, mais ils feront sans aucun doute tuer beaucoup de gens en s\'entêtant vers leur mort débile.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "On reste en dehors de ça.",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "Nous aidons les bannerets !",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Nous aidons les paysans !",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_02.png[/img]La guerre des nobles n\'était pas votre combat. Vous disputer avec les paysans n\'était pas votre combat. Et empêcher les soldats de massacrer des civils n\'est pas votre combat non plus. Vous dites aux frères de se tenir à l\'écart.\n\n Comme on pouvait s\'y attendre, les soldats chargent dans la foule, les épées balançent, les massues frappent. Quelques civils meurent, n\'ayant rien pour arrêter l\'assaut, mais le grand nombre de paysans submerge rapidement le lieutenant et ses hommes. Un duo d\'enfants pousse la cheminée d\'une masure et la pluie de pierres écrase un soldat dans la boue. Alors que le reste des soldats s\'arrête, un fermier accoure et en empale un avec une fourche et le soulève vers le ciel comme s\'il était une botte de foin. Le lieutenant panique et s\'enfuit, mais il  trébuche et deux femmes s\'abattent sur lui avec des couteaux à cisailler.\n\n Après le combat, de nombreux villageois et tout les soldat sont morts. Victorieux, les citadins traînent les bannerets dans les arbres et suspendent leurs corps pour une nouvelle mutilation. Vos mercenaires vous remercient de ne pas vous impliquer inutilement.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Bien. Partons.",
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
			ID = "G",
			Text = "[img]gfx/ui/events/event_94.png[/img]Il y a un choix à faire ici - se tenir avec les roturiers impuissants, ou aller avec les ambassadeurs violents de ceux qui exercent le pouvoir comme le gobelet d\'une fille ivre. Des deux, vous pensez que le dernier pourrait servir un objectif plus important à l\'avenir. Vous ordonnez à %companyname% de se tenir aux côtés des soldats. C\'est une bataille rapide, qui se termine par la fuite des paysans à travers les champs et des femmes suppliant pour que les blessés ne soient pas exécutés. Leurs supplications ne sont pas entendues.\n\n En nettoyant sa lame, le lieutenant vous remercie de l\'avoir sauvé, lui et ses hommes.%SPEECH_ON%Ce n\'était pas la décision la plus intelligente que j\'aurais pu prendre, mais je vous remercie d\'être intervenu pour nous aider. Ça faisait longtemps que je n\'avais pas passé une bonne journée à tuer. Merci, mercenaire. Les nobles entendront parler de vos actes ici.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Ravi d\'être utile.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A aidé leurs hommes à enrôler des paysans");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "A tué leur population");
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
					{
						candidates.push(bro);
					}
				}

				local numInjured = this.Math.min(candidates.len(), this.Math.rand(1, 3));

				for( local i = 0; i < numInjured; i = ++i )
				{
					local idx = this.Math.rand(0, candidates.len() - 1);
					local bro = candidates[idx];
					candidates.remove(idx);

					if (this.Math.rand(1, 100) <= 50)
					{
						local injury = bro.addInjury(this.Const.Injury.Brawl);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " souffre " + injury.getNameOnly()
						});
					}
					else
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " souffre de blessures légères"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_87.png[/img]Ah, les roturiers impuissants se dressant contre la botte de la noblesse amorale. Tu es avec le plus pauvre des deux connards. Dès que les soldats se heurtent aux paysans, vous ordonnez au %compagnyname% de fondre derrière les bannerets et d\'attaquer. Chaque soldat est rapidement poignardé dans le dos. Vous vous occupez du lieutenant vous-même, en lui plantant un poignard dans le cou. Il se retourne, serrant sa blessure mortelle dans une tentative de réparer l\'irréparable. En te voyant, ses yeux s\'écarquillent et s\'embrouillent, comme s\'il ne s\'était jamais attendu à ce qu\'un mercenaire le trahisse. Il crache une bouffée de cramoisi puis tombe à genoux et en arrière dans la boue.\n\n Un vieil homme s\'approche lentement pendant que vous nettoyez votre lame. Il vous remercie d\'avoir sauvé le village, si petit soit-il, et promet de faire connaître votre - apparemment - réputation de \"saint\".",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Avons-nous fait le bien ici?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationAttacked, "A tué certains de leurs hommes");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationFavor, "A sauvé leur population de la conscription");
				this.World.Assets.addMoralReputation(4);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 1)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d < bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance > 3)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Town = bestTown;
		this.m.Score = 25;
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
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Town = null;
	}

});


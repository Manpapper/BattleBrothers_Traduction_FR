this.discover_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Location = null,
		LastHelpTime = 0.0
	},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(75, 105) * 0.01;
		this.m.Type = "contract.discover_location";
		this.m.Name = "Trouver Location";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		this.contract.start();
	}

	function setup()
	{
		local locations = clone this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
		locations.extend(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements());
		local lowestDistance = 9000;
		local best;
		local myTile = this.m.Home.getTile();

		foreach( b in locations )
		{
			if (b.isLocationType(this.Const.World.LocationType.Unique))
			{
				continue;
			}

			if (b.isDiscovered())
			{
				continue;
			}

			local region = this.World.State.getRegion(b.getTile().Region);

			if (!region.Center.IsDiscovered)
			{
				continue;
			}

			if (region.Discovered < 0.25)
			{
				this.World.State.updateRegionDiscovery(region);
			}

			if (region.Discovered < 0.25)
			{
				continue;
			}

			local d = myTile.getDistanceTo(b.getTile());

			if (d > 20)
			{
				continue;
			}

			if (d + this.Math.rand(0, 5) < lowestDistance)
			{
				lowestDistance = d;
				best = b;
			}
		}

		if (best == null)
		{
			this.m.IsValid = false;
			return;
		}

		this.m.Location = this.WeakTableRef(best);
		this.m.Flags.set("Region", this.World.State.getTileRegion(this.m.Location.getTile()).Name);
		this.m.Flags.set("Location", this.m.Location.getName());
		this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		this.m.Payment.Pool = this.Math.max(300, 100 + (this.World.Assets.isExplorationMode() ? 100 : 0) + lowestDistance * 15.0 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentLightMult());

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * (this.Math.rand(110, 150) * 0.01)));
		this.m.Flags.set("HintBribe", this.beautifyNumber(this.m.Payment.Pool * 0.1));
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Trouvez %location% %distance% %direction% et quelque part autour de la r??gion de %region%"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 15)
				{
					this.Flags.set("IsAnotherParty", true);
					this.Flags.set("IsShowingAnotherParty", true);
				}

				this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(10, 40);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Trouvez %location% %direction% et aux alentours de la r??gion de %region%"
				];

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Flags.get("IsShowingAnotherParty"))
				{
					this.Flags.set("IsShowingAnotherParty", false);
					this.Contract.setScreen("AnotherParty1");
					this.World.Contracts.showActiveContract();
				}

				if (this.TempFlags.get("IsDialogTriggered"))
				{
					return;
				}

				if (this.Contract.m.Location.isDiscovered())
				{
					if (this.Flags.get("IsTrap"))
					{
						this.TempFlags.set("IsDialogTriggered", true);
						this.Contract.setScreen("Trap");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("FoundIt");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);

					foreach( party in parties )
					{
						if (!party.isAlliedWithPlayer)
						{
							return;
						}
					}

					if (this.Time.getVirtualTimeF() >= this.Contract.m.LastHelpTime + 70.0)
					{
						this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(0, 30);
						local r = this.Math.rand(1, 100);

						if (r <= 50)
						{
							this.Contract.setScreen("SurprisingHelpAltruists");
						}
						else
						{
							this.Contract.setScreen("SurprisingHelpOpportunists1");
						}

						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "DiscoverLocation")
				{
					this.Contract.setState("Return");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "DiscoverLocation")
				{
					this.Contract.setState("Return");
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez ?? " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = false;
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsAnotherParty"))
					{
						this.Contract.setScreen("AnotherParty2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "N??gociations",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% regarde une carte mal dessin??e, puis vous regarde comme si c\'??tait vous qui l\'aviez faite.%SPEECH_ON%Ecoutez, mercenaire, c\'est une t??che ??trange pour vous, mais vous semblez avoir la t??te sur les ??paules. Vous voyez cette tache sombre ici ? Seriez-vous pr??t ?? vous aventurer dans cette direction et ?? essayer de trouver %location%? C\'est quelque part ?? ou aux autours de la r??gion de %region%.%SPEECH_OFF% | Vous entrez dans le bureau de %employer% et il vous met une carte sous le nez.%SPEECH_ON%{Mercenaire ! Il est temps pour vous de partir en exploration ! Vous voyez cet endroit inexplor??, %direction% d\'ici dans la r??gion de %region%? C\'est l?? que j\'ai besoin que vous alliez ?? la recherche de %location%. Acceptez-vous ou non ? | D\'accord, ??a peut sembler ??trange, mais j\'ai besoin qu\'un endroit du nom de  %location% soit localis?? et cartographi??. Nos cartes sont incompl??tes en ce qui concerne cet endroit qui, au mieux, j\'esp??re se trouve aux alentours de la r??gion de %region% %direction% d\'ici. Partez, trouvez-la et revenez avec les coordonn??es et vous serez r??compens?? comme il se doit. | Il y a des parties de ce monde que l\'homme n\'a pas encore d??couverts et inscrits sur ses cartes. Je cherche %location% %direction% d\'ici ?? ou aux alentours de la r??gion de %region%. C\'est ?? peu pr??s tout ce que j\'en sais, mais je sais que ??a existe. Alors allez le trouver pour moi et vous serez r??compens?? comme il se doit. | J\'ai besoin qu\'on me trouve un endroit, mercenaire. Elle se trouve %direction% d\'ici, dans la r??gion de %r??gion% ou dans sa proximit??. Les profanes l\'appellent %location%, mais quoi que ce soit, je dois savoir o?? c\'est, compris ? Trouvez-la et vous serez pay?? g??n??reusement. | J\'ai besoin d\'un soldat explorateur et d\'un mercenaire, et je pense que vous ??tes l\'homme id??al pour ??tre les deux ?? la fois. Maintenant, avant que vous ne m\'accusiez d\'??tre radin en n\'engageant pas les deux vocations, disons simplement que j\'ai beaucoup de couronnes ?? vous faire gagner en faisant cela pour moi. Qu\'est-ce que c\'est, hm ? Eh bien, je connais un endroit qui s\'appelle %location%, mais je ne sais pas o?? il se trouve, sinon qu\'il se trouve %direction% d\'ici, dans la bande de terre appel??e %r??gion%. Trouvez-la, dessinez son emplacement sur la carte, et vous recevrez la paie d\'un soldat et d\'un explorateur !}%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combien ??a paie? | Pour le bon prix, nous le trouverons.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas int??ress??. | Nos voyages ne nous menerons pas l??-bas avant un moment. | Ce n\'est pas le type de travail que nous recherchons.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "FoundIt",
			Title = "?? %location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Vous voyez %location% dans le verre de votre lunette et vous la marquez sur vos cartes. C\'??tait assez facile. Il est temps de retournez aupr??s de %employer%. | Eh bien, il est d??j?? temps de retourner aupr??s de %employer% car %location% a ??t?? plus facile ?? trouver que vous ne le pensiez. En le marquant sur votre carte, vous vous arr??tez, riez et secouez la t??te. Quelle chance. |  %location% appara??t et il rena??t imm??diatement sur votre carte au mieux de vos capacit??s d\'illustration. %randombrother% demande si c\'est tout ce qu\'il y avait ?? faire. Vous acquiescez. Que ce soit difficile ou facile, %employer% vous attendra pour vous payer.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il est temps de rentrer.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Trap",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]%location% a ??t?? rep??r?? - et %companyname% aussi. Le pr??tendu \"altruiste\" qui vous a indiqu?? le chemin est toujours l??, sauf qu\'il est maintenant accompagn?? d\'une bande d\'hommes rustiques et peu amicaux.%SPEECH_ON%{Eh bien, on dirait que vous pouvez suivre des directions apr??s tout. Monter une embuscade est assez facile quand vous dites ?? l\'idiot o?? vous rencontrer. Quoi qu\'il en soit, tuez-les tous ! | Salut, mercenaire. C\'est ??trange de vous voir ici. Oh attendez, non ??a ne l\'est pas. Tuez-les tous ! | Bon sang, vous en avez mis du temps ! Quoi, vous ne pouvez pas suivre de simples instructions sur la fa??on de marcher dans vos propres tombes ? Stupide, mercenaire, et f??cheusement stupide. Eh bien, finissons-en. Tuez-les tous.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux Armes!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "DiscoverLocation";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SurprisingHelpAltruists",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Un homme s\'approche en agitant la main de mani??re plut??t amicale. Vous r??pondez en d??gainant votre ??p??e ?? moiti??. Il rit.%SPEECH_ON%Beaucoup s\'int??ressent ?? %location%, je ne peux donc pas vous reprocher d\'??tre sur la d??fensive. ??coutez, je vais vous dire exactement o?? c\'est. A %distance% en direction %direction% d\'ici, %terrain%.%SPEECH_OFF%Il s\'en va en riant aux ??clats.%SPEECH_ON%Je ne sais pas si j\'ai fait du bien ou du mal, et c\'est justement le genre d\'amusement que j\'aime !%SPEECH_OFF% | Un groupe d\'explorateurs fatigu??s du monde ! Ils s\'immobilisent au milieu de la route, ?? moiti?? couverts de boue, ?? moiti?? couverts de feuilles et tous en camouflage non voulu. L\'un d\'eux se frotte le front et vous regarde attentivement avant d\'??largir son sourire.%SPEECH_ON%Eh, je sais reconna??tre un chercheur quand j\'en vois un. Vous cherchez %location%, n\'est-ce pas ? Eh bien, vous avez de la chance, nous venons juste de l??-b??s ! Donnez-moi votre carte et je vous montrerai o?? c\'est. Vous voyez, %terrain% %distance%  %direction% d\'o?? nous sommes actuellement.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous appr??cions beaucoup.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 20 && this.Contract.getDifficultyMult() > 0.95)
						{
							this.Flags.set("IsTrap", true);
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SurprisingHelpOpportunists1",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{L\'??tranger est un homme seul qui garde ses distances, un pied sur le chemin, l\'autre vers la fuite.%SPEECH_ON%Hey there.%SPEECH_OFF%Il jette un coup d\'??il ?? vos hommes, souriant lentement comme s\'il pouvait sentir que nous sommes perdus.%SPEECH_ON%Vous cherchez %location%, c\'est ??a ? Hmm, ouais. Je vais vous dire, donnez-moi %hint_bribe% couronnes et je vous dirai exactement o?? c\'est ! Venez apr??s moi avec vos ??p??es et je serai parti avant que vous ne puissiez cligner des yeux !%SPEECH_OFF% | Vous observez l\'??tranger qui entre dans la lumi??re du chemin, en se prot??geant les yeux de mani??re ?? cacher une grande partie de son visage.%SPEECH_ON%Vous avez l\'air d\'??tre ?? la recherche de quelque chose, mais vous ne savez pas o?? c\'est ! %location% est compliqu??e comme ??a. Heureusement que je sais o?? c\'est. Heureusement, vous pouvez aussi savoir o?? il se trouve en glissant %hint_bribe% couronnes vers moi. Je suis le coureur le plus rapide que vous ayez jamais vu, alors n\'essayez pas de me soutirer des informations avec une de ces ??p??es brillantes que vous avez.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bien, voici les couronnes. Maintenant, parlez.",
					function getResult()
					{
						return "SurprisingHelpOpportunists2";
					}

				},
				{
					Text = "Pas besoin, nous le trouverons par nous-m??mes.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SurprisingHelpOpportunists2",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_76.png[/img]Vous acceptez l\'offre de l\'homme et il vous donne les d??tails comme promis.%SPEECH_ON%Vous voyez, c\'est l??, bien s??r, %terrain% %distance%  %direction% d\'o?? nous sommes actuellement. Facile.%SPEECH_OFF%Il siffle en partant, sans doute un jour de paie tr??s facile pour lui.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "J\'ai compris.",
					function getResult()
					{
						this.World.Assets.addMoney(-this.Flags.get("HintBribe"));
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("HintBribe") + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "AnotherParty1",
			Title = "?? %townname%",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Alors que vous et %companyname% pr??parez votre voyage, %randombrother% d??clare qu\'il y a un homme qui souhaite vous parler directement. Vous acquiescez et le faites conduire jusqu\'?? vous. C\'est un petit homme maussade qui affirme que les \"dirigeants\" de %townname% n\'ont aucun int??r??t pour %townname% autre que celui de la cupidit??. Bien s??r que c\'est le cas, alors quel est le probl??me ? L\'homme acquiesce.%SPEECH_ON%??coutez, j\'ai des gens qui veulent garder %location% cach?? pour de bon. Si vous le trouvez, eh bien, parlez m\'en d\'abord. Nous vous r??compenserons avec un joli paquet de fric.%SPEECH_OFF% | Pendant que %companyname% pr??pare son voyage pour trouver %location%, un homme s\'approche de vous. Il vous remet une note et s\'en va sans dire un mot. Le parchemin se lit comme suit : LAISSER LE %location% O?? IL EST. SI VOUS LE TROUVEZ, PARLEZ-NOUS EN. NOS COURONNES POUR VOTRE SILENCE. LES R??GENTS DE %townname% NE DOIVENT RIEN SAVOIR ! | Un homme s\'approche de la compagnie. Derri??re lui, on aper??oit deux familles pauvres qui le regardent. Vous n\'??tes pas s??r qu\'il soit leur ambassadeur ou non, mais dans tous les cas, il vient vers vous avec une proposition prononc??e ?? voix basse et calme.%SPEECH_ON%??coute, mercenaire. Si vous sortez et trouvez %location%, venez nous voir d\'abord. Les dirigeants de %townname% n\'ont pas besoin d\'apporter leur avidit?? et leur soif de pouvoir ?? cet endroit. Laissez-nous faire, d\'accord ? Nous vous paierons bien.%SPEECH_OFF%Avant que vous ne puissiez dire un mot, il se redresse et continue. Quand vous regardez en arri??re sur la route, ces familles ne sont plus l??.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je vais y r??fl??chir.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AnotherParty2",
			Title = "?? votre retour...",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Alors que vous vous dirigez vers %townname%, un ??tranger s\'avance sur le chemin. C\'est l\'homme ?? qui vous avez parl?? auparavant, mais cette fois, il a une sacoche ?? la main.%SPEECH_ON%{Vous n\'avez aucune raison de dire aux dirigeants de cette ville o?? se trouve %location%. Laissez-nous ses secrets, vous n\'avez aucune id??e des h??ritages et de l\'histoire que nous avons l??. Pour votre silence, nous sommes pr??ts ?? vous donner ceci comme paiement, %bribe% couronnes. S\'il vous pla??t, monsieur, acceptez. | Ecoutez, mercenaire, je sais que vous ne parlez qu\'une seule langue et c\'est celle de l\'argent. Prenez cette sacoche en gage de notre reconnaissance, si vous restez silencieux. Vous n\'avez pas besoin de dire aux dirigeants de %townname% o?? se trouve %location%. Cet endroit appartient ?? nos familles. Ces dirigeants mesquins ne feront que le ruiner avec leur cupidit?? et leur recherche du pouvoir. Alors, qu\'en dites-vous, vous prenez ??a ? Il y a %bribe% couronnes l??-dedans. Tout ce que vous devez faire est de le prendre et de ne pas parler.}%SPEECH_OFF% | En entrant dans %townname%, vous ??tes dirig?? par un visage familier : l\'homme qui vous avait salu?? juste avant votre d??part. Mais cette fois, il a une sacoche avec lui.%SPEECH_ON%{%bribe% couronnes pour votre silence. Ne dites absolument rien aux dirigeants de cette ville et elle est ?? vous. Ils n\'ont pas besoin de conna??tre notre accord, ils n\'ont juste pas besoin de savoir o?? se trouve cet endroit. C\'est important pour nous, avec une histoire sans commune mesure, et tout ce qu\'ils feront, c\'est le piller. S\'il vous pla??t, acceptez. | Prends ??a, il y a %bribe% couronnes. C\'est la somme que nous sommes pr??ts ?? vous donner pour votre silence. Les dirigeants de %townname% vont prendre vos informations et les utiliser pour piller %location%, parce qu\'ils connaissent nos propres relations familiales avec elle et, eh bien, nous sommes depuis longtemps tomb??s en disgr??ce. Il nous reste peu de choses, alors, s\'il vous pla??t, laissez-nous garder nos h??ritages et notre vieille maison.}%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je ne pense pas. Seul notre employeur saura o?? il se trouve.",
					function getResult()
					{
						return "AnotherParty3";
					}

				},
				{
					Text = "Nous avons un accord. Vous et personne d\'autre ne saura o?? il se trouve.",
					function getResult()
					{
						return "AnotherParty4";
					}

				},
				{
					Text = "Pourquoi ??tre pay?? une seule fois si l\'on peut ??tre pay?? deux fois ?",
					function getResult()
					{
						return "AnotherParty5";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AnotherParty3",
			Title = "?? votre retour...",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Apr??s avoir dit non ?? l\'homme, il tombe ?? genoux et pleure, au grand amusement de %companyname%. Il se lamente sur la fa??on dont vous avez laiss?? le pass?? historique de sa famille entre les mains de profiteurs et d\'usuriers. Vous lui dites que vous vous en fichez. | Dire ?? l\'homme que vous n\'avez aucun int??r??t ?? trahir votre employeur d\'origine l\'??nerve. Il tente de vous attaquer, s\'??lan??ant en avant pour se coller ?? vous avec des mains en col??re. %randombrother% le repousse et menace de le tuer avec une lame. L\'homme recule. Il s\'assied au bord du chemin, la t??te entre les genoux, en sanglotant. Un des hommes lui donne un mouchoir en passant. | Vous dites non ?? l\'homme. Il supplie. Vous lui dites non ?? nouveau. Il supplie encore. Vous r??alisez soudain que vous avez d??j?? fait ??a avec une ou deux femmes. Ce n\'est vraiment pas un bon signe. Vous le lui dites, mais l\'??motion du moment est trop forte pour lui. Il se met ?? g??mir, expliquant que le nom de sa famille va ??tre ruin?? par les salauds cupides qui dirigent %townname%. Vous lui dites que le nom de sa pr??tendue famille serait ??pargn?? si, peut-??tre, c\'??tait lui qui dirigeait cette ville. Cela ne dissipe pas ses larmes.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Hors du chemin.",
					function getResult()
					{
						return "Success1";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AnotherParty4",
			Title = "?? votre retour...",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Vous acceptez de vendre ?? l\'homme les d??tails de votre exp??dition. Il est tr??s heureux de l\'affaire, mais %employer% ne l\'est pas. Apparemment, un petit enfant a vu cet ??change et a rapport?? votre trahison au chef de %townname%. Votre r??putation ici a, sans doute, ??t?? un peu entach??e. | D\'un c??t??, vous avez ??pargn?? la suppos??e maison familiale de cet homme d\'??tre d??truite par les mains de ceux qui dirigent %townname%. D\'autre part, ceux qui dirigent %townname% ont rapidement entendu parler de ce que vous aviez fait. Vous auriez d?? pr??ter plus d\'attention ?? la population d\'une petite ville pour qu\'elle se transforme en rumeurs extraordinaires.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Eh bien, %employer% aurait d?? juste nous payer plus.",
					function getResult()
					{
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "A vendu l\'emplacement de " + this.Flags.get("Location") + " ?? un autre groupe");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "AnotherParty5",
			Title = "?? votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]Vous dites ?? l\'homme que vous garderez secret l\'emplacement de sa maison familiale. Pendant qu\'il fait la f??te, vous allez dire ?? %employer% o?? se trouve %location%. ??tre pay?? par les deux parties, c\'est un bon boulot. S\'attirer la haine des deux, pas vraiment, mais ?? quoi s\'attendaient-ils en traitant avec un mercenaire ?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ces gens n\'apprendront jamais.",
					function getResult()
					{
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 1.5, "Donner des informations ?? un concurrent");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "?? votre retour...",
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% vous souhaite la bienvenue. Vous lui tendez votre carte r??cemment illustr??e et il la parcourt, en effa??ant la tache du revers de sa main.%SPEECH_ON%Bien s??r, c\'est l?? qu\'il est !%SPEECH_OFF%Il sourit et vous paie ce qui vous est d??. | Vous arrivez dans le bureau de %employer%, une carte ?? la main. Il vous la prend et l\'examine.%SPEECH_ON%Bon, alors. On pourrait penser que c\'est un peu trop facile, mais un accord est un accord.%SPEECH_OFF%Il vous tend une sacoche charg??e de ce qui vous est d??. | Vous vous pr??sentez ?? %employer%, lui indiquant l\'emplacement de %location%. Il acquiesce et gribouille, copiant les notes de votre carte. Curieux, vous lui demandez comment il sait que vous ne mentez pas. L\'homme s\'assoit sur une chaise et se penche en arri??re, en mettant ses mains sur son ventre.%SPEECH_ON%J\'ai investi dans un traqueur qui est rest?? proche de votre compagnie. Il est arriv?? ici avant vous et vous n\'avez fait que confirmer ce que je savais d??j??. J\'esp??re que les mesures prises ne vous d??rangent pas.%SPEECH_OFF%En hochant la t??te, vous pensez que c\'est une sage d??cision, vous prenez votre paie et vous partez.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien m??rit??es.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Engag?? pour trouver  " + this.Flags.get("Location"));
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local distance = this.m.Location != null && !this.m.Location.isNull() ? this.World.State.getPlayer().getTile().getDistanceTo(this.m.Location.getTile()) : 0;
		distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
		_vars.push([
			"region",
			this.m.Flags.get("Region")
		]);
		_vars.push([
			"location",
			this.m.Flags.get("Location")
		]);
		_vars.push([
			"locationC",
			this.m.Flags.get("Location").toupper()
		]);
		_vars.push([
			"townnameC",
			this.m.Home.getName().toupper()
		]);
		_vars.push([
			"direction",
			this.m.Location == null || this.m.Location.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Location.getTile())]
		]);
		_vars.push([
			"terrain",
			this.m.Location != null && !this.m.Location.isNull() ? this.Const.Strings.Terrain[this.m.Location.getTile().Type] : ""
		]);
		_vars.push([
			"distance",
			distance
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
		_vars.push([
			"hint_bribe",
			this.m.Flags.get("HintBribe")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Location == null || this.m.Location.isNull() || !this.m.Location.isAlive() || this.m.Location.isDiscovered())
		{
			return false;
		}

		return true;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Location != null && !this.m.Location.isNull() && _tile.ID == this.m.Location.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		this.contract.onDeserialize(_in);
	}

});


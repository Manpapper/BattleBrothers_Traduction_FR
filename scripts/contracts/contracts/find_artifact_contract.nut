this.find_artifact_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.find_artifact";
		this.m.Name = "Expedition";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local myTile = this.World.State.getPlayer().getTile();
		local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
		local highestDistance = 0;
		local best;

		foreach( b in undead )
		{
			if (b.isLocationType(this.Const.World.LocationType.Unique))
			{
				continue;
			}

			local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 45);

			if (d > highestDistance)
			{
				highestDistance = d;
				best = b;
			}
		}

		this.m.Destination = this.WeakTableRef(best);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		local nemesisNames = [
			"the Raven",
			"the Fox",
			"the Bastard",
			"the Cat",
			"the Lion",
			"the General",
			"the Robber Baron",
			"the Rook"
		];
		local nemesisNamesC = [
			"The Raven",
			"The Fox",
			"The Bastard",
			"The Cat",
			"The Lion",
			"The General",
			"The Robber Baron",
			"The Rook"
		];
		local nemesisNamesS = [
			"Raven",
			"Fox",
			"Bastard",
			"Cat",
			"Lion",
			"General",
			"Robber Baron",
			"Rook"
		];
		local n = this.Math.rand(0, nemesisNames.len() - 1);
		this.m.Flags.set("NemesisName", nemesisNames[n]);
		this.m.Flags.set("NemesisNameC", nemesisNamesC[n]);
		this.m.Flags.set("NemesisNameS", nemesisNamesS[n]);
		this.m.Payment.Pool = 2000 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Score", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Récuperez l\'artefact provenant de %objective% %direction%"
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

				if (r <= 20)
				{
					this.Flags.set("IsLost", true);
				}

				r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					if (!this.Flags.get("IsLost"))
					{
						this.Flags.set("IsScavengerHunt", true);
					}
				}
				else if (r <= 25)
				{
					this.Flags.set("IsTrap", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsTooLate", true);
				}

				if (!this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.m.Destination.setLootScaleBasedOnResources(130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));

				if (!this.Flags.get("IsLost") && !this.Flags.get("IsTooLate"))
				{
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsTrap") && !this.Flags.get("IsTrapShown"))
					{
						this.Flags.set("IsTrapShown", true);
						this.Contract.setScreen("Trap");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsScavengerHunt") && !this.Flags.get("IsScavengerHuntShown"))
					{
						this.Flags.set("IsScavengerHuntShown", true);
						this.Contract.setScreen("ScavengerHunt");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("SearchingTheRuins");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsLost") && !this.Flags.get("IsLostShown") && this.Contract.isPlayerNear(this.Contract.m.Destination, 500))
				{
					this.Flags.set("IsLostShown", true);
					local brothers = this.World.getPlayerRoster().getAll();
					local hasHistorian = false;

					foreach( bro in brothers )
					{
						if (bro.getBackground().getID() == "background.historian")
						{
							hasHistorian = true;
							break;
						}
					}

					if (hasHistorian)
					{
						this.Contract.setScreen("AlmostLost");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Lost");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (!this.Flags.get("IsAttackDialogShown"))
				{
					this.Flags.set("IsAttackDialogShown", true);

					if (this.Flags.get("IsTooLate"))
					{
						this.Contract.setScreen("TooLate1");
					}
					else
					{
						this.Contract.setScreen("ApproachingTheRuins");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					_dest.m.IsShowingDefenders = true;
					this.World.Contracts.showCombatDialog();
				}
			}

		});
		this.m.States.push({
			ID = "Running_TooLate",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Rattrapez %nemesis% et récupérez l\'artefact"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithNemesis.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("TooLate3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithNemesis( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!this.TempFlags.get("IsAttackDialogWithNemesisShown"))
				{
					this.TempFlags.set("IsAttackDialogWithNemesisShown", true);
					this.Contract.setScreen("TooLate2");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.Music = this.Const.Music.NobleTracks;
					properties.Entities.push({
						ID = this.Const.EntityType.BanditLeader,
						Variant = 0,
						Row = 2,
						Script = "scripts/entity/tactical/enemies/bandit_leader",
						Faction = _dest.getFaction(),
						Callback = this.onNemesisPlaced.bindenv(this)
					});
					properties.EnemyBanners = [
						this.Const.PlayerBanners[this.Flags.get("NemesisBanner") - 1]
					];
					this.World.Contracts.startScriptedCombat(properties, true, true, true);
				}
			}

			function onNemesisPlaced( _entity, _tag )
			{
				_entity.setName(this.Flags.get("NemesisNameC"));
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
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
			Title = "Négociations",
			Text ="[img]gfx/ui/events/event_45.png[/img]{Vous trouvez %employer% en train d\'observer une pile de cartes, les triant avec les outils même qui ont servi à les dessiner au départ. Il relève la tête, une expression tendue de cartographe sur son visage.%SPEECH_ON%Mes scribes m\'ont remis ces cartes, me disant qu\'ils ont découvert un endroit nommé \'%objective%\'. On dit qu\'il renferme un pouvoir immense quelque part dans ses salles, ses couloirs, ou, euh, peu importe ce qui s\'y trouve.%SPEECH_OFF%Vous haussez un sourcil, mais l\'homme persiste.%SPEECH_ON%Regardez, mes scribes croient sincèrement que tout ce qui s\'y trouve pourrait nous aider à trouver une solution à cette menace morte-vivante. Mais ils m\'ont aussi dit que d\'autres le recherchent. J\'ai besoin que vous y alliez avant tout le monde.%SPEECH_OFF% | %employer% vous accueille en déroulant une carte, le papier s\'étendant de sa tête à ses pieds. Il entoure un endroit spécifique avec un doigt.%SPEECH_ON%Voyez-vous ceci ? C\'est appelé \'%objective%\'. Un endroit dont je... ne sais en fait pas grand-chose. Ce que je sais, c\'est que d\'autres s\'y rendent et qu\'apparemment, c\'est pour récupérer un artefact d\'un grand pouvoir. Mes scribes pensent que cet artefact pourrait nous aider à lutter contre la menace morte-vivante. Évidemment, j\'aimerais que vous y alliez et le récupériez avant tout le monde !%SPEECH_OFF% | %employer% vous présente une carte, en particulier un endroit spécifique dessus.%SPEECH_ON%Cela s\'appelle \'%objective%\'. Des rumeurs disent que d\'autres hommes le cherchent. Mes scribes, qui n\'apprécient pas les rumeurs, pensent qu\'il renferme un certain artefact que nous pourrions utiliser pour lutter contre la menace morte-vivante. Cette zone est située en profondeur dans un territoire hostile, et j\'ai des raisons de croire que vous ne serez pas le seul à le rechercher. Allez-y, ramenez l\'artefact, et je vous récompenserai généreusement.%SPEECH_OFF% | Lorsque vous rencontrez %employer%, il vous implore rapidement de vous rendre à ses côtés et de lire un livre. Vous voyez une langue qui, à votre connaissance, n\'a jamais existé, mais il y a aussi une carte sur les pages qui ne nécessite aucune traduction, en particulier l\'emplacement fortement entouré par une plume d\'oie. %employer% y tapote.%SPEECH_ON%Je besoin que tu y ailles, mercenaire. Ils l\'appellent \'%objective%\'. Mes scribes affirment qu\'il renferme un artefact d\'un grand pouvoir que nous pourrions utiliser pour lutter contre la menace morte-vivante. Bien sûr, un artefact comme celui-ci ne sera pas simplement exposé au grand jour. J\'espère vraiment toutes sortes d\'hommes et de créatures rôdant dans cette zone, attirés par le bourdonnement du pouvoir même de l\'artefact ! Vous devez le récupérer et le ramener.%SPEECH_OFF% | %employer% vous accueille et décrit rapidement un endroit appelé \'%objective%\', un endroit horrible qui se trouve %direction% d\'où vous êtes.%SPEECH_ON%Mes scribes affirment que cette zone renferme un artefact d\'un immense pouvoir qui pourrait nous aider à lutter contre la menace morte-vivante. Bien sûr, Voyou ! J\'ai eu... des nouvelles, qu\'un endroit %direction% d\'ici renferme un pouvoir immense dont nous avons besoin de nous emparer. Je pense que cela nous aidera à repousser le fléau des morts-vivants. Bien sûr, si cela a réellement le pouvoir de le faire, nous pouvons facilement supposer que d\'autres chercheront également cet objet ! Pour cette raison, la rapidité est d\'une importance capitale. Je veux que vous y alliez et reveniez.%SPEECH_OFF% | Vous trouvez %employer% en train de traverser son cimetière personnel. Il se tient devant une pierre tombale.%SPEECH_ON%Chaque nuit, je crains que ceux-ci ne commencent à bouger et que mes ancêtres se lèvent, venant me détruire pour mes échecs.%SPEECH_OFF%Il se tourne et vous regarde avec une grimace froide sur le visage. Sans parler, il vous emmène dans sa maison où un vieil homme parcourt des livres couvrant complètement son bureau. %employer% vous dit de parler à l\'homme, puis va se tenir près de la porte. Vous vous asseyez en face de l\'aîné qui pose son stylo.%SPEECH_ON%{Mon seigneur m\'a accordé l\'honneur de vous dire tout ce que vous devez savoir. J\'ai identifié un artefact de grande puissance situé %direction% d\'ici dans un endroit appelé \'%objective%\'. Je crois que cet artefact peut contenir le pouvoir de résoudre ce problème des morts qui... reviennent à la vie. Je crois aussi que le pouvoir de cette magnitude ne passe pas inaperçu dans ce monde. Vous devez y aller, repousser quiconque pense lui appartenir, et Retournez à nous. | Bienvenue, mercenaire. Il n\'est pas souvent que je fais appel à un homme de votre vocation pour résoudre mes problèmes. Un bon livre et une soirée tranquille suffisaient autrefois, mais plus maintenant. Nous avons besoin que vous voyagiez %direction% d\'ici vers un endroit appelé \'%objective%\'. Nous avons des raisons de croire qu\'il pourrait contenir la réponse à notre problème des morts qui marchent parmi nous. Bien sûr, un tel pouvoir est un appât puissant. Vous devez vous dépêcher d\'y aller et d\'en revenir, de peur que nous ne le perdions.}%SPEECH_OFF% | Un scribe se tient aux côtés de %employer%. Les deux hommes fixent une feuille de papier. En vous approchant, ils la poussent lentement de l\'autre côté de la table pour que vous puissiez la lire. Il semble que le scribe a localisé un endroit d\'un pouvoir immense et ils pensent qu\'il pourrait contenir la solution au fléau des morts-vivants. %employer% pense que beaucoup d\'autres le rechercheront également, et que la rapidité est d\'une importance capitale. | Vous trouvez %employer% en train de parler à un scribe, les deux hommes penchés sur un livre, une bougie vacillante entre eux. En vous entendant, le seigneur lève rapidement les yeux et explique la situation en cours : ils ont déchiffré l\'emplacement d\'un grand artefact, un artefact qui pourrait bien contenir la réponse aux morts qui marchent sur terre. %employer% hoche la tête avec diligence.%SPEECH_ON%Nous avons des raisons de croire que vous ne serez pas seul à le chercher, ni que là où il se trouve est l\'endroit le plus sûr pour commencer.%SPEECH_OFF% | %employer% prend une torche sur un brasero et vous emmène dans des cryptes. Vous regardez des statues spectrales émerger de l\'obscurité, la flamme du noble donnant vie aux ombres et aux silhouettes. Il s\'arrête devant l\'une d\'elles puis se retourne.%SPEECH_ON%Voici mon père. Écoutez attentivement.%SPEECH_OFF%Vous approchez votre oreille du sarcophage énorme et entendez un grattage faible à l\'intérieur. %employer% secoue la tête.%SPEECH_ON%Mes scribes ont déchiffré l\'emplacement d\'un prétendu grand artefact. Il se trouve %direction% d\'ici dans un endroit appelé \'%objective%\'. Il peut ou non contenir le pouvoir de mettre fin à cette folie. Bien sûr, un tel pouvoir n\'existe jamais discrètement dans ce monde. Nous nous attendons à ce que de nombreux autres, hommes ou autres, soient autour de l\'artefact. Allez-y, mercenaire, et rapportez-le-moi et vous serez récompensé.%SPEECH_OFF%Il agite la torche vers le cercueil qui émet un grognement étouffé.%SPEECH_ON%Pour notre bien et le leur.%SPEECH_OFF% | %employer% et son scribe vous emmènent dans les catacombes. Vous y trouvez un cercueil qui a été brisé ouvert. Deux gardes se tiennent avec des piques pour repousser une femme morte-vivante et décharnée qui attaque. Elle grogne et grince des dents, les dents claquant dans des cliquetis creux alors que la lumière de la flamme remplit ses formes maigres. %employer% se tourne vers vous.%SPEECH_ON%Nous ne savons pas ce que c\'est ni ce qui l\'a déclenché, mais nous pensons qu\'un endroit appelé \'%objective%\' qui se trouve %direction% d\'ici pourrait contenir la réponse. Un artefact d\'une certaine puissance est censé s\'y trouver et j\'ai besoin que vous le rameniez. Mon scribe dit que vous devriez vous préparer à des dangers inconnus.%SPEECH_OFF%La fille morte-vivante grogne et s\'avance, s\'empalant sur une lame et se poussant vers le bas. Le scribe acquiesce et %employer% continue.%SPEECH_ON%Si cela peut mettre fin à ce tourment, qui sait ce qu\'il pourrait encore faire.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Je fais confiance à ce que vous paierez généreusement pour un voyage aussi dangereux que celui-ci. | C\'est loin d\'ici, alors ça ferait mieux de bien payer.}",

					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | C\'est une trop longue marche. | Nous avons des affaires plus urgentes à régler. | On est demandé autre part.}",
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
			ID = "ApproachingTheRuins",
			Title = "À %objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Bien, les ruines. Voyons si %employer% et ses scribes idiots savent de quoi ils parlent. | Vous arrivez aux ruines. Il n\'y a pas grand-chose autour qui vous rende mal à l\'aise. Vous dites à %companyname% de se préparer au pire. | Enfin, vous arrivez à la prétendue demeure d\'un grand artefact. Il est temps de voir si %employer% et ses scribes savaient vraiment de quoi ils parlaient. | Les ruines penchent et se replient les unes sur les autres. Presque comme sur commande, un nuage de chauves-souris s\'envole en hurlant. %randombrother% se baisse et le reste des hommes rit. | Vous trouvez %objective% et vous tenez sur une colline adjacente. En regardant en bas, vous comprenez pourquoi elle était cachée si longtemps, l\'endroit étant dans un emplacement si anodin. Même d\'ici, vous pouvez entendre le vent se faufiler à travers ses œuvres de pierre. | Vous arrivez à %objective% et %randombrother% l\'évalue comme on pouvait s\'y attendre.%SPEECH_ON%Ça a l\'air nul à chier. Allons-y, d\'accord ?%SPEECH_OFF%Espérons qu\'il a raison. | %randombrother% se redresse.%SPEECH_ON%Bon sang, je pense que c\'est ça.%SPEECH_OFF%Il fixe un groupe de ruines qui semblent en effet être %objective%. Il applaudit et se frotte les mains.%SPEECH_ON%Allons-y. Je jure par fark, s\'il y a un liche là-dedans, je me plaindrai longtemps après ma mort.%SPEECH_OFF% | %randombrother% regarde %objective% qui se trouve au loin.%SPEECH_ON%Alors, qu\'est-ce que tu penses qu\'il y a là-bas ? Je pense que %employer% nous trompe. On va entrer et être accueillis par un tas de belles femmes. Une récompense pour nous, les hommes qui travaillent dur, tu sais ?%SPEECH_OFF%Pour une raison quelconque, vous ne pensez pas que ce sera le cas. | %objective% est à une courte distance. Vous ne pouvez voir que les œuvres de pierre inclinées d\'ici, mais une odeur persiste loin de l\'endroit. %randombrother% se couvre le nez.%SPEECH_ON%Ça sent comme les merdes de ma tante. Ça ne me surprendrait pas si cette sorcière était là-dedans aussi.%SPEECH_OFF% | En approchant %objective%, vous dites à vos hommes de se préparer au combat. Qui sait ce qui attend la %companyname% dans ces terres interdites! | En vous approchant %objective%, des murmures doux vous parviennent. La peur remplira votre cœur jusqu\'à ce qu\'il n\'y ait plus de place pour quoi que ce soit d\'autre. Et puis vous mourrez. C\'est ainsi, c\'est ainsi que ce sera. | Approche petit humain. C\'est là que j\'ai toujours voulu que tu sois. | Oui ! Tu es enfin venu ! C\'est tellement bon de te voir, humain, tellement bon de te voir ! | Ah, une autre bête cruelle s\'approche. Quelle petite chose stupide. Oui, très stupide. Que devrions-nous en faire ? Laissez-la entrer, bien sûr. Bien sûr !}%SPEECH_OFF%%randombrother% tourne un doigt dans son oreille.%SPEECH_ON%Avez-vous dit quelque chose, monsieur ?%SPEECH_OFF%Vous secouez la tête et dites rapidement aux hommes de se préparer à tout. | En vous approchant %objective%, des murmures doux vous parviennent.%SPEECH_ON%{Entrez. Entrez. C\'est pour le mieux. Vous allez aimer ici, oui, vous allez. Nous sommes d\'accord. Oui, nous le sommes. S\'il vous plaît, dépêchez-vous. Nous ne pouvons plus attendre ! | Vous n\'êtes pas le premier. Vous n\'êtes pas le premier. Vous ne serez pas le dernier. Vous ne serez pas le dernier. | Homme stupide, tu crois que tes pensées sont les tiennes ? | Vos hommes vous trahiront. Ils pensent que vous êtes inutile. Rebattez-vous, vous insecte pleurnichard. | Ici tu es. Ici tu seras pour toujours. | Ah, plus d\'humains. Je supporte à peine l\'odeur de vous dans cet état. Vous êtes un poison pour l\'air que je respire. Laissez-moi vous avoir. Je mettrai de la pourriture dans vos ventres et vous serez tellement mieux pour ça... | Un petit homme audacieux que vous êtes de venir ici, mais vous n\'êtes qu\'un simple spécimen. La peur remplira votre cœur jusqu\'à ce qu\'il n\'y ait plus de place pour rien d\'autre. Et puis vous mourrez. C\'est ainsi, c\'est ainsi que ce sera. | Approche petit humain. C\'est là que j\'ai toujours voulu que tu sois. | Oui ! Tu es enfin venu ! C\'est tellement bon de te voir, humain, tellement bon de te voir ! | Ah, une autre bête cruelle s\'approche. Quelle petite chose stupide. Oui, très stupide. Que devrions-nous en faire ? Laissez-la entrer, bien sûr. Bien sûr !}%SPEECH_OFF%%randombrother% tourne un doigt dans son oreille.%SPEECH_ON%Avez-vous dit quelque chose, monsieur ?%SPEECH_OFF%Vous secouez la tête et dites rapidement aux hommes de se préparer à tout.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Soyez sur vos gardes !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SearchingTheRuins",
			Title = "À %objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Enfin, vous avez l\'artefact. Son poids semble étrange dans vos mains, comme s\'il devait être lourd, mais quelque chose le maintient artificiellement léger. Vous le mettez dans un sac et vous préparez à retourner chez votre employeur, %employer%. | Vous avez maintenant l\'artefact que vous cherchiez. Pour être honnête, c\'est un peu décevant. Une partie de vous espérait qu\'il vous donnerait un pouvoir immense, mais au lieu de cela, il repose tranquillement dans vos mains. Peut-être que vous n\'étiez tout simplement pas l\'élu. | Vous prenez l\'artefact, ignorant le bourdonnement étouffé qu\'il émet, et vous vous préparez à Retournez à %employer%. | Vous prenez l\'artefact et le regardez attentivement. %randombrother% s\'approche et met ses poings sur ses hanches.%SPEECH_ON%Bon sang, cette chose laide n\'est pas si précieuse que ça.%SPEECH_OFF% | Vous pesez l\'artefact dans vos mains. Il devient léger puis lourd, puis léger à nouveau. Eh bien, c\'est assez étrange, alors vous le rangez rapidement dans une besace. | %randombrother% jette un coup d\'œil à l\'artefact avant que vous ne le rangiez.%SPEECH_ON%Ça ne ressemble pas à grand-chose.%SPEECH_OFF%Vous lui dites que beaucoup de choses puissantes ne semblent pas à grand-chose. Il s\'assied et réfléchit.%SPEECH_ON%Mes pets ne ressemblent à rien du tout, donc je suppose que tu as raison.%SPEECH_OFF% | Vous remettez l\'artefact à %randombrother%. Il le lève.%SPEECH_ON%Et si je le cassais ici et maintenant, ça te mettrait en colère ?%SPEECH_OFF%Vous fixez l\'homme.%SPEECH_ON%Ouais, un peu. Mais peut-être qu\'il y a de petits démons là-dedans qui te foutent en l\'air pour l\'éternité pour avoir cassé leur maison. Qui sait, non ?%SPEECH_OFF%Le mercenaire range rapidement l\'artefact dans une besace. | Vous regardez l\'artefact. Il est vierge et immobile, pas quelque chose que vous vous attendriez à contenir un grand pouvoir, mais pour une raison quelconque, c\'est la partie la plus inquiétante. Vous le mettez rapidement dans une besace. | Vous mettez l\'artefact dans une besace seulement pour qu\'il brille et vous appelle. En ouvrant le sac, vous regardez deux points rouges vous fixer. %randombrother% demande si vous allez bien. Vous refermez rapidement la besace et hochez la tête. | Vous avez enfin l\'artefact. Il ne brille pas, il ne bourdonne pas, il ne semble même pas très joli. Vous ne savez pas ce qui a tant fait parler, mais si %employer% veut vous payer pour ça, c\'est son problème. | Eh bien, vous avez l\'artefact. %randombrother% s\'approche, se grattant la tête.%SPEECH_ON%Alors, beaucoup de gens sont morts pour cette petite chose ?%SPEECH_OFF%L\'artefact tremble et une voix grognante répond.%SPEECH_ON%Ils ne sont pas morts. Ils sont avec moi maintenant et pour toujours.%SPEECH_OFF%Le mercenaire recule en arrière.%SPEECH_ON%Tu sais quoi ? Je n\'ai pas entendu ça. Je ne sais pas ce que c\'était. Ça m\'est égal. Non. Je vais juste retourner à manger du pain dur et rassis et vivre une vie ennuyeuse, merci beaucoup.%SPEECH_OFF% | Vous tenez l\'artefact, en utilisant un chiffon entre lui et vous au cas où ses pouvoirs s\'infiltreraient dans votre chair. Bien sûr, cela ressemble juste à un morceau de pierre fantaisie, mais il n\'y a pas de mal à être prudent. %employer% devrait être content de le voir et il peut le tenir comme il veut autant que vous êtes concerné. | L\'artefact a l\'air étrange, mais rien d\'extraordinaire. Pour tout ce que vous savez, c\'était le projet d\'un vagabond qu\'un autre a pris pour un objet divin. %randombrother% le fixe.%SPEECH_ON%J\'ai chié des choses plus jolies que ça, si je suis honnête.%SPEECH_OFF%Vous le prévenez que si ce relique a vraiment des pouvoirs, il paiera probablement pour ce commentaire. Il hausse les épaules.%SPEECH_ON%Ne change pas les faits cependant.%SPEECH_OFF% | Vous levez le relique et il devient soudain lourd, le ramenant vers le bas. Lorsque vous le baissez vers vos pieds, il devient plus léger, comme s\'il voulait être repris. C\'est assez étrange pour vous, alors vous le rangez rapidement et vous préparez un Retournez à %employer% à %townname%. | Enfin, vous avez l\'artefact. Vous le regardez quand %randombrother% s\'approche.%SPEECH_ON%Alors, c\'est ce que %employer% veut ? Bon sang, j\'aurais pu fabriquer quelque chose comme ça et nous aurait épargné tout ce tracas.%SPEECH_OFF%Vous rangez l\'artefact dans un sac et répondez.%SPEECH_ON%Je pense qu\'il aurait fini par savoir que c\'était un faux.%SPEECH_OFF%Le mercenaire lève le doigt.%SPEECH_ON%Mot-clé : finalement.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous avons ce pour quoi nous sommes venus ici. Il est temps de rentrer !",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "AlmostLost",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_42.png[/img]{En marchant, %historian% l\'historien vous voit fixer la carte. Il demande à y jeter un œil, ce que vous autorisez. L\'homme le tient, puis le rapproche.%SPEECH_ON%Nous allons dans la mauvaise direction. Les scribes de %employer% ont dû mal interpréter cela. Voyez ce symbole ? En fait, cela signifie...%SPEECH_OFF%Il s\'interrompt, voyant que ce qu\'il est sur le point de dire ne vous fera pas de sens. Il rit.%SPEECH_ON%D\'accord, en gros, nous devons aller par ici.%SPEECH_OFF%Il sort une plume et fait une correction. | %historian% l\'historien regarde l\'une des cartes que %employer% vous a données. Il s\'arrête et demande.%SPEECH_ON%Vous avez dit que les scribes du noble ont créé cette carte ? Parce que c\'est tout faux. Regardez.%SPEECH_OFF%Il vous le montre.%SPEECH_ON%Ils ont mal interprété les langues. Ce n\'est pas un alphabet, mais des symboles de foi. Ce ne sont pas des mots, mais des énigmes. Et si vous les interprétez correctement, ils vous mènent ici.%SPEECH_OFF%Il pointe vers un endroit complètement différent de celui où vous vous dirigiez. Il semble que la %companyname% doit corriger sa trajectoire. | %historian% l\'historien secoue la tête en examinant une carte.%SPEECH_ON%Monsieur, nous allons dans la mauvaise direction. Les scribes de %employer% ont mal interprété les symboles ici. Nous devons changer de direction.%SPEECH_OFF%Vous pensez remettre en question les hypothèses de l\'homme, mais vous auriez plus tôt confiance en un historien robuste qui voyage avec la %companyname% qu\'en un vieux schnock élaboré dans une tour de noble. | %historian% prend la carte que %employer% vous avait donnée et l\'examine.%SPEECH_ON%Ouais, non, nous allons dans la mauvaise direction. Vous voyez ça ? L\'alphabet ici va de haut en bas, de droite à gauche. C\'est un puzzle de mots, que les scribes du noble pensaient à tort avoir résolu.%SPEECH_OFF%Vous demandez si cela signifie que vous vous dirigez dans la mauvaise direction. %historian% hoche la tête.%SPEECH_ON>Oui. Heureusement que j\'étais là, non ?%SPEECH_OFF% | Vous regardez la carte que %employer% vous a donnée. Elle est pleine de symboles bouclés que vous ne comprenez pas, comme si quelqu\'un avait griffonné une langue entière. %historian% l\'historien s\'approche en mangeant son déjeuner. Il parle entre deux bouchées.%SPEECH_ON>La carte est fausse.%SPEECH_OFF%Vous essuyez les miettes de la carte et demandez ce qu\'il veut dire. Il rit.%SPEECH_ON>Je veux dire que la carte est fausse. Les scribes de %employer% n\'avaient aucune idée de ce qu\'ils regardaient. Voyez cette formation rocheuse là-bas ? C\'est là où nous devons aller. C\'est bon, d\'ailleurs, vous en voulez ?%SPEECH_OFF%Il offre une bouchée, mais vous la refusez.%SPEECH_ON>Votre perte. Devrais-je aller dire aux hommes que nous changeons de direction ?%SPEECH_OFF%Vous soupirez et hochez la tête.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Une connaissance utile à avoir.",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local myTile = this.World.State.getPlayer().getTile();
						local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local lowestDistance = 9999;
						local best;

						foreach( b in undead )
						{
							if (b.isLocationType(this.Const.World.LocationType.Unique))
							{
								continue;
							}

							local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 25);

							if (d < lowestDistance)
							{
								lowestDistance = d;
								best = b;
							}
						}

						this.Contract.m.Destination = this.WeakTableRef(best);
						this.Flags.set("DestinationName", this.Contract.m.Destination.getName());
						this.Contract.m.Destination.setDiscovered(true);
						this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
						this.Contract.m.Destination.clearTroops();
						this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.historian")
					{
						candidates.push(bro);
					}
				}

				this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
			}

		});
		this.m.Screens.push({
			ID = "Lost",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_42.png[/img]Vous arrivez là où vous pensez que vous êtes censé être. Sauf que... il n\'y a rien ici. Vous regardez attentivement la carte et réalisez où vous avez mal tourné. Apparemment, il y a deux formations rocheuses en forme de {homme tenant une épée | église attaquée par les anciens dieux | gigantesque pomme de terre avec un visage | belle femme aux formes généreuses | chien promenant un homme | ours dressé sur ses pattes arrière, abattant une petite fille qui essaie de manger de la soupe dans un bol | jeune homme regardant les nuages, qui sont également formés au-dessus de lui avec une roche qui ressemble à un lapin bien que %randombrother% affirme que c\'est probablement un chien, seulement pour vous deux de réaliser que vous débattiez de ce à quoi ressemblait un tas de nuages rocheux pendant qu\'ils étaient fixés par un observateur de nuages rocheux}. Vous mettez une note sur votre carte et vous dirigez vers l\'emplacement réel, espérant n\'avoir pas perdu trop de temps pour cette petite excursion qui a mal tourné.",
    Image = "",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Zut!",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local myTile = this.World.State.getPlayer().getTile();
						local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local lowestDistance = 9999;
						local best;

						foreach( b in undead )
						{
							if (b.isLocationType(this.Const.World.LocationType.Unique))
							{
								continue;
							}

							local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 25);

							if (d < lowestDistance)
							{
								lowestDistance = d;
								best = b;
							}
						}

						this.Contract.m.Destination = this.WeakTableRef(best);
						this.Flags.set("DestinationName", this.Contract.m.Destination.getName());
						this.Contract.m.Destination.setDiscovered(true);
						this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
						this.Contract.m.Destination.clearTroops();
						this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.m.Destination.setLootScaleBasedOnResources(130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

						if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
						{
							this.Contract.m.Destination.getLoot().clear();
						}

						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLate1",
			Title = "À %objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]En entrant dans une pièce en vous attendant à trouver le relique, tout ce que vous voyez est un socle vide avec une note. Il dit:%SPEECH_ON%{On dirait que vos laquais sont encore en retard, %employer%. Vous vous souvenez quand vous travailliez avec moi ? C\'est ce que vous obtenez ! | Ah-ha ! Oui, j\'ai écrit ça, car c\'est ce que j\'ai exclamé quand j\'ai vu que, une fois de plus, j\'étais un pas en avant de vous, %employer%! Dommage que vous ayez choisi la voie bon marché et embauché une bande de mercenaires sans importance. Meilleure chance la prochaine fois. | Si vous lisez ceci, vous êtes trop lent et %employer% a eu tort de vous embaucher à ma place. Hélas, j\'ai le relique. Maintenant, retournez voir votre employeur et expliquez-lui comment vous avez échoué. | Si vous lisez ceci, alors vous êtes probablement ce groupe de mercenaires que %employer% a décidé d\'embaucher à ma place. Regardez comme il avait tort ! Et regardez à quelle vitesse vous êtes ! Vous êtes probablement si têtu que vous ne pouvez même pas lire ceci. | Bonjour mercenaire, c\'est dommage que je ne puisse pas être là pour voir votre visage lorsque vous avez commencé à lire ceci. Oh bien, nous ne pouvons pas toujours obtenir ce que nous voulons. Le fait que le relique soit entre mes mains et non les vôtres devrait suffire à faire passer ce message. Meilleure chance la prochaine fois, perdants, et transmettez mes salutations à %employer%.}%SPEECH_OFF%En bas, il est signé \'%nemesis%\'.\n\nVous ne savez pas qui diable c\'est, mais c\'est un homme mort marchant maintenant. Des empreintes de pas éparpillées donnent une idée d\'où est parti ce type.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Un rebondissement inattendu !",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(playerTile);
						local tile = this.Contract.getTileToSpawnLocation(playerTile, 8, 14);
						local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, this.Flags.get("NemesisNameC"), false, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.setFootprintType(this.Const.World.FootprintsType.Mercenaries);
						local n = 0;

						do
						{
							n = this.Math.rand(1, this.Const.PlayerBanners.len());
						}
						while (n == this.World.Assets.getBannerID());

						party.getSprite("banner").setBrush(this.Const.PlayerBanners[n - 1]);
						this.Flags.set("NemesisBanner", n);
						this.Contract.m.UnitsSpawned.push(party);
						party.getLoot().Money = this.Math.rand(50, 100);
						party.getLoot().ArmorParts = this.Math.rand(0, 10);
						party.getLoot().Medicine = this.Math.rand(0, 2);
						party.getLoot().Ammo = this.Math.rand(0, 20);
						local r = this.Math.rand(1, 6);

						if (r == 1)
						{
							party.addToInventory("supplies/bread_item");
						}
						else if (r == 2)
						{
							party.addToInventory("supplies/roots_and_berries_item");
						}
						else if (r == 3)
						{
							party.addToInventory("supplies/dried_fruits_item");
						}
						else if (r == 4)
						{
							party.addToInventory("supplies/ground_grains_item");
						}
						else if (r == 5)
						{
							party.addToInventory("supplies/pickled_mushrooms_item");
						}

						this.Contract.m.Destination = this.WeakTableRef(party);
						party.setAttackableByAI(false);
						party.setFootprintSizeOverride(0.75);
						local c = party.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
						local roam = this.new("scripts/ai/world/orders/roam_order");
						roam.setPivot(camp);
						roam.setMinRange(5);
						roam.setMaxRange(10);
						roam.setAllTerrainAvailable();
						roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
						roam.setTerrain(this.Const.World.TerrainType.Shore, false);
						roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
						c.addOrder(roam);
						this.Const.World.Common.addFootprintsFromTo(playerTile, this.Contract.m.Destination.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Mercenaries, 0.75);
						this.Contract.setState("Running_TooLate");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLate2",
			Title = "En vous approchant...",
			 Text = "[img]gfx/ui/events/event_07.png[/img]{Suivant leurs empreintes de pas, vous parvenez à rattraper %nemesis% et ses hommes. Vous savez que c\'est eux parce que le plus grand idiot du groupe tient le relique. Il semble que l\'homme puisse soutenir ses insultes : il est entouré d\'un groupe bien armé de combattants. Vous devriez faire attention à la manière dont vous approchez. | %nemesisC% n\'était pas aussi difficile à trouver que son message tape-à-l\'œil et insultant aurait pu le laisser paraître. Mais, à tout le moins, il est très bien protégé. Un cortège d\'hommes armés et blindés entoure l\'idiot pendant qu\'il regarde avidement le relique dans ses mains. Pour obtenir cet artefact, le %companyname% devrait réfléchir à la meilleure façon d\'aborder cette situation. | Vous trouvez un homme en train de fixer le relique que vous recherchiez. Cela doit être %nemesis%! Juste au moment où vous vous apprêtez à sauter et à le tuer vous-même, %randombrother% vous attrape par la chemise et vous tire vers le bas. Il pointe devant vous et un cortège de gardes bien armés apparaît. Le %companyname% devrait aborder cette situation avec prudence. | Les empreintes de pas n\'étaient pas difficiles à suivre. Vous pensiez initialement que c\'était parce que ce type de %nemesisS% était un idiot, mais il s\'avère qu\'il est simplement très bien protégé. Vous le trouvez tenant le relique et étant complètement entouré par un détachement de gardes bien armés. La violence était ce que vous étiez venu chercher, mais peut-être y a-t-il une autre solution ? | Vous trouvez %nemesis% tenant le relique. C\'est une cible assez facile qui a laissé des empreintes partout, soit par ignorance, soit par confiance mal placée. Alors que vous tirez votre épée, %randombrother% retient votre main. Il fait un signe de tête en avant.\n\nVous regardez un groupe d\'hommes approcher %nemesis% et demander des ordres. Ce sont ses gardes, et ils sont très bien armés. Récupérer l\'artefact pourrait nécessiter plus de bains de sang que vous ne le pensiez.}",
			Image = "",
			List = [],
			Options = [
				{
					 Text = "Vous avez commis une terrible erreur en défiant le %companyname%. Votre dernière.",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithNemesis(this.Contract.m.Destination, false);
						return 0;
					}

				},
				{
					Text = "Personne n\'a besoin de mourir ici. L\'artefact en échange de %bribe% couronnes, qu\'en dites-vous ?",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "TooLateBribeRefused" : "TooLateBribeAccepted";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLate3",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_11.png[/img]{Enfin, vous avez l\'artefact. Son poids semble étrange dans vos mains, comme s\'il devait être lourd, mais il y a quelque chose qui le maintient artificiellement léger. Vous l\'emballez et vous préparez à rentrer chez %employer%. | Vous avez maintenant l\'artefact que vous recherchiez. Pour être honnête, c\'est un peu une déception. Une partie de vous espérait qu\'il vous donnerait un immense pouvoir, mais au lieu de cela, il repose simplement dans vos mains. Peut-être que vous n\'étiez tout simplement pas l\'élu. | Vous prenez l\'artefact, ignorant le léger bourdonnement qu\'il émet, et vous vous préparez à retourner chez %employer%. | Vous prenez l\'artefact et l\'examinez attentivement. %randombrother% s\'approche et met ses poings sur ses hanches.%SPEECH_ON%Mince, cette chose laide n\'est pas si précieuse.%SPEECH_OFF% | Vous pesez l\'artefact dans vos mains. Il passe de léger à lourd et vice versa. Eh bien, c\'est assez étrange, alors vous le fourrez rapidement dans une besace. | %randombrother% jette un coup d\'œil à l\'artefact avant que vous ne le rangiez.%SPEECH_ON%Ça n\'a pas l\'air de grand-chose.%SPEECH_OFF%Vous lui dites que beaucoup de choses puissantes ne semblent pas impressionnantes. Il réfléchit un instant.%SPEECH_ON%Mes pets ne ressemblent à rien du tout, donc je suppose que tu as raison.%SPEECH_OFF% | Vous donnez l\'artefact à %randombrother%. Il le soulève.%SPEECH_ON%Et si je le cassais ici et maintenant, tu serais fâché ?%SPEECH_OFF%Vous lancez un regard furieux à l\'homme.%SPEECH_ON%Ouais, un peu. Mais peut-être qu\'il y a de petits démons dedans qui te feront foutre pour l\'éternité pour avoir détruit leur maison. Qui sait, hein ?%SPEECH_OFF%Le mercenaire fourre rapidement l\'artefact dans une besace. | Vous regardez l\'artefact. Il est vierge et immobile, pas quelque chose à quoi vous vous attendiez de tenir un grand pouvoir, mais pour une raison quelconque, c\'est la partie la plus inquiétante. Vous le fourrez rapidement dans une besace. | Vous mettez l\'artefact dans une besace, mais il se met à luire et à vous appeler. En ouvrant le sac, vous regardez deux points rouges qui vous fixent. %randombrother% demande si vous allez bien. Vous refermez rapidement le sac et hochez la tête. | Vous avez enfin l\'artefact. Il ne brille pas, il ne bourdonne pas, il n\'a même pas l\'air si joli. Vous n\'êtes pas sûr de ce qui a suscité tout ce tapage, mais si %employer% veut vous payer pour ça, c\'est son problème. | Eh bien, vous avez l\'artefact. %randombrother% s\'approche en se grattant la tête.%SPEECH_ON%Alors, beaucoup de gens sont morts pour cette petite chose ?%SPEECH_OFF%L\'artefact s\'agite et une voix grognante répond.%SPEECH_ON%Ils ne sont pas morts. Ils sont avec moi maintenant et pour toujours.%SPEECH_OFF%Le mercenaire recule brusquement.%SPEECH_ON%Tu sais quoi ? Je n\'ai pas entendu ça. Je ne sais pas ce que c\'était. Ça m\'est égal. Non. Je vais simplement retourner à manger du pain dur et rassis et vivre une vie ennuyeuse, merci beaucoup.%SPEECH_OFF% | Vous tenez l\'artefact, en utilisant un chiffon entre lui et vous de peur que ses pouvoirs ne pénètrent dans votre chair. Bien sûr, il ressemble simplement à un morceau de pierre fantaisiste, mais il n\'y a pas de mal à être prudent. %employer% devrait être content de le voir et il peut le tenir comme il veut, autant que vous êtes concerné. | L\'artefact a l\'air étrange, mais rien de trop extraordinaire. Pour tout ce que vous savez, c\'était peut-être le projet d\'un vagabond que quelqu\'un d\'autre a pris pour un objet divin. %randombrother% le fixe.%SPEECH_ON%J\'ai chié des choses plus jolies que ça, si je suis honnête.%SPEECH_OFF%Vous le mettez en garde que si cet objet a vraiment des pouvoirs, il paiera probablement pour ce commentaire. Il hausse les épaules.%SPEECH_ON%Ne change pas les faits cependant.%SPEECH_OFF% | Vous levez le reliquaire et il devient soudain lourd, vous le ramenant vers le bas. Lorsque vous le baissez vers vos pieds, il devient plus léger, comme s\'il souhaitait être repris. C\'est assez étrange pour vous, alors vous le rangez rapidement et vous vous préparez à retourner chez %employer%. | Enfin, vous avez l\'artefact. Vous le regardez quand %randombrother% s\'approche.%SPEECH_ON%Alors, c\'est ce que %employer% veut ? Mince, j\'aurais pu fabriquer quelque chose comme ça et nous aurions évité tous ces ennuis.%SPEECH_OFF%Vous rangez l\'artefact dans un sac et répondez.%SPEECH_ON%Je pense qu\'il aurait fini par comprendre que c\'était un faux.%SPEECH_OFF%Le mercenaire lève le doigt.%SPEECH_ON%Mot-clé : finalement.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous avons ce pour quoi nous sommes venus. Il est temps de rentrer !",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLateBribeRefused",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Le chef des voleurs rit et secoue la tête.%SPEECH_ON%Tu viens sérieusement de... Je veux dire, vraiment ?%SPEECH_OFF%Il s\'avance et continue.%SPEECH_ON%C\'était une tentative, je suppose, mais la réponse est non.%SPEECH_OFF% Lentement, il sort sa lame. Le métal scintille lorsqu\'il la dirige vers vous.%SPEECH_ON%Un non catégorique.%SPEECH_OFF% | Votre tentative de corruption n\'a pas été acceptée. Non seulement les voleurs ont refusé, mais ils se sont offensés et attaquent ! Apparemment, il y a de l\'honneur parmi ces voleurs ! | Le chef des voleurs ricane.%SPEECH_ON%Un pot-de-vin ? Non. Nous ne sommes pas venus si loin et n\'avons pas souffert de ce que nous avons souffert juste pour faire un échange mesquin. Hé les gars, que dites-vous que c\'est leur tour de souffrir ?%SPEECH_OFF%Acclamant, le groupe de vandales sort ses armes. Leur chef pointe une lame vers le %companyname%.%SPEECH_ON%Préparez-vous à mourir, mercenaires.%SPEECH_OFF% | Vous offrez le pot-de-vin et il est rapidement refusé. Le chef des vandales et vous-même hochez la tête. Une chose est comprise : aucun de vous ne repartira les mains vides. Préparez-vous pour le combat ! | Les brigands font un cercle et en parlent à voix basse. Enfin, le chef sort, les mains sur les hanches et la poitrine fièrement bombée. Il secoue la tête.%SPEECH_ON%Nous déclinons respectueusement l\'offre. Maintenant, laissez-nous passer, ou préparez-vous au combat.%SPEECH_OFF%%employer% ne vous paie pas pour revenir les mains vides. Vous ordonnez au %companyname% de se mettre en formation. Le brigand soupire et sort son épée.%SPEECH_ON%Soit. C\'est ainsi !%SPEECH_OFF% | Les vandales rient de votre offre. Il semble qu\'ils l\'aient également interprétée comme un signe de faiblesse, car ils sortent tous leurs armes. Vous pensiez que l\'offre était très équitable, mais il semble que ces hommes souhaitent vendre l\'objet au prix ultime. Soit. Préparez-vous pour le combat ! | Le chef des voleurs rit.%SPEECH_ON%Une offre intéressante, mais non. Je pense que nous savons tous les deux que ce petit artefact vaut plus que ça, et certainement plus que tout ce que vous pouvez offrir. Maintenant, dégagez de notre chemin.%SPEECH_OFF%Le %companyname% se met en formation, tirant des armes. %randombrother% crache.%SPEECH_ON%Nous pouvons les tuer tous, monsieur, donnez simplement l\'ordre.%SPEECH_OFF%Vous avez une foi inébranlable dans le %companyname%, car c\'est une religion de la violence exacte. Il est temps de mettre en pratique ce que vous prêchez ! | Le chef des brigands plonge sa main dans un sac et sort une tête. Elle est d\'un gris luride et tourne par les cheveux tendus entre ses doigts.%SPEECH_ON%C\'est ce qui est arrivé aux derniers hommes qui se sont mis en travers de notre chemin. Votre offre est respectueusement déclinée, mercenaire. Maintenant, dégagez de notre chemin ou c\'est ici que se terminent mes politesses.%SPEECH_OFF%Vous riez et répondez à votre tour.%SPEECH_ON%Nous sommes le %companyname%, et c\'est dommage que personne ne sache qui vous êtes car il n\'y aura rien à se vanter après que nous vous ayons tous tués.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux Armes!",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithNemesis(this.Contract.m.Destination, false);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TooLateBribeAccepted",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Après quelques discussions, les voleurs acceptent votre offre. Vous remettez les couronnes et ils remettent l\'artefact. Cela a été plus facile que prévu. | Les brigands discutent entre eux, regroupés et vous regardant de temps en temps. C\'est une étrange épreuve, étant donné que dans quelques minutes, vous pourriez tous vous entretuer en fonction de leur décision. Finalement, ils rompent le cercle et le chef vous fait signe de vous approcher.%SPEECH_ON%Notre employeur ne sera pas content, mais ces couronnes sont difficiles à refuser. Vous avez un accord, mercenaire.%SPEECH_OFF% | Les vandales débattent de votre offre. Certains disent que leur employeur sera très mécontent s\'ils rentrent les mains vides, tandis que d\'autres affirment que cela ne vaut pas la peine de mourir pour cela. Le dernier parti l\'emporte. Vous recevez l\'artefact en échange de couronnes. | Un parti honorable aurait peut-être essayé de combattre le %companyname%, mais vous avez affaire à des voleurs ici, pas à des hommes au rapport le plus honorable. Ils acceptent de remettre l\'artefact contre des couronnes. | Le chef des voleurs sort son épée.%SPEECH_ON%Tu crois sérieusement que nous accepterions cette off...%SPEECH_OFF%Un jet de sang termine le mot et il éclabousse la lame qui sort soudainement de sa poitrine. Les yeux du brigand roulent en arrière alors que son tueur pose un pied sur son dos et le fait tomber de l\'épée. Le tueur nettoie son arme.%SPEECH_ON%On ne va pas mourir pour ce fils de pute. Ton offre est acceptée, mercenaire.%SPEECH_OFF% | Un argument éclate entre les voleurs. Certains pensent qu\'ils peuvent vous affronter tandis que d\'autres sont un peu plus conscients de qui est le %companyname% et ce dernier argumente assez vigoureusement contre toute hostilité. Finalement, ils parviennent à un accord : le pot-de-vin est accepté. | Votre offre de payer pour l\'artefact suscite un débat animé entre les voleurs. Ils argumentent à voix basse, mais leurs regards furtifs semblent indiquer qu\'ils vous considèrent comme une menace existentielle. Finalement, ils rompent leur cercle et acceptent vos conditions. Vous êtes content que cela n\'ait pas conduit à un bain de sang. | Les voleurs ricanent.%SPEECH_ON%Tu crois qu\'on peut retourner les mains vides à nos bienfaiteurs ?%SPEECH_OFF%Vous passez une main dans vos cheveux et répondez.%SPEECH_ON%C\'est mieux que de ne pas revenir du tout, non ?%SPEECH_OFF%Chaque voleur fait un pas en arrière avec méfiance. Leur chef secoue la tête puis fait signe de la tête tout en un mouvement rapide.%SPEECH_ON%Bon sang, mercenaire, tu nous mets dans une situation délicate ici. Mais d\'accord, nous accepterons.%SPEECH_OFF%L\'artefact est remis et la violence est évitée. | Le chef des voleurs se tourne vers sa bande et demande sincèrement.%SPEECH_ON%Qu\'en pensez-vous, les gars, pensez-vous que nous pouvons les battre ?%SPEECH_OFF%L\'un hausse les épaules.%SPEECH_ON%Je pense qu\'on peut prendre l\'or qu\'ils offrent.%SPEECH_OFF%Un autre intervient.%SPEECH_ON%C\'était censé être une expédition, on n\'est pas assez bien payés pour mourir à cause de ce maudit artefact.%SPEECH_OFF%Peu à peu, les brigands parviennent à un accord : ils prendront le pot-de-vin plutôt que d\'être massacrés. Une décision intelligente selon la plupart des critères.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Vous avez pris la bonne décision.",
					function getResult()
					{
						this.Contract.m.Destination.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
						return "TooLate3";
					}

				}
			],
			function start()
			{
				local bribe = this.Contract.beautifyNumber(this.Contract.m.Payment.Pool * 0.4);
				this.World.Assets.addMoney(-bribe);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + bribe + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Trap",
			Title = "À %objective%",
			Text = "[img]gfx/ui/events/event_12.png[/img]{Vous enjambez un fil de déclenchement et dites à %hurtbro% de faire attention. Il ne le fait pas et tombe dans les machinations d\'un piège pour son insouciance. | Le sol des ruines est truffé de pièges évidents et de gadgets mortels. Vous parvenez à passer à travers sans problème jusqu\'à ce que %hurtbro%, pensant être à l\'abri, se précipite soudainement en avant. Des machines anciennes sont déclenchées, et vous pensez que tout l\'endroit va s\'effondrer sur vos têtes. Heureusement, seul le mercenaire paie pour son manque de discrétion. | Les ruines sont piégées, et %hurtbro% parvient à en déclencher un. | Le pied de %hurtbro% tombe sur une brique qui s\'enfonce rapidement dans le sol. Des machines anciennes grondent derrière les murs, et le plafond commence à s\'effondrer. Malgré tout le bruit, le piège lui-même est assez petit, et le mercenaire survivra. | Des glyphes sur le mur épellent d\'anciennes ruminations à travers l\'utilisation d\'images. Malheureusement, les bonshommes sont si mal dessinés que vous ne réalisez pas qu\'ils sont en fait des panneaux d\'avertissement avant qu\'il ne soit trop tard : %hurtbro% se promène dans un piège et récolte beaucoup de problèmes pour vos pauvres compétences en traduction. | Vous auriez dû le savoir : les ruines sont truffées de pièges et %hurtbro% marche droit dans l\'un d\'eux. Il survivra, et vous serez plus en sécurité à l\'avenir. | %hurtbro% déclenche un piège et récolte beaucoup de problèmes douloureux pour son manque de prudence. | Il y a bien des années, un homme s\'est assis pour fabriquer un piège. Aujourd\'hui, %hurtbro% marche droit dedans. | Vous déclenchez un fil de déclenchement et entendez les murs s\'animer avec des machines anciennes. Vous vous baissez, pensant être à l\'abri, pour vous retourner et voir que %hurtbro% a subi la majeure partie des dégâts du piège. Oups... | Vous voyez un fil de déclenchement au sol et riez. Tellement proche, ancien fabricant de pièges, tellement proche - soudain, %hurtbro% passe juste à côté de vous et déclenche le piège. L\'idiot survivra, mais il y aura beaucoup de douleur dans son futur. | Le sifflement de %hurtbro% résonne profondément dans les ruines, mais l\'écho semble plutôt étrange, comme s\'il hoquetait quelque part dans les murs. Vous dites aux hommes de tenir leur position, mais le siffleur continue d\'avancer et tombe soudainement à travers le sol dans un puits. Vous vous précipitez au bord, et vous voyez qu\'il a réussi à éviter de justesse des pointes. | En marchant dans les ruines, %hurtbro% déclenche un piège qui l\'envoie chuter à travers le sol. Il atterrit sur un étage inférieur parsemé de trous. Des pointes émergent, mais suffisamment lentement pour que l\'homme puisse s\'en sortir. Heureusement, le piège ne s\'est pas déclenché dans le bon ordre, et vous parvenez à sortir le mercenaire de là. | En se frayant un chemin à travers les ruines déroutantes, %hurtbro% disparaît soudainement de votre champ de vision. Vous vous précipitez là où il était pour presque tomber dans le même piège : un trou dans le sol parsemé d\'écailles de serpent croquantes. Heureusement, les bestioles ne sont plus là, mais la chute elle-même a suffi à mettre le pauvre mercenaire à mal.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Soyez plus prudent !",
					function getResult()
					{
						this.Contract.m.Dude = null;
						return "SearchingTheRuins";
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				local injury = bro.addInjury(this.Const.Injury.Accident1);
				this.Contract.m.Dude = bro;
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " suffers " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "ScavengerHunt",
			Title = "À %objective%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Vous trouvez une carte dans les ruines qui semble suggérer que le relique est en réalité situé dans des ruines appelées %objective% quelque part %direction% d\'ici. | Malheureusement, la relique n\'est pas ici. En enquêtant, vous découvrez que vous avez commis une erreur en venant ici : ce que vous cherchez se trouve en réalité à %objective%, juste %direction% d\'ici. | Eh bien, vous êtes venu au mauvais endroit. Vous et les hommes faites de votre mieux pour déchiffrer les langues sur le mur et les comparer à ce que vous avez sur votre carte. Avec le temps, vous comprenez que l\'artefact que vous cherchez est probablement situé dans un endroit appelé %objective%, juste %direction% d\'ici. | %randombrother% vous apporte la carte et il maudit entre ses dents.%SPEECH_ON%Je pense qu\'on s\'est trompés d\'endroit, monsieur. Regardez ceci.%SPEECH_OFF%Ensemble, vous comprenez que l\'artefact est probablement situé dans des ruines %direction% d\'ici, à un endroit appelé %objective%. | Vous espériez trouver l\'artefact en une seule fois, mais cela n\'arrivera pas. Grâce à une enquête minutieuse, la compagnie découvre lentement qu\'elle s\'est trompée d\'endroit. Il faut se rendre à %objective%, %direction% d\'ici. | Les ruines ne sont pas les bonnes. Certaines indications sur les murs et l\'absence distincte de l\'artefact vous le confirment. En spéculant soigneusement, vous estimez que le relique se trouve en réalité à %objective%, %direction% d\'ici. | En grimpant à travers les ruines et ne trouvant rien de valeur, vous comprenez lentement que vous vous êtes trompés d\'endroit. Vous et %randombrother% étudiez la carte pendant un moment avant de conclure que l\'artefact se trouve en réalité dans un endroit appelé %objective%, juste %direction% d\'ici. | %randombrother% trouve un homme empalé sur quelques pointes déclenchées par un piège. Il a une carte dans sa poigne osseuse et en décomposition. Vous lisez la carte et réalisez que, tout comme cet homme l\'a fait, vous êtes venus au mauvais ensemble de ruines. L\'artefact se trouve en réalité à %objective%, %direction% d\'ici. Heureusement, cet explorateur intrépide est arrivé avant vous ! | On trouve un cadavre recroquevillé au bas d\'une paire de marches menant à un podium vide. Vous pensez que c\'est là que l\'artefact était censé être, mais il a disparu. Le mort ne semble pas l\'avoir. %randombrother% fouille les vêtements du corps pour trouver une carte pliée. Elle mène à un endroit appelé %objective%, quelque part %direction% d\'ici.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous à avancer, les hommes !",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Destination = null;
				local myTile = this.World.State.getPlayer().getTile();
				local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
				local lowestDistance = 9999;
				local best;

				foreach( b in undead )
				{
					if (b.isLocationType(this.Const.World.LocationType.Unique))
					{
						continue;
					}

					local d = myTile.getDistanceTo(b.getTile()) + this.Math.rand(0, 35);

					if (d < lowestDistance)
					{
						lowestDistance = d;
						best = b;
					}
				}

				this.Contract.m.Destination = this.WeakTableRef(best);
				this.Flags.set("DestinationName", this.Contract.m.Destination.getName());
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.getActiveState().start();
				this.World.Contracts.updateActiveContract();
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{La porte de %employer% est ouverte et vous entrez. Il se tourne pour vous regarder avec un long regard et un regard interrogateur. Vous produisez l\'artefact et le tendez. Le noble se lève d\'un bond avec une énergie inattendue.%SPEECH_ON%Vous l\'avez ! Par les anciens dieux ! Laissez-moi avoir ça !%SPEECH_OFF%L\'artefact est remis et les yeux de %employer% s\'élargissent. Vous demandez votre paiement, mais il est déjà dans un autre monde, comme s\'il avait été aspiré par l\'artefact lui-même. L\'un de ses scribes s\'avance hors des ombres d\'un coin. Il vous remet une bourse contenant %reward_completion% couronnes.%SPEECH_ON%Excusez-nous, mercenaire. Mon seigneur et moi avons des devoirs à accomplir.%SPEECH_OFF% | %employer% est profondément assis dans un fauteuil et peut-être même plus profondément dans ses pensées. Un de ses gardes doit lui dire que vous êtes là, se répétant trois fois jusqu\'à ce que le noble vous regarde. Il vous fixe, puis regarde l\'artefact. Son corps se lève de la chaise comme s\'il était animé par l\'impulsion d\'une force invisible. Il prend l\'artefact et se retourne, se précipitant vers son bureau où il le pose et s\'accroupit pratiquement, s\'observant avec une ferveur atavique. Le garde vous remet une bourse contenant %reward_completion% couronnes.%SPEECH_ON%Vous feriez bien de partir, mercenaire.%SPEECH_OFF% | Un scribe de %employer% vous accueille à l\'extérieur de la chambre du noble. Il a une haleine de livre moisi et une hâte dans sa façon d\'agir.%SPEECH_ON%Est-ce l\'artefact ? Est-ce ?%SPEECH_OFF%Vous remettez un sac avec le relique. Les doigts du scribe s\'agrippent aux cordons comme des becs picorant des vers.%SPEECH_ON%Donnez ! Donnez ! Ici, prenez votre argent et partez !%SPEECH_OFF%Il vous enfonce une bourse contenant %reward_completion% couronnes avant de disparaître dans la chambre de %employer%. | Quelques scribes attendent à l\'intérieur de la chambre de %employer%. Le noble lui-même est endormi dans son lit, la tête tournée vers le plafond, les bras le long du corps comme une sorte de mannequin inachevé. L\'un des scribes s\'avance.%SPEECH_ON%Le relique, donnez-le.%SPEECH_OFF%C\'est très étrange, mais vous ne réveillerez certainement pas un seigneur qui dort. Vous vous renseignez sur le paiement. Un autre scribe vous lance un sac contenant %reward_completion% couronnes, le sac glissant sur le sol en pierre.%SPEECH_ON%Mettez maintenant le relique sur le sol et partez.%SPEECH_OFF%Vous prenez votre argent et partez. | Vous trouvez %employer% amusant une foule de nobles. L\'apercevant au-dessus de leurs têtes, il se dépêche de faire ses blagues avant de prendre congé. Il glisse autour de la pièce pour vous saluer avec des chuchotements.%SPEECH_ON%Avez-vous le relique ?%SPEECH_OFF%Vous le remettez et l\'homme sourit. Il vous donne une bourse contenant %reward_completion% couronnes.%SPEECH_ON%Bon travail, mercenaire, mais vous devriez partir. Ce n\'est pas votre foule. Ce n\'est pas la mienne non plus.%SPEECH_OFF%Il cligne de l\'œil et vous fait signe de partir. | Un scribe vous intercepte à l\'extérieur de la chambre de %employer%. Il met un doigt sur ses lèvres et secoue la tête avant de vous guider plus loin dans le couloir. Se tenant devant un brasero, l\'aîné jette rapidement un coup d\'œil autour de lui avant de tirer sur le flambeau.%SPEECH_ON%Poussez le mur, mercenaire.%SPEECH_OFF%Vous faites ce qu\'on vous dit. Une partie de ce n\'est pas de la pierre du tout, mais du bois. Elle glisse et vous entrez. %employer% est là avec une multitude de livres et d\'objets étranges éparpillés dans une pièce sombre et éclairée à la chandelle.\", \"[img]gfx/ui/events/event_04.png[/img]{La pièce est éclairée à la chandelle. Il snappe des doigts et vous remettez l\'artefact. En retour, vous recevez une bourse contenant %reward_completion% couronnes. Le noble fait une pause, puis regarde son scribe.%SPEECH_ON%Attendez, cet endroit était censé être secret, que diable faites-vous ?%SPEECH_OFF%Le vieil homme pince maladroitement les lèvres. Le noble se pince le front.%SPEECH_ON%Bon sang. D\'accord, appelez le maçon à nouveau, je suppose.%SPEECH_OFF% | Vous trouvez %employer% et remettez l\'artefact. Il vous donne une bourse contenant %reward_completion% couronnes et c\'est ainsi que la transaction est complète. Eh bien, c\'était anti-climactique. | %employer% est debout aux côtés de quelques-uns de ses commandants. Ils vous regardent lorsque vous entrez et le noble tend la main sur son bureau. Vous avancez lentement et déposez l\'artefact dans sa paume. Il le prend, le tourne, le regarde, puis vous regarde. Il snappe des doigts.%SPEECH_ON%Payez le mercenaire.%SPEECH_OFF%L\'un des commandants vous remet une bourse contenant %reward_completion% couronnes et vous êtes bientôt conduit hors de la pièce. | Un homme qui ressemble beaucoup à %employer% vous attend dans la chambre du noble. Il vous demande de remettre l\'artefact et vous faites ce qui est demandé. L\'homme fait une pause, le tenant, les yeux fuyant autour. Finalement, il le pose au sol et crie.%SPEECH_ON%Cela semble correct !%SPEECH_OFF%Soudain, le vrai %employer% apparaît du côté de la pièce, avançant prudemment.%SPEECH_ON%Désolé pour les effets dramatiques, mais il y a des pouvoirs ici que vous ne pouvez pas comprendre.%SPEECH_OFF%Vous doutez qu\'un artefact puisse prendre vie comme un assassin potentiel, mais vous ne remettez pas en question les processus de pensée clairement insensés du noble. Vous acceptez vos %reward_completion% couronnes et partez joyeusement. | %employer% vous rencontre à l\'extérieur de sa chambre. Son visage est rouge et moite et il semble presque garder la porte.%SPEECH_ON%Bonsoir, mercenaire. Avez-vous ce qui était demandé ?%SPEECH_OFF%Vous remettez l\'artefact. L\'homme sourit et vous donne une bourse contenant %reward_completion% couronnes. Il se tourne pour retourner dans sa chambre, puis fait une pause.%SPEECH_ON%Hé, partez. Je ne vous paie pas pour rester là à regarder ce que je fais.%SPEECH_OFF%Vous hochez la tête et partez. En partant, vous entendez la porte s\'ouvrir et un bruissement de voix féminines qui s\'échappe rapidement avant de se refermer. | Un des gardes de %employer% vous emmène dans les jardins où le noble s\'occupe de ses récoltes. Il enseigne à un jeune garçon comment tailler les tomates.%SPEECH_ON%La tige, imbécile ! Coupe ça, tu vois ? Pourquoi poignarder la nourriture ? Ne poignardez jamais la nourriture ! Mercenaire !%SPEECH_OFF%Le seigneur se redresse à la vue de vous. Il repousse le garçon et s\'approche en demandant si vous avez le relique. Vous le remettez et recevez %reward_completion% couronnes en retour. Le noble hoche la tête.%SPEECH_ON%Vous avez bien fait, mercenaire. Je perds foi en les capacités individuelles à faire ce que je leur demande. Je suis sûr que vous comprenez.%SPEECH_OFF%Par-dessus les épaules du noble, vous voyez le garçon assassiner une autre plante. Vous hochez lentement la tête. | Vous remettez le relique à %employer%. Il le regarde avec des sourcils froncés, roulant les doigts en colère le long de son bureau.%SPEECH_ON%Hmm, je suppose que c\'est tout. Un peu décevant, mais un accord est un accord.%SPEECH_OFF%Il fait glisser à contrecœur une bourse contenant %reward_completion% couronnes vers vous. | %employer% vous accueille dans sa chambre, vous offrant une coupe de vin. Vous buvez pendant qu\'un scribe vient prendre le relique. Il va sur le côté de la pièce et commence à mesurer, peser, et même... le goûter ? Vous ignorez quelles que soient les calculs qui se font là et demandez votre paiement. %employer% sourit.%SPEECH_ON%Vous le buvez !%SPEECH_OFF%Vous faites une pause avec la coupe sur vos lèvres. Le noble rit.%SPEECH_ON%Une blague, mercenaire, détendez-vous ! Voici %reward_completion% couronnes comme convenu.%SPEECH_OFF% | Vous ouvrez la porte de la chambre de %employer% pour trouver le noble et quelques scribes debout devant une table. Des fioles et des flacons de forme étrange sont partout, certains remplis de couleurs encore plus étranges. Un des scribes se précipite vers vous et tire sa main d\'entre manches trop grandes, comme des serpents poignardant hors d\'une grotte. Il prend le relique d\'une main tandis que l\'autre enfonce une bourse contenant %reward_completion% couronnes dans votre poitrine. %employer% vous fait signe de partir.%SPEECH_ON%Partez, mercenaire, vous avez fait autant que nous avons demandé et c\'est aussi loin que vos services sont requis pour l\'instant.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Procured an artifact important for the war effort");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

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
		_vars.push([
			"hurtbro",
			this.m.Dude == null ? "" : this.m.Dude.getName()
		]);
		_vars.push([
			"historian",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"objective",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"nemesis",
			this.m.Flags.get("NemesisName")
		]);
		_vars.push([
			"nemesisS",
			this.m.Flags.get("NemesisNameS")
		]);
		_vars.push([
			"nemesisC",
			this.m.Flags.get("NemesisNameC")
		]);
		_vars.push([
			"bribe",
			this.beautifyNumber(this.m.Payment.Pool * 0.4)
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});


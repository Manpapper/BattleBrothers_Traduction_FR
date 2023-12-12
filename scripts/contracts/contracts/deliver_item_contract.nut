this.deliver_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Location = null,
		RecipientID = 0
	},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 105) * 0.01;
		this.m.Type = "contract.deliver_item";
		this.m.Name = "Armed Courier";
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

		local recipient = this.World.FactionManager.getFaction(this.m.Destination.getFactions()[0]).getRandomCharacter();
		this.m.RecipientID = recipient.getID();
		this.m.Flags.set("RecipientName", recipient.getName());
		this.contract.start();
	}

	function setup()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local candidates = [];

		foreach( s in settlements )
		{
			if (s.getID() == this.m.Home.getID())
			{
				continue;
			}

			if (!s.isDiscovered() || s.isMilitary())
			{
				continue;
			}

			if (!s.isAlliedWithPlayer())
			{
				continue;
			}

			if (this.m.Home.isIsolated() || s.isIsolated() || !this.m.Home.isConnectedToByRoads(s) || this.m.Home.isCoastal() && s.isCoastal())
			{
				continue;
			}

			local d = this.m.Home.getTile().getDistanceTo(s.getTile());

			if (d < 15 || d > 100)
			{
				continue;
			}

			if (this.World.getTime().Days <= 10)
			{
				local distance = this.getDistanceOnRoads(this.m.Home.getTile(), s.getTile());
				local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed, false);

				if (this.World.getTime().Days <= 5 && days >= 2)
				{
					continue;
				}

				if (this.World.getTime().Days <= 10 && days >= 3)
				{
					continue;
				}
			}

			candidates.push(s);
		}

		if (candidates.len() == 0)
		{
			this.m.IsValid = false;
			return;
		}

		this.m.Destination = this.WeakTableRef(candidates[this.Math.rand(0, candidates.len() - 1)]);
		local distance = this.getDistanceOnRoads(this.m.Home.getTile(), this.m.Destination.getTile());
		local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed, false);

		if (days >= 2 || distance >= 40)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		}

		this.m.Payment.Pool = this.Math.max(125, distance * 4.5 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentLightMult());

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Distance", distance);
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Délivrez le paquet à %recipient% dans %objective% a à peu près %days% %direction% par la route"
				];
				local isSouthern = this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState;

				if (!isSouthern && this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else if (isSouthern)
				{
					this.Contract.setScreen("TaskSouthern");
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

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 750 && (!this.World.Ambitions.hasActiveAmbition() || this.World.Ambitions.getActiveAmbition().getID() != "ambition.defeat_mercenaries"))
					{
						this.Flags.set("IsMercenaries", true);
					}
				}
				else if (r <= 15)
				{
					if (this.World.Assets.getBusinessReputation() > 700)
					{
						this.Flags.set("IsEvilArtifact", true);

						if (!this.World.Flags.get("IsCursedCrystalSkull") && this.Math.rand(1, 100) <= 50)
						{
							this.Flags.set("IsCursedCrystalSkull", true);
						}
					}
				}
				else if (r <= 20)
				{
					if (this.World.Assets.getBusinessReputation() > 500)
					{
						this.Flags.set("IsThieves", true);
					}
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Délivrez le paquet à %recipient% dans %objective% a à peu près %days% %direction% par la route"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Destination) && !this.Flags.get("IsStolenByThieves"))
				{
					if (this.Flags.get("IsEnragingMessage"))
					{
						this.Contract.setScreen("EnragingMessage1");
					}
					else
					{
						local isSouthern = this.Contract.m.Destination.isSouthern();

						if (isSouthern)
						{
							this.Contract.setScreen("Success2");
						}
						else
						{
							this.Contract.setScreen("Success1");
						}
					}

					this.World.Contracts.showActiveContract();
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

					if (this.Flags.get("IsMercenaries") && this.World.State.getPlayer().getTile().HasRoad)
					{
						if (!this.TempFlags.get("IsMercenariesDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.Contract.setScreen("Mercenaries1");
							this.World.Contracts.showActiveContract();
							this.TempFlags.set("IsMercenariesDialogTriggered", true);
						}
					}
					else if (this.Flags.get("IsEvilArtifact") && !this.Flags.get("IsEvilArtifactDone"))
					{
						if (!this.TempFlags.get("IsEvilArtifactDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.Contract.setScreen("EvilArtifact1");
							this.World.Contracts.showActiveContract();
							this.TempFlags.set("IsEvilArtifactDialogTriggered", true);
						}
					}
					else if (this.Flags.get("IsEvilArtifact") && this.Flags.get("IsEvilArtifactDone"))
					{
						this.Contract.setScreen("EvilArtifact3");
						this.World.Contracts.showActiveContract();
						this.Flags.set("IsEvilArtifact", false);
					}
					else if (this.Flags.get("IsThieves") && !this.Flags.get("IsStolenByThieves") && this.World.State.getPlayer().getTile().Type != this.Const.World.TerrainType.Desert && (this.World.Assets.isCamping() || !this.World.getTime().IsDaytime) && this.Math.rand(1, 100) <= 3)
					{
						local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 5, 10, [
							this.Const.World.TerrainType.Shore,
							this.Const.World.TerrainType.Ocean,
							this.Const.World.TerrainType.Mountains
						], false);
						tile.clear();
						this.Contract.m.Location = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/bandit_hideout_location", tile.Coords));
						this.Contract.m.Location.setResources(0);
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).addSettlement(this.Contract.m.Location.get(), false);
						this.Contract.m.Location.onSpawned();
						this.Contract.addUnitsToEntity(this.Contract.m.Location, this.Const.World.Spawn.BanditDefenders, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Const.World.Common.addFootprintsFromTo(this.World.State.getPlayer().getTile(), tile, this.Const.GenericFootprints, this.Const.World.FootprintsType.Brigands, 0.75);
						this.Flags.set("IsStolenByThieves", true);
						this.Contract.setScreen("Thieves1");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "EvilArtifact")
				{
					this.Flags.set("IsEvilArtifactDone", true);
				}
				else if (_combatID == "Mercs")
				{
					this.Flags.set("IsMercenaries", false);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "EvilArtifact")
				{
					if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to deliver cargo");
					}
					else
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to deliver cargo");
					}

					this.World.Contracts.removeContract(this.Contract);
				}
				else if (_combatID == "Mercs")
				{
					if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to deliver cargo");
					}
					else
					{
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to deliver cargo");
					}

					this.World.Contracts.removeContract(this.Contract);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Thieves",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = true;
				}

				this.Contract.m.BulletpointsObjectives = [
					"Suivez les voleurs et récupérez le paquet",
					"Délivrez le paquet à %recipient% dans %objective% a à peu près %days% %direction% par la route"
				];
			}

			function update()
			{
				if (this.Contract.m.Location == null || this.Contract.m.Location.isNull())
				{
					this.Contract.setScreen("Thieves2");
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
			Text = "[img]gfx/ui/events/event_112.png[/img]{%employer% pousse une caisse de taille considérable dans vos mains avant même qu\'il ou vous ne disiez un mot.%SPEECH_ON%Regardez ça, la cargaison que j\'ai besoin de livrer a déjà trouvé quelqu\'un pour l\'expédier ! Quelle merveille !%SPEECH_OFF%Il abandonne le théâtre.%SPEECH_ON%Je veux que cela soit livré à %objective% où un homme du nom de %recipient% l\'attend. Cela peut sembler petit, mais je suis prêt à payer de bonnes couronnes pour m\'assurer qu\'il arrive sain et sauf. Cela vous intéresse-t-il ? Ou est-ce un peu trop lourd pour vos bras ?%SPEECH_OFF% | Vous trouvez %employer% en train de fermer une boîte. Il jette rapidement un coup d\'œil en l\'air, comme s\'il avait été pris en flagrant délit.%SPEECH_ON%Mercenaire ! Merci d\'être venu.%SPEECH_OFF]Il verrouille les loquets avec quelques clics rapides. Puis il tapote la caisse quelques fois, même s\'appuie dessus comme s\'il avait besoin d\'un autre loquet.%SPEECH_ON%Cette cargaison doit être livrée en toute sécurité à %objective%. Un homme du nom de %recipient% l\'attend. Je ne crois pas que la tâche sera facile, car la cargaison est plutôt précieuse pour certaines personnes prêtes à tout pour l\'acquérir, c\'est pourquoi je m\'adresse à un homme de votre... expérience. Êtes-vous intéressé à le faire pour moi ?%SPEECH_OFF% | En entrant dans la pièce de %employer%, celui-ci et l\'un de ses serviteurs clouent une boîte.%SPEECH_ON%Bienvenue, bienvenue. Content de vous voir. J\'ai besoin de gardes armés pour livrer ce colis à un homme du nom de %recipient% à %objective%. Je pense que c\'est à environ %days% de voyage pour une compagnie comme la vôtre. À quel point seriez-vous intéressé à le faire pour moi ?%SPEECH_OFF% | %employer% a les pieds sur sa table quand vous entrez. Il met ses mains derrière sa tête, ayant l\'air un peu trop détendu à votre goût.%SPEECH_ON%Salutations, capitaine. Que diriez-vous de faire une pause dans tout ce meurtre et cette mort.%SPEECH_OFF%Il lève un sourcil à votre réponse, qui est précisément nulle.%SPEECH_ON%Hein, je pensais que vous sauteriez sur cette opportunité. Peu importe, c\'était un mensonge : j\'ai besoin que vous transportiez un certain colis à %recipient%, un individu résidant à %objective%. Ce chargement a sans aucun doute attiré quelques regards mal intentionnés, c\'est pourquoi j\'ai besoin de vos hommes pour le surveiller pour moi. Si vous êtes intéressé, ce que vous devriez être, parlons chiffres.%SPEECH_OFF% | %employer% vous accueille, vous faisant signe d\'entrer.%SPEECH_ON%Très bien, maintenant que vous êtes ici, pourriez-vous fermer la porte derrière vous, s\'il vous plaît ?%SPEECH_OFF%L\'un des gardes de l\'homme poke sa tête autour du coin. Vous souriez en le laissant lentement dehors. En vous retournant, vous trouvez %employer% marchant vers une fenêtre. Il regarde dehors en parlant.%SPEECH_ON%J\'ai besoin de quelque chose... c\'est, euh, vous n\'avez pas besoin de savoir ce que c\'est. J\'ai besoin que ce \'quelque chose\' soit livré à un certain %recipient%. Il l\'attend à %objective%. Il est important qu\'il y arrive réellement, assez important pour un escorte armée pendant %days% de voyage, c\'est pourquoi je me tourne vers vous et votre compagnie. Que dites-vous, mercenaire ?%SPEECH_OFF% | Des bougies tamisées éclairent à peine la pièce assez pour que vous puissiez voir, c\'est %employer% assis derrière son bureau tandis que ses ombres dansent sur les murs au rythme des lumières vacillantes.%SPEECH_ON%Prêteriez-vous vos épées pour moi si je vous payais une bonne somme ? J\'ai besoin {d\'un petit coffre | de quelque chose de cher pour moi | de quelque chose de précieux} livré en toute sécurité à %recipient% à %objective%, environ %days% de voyage %direction% d\'ici. Des hommes se sont entretués pour cela, alors vous devez être prêt à le défendre de votre vie.%SPEECH_OFF%Il fait une pause, mesurant votre réponse.%SPEECH_ON%Je rédigerai une lettre scellée avec des instructions pour vous payer au fur et à mesure que vous livrerez l\'objet à mon contact à %objective%. Qu\'en dites-vous ?%SPEECH_OFF% | Un serviteur vous demande d\'attendre %employer%, qui, dit-il, sera bientôt avec vous. Et ainsi vous attendez, et attendez, et attendez. Et enfin, alors que vous êtes sur le point de partir pour la deuxième fois, %employer% ouvre grand les portes et se précipite vers vous.%SPEECH_ON%Qui est-ce, encore ? Le mercenaire ?%SPEECH_OFF%Son assistant hoche la tête et %employer% esquisse un sourire.%SPEECH_ON%Oh, le plus fortuit d\'avoir vous à %townname%, bon capitaine !\n\nIl est impératif que certaines de mes précieuses marchandises atteignent %objective% aussi sûrement et rapidement que possible. Vous êtes précisément celui dont j\'ai besoin, car aucun brigand commun n\'oserait vous attaquer, vous et vos hommes.\n\nOui, j\'aimerais vous embaucher pour l\'escorter. Assurez-vous que les articles soient livrés à %recipient%, sans détours bien sûr. Pouvons-nous nous entendre ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Parlons argent. | De combien de Couronnes parle-t-on?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas intéressé. | Nos voyages ne nous menerons pas là-bas avant un moment. | Ce n\'est pas le type de travail que nous recherchons.}",
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
			ID = "TaskSouthern",
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_112.png[/img]{L\'un des échevins du vizir s\'approche avec une suite de serviteurs. Ils transportent une caisse de taille modeste dans votre direction générale.%SPEECH_ON%Héritier de la couronne, le vizir a besoin de vous. Faites charger la caisse dans votre garde-robe, puis emmenez-la à %recipient% à %objective%, à une bonne distance de %days% par la route vers le %direction%.%SPEECH_OFF%L\'échevin s\'incline.%SPEECH_ON%Bien que la tâche puisse être simple, le vizir est prêt à payer une somme considérable pour l\'accomplissement de la tâche.%SPEECH_OFF% | Vous trouvez %employer% qui vous attend dans le hall. Il écoute une rangée de marchands, chacun avec sa propre demande ou offre, et pendant ce temps, un scribe à ses côtés prend des notes dans un registre qui se déroule de plus en plus sur le sol marbré. En vous voyant, le vizir claque des doigts et un homme sur le côté s\'approche.%SPEECH_ON%Héritier de la couronne, sa majesté souhaite faire appel à vos services. Prenez une caisse avec cette étiquette pour la livrer à %recipient% à %objective%, à environ %days% par la route. Vous serez récompensé à votre arrivée.%SPEECH_OFF% | Un homme coiffé d\'un chapeau orné de plumes de paon s\'approche de vous apparemment de nulle part. Il se faufile le long avec un registre à la main, bien que le registre porte l\'emblème de l\'un des vizirs de %townname% et de sa garde.%SPEECH_ON%%employer% souhaite faire appel à vos services, Héritier de la couronne. Vous devez manipuler un matériau de qualité, bien rangé loin de vos yeux diaboliques bien sûr, et le transporter secrètement à %recipient% à %objective%, situé à %days% par la route vers le %direction%. Une fois le matériau livré, vous serez alors payé à l\'endroit où vous êtes arrivé.%SPEECH_OFF%L\'homme écarte les plumes en arrière et secoue brièvement la tête.%SPEECH_ON%Trouvez-vous cette offre conforme à vos souhaits financiers actuels ?%SPEECH_OFF% | Vous êtes d\'abord salué par un pigeon avec une note, la note vous indique un jeune garçon qui vous emmène ensuite à un serviteur, le serviteur vous guide à travers un hall de harem de femmes nues après quoi vous arrivez à la chambre d\'un riche marchand.%SPEECH_ON%Ah, enfin, vous êtes arrivé. J\'ai confié une tâche simple à mes débiteurs et cela prend autant de temps pour être complété ? Je vais devoir vérifier cela.%SPEECH_OFF%Le marchand vous lance un registre et tombe simultanément dans un tas de coussins.%SPEECH_ON%Excusez-moi, le vizir a besoin que vous preniez une caisse de marchandises pour la livrer à %recipient% à %objective%, situé à %days% sur la route du %direction%. Vous ne devez pas ouvrir les marchandises, seulement les livrer. Si vous ouvrez les marchandises, le vizir en entendra parler. Et croyez-moi, Héritier de la couronne, le vizir aime seulement entendre des choses splendides. C\'est pourquoi je suis ici à la place de la majesté.%SPEECH_OFF%Quelle courtoisie.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Parlons argent. | De combien de Couronnes parle-t-on?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas intéressé. | Nos voyages ne nous menerons pas là-bas avant un moment. | Ce n\'est pas le type de travail que nous recherchons.}",
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
			ID = "Mercenaries1",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Sur la route, un groupe d\'hommes bien armés croise votre chemin. | En marchant vers %objective%, quelques hommes interrompent vos voyages tranquilles, le tintement de leurs armes et de leur armure emplissant l\'air alors qu\'ils se mettent en formation. | Vos voyages, malheureusement, ne seront pas simples. Plusieurs hommes se sont avancés devant vous, bloquant clairement votre chemin. | Quelques hommes armés et bien protégés sont sortis pour créer une sorte d\'impasse métallique. On dirait qu\'ils ont l\'intention de s\'assurer que vous n\'irez pas plus loin. | Quelques hommes s\'arrêtent. Vous allez à l\'avant pour comprendre ce qui se passe, pour voir une ligne d\'hommes bien armés se tenant devant %companyname%. Eh bien, cela devrait être intéressant.} Le lieutenant ennemi s\'avance et frappe sa poitrine avec son poing serré.%SPEECH_ON%{C\'est nous, le %mercband%, qui se dressons devant vous. Tueurs de bêtes au-delà de l\'imagination, le dernier espoir de cette terre maudite par les dieux ! | Nous sommes le %mercband% et nous sommes bien connus à travers cette terre en tant que pourfendeurs de têtes, buveurs de fûts et amoureux des dames ! | C\'est le légendaire %mercband% qui se tient devant vous. C\'est nous, sauveurs de %randomtown% et tueurs du faux roi ! | Contemplez ma fière bande, le %mercband%! Nous, qui avons repoussé une centaine d\'orques pour sauver une ville d\'un certain destin funeste. Qu\'avez-vous à votre actif ? | Vous parlez à un homme du %mercband%. Aucun brigand ordinaire, aucune vermine verte, aucun sac de pièces ou aucune jupe n\'a jamais échappé à notre vigilance !}%SPEECH_OFF%Après que l\'homme ait fini de parader et de faire son monologue personnel, il pointe du doigt la cargaison que vous transportez.%SPEECH_ON%{Maintenant que vous réalisez le danger dans lequel vous vous trouvez, pourquoi ne pas nous remettre cette cargaison ? | J\'espère que vous réalisez à qui vous avez affaire, misérable mercenaire, afin que vos hommes puissent rentrer chez eux ce soir. Il vous suffit de remettre la cargaison et nous n\'aurons pas à vous ajouter à l\'histoire du %mercband%. | Ah, je parie que vous aimeriez faire partie de notre histoire, n\'est-ce pas ? Eh bien, bonne nouvelle, tout ce que vous avez à faire, c\'est de ne pas remettre cette cargaison et nous vous inscrirons avec nos épées. Bien sûr, vous pouvez échapper à la plume du scribe si vous nous donnez simplement cette cargaison. | Maintenant, si ce n\'est pas le %companyname%. Autant j\'aimerais vous ajouter à notre liste de victoires, je vous donne une chance ici, mercenaire à mercenaire. Il vous suffit de remettre cette cargaison et nous serons en chemin. Comment ça sonne ?}%SPEECH_OFF%{Hmm, eh bien, c\'était une demande bombastique, c\'est le moins qu\'on puisse dire. | Eh bien, les effets de scène étaient plutôt divertissants, c\'est le moins qu\'on puisse dire. | Vous ne comprenez pas tout à fait le besoin de mise en scène, mais il ne fait aucun doute sur la gravité de la nouvelle situation dans laquelle vous vous trouvez. | Bien que vous ayez apprécié les superlatifs et l\'hyperbole, il reste la réalité très concise que ces hommes signifient effectivement des affaires.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Si tu le veux, viens le prendre !",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Mercs";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "Ça ne vaut pas la peine de mourir pour ça. Prends cette satanée cargaison et disparais.",
					function getResult()
					{
						return "Mercenaries2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Mercenaries2",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{N\'ayant pas envie d\'un combat, tu remets la cargaison. Ils rient en la prenant de tes mains.%SPEECH_ON%Bon choix, mercenaire. Peut-être qu\'un jour, c\'est toi qui feras les menaces.%SPEECH_OFF% | La cargaison, quoi qu\'elle soit, ne vaut pas la vie de tes hommes. Tu remets la caisse et les mercenaires la prennent. Ils rient de toi pendant que tu t\'en vas.%SPEECH_ON%Comme charmer une putain !%SPEECH_OFF% | Ce n\'est pas le moment ni l\'endroit pour sacrifier tes hommes au nom du service de livraison de %employer%. Tu remets la cargaison. Les mercenaires la prennent puis s\'en vont, leur lieutenant te lançant une couronne qui tournoie jusqu\'à la boue.%SPEECH_ON%Trouve-toi une boîte à cirage, gamin, ce boulot n\'est pas fait pour toi.%SPEECH_OFF% | Les mercenaires sont bien armés et tu ne sais pas si tu pourrais dormir la nuit en sachant que tu as sacrifié la vie de tes hommes juste pour une caisse idiote transportant Dieu sait quoi. D\'un signe de tête, tu remets la cargaison. La bande de mercenaires la prend volontiers, leur lieutenant faisant une pause pour te saluer d\'un signe de tête avec respect.%SPEECH_ON%Un choix sage. Ne pense pas que je n\'en ai pas fait beaucoup comme ça quand je montais en grade.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Hrm...",
					function getResult()
					{
						this.Flags.set("IsMercenaries", false);
						this.Flags.set("IsMercenariesDialogTriggered", true);

						if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to deliver cargo");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to deliver cargo");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 0.5);
						}

						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters1",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Sur les routes, tu tombes sur un groupe de chasseurs de primes. Leur prisonnier t\'appelle, sa voix se brise alors qu\'il implore que tu le sauves. Il prétend être un homme innocent. Les chasseurs de primes te disent d\'aller te faire foutre et de crever. | Tu voyages sur les routes quand tu tombes sur un groupe de chasseurs de primes bien armés. Ils traînent un homme enchaîné de la tête aux pieds.%SPEECH_ON%Tu ne veux rien avoir à faire avec ce type.%SPEECH_OFF%Un homme dit en frappant son prisonnier à l\'arrière des tibias. L\'homme pousse un cri et rampe vers toi sur des mains et des genoux ensanglantés.%SPEECH_ON%Ce sont tous des menteurs ! Ces hommes me tueront même si je n\'ai rien fait de mal ! Sauvez-moi, messieurs, je vous en prie !%SPEECH_OFF% | Tu tombes sur une grande bande de chasseurs de primes, tes deux groupes se reflétant étrangement, bien que vos objectifs dans ce monde divergent clairement. Ils transportent un prisonnier qui a été enchaîné et dont la bouche est bourrée de chiffon. L\'homme crie vers toi, presque en suppliant, s\'étouffant avec ses mots jusqu\'à ce qu\'il rougisse. Un des chasseurs de primes crache.%SPEECH_ON%Ne lui prête pas attention, étranger, et continue ton chemin. Il vaut mieux qu\'il n\'y ait pas de problème entre des hommes comme nous.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Si tu le veux, viens le prendre !",
					function getResult()
					{
						return 0;
					}

				},
				{
					Text = "Ce n\'est pas de nos affaires.",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "BountyHunters1" : "BountyHunters1";
					}

				},
				{
					Text = "Peut-être pouvons-nous acheter le prisonnier ?",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Mercs";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 140 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Thieves1",
			Title = "Pendant le camp...",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Vous vous levez d\'une sieste et vous retournez, cherchant le colis comme s\'il s\'agissait d\'un amant. Mais elle n\'est pas là, et le cargo non plus. Vous vous levez rapidement, ordonnant aux hommes de se mettre au garde-à-vous. %randombrother% accourt et dit qu\'il a suivi des empreintes de pas menant hors du site. | Pendant une pause, vous entendez un tumulte quelque part dans le camp. Vous vous précipitez pour trouver %randombrother% face contre terre, se frottant l\'arrière de la tête.%SPEECH_ON%Désolé, monsieur, je faisais pipi, et ils sont passés devant et l\'ont pris de moi. En plus, ils ont volé le colis.%SPEECH_OFF%Vous lui demandez de répéter cette dernière partie.%SPEECH_ON%Des putains de voleurs ont volé les marchandises !%SPEECH_OFF%Il est temps de traquer ces salauds et de les récupérer. | Naturellement, ce ne serait pas un voyage ordinaire. Non, ce monde est trop pourri pour que ce soit le cas. Il semble que des voleurs se soient enfuis avec le colis. Heureusement, ils ont laissé beaucoup de preuves, notamment des empreintes de pas et des traces de glissement indiquant le transport du paquet. Ils devraient être faciles à trouver... | Rien qu\'une fois, vous aimeriez faire une belle promenade d\'une ville à l\'autre. Au lieu de cela, votre accord avec %employer% a encore attiré des ennuis. Des voleurs ont réussi à se faufiler dans le camp et à s\'emparer du colis. La bonne nouvelle, c\'est qu\'ils n\'ont pas réussi à se faufiler à nouveau : vous avez trouvé leurs empreintes de pas et ils ne seront pas difficiles à suivre.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous suivons leurs traces !",
					function getResult()
					{
						this.Contract.setState("Running_Thieves");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Thieves2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Le sang des voleurs coule épais. Vous parvenez à retrouver les biens de votre employeur encore dans le camp, tous verrouillés et en sécurité. Il n\'a pas besoin de savoir pour cette petite excursion. | Eh bien, tout est là où ça devrait être. Le chargement de %employer% a été retrouvé sous le corps torturé d\'un voleur. Vous vous êtes assuré de le dégager avant de le transpercer. Après tout, vous ne voudriez pas salir le paquet avec du sang. | En tuant les derniers voleurs, vous et les hommes vous dispersez dans le camp des brigands à la recherche du colis. %randombrother% le repère très vite, le conteneur toujours entre les griffes d\'un imbécile mort. Le mercenaire tâtonne avec la prise du cadavre et, frustré, coupe tout simplement les bras du salaud. Vous récupérez le colis et le tenez un peu plus près pour le reste du voyage. | En regardant par-dessus les corps des voleurs abattus, vous vous demandez si %employer% a besoin de savoir cela. Le colis semble intact. Un peu de sang et d\'os, mais vous pouvez le frotter facilement. | Le colis est un peu éraflé, mais il ira bien. D\'accord, il y a du sang partout et un doigt écorché de voleur est tout écrasé dans l\'une des fermoirs. Ces problèmes mis à part, tout va parfaitement bien.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "De retour à sa place.",
					function getResult()
					{
						this.Flags.set("IsThieves", false);
						this.Flags.set("IsStolenByThieves", false);
						this.Contract.setState("Running");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EnragingMessage1",
			Title = "À %objective%",
			Text = "{Le cimetière est recouvert de brouillard - ou peut-être d\'une épaisse miasme émanant des morts. Attendez... ce SONT les morts ! Aux armes ! | Vous observez une pierre tombale avec une monticule de terre déterrée à sa base. Des taches de boue s\'éloignent comme un chemin de miettes. Il n\'y a pas de pelles... pas d\'hommes... En suivant la piste, vous tombez sur un groupe de morts-vivants gémissants et grognants... maintenant vous fixant d\'un regard insatiable de faim... | Un homme traîne profondément entre les rangées de pierres tombales. Il semble vaciller, comme s\'il était prêt à s\'évanouir. %randombrother% vient à vos côtés et hoche la tête.%SPEECH_ON%C\'est pas un homme, monsieur. Il y a des morts-vivants dans les parages.%SPEECH_OFF%Juste après avoir fini de parler, l\'étranger au loin se retourne lentement et là, dans la lumière, on voit qu\'il lui manque la moitié de son visage. | Vous découvrez que de nombreuses tombes sont vides. Non seulement vides, mais déterrées par en dessous. Ce n\'est pas le travail de profanateurs de tombes...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact1",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{En chemin, vous remarquez que quelque chose d\'autre bouge aussi : la cargaison. Le couvercle saute et il y a une étrange lueur qui en émane sur les côtés. %randombrother% s\'approche, regarde, puis vous regarde.%SPEECH_ON%Devrions-nous l\'ouvrir, monsieur ? Ou je peux le prendre et le jeter dans l\'étang le plus proche, car rien de tout ça n\'est normal.%SPEECH_OFF%Vous piquez l\'homme et lui demandez s\'il a peur. | En avançant sur les sentiers, vous commencez à entendre un bourdonnement provenant du colis que %employer% vous a confié. %randombrother% est à côté, le tapotant avec un bâton. Vous le giflez. Il s\'explique.%SPEECH_ON%Monsieur, il y a quelque chose qui ne va pas avec la cargaison que nous remorquons...%SPEECH_OFF%Vous y jetez un bon coup d\'œil. Il y a une légère couleur qui déborde aux bords du couvercle. Autant que vous sachiez, le feu ne peut pas respirer dans un tel espace, et la seule autre chose qui brille dans l\'obscurité sont les lunes et les étoiles. Vous vous inquiétez de plus en plus que la curiosité prenne le dessus sur vous... | La cargaison repose dans la charrette à côté de vous, se secouant au gré des inclinaisons et des virages des chemins. Soudain, elle commence à bourdonner et vous jurez avoir vu le couvercle flotter vers le haut pendant une seconde. %randombrother% jette un coup d\'œil.%SPEECH_ON{Tout va bien, monsieur ?}%SPEECH_OFF%Juste après avoir fini de parler, le couvercle explose vers l\'extérieur, un tourbillon de couleurs, de brume, de cendres, de chaleur ardente et de froid brutal. Vous levez les bras pour vous protéger, et lorsque vous jetez un coup d\'œil à travers vos coudes, le paquet est complètement immobile, le couvercle fermé. Vous échangez un regard avec le mercenaire, puis tous les deux fixent la cargaison. Cela pourrait être un peu plus qu\'une simple livraison ordinaire... | Un bourdonnement bas émane à proximité. Pensant à une ruche à proximité, vous vous baissez instinctivement, seulement pour réaliser que le son vient de la cargaison que %employer% vous avait remise. Le couvercle sur le dessus du conteneur claque de gauche à droite, secouant les loquets et les clous censés le maintenir en place. %randombrother% a l\'air un peu effrayé.%SPEECH_ON{Laissons-le simplement ici. Cette chose n\'est pas normale.}%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je veux savoir ce qui se passe.",
					function getResult()
					{
						return "EvilArtifact2";
					}

				},
				{
					Text = "Laissez cette chose tranquille.",
					function getResult()
					{
						this.Flags.set("IsEvilArtifact", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact2",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_73.png[/img]{La curiosité prend le dessus sur vous. Lentement, vous commencez à ouvrir le couvercle. %randombrother% recule d\'un pas et proteste.%SPEECH_ON%Je pense que nous devrions le laisser tranquille, monsieur. Je veux dire, regardez ça.%SPEECH_OFF%L\'ignorant, vous dites aux hommes que tout ira bien, puis vous soulevez le couvercle.\n\n Ce n\'est pas bien. L\'explosion vous renverse. Des formes horribles et des cris tourbillonnent autour de vous. Les hommes s\'arment instinctivement alors que les spectres pilotés se plantent dans la terre. Là, le sol se soulève en monticules, et là aussi, la terre commence à gémir. Vous regardez des mains surgir, traînant des corps décrépits de leur fosse. Les morts revivent et ils ont sûrement l\'intention d\'ajouter à leurs rangs ! | Contre le meilleur jugement de quiconque, vous ouvrez le chargement. Au début, il n\'y a rien. C\'est juste une boîte vide. %randombrother% rit nerveusement.%SPEECH_ON%Eh bien... je suppose que c\'est tout alors.%SPEECH_OFF%Mais ça ne peut pas être tout, n\'est-ce pas ? Pourquoi %employer% vous ferait-il livrer un conteneur vide à moins que -- \n\n Vous vous réveillez avec un bourdonnement qui s\'estompe lentement de vos oreilles. Vous vous retournez et voyez que la boîte s\'est complètement évaporée, une rafale de sciure de neige étant tout ce qui en reste. %randombrother% accourt, vous ramasse et vous traîne vers le reste de la compagnie. Ils pointent du doigt, leurs bouches bougent, criant...\n\n Une foule d\'hommes bien armés... se dirige vers vous ? En les observant de plus près, vous réalisez qu\'ils sont armés de vieux boucliers en bois peints de rites spirituels étranges, et leur armure est de formes et de tailles que vous n\'avez jamais vues auparavant, comme si elles étaient fabriquées par des hommes qui apprenaient tout juste le métier, mais qui étaient encore bien instruits dans ce qu\'ils avaient appris jusqu\'à présent. Ce sont comme des anciens... les premiers hommes. | %randombrother% secoue la tête pendant que vous allez chercher le couvercle. Avec un certain effort, vous le décollez et reculez rapidement, vous attendant au pire. Mais il n\'y a rien. Pas un son ne sort même de la boîte. Vous prenez une épée et la secouez dans la boîte vide, cherchant un compartiment secret ou quelque chose. %randombrother% rit.%SPEECH_ON%Eh bien, nous livrons juste de l\'air ! Et penser que je pensais que cette maudite chose était trop lourde !%SPEECH_OFF%À ce moment-là, la boîte s\'élève brièvement dans les airs, tourne et se précipite au sol. Elle se casse parfaitement, sans bruit, et sans mouvements inutiles, chaque morceau de bois reposant contre l\'herbe comme des œuvres de maçonnerie ancienne. Une forme incorporelle vous toise depuis les rites éclatés, grimaçant tout en se tordant.%SPEECH_ON%Oh, humains, c\'est vraiment bon de vous revoir.%SPEECH_OFF%La voix glisse comme de la glace dans votre dos. Vous regardez le spectre s\'envoler dans le ciel puis retomber, se plantant dans la terre même. Pas une seconde ne passe avant que le sol ne s\'éclate à mesure que les corps commencent à grimper dehors. | La boîte vous magnétise. Sans hésiter, vous ouvrez le chargement et jetez un coup d\'œil à l\'intérieur. Vous sentez avant de voir - une puanteur horripilante vous submerge presque au point de l\'aveuglement. Un des hommes vomit. Un autre rend. Quand vous regardez de nouveau la boîte, des volutes noircies s\'en échappent, s\'étirant longtemps et loin, sondant le sol pendant qu\'elles avancent. Lorsqu\'elles trouvent ce qu\'elles cherchent, elles plongent dans la terre, arrachant des os d\'hommes morts comme un leurre ferait un poisson. | Ignorant les inquiétudes de quelques hommes, vous cassez l\'emballage. Un tas de têtes est à l\'intérieur, leurs yeux lumineux s\'éveillant. Leurs mâchoires craquent en rires. Vous refermez rapidement la boîte, mais une force la pousse à se rouvrir. Vous luttez avec elle, %randombrother% et quelques autres essayant d\'aider, mais c\'est presque comme si les vents silencieux d\'une tempête résistaient contre vous.\n\nUn bref moment plus tard, vous êtes tous jetés en arrière, le couvercle de la caisse s\'élevant dans le ciel, porté vers le haut par une rafale d\'âmes noircies. Elles virevoltent, peignant la terre, puis se positionnent collectivement en face de %companyname%. Là, vous regardez avec horreur tandis que l\'incorporel commence à prendre forme, les brumes fantomatiques des âmes se durcissant en os bien réels d\'âmes perdues depuis longtemps. Et bien sûr, elles viennent armées, les mâchoires crépitantes résonnant encore de rires creux.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "EvilArtifact";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;

						if (this.Flags.get("IsCursedCrystalSkull"))
						{
							this.World.Flags.set("IsCursedCrystalSkull", true);
							p.Loot = [
								"scripts/items/accessory/legendary/cursed_crystal_skull"
							];
						}

						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.UndeadArmy, 120 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact3",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{La bataille terminée, vous vous précipitez rapidement vers l\'artefact, le trouvant flottant dans l\'air. %randombrother% court vers vous.%SPEECH_ON%Détruisez-le, monsieur, avant qu\'il ne cause plus de problèmes !%SPEECH_OFF% | Vos hommes n\'étaient pas la seule chose à survivre à la bataille - l\'artefact, ou ce qui reste de son pouvoir palpitant, flotte innocemment là où vous l\'aviez vu pour la dernière fois. La chose est une sphère tourbillonnante d\'énergie, tressautant occasionnellement, chuchotant parfois une langue que vous ne connaissez pas. %randombrother% fait un signe de tête vers lui.%SPEECH_ON%Écrasez-le, monsieur. Écrasez-le et en finissons avec cette horreur.%SPEECH_OFF% | Un tel pouvoir n\'était pas destiné à ce monde ! L\'artefact a pris la forme d\'une sphère de la taille de votre poing. Il flotte au-dessus du sol, bourdonnant comme s\'il chantait une chanson d\'un autre monde. La chose semble presque vous attendre, comme un chien attendrait son maître.%SPEECH_ON%Monsieur.%SPEECH_OFF%%randombrother% tire sur votre épaule.%SPEECH_ON%Monsieur, s\'il vous plaît, détruisez-le. Ne laissons pas cette chose faire un pas de plus avec nous !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous devons le détruire.",
					function getResult()
					{
						return "EvilArtifact4";
					}

				},
				{
					Text = "Nous sommes payés pour le livrer, c\'est donc ce que nous ferons.",
					function getResult()
					{
						this.Flags.set("IsEvilArtifact", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact4",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Vous sortez votre épée et vous tenez devant l\'artefact avec la lame lentement levée au-dessus de votre tête.%SPEECH_ON%Ne le faites pas !%SPEECH_OFF%Jetant un coup d\'œil par-dessus votre épaule, vous voyez %randombrother% et les autres hommes vous regarder d\'un air mécontent. Les ténèbres les entourent et le monde entier aussi loin que votre œil peut voir. Leurs yeux brillent en rouge, pulsant furieusement à chaque mot prononcé.%SPEECH_ON%Vous brûlerez éternellement ! Brûlez éternellement ! Détruisez-le et vous brûlerez ! Brûlez ! BRÛLEZ !%SPEECH_OFF%En criant, vous vous retournez et tranchez votre épée à travers le relique. Il se divise sans effort en deux et une vague de couleur balaye de nouveau votre monde. La sueur coule de votre front alors que vous vous retrouvez en train de vous appuyer sur le pommeau de votre arme. Vous regardez en arrière pour voir votre compagnie de mercenaires vous fixer.%SPEECH_ON%Monsieur, ça va ?%SPEECH_OFF%Vous remettez votre épée dans le fourreau et hochez la tête, mais vous ne vous êtes jamais senti aussi horrifié de toute votre vie. %employer% ne sera pas content, mais lui et sa colère peuvent être maudits ! | Tout aussi rapidement que la pensée de détruire la relique vous traverse l\'esprit, une vague de hurlements horrifiés vous traverse également. Les cris stridents de femmes et d\'enfants, leurs voix craquant de terreur comme s\'ils couraient tous vers vous en feu. Ils crient après vous dans des centaines de langues, mais de temps en temps, celle que vous connaissez vous parvient et c\'est toujours avec le même mot : NE LE FAITES PAS.\n\n Vous sortez votre épée et la balancez par-dessus votre tête. L\'artefact bourdonne et vibre. Des volutes de fumée s\'en échappent et une chaleur brutale vous submerge. NE LE FAITES PAS.\n\n Vous resserrez votre prise.\n\n Davkul. Yekh\'la. Imshudda. Pezrant. NE LE FAITES PAS.\n\nVous avalez et stabilisez votre visée.\n\n NE LE FAITES PAS.RAVWEET.URRLA.OSHARO.EBBURRO.MEHT\'JAKA.NE LE FAITES PAS.NE LE FAITES PAS.NE LE FAITES PAS.FAI--\n\n La frappe est vraie, le mot est perdu, l\'artefact tombe sur la terre en deux. Vous tombez avec lui, à genoux, et quelques-uns des frères de la compagnie viennent vous relever. %employer% ne sera pas content, mais vous ne pouvez vous empêcher de sentir que vous avez épargné à ce monde une horreur qu\'il ne devrait jamais voir ni entendre.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "C\'est fait.",
					function getResult()
					{
						this.Flags.set("IsEvilArtifact", false);

						if (this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to deliver cargo");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.m.Destination.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to deliver cargo");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 0.5);
						}

						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "EvilArtifact5",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Vous secouez la tête et prenez une autre caisse, poussant soigneusement l\'artefact flottant à l\'intérieur, puis refermez le couvercle. %employer% vous payait bien et, eh bien, vous avez l\'intention d\'aller jusqu\'au bout. Mais pour une raison quelconque, vous n\'êtes pas sûr si ce choix est le vôtre, ou si le chuchotement étrange de ce relique guide votre main pour vous. | Vous allez chercher un coffre en bois et le soulevez jusqu\'à l\'artefact, refermant rapidement le couvercle dessus. Quelques-uns des mercenaires secouent la tête. Ce n\'est probablement pas la meilleure des idées, mais pour une raison quelconque, vous vous sentez obligé de mener à bien votre tâche. | Le bon jugement dit que vous devriez détruire ce relique horrible, mais le bon jugement échoue une fois de plus. Vous prenez un coffre en bois et le placez au-dessus de l\'artefact avant de refermer le couvercle et de verrouiller les loquets. Vous n\'avez aucune idée de pourquoi vous faites cela, mais votre corps est rempli d\'une énergie nouvelle alors que vous vous apprêtez à reprendre la route.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous devrions continuer.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À %objective%",
			Text = "[img]gfx/ui/events/event_20.png[/img]{%recipient%\' vous attend alors que vous entrez dans la ville. Il prend précipitamment la cargaison de vos mains.%SPEECH_ON%Oh, ohhh je ne pensais pas que vous arriveriez.%SPEECH_OFF%Ses doigts sales dansent le long du coffre portant la cargaison. Il se retourne et donne un ordre à l\'un de ses hommes. Ils s\'avancent et vous remettent une bourse de couronnes. | Enfin, vous y êtes arrivé. %recipient% est là au milieu de la route, les mains serrées sur son estomac, un sourire malicieux sur son visage.%SPEECH_ON%Mercenaire, je n\'étais pas sûr que tu y arriverais.%SPEECH_OFF%Vous portez la cargaison et la remettez.%SPEECH_ON%Oh oui, et pourquoi dis-tu cela ?%SPEECH_OFF%L\'homme prend la boîte et la remet à un homme en robe qui s\'éloigne rapidement avec sous le bras. %recipient% rit en vous remettant une bourse de couronnes.%SPEECH_ON%Les routes sont difficiles ces jours-ci, n\'est-ce pas ?%SPEECH_OFF%Vous comprenez qu\'il fait de la petite conversation, tout pour attirer votre attention loin de la cargaison que vous venez de remettre. Peu importe, vous avez votre paiement, c\'est assez pour vous. | %recipient% vous accueille et quelques-uns de ses hommes s\'approchent rapidement pour prendre la cargaison. Il vous tape sur les épaules.%SPEECH_ON%Je suppose que votre voyage s\'est bien passé ?%SPEECH_OFF%Vous lui épargnez les détails et vous renseignez sur votre salaire.%SPEECH_ON%Bah, un mercenaire à travers et à travers. %randomname%! Donnez à cet homme ce qu\'il mérite !%SPEECH_OFF%Un des gardes du corps de %recipient% s\'approche et vous remet une petite boîte de couronnes. | Après quelques recherches, un homme demande qui vous cherchez. Quand vous dites %recipient%, il vous indique du doigt vers un paddock voisin où un homme se pavane sur un cheval plutôt opulent.\n\n Vous vous approchez et l\'homme cabre la monture et demande si c\'est la cargaison que %employer% a envoyée. Vous hochez la tête.%SPEECH_ON%Laissez-le là à vos pieds. Je viendrai le chercher.%SPEECH_OFF%Vous ne le faites pas, demandant plutôt votre salaire. L\'homme soupire et siffle à un garde du corps qui s\'approche rapidement.%SPEECH_ON%Assurez-vous que ce mercenaire reçoit le salaire qu\'il mérite.%SPEECH_OFF%Enfin, vous posez la caisse au sol et partez.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Delivered some cargo");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Delivered some cargo");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 0.5, "Delivered some cargo");
						}

						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.RecipientID).getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À %objective%",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%SPEECH_START%Ah, le Couronné.%SPEECH_OFF%La voix provient d\'une ruelle voisine. Habituellement, cela signifie que vous êtes sur le point de vous faire dérober de l\'argent, mais au lieu de cela, vous trouvez un homme qui vous offre de l\'or.%SPEECH_ON%Je suis %recipient%, et ce colis m\'appartient. Transmettez mes salutations à %employer%, ou ne le faites pas, je m\'en moque.%SPEECH_OFF%L\'homme s\'éloigne et disparaît aussi rapidement qu\'il est venu. | %recipient% est un homme trapu et il porte l\'emblème et la signalisation du Vizir comme s\'il était aussi lourd que la caisse que vous venez de lui apporter.%SPEECH_ON%J\'ai donné beaucoup au Vizir, et qu\'est-ce qu\'il utilise pour me payer ? La sueur d\'un Couronné. Puisse le Gilder cligner des yeux en regardant l\'avenir de cet homme.%SPEECH_OFF%Vous ne dites rien à cela, en partie parce que vous vous demandez si c\'est un \'test\' pour voir si vous serez d\'accord avec lui et vous révéler comme un ennemi du toujours majestueux Vizir. L\'homme vous fixe un moment, puis hausse les épaules et continue.%SPEECH_ON%J\'ai votre paiement ici. La pièce est entièrement prise en compte, bien que je n\'offense pas si vous souhaitez la compter vous-même. Ah, je vois que vous le faites déjà. Bien. Voyez ? Tout y est. Maintenant, filez, petit Couronné.%SPEECH_OFF% | Vous trouvez %recipient% en train de diriger une petite foule d\'enfants. Il vous repère rapidement et leur donne une leçon sur le fait de rester studieux de peur de finir comme vous. Après le départ des enfants, l\'homme s\'approche avec une bourse de couronnes.%SPEECH_ON%Mes hommes m\'ont dit que vous étiez arrivé et que le matériau était toujours en bon état. Voici votre paiement hétéroclite, Couronné.%SPEECH_OFF% | Vous entrez dans la maison de %recipient% où le colis est enfin déposé et emporté par des serviteurs. Vous fixant depuis un fauteuil confortable, %recipient% demande si votre voyage s\'est bien passé. Vous déclarez que les bavardages inutiles ne remplissent pas vos poches, puis vous vous renseignez sur votre salaire. L\'homme hausse un sourcil.%SPEECH_ON%Ah, ai-je offensé le Couronné avec mes sensibilités civilisées et aimables ? Comment osé-je. Eh bien alors, votre paiement est dans le coin et il est complet comme convenu.%SPEECH_OFF% | %recipient% disserte sur la nature des oiseaux devant un miroir. Lorsqu\'il vous voit dans le reflet, il se retourne et parle comme s\'il ne s\'était rien passé d\'inhabituel du tout.%SPEECH_ON%Un Couronné. Bien sûr que le Vizir envoie un Couronné. J\'aime imaginer que vous n\'avez pas osé profaner les matériaux de la caisse avec vos yeux, mais je ne peux même pas attendre une telle professionnalisme de votre genre. Mais vous pouvez vous y attendre de ma part : votre paiement est dans le coin, et en entier.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Delivered some cargo");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Delivered some cargo");
						}

						local recipientFaction = this.Contract.m.Destination.getFactionOfType(this.Const.FactionType.Settlement);

						if (recipientFaction != null)
						{
							recipientFaction.addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 0.5, "Delivered some cargo");
						}

						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.RecipientID).getImagePath());
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
		local days = this.getDaysRequiredToTravel(this.m.Flags.get("Distance"), this.Const.World.MovementSettings.Speed, true);
		_vars.push([
			"objective",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"recipient",
			this.m.Flags.get("RecipientName")
		]);
		_vars.push([
			"mercband",
			this.Const.Strings.MercenaryCompanyNames[this.Math.rand(0, this.Const.Strings.MercenaryCompanyNames.len() - 1)]
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"days",
			days <= 1 ? "un jour" : days + " jours"
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}

			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() || !this.m.Destination.isAlliedWithPlayer())
		{
			return false;
		}

		return true;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && _tile.ID == this.m.Destination.getTile().ID)
		{
			return true;
		}

		return false;
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

		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		_out.writeU32(this.m.RecipientID);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		this.m.RecipientID = _in.readU32();

		if (!this.m.Flags.has("Distance"))
		{
			this.m.Flags.set("Distance", 0);
		}

		this.contract.onDeserialize(_in);
	}

});


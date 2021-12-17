this.escort_envoy_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.escort_envoy";
		this.m.Name = "Escorter l\'émissaire";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

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

			if (s.getOwner() == null || s.getOwner().getID() == this.getFaction())
			{
				continue;
			}

			if (s.isIsolated() || !this.m.Home.isConnectedTo(s) || this.m.Home.isCoastal() && s.isCoastal())
			{
				continue;
			}

			candidates.push(s);
		}

		this.m.Destination = this.WeakTableRef(candidates[this.Math.rand(0, candidates.len() - 1)]);
		local distance = this.getDistanceOnRoads(this.m.Home.getTile(), this.m.Destination.getTile());
		this.m.Payment.Pool = this.Math.max(250, distance * 7.0 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult());

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local titles = [
			"l\'émissaire",
			"l\'émissaire"
		];
		this.m.Flags.set("EnvoyName", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.m.Flags.set("EnvoyTitle", titles[this.Math.rand(0, titles.len() - 1)]);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * this.Math.rand(75, 150) * 0.01));
		this.m.Flags.set("EnemyName", this.m.Destination.getOwner().getName());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Escortez %envoy% %envoy_title% à " + this.Contract.m.Destination.getName() + " %direction%"
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

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsShadyDeal", true);
					}
				}

				local envoy = this.World.getGuestRoster().create("scripts/entity/tactical/humans/envoy");
				envoy.setName(this.Flags.get("EnvoyName"));
				envoy.setTitle(this.Flags.get("EnvoyTitle"));
				envoy.setFaction(1);
				this.Flags.set("EnvoyID", envoy.getID());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Destination.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.World.getGuestRoster().getSize() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.Contract.setScreen("Arrival");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsShadyDeal"))
				{
					if (!this.Flags.get("IsShadyDealAnnounced"))
					{
						this.Flags.set("IsShadyDealAnnounced", true);
						this.Contract.setScreen("ShadyCharacter1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.World.State.getPlayer().getTile().HasRoad && this.Math.rand(1, 1000) <= 1)
					{
						local enemiesNearby = false;
						local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);

						foreach( party in parties )
						{
							if (!party.isAlliedWithPlayer)
							{
								enemiesNearby = true;
								break;
							}
						}

						if (!enemiesNearby && this.Contract.getDistanceToNearestSettlement() >= 6)
						{
							this.Contract.setScreen("ShadyCharacter2");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getID() == this.Flags.get("EnvoyID"))
				{
					this.World.getGuestRoster().clear();
				}
			}

		});
		this.m.States.push({
			ID = "Waiting",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Attendez autour de " + this.Contract.m.Destination.getName() + " jusqu\'à ce que %envoy% %envoy_title% ait terminé"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = true;
			}

			function update()
			{
				this.World.State.setUseGuests(false);

				if (this.Contract.isPlayerAt(this.Contract.m.Destination) && this.Time.getVirtualTimeF() >= this.Flags.get("WaitUntil"))
				{
					this.Contract.setScreen("Departure");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Escortez %envoy% %envoy_title% de nouveau à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				this.World.State.setUseGuests(true);

				if (this.World.getGuestRoster().getSize() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getID() == this.Flags.get("EnvoyID"))
				{
					this.World.getGuestRoster().clear();
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% a un homme debout à côté de lui. Vous pouvez à peine voir son visage et lorsque vous tournez la tête pour mieux voir, il fait de même pour s\'assurer que vous ne le voyez pas.%SPEECH_ON%S\'il vous plaît, mercenaire. Je vous présente %envoy%. Vous n\'avez pas besoin de le voir. J\'ai juste besoin que vous l\'ameniez à %objective%. Il y va pour les convaincre que notre cause vaut la peine d\'être rejointe. Bien sûr, %enemynoblehouse% ne sera pas contente, la discrétion est donc de mise.%SPEECH_OFF%Vous acquiescez, comprenant les subtilités de la politique entre les maisons nobles.%SPEECH_ON%Bien, mercenaire. Maintenant, êtes-vous intéressé ?%SPEECH_OFF% | Un homme, semblant sortir de l\'ombre du bureau de %employer%, s\'approche de vous avec une main tendue. Vous la serrez et il se présente.%SPEECH_ON%Je suis %envoy% au service de %employer% ici. Nous avons...%SPEECH_OFF%%employer% intervient.%SPEECH_ON%J\'ai besoin que vous protégiez cet homme jusqu\'à %objective%. C\'est le territoire de %enemynoblehouse%, donc un certain degré de discrétion est nécessaire. C\'est là que vous intervenez. Vous devez juste vous assurer que cet homme y arrive. Après ça, ramenez-le et vous serez payé. Est-ce que ça fait partie de votre domaine de travail et d\'expertise ?%SPEECH_OFF% | %employer% vous colle un parchemin dans la poitrine.%SPEECH_ON%Il y a un homme, un émissaire, qui se tient devant ma porte. Il s\'appelle %envoy% et il est censé aller à %objective% pour les convaincre de se joindre à nous.%SPEECH_OFF%Prenant le parchemin, vous vous renseignez sur le problème évident qui se pose : le fief de %enemynoblehouse%. %employer% acquiesce.%SPEECH_ON%Oui, c\'est ça. C\'est pourquoi vous êtes ici et pas un de mes hommes. Pas besoin de commencer une guerre, hein ? J\'ai juste besoin que vous ameniez %envoy% là-bas et que vous le rameniez. Si vous êtes intéressé, parlons chiffres, puis vous pourrez donner ce parchemin à l\'émissaire et repartir.%SPEECH_OFF% | En regardant une carte, %employer% vous demande si vous vous intéressez à la politique. Vous haussez les épaules et il acquiesce.%SPEECH_ON%Je m\'en doutais. Malheureusement, j\'ai un truc politique à vous faire faire. J\'ai besoin que vous gardiez un émissaire du nom de %envoy%. Il va avoir pour objectif de... eh bien, de faire des tâches de nature politique, en convainquant les gens là-bas de nous rejoindre, rien de bien méchant. Évidemment, ce n\'est pas notre territoire, c\'est pourquoi j\'engage un homme sans visage tel que vous. Sans vouloir vous offenser.%SPEECH_OFF%Vous faites comme si de rien n\'était. %employer% continue.%SPEECH_ON%Eh bien, si vous êtes intéressé, il suffit d\'amener l\'homme là-bas et de le ramener. Ça semble assez facile, non ? Vous n\'avez même pas besoin de parler !%SPEECH_OFF% | %employer% étudie une carte, plus particulièrement les couleurs qui indiquent où se trouvent ses frontières par rapport à %enemynoblehouse%. Il tape du poing dans leur côté des territoires.%SPEECH_ON%Très bien, mercenaire. J\'ai besoin d\'hommes robustes pour garder %envoy%, un de mes émissaires. Il va à %objective% qui, si vous vous y connaissez en politique, n\'est pas sous mon contrôle.%SPEECH_OFF%Vous acquiescez, indiquant au noble que vous comprenez les implications de ce qu\'il demande.%SPEECH_ON%Vous l\'emmenez là-bas, il fait la conversation, et vous le ramenez. En ce qui vous concerne, vous n\'êtes qu\'un simple soldat sans bannière qui le suit partout, compris ? Alors si vous êtes intéressé, parlons paiement, d\'accord ?%SPEECH_OFF% | %employer% jette sur sa table un morceau de papier abîmé, manifestement un rouleau de mauvaises nouvelles.%SPEECH_ON%Mes filles se marient, mais je n\'ai pas assez de territoires imposables pour leur offrir les célébrations qu\'elles méritent.%SPEECH_OFF%Vous vous en moquez et vous lui suggérez d\'en venir au fait.%SPEECH_ON%D\'accord, d\'accord. Mis à part les conneries, j\'ai besoin que vous gardiez un de mes émissaires, %envoy%, jusqu\'à %objective%. Il va essayer de les convaincre de passer sous notre bannière. Maintenant, ce petit endroit est le territoire de %enemynoblehouse% et il est raisonnable de supposer qu\'ils ne seront pas heureux de savoir que nous sommes sur leur territoire. C\'est pourquoi je vous engage, mercenaire sans visage, pour être le gardien de mon émissaire.%SPEECH_OFF%L\'homme replie ses mains sur ses genoux.%SPEECH_ON%Est-ce que ce petit pari vous intéresse ? Tout ce que vous avez à faire, c\'est de l\'emmener et de le ramener. Un travail facile, pour une paie facile !%SPEECH_OFF% | En lisant un parchemin, %employer% se met à rire, puis semble incapable de s\'empêcher de sourire.%SPEECH_ON%Bonne nouvelle, mercenaire ! Le peuple de %enemynoblehouse% ne semble plus satisfait de son règne !%SPEECH_OFF%Vous levez un sourcil et acquiescez avec facétie. Déplaçant sa chaise jusqu\'à son bureau et examinant une carte posée dessus, l\'homme continue.%SPEECH_ON%La meilleure nouvelle est que j\'ai un émissaire du nom de %envoy% qui se rend à %objective% aujourd\'hui pour faire quelques... discussions. Évidemment, les routes sont remplies de voleurs sournois et les seigneurs de %enemynoblehouse% sont les plus sournois, alors cet homme a besoin de protection ! C\'est là que vous intervenez. Tout ce que vous avez à faire, c\'est de l\'emmener et de le ramener.%SPEECH_OFF% | %employer% a un homme debout à côté de lui. Il vous serre la main et se présente comme %envoy%, un émissaire en quelque sorte. Vous vous renseignez sur l\'importance de cet homme et %employer% s\'empresse de vous expliquer.%SPEECH_ON%Il va à %objective%, un fief de %enemynoblehouse%, si vous ne le savez pas. Nous pourrons peut-être persuader les gens d\'ici de se soumettre à notre autorité. Maintenant que vous connaissez cet homme et sa mission, vous comprenez sûrement pourquoi vous êtes ici et pas un de mes hommes.\n\nJ\'ai besoin que vous ameniez cet homme à %objective% et ensuite, quand il aura terminé ce qu\'il doit faire, ramenez-le. Après ça, vous serez payé. Vous en êtes ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Parlons argent. | Combien cela vaut-il pour vous ? | Quel sera le salaire ?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Vous devrez trouver une protection ailleurs. | Ce n\'est pas le type de travail que nous recherchons.}",
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
			ID = "Arrival",
			Title = "À %objective%",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Vous êtes arrivé à %objective%. %envoy% %envoy_title% entre dans un bâtiment, fermant discrètement la porte derrière lui. Vous posez une botte contre le mur et attendez qu\'il revienne. Quelques paysans vont et viennent. Les oiseaux gazouillent. Cela fait longtemps que vous n\'avez pas prêté attention à leurs chants.\n\nCela pourrait prendre un certain temps, il semble. Peut-être devriez-vous utiliser ce temps pour faire des provisions pour le voyage de retour ? | L\'émissaire entre dans un bâtiment à %objective%. Vous l\'avez amené là en toute sécurité, maintenant il ne lui reste plus qu\'à faire le reste. Pendant un moment, vous écoutez la conversation, appuyé contre l\'une des fenêtres et vous en imprégnant. L\'homme a la langue bien pendue et il rallie les hommes à sa cause mieux que vous et quelques épées ne le pourriez. L\'émissairevous voit à travers la fenêtre et vous fait subtilement signe de partir. Vous vous esquivez et attendez qu\'il ait terminé. | Quelques hommes bien habillés vous accueillent dans %objective%. Ils demandent à %envoy% %envoy_title% si vous êtes avec lui. Il acquiesce et passe un rapide murmure aux conseillers. Ils hochent la tête en retour et bientôt tous les hommes se rendent dans un pub local. Vous attendez dehors. Peut-être devriez-vous en profiter pour faire le plein de provisions pour le voyage de retour ? | Les soupçons de %employer% sur le fait que %objective% pourrait se tourner vers sa cause semblent se vérifier : les gens ici sont déjà dans les rues en une grande foule. Une rangée de gardes se tient à l\'extérieur d\'un grand bâtiment et se repousse avec leurs lances tournées de côté. Un homme riche se penche par la fenêtre pour essayer de disperser la foule avec des mots, mais ses oreilles sont trop remplies de colère. %envoy% se faufile dans la foule avec aisance et rencontre quelques conseillers en cape. Ils se glissent dans un bâtiment voisin et vous attendez dehors. | L\'ambiance à %objective% semble plutôt mauvais. Les paysans dans la rue sont soit en colère pour quelque chose, soit paresseux pour rien. C\'est un bon signe pour une communauté saine. %envoy% %envoy_title% entre dans un pub local où un groupe d\'hommes recroquevillés l\'accueille prudemment. Il vous fait signe de partir et vous restez dehors à attendre qu\'il ait fini.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Ça ne va pas durer une éternité. | Nous allons rester dans le coin.}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(20, 60) * 1.0);
				this.Contract.setState("Waiting");
			}

		});
		this.m.Screens.push({
			ID = "Departure",
			Title = "À %objective%",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Un certain temps s\'écoule avant que l\'émissaire ne ressorte. Vous lui demandez s\'il a eu des problèmes, ce à quoi il répond par non. Il est temps de retournez voir %employer%. | La porte s\'ouvre et l\'émissaire sort. Il vous dit d\'ouvrir le chemin vers la maison. | Très vite, l\'émissaire est de retour. Il vous dit que son travail est terminé et qu\'il doit retourner voir %employer%. | %envoy% revient vers vous en toute hâte. Il vous dit qu\'il doit retourner voir %employer% le plus vite possible. | Lorsque l\'émissaire revient, il dit que la discussion a été fructueuse et que vous devez le ramener voir %employer% dès que possible.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Enfin, allons-y ! | Qu\'est-ce qui vous a pris si longtemps ?}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter1",
			Title = "À %townname%",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Au moment où vous quittez la ville, un homme en cape vient vous parler. Il garde son visage dans l\'ombre de son manteau, on ne voit que ses dents de temps en temps et la pointe d\'un menton pointu.%SPEECH_ON%Quand le moment sera venu, regarderez-vous ailleurs, mercenaire ?%SPEECH_OFF%Avant que vous ne puissiez répondre, il est parti. | Alors que vous vous apprêtez à quitter la ville, un homme vous heurte. Il ne s\'excuse pas, mais jette un coup d\'oeil sous un long manteau noir.%SPEECH_ON%Il y aura un moment où vous devrez prendre une décision. Rester et se battre, ou partir et vivre pour voir un autre jour. L\'or vous suivra sur la deuxième route, une pelle vous enterrera sur la première...%SPEECH_OFF%Vous tendez le bras pour attraper l\'homme, mais il recule simplement, absorbé par une foule. | Alors que vous vous apprêtez à quitter %townname%, un homme vêtu d\'une cape sombre vient à vos côtés. Il ne vous regarde pas, il se contente de parler.%SPEECH_ON%Mon bienfaiteur vous attendait. %employer% a été sage de vous engager. Cependant, vous avez le choix et quand le moment sera venu... quel chemin emprunterez-vous ?%SPEECH_OFF%Vous dites à l\'homme d\'emmener ses présages ailleurs. | Un homme en noir vous coupe la route alors que vous quittez la présence de %employer%. Il jette un coup d\'œil par-dessus vos épaules, puis chuchote.%SPEECH_ON%%employer% vous paie bien, mais je connais quelqu\'un qui paiera encore mieux. Regarder ailleurs quand le moment sera venu...%SPEECH_OFF%L\'étranger fait un pas en arrière et se glisse derrière une porte. Lorsque vous l\'ouvrez pour le poursuivre, il a disparu. Seul un commis de cuisine est là, l\'air de n\'avoir rien vu du tout. | Avec la tâche de %employer% en main, vous vous préparez à partir. Alors que vous préparez les provisions, un étranger vêtu d\'une cape s\'approche. Il parle comme s\'il avait du gravier dans la gorge.%SPEECH_ON%De nombreux oiseaux vous observent, mercenaire. Faites attention à vos prochains pas. Vous avez encore une chance de vous en sortir. Quand le moment sera venu, nous vous demandons simplement de vous écarter.%SPEECH_OFF%Vous tirez votre épée pour menacer l\'homme, mais il s\'éloigne, sa cape flottante se glissant dans une foule de paysans qui semblent alarmés par votre armement soudain.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Ça pourrait devenir intéressant... | On dirait que les problèmes se préparent.}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter2",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Sur votre chemin, un groupe d\'hommes armés surgit de nulle part pour vous barrer la route. Parmi eux se trouve le personnage louche que vous avez vu plus tôt. Ils annoncent leur intention de vous débarrasser de l\'émissaire. En échange, vous recevrez une grosse somme d\'argent - %bribe% couronnes.\n\nSinon, eh bien, ils devront le prendre de force... | Vous êtes en train de vous mettre dans le bain, d\'écouter les plaisanteries de l\'émissaire, de les ignorer, de souhaiter qu\'il parte seuls dans les bois pour ne jamais revenir, quand soudain un groupe d\'hommes armés vous surprend. L\'étranger qui vous a rencontré plus tôt se tient à leurs côtés. Ils déclarent que l\'émissaire doit leur être remis. En retour, vous recevrez la somme de %bribe% couronnes. Si vous refusez, ils utiliseront des méthodes plus violentes.\n\nAlors que vous réfléchissez à vos options, l\'émissaire est, pour une fois, complètement silencieux. | En marchant sur la route, un groupe d\'hommes armés sort pour vous arrêter. Vous reconnaissez l\'étranger de tout à l\'heure qui se tient avec eux. Ils vous demandent de leur remettre l\'émissaire, en montrant d\'un geste une très grande sacoche de couronnes, la somme de %bribe% couronnes qu\'ils proposent. Ils montrent également leurs armes d\'un geste, ce qui suggère qu\'ils sont prêts à utiliser d\'autres moyens si vous refusez.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Pourquoi saigner pour des couronnes quand on les offre gratuitement ? Nous avons un accord.",
					function getResult()
					{
						return "ShadyCharacter3";
					}

				},
				{
					Text = "Si vous le voulez, venez le chercher.",
					function getResult()
					{
						return "ShadyCharacter4";
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.Flags.set("IsShadyDeal", false);
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter3",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Alors que vous réfléchissez à cette idée, l\'émissaire vient à vos côtés, en chuchotant.%SPEECH_ON%Vous ne les laisserez pas me prendre, n\'est-ce pas ? %employer% vous paie bien pour assurer ma sécurité.%SPEECH_OFF%Vous acquiescez, posez une main sur l\'épaule de l\'homme et chuchotez.%SPEECH_ON%Vous avez raison. Il me paie. Mais ils me paient plus.%SPEECH_OFF%Avec ça, vous poussez l\'homme en avant. Il proteste, mais il est coupé court par le bout d\'une épée. Le sang gicle sur le sol et lorsque la lame est retirée, un tas de tripes la suit. Le mystérieux étranger vous tend une sacoche contenant les couronnes promises.%SPEECH_ON%Un plaisir de faire affaire avec vous, mercenaire.%SPEECH_OFF% | Vous fixez l\'émissaire, puis les hommes mystérieux, en leur faisant un signe de tête. Il s\'agrippe à votre chemise, suppliant.%SPEECH_ON%Non, vous ne pouvez pas ! Vous avez promis à %employer% que je serais en sécurité !%SPEECH_OFF%Vous lui remettez l\'homme. Ils lui tranchent la gorge en un instant et il tombe à genoux, les doigts enroulés autour de sa blessure tandis que le sang jaillit. Les tueurs lui donnent des coups de pied, l\'émissaire s\'immobilise lentement tandis qu\'une bande d\'hommes se moque de son passage dans l\'autre monde. Une sacoche atterrit dans vos mains et l\'homme qui l\'a mise là vous tape sur l\'épaule.%SPEECH_ON%Merci pour votre coopération, mercenaire. Vous êtes vraiment à la hauteur de votre titre.%SPEECH_OFF% | Vous regardez l\'émissaire et secouez la tête.%SPEECH_ON%Je suis un mercenaire, et mon prix est ce qu\'il est.%SPEECH_OFF%L\'émissaire crie, mais un homme s\'approche avec une petite arbalète et tire un carreau entre ses yeux, la tige sortant à l\'arrière de sa tête, enveloppée de matière cérébrale. L\'homme mystérieux vous lance une sacoche de couronnes.%SPEECH_ON%Qu\'est-ce qui vous faisait hésité la pitié, ou les bonnes grâces ?%SPEECH_OFF%Vous comptez les couronnes et répondez.%SPEECH_ON%C\'était les deux jusqu\'à ce que votre homme là-bas ajoute un peu de charpenterie au crâne de l\'émissaire. Maintenant, c\'est juste des bonnes grâces.%SPEECH_OFF%L\'homme mystérieux sourit ironiquement.%SPEECH_ON%C\'est dommage. Personnellement, j\'aime la diversité d\'opinions. Cela ajoute du drame, comme on dit.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Des couronnes faciles. | Tout le monde y gagne.}",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", true);
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "N\'a pas réussi à protéger un émissaire.");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.updateAchievement("NeverTrustAMercenary", 1, 1);
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "ShadyCharacter4",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_50.png[/img]{Vous poussez l\'émissaire derrière vous d\'un bras tandis que l\'autre dégaine votre épée. L\'homme mystérieux acquiesce et s\'efface lentement derrière sa propre ligne de combat.%SPEECH_ON%C\'est dommage, mais mes affaires ici doivent être poursuivies. Je suis sûr que vous comprenez.%SPEECH_OFF% | L\'homme mystérieux tend un bras, les doigts de la main s\'enroulent comme pour éloigner l\'émissaire de vous. Au lieu de cela, vous repoussez l\'émissaire derrière votre ligne de combat. L\'étranger hoche instantanément la tête.%SPEECH_ON%Compréhensible. Mais pas punissable. Nous avons tous deux nos bienfaiteurs, mercenaire. Vous devez être loyal envers les vôtres et moi envers les miens. Que les meilleurs d\'entre nous restent debout pour récompenser ceux qui ont mis leur foi dans nos mains.%SPEECH_OFF% | L\'émissaire vous supplie, mais vous lui dites de se taire avant de vous retourner vers le groupe de tueurs.%SPEECH_ON%L\'émissaire sortira d\'ici en vie.%SPEECH_OFF%En hochant la tête, le mystérieux étranger s\'efface simplement derrière la ligne de combat.%SPEECH_ON%Je comprends. Les affaires sont les affaires, et pour l\'instant, ces affaires doivent être résolues.%SPEECH_OFF%Ses hommes s\'avancent, tirant leurs épées.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Mercs";
						p.Entities = [];
						p.Parties = [];
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getGuestRoster().get(0).getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous retournez voir %employer%, l\'émissaire à vos côtés.%SPEECH_ON%Ah, mercenaire, je vois que vous avez fait ce que j\'ai demandé. Et vous, émissaire... ?%SPEECH_OFF%%envoy% se penche en avant et chuchote à l\'oreille du noble. Il se penche en arrière et acquiesce.%SPEECH_ON%Bien, bien. Parlons... Oh, et mercenaire, votre paie vous attend dehors. Demandez à l\'un des gardes.%SPEECH_OFF%Les deux hommes se retournent et s\'éloignent. Vous sortez dans le hall et un homme costaud est là pour vous remettre une sacoche de %reward_completion% couronnes. | De retour auprès de %employer%, l\'émissaire vous laisse et lui annonce rapidement - et discrètement - quelques nouvelles. %employer% hoche la tête, sans rien révéler de ces nouvelles, puis fait un signe du doigt à un garde proche. L\'homme armé s\'avance et vous tend une sacoche. Le temps que vous la preniez et que vous leviez les yeux, le noble et l\'émissaire sont partis. | Ayant assuré la sécurité de %envoy%, l\'émissaire vous remercie de vos services. %employer% n\'est pas aussi amical, préférant vous ignorer pour parler au mystérieux émissaire. Alors que vous attendez d\'être payé, un garde s\'approche furtivement et vous tend un coffre en bois.%SPEECH_ON%Voilà %reward_completion% couronnes. Vous pouvez les compter si vous voulez.%SPEECH_OFF% | Vous n\'apprenez pas grand-chose sur ce que le petit émissaire sournois de %employer% faisait dans cette ville. L\'émissaire et l\'employeur vous saluent et discutent immédiatement, se serrant l\'un contre l\'autre et parlant à voix basse. Lorsque vous faites un pas en avant pour vous renseigner sur le salaire, un garde vous intercepte et vous remet une sacoche. Les %reward_completion% couronnes sont là, comme promis. N\'ayant aucun intérêt pour la politique, vous ne restez pas longtemps dans les parages pour voir ce que ces deux hommes ont en tête. | %employer% vous accueille à bras ouverts.%SPEECH_ON%Ah, vous avez gardé %envoy% en sécurité !%SPEECH_OFF%Il enlace l\'émissaire, mais ne fait que vous serrer la main, la croisant avec une bourse de couronnes en même temps.%SPEECH_ON%Je savais que je pouvais vous faire confiance, mercenaire. Maintenant, s\'il vous plaît...%SPEECH_OFF%Il fait un geste vers la porte. Vous partez, laissant les deux hommes discuter.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "L\'émissaire a été escorté en toute sécurité.");
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
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Après la bataille",
			Text = "[img]gfx/ui/events/event_60.png[/img]{L\'émissaire ne s\'en est pas sorti. %employer% peut accepter des pertes ici et là, mais il ne va pas être content de ça. Essayez de ne pas le décevoir à nouveau. | Malheureusement, %envoy% %envoy_title% est mort à vos pieds. Quel destin terrible pour un homme auquel vous aviez promis la sécurité ! Mais bon. À l\'avenir, il vaudrait mieux ne pas décevoir %employer%. | Eh bien, voyez-vous ça : l\'émissaire est mort. Votre seul travail était de garder cet homme en vie. Maintenant, il ne l\'ai plus. Pas besoin de parler à %employer% pour savoir qu\'il ne sera pas content. | Vous avez promis de garder l\'émissaire à l\'abri du danger. Une fois mort il est difficile d\'être pluis blessé, donc il semble que vous ayez échoué de façon spectaculaire dans cette tâche. | Protégez l\'émissaire. Gardez l\'émissaire en vie. L\'émissaire doit survivre. Hé, je suis un émissaire, je suis trop important pour mourir !\n\nCes mots ont dû tomber dans l\'oreille d\'un sourd car l\'émissaire est bel et bien mort. | C\'est dur de garder un homme en vie quand le monde veut sa mort. Malheureusement, %envoy% %envoy_title% n\'a pas survecu au voyage. %employer% ne sera probablement pas content de cette âme perdue.}",
			Image = "",
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Merde !",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to protect an envoy");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
		_vars.push([
			"envoy",
			this.m.Flags.get("EnvoyName")
		]);
		_vars.push([
			"envoy_title",
			this.m.Flags.get("EnvoyTitle")
		]);
		_vars.push([
			"enemynoblehouse",
			this.m.Flags.get("EnemyName")
		]);
		_vars.push([
			"direction",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())] : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Destination.getSprite("selection").Visible = false;
			this.m.Home.getSprite("selection").Visible = false;
			this.World.State.setUseGuests(true);
			this.World.getGuestRoster().clear();
		}
	}

	function onIsValid()
	{
		if (this.World.FactionManager.isCivilWar())
		{
			return false;
		}

		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			local settlements = this.World.EntityManager.getSettlements();
			local hasPotentialDestination = false;

			foreach( s in settlements )
			{
				if (!s.isDiscovered() || s.isMilitary() || s.isIsolated())
				{
					continue;
				}

				if (s.getOwner() == null || s.getOwner().getID() == this.getFaction())
				{
					continue;
				}

				hasPotentialDestination = true;
				break;
			}

			if (!hasPotentialDestination)
			{
				return false;
			}

			return true;
		}
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

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local dest = _in.readU32();

		if (dest != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(dest));
		}

		this.contract.onDeserialize(_in);
	}

});


this.escort_envoy_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.escort_envoy";
		this.m.Name = "Escorter l'émissaire";
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
			"l'émissaire",
			"l'émissaire"
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% a un homme debout à côté de lui. Vous pouvez à peine voir son visage et lorsque vous tournez la tête pour mieux voir, il fait de même pour s'assurer que vous ne le voyez pas.%SPEECH_ON%S'il vous plaît, mercenaire. Je vous présente %envoy%. Vous n'avez pas besoin de le voir. J'ai juste besoin que vous l'ameniez à %objective%. Il y va pour les convaincre que notre cause vaut la peine d'être rejointe. Bien sûr, %enemynoblehouse% ne sera pas contente, la discrétion est donc de mise.%SPEECH_OFF%Vous acquiescez, comprenant les subtilités de la politique entre les maisons nobles.%SPEECH_ON%Bien, mercenaire. Maintenant, êtes-vous intéressé ?%SPEECH_OFF% | Un homme, semblant sortir de l'ombre du bureau de %employer%, s'approche de vous avec une main tendue. Vous la serrez et il se présente.%SPEECH_ON%Je suis %envoy% au service de %employer% ici. Nous avons...%SPEECH_OFF%%employer% intervient.%SPEECH_ON%J'ai besoin que vous protégiez cet homme jusqu'à %objective%. C'est le territoire de %enemynoblehouse%, donc un certain degré de discrétion est nécessaire. C'est là que vous intervenez. Vous devez juste vous assurer que cet homme y arrive. Après ça, ramenez-le et vous serez payé. Est-ce que ça fait partie de votre domaine de travail et d'expertise ?%SPEECH_OFF% | %employer% vous colle un parchemin dans la poitrine.%SPEECH_ON%Il y a un homme, un émissaire, qui se tient devant ma porte. Il s'appelle %envoy% et il est censé aller à %objective% pour les convaincre de se joindre à nous.%SPEECH_OFF%Prenant le parchemin, vous vous renseignez sur le problème évident qui se pose : le fief de %enemynoblehouse%. %employer% acquiesce.%SPEECH_ON%Oui, c'est ça. C'est pourquoi vous êtes ici et pas un de mes hommes. Pas besoin de commencer une guerre, hein ? J'ai juste besoin que vous ameniez %envoy% là-bas et que vous le rameniez. Si vous êtes intéressé, parlons chiffres, puis vous pourrez donner ce parchemin à l'émissaire et repartir.%SPEECH_OFF% | En regardant une carte, %employer% vous demande si vous vous intéressez à la politique. Vous haussez les épaules et il acquiesce.%SPEECH_ON%Je m'en doutais. Malheureusement, j'ai un truc politique à vous faire faire. J'ai besoin que vous gardiez un émissaire du nom de %envoy%. Il va avoir pour objectif de... eh bien, de faire des tâches de nature politique, en convainquant les gens là-bas de nous rejoindre, rien de bien méchant. Évidemment, ce n'est pas notre territoire, c'est pourquoi j'engage un homme sans visage tel que vous. Sans vouloir vous offenser.%SPEECH_OFF%Vous faites comme si de rien n'était. %employer% continue.%SPEECH_ON%Eh bien, si vous êtes intéressé, il suffit d'amener l'homme là-bas et de le ramener. Ça semble assez facile, non ? Vous n'avez même pas besoin de parler !%SPEECH_OFF% | %employer% étudie une carte, plus particulièrement les couleurs qui indiquent où se trouvent ses frontières par rapport à %enemynoblehouse%. Il tape du poing dans leur côté des territoires.%SPEECH_ON%Très bien, mercenaire. J'ai besoin d'hommes robustes pour garder %envoy%, un de mes émissaires. Il va à %objective% qui, si vous vous y connaissez en politique, n'est pas sous mon contrôle.%SPEECH_OFF%Vous acquiescez, indiquant au noble que vous comprenez les implications de ce qu'il demande.%SPEECH_ON%Vous l'emmenez là-bas, il fait la conversation, et vous le ramenez. En ce qui vous concerne, vous n'êtes qu'un simple soldat sans bannière qui le suit partout, compris ? Alors si vous êtes intéressé, parlons paiement, d'accord ?%SPEECH_OFF% | %employer% jette sur sa table un morceau de papier abîmé, manifestement un rouleau de mauvaises nouvelles.%SPEECH_ON%Mes filles se marient, mais je n'ai pas assez de territoires imposables pour leur offrir les célébrations qu'elles méritent.%SPEECH_OFF%Vous vous en moquez et vous lui suggérez d'en venir au fait.%SPEECH_ON%D'accord, d'accord. Mis à part les conneries, j'ai besoin que vous gardiez un de mes émissaires, %envoy%, jusqu'à %objective%. Il va essayer de les convaincre de passer sous notre bannière. Maintenant, ce petit endroit est le territoire de %enemynoblehouse% et il est raisonnable de supposer qu'ils ne seront pas heureux de savoir que nous sommes sur leur territoire. C'est pourquoi je vous engage, mercenaire sans visage, pour être le gardien de mon émissaire.%SPEECH_OFF%L'homme replie ses mains sur ses genoux.%SPEECH_ON%Est-ce que ce petit pari vous intéresse ? Tout ce que vous avez à faire, c'est de l'emmener et de le ramener. Un travail facile, pour une paie facile !%SPEECH_OFF% | En lisant un parchemin, %employer% se met à rire, puis semble incapable de s'empêcher de sourire.%SPEECH_ON%Bonne nouvelle, mercenaire ! Le peuple de %enemynoblehouse% ne semble plus satisfait de son règne !%SPEECH_OFF%Vous levez un sourcil et acquiescez avec facétie. Déplaçant sa chaise jusqu'à son bureau et examinant une carte posée dessus, l'homme continue.%SPEECH_ON%La meilleure nouvelle est que j'ai un émissaire du nom de %envoy% qui se rend à %objective% aujourd'hui pour faire quelques... discussions. Évidemment, les routes sont remplies de voleurs sournois et les seigneurs de %enemynoblehouse% sont les plus sournois, alors cet homme a besoin de protection ! C'est là que vous intervenez. Tout ce que vous avez à faire, c'est de l'emmener et de le ramener.%SPEECH_OFF% | %employer% a un homme debout à côté de lui. Il vous serre la main et se présente comme %envoy%, un émissaire en quelque sorte. Vous vous renseignez sur l'importance de cet homme et %employer% s'empresse de vous expliquer.%SPEECH_ON%Il va à %objective%, un fief de %enemynoblehouse%, si vous ne le savez pas. Nous pourrons peut-être persuader les gens d'ici de se soumettre à notre autorité. Maintenant que vous connaissez cet homme et sa mission, vous comprenez sûrement pourquoi vous êtes ici et pas un de mes hommes.\n\nJ'ai besoin que vous ameniez cet homme à %objective% et ensuite, quand il aura terminé ce qu'il doit faire, ramenez-le. Après ça, vous serez payé. Vous en êtes ?%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{Vous êtes arrivé à %objective%. %envoy% %envoy_title% entre dans un bâtiment, fermant discrètement la porte derrière lui. Vous posez une botte contre le mur et attendez qu'il revienne. Quelques paysans vont et viennent. Les oiseaux gazouillent. Cela fait longtemps que vous n'avez pas prêté attention à leurs chants.\n\nCela pourrait prendre un certain temps, il semble. Peut-être devriez-vous utiliser ce temps pour faire des provisions pour le voyage de retour ? | L'émissaire entre dans un bâtiment à %objective%. Vous l'avez amené là en toute sécurité, maintenant il ne lui reste plus qu'à faire le reste. Pendant un moment, vous écoutez la conversation, appuyé contre l'une des fenêtres et vous en imprégnant. L'homme a la langue bien pendue et il rallie les hommes à sa cause mieux que vous et quelques épées ne le pourriez. L'émissairevous voit à travers la fenêtre et vous fait subtilement signe de partir. Vous vous esquivez et attendez qu'il ait terminé. | Quelques hommes bien habillés vous accueillent dans %objective%. Ils demandent à %envoy% %envoy_title% si vous êtes avec lui. Il acquiesce et passe un rapide murmure aux conseillers. Ils hochent la tête en retour et bientôt tous les hommes se rendent dans un pub local. Vous attendez dehors. Peut-être devriez-vous en profiter pour faire le plein de provisions pour le voyage de retour ? | Les soupçons de %employer% sur le fait que %objective% pourrait se tourner vers sa cause semblent se vérifier : les gens ici sont déjà dans les rues en une grande foule. Une rangée de gardes se tient à l'extérieur d'un grand bâtiment et se repousse avec leurs lances tournées de côté. Un homme riche se penche par la fenêtre pour essayer de disperser la foule avec des mots, mais ses oreilles sont trop remplies de colère. %envoy% se faufile dans la foule avec aisance et rencontre quelques conseillers en cape. Ils se glissent dans un bâtiment voisin et vous attendez dehors. | L'ambiance à %objective% semble plutôt mauvais. Les paysans dans la rue sont soit en colère pour quelque chose, soit paresseux pour rien. C'est un bon signe pour une communauté saine. %envoy% %envoy_title% entre dans un pub local où un groupe d'hommes recroquevillés l'accueille prudemment. Il vous fait signe de partir et vous restez dehors à attendre qu'il ait fini.}",
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{Un certain temps s'écoule avant que l'émissaire ne ressorte. Vous lui demandez s'il a eu des problèmes, ce à quoi il répond par non. Il est temps de retournez voir %employer%. | La porte s'ouvre et l'émissaire sort. Il vous dit d'ouvrir le chemin vers la maison. | Très vite, l'émissaire est de retour. Il vous dit que son travail est terminé et qu'il doit retourner voir %employer%. | %envoy% revient vers vous en toute hâte. Il vous dit qu'il doit retourner voir %employer% le plus vite possible. | Lorsque l'émissaire revient, il dit que la discussion a été fructueuse et que vous devez le ramener voir %employer% dès que possible.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Enfin, allons-y ! | Qu'est-ce qui vous a pris si longtemps ?}",
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
			Text = "[img]gfx/ui/events/event_51.png[/img]{Au moment où vous quittez la ville, un homme en cape vient vous parler. Il garde son visage dans l'ombre de son manteau, on ne voit que ses dents de temps en temps et la pointe d'un menton pointu.%SPEECH_ON%Quand le moment sera venu, regarderez-vous ailleurs, mercenaire ?%SPEECH_OFF%Avant que vous ne puissiez répondre, il est parti. | Alors que vous vous apprêtez à quitter la ville, un homme vous heurte. Il ne s'excuse pas, mais jette un coup d'oeil sous un long manteau noir.%SPEECH_ON%Il y aura un moment où vous devrez prendre une décision. Rester et se battre, ou partir et vivre pour voir un autre jour. L'or vous suivra sur la deuxième route, une pelle vous enterrera sur la première...%SPEECH_OFF%Vous tendez le bras pour attraper l'homme, mais il recule simplement, absorbé par une foule. | Alors que vous vous apprêtez à quitter %townname%, un homme vêtu d'une cape sombre vient à vos côtés. Il ne vous regarde pas, il se contente de parler.%SPEECH_ON%Mon bienfaiteur vous attendait. %employer% a été sage de vous engager. Cependant, vous avez le choix et quand le moment sera venu... quel chemin emprunterez-vous ?%SPEECH_OFF%Vous dites à l'homme d'emmener ses présages ailleurs. | Un homme en noir vous coupe la route alors que vous quittez la présence de %employer%. Il jette un coup d'œil par-dessus vos épaules, puis chuchote.%SPEECH_ON%%employer% vous paie bien, mais je connais quelqu'un qui paiera encore mieux. Regarder ailleurs quand le moment sera venu...%SPEECH_OFF%L'étranger fait un pas en arrière et se glisse derrière une porte. Lorsque vous l'ouvrez pour le poursuivre, il a disparu. Seul un commis de cuisine est là, l'air de n'avoir rien vu du tout. | Avec la tâche de %employer% en main, vous vous préparez à partir. Alors que vous préparez les provisions, un étranger vêtu d'une cape s'approche. Il parle comme s'il avait du gravier dans la gorge.%SPEECH_ON%De nombreux oiseaux vous observent, mercenaire. Faites attention à vos prochains pas. Vous avez encore une chance de vous en sortir. Quand le moment sera venu, nous vous demandons simplement de vous écarter.%SPEECH_OFF%Vous tirez votre épée pour menacer l'homme, mais il s'éloigne, sa cape flottante se glissant dans une foule de paysans qui semblent alarmés par votre armement soudain.}",
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
			Text = "[img]gfx/ui/events/event_07.png[/img]{Sur votre chemin, un groupe d'hommes armés surgit de nulle part pour vous barrer la route. Parmi eux se trouve le personnage louche que vous avez vu plus tôt. Ils annoncent leur intention de vous débarrasser de l'émissaire. En échange, vous recevrez une grosse somme d'argent - %bribe% couronnes.\n\nSinon, eh bien, ils devront le prendre de force... | Vous êtes en train de vous mettre dans le bain, d'écouter les plaisanteries de l'émissaire, de les ignorer, de souhaiter qu'il parte seuls dans les bois pour ne jamais revenir, quand soudain un groupe d'hommes armés vous surprend. L'étranger qui vous a rencontré plus tôt se tient à leurs côtés. Ils déclarent que l'émissaire doit leur être remis. En retour, vous recevrez la somme de %bribe% couronnes. Si vous refusez, ils utiliseront des méthodes plus violentes.\n\nAlors que vous réfléchissez à vos options, l'émissaire est, pour une fois, complètement silencieux. | En marchant sur la route, un groupe d'hommes armés sort pour vous arrêter. Vous reconnaissez l'étranger de tout à l'heure qui se tient avec eux. Ils vous demandent de leur remettre l'émissaire, en montrant d'un geste une très grande sacoche de couronnes, la somme de %bribe% couronnes qu'ils proposent. Ils montrent également leurs armes d'un geste, ce qui suggère qu'ils sont prêts à utiliser d'autres moyens si vous refusez.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{As you mull the thought over, the envoy comes to your side, whispering.%SPEECH_ON%Surely you won\'t let them take me, right? %employer% is paying you good money to ensure my safety.%SPEECH_OFF%You nod, putting a hand on the man\'s shoulder as you whisper back.%SPEECH_ON%You\'re right. He is. But they\'re paying me more.%SPEECH_OFF%With that, you push the man forward. He protests, but it is cut short on the end of a sword. Blood splatters to the ground and when the blade is drawn out a pile of guts follow it. The mysterious stranger hands you a satchel of promised crowns.%SPEECH_ON%Thank you for your business, sellsword.%SPEECH_OFF% | You stare at the envoy and then to the mysterious men, nodding toward them. He clutches your shirt, pleading.%SPEECH_ON%No, you can\'t! You promised %employer% that I would be safe!%SPEECH_OFF%You hand the man off. They slit his throat in an instant and he falls to his knees, fingers wrapped around his wound as blood spews forth. The killers kick him around, the envoy slowly going still as a bunch of men laugh his way into the next world. A satchel lands in your hands and the man who put it there claps you on the shoulder.%SPEECH_ON%Thank you for your cooperation, sellsword. You truly live up to your title.%SPEECH_OFF% | You glance at the envoy and shake your head.%SPEECH_ON%I am a sellsword, and my price is what it is.%SPEECH_OFF%The envoy cries out, but a man walks up with a small crossbow and fires a bolt between his eyes, the rod of it sticking out the back of his head, wrapped in unspooled brain matter. The mysterious man throws you a satchel of crowns.%SPEECH_ON%What was this to all parties involved, a pity, or good graces?%SPEECH_OFF%You count the crowns and answer.%SPEECH_ON%It was both until your man there added some carpentry to the envoy\'s skull. Now it\'s just good graces.%SPEECH_OFF%The mysterious man smiles wryly.%SPEECH_ON%What a pity. I personally like a diversity of opinion. It adds drama, as they say.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "{Easy crowns. | Everybody wins.}",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", true);
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to protect an envoy");
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
			Text = "[img]gfx/ui/events/event_50.png[/img]{You push the envoy behind you with one arm while the other draws out your sword. The mysterious man nods and slowly fades behind his own battle line.%SPEECH_ON%\'Tis a shame, but my business here must still be pursued. I\'m sure you understand.%SPEECH_OFF% | The mysterious man stretches an arm out, the hand\'s fingers curling as if to reel the envoy away from you. Instead, you push the envoy back behind your battleline. The stranger nods instantly.%SPEECH_ON%Understandable. But not pursuable. We both have our benefactors, sellsword. You must be loyal to yours and I to mine. Let the best of us remain standing to reward those who put their faith in our hands.%SPEECH_OFF% | The envoy pleads with you, but you tell him to shut up before turning back toward the outfit of killers.%SPEECH_ON%The envoy walks out of here alive.%SPEECH_OFF%Nodding, the mysterious stranger simply fades behind his battleline.%SPEECH_ON%I understand. Business is business, and for now, that business must be pursued.%SPEECH_OFF%His men step forward, drawing their swords.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "To arms!",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %employer%, the envoy alongside you.%SPEECH_ON%Ah, sellsword, I see you did as I asked. And you, envoy...?%SPEECH_OFF%%envoy% dips forward and whispers into the nobleman\'s ears. He leans back, nodding.%SPEECH_ON%Good, good. Let\'s talk... Oh, and mercenary, your pay is waiting for you outside. Just ask one of the guards.%SPEECH_OFF%The two men turn and walk away. You go out into the hall and a burly man is there to hand you a satchel of %reward_completion% crowns. | Returning to %employer%, the envoy leaves your side and quickly - and quietly - tells the man some news. %employer% nods, giving away nothing about what said news was, and then snaps his finger at a nearby guard. The armed man steps forward and hands you a satchel. By the time you take it and look up, the nobleman and envoy are gone. | Having kept %envoy% safe, the envoy thanks you for your services. %employer% is not so amicable, instead ignoring you to talk to secretive emissary. While you stand around for pay, a guard sneaks up and slams a wooden chest into your arms.%SPEECH_ON%It\'s %reward_completion% crowns. You can count it if you want.%SPEECH_OFF% | You learn little of what %employer%\'s sneaky little delegate was doing in that town. The envoy and employer greet and immediately talk, huddling close and keeping their voices low. When you step forward to inquire about pay, a guard intercepts you, shoving a satchel into your arms. %reward_completion% crowns are there, as promised. Having no interest in politics, you don\'t stick around long to see what those two men are up to. | %employer% welcomes you with open arms.%SPEECH_ON%Ah, you kept %envoy% safe!%SPEECH_OFF%He hugs the envoy, but only shakes your hand, crossing it with a purse of crowns at the same time.%SPEECH_ON%I knew I could trust you, mercenary. Now, please...%SPEECH_OFF%He gestures toward the door. You depart, leaving the two men to talk.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Crowns well earned.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Safely escorted an envoy");
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
			Text = "[img]gfx/ui/events/event_60.png[/img]{The envoy didn\'t make it. %employer% can accept losses here and there, but he\'s not going to be happy about this. Try not to fail him again. | Sadly, %envoy% %envoy_title% is dead at your feet. What a terrible fate for a man promised safety! Oh well. Going into the future, it\'d be best to not keep failing %employer%. | Well, would you look at that: the envoy is dead. Your only job was to keep that man breathing. Now, he\'s not doing that. You needn\'t talk to %employer% to know he won\'t be happy about this. | You promised to keep the envoy safe from harm. It\'s hard to get anymore harmed than being outright dead, so it appears you failed quite spectacularly at this here task. | Guard the envoy. Just keep the envoy alive. The envoy must survive. Hey, I\'m an envoy, I\'m too important to die!\n\n These words must have fallen on deaf ears because the envoy is indeed dead. | It\'s hard to keep a man alive when the world wants him dead. Sadly, %envoy% %envoy_title% did not make his journey. %employer% is unlikely to be happy about this lost soul.}",
			Image = "",
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Damn this!",
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


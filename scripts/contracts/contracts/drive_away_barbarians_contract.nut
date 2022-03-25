this.drive_away_barbarians_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_barbarians";
		this.m.Name = "Chasser les barbares";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Flags.set("EnemyBanner", banditcamp.getBanner());
		this.m.Flags.set("ChampionName", this.Const.Strings.BarbarianNames[this.Math.rand(0, this.Const.Strings.BarbarianNames.len() - 1)] + " " + this.Const.Strings.BarbarianTitles[this.Math.rand(0, this.Const.Strings.BarbarianTitles.len() - 1)]);
		this.m.Flags.set("ChampionBrotherName", "");
		this.m.Flags.set("ChampionBrother", 0);
		this.m.Payment.Pool = 600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Repoussez les barbares à " + this.Flags.get("DestinationName") + " %direction% de %origin%"
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
				this.Contract.m.Destination.setLastSpawnTimeToNow();
				this.Contract.m.Destination.clearTroops();

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Barbarians, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					if (this.World.getTime().Days >= 10)
					{
						this.Flags.set("IsDuel", true);
					}
				}
				else if (r <= 40)
				{
					if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsRevenge", true);
					}
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSurvivor", true);
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
				if (this.Flags.get("IsDuelVictory"))
				{
					this.Contract.setScreen("TheDuel2");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsDuelVictory", false);
				}
				else if (this.Flags.get("IsDuelDefeat"))
				{
					this.Contract.setScreen("TheDuel3");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsDuelDefeat", false);
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsSurvivor"))
					{
						this.Contract.setScreen("Survivor1");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsDuel"))
				{
					this.Contract.setScreen("TheDuel1");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Approaching");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Duel")
				{
					this.Flags.set("IsDuelVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Duel")
				{
					this.Flags.set("IsDuelDefeat", true);
				}
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
			}

			function update()
			{
				if (this.Flags.get("IsRevengeVictory"))
				{
					this.Contract.setScreen("Revenge2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRevengeDefeat"))
				{
					this.Contract.setScreen("Revenge3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRevenge") && this.Contract.isPlayerNear(this.Contract.m.Home, 600))
				{
					this.Contract.setScreen("Revenge1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Revenge")
				{
					this.Flags.set("IsRevengeVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Revenge")
				{
					this.Flags.set("IsRevengeDefeat", true);
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% soupire en poussant un bout de papier vers vous. Il s'agit d'une liste de crimes. Vous hochez la tête, observant qu'il s'agit d'un grand nombre de méfaits. L'homme hoche la tête en retour.%SPEECH_ON%Si c'était l'affaire d'un simple criminel, je trouverais un chasseur de primes. Mais je vous ai fait venir ici, mercenaire, parce que c'est le travail des barbares. Tout ce qu'ils ont fait, tout ce qui est écrit là, je dois le leur faire. Ils ont un village  %direction% d'ici. J'ai besoin que vous leur rendiez visite et que vous leur montriez que même si nous vivons avec des foyers et la civilisation, l'étincelle de la nature ne nous a pas encore quittés, et que les actes barbares seront punis par des châtiments barbares. Vous comprenez ?%SPEECH_OFF%Vous remarquez maintenant que la page des crimes est parsemée de pointes de plumes frappées, comme si celui qui l'a écrite était de plus en plus contrarié par ses écrits. | Un groupe de chevaliers du coin se trouve dans la pièce avec %employer%. Ils vous regardent d'un air détaché, comme si vous étiez un chien qui avait poussé la porte et s'était faufilé à l'intérieur. %employer% descend de sa chaise, récupère un parchemin et le lance vers vous.%SPEECH_ON%Les barbares m'ont laissé ça quand j'ai voulu donner un sens à une ferme voisine qui a été détruite.%SPEECH_OFF%Le papier comporte des dessins runiques et ce qui ressemble à la représentation d'une pendaison. %employer% acquiesce.%SPEECH_ON%Ils ont massacré les fermiers, les hommes en tout cas. Seuls les vieux dieux savent ce qu'il est advenu des femmes. Allez %direction% d'ici, mercenaire, et trouvez les barbares responsables. Vous serez généreusement récompensé pour leur anéantissement pur et simple, et leur complète annihilation.%SPEECH_OFF% | %employer% a l'air plutôt énervé lorsque vous entrez dans la pièce. Il déclare que %townname% avait autrefois de bonnes relations avec les barbares du nord.%SPEECH_ON%Mais je suppose que je me trompais en pensant que nous pourrions rester en termes amicaux avec ces sauvages.%SPEECH_OFF%Il déclare qu'ils ont attaqué des caravanes, tué des voyageurs et attaqué des fermes.%SPEECH_ON%Je vais donc les traiter de la même façon. Allez %direction% d'ici et massacrez tout leur village. Etes-vous prêt à faire ça ?%SPEECH_OFF% | %employer% rit quand vous entrez dans la pièce.%SPEECH_ON%Je ne me moque pas de vous, mercenaire, seulement de cette cruelle coïncidence de rechercher un mercenaire pour une éradication rapide et totale des barbares. Vous voyez, %direction% d'ici se trouve une tribu d'enfoirés portant des peaux d'ours qui ont scalpé et tué à la hache des marchands et des voyageurs. Je ne le supporterai plus. En partie parce qu'ils ont tort, mais surtout parce que j'ai l'argent pour payer quelqu'un comme vous pour s'en occuper pour moi.%SPEECH_OFF%Il rit encore tout seul. On a l'impression que cet homme n'a jamais mis d'épée dans un être vivant.%SPEECH_ON%Alors qu'en dites-vous, mercenaire, intéressé par le massacre de quelques sauvages ?%SPEECH_OFF% | Quand vous entrez dans le bureau de %employer%, il fixe la tête d'un chien. Du sang provenant du cou s'écoule sur le bord de la table. L'homme frotte l'une des oreilles.%SPEECH_ON%Qui tue le chien d'un homme, lui coupe la tête et la lui envoie ?%SPEECH_OFF%Vous imaginez le pire ennemi de quelqu'un, mais ne dites rien. %employer% fait un signe de tête à l'un de ses serviteurs et la tête du chien est enlevée. Il vous regarde maintenant.%SPEECH_ON%Les sauvages %direction% ont fait ça. Ils ont commencé par s'en prendre aux marchands et aux colons, violant et pillant comme le font les barbares. J'ai donc envoyé une réponse, tué quelques-uns des leurs, et voilà ce que j'ai reçu en retour. Eh bien, s'en est fini de ces putes. Je veux que vous alliez dans leur village et que vous les anéantissiez jusqu'au dernier.%SPEECH_OFF%Vous demandez presque si cela inclut la destruction de leurs chiens. | Vous trouvez %employer% avec une femme sale et couverte de boue assise à côté de sa chaise. Ses cheveux sont emmêlés et sa chair est marquée par toutes sortes de punitions. Elle se moque de vous comme si c'était votre faute. %employer% la renverse d'un coup de pied.%SPEECH_ON%Ne fais pas attention à cette gueuse, mercenaire. On l'a surprise avec ses amis en train de piller le grenier. On a tué la plupart des sauvages, je dirais qu'on l'a épargnée pour le plaisir, mais la battre est aussi amusant que de battre un chien. Sa virilité gâche tout le plaisir.%SPEECH_OFF%Il lui donne un nouveau coup de pied et elle lui répond en grognant.%SPEECH_ON%Tu vois ? Eh bien, j'ai des nouvelles ! Nous avons localisé la souillure d'où elle vient et j'ai bien l'intention de la réduire en cendres. C'est là que vous intervenez. Le village barbare est %direction% d'ici. Détruisez-le et vous serez très bien payés.%SPEECH_OFF%La femme ne sait pas ce qu'il dit, mais son regard semble indiquer qu'elle commence à comprendre pourquoi un homme de votre espèce a franchi cette porte en premier lieu. %employer% sourit.%SPEECH_ON%Vous êtes intéressé ou je dois trouver un homme au profil plus méchant ?%SPEECH_OFF% | %employer% a une foule de paysans dans son bureau. Ils sont plus nombreux qu'un homme de son rang n'en voudrait, mais étonnamment, ils ne semblent pas vouloir le lyncher. En vous voyant, %employer% vous fait avancer.%SPEECH_ON%Ah, enfin ! Notre solution est là ! Mercenaire, les barbares %direction% d'ici ont pillé les villages voisins et violé tout ce qui avait un trou. Nous en avons marre et franchement, je ne veux pas plus que quiconque qu'une bite de sauvage s'approche de mon cul.%SPEECH_OFF%La foule des péons se moque, un homme crie que les barbares {ont coupé la tête de sa mère | ont également tué ses chèvres | ont volé tous ses chiens, ces salauds | ont mangé le foie de son plus jeune fils}. %employer% hoche la tête.%SPEECH_ON%Oui. Oui, messieurs, oui ! Et donc je disais, mercenaire, que vous devriez tracer un chemin vers le village des barbares et que vous les traitiez avec une justice mesurée, appropriée et civilisée.%SPEECH_OFF% | %employer% vous fait entrer dans son bureau. Il tient une pique, avec une tête accroché à son bout.%SPEECH_ON%Les barbares du nord m'ont envoyé ça aujourd'hui. Elle était plantée dans son messager, un homme à qui ils ont arraché les yeux et la langue. Telle est leur nature, ces sauvages, de me parler sans un mot. J'ai donc l'impression que je vais leur rendre la pareille avec votre aide, mercenaire. Allez %direction% d'ici, trouvez leur petit village et réduisez-le en cendres.%SPEECH_OFF%La tête se détache du pique et tape contre le sol en pierre avec un bruit indescriptible. | %employer% vous accueille à contrecœur, comme on a l'habitude de le faire quand le monde a besoin d'un mercenaire. Il parle succinctement.%SPEECH_ON%Les barbares ont un village %direction% d'ici d'où ils envoient des raids. Ils violent, ils pillent, ils ne sont que des insectes et des vermines sous forme d'hommes. Je veux qu'ils disparaissent tous, jusqu'au dernier. Êtes-vous prêt à accomplir cette tâche ?%SPEECH_OFF% | %employer% a un chat sur les genoux, mais en vous approchant, vous réalisez que ce n'est que la tête et qu'il a simplement fait tourner une queue avec son pouce. Il pince les lèvres.%SPEECH_ON%Les sauvages barbares ont fait ça. Ils ont également violé et pillé un certain nombre de fermes environnantes et ont pendu à un arbre deux jumeaux, mais cela...%SPEECH_OFF%Ses paumes s'ouvrent et la tête de la chatte roule et frappe le sol de pierre avec un claquement mat.%SPEECH_ON%Pas plus. Je veux que vous alliez %direction% d'ici et que vous trouviez le village que ces sauvages appellent maison et que vous leurs fassiez ce qu'ils nous ont fait !%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{De combien de Couronnes parle-t-on? | Combien est prêt à payer %townname% pour leur sécurité? | Parlons argent.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas intéressé. | Nous avons d\'autres importants problèmes à régler. | Je vous souhaite bonne chance, mais nous ne participerons pas à cela.}",
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
			ID = "Approaching",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_138.png[/img]{Vous avez trouvé le village barbare et une succession de cairns qui y mènent. Les pierres sont empilées en forme d'hommes, et au sommet de chaque cairn repose une tête humaine fraîchement coupée. %randombrother% hoche la tête.%SPEECH_ON%Je me demande s'ils croient que faire ça les rapproche de leurs dieux.%SPEECH_OFF%Vous pensez avoir un autre moyen de les rapprocher de leurs dieux : en les tuant tous. Il est temps de planifier une attaque. | Vous trouvez le village barbare et juste à sa périphérie se trouve une pierre ronde dans la neige. Elle est si grande que la compagnie entière pourrait s'y allonger. Des runes ont été gravées sur son bord extérieur, de longues rainures recouvertes de sang séché. Au centre de la pierre se trouve une petite élévation carrée avec une courbe pour tenir le cou. %randombrother% crache.%SPEECH_ON%On dirait un carré, euh, un cercle sacrificiel.%SPEECH_OFF%En regardant autour de vous, vous vous demandez à haute voix où ils ont mis les corps. Le mercenaire hausse les épaules.%SPEECH_ON%Je ne sais pas. Il a dû les manger.%SPEECH_OFF%Ça ne vous surprendrait pas qu'ils le fassent. Vous fixez le village et vous vous demandez s'il faut attaquer ou attendre. | Le village barbare se trouve juste un peu plus loin. C'est une scène nomade, des tentes entourées de forges improvisées et de chariots bâchés en guise de greniers. On a l'impression qu'ils n'ont pas l'intention de s'installer dans une région particulière du monde. %randombrother% rit.%SPEECH_ON%Regarde celui-là. Il chie. Quel enfoiré.%SPEECH_OFF%En effet, l'un des sauvages est accroupi tout en parlant à ses compagnons du village. | Le village des sauvages n'est étonnamment pas le paysage infernal auquel on pouvait s'attendre. À part le cadavre écorché suspendu à l'envers à un totem sacré en bois, il ressemble à n'importe quel autre endroit où vivent des gens ordinaires. A part les vêtements épais et le fait que chaque individu porte une hache ou une épée. Tout à fait normal. Il y a un type qui coupe les jambes d'un cadavre et les donne à manger aux cochons, mais vous verrez ça à peu près partout. %randombrother% hoche la tête.%SPEECH_ON%Eh bien, nous sommes prêts à attaquer. Donnez le signal, capitaine.%SPEECH_OFF% | Vous trouvez le village barbare blotti dans les étendues enneigées. Il ne doit pas être là depuis longtemps : il n'y a que des tentes et leur sommet ne porte pas beaucoup de neige. Ils doivent s'installer pour un temps puis reprendre la route, soit pour garder des proies à proximité, soit pour éviter les représailles de ceux qu'ils pillent. Quel dommage qu'ils n'aient pas réussi à faire le dernier. Vous préparez la compagnie pour l'action. | Vous trouvez le village des sauvages. Bien qu'à première vue, ils semblent ordinaires. Des hommes, des femmes, des enfants. Il y a un forgeron, un tanneur, un borgne qui fabrique des flèches, et un énorme bourreau qui éviscère les corps et lave les abats sur un âne. Ça vous rappelle pourquoi vous êtes ici. | Vous trouvez le village barbare. Les sauvages sont au beau milieu d'un rituel religieux. Un vieil homme avec un collier en écaille de tortue tient en son poing une tête décapitée et rasée. Il laisse le sang couler le long de son avant-bras, tandis que des enfants prennent des brosses en crin de cheval, balaient la \"peinture\" sur la tête et vont l'écraser contre un totem sacré en bois de trois mètres de haut. Les primitifs regardent et chantent dans une langue qui vous est totalement étrangère. %randombrother% chuchote, comme s'il respectait le rituel plus qu'il n'avait peur qu'ils entendent.%SPEECH_ON%Eh bien. Je dis qu'on y va et qu'on fait les présentations, ok ?%SPEECH_OFF% | Vous trouvez les barbares se baladant dans leur village. Il s'agit principalement de tentes et de maisons de neige improvisées. Des femmes âgées sont assises en cercle pour tresser des paniers et des femmes plus jeunes fabriquent des flèches tout en jetant des regards aux hommes costauds qui se promènent. Les hommes eux-mêmes font semblant de s'en moquer, mais on reconnaît un paon en action quand on le voit. Il y a aussi des enfants qui se dépêchent de faire telle ou telle tâche. Et juste à l'extérieur du village, une série de pieux en bois empalent des cadavres nus de l'anus à la bouche, et leurs cavités thoraciques ont été écartées comme des ailes de papillon et leurs entrailles drapées comme des broderies défaites.%SPEECH_ON%Horrible.%SPEECH_OFF%dit %randombrother%. Vous hochez la tête. C'est vrai, mais c'est pour ça que vous êtes là.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous à attaquer.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TheDuel1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_139.png[/img]{Alors qu'il semble que %companyname% soit prêt à affronter les sauvages, une figure solitaire s'avance et se tient entre les lignes de combat. Il porte une longue barbe fendue nouée autour d'écailles de tortue et sa tête est abritée sous le museau incliné d'un crâne de loup. Il n'est pas armé, à l'exception d'un long bâton où sont attachées des cornes de cerf. Chose étonnante, il parle dans votre langue.%SPEECH_ON%Etrangers. Bienvenue dans le Nord. Nous ne sommes pas aussi inhospitaliers que vous le pensez. Comme le veut notre tradition, nous croyons que la bataille entre deux hommes est tout aussi honorable et valable que celle entre deux armées. C'est pourquoi je vous présente mon meilleur champion, %barbarianname%.%SPEECH_OFF%Un homme costaud s'avance. Il décroche les peaux et les jette sur le côté pour révéler un corps de muscles purs, de tendons et de cicatrices. L'aîné hoche la tête.%SPEECH_ON%Présentez votre champion, Etrangers, et nous partagerons un jour qui fera sourire tous nos ancêtres.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je préfère brûler tout le camp. A l'attaque !",
					function getResult()
					{
						this.Flags.set("IsDuel", false);
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				local raw_roster = this.World.getPlayerRoster().getAll();
				local roster = [];

				foreach( bro in raw_roster )
				{
					if (bro.getPlaceInFormation() <= 17)
					{
						roster.push(bro);
					}
				}

				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local name = this.Flags.get("ChampionName");
				local difficulty = this.Contract.getDifficultyMult();
				local e = this.Math.min(3, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = roster[i].getName() + " combattra votre champion !",
						function getResult()
						{
							this.Flags.set("ChampionBrotherName", bro.getName());
							this.Flags.set("ChampionBrother", bro.getID());
							local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
							properties.CombatID = "Duel";
							properties.Music = this.Const.Music.BarbarianTracks;
							properties.Entities = [];
							properties.Entities.push({
								ID = this.Const.EntityType.BarbarianChampion,
								Name = name,
								Variant = difficulty >= 1.15 ? 1 : 0,
								Row = 0,
								Script = "scripts/entity/tactical/humans/barbarian_champion",
								Faction = this.Contract.m.Destination.getFaction(),
								function Callback( _entity, _tag )
								{
									_entity.setName(name);
								}

							});
							properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
							properties.Players.push(bro);
							properties.IsUsingSetPlayers = true;
							properties.BeforeDeploymentCallback = function ()
							{
								local size = this.Tactical.getMapSize();

								for( local x = 0; x < size.X; x = ++x )
								{
									for( local y = 0; y < size.Y; y = ++y )
									{
										local tile = this.Tactical.getTileSquare(x, y);
										tile.Level = this.Math.min(1, tile.Level);
									}
								}
							};
							this.World.Contracts.startScriptedCombat(properties, false, true, false);
							return 0;
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "TheDuel2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_138.png[/img]{%champbrother% rengaine ses armes et se tient au-dessus du cadavre du sauvage tué. Hochant la tête, le mercenaire victorieux vous regarde en retour.%SPEECH_ON%Travail terminé, monsieur.%SPEECH_OFF%L'aîné s'avance à nouveau et lève son bâton.%SPEECH_ON%Effectivement, qu'est-ce que vous souhaitez voir résolu et qui vous amène ici?%SPEECH_OFF%Vous lui dites que ceux du sud sont furieux et veulent qu'ils quittent ces terres. L'aîné hoche la tête.%SPEECH_ON%Si par la bataille vous avez réussi, alors par un duel honorable c'est terminé. Nous partons.%SPEECH_OFF%L'aîné dit aux sauvages, dans leur langue, de faire leurs bagages et de partir. Étonnamment, il n'y a pas de plaintes. S'ils sont fidèles à leur parole, vous pouvez aller le signaler à %employer% maintenant.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une bonne fin.",
					function getResult()
					{
						this.Contract.setState("Return");
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						return 0;
					}

				}
			],
			function start()
			{
				local bro = this.Tactical.getEntityByID(this.Flags.get("ChampionBrother"));
				this.Characters.push(bro.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "TheDuel3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_138.png[/img]{C'était un bon combat, un affrontement entre hommes. Mais. %champbrother% gît mort sur le sol. Battu et tué. L'aîné s'avance à nouveau. Il n'a pas l'air de jubiler ou de sourire.%SPEECH_ON%Etrangers, la bataille est terminé. Nous avons gagné, béni soit le jugement de Far Rock, et donc nous vous demandons de quitter ces terres et de ne pas revenir.%SPEECH_OFF%Quelques mercenaires vous regardent avec colère. L'un d'eux dit qu'il ne pense pas que les sauvages respecteraient l'accord si c'était l'inverse, que la compagnie devrait éliminer ces barbares quelle que soit l'issue.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous allons rester fidèles à notre parole et vous laisser en paix.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoralReputation(5);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "A échoué à détruire un campement barbare menaçant " + this.Contract.m.Home.getName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				},
				{
					Text = "Tout le monde, chargez !",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-3);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{La bataille terminée, %randombrother% vous invite à venir. Dans l'une des tentes, un barbare soigne une blessure. Des hommes, des femmes et des enfants jonchent le sol autour de lui. Le mercenaire le désigne du doigt.%SPEECH_ON%On a chassé le sauvage jusqu'ici. Je pense qu'il s'agit de sa famille autour de lui, ou quelqu'un qu'il connaît, car il s'est effondré et n'a pas bougé depuis.%SPEECH_OFF%Vous marchez vers l'homme et vous vous accroupissez devant lui. Vous tapez sur une de ses bottes en peau de cerf et lui demandez s'il vous comprend. Il hoche la tête et hausse les épaules.%SPEECH_ON%Un peu. Vous avez fait ça. Vous n'aviez pas à le faire, mais vous l'avez fait. Achèvez-moi, ou je me battrai avec vous. L'un, l'autre, tous honorables.%SPEECH_OFF%Il semble qu'il offre sa main pour se battre avec la compagnie, sans doute dans le cadre d'un code nordique qui vous est étranger. Il offre aussi sa tête si vous la voulez, et il ne semble pas avoir peur de la donner.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous ne laisserons personne en vie.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return "Survivor2";
					}

				},
				{
					Text = "Laissons-le partir.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						return "Survivor3";
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
				{
					this.Options.push({
						Text = "Nous pourrions avoir besoin d'un homme comme lui.",
						function getResult()
						{
							return "Survivor4";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Survivor2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{Vous rengainez votre épée et abaissez la lame vers l'homme, les cadavres dans la tente se reflétant dans le métal de la lame, et le visage du barbare survivant apparaissant au bout de la lame. Il sourit et saisit les bords, la serrant dans ses énormes mains. Le sang s'écoule constamment de ses paumes.%SPEECH_ON%La mort, le meurtre, pas de déshonneur. Pour nous deux. N'est-ce pas?%SPEECH_OFF%En hochant la tête, vous enfoncez la lame dans sa poitrine et le poussez vers le sol. Le poids de son corps sur l'épée est comme une pierre et lorsque vous retirez votre épée, le cadavre tombe contre la pile de cadavres. Rengainant l'épée, vous dites à la compagnie de rassembler les marchandises qu'elle peut et de se préparer à retourner voir %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il est temps d'être payé.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{Vous dégainez votre lame à moitié, la tenez assez longtemps pour que le sauvage la voit, puis vous la remettez dans le fourreau. En hochant la tête, vous demandez.%SPEECH_ON%Vous comprenez ?%SPEECH_OFF%Le barbare se lève, s'affaissant brièvement contre le poteau de la tente. Vous vous retournez et tendez la main vers le rabat de la tente. Il acquiesce.%SPEECH_ON%Oui, je comprends.%SPEECH_OFF%Il sort en titubant, pénètre dans la lumière et s'éloigne dans les étendues du nord, sa silhouette vacillant d'un côté à l'autre, rapetissant, puis il disparaît. Vous dites à la compagnie de se préparer à retourner voir %employer% pour un salaire bien mérité.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il est temps d'être payé.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor4",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{Vous fixez l'homme, puis vous sortez votre dague et vous vous tranchez l'intérieur de la paume. Pressant le sang, vous lancez la dague au barbare, puis vous tendez la main, le sang coulant régulièrement. Le sauvage prend la lame et se coupe à son tour. Il se lève, tend sa main et vous vous serrez les mains. Il fait un signe de tête.%SPEECH_ON%L'honneur, toujours. Avec vous, le seul chemin, jusqu'au bout.%SPEECH_OFF%L'homme sort en titubant de la tente. Vous dites aux hommes de ne pas le tuer, mais plutôt de l'armer, ce qui fait sourciller certains. Son ajout à la compagnie est imprévu, mais utile. Les mercenaires du sud s'y habitueront avec le temps, mais pour l'instant %companyname% a besoin de retourner voir %employer%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans %companyname%.",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.worsenMood(1.0, "A vu son village se faire massacrer");
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx([
					"barbarian_background"
				]);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Revenge1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_135.png[/img]{A man stands out into your path. He\'s an elder and not of southern reaches.%SPEECH_ON%Ah, the Outsiders. You come to our lands and ravage an undefended village.%SPEECH_OFF%You spit and nod. %randombrother% yells out that it\'s what the savages themselves do. The old man smiles.%SPEECH_ON%So we are in cycle, and through this violence we all shall regenerate, but violence there shall be. When we are through with you, %townname% will not be spared.%SPEECH_OFF%A line of strongmen get up out of the terrain where they were hiding. By the looks of it, this is the main war party of the village you burned down. They may have been out raiding when you sacked the place. Now here they are seeking barbarian retribution.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Revenge";
						properties.Music = this.Const.Music.BarbarianTracks;
						properties.EnemyBanners.push(this.Flags.get("EnemyBanner"));
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Barbarians, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getID());
						this.World.Contracts.startScriptedCombat(properties, false, true, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Revenge2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{The savages are driven from %townname%. Despite the results, it takes time for the villagers to emerge and see your victory in full. %employer% eventually comes out clapping and hollering. There\'s a retinue of sheepish lieutenants looking around, their knees muddied, stray straw and clods of earth all over them. It appears they were hiding.%SPEECH_ON%Well done, sellsword, well done! The old gods surely all of that and will reward you in good time!%SPEECH_OFF%You sheathe your sword and nod at the man\'s useless lieutenants.%SPEECH_ON%Maybe, but you better do it first anyway. The old gods would surely appreciate your acting on their behalf given that others, shall we say, could not?%SPEECH_OFF%The man purses his lips and glances at his lieutenants who glance away. Your employer smiles and nods.%SPEECH_ON%Of course, of course, sellsword. I understand you well. You shall be paid in full and then some! All well-earned, truly!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A hard day\'s work.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "You destroyed a barbarian encampment that threatened " + this.Contract.m.Home.getName());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "You saved " + this.Contract.m.Home.getName() + " from barbarian revenge");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Revenge3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_94.png[/img]{You\'re run off the field of battle and retreat to a safe enough spot to watch the ruination of %townname%. The savages dip into homes and start raping and murdering of both men and women. Children are collected up and heaved into cages made of bone and hide where the elder gently hands them sliced apples and cups of camphor. At the town square you watch as the primitives set upon %employer%\'s home. A few guards step forward, but they\'re cut down almost immediately. One man is laid out upon the ground and is stripped and kicked toward a pair of dogs who tear at him from every which way and he survives and uncomfortably long time. \n\n Finally, %employer% is dragged out of his home. The barbarian leader stares down at him, nods, then grabs him by the neck with one hand and covers his face with the other. In this suspension the man is suffocated. The corpse is then thrown to the warband who have it stripped, desecrated, and then impaled from anus to mouth and lifted high up in the town square. Once the pillaging is done, the savages take what look they want and depart. The last you see of them is a dog trotting with a human ribcage in its maw. %randombrother% comes to your side.%SPEECH_ON%Well. I don\'t think we\'re getting paid, sir.%SPEECH_OFF%No. You suspect not.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "All is lost.",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getRoster().remove(this.Tactical.getEntityByID(this.Contract.m.EmployerID));
						this.Contract.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 4);
						this.Contract.m.Home.setLastSpawnTimeToNow();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "You failed to save " + this.Contract.m.Home.getName() + " from barbarians out for revenge");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Près de %townname%...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% welcomes your entrance with applause.%SPEECH_ON%My scouts tracked your company to the north and to its, dare I say, inevitable success! Splendid work murdering those savages. Surely this will make them think twice about venturing down here again!%SPEECH_OFF%The man pays you what you\'re owed. | You enter %employer%\'s room and find him slackened into his chair. He\'s watching a naked woman saunter from one side of the room to the other. Shaking his head, he talks to you while not taking his eyes from the show.%SPEECH_ON%My scouts have already told me of your doings. Said you put it to the barbarians like they\'d done their wrongs against you personally. I like that. I like the lack of restraint. Wish more of my own men had it.%SPEECH_OFF%A servant, previously unseen, quickly marches across the room. He\'s got a red candle atop his head and a chest of crowns in his hands. You take your pay and leave the room as quick as you can. | You find %employer% and a group of armored men standing around a table. A barbarian\'s corpse is on it. The flesh is greyed, but the body\'s musculature and grit has not yet been decayed. They ask if you truly fought men of this sort. You cut to the chase and ask for your pay. %employer% claps and shows you off to the group.%SPEECH_ON%Gentlemen, this is the sort of man I want in my ranks! Unfearful and always focused.%SPEECH_OFF%One of the nobles spits and says something you don\'t hear. You ask him to speak up if he\'s something to say, but %employer% rushes forward, chest of crowns in hand, and sends you on your way. | Finding %employer% proves a little difficult, a hunt that ends in a seemingly abandoned barn. You see him standing before a dead barbarian, the corpse hanging from the rafters by his legs like a fisherman\'s haul. The body has been burned, mutilated, and all else. %employer% crouches and washes his hands in a bucket.%SPEECH_ON%I\'ve to say, sellsword, you killing a whole number of these savages is most impressive. This one here lasted a good long while. Took to the pain like he was gonna pay it forward to me tenfold. But he never did. Did you?%SPEECH_OFF%The man gently slaps the barbarian\'s face and the chains clink as the body gently twists. %employer% nods.%SPEECH_ON%A servant outside will have your pay. A job well done, sellsword.%SPEECH_OFF% | You find %employer% and a group of men overseeing the defense of %townname%, no doubt preparing themselves for whatever attack may come next. Judging by the appearance of the men, their ambitions of survival will meet a reality far more cruel than they are ready for. But you keep that to yourself. %employer% thanks you for a job well done and pays you what is owed. | A few denizens of %townname% see your return with horrified confusion, mistaking you for the savages that they\'d come to know. Windows are shuttered, doors slammed closed, children hurried away, and a few braver souls step out with pitchforks. %employer% hurries out of his abode and sets them straight, explaining you are the heroes of the tale, that you went north and annihilated the savages, burned their village, and scattered them to the wastes. Windows swing wide and doors creak open and the children Retournez à their play. Just when you think order has returned, an old woman snarls.%SPEECH_ON%A sellsword is just a savage by another name!%SPEECH_OFF%Sighing, you tell %employer% to pay what is owed. | %employer% is studying a few scrolls. He\'s also penning notes into them and crossing others out. Looking up, he explains that he\'s putting you into the records as a \'hero who went to the wastes\' and \'slaughtered the savages in a fashion most proper and southernly.\' He asks you to remind him what your name is. You ask him to pay you what you\'re owed. | %employer% is in the company of a group of sobbing women. He\'s consoling them and when you enter he stands and points you out to them.%SPEECH_ON%Behold! The man who has slain those who murdered your husbands!%SPEECH_OFF%The women wail and clamber to you, one after the other, and you know what to do besides nod sternly and stoically. %employer% is the last of the crowd to find you, a chest of crowns in his arm and a wry smile on his lips. You take your pay and the man returns to the women.%SPEECH_ON%There there, fine ladies, the world will see a new dawn. Please, come with me. Does anyone want wine?%SPEECH_OFF% | %employer% welcomes you with open arms. You decline a hug and ask for your pay. He returns to his desk.%SPEECH_ON%I wasn\'t trying to hug you, sellsword.%SPEECH_OFF%He taps the chest rather despondently.%SPEECH_ON%But you did a good job slaughtering those savages. I\'ve a number of scouts who reported it as a \'splendid time\' you had out there. You\'ve earned this.%SPEECH_OFF%He pushes the chest across the desk and you take it at arm\'s length, meeting a slight bit of resistance as he holds onto it. You hurriedly leave the room without looking at him again. | You have a hard time finding %employer%, eventually finding him halfway down a well shaft plugging a hole with a stone slab. He shouts up to you.%SPEECH_ON%Ah, the sellsword. Hoist me up, men!%SPEECH_OFF%A pulley system draws up the plank upon which he sits. He swings his legs off and rests them on the rim of the wellhead.%SPEECH_ON%Our mason was killed by a donkey so I thought I\'d lend a hand myself. Nothing like a little dirty work to get a good man up in the morn\'.%SPEECH_OFF%He slaps your chest with his glove, it leaves a powdered outline. He nods and fetches a servant to go get your pay.%SPEECH_ON%A job well done, sellsword. Very, very well done. Heh.%SPEECH_OFF%You don\'t humor him. | %employer% is found giving a speech to a crowd of peasants. He describes an unnamed force of southerners that headed north and annihilated the savage scum. At no point are you or the %companyname% named. When he\'s done, the mob of peons cheer and clap and flowers are thrown and a general state of festivity takes over. %employer% seeks you out and shakes your hand while pushing a chest of crowns toward you.%SPEECH_ON%I wish I could call you the hero to these fine folk, but mercenaries are not seen in the best of light.%SPEECH_OFF%You wrap your hands autour de payment and lean forward.%SPEECH_ON%All I want is the pay. Have fun out there, %employer%.%SPEECH_OFF% | You find %employer% attending a funeral ceremony. They\'re burning a pyre weighed with three corpses and what may possibly be a fourth, smaller one. Possibly a whole family. %employer% says a few kind words and then sets the woodwork ablaze. A servant surprises you with a chest of crowns.%SPEECH_ON%%employer% does not wish to be bothered. Here is your pay, sellsword. Please count if you do not trust it is all there.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "You destroyed a barbarian encampment that threatened " + this.Contract.m.Home.getName());
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
		_vars.push([
			"original_reward",
			this.m.OriginalReward
		]);
		_vars.push([
			"barbarianname",
			this.m.Flags.get("ChampionName")
		]);
		_vars.push([
			"champbrother",
			this.m.Flags.get("ChampionBrotherName")
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ambushed_trade_routes_situation"));
		}
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

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
			}
		}
	}

	function onIsValid()
	{
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
			return true;
		}
	}

	function onSerialize( _out )
	{
		_out.writeI32(0);

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
		_in.readI32();
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});


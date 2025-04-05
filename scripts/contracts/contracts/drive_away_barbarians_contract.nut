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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% soupire en poussant un bout de papier vers vous. Il s\'agit d\'une liste de crimes. Vous hochez la tête, observant qu\'il s\'agit d\'un grand nombre de méfaits. L\'homme hoche la tête en retour.%SPEECH_ON%Si c\'était l\'affaire d\'un simple criminel, je trouverais un chasseur de primes. Mais je vous ai fait venir ici, mercenaire, parce que c\'est le travail des barbares. Tout ce qu\'ils ont fait, tout ce qui est écrit là, je dois le leur faire. Ils ont un village  %direction% d\'ici. J\'ai besoin que vous leur rendiez visite et que vous leur montriez que même si nous vivons avec des foyers et la civilisation, l\'étincelle de la nature ne nous a pas encore quittés, et que les actes barbares seront punis par des châtiments barbares. Vous comprenez ?%SPEECH_OFF%Vous remarquez maintenant que la page des crimes est parsemée de pointes de plumes frappées, comme si celui qui l\'a écrite était de plus en plus contrarié par ses écrits. | Un groupe de chevaliers du coin se trouve dans la pièce avec %employer%. Ils vous regardent d\'un air détaché, comme si vous étiez un chien qui avait poussé la porte et s\'était faufilé à l\'intérieur. %employer% descend de sa chaise, récupère un parchemin et le lance vers vous.%SPEECH_ON%Les barbares m\'ont laissé ça quand j\'ai voulu donner un sens à une ferme voisine qui a été détruite.%SPEECH_OFF%Le papier comporte des dessins runiques et ce qui ressemble à la représentation d\'une pendaison. %employer% acquiesce.%SPEECH_ON%Ils ont massacré les fermiers, les hommes en tout cas. Seuls les vieux dieux savent ce qu\'il est advenu des femmes. Allez %direction% d\'ici, mercenaire, et trouvez les barbares responsables. Vous serez généreusement récompensé pour leur anéantissement pur et simple, et leur complète annihilation.%SPEECH_OFF% | %employer% a l\'air plutôt énervé lorsque vous entrez dans la pièce. Il déclare que %townname% avait autrefois de bonnes relations avec les barbares du nord.%SPEECH_ON%Mais je suppose que je me trompais en pensant que nous pourrions rester en termes amicaux avec ces sauvages.%SPEECH_OFF%Il déclare qu\'ils ont attaqué des caravanes, tué des voyageurs et attaqué des fermes.%SPEECH_ON%Je vais donc les traiter de la même façon. Allez %direction% d\'ici et massacrez tout leur village. Etes-vous prêt à faire ça ?%SPEECH_OFF% | %employer% rit quand vous entrez dans la pièce.%SPEECH_ON%Je ne me moque pas de vous, mercenaire, seulement de cette cruelle coïncidence de rechercher un mercenaire pour une éradication rapide et totale des barbares. Vous voyez, %direction% d\'ici se trouve une tribu d\'enfoirés portant des peaux d\'ours qui ont scalpé et tué à la hache des marchands et des voyageurs. Je ne le supporterai plus. En partie parce qu\'ils ont tort, mais surtout parce que j\'ai l\'argent pour payer quelqu\'un comme vous pour s\'en occuper pour moi.%SPEECH_OFF%Il rit encore tout seul. On a l\'impression que cet homme n\'a jamais mis d\'épée dans un être vivant.%SPEECH_ON%Alors qu\'en dites-vous, mercenaire, intéressé par le massacre de quelques sauvages ?%SPEECH_OFF% | Quand vous entrez dans le bureau de %employer%, il fixe la tête d\'un chien. Du sang provenant du cou s\'écoule sur le bord de la table. L\'homme frotte l\'une des oreilles.%SPEECH_ON%Qui tue le chien d\'un homme, lui coupe la tête et la lui envoie ?%SPEECH_OFF%Vous imaginez le pire ennemi de quelqu\'un, mais ne dites rien. %employer% fait un signe de tête à l\'un de ses serviteurs et la tête du chien est enlevée. Il vous regarde maintenant.%SPEECH_ON%Les sauvages %direction% ont fait ça. Ils ont commencé par s\'en prendre aux marchands et aux colons, violant et pillant comme le font les barbares. J\'ai donc envoyé une réponse, tué quelques-uns des leurs, et voilà ce que j\'ai reçu en retour. Eh bien, s\'en est fini de ces putes. Je veux que vous alliez dans leur village et que vous les anéantissiez jusqu\'au dernier.%SPEECH_OFF%Vous demandez presque si cela inclut la destruction de leurs chiens. | Vous trouvez %employer% avec une femme sale et couverte de boue assise à côté de sa chaise. Ses cheveux sont emmêlés et sa chair est marquée par toutes sortes de punitions. Elle se moque de vous comme si c\'était votre faute. %employer% la renverse d\'un coup de pied.%SPEECH_ON%Ne fais pas attention à cette gueuse, mercenaire. On l\'a surprise avec ses amis en train de piller le grenier. On a tué la plupart des sauvages, je dirais qu\'on l\'a épargnée pour le plaisir, mais la battre est aussi amusant que de battre un chien. Sa virilité gâche tout le plaisir.%SPEECH_OFF%Il lui donne un nouveau coup de pied et elle lui répond en grognant.%SPEECH_ON%Tu vois ? Eh bien, j\'ai des nouvelles ! Nous avons localisé la souillure d\'où elle vient et j\'ai bien l\'intention de la réduire en cendres. C\'est là que vous intervenez. Le village barbare est %direction% d\'ici. Détruisez-le et vous serez très bien payés.%SPEECH_OFF%La femme ne sait pas ce qu\'il dit, mais son regard semble indiquer qu\'elle commence à comprendre pourquoi un homme de votre espèce a franchi cette porte en premier lieu. %employer% sourit.%SPEECH_ON%Vous êtes intéressé ou je dois trouver un homme au profil plus méchant ?%SPEECH_OFF% | %employer% a une foule de paysans dans son bureau. Ils sont plus nombreux qu\'un homme de son rang n\'en voudrait, mais étonnamment, ils ne semblent pas vouloir le lyncher. En vous voyant, %employer% vous fait avancer.%SPEECH_ON%Ah, enfin ! Notre solution est là ! Mercenaire, les barbares %direction% d\'ici ont pillé les villages voisins et violé tout ce qui avait un trou. Nous en avons marre et franchement, je ne veux pas plus que quiconque qu\'une bite de sauvage s\'approche de mon cul.%SPEECH_OFF%La foule des péons se moque, un homme crie que les barbares {ont coupé la tête de sa mère | ont également tué ses chèvres | ont volé tous ses chiens, ces salauds | ont mangé le foie de son plus jeune fils}. %employer% hoche la tête.%SPEECH_ON%Oui. Oui, messieurs, oui ! Et donc je disais, mercenaire, que vous devriez tracer un chemin vers le village des barbares et que vous les traitiez avec une justice mesurée, appropriée et civilisée.%SPEECH_OFF% | %employer% vous fait entrer dans son bureau. Il tient une pique, avec une tête accroché à son bout.%SPEECH_ON%Les barbares du nord m\'ont envoyé ça aujourd\'hui. Elle était plantée dans son messager, un homme à qui ils ont arraché les yeux et la langue. Telle est leur nature, ces sauvages, de me parler sans un mot. J\'ai donc l\'impression que je vais leur rendre la pareille avec votre aide, mercenaire. Allez %direction% d\'ici, trouvez leur petit village et réduisez-le en cendres.%SPEECH_OFF%La tête se détache du pique et tape contre le sol en pierre avec un bruit indescriptible. | %employer% vous accueille à contrecœur, comme on a l\'habitude de le faire quand le monde a besoin d\'un mercenaire. Il parle succinctement.%SPEECH_ON%Les barbares ont un village %direction% d\'ici d\'où ils envoient des raids. Ils violent, ils pillent, ils ne sont que des insectes et des vermines sous forme d\'hommes. Je veux qu\'ils disparaissent tous, jusqu\'au dernier. Êtes-vous prêt à accomplir cette tâche ?%SPEECH_OFF% | %employer% a un chat sur les genoux, mais en vous approchant, vous réalisez que ce n\'est que la tête et qu\'il a simplement fait tourner une queue avec son pouce. Il pince les lèvres.%SPEECH_ON%Les sauvages barbares ont fait ça. Ils ont également violé et pillé un certain nombre de fermes environnantes et ont pendu à un arbre deux jumeaux, mais cela...%SPEECH_OFF%Ses paumes s\'ouvrent et la tête de la chatte roule et frappe le sol de pierre avec un claquement mat.%SPEECH_ON%Pas plus. Je veux que vous alliez %direction% d\'ici et que vous trouviez le village que ces sauvages appellent maison et que vous leurs fassiez ce qu\'ils nous ont fait !%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_138.png[/img]{Vous avez trouvé le village barbare et une succession de cairns qui y mènent. Les pierres sont empilées en forme d\'hommes, et au sommet de chaque cairn repose une tête humaine fraîchement coupée. %randombrother% hoche la tête.%SPEECH_ON%Je me demande s\'ils croient que faire ça les rapproche de leurs dieux.%SPEECH_OFF%Vous pensez avoir un autre moyen de les rapprocher de leurs dieux : en les tuant tous. Il est temps de planifier une attaque. | Vous trouvez le village barbare et juste à sa périphérie se trouve une pierre ronde dans la neige. Elle est si grande que la compagnie entière pourrait s\'y allonger. Des runes ont été gravées sur son bord extérieur, de longues rainures recouvertes de sang séché. Au centre de la pierre se trouve une petite élévation carrée avec une courbe pour tenir le cou. %randombrother% crache.%SPEECH_ON%On dirait un carré, euh, un cercle sacrificiel.%SPEECH_OFF%En regardant autour de vous, vous vous demandez à haute voix où ils ont mis les corps. Le mercenaire hausse les épaules.%SPEECH_ON%Je ne sais pas. Il a dû les manger.%SPEECH_OFF%Ça ne vous surprendrait pas qu\'ils le fassent. Vous fixez le village et vous vous demandez s\'il faut attaquer ou attendre. | Le village barbare se trouve juste un peu plus loin. C\'est une scène nomade, des tentes entourées de forges improvisées et de chariots bâchés en guise de greniers. On a l\'impression qu\'ils n\'ont pas l\'intention de s\'installer dans une région particulière du monde. %randombrother% rit.%SPEECH_ON%Regarde celui-là. Il chie. Quel enfoiré.%SPEECH_OFF%En effet, l\'un des sauvages est accroupi tout en parlant à ses compagnons du village. | Le village des sauvages n\'est étonnamment pas le paysage infernal auquel on pouvait s\'attendre. À part le cadavre écorché suspendu à l\'envers à un totem sacré en bois, il ressemble à n\'importe quel autre endroit où vivent des gens ordinaires. A part les vêtements épais et le fait que chaque individu porte une hache ou une épée. Tout à fait normal. Il y a un type qui coupe les jambes d\'un cadavre et les donne à manger aux cochons, mais vous verrez ça à peu près partout. %randombrother% hoche la tête.%SPEECH_ON%Eh bien, nous sommes prêts à attaquer. Donnez le signal, capitaine.%SPEECH_OFF% | Vous trouvez le village barbare blotti dans les étendues enneigées. Il ne doit pas être là depuis longtemps : il n\'y a que des tentes et leur sommet ne porte pas beaucoup de neige. Ils doivent s\'installer pour un temps puis reprendre la route, soit pour garder des proies à proximité, soit pour éviter les représailles de ceux qu\'ils pillent. Quel dommage qu\'ils n\'aient pas réussi à faire le dernier. Vous préparez la compagnie pour l\'action. | Vous trouvez le village des sauvages. Bien qu\'à première vue, ils semblent ordinaires. Des hommes, des femmes, des enfants. Il y a un forgeron, un tanneur, un borgne qui fabrique des flèches, et un énorme bourreau qui éviscère les corps et lave les abats sur un âne. Ça vous rappelle pourquoi vous êtes ici. | Vous trouvez le village barbare. Les sauvages sont au beau milieu d\'un rituel religieux. Un vieil homme avec un collier en écaille de tortue tient en son poing une tête décapitée et rasée. Il laisse le sang couler le long de son avant-bras, tandis que des enfants prennent des brosses en crin de cheval, balaient la \"peinture\" sur la tête et vont l\'écraser contre un totem sacré en bois de trois mètres de haut. Les primitifs regardent et chantent dans une langue qui vous est totalement étrangère. %randombrother% chuchote, comme s\'il respectait le rituel plus qu\'il n\'avait peur qu\'ils entendent.%SPEECH_ON%Eh bien. Je dis qu\'on y va et qu\'on fait les présentations, ok ?%SPEECH_OFF% | Vous trouvez les barbares se baladant dans leur village. Il s\'agit principalement de tentes et de maisons de neige improvisées. Des femmes âgées sont assises en cercle pour tresser des paniers et des femmes plus jeunes fabriquent des flèches tout en jetant des regards aux hommes costauds qui se promènent. Les hommes eux-mêmes font semblant de s\'en moquer, mais on reconnaît un paon en action quand on le voit. Il y a aussi des enfants qui se dépêchent de faire telle ou telle tâche. Et juste à l\'extérieur du village, une série de pieux en bois empalent des cadavres nus de l\'anus à la bouche, et leurs cavités thoraciques ont été écartées comme des ailes de papillon et leurs entrailles drapées comme des broderies défaites.%SPEECH_ON%Horrible.%SPEECH_OFF%dit %randombrother%. Vous hochez la tête. C\'est vrai, mais c\'est pour ça que vous êtes là.}",
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
			Text = "[img]gfx/ui/events/event_139.png[/img]{Alors qu\'il semble que %companyname% soit prêt à affronter les sauvages, une figure solitaire s\'avance et se tient entre les lignes de combat. Il porte une longue barbe fendue nouée autour d\'écailles de tortue et sa tête est abritée sous le museau incliné d\'un crâne de loup. Il n\'est pas armé, à l\'exception d\'un long bâton où sont attachées des cornes de cerf. Chose étonnante, il parle dans votre langue.%SPEECH_ON%Etrangers. Bienvenue dans le Nord. Nous ne sommes pas aussi inhospitaliers que vous le pensez. Comme le veut notre tradition, nous croyons que la bataille entre deux hommes est tout aussi honorable et valable que celle entre deux armées. C\'est pourquoi je vous présente mon meilleur champion, %barbarianname%.%SPEECH_OFF%Un homme costaud s\'avance. Il décroche les peaux et les jette sur le côté pour révéler un corps de muscles purs, de tendons et de cicatrices. L\'aîné hoche la tête.%SPEECH_ON%Présentez votre champion, Etrangers, et nous partagerons un jour qui fera sourire tous nos ancêtres.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je préfère brûler tout le camp. A l\'attaque !",
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
			Text = "[img]gfx/ui/events/event_138.png[/img]{%champbrother% rengaine ses armes et se tient au-dessus du cadavre du sauvage tué. Hochant la tête, le mercenaire victorieux vous regarde en retour.%SPEECH_ON%Travail terminé, monsieur.%SPEECH_OFF%L\'aîné s\'avance à nouveau et lève son bâton.%SPEECH_ON%Effectivement, qu\'est-ce que vous souhaitez voir résolu et qui vous amène ici?%SPEECH_OFF%Vous lui dites que ceux du sud sont furieux et veulent qu\'ils quittent ces terres. L\'aîné hoche la tête.%SPEECH_ON%Si par la bataille vous avez réussi, alors par un duel honorable c\'est terminé. Nous partons.%SPEECH_OFF%L\'aîné dit aux sauvages, dans leur langue, de faire leurs bagages et de partir. Étonnamment, il n\'y a pas de plaintes. S\'ils sont fidèles à leur parole, vous pouvez aller le signaler à %employer% maintenant.}",
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
			Text = "[img]gfx/ui/events/event_138.png[/img]{C\'était un bon combat, un affrontement entre hommes. Mais. %champbrother% gît mort sur le sol. Battu et tué. L\'aîné s\'avance à nouveau. Il n\'a pas l\'air de jubiler ou de sourire.%SPEECH_ON%Etrangers, la bataille est terminé. Nous avons gagné, béni soit le jugement de Far Rock, et donc nous vous demandons de quitter ces terres et de ne pas revenir.%SPEECH_OFF%Quelques mercenaires vous regardent avec colère. L\'un d\'eux dit qu\'il ne pense pas que les sauvages respecteraient l\'accord si c\'était l\'inverse, que la compagnie devrait éliminer ces barbares quelle que soit l\'issue.}",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{La bataille terminée, %randombrother% vous invite à venir. Dans l\'une des tentes, un barbare soigne une blessure. Des hommes, des femmes et des enfants jonchent le sol autour de lui. Le mercenaire le désigne du doigt.%SPEECH_ON%On a chassé le sauvage jusqu\'ici. Je pense qu\'il s\'agit de sa famille autour de lui, ou quelqu\'un qu\'il connaît, car il s\'est effondré et n\'a pas bougé depuis.%SPEECH_OFF%Vous marchez vers l\'homme et vous vous accroupissez devant lui. Vous tapez sur une de ses bottes en peau de cerf et lui demandez s\'il vous comprend. Il hoche la tête et hausse les épaules.%SPEECH_ON%Un peu. Vous avez fait ça. Vous n\'aviez pas à le faire, mais vous l\'avez fait. Achèvez-moi, ou je me battrai avec vous. L\'un, l\'autre, tous honorables.%SPEECH_OFF%Il semble qu\'il offre sa main pour se battre avec la compagnie, sans doute dans le cadre d\'un code nordique qui vous est étranger. Il offre aussi sa tête si vous la voulez, et il ne semble pas avoir peur de la donner.}",
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
						Text = "Nous pourrions avoir besoin d\'un homme comme lui.",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{Vous rengainez votre épée et abaissez la lame vers l\'homme, les cadavres dans la tente se reflétant dans le métal de la lame, et le visage du barbare survivant apparaissant au bout de la lame. Il sourit et saisit les bords, la serrant dans ses énormes mains. Le sang s\'écoule constamment de ses paumes.%SPEECH_ON%La mort, le meurtre, pas de déshonneur. Pour nous deux. N\'est-ce pas?%SPEECH_OFF%En hochant la tête, vous enfoncez la lame dans sa poitrine et le poussez vers le sol. Le poids de son corps sur l\'épée est comme une pierre et lorsque vous retirez votre épée, le cadavre tombe contre la pile de cadavres. Rengainant l\'épée, vous dites à la compagnie de rassembler les marchandises qu\'elle peut et de se préparer à retourner voir %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il est temps d\'être payé.",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{Vous dégainez votre lame à moitié, la tenez assez longtemps pour que le sauvage la voit, puis vous la remettez dans le fourreau. En hochant la tête, vous demandez.%SPEECH_ON%Vous comprenez ?%SPEECH_OFF%Le barbare se lève, s\'affaissant brièvement contre le poteau de la tente. Vous vous retournez et tendez la main vers le rabat de la tente. Il acquiesce.%SPEECH_ON%Oui, je comprends.%SPEECH_OFF%Il sort en titubant, pénètre dans la lumière et s\'éloigne dans les étendues du nord, sa silhouette vacillant d\'un côté à l\'autre, rapetissant, puis il disparaît. Vous dites à la compagnie de se préparer à retourner voir %employer% pour un salaire bien mérité.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il est temps d\'être payé.",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{Vous fixez l\'homme, puis vous sortez votre dague et vous vous tranchez l\'intérieur de la paume. Pressant le sang, vous lancez la dague au barbare, puis vous tendez la main, le sang coulant régulièrement. Le sauvage prend la lame et se coupe à son tour. Il se lève, tend sa main et vous vous serrez les mains. Il fait un signe de tête.%SPEECH_ON%L\'honneur, toujours. Avec vous, le seul chemin, jusqu\'au bout.%SPEECH_OFF%L\'homme sort en titubant de la tente. Vous dites aux hommes de ne pas le tuer, mais plutôt de l\'armer, ce qui fait sourciller certains. Son ajout à la compagnie est imprévu, mais utile. Les mercenaires du sud s\'y habitueront avec le temps, mais pour l\'instant %companyname% a besoin de retourner voir %employer%.}",
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
			Text = "[img]gfx/ui/events/event_135.png[/img]{Un homme se dresse sur votre chemin. C\'est un ancien et il n\'est pas originaire du sud.%SPEECH_ON%Ah, les étrangers. Vous venez sur nos terres et ravagez un village sans défense.%SPEECH_OFF%Vous crachez et hochez la tête. %randombrother% crie que c\'est ce que font les sauvages eux-mêmes. Le vieil homme sourit.%SPEECH_ON%Nous sommes donc dans un cycle, et à travers cette violence, nous serons tous satisfait, mais la violence sera là. Quand nous en aurons fini avec vous, %townname% ne sera pas épargné.%SPEECH_OFF%Une ligne d\'hommes forts sort du terrain où ils étaient cachés. A première vue, c\'est le principal groupe de guerriers du village que vous avez incendié. Ils étaient peut-être en train de faire des raids quand vous avez mis l\'endroit à sac. Maintenant, ils sont là, cherchant à se venger des barbares.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
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
			Text = "[img]gfx/ui/events/event_145.png[/img]{Les sauvages sont chassés de %townname%. Malgré les résultats, il faut du temps pour que les villageois émergent et voient votre victoire dans son intégralité. %employer% finit par sortir en applaudissant et en criant. Il y a une suite de lieutenants penauds qui regardent autour d\'eux, les genoux couverts de boue, de la paille perdue et des mottes de terre partout sur eux. On dirait qu\'ils se cachaient.%SPEECH_ON%Bien joué, mercenaire, bien joué ! Les vieux dieux ont sûrement vu tout cela et vous récompenseront en temps voulu !%SPEECH_OFF%Vous rengainez votre épée et faites un signe de tête aux lieutenants inutiles de l\'homme.%SPEECH_ON%Peut-être, mais vous devriez le faire d\'abord de toute façon. Les anciens dieux apprécieraient sûrement que vous agissiez en leur nom étant donné que d\'autres, disons, n\'ont pas pu le faire ?%SPEECH_OFF%L\'homme pince les lèvres et jette un coup d\'œil à ses lieutenants qui détournent le regard. Votre employeur sourit et acquiesce.%SPEECH_ON%Bien sûr, bien sûr, mercenaire. Je vous comprends bien. Vous serez payé en totalité et même plus ! Tout est bien mérité, vraiment !%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une dure journée de travail.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Vous avez détruit un campement barbare qui menaçait " + this.Contract.m.Home.getName());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Vous avez sauvé " + this.Contract.m.Home.getName() + " de la vengeance des barbares");
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
			Text = "[img]gfx/ui/events/event_94.png[/img]{Vous quittez le champ de bataille et vous vous retirez dans un endroit assez sûr pour assister à la destruction de %townname%. Les sauvages pénètrent dans les maisons et commencent à violer et à assassiner les hommes et les femmes. Les enfants sont rassemblés et hissés dans des cages faites d\'os et de peaux où l\'aîné leur tend gentiment des pommes coupées en tranches. Sur la place du village, vous regardez les primitifs s\'attaquer à la maison de %employer%. Quelques gardes s\'avancent, mais ils sont abattus presque immédiatement. Un homme est allongé sur le sol et est dépouillé et poussé vers une paire de chiens qui le déchirent de toutes parts, mais il survit pendant un temps inconfortable. \n\n Finalement, %employer% est traîné hors de sa maison. Le chef barbare le dévisage, acquiesce, puis le saisit par le cou d\'une main et lui couvre le visage de l\'autre. L\'homme est ainsi asphyxié. Le cadavre est ensuite jeté à la bande de guerriers qui le font dépouiller, profaner, puis empaler de l\'anus à la bouche et l\'élèvent sur la place de la ville. Une fois le pillage terminé, les sauvages prennent l\'apparence qu\'ils veulent et partent. La dernière fois qu\'on les voit, c\'est un chien qui trotte avec une cage thoracique humaine dans sa gueule. %randombrother% vient à vos côtés.%SPEECH_ON%Eh bien. Je suppose que nous serons pas payés, monsieur.%SPEECH_OFF%Oui. Effectivement.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tout est perdu.",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getRoster().remove(this.Tactical.getEntityByID(this.Contract.m.EmployerID));
						this.Contract.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 4);
						this.Contract.m.Home.setLastSpawnTimeToNow();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Vous n\'avez pas réussi à sauver " + this.Contract.m.Home.getName() + " de la vengeance des barbares");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Près de %townname%...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% accueille votre arrivée avec des applaudissements.%SPEECH_ON%Mes éclaireurs ont suivi votre compagnie vers le nord et votre réussite, si j\'ose dire, inévitable ! Beau travail d\'assassiner ces sauvages. Cela va sûrement les faire réfléchir à deux fois avant de s\'aventurer à nouveau ici !%SPEECH_OFF%L\'homme vous paie ce qui vous est dû. | Vous entrez dans le bureau de %employer% et vous le trouvez détendu dans son fauteuil. Il regarde une femme nue déambuler d\'un côté à l\'autre de la pièce. Secouant la tête, il vous parle tout en ne quittant pas le spectacle des yeux.%SPEECH_ON%Mes éclaireurs m\'ont déjà parlé de vos exploits. Ils ont dit que vous aviez traité les barbares comme si vous aviez été personnellement lésé. J\'aime ça. J\'aime le manque de retenu. J\'aimerais que plus de mes propres hommes l\'aient.%SPEECH_OFF%Un serviteur, jusqu\'alors invisible, traverse rapidement la pièce. Il a une bougie rouge sur la tête et un coffre de couronnes dans les mains. Vous prenez votre paie et quittez la pièce aussi vite que possible. | Vous trouvez %employer% et un groupe d\'hommes en armure autour d\'une table. Le cadavre d\'un barbare y est posé. La chair est grisonnante, mais la musculature ne s\'est pas encore décomposée. Ils demandent si vous avez vraiment combattu des hommes de cette sorte. Vous allez droit au but et demandez votre salaire. %employer% applaudit et vous présente au groupe.%SPEECH_ON%Messieurs, c\'est le genre d\'homme que je veux dans mes rangs ! Sans peur et toujours concentré.%SPEECH_OFF%L\'un des nobles crache et dit quelque chose que vous n\'entendez pas. Vous lui demandez de parler s\'il a quelque chose à dire, mais %employer% se précipite, un coffre de couronnes à la main, et vous renvoie sur votre chemin. | Trouver %employer% s\'avère un peu difficile, une recherche qui se termine dans une grange apparemment abandonnée. Vous le voyez debout devant un barbare mort, le cadavre suspendu aux chevrons par les jambes comme le filet d\'un pêcheur. Le corps a été brûlé, mutilé, et tout le reste. %employer% s\'accroupit et se lave les mains dans un seau.%SPEECH_ON%Je dois dire, mercenaire, que tuer un grand nombre de ces sauvages est très impressionnant. Celui-là a duré un bon moment. Il a supporté la douleur comme s\'il allait me la rendre au centuple. Mais il ne l\'a jamais fait. Et vous ?%SPEECH_OFF%L\'homme gifle doucement le visage du barbare et les chaînes s\'entrechoquent alors que le corps se tord doucement. %employer% hoche la tête.%SPEECH_ON%Un serviteur dehors aura votre paie. Un travail bien fait, mercenaire.%SPEECH_OFF% | Vous trouvez %employer% et un groupe d\'hommes qui supervisent la défense de %townname%, se préparant sans doute à toute attaque à venir. À en juger par l\'apparence des hommes, leurs ambitions de survie vont rencontrer une réalité bien plus cruelle que celle à laquelle ils sont prêts. Mais vous gardez cela pour vous. %employer% vous remercie pour votre travail et vous paie ce qui vous est dû. | Quelques habitants de %townname% voient votre retour avec une confusion horrifiée, vous prenant pour les sauvages qu\'ils avaient appris à connaître. Les fenêtres se ferment, les portes sont claquées, les enfants s\'enfuient, et quelques âmes courageuses sortent avec des fourches. %employer% se précipite hors de sa demeure et leur explique que vous êtes les héros de l\'histoire, que vous êtes allés au nord et avez anéanti les sauvages, brûlé leur village et les avez dispersés dans les terres. Les fenêtres s\'ouvrent en grand, les portes grincent et les enfants retournent à leurs jeux. Au moment où vous pensez que l\'ordre est revenu, une vieille femme grogne.%SPEECH_ON%Un mercenaire n\'est qu\'un sauvage sous un autre nom !%SPEECH_OFF%En soupirant, vous dites à %employer% de payer ce qui vous est dû. | %employer% étudie quelques parchemins. Il y inscrit des notes et en raye d\'autres. En levant les yeux, il explique qu\'il vous inscrit dans les registres comme un \"héros qui est allé dans les terres désolées\" et \"a massacré les sauvages de la manière la plus correcte et la plus sudiste qu\'il soit\". Il vous demande de lui rappeler votre nom. Vous lui demandez de vous payer ce qui vous est dû. | %employer% est en compagnie d\'un groupe de femmes en sanglots. Il les console et quand vous entrez, il se lève et vous désigne à elles.%SPEECH_ON%Regardez ! L\'homme qui a tué ceux qui ont assassiné vos maris !%SPEECH_OFF%Les femmes gémissent et se précipitent vers vous, l\'une après l\'autre, et vous ne savez que faire à part hocher la tête sévèrement et stoïquement. %employer% est le dernier de la foule à vous trouver, un coffre de couronnes dans le bras et un sourire en coin sur les lèvres. Vous prenez votre paie et l\'homme retourne auprès des femmes.%SPEECH_ON%Là, là, belles dames, le monde verra une nouvelle aube. S\'il vous plaît, venez avec moi. Quelqu\'un veut-il du vin ?%SPEECH_OFF% | %employer% vous accueille à bras ouverts. Vous refusez une accolade et demandez votre salaire. Il retourne à son bureau.%SPEECH_ON%Je n\'essayais pas de vous étreindre, mercenaire.%SPEECH_OFF%Il tapote la poitrine d\'un air plutôt découragé.%SPEECH_ON%Mais vous avez fait du bon travail en massacrant ces sauvages. J\'ai un certain nombre d\'éclaireurs qui m\'ont dit que c\'était un \"moment splendide\" que vous avez passé là-bas. Vous l\'avez mérité.%SPEECH_OFF%Il pousse le coffre sur le bureau et vous le prenez à bout de bras, rencontrant une légère résistance lorsqu\'il le tient. Vous quittez précipitamment la pièce sans le regarder à nouveau. | Vous avez du mal à trouver %employer%, mais vous finissez par le trouver au milieu d\'un puis en train de boucher un trou avec une dalle de pierre. Il vous crie dessus.%SPEECH_ON%Ah, le mercenaire. Remontez-moi, les gars !%SPEECH_OFF%Un système de poulies soulève la planche sur laquelle il est assis. Il balance ses jambes et les pose sur le rebord de la tête de puits.%SPEECH_ON%Notre maçon a été tué par un âne alors j\'ai pensé donner un coup de main moi-même. Rien de tel qu\'un peu de sale boulot pour mettre un homme bon dans le bain.%SPEECH_OFF%Il vous frappe la poitrine avec son gant, il laisse un contour poudré. Il hoche la tête et va chercher un serviteur pour aller chercher votre paie.%SPEECH_ON%Un travail bien fait, mercenaire. Très, très bien fait. Heh.%SPEECH_OFF% Vous ne vous laissez pas amadouer. | %employer% se retrouve à faire un discours à une foule de paysans. Il décrit une force anonyme de Sudistes qui s\'est dirigée vers le nord et a anéanti les sauvages. À aucun moment vous ou %companyname% n\'êtes nommés. Quand il a terminé, la foule de paysans applaudit et lance des fleurs, et un état général de fête s\'installe. %employer% vous cherche et vous serre la main tout en poussant un coffre de couronnes vers vous.%SPEECH_ON%J\'aimerais pouvoir vous appeler le héros de ces braves gens, mais les mercenaires ne sont pas vus sous leur meilleur jour.%SPEECH_OFF%Vous enroulez vos mains autour du paiement et vous vous penchez en avant.%SPEECH_ON%Tout ce que je veux, c\'est le salaire. Amusez-vous bien, %employer%.%SPEECH_OFF% | Vous trouvez %employer% en train d\'assister à une cérémonie funéraire. Ils brûlent un bûcher sur lequel se trouvent trois cadavres et ce qui pourrait être un quatrième, plus petit. Peut-être une famille entière. %employer% dit quelques mots gentils, puis met le feu aux boiseries. Un serviteur vous surprend avec un coffre de couronnes.%SPEECH_ON%%employer% ne souhaite pas être dérangé. Voici votre paie, mercenaire. Comptez si vous ne pensez pas que tout y est.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Vous avez détruit un campement barbare qui menaçait " + this.Contract.m.Home.getName());
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


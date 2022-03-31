this.marauding_greenskins_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Objective = null,
		Target = null,
		IsPlayerAttacking = true,
		LastRandomEventShown = 0.0
	},
	function setObjective( _h )
	{
		if (typeof _h == "instance")
		{
			this.m.Objective = _h;
		}
		else
		{
			this.m.Objective = this.WeakTableRef(_h);
		}
	}

	function setOrcs( _o )
	{
		this.m.Flags.set("IsOrcs", _o);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.marauding_greenskins";
		this.m.Name = "Pillards à la Peau Verte";
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

		local myTile = this.m.Origin.getTile();
		local orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(myTile);
		local goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(myTile);

		if (myTile.getDistanceTo(orcs.getTile()) + this.Math.rand(0, 8) < myTile.getDistanceTo(goblins.getTile()) + this.Math.rand(0, 8))
		{
			this.m.Flags.set("IsOrcs", true);
		}
		else
		{
			this.m.Flags.set("IsOrcs", false);
		}

		local bestDist = 9000;
		local best;
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (s.isMilitary() || s.isSouthern() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getID() == this.m.Origin.getID() || s.getID() == this.m.Home.getID())
			{
				continue;
			}

			local d = this.getDistanceOnRoads(s.getTile(), this.m.Origin.getTile());

			if (d < bestDist)
			{
				bestDist = d;
				best = s;
			}
		}

		if (best != null)
		{
			local distance = this.getDistanceOnRoads(best.getTile(), this.m.Origin.getTile());
			this.m.Flags.set("MerchantReward", this.Math.max(150, distance * 5.0 * this.getPaymentMult()));
			this.setObjective(best);
			this.m.Flags.set("MerchantID", best.getFactionOfType(this.Const.FactionType.Settlement).getRandomCharacter().getID());
		}

		this.m.Payment.Pool = 800 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Tuez les peaux vertes en maraude autour de %origin%"
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

				if (r <= 5 && this.World.Assets.getBusinessReputation() >= 2250)
				{
					if (this.Flags.get("IsOrcs") == true)
					{
						this.Flags.set("IsWarlord", true);
					}
					else
					{
						this.Flags.set("IsShaman", true);
					}
				}
				else if (r <= 10 && this.Contract.m.Objective != null)
				{
					this.Flags.set("IsMerchant", true);
				}

				local originTile = this.Contract.m.Origin.getTile();
				local tile = this.Contract.getTileToSpawnLocation(originTile, 5, 10);
				local party;

				if (this.Flags.get("IsOrcs"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Orc Marauders", false, this.Const.World.Spawn.OrcRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("Une bande d\'orcs menaçants, à la peau verte et dépassant n\'importe quel homme.");
					party.getLoot().ArmorParts = this.Math.rand(0, 25);
					party.getLoot().Ammo = this.Math.rand(0, 10);
					party.addToInventory("supplies/strange_meat_item");
					local enemyBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.Contract.getOrigin().getTile());
					party.getSprite("banner").setBrush(enemyBase.getBanner());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Goblin Raiders", false, this.Const.World.Spawn.GoblinRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("Une bande de gobelins malicieux, petits mais rusés et à ne pas sous-estimer.");
					party.getLoot().ArmorParts = this.Math.rand(0, 10);
					party.getLoot().Medicine = this.Math.rand(0, 2);
					party.getLoot().Ammo = this.Math.rand(0, 30);
					local r = this.Math.rand(1, 4);

					if (r == 1)
					{
						party.addToInventory("supplies/strange_meat_item");
					}
					else if (r == 2)
					{
						party.addToInventory("supplies/roots_and_berries_item");
					}
					else if (r == 3)
					{
						party.addToInventory("supplies/pickled_mushrooms_item");
					}

					local enemyBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.Contract.getOrigin().getTile());
					party.getSprite("banner").setBrush(enemyBase.getBanner());
				}

				this.Contract.m.UnitsSpawned.push(party.getID());
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Origin);
				roam.setMinRange(3);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}

				this.Contract.m.Origin.getSprite("selection").Visible = true;
			}

			function update()
			{
				local playerTile = this.World.State.getPlayer().getTile();

				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsMerchant") && this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
					{
						this.Contract.setScreen("Merchant");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsOrcs"))
					{
						this.Contract.setScreen("BattleWonOrcs");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
					else
					{
						this.Contract.setScreen("BattleWonGoblins");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
				else if (playerTile.getDistanceTo(this.Contract.m.Target.getTile()) <= 10 && this.Contract.m.Target.isHiddenToPlayer() && this.Time.getVirtualTimeF() - this.Contract.m.LastRandomEventShown >= 30.0 && this.Math.rand(1, 1000) <= 1)
				{
					this.Contract.m.LastRandomEventShown = this.Time.getVirtualTimeF();

					if (!this.Flags.get("IsBurnedFarmsteadShown") && playerTile.Type == this.Const.World.TerrainType.Plains || playerTile.Type == this.Const.World.TerrainType.Hills || playerTile.Type == this.Const.World.TerrainType.Tundra || playerTile.Type == this.Const.World.TerrainType.Steppe)
					{
						this.Flags.set("IsBurnedFarmsteadShown", true);
						this.Contract.setScreen("BurnedFarmstead");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsCaravanShown") && playerTile.HasRoad)
					{
						this.Flags.set("IsCaravanShown", true);
						this.Contract.setScreen("DestroyedCaravan");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsDeadBodiesOrcsShown") && this.Flags.get("IsOrcs") == true)
					{
						this.Flags.set("IsDeadBodiesOrcsShown", true);
						this.Contract.setScreen("DeadBodiesOrcs");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsDeadBodiesGoblinsShown") && this.Flags.get("IsOrcs") == false)
					{
						this.Flags.set("IsDeadBodiesGoblinsShown", true);
						this.Contract.setScreen("DeadBodiesGoblins");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsWarlord") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Const.World.Common.addTroop(this.Contract.m.Target, {
						Type = this.Const.World.Spawn.Troops.OrcWarlord
					}, false);
					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Warlord");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsShaman") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Const.World.Common.addTroop(this.Contract.m.Target, {
						Type = this.Const.World.Spawn.Troops.GoblinShaman
					}, false);
					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Shaman");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Merchant",
			function start()
			{
				this.Contract.m.Origin.getSprite("selection").Visible = false;

				if (this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
				{
					this.Contract.m.Objective.getSprite("selection").Visible = true;
				}

				this.Contract.m.BulletpointsObjectives = [
					"Ramenez le marchand sain et sauf à %objective% %objectivedirection%"
				];
				this.Contract.m.BulletpointsPayment = [];
				this.Contract.m.BulletpointsPayment.push("Vous recevez %reward_merchant% Couronnes en arrivant");
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Objective))
				{
					this.Contract.setScreen("Success2");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function end()
			{
				if (this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
				{
					this.Contract.m.Objective.getSprite("selection").Visible = false;
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
				this.Contract.m.BulletpointsPayment = [];

				if (this.Contract.m.Payment.Advance != 0)
				{
					this.Contract.m.BulletpointsPayment.push("Vous recevez " + this.Contract.m.Payment.getInAdvance() + " Couronnes d\'avance");
				}

				if (this.Contract.m.Payment.Completion != 0)
				{
					this.Contract.m.BulletpointsPayment.push("Vous recevez " + this.Contract.m.Payment.getOnCompletion() + " Couronnes à l\'achèvement du contrat");
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.Origin.getSprite("selection").Visible = false;
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{La posture avachie et les gémissements occasionnels de %employer% en disent long sur le déroulement de sa journée. Il se masse les tempes avant de s\'adresser à vous d\'une voix tremblante.%SPEECH_ON%Une horde de peaux vertes terrorise et pille la région de %origin%. Ils n\'épargnent rien ni personne. {Mes hommes ont trop peur pour faire quoi que ce soit. | Trop de mes hommes errent dans le pays. | Mes hommes ne le feront pas sans un salaire scandaleux.} Vous êtes le dernier espoir du peuple pour arrêter ces brutes. Si on les laisse aller où bon leur semble, nous ne trouverons peut-être jamais le temps de reconstruire !%SPEECH_OFF%Il ferme lentement les yeux et soupire avant de poursuivre.%SPEECH_ON%Des peaux vertes. Ils laissent des traces partout où ils vont. Ils ne devraient pas être difficiles à trouver, non ? Tuez-les tous et vengez le bon peuple de %origin% !%SPEECH_OFF% | En regardant par la fenêtre, %employer% pose une question simple.%SPEECH_ON%Savez-vous ce que fait une peau verte quand elle met la main sur un enfant ?%SPEECH_OFF%Vous tournez la tête. Un garde dans le coin hausse les épaules. Vous répondez à la question.%SPEECH_ON%Oui.%SPEECH_OFF%Le noble acquiesce de la tête et retourne à son bureau, s\'y asseyant à son aise.%SPEECH_ON%Une horde d\'entre eux terrorise %origin%. J\'ai besoin que vous les trouviez et que vous les tuiez tous. Je ne peux pas... Ils ne peuvent pas... Eh bien, tuez-les tous, d\'accord ?%SPEECH_OFF% | %employer% porte une bougie près d\'un de ses livres, ses yeux s\'assombrissent à la lumière et se concentrent sur des textes que vous ne pouvez pas lire.%SPEECH_ON%On dit que les peaux vertes ont une très longue histoire dans ce pays. Vous y croyez ?%SPEECH_OFF%Vous haussez les épaules et répondez au mieux de vos connaissances.%SPEECH_ON%Si vous voulez rester un peu dans ce monde, vous devez vous battre, et les peaux vertes semblent être là depuis longtemps.%SPEECH_OFF%L\'homme hoche la tête, semblant apprécier votre observation.%SPEECH_ON%Nous savons que plusieurs d\'entre eux maraudent autour de %origin%. Ils brûlent tout ce qu\'ils rencontrent, tuent tout le monde... c\'est évident, j\'en suis sûr. Ce qui est aussi évident, c\'est que j\'ai besoin de vous, mercenaire, pour les trouver et les détruire. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% rit tout seul sur sa chaise - il a aussi la tête enfouie dans ses mains, comme une sorte de bouffon qui cache un fou rire. Pas le meilleur portrait pour un homme. Il se tourne vers vous, le regard fatigué.%SPEECH_ON%Les peaux vertes se déchaînent à nouveau. Je ne sais pas où ils sont, seulement où ils ont été. Vous connaissez ces bêtes, non ?%SPEECH_OFF%Vous acquiescez et répondez.%SPEECH_ON%Ils laissent une grande empreinte, et je ne parle pas seulement de leurs pieds.%SPEECH_OFF%L\'homme rit à nouveau, mais c\'est un rire douloureux.%SPEECH_ON%Eh bien, j\'ai clairement besoin que vous fassiez quelque chose à leur sujet. Etes-vous prêt à le faire ?%SPEECH_OFF% | %employer% se lève et va vers sa fenêtre, s\'arrête, secoue la tête et retourne à sa table. Il s\'assied lentement, avec une certaine prudence.%SPEECH_ON%Au début, on m\'a dit que c\'était des brigands. Puis j\'ai entendu dire que c\'était des pillards venus des côtes. Puis les survivants ont commencé à parler. Maintenant, vous savez quel est mon problème ?%SPEECH_OFF%Vous haussez les épaules.%SPEECH_ON%Est-ce important ?%SPEECH_OFF%L\'homme lève un sourcil.%SPEECH_ON%Des peaux vertes, mercenaires. Voilà , le problème. Ils se déchaînent autour de %origin% et j\'ai besoin de vous pour les arrêter. Est-ce important maintenant ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Nous pourrions les chasser si le salaire convient. | Combattre les peaux vertes n\'est pas donné. | Parlons couronnes.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | Nous avons d\'autres obligations.}",
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
			ID = "DestroyedCaravan",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Une caravane. Manifestement, pas une en bon état. Les chariots ont été renversés et leurs propriétaires tués. Vous chassez les buses pour examiner les preuves. Si le carnage ne fait pas penser aux peaux vertes, les empreintes de pas noueuses le font certainement. Vous êtes sur le bon chemin. | Eh bien, le chemin des peaux vertes n\'était pas difficile à suivre. Vous tombez sur une file de chariots de caravanes en feu. Les feux sont récents, profitant encore du bois des wagons. Les corps des caravaniers et des marchands sont frais eux aussi, et ils semblent être morts de peur. Continuez et vous pourrez encore rattraper ces bâtards verts. | Un homme est suspendu aux branches d\'un arbre solitaire, comme s\'il était tombé du ciel et s\'était embroché là. Au tronc se trouvent deux ânes morts. Plus loin, un chariot détruit de toutes parts, ses roues renversées et éclatées. Le chargement et les marchandises sont éparpillés partout. Un vieux feu de camp brûle autour, cherchant de quoi rester en vie alors qu\'il se réduit de plus en plus.\n\n C\'est le travail des peaux-vertes, vous n\'en doutez pas. Ce ne sera pas long avant que vous ne soyez sur eux.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On doit être proche.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BurnedFarmstead",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Des volutes de fumée s\'échappent des ruines de la ferme. Un corps est à ce qui était la porte d\'entrée. La moitié du corps a disparu. La moitié qui reste porte un visage horrifié, un bras brûlé tendu vers quelque chose, ou quelqu\'un, qui n\'est plus là. Quelques empreintes de pas se dispersent dans la boue et l\'herbe. Des peaux vertes. Vous vous rapprochez. | La petite ferme n\'a pas eu la moindre chance. Vous trouvez des fermiers tués à gauche et à droite, avec des fourches et des armes toujours en main. Il y a du sang sur l\'une des branches. Certainement pas humain. Vous suivez la piste, sachant que vous serez bientôt confronté aux auteurs de ce crime. | Un chien mort. Un autre. Des chiens de berger, si vous deviez deviner, bien que la brutalité les rende difficiles à déchiffrer. Leurs maîtres n\'étaient pas loin - il semble qu\'ils aient couru pendant que les chiens se tenaient à l\'arrière. Malheureusement, les empreintes de pas vous disent que ces fermiers sont tombés sur des peaux vertes. Les chiens se sont bien battus, et leurs maîtres ont bien fui.\n\nVous êtes proches. Continuez et vous rencontrerez ces bâtards.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On doit être proche.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DeadBodiesOrcs",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Le travail d\'un orc n\'est pas difficile à déterminer : a-t-il l\'air précis et exact ? Si oui, ce n\'était pas un orc. Ce que vous regardez est une série de corps et de parties de corps, de propriétaires et de locataires, tous mélangés ensemble. Ça prendrait une semaine juste pour les reconstituer. Si vous continuez, vous serez sûr de tomber sur des orcs. | Vous trouvez un homme coupé en deux. Un autre fendu verticalement. Un autre n\'a plus de tête car elle a été écrasée en plein dans sa poitrine. Un autre encore est couvert de bleus et de blessures, et quand vous allez l\'examiner, tous les os à l\'intérieur se bousculent et bougent, complètement brisés. C\'est l\'oeuvre des orcs. Vous êtes sur la bonne piste. | Un corps est plié en arrière, la tête touchant ses talons. Vous en trouvez un autre avec un énorme trou dans la poitrine et un autre encore qui semble avoir été éventré par quelque chose de dentelé et de rugueux. Il n\'y a rien de propre dans tout ça. C\'est, sans aucun doute, le travail des orcs.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On dirait qu\'on chasse des orcs.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DeadBodiesGoblins",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Vous tombez sur un homme appuyé contre un panneau de signalisation. Lorsque vous lui demandez s\'il a vu des peaux-vertes, il s\'incline simplement vers l\'avant et s\'écroule sur le sol. Il a des fléchettes dans le dos. Voilà qui répond à votre question. Ça veut aussi dire que vous êtes sur les traces de gobelins, pas d\'orcs. | Les Orques ne laissent pas de tels désordres. Vous avez trouvé une série de paysans et leurs chiens morts ou tués. Mais il y a peu de dégâts. Des coups de couteau ici, de petites blessures par perforation là. Quelques fléchettes ici et là. Du poison sur les pointes. C\'est l\'oeuvre de... gobelins. Ils ne doivent pas être loin. | Un homme est allongé dans l\'herbe, une fléchette dans le cou. Il a le visage empourpré, la langue arrachée. Ses mains sont fermement serrées, presque comme si elles s\'agrippaient à elles-mêmes. L\'œuvre d\'un poison paralysant, sans aucun doute. Et sans doute pas l\'œuvre d\'orcs, mais de gobelins. Ils doivent être proches...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On dirait que nous chassons des gobelins.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWonOrcs",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_81.png[/img]{Alors que vos hommes abattent les derniers orcs, vous regardez autour de vous. Les peaux vertes ont livré un sacré combat. Il est temps de vérifier la compagnie et de retourner auprès de votre employeur, %employer%. | Les hommes de %employer% ne pourraient jamais faire ce que vous venez de faire. Seul %companyname% pouvait s\'occuper de ces peaux-vertes. Vous êtes fier de la compagnie, mais essayez de ne pas le montrer. | La bataille est terminée, tout comme un ou deux paris que les hommes ont fait. Il s\'avère qu\'un orque cessera de grogner si vous lui retirez la tête du cou ! Votre employeur, %employer%, ne se soucie probablement pas de ces expériences brutales, mais il vous paiera pour le travail que vous avez accompli aujourd\'hui. | Les orcs ont livré un combat que les hommes saints auraient même osé qualifier de juste. Mais ils ne valent pas mieux que %companyname%, pas en ce jour ! | Votre employeur, %employer%, voulait que vous tuiez les peaux vertes et c\'est ce que vous avez fait. Maintenant, il est temps de vérifier la condition de vos hommes et de retourner récupérer votre salaire durement mérité. | Les batailles avec les orcs ne sont jamais faciles et celle-ci n\'a pas été différente. Le salaire de %employer%, cependant, rendra les difficultés de %companyname% un peu plus facile à avaler. | Votre employeur, %employer%, a intérêt à bien vous payer pour combattre ces brutes - ils ne se sont pas laissés faire facilement ! Vérifiez l\'état de vos hommes et préparez vous retournez voir votre employeur.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retournons à %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWonGoblins",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_83.png[/img]{Pour être de si petites bêtes, les gobelins savent se battre ! Votre employeur, %employer%, sera heureux du travail que vous avez accompli ici aujourd\'hui. | Vous avez entendu des gens se moquer de la taille des gobelins. Eh bien, ils étaient peut-être petits, mais ils ont tout donné.\n\nVous comptez vos hommes et vous préparez à retourner voir votre employeur, %employer%, pour votre paie. | Les gobelins se sont battus comme des bâtards affamés. Des bâtards affamés, rusés et meurtriers. Dommage que leur ingéniosité n\'ait pas été mieux utilisée. %employer% appréciera les nouvelles de ce qui a été accompli ici. | Vous ne savez pas si c\'est une bonne chose que votre employeur, %employer%, n\'était pas tout à fait sûr de l\'existence de gobelins. S\'il l\'avait su, vous aurait-il payé moins ? Les gobelins ont l\'air inoffensifs quand on les regarde, mais ils savent se battre.\n\n Quoi qu\'il en soit, il est temps de vérifier l\'état de la compagnie et de retournez voir votre employeur. | Les gobelins sont morts. Quelle nuisance. Votre employeur, %employer%, devrait être satisfait de ce que vous avez accompli aujourd\'hui. | Une pile de gobelins morts n\'est toujours pas assez grande pour atteindre la taille écrasante d\'un berserker orque. Et pourtant... ils se battent tout aussi bien ! Dommage que leurs efforts soient gaspillés dans des corps si petits. Mais si leur esprit et leur ruse étaient adaptés au corps d\'un orque... par les vieux dieux, c\'est une pensée effrayante !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retournons à %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Warlord",
			Title = "Avant l\'attaque...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{En vous approchant du groupe d\'orcs, vous apercevez la silhouette caractéristique d\'un chef de guerre brutal. Il semble que votre temps avec les peaux vertes sera plus difficile que prévu. | Les orcs ont un énorme seigneur de guerre en leur sein. Cela ne change rien. Enfin, ça change un peu les choses, mais l\'objectif final reste le même : les tuer tous. | Quelle malheureuse nouvelle ! Un seigneur de guerre orque a été vu se dressant parmi les orcs. C\'est malheureux pour le seigneur de guerre. Vous êtes sûr qu\'il a travaillé dur pour arriver là où il est. C\'est dommage que %companyname% soit sur le point de tout gâcher. | Un chef de guerre parmi les peaux vertes ! Sa taille et son grognement sont inimitables - vous l\'entendriez même si un ours vous faisait la grimace ! Peu importe, le chef de guerre doit mourir comme les autres. | Un seigneur de la guerre. Un orc redoutable. Vous les avez tous entendus. Une telle énormité se tient dans le camp des peaux vertes. Un de leurs chefs. Un de leurs meilleurs combattants. Qu\'est-ce que ça peut faire ? Aucune importance. Bien sûr que non ! Rien du tout. Tout se passera comme prévu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Shaman",
			Title = "Avant l\'attaque...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{En vous approchant, vous apercevez une étrange fumée qui s\'élève. Elle n\'est pas cendrée ou grise, mais violette, avec des filaments de vert apparemment vivants qui s\'y glissent et s\'y enroulent. Les gobelins sont là, et ils ont un chaman avec eux ! | Un shaman ! Vous reconnaîtriez un de ces rusés gobelins n\'importe où - les bijoux en os, les yeux bridés, le sens de la sagesse habituellement absent de la face muette d\'un gobelin. Ces peaux vertes sont dangereuses, méfiez-vous ! | Hé, regardez où vous mettez les pieds. Un chaman gobelin se tient dans les rangs ennemis ! C\'est un combattant ennemi très redoutable ! Ne prenez pas sa petite forme ou sa taille à la légère... | Vous avez entendu des histoires sur certains chamans capables de faire sortir les rêves d\'un homme de ses oreilles. Vous n\'êtes pas sûr que ce soit vrai, mais vous savez qu\'ils font des combattants rusés, et vous êtes sur le point d\'en affronter un ! | Un gobelin chamaniste... vous reconnaitriez cette tenue osseuse n\'importe où, et la cape de camouflage aussi ! Gardez votre calme et continuez - en tuant tous ces peaux vertes, bien sûr ! | Chaman. Un chaman gobelin... Vous avez entendu des histoires d\'horreur sur leurs \"magies\", mais ce n\'est ni le moment ni l\'endroit. Préparez les hommes à attaquer ! | Un shaman gobelin. Vous avez entendu des histoires sur ces sales bêtes capables de tromper l\'esprit des hommes. Vous vous demandez maintenant si %employer%, votre employeur, n\'a pas été berné en vous amenant ici.\n\n...non. Certainement pas, n\'est-ce pas ? | Un chaman gobelin ! Vous avez entendu des histoires sur ces choses infâmes. L\'une d\'elles dit qu\'ils nourrissent les oreilles de leurs prisonniers à des guêpes ! Un homme, avec quelques verres dans le ventre, vous a dit qu\'il avait vu des abeilles transformer la cervelle d\'un homme en rayon de miel ! Je parie que le miel rend intelligent !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Merchant",
			Title = "Après la bataille...",
			Text = "{La bataille terminée, vous découvrez un surprenant captif parmi les vestiges de la bataille : un marchand. Vêtu de soies ensanglantées, il s\'approche de vous, reconnaissant. Il vous demande si vous pouvez le conduire à %objective%. Il est clair qu\'il n\'est pas en sécurité sur les routes. Vous haussez les épaules et regardez ailleurs. L\'homme reprend rapidement la parole et vous offre %reward_merchant% couronnes si vous l\'aidez. C\'est un peu plus à votre goût... | Un homme émerge d\'un tas de peaux vertes mortes. Il ne s\'agit pas d\'un de vos mercenaires, mais en fait d\'un marchand avec les mains attachées dans le dos. Vous lui demandez comment il s\'est retrouvé en si bonne compagnie et il hausse les épaules en déclarant qu\'il a rarement entendu parler de peaux vertes faisant des prisonniers. Quelle chance pour lui.\n\n Jetant un coup d\'œil autour de lui, l\'homme se remet à parler.%SPEECH_ON%Je dois vous remercier, mercenaire, mais si ce n\'était pas évident, je dois dire que je ne me sens plus en sécurité sur ces routes. Si vous pouviez m\'amener à %objective% en un seul morceau, je serais prêt à, euh,  vous récompenser avec %reward_merchant% couronnes. Cela vous convient-il ?%SPEECH_OFF% | Après la bataille, vous remarquez un marchand sur le côté, assis sur son cheval mort. Une attaque quelconque a mis fin à la créature et maintenant le marchand n\'a de solutions. Il regarde le champ de bataille, puis vous. Croisant ses bras sur le pommeau de sa selle, il demande à voix haute.%SPEECH_ON%Voudriez-vous, monsieur le mercenaire, m\'escorter jusqu\'à %objective% ? Comme vous pouvez le voir, mon mode de transport s\'est effondré sous moi, abattu dans la bataille... mais ce n\'est pas votre faute ! Non, monsieur ! Cependant, je dois vraiment me rendre dans cette ville.%SPEECH_OFF%Il fait une pause et vous montre un petit sac.%SPEECH_ON%Il y a %reward_merchant% couronnes dedans pour vous. Qu\'en dites-vous ?%SPEECH_OFF% | Alors que vous examinez le champ de bataille, un homme s\'approche de vous et vous demande ce qu\'il s\'est passé ici. Essuyant le sang sur votre lame, vous lui dites de bien regarder. Il ferme les yeux et, pour une raison quelconque, se penche en avant sur la pointe des pieds.%SPEECH_ON%Ah, des peaux vertes. Un événement tragique. Et bien...%SPEECH_OFF%Il tombe sur ses fesses%SPEECH_ON%Attendez une bonne minute. Des peaux-vertes ? Que diable font-ils ici ? Par la miséricorde des cieux, je ne peux pas être en sécurité dans ces régions ! Mercenaire ! Je vous paierai %reward_merchant% couronnes si vous m\'escortez jusqu\'à %objective%. Je vous promets que ce n\'est pas loin d\'ici, mais je ne peux pas me permettre d\'y aller seul.%SPEECH_OFF%Il passe un pouce sur son cou et désigne une peau verte morte.%SPEECH_ON%Je ne pense pas que quiconque puisse se permettre ce prix, compris ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très bien, nous allons vous conduire à %objective%.",
					function getResult()
					{
						this.Contract.setState("Running_Merchant");
						return 0;
					}

				},
				{
					Text = "Allez-y et restez hors de notre chemin.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Flags.get("IsOrcs"))
				{
					this.Text = "[img]gfx/ui/events/event_81.png[/img]" + this.Text;
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_22.png[/img]" + this.Text;
				}

				local merchant = this.Tactical.getEntityByID(this.Flags.get("MerchantID"));
				this.Characters.push(merchant.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous retournez voir %employer% et jetez la tête d\'une peau verte sur sa table. Il s\'en éloigne.%SPEECH_ON%Excusez-moi ?%SPEECH_OFF%En hochant la tête, vous lui expliquez que ces choses immondes sont mortes. Il sort un mouchoir de ses poches et commence à éponger le sang.%SPEECH_ON%Oui, je peux voir ça. Ce désordre était destiné à rester là bas, pas à être ramené à mes pieds ! Putain de mercenaires... votre paie est dans le coin ! Et envoyez moi mon serviteur quand vous partirez. Quelqu\'un doit nettoyer tout ça !%SPEECH_OFF% | %employer% régale une femme de ses histoires quand vous revenez. Ses rires se transforment en un regard plein de désir lorsque vous entrez. Il s\'en aperçoit et la fait rapidement sortir, de peur que la présence d\'un vrai homme ne lui fasse perdre connaissance.%SPEECH_ON%Mercenaire ! Quelles sont vos nouvelles ?%SPEECH_OFF%Vous sortez la tête d\'une peau verte d\'un sac en toile de jute. %employer% la regarde, pince les lèvres, sourit, fronce les sourcils, semble ne pas savoir quoi faire de ce qu\'il regarde.%SPEECH_ON%Bien... bien. Eh bien, votre paie est là, comme promis.%SPEECH_OFF%Il soulève un coffre en bois sur la table.%SPEECH_ON%Ramenez la fille ici quand vous partirez.%SPEECH_OFF% | Vous plantez la tête d\'un peau-verte sur le bureau de %employer%. Il se redresse et déplie un parchemin, comparant le dessin d\'une peau verte à une bien réelle.%SPEECH_ON%Hmm, je vais devoir dire aux savants qu\'ils ont un peu... tort.%SPEECH_OFF%Vous demandez comment.%SPEECH_ON%Ils les ont colorés en gris. Celui-ci est clairement vert.%SPEECH_OFF%Vous vous demandez à haute voix si les stylos des savants existent même en vert. L\'homme se pince les lèvres et hoche la tête.%SPEECH_ON%Huh. Bon point. Eh bien, le garde à l\'extérieur de la porte aura votre paie. Laissez-moi à ce... spécimen.%SPEECH_OFF% | Un homme en robe est à côté de %employer% quand vous entrez. Il a le visage plongé dans un parchemin et ne jette même pas un regard à votre arrivée. Haussant les épaules, vous sortez d\'un sac une tête de peau verte et la posez sur la table de votre employeur. L\'étranger s\'en aperçoit et prend lui aussi la tête ! Il l\'arrache et se précipite immédiatement hors de la pièce, hurlant presque de vertige. Vous demandez ce que c\'était. %employer% rit.%SPEECH_ON%Les savants étaient impatients de vous voir revenir. Ils voulaient quelque chose de nouveau à étudier depuis un moment maintenant.%SPEECH_OFF%L\'homme sort une sacoche et vous la remet. Comptant les couronnes, vous demandez si les pensants vous paieront aussi. %employer% hausse les épaules.%SPEECH_ON%Si vous pouvez les attraper. Et je ne veux pas dire physiquement - ces hommes sont tellement plongés dans leurs pensées qu\'ils agissent comme si le reste d\'entre nous n\'existaient pas !%SPEECH_OFF% | %employer%% a un oiseau dans la main et une pierre dans l\'autre. Vous lui demandez ce qu\'il fait.%SPEECH_ON%J\'essaie de savoir lequel des deux vaut le plus. Un oiseau dans la main, ou... ou une pierre... attendez...%SPEECH_OFF%Vous n\'avez pas le temps pour ça et vous posez la tête de la peau verte sur sa table en demandant combien elle vaut. L\'homme libère l\'oiseau et pose la pierre sur son étagère. Il se retourne avec votre paiement en main.%SPEECH_ON%J\'en déduis par cette... curiosité, que mes problèmes ont été réglés. Votre paie, comme promis.%SPEECH_OFF%Vous vous demandez comment cet homme a réussi à attraper cet oiseau, mais vous décidez de ne pas vous y attarder. | %employer% a une quinte de toux quand vous revenez. Il vous jette un coup d\'œil, la main devant ses lèvres.%SPEECH_ON%Votre présence n\'est sûrement pas un autre mauvais présage ?%SPEECH_OFF%Vous haussez les épaules et posez la tête d\'une peau verte sur sa table, expliquant que vous vous êtes occupé d\'eux. %employer% y jette un coup d\'oeil.%SPEECH_ON%Donc ma maladie doit avoir été causée par quelque chose d\'autre... mais quoi ? {Les femmes ? C\'est probablement les femmes. Soyons honnêtes, c\'est toujours les femmes. | Les chiens. Les gens disent que ces bâtards galeux sont des signes avant-coureurs de la folie. | Des chats noirs ! Oui, bien sûr ! Je les ferai tous tuer ! | Les enfants. Les enfants ont été plutôt bruyants ces derniers temps. Qu\'est-ce qu\'ils préparent derrière ces rires ? | Peut-être que c\'est la viande mal cuite que j\'ai mangée... ou... non, je suis sûr que c\'est cette folle qui vit sur la colline. | J\'ai mangé du pain que j\'avais involontairement partagé avec un rat. C\'est soit ça, soit une femme. Vous savez comment sont les femmes, toujours à nous rendre malade et à nous pourrir, ces maudites femmes !}%SPEECH_OFF%L\'homme fait une pause, puis secoue la tête.%SPEECH_ON%Ah, peu importe. Votre paie est détenue par un garde à l\'extérieur. C\'est le montant dont nous avions convenu, mais n\'hésitez pas à le compter. Les dieux savent que je peux avoir mal compté dans mon état actuel !%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse réussie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "S\'est occupé des pillards à la peau verte.");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À %objective%...",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Ayant atteint %objective% en toute sécurité, le marchand se retourne et vous remercie. Il vous remet une sacoche de couronnes, comme promis, et se dirige rapidement vers la ville. | %objective% est un spectacle pour les yeux, et pour les joyeux marchands aussi. L\'homme que vous escortiez s\'est mis à crier, ravi d\'être en vie ou sur le point de gagner de l\'argent, ou quoi que ce soit qui fasse bouger les marchands. Il court vers une auberge voisine et revient rapidement, une sacoche de couronnes à la main.%SPEECH_ON%Comme promis, mercenaire. Je vous dois beaucoup plus.%SPEECH_OFF%Vous demandez sournoisement combien l\'homme paierait. Il rit.%SPEECH_ON%Je n\'oserais pas mettre un prix sur ma propre tête car je suis sûr que quelqu\'un voudra l\'acheter !%SPEECH_OFF%Vous hochez la tête, comprenant, et étant tout à fait d\'accord avec le paiement tel quel. | Ayant atteint %objective%, le marchand vous verse la somme dont vous avez convenu tous les deux. Il s\'empresse ensuite de partir en racontant comment il va gagner beaucoup de couronnes et coucher avec beaucoup de femmes. | Vous avez amené le marchand en toute sécurité à %objective%. Il vous remercie puis se précipite dans une taverne voisine. Quand il revient, il porte une sacoche de couronnes. Il la soulève vers vous.%SPEECH_ON%Votre paiement, mercenaire. Vous avez ma gratitude et, bien sûr, mes couronnes. Maintenant, excusez-moi...%SPEECH_OFF%Il redresse sa chemise et son pantalon, et lève le menton.%SPEECH_ON%...car j\'ai de l\'argent à gagner.%SPEECH_OFF%Il se tourne et s\'en va, avec un peu d\'entrain dans sa démarche.}",
			Image = "",
			List = [],
			Characters = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Des couronnes faciles.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Flags.get("MerchantReward"));
						return 0;
					}

				}
			],
			function start()
			{
				local merchant = this.Tactical.getEntityByID(this.Flags.get("MerchantID"));
				this.Characters.push(merchant.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("MerchantReward") + "[/color] Couronnes"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Objective != null ? this.m.Objective.getName() : ""
		]);
		_vars.push([
			"objectivedirection",
			this.m.Objective == null || this.m.Objective.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Objective.getTile())]
		]);
		_vars.push([
			"reward_merchant",
			this.m.Flags.get("MerchantReward")
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/greenskins_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Objective != null && !this.m.Objective.isNull())
			{
				this.m.Objective.getSprite("selection").Visible = false;
			}

			this.m.Origin.getSprite("selection").Visible = false;
			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
			}
		}
	}

	function onIsValid()
	{
		if (this.m.Origin.getOwner().getID() != this.m.Faction)
		{
			return false;
		}

		return true;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Objective != null && !this.m.Objective.isNull() && _tile.ID == this.m.Objective.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull() && this.m.Target.isAlive())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Objective != null && !this.m.Objective.isNull() && this.m.Objective.isAlive())
		{
			_out.writeU32(this.m.Objective.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		local objective = _in.readU32();

		if (objective != 0)
		{
			this.m.Objective = this.WeakTableRef(this.World.getEntityByID(objective));
		}

		this.contract.onDeserialize(_in);
	}

});


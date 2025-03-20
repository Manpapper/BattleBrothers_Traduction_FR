this.raid_caravan_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		LastCombatTime = 0.0
	},
	function setEnemyNobleHouse( _h )
	{
		this.m.Flags.set("EnemyNobleHouse", _h.getID());
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.raid_caravan";
		this.m.Name = "Raid Caravan";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 800 * this.getPaymentMult() * this.getDifficultyMult() * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local myTile = this.World.State.getPlayer().getTile();
		local enemyFaction = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse"));
		local settlements = enemyFaction.getSettlements();
		local lowest_distance = 99999;
		local highest_distance = 0;
		local best_start;
		local best_dest;

		foreach( s in settlements )
		{
			if (s.isIsolated())
			{
				continue;
			}

			local d = s.getTile().getDistanceTo(myTile);

			if (d < lowest_distance)
			{
				lowest_distance = d;
				best_dest = s;
			}

			if (d > highest_distance)
			{
				highest_distance = d;
				best_start = s;
			}
		}

		this.m.Flags.set("InterceptStart", best_start.getID());
		this.m.Flags.set("InterceptDest", best_dest.getID());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Attaquez la caravane partant de %start% vers %dest%",
					"Retournez à %townname%"
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
				this.Flags.set("Survivors", 0);

				if (r <= 10)
				{
					this.Flags.set("IsBribe", true);
					this.Flags.set("Bribe1", this.Contract.beautifyNumber(this.Contract.m.Payment.Pool * (this.Math.rand(70, 150) * 0.01)));
					this.Flags.set("Bribe2", this.Contract.beautifyNumber(this.Contract.m.Payment.Pool * (this.Math.rand(70, 150) * 0.01)));
				}
				else if (r <= 15)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsSwordmaster", true);
					}
				}
				else if (r <= 20)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsUndeadSurprise", true);
					}
				}
				else if (r <= 25)
				{
					this.Flags.set("IsWomenAndChildren", true);
				}
				else if (r <= 35)
				{
					this.Flags.set("IsCompromisingPapers", true);
				}

				local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
				local best_start = this.World.getEntityByID(this.Flags.get("InterceptStart"));
				local best_dest = this.World.getEntityByID(this.Flags.get("InterceptDest"));
				local party = enemyFaction.spawnEntity(best_start.getTile(), "Caravane", false, this.Const.World.Spawn.NobleCaravan, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("base").Visible = false;
				party.getSprite("banner").setBrush(enemyFaction.getBannerSmall());
				party.setMirrored(true);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setDescription("A caravan with armed escorts transporting something worth protecting between settlements.");
				party.setFootprintType(this.Const.World.FootprintsType.Caravan);
				party.getFlags().set("IsCaravan", true);
				party.setAttackableByAI(false);
				party.getFlags().add("ContractCaravan");
				this.Contract.m.Target = this.WeakTableRef(party);
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

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(best_dest.getTile());
				move.setRoadsOnly(true);
				local despawn = this.new("scripts/ai/world/orders/despawn_order");
				c.addOrder(move);
				c.addOrder(despawn);
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
					this.Contract.m.Target.setVisibleInFogOfWar(true);
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					if (this.Flags.get("IsWomenAndChildren"))
					{
						this.Contract.setScreen("WomenAndChildren1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsCompromisingPapers"))
					{
						this.Contract.setScreen("CompromisingPapers1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setState("Return");
					}
				}
				else if (this.Contract.isEntityAt(this.Contract.m.Target, this.World.getEntityByID(this.Flags.get("InterceptDest"))))
				{
					this.Contract.setScreen("Failure3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Target))
				{
					this.onTargetAttacked(this.Contract.m.Target, false);
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);

					if (this.Flags.get("IsBribe"))
					{
						this.Contract.setScreen("Bribe1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSwordmaster"))
					{
						this.Contract.setScreen("Swordmaster");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsUndeadSurprise"))
					{
						this.Contract.setScreen("UndeadSurprise");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.onTargetAttacked(_dest, true);
					}
				}
				else if (this.Time.getVirtualTimeF() >= this.Contract.m.LastCombatTime + 5.0)
				{
					local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
					enemyFaction.setIsTemporaryEnemy(true);
					this.Contract.m.LastCombatTime = this.Time.getVirtualTimeF();
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (!_actor.isNonCombatant() && _actor.getFaction() == this.Flags.get("EnemyNobleHouse") && this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("Survivors", this.Flags.get("Survivors") + 1);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Contract.m.LastCombatTime = this.Time.getVirtualTimeF();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à %townname%"
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsCompromisingPapers"))
					{
						if (this.Flags.get("IsExtorting"))
						{
							this.Contract.setScreen("CompromisingPapers2");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("CompromisingPapers3");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("Survivors") == 0)
					{
						this.Contract.setScreen("Success1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) > this.Flags.get("Survivors") * 15)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Failure2");
						this.World.Contracts.showActiveContract();
					}
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Vous prenez place pendant que %employer% déploie une carte devant vous. Il fait glisser un doigt le long d\'une des routes mal dessinées.%SPEECH_ON%Un convoi emprunte cette route. J\'ai besoin qu\'il soit attaqué, mais attendez !%SPEECH_OFF%Il lève le doigt.%SPEECH_ON%Il doit sembler que cela soit l\'œuvre de brigands. Personne ne doit savoir que sa destruction a été ordonnée par moi, compris ?%SPEECH_OFF% | %employer% explique qu\'il a besoin qu\'un convoi soit détruit. Vous demandez pourquoi, exactement, un noble tel que lui aurait une telle tâche à accomplir, mais l\'homme est avare de détails. Sa principale exigence est assez simple, détruisez le convoi et tuez tout le monde là-bas. Cela doit ressembler au travail de {brigands | vandales | vagabonds | peaux-vertes}, sinon le noble pourrait être incriminé.%SPEECH_ON%Vous avez compris cette dernière partie, mercenaire ? Bien sûr que vous avez compris. Vous êtes un gars intelligent, n\'est-ce pas ?%SPEECH_OFF% | Vous prenez place pendant que %employer% prend un grand livre sur son étagère et l\'ouvre devant vous. Sa largeur englobe toute la table et les pages sont remplies de cartes très détaillées. Le noble pointe une ligne sur l\'une des topographies.%SPEECH_ON%C\'est la route d\'un convoi que je veux détruit. Ne me posez plus de questions, j\'ai juste besoin qu\'il soit détruit. Maintenant, tout ce que je demande, c\'est que vous fassiez en sorte que cela ressemble au travail de brigands, d\'accord ? On ne doit pas savoir que j\'ai donné l\'ordre ici. Est-ce que cela vous semble faisable ?%SPEECH_OFF% | %employer% vous salue d\'une poignée de main, mais lorsque vous essayez de récupérer votre main, il serre fermement.%SPEECH_ON%Ce que je m\'apprête à dire ne peut pas quitter cette pièce, compris ?%SPEECH_OFF%Vous hochez la tête et récupérez votre main aussi sec.%SPEECH_ON%Bien. J\'ai besoin qu\'un convoi soit détruit, mais... personne ne doit savoir que c\'est vous, mercenaires, qui l\'avez fait. S\'ils le savent, ils le remonteront facilement jusqu\'à moi. J\'ai besoin que cela ressemble au travail de brigands. Personne ne doit survivre, d\'accord ?%SPEECH_OFF%Vous haussez les épaules comme pour dire, \'facilement fait.\'%SPEECH_ON%Bien, alors nous avons un accord ?%SPEECH_OFF% | Alors que vous prenez place dans le bureau de %employer%, un étranger entre derrière vous et chuchote à l\'oreille du noble. Puis, comme ça, l\'homme mystérieux se retourne et s\'en va. %employer% se lève et se sert une coupe de vin. Il ne vous en offre pas.%SPEECH_ON%J\'ai besoin qu\'un convoi soit détruit, mais cela doit être fait avec un certain niveau de discrétion. On ne doit pas savoir que c\'est moi, %employer%, qui vous a dit de le faire. Non, c\'était l\'œuvre de brigands, ces salauds... compris ? Vous comprenez ? Parlons chiffres si c\'est le cas.%SPEECH_OFF% | Alors que vous prenez place, %employer% vous demande à quel point vous êtes familier avec le travail des brigands. Vous déclarez que leur vie n\'est pas trop différente de la vôtre, sauf que vous êtes plus intelligent et que vous avez l\'oreille de gens qui paient mieux que ce que vous obtenez en pillant des paysans. %employer% hoche la tête.%SPEECH_ON%Bien, parce que j\'ai besoin que vous fassiez semblant d\'être un brigand pendant une journée et que vous détruisez un convoi. Personne ne doit survivre. Personne ne doit savoir que vous, un mercenaire, l\'avez fait. Vous comprenez ? Si c\'est le cas, parlons chiffres.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Qu\'est-ce que ça vaut pour vous ? | Parlons salaire.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne ressemble pas à notre type de travail. | Je ne pense pas.}",
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
			ID = "Bribe1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{En vous approchant du convoi, l\'un des gardes vous repère et tout le monde sort ses armes. Un homme, criant et courant les mains en l\'air, demande à tous de baisser leurs armes. Il a une bourse à la main, lourde de %bribe% couronnes, et dit que vous pouvez la prendre si vous les laissez simplement partir. Vous demandez à voix haute pourquoi vous prendriez le pot-de-vin quand vous pourriez tous les tuer et le prendre de toute façon. L\'homme hausse les épaules.%SPEECH_ON%Eh bien, cela vous éviterait certainement la peine de nous \'tuer\', étant donné que nous ne nous laisserons pas abattre sans combattre. Prenez-le simplement et partez, mercenaire.%SPEECH_OFF% | À mesure que vos hommes approchent du convoi, l\'un des gardes vous repère et sonne une corne, alertant les autres de votre présence. Bientôt, une garde armée entière se dresse devant vous, prête à combattre. Le chef du convoi passe à travers leur ligne, les mains levées.%SPEECH_ON%Gardez vos armes, hommes ! Mercenaire, je voudrais vous faire une offre. Prenez cette bourse de %bribe% couronnes et partez, et personne n\'a à mourir ici.%SPEECH_OFF%Vous ouvrez la bouche pour répondre, mais l\'homme lève un doigt et continue de parler.%SPEECH_ON%Whoa, réfléchissez bien, mercenaire. Vous n\'avez plus l\'avantage sur nous et j\'ai engagé ces hommes pour protéger ces chariots pour une bonne raison - ce sont des tueurs, tout comme vous.%SPEECH_OFF% | Alors que vos hommes approchent, la destruction du convoi semble imminente. Malheureusement, vous regardez l\'un des mercenaires faire un faux pas, glissant son pied sur une branche d\'arbre qui roule et le fait dévaler une petite colline. Le bruit est assez fort pour alerter tout le convoi de votre présence et vous regardez les gardes armés sortir pour vous rencontrer. Leur lieutenant court entre les deux groupes de guerre, les bras en l\'air.%SPEECH_ON%Attendez. Juste attendez. Avant que nous ne commencions à nous tuer et à nous massacrer, discutons un peu, d\'accord ? J\'ai ici %bribe% couronnes.%SPEECH_OFF%L\'homme tient une bourse et la brandit vers vous.%SPEECH_ON%Prenez cela, partez, et nous pouvons tous suivre notre chemin. Pas besoin que des hommes soient des obstacles les uns pour les autres, n\'est-ce pas ? Je dirais que c\'est une offre plutôt intéressante, mercenaire, étant donné que vous n\'avez plus vos méthodes furtives de votre côté - ce sera homme contre homme. Alors, qu\'en dites-vous ?%SPEECH_OFF% | Juste au moment où vous pensez que vos hommes vont commencer l\'assaut sur le convoi, un garde qui surveille les chariots les repère. Il se précipite vers une cloche d\'alarme, la sonnant bruyamment juste au moment où %randombrother% écrase son crâne. Malheureusement, un grand nombre des compatriotes du garde sortent, armes levées. Leur chef est à côté d\'eux, maintenant l\'ordre de ne pas charger.%SPEECH_ON%Ho, hommes ! Pas encore. Permettez-nous, peut-être, de discuter d\'une fin moins... violente à cette jonction ici.%SPEECH_OFF%Il jette un coup d\'œil à la tête fracassée du garde.%SPEECH_ON%Eh bien, pour le reste d\'entre nous, en tout cas. J\'ai ici dans ma main %bribe% couronnes. C\'est à vous, embusqué, assassin, peu importe comment vous vous appelez, si vous le prenez simplement et que vous partez. Et je vous suggère de faire exactement cela - vous n\'avez plus l\'avantage sur nous et j\'ai payé cher ces hommes pour surveiller mes marchandises, vous comprenez ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Soit. Remettez les couronnes. | Une offre équitable, nous l\'accepterons.}",
					function getResult()
					{
						return "Bribe2";
					}

				},
				{
					Text = "Rien de personnel, mais ce convoi va brûler. Et vous avec.",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Bribe2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{Alors que vous commencez à partir, le chef du convoi vous attrape par le bras.%SPEECH_ON%Hé, ça m\'intrigue quelque chose, et je parie que vous avez quelque chose pour assouvir cette curiosité.%SPEECH_OFF%Vous récupérez votre bras de sa prise avec colère. Il s\'excuse, mais passe rapidement à sa question.%SPEECH_ON%Je voudrais savoir qui vous a envoyé. Que diriez-vous de %bribe2% couronnes de plus pour que mes oreilles soient informées de ces informations ?%SPEECH_OFF% | Le chef du convoi vous arrête avant que vous ne puissiez partir.%SPEECH_ON%Je me demande quelque chose, mercenaire, et je sais que vous avez la réponse pour moi : qui vous a envoyé ?%SPEECH_OFF%Vous regardez autour de vous. Il rit et vous donne une tape sur l\'épaule.%SPEECH_ON%Évidemment, je n\'accepterais pas une réponse gratuitement. Que diriez-vous de %bribe2% couronnes de plus dans cette bourse là pour apprendre quelques mots qui ressemblent à ce qu\'on appelle \'un nom\'. Alors, comment ça sonne, mercenaire ?%SPEECH_OFF% | Le leader vous interpelle avant que vous ne partiez. Il a les bras croisés, ses pieds remuant distraitement des cailloux.%SPEECH_ON%Vous savez, je ne peux pas simplement vous laisser partir comme ça. Il y a des informations plutôt pertinentes que j\'aimerais apprendre et je suis prêt à lâcher %bribe2% couronnes dans cette bourse là pour apprendre lesdites informations.%SPEECH_OFF%Vous regardez autour de vous, vous assurant qu\'il n\'y a pas d\'embuscade qui vous attend. Puis vous vous tournez vers l\'homme et hochez la tête.%SPEECH_ON%Vous voulez savoir qui m\'a envoyé.%SPEECH_OFF%Le leader sourit et joint ses mains.%SPEECH_ON%Mon garçon, tu es certainement un apprenant rapide ! Eh bien, oui ! Je veux savoir !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Remettez les couronnes, alors. | Très bien, même si cela ne change rien à ce stade. | Une bonne affaire vient de devenir encore plus douce.}",
					function getResult()
					{
						return "Bribe3";
					}

				},
				{
					Text = "Je ne trahirai pas notre réputation de cette manière, nous allons partir.",
					function getResult()
					{
						return "Bribe4";
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(this.Flags.get("Bribe1"));
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
				this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe1") + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Bribe3",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{Vous prenez les couronnes supplémentaires, les rangez soigneusement, puis donnez le nom au chef : %employer%. Il le fait rebondir sur sa langue comme une sorte de noix empoisonnée.%SPEECH_ON%%employer%. %employer%! Berk, ce nom. %employer%, comme une sorte de... eh bien, je ne vous ennuierai pas avec mon envie soudaine de faire descendre mon langage dans les bas-fonds. Je vous remercie, mercenaire, et vous dis au revoir.%SPEECH_OFF%Vous hochez la tête et vous en allez. | Mettant de côté les couronnes supplémentaires, vous dites au chef le mot du jour : %employer%. L\'homme éclate de rire en l\'entendant et hoche la tête plusieurs fois comme s\'il s\'y attendait depuis le début.%SPEECH_ON%Vous avez bien fait, mercenaire. Quelle journée, non ? D\'abord, vous venez ici pour me passer votre épée à travers le corps, mais quelques minutes plus tard, nous nous quittons dans de si bons termes. Vraiment, vous êtes un homme d\'affaires. Dommage que vous ayez décidé de mettre cette compétence derrière une lame plutôt qu\'une plume. Adieu et bonne chance.%SPEECH_OFF% | {Bon gré, mal gré. | On ne peut pas avoir le beurre et l\'argent du beurre.} Vous acceptez l\'offre de l\'homme et révélez les agissements de %employer%. Le chef du convoi hoche la tête solennellement.%SPEECH_ON%Vous savez, nous, hommes d\'affaires, ne manions pas d\'armes comme vous le faites, mais croyez-moi, c\'est tout aussi impitoyable. Bonne chance, mercenaire.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Être payé sans avoir à tuer personne. Je peux m\'habituer à ça.",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(this.Flags.get("Bribe2"));
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
				this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", true);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe2") + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Bribe4",
			Title = "En vous approchant...",
			Text ="[img]gfx/ui/events/event_41.png[/img]{Vous dites à l\'homme de dégager. Il a déjà eu assez de chance. L\'homme hoche la tête, d\'accord, bien que son visage étroit vous dise tout ce que vous avez besoin de savoir sur votre rejet. | Vous secouez la tête.%SPEECH_ON%Je vais vous laisser partir, mais je ne peux pas aller jusque-là. J\'ai encore besoin de l\'emploi que %employer% offre, vous comprenez ?%SPEECH_OFF%L\'homme hoche la tête.%SPEECH_ON%Une décision intelligente, bien que mauvaise pour moi, évidemment. Mais oui, je vous comprends, mercenaire. Que les anciens dieux soient avec vous dans vos voyages. Espérons que nous nous reverrons, j\'espère que ce sera dans de meilleures conditions !%SPEECH_OFF% | Trahir %employer% n\'est probablement pas la meilleure des idées et vous le dites à l\'homme. Il hoche la tête, comprenant.%SPEECH_ON%Eh bien, d\'accord alors. Je ne peux pas vous blâmer de garder ces cartes en main, mais maudit soit si je ne souhaite pas que vous les ayez montrées de la même manière. Bonne chance, mercenaire.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On y va !",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Swordmaster",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_35.png[/img]{Alors que vous vous préparez à attaquer le convoi, %randombrother% vient à vos côtés et pointe du doigt l\'un des hommes dans le convoi.%SPEECH_ON%Tu sais qui c\'est ?%SPEECH_OFF%Vous secouez la tête.%SPEECH_ON%C\'est %swordmaster%.%SPEECH_OFF%En plissant les yeux pour avoir une image plus claire, tout ce que vous voyez est un homme ordinaire. Le mercenaire explique qu\'il s\'agit d\'un maître d\'armes renommé qui a tué un nombre incalculable d\'hommes. Il se mouche et crache.%SPEECH_ON%Tu veux toujours attaquer ?%SPEECH_OFF% | Vous scrutez le convoi avec des lunettes et repérez un visage familier : %swordmaster%. Un homme que vous avez vu participer à un tournoi de joute à %randomtown% il y a quelques années. Si vous vous souvenez bien, il a gagné avec un bras attaché derrière le dos. Toute personne qui l\'a rencontré en dehors des chevaux a rapidement été tuée alors qu\'il faisait preuve d\'une habileté experte au maniement de l\'épée. Ce type est dangereux et doit être approché avec prudence. | En faisant du repérage sur le convoi, vous voyez un visage que vous avez déjà vu. %randombrother% se joint à vous, se nettoyant les ongles avec un couteau.%SPEECH_ON%C\'est %swordmaster%, le maître d\'armes. Il a tué vingt hommes cette année.%SPEECH_OFF%Une voix aboie derrière vous.%SPEECH_ON%J\'en ai entendu parler cinquante ! Soixante peut-être. Quarante-cinq si on est réaliste...%SPEECH_OFF%Hmm, il semble y avoir un adversaire très dangereux parmi la garde de ce convoi...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A vos Armes !",
					function getResult()
					{
						this.Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = this.Const.World.Spawn.Troops.Swordmaster
						}, true, this.Contract.getDifficultyMult() >= 1.1 ? 5 : 0);
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "UndeadSurprise",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Ordre d\'attaquer, vos hommes se précipitent à travers l\'herbe. Les gardes du convoi courent déjà dans votre direction, mais ils ont l\'air effrayés. Derrière eux, une multitude de créatures voyantes les suivent. Il est sûr de dire que cela va être la rencontre la plus étrange... | Alors que le %companyname% se précipite vers le convoi, armes à la main, quelques hommes ralentissent pour signaler qu\'un groupe encore plus important approche du train depuis l\'autre côté. En prenant une pause pour bien observer, vous réalisez qu\'une horde de morts-vivants converge vers cet endroit même ! | Eh bien, il semble que cela ne sera pas aussi facile que vous le pensiez : alors que vos hommes commencent l\'attaque sur le convoi, %randombrother% repère une horde de morts-vivants approchant de l\'autre côté ! Morts-vivants ou futurs morts, cela n\'a pas d\'importance. Vous êtes là pour faire ce que %employer% vous a payé pour faire.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A vos Armes !",
					function getResult()
					{
						local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "UndeadSurprise";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Flags.get("EnemyNobleHouse")
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							enemyFaction.getBannerSmall(),
							this.Const.ZombieBanners[0]
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Necromancer, 100 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WomenAndChildren1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Après que vos hommes aient nettoyé le champ de tout blessé, %randombrother% vient vers vous avec une file de femmes et d\'enfants traînés derrière lui. Vous levez votre épée et demandez ce que c\'est.%SPEECH_ON%On dirait qu\'ils ont amené leur famille avec eux. Que voulez-vous que nous fassions ?%SPEECH_OFF%Si vous les laissez partir, il y a de fortes chances qu\'ils répandent la nouvelle de votre présence. Si vous les tuez, eh bien, cela a un coût qui pèsera lourd sur n\'importe quelle conscience... | Après avoir remporté la bataille, vos hommes se dispersent pour collecter les biens et s\'assurer que chaque garde du convoi est bien mort. Malheureusement, tout le monde que vous croisez n\'est pas mort - et tout le monde n\'est pas adulte. Un groupe de femmes et d\'enfants émerge des ruines du combat, s\'approchant lentement avec toute la fragilité d\'un chien blessé. %randombrother% demande ce qu\'il faut faire d\'eux.%SPEECH_ON%Nous devrions probablement les laisser partir, parce que, bon, regardez-les. Mais... ils pourraient parler à quelqu\'un. Vous savez, les femmes et leurs grandes bouches.%SPEECH_OFF%Le mercenaire rit nerveusement. Une des femmes serre sa poitrine.%SPEECH_ON%Nous ne dirons à personne, nous le jurons !%SPEECH_OFF% | La bataille terminée, vous tombez sur un groupe de femmes et d\'enfants dans les ruines du convoi. Ils s\'approchent, semblant comprendre que s\'ils prenaient simplement leurs jambes à leur cou, vous auriez une raison de les poursuivre. Une des femmes, tenant un bébé contre sa poitrine, implore.%SPEECH_ON%S\'il vous plaît, vous avez déjà causé tant de douleur. Nos pères, maris, frères, vous les avez déjà tous tués. N\'est-ce pas suffisant ? Laissez-nous partir.%SPEECH_OFF%%randombrother% crache.%SPEECH_ON%Ces enfants ont vu ce que nous avons fait. Ils vont grandir en s\'en souvenant aussi. Et ces femmes, eh bien, elles vont tout raconter à tout le monde. C\'est ce qu\'elles font.%SPEECH_OFF%Il regarde dans votre direction, faisant signe vers une lame à moitié dégainée.%SPEECH_ON%Que voulez-vous que nous fassions, monsieur ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous sommes payés pour ne laisser personne en vie, alors c\'est ce que nous ferons.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-5);
						return "WomenAndChildren2";
					}

				},
				{
					Text = "Au diable - laissez-les partir.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.Flags.set("Survivors", this.Flags.get("Survivors") + 3);
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WomenAndChildren2",
			Title = "Après la bataille...",
			Text ="[img]gfx/ui/events/event_60.png[/img]{Vous hochez la tête à %randombrother%. Il s\'avance, arme à la main, et d\'un coup rapide, il coupe la tête d\'une femme. Un geyser cramoisi jaillit, et ses enfants sont trop aveuglés par le sang pour voir le reste des lames arriver. Les cris s\'atténuent progressivement alors que vos frères se frayent un chemin à travers la foule horrifiée, réduisant leurs nombres en de vains gémissements dispersés. Vos hommes vérifient leur travail jusqu\'à ce que les victimes soient muettes et que le silence dégouline. | D\'un geste rapide de la main, vous donnez l\'ordre. %randombrother% ne prend qu\'un moment pour enfoncer une lame dans le visage d\'un enfant, le clouant contre le ventre de sa mère avant de la trancher vers le haut pour lui ôter la vie également. Le reste des hommes se disperse, certains hésitants tandis que d\'autres continuent avec une diligence révérente.\n\nAlors que les cris horribles emplissent l\'air, vous avez le sentiment que certains mercenaires massacrent simplement pour chasser le bruit de leurs têtes. La violence consume tout, une orgie de folie que vous ne savez pas si elle représente le pinacle ou le nadir des actions de l\'homme, car tout sens est perdu dans l\'événement et les mots pour le décrire n\'ont pas encore été trouvés dans votre langue ou dans aucune qui soit ancestrale ou au-delà de la sombre estimation de ce que votre œil peut voir. C\'est simplement un événement. | Malheureusement, personne ne peut être autorisé à vivre. Vous lancez un ordre et les mercenaires se mettent à la tâche. Une femme s\'approche, ayant apparemment mal compris vos instructions, et demande le chemin de la ville la plus proche. %randombrother% répond en écrasant sa tête avec une pierre. Des enfants effrayés se dispersent en un éparpillement sinueux qui vous rappelle vos jours de chasse au lapin. Vos mercenaires les plus rapides les poursuivent tandis que le reste reste en arrière pour se débarrasser rapidement des parents. C\'est une vision horrible en effet.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Eh bien, ce n\'est pas un travail agréable, mais c\'est pour cela que nous sommes payés.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CompromisingPapers1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Alors que la caravane brûle, vos hommes fouillent les décombres. %randombrother% vient à vous avec des papiers en main.%SPEECH_ON%Ceux-ci pourraient vous intéresser, monsieur.%SPEECH_OFF%Vous en déroulez un et le lisez. Il semble que %employer% avait un motif très, très caché pour attaquer ce convoi en particulier. Ce serait dommage si quelqu\'un venait à découvrir ces détails... | Les chariots brûlent encore, vous arrivez à un coffre en bois et le frappez pour l\'ouvrir. Des parchemins en sortent, se déroulant et se dispersant au vent. Vous en attrapez un et le lisez. C\'est un rapport sur les gains - ou l\'absence de gains - du territoire de %employer%. Il semble avoir été destiné à révéler la fragilité financière de l\'homme. Vous pourriez, si vous le souhaitez, utiliser cela contre lui... | Vous trouvez un tas de papiers dans les ruines de la caravane. Un des parchemins révèle quelque chose à propos de %employer% qui, très probablement, était au courant que cela voyageait avec les chariots. Cela doit être la raison pour laquelle il vous a ordonné de l\'attaquer... cela pourrait aussi être utilisé contre lui. Vous doutez qu\'il s\'attendait à ce que cela tombe entre vos mains. Vous n\'êtes qu\'un stupide mercenaire, après tout...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Brûlez-les avec le reste.",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", false);
						this.Contract.setState("Return");
						return 0;
					}

				},
				{
					Text = "Nous les remettrons à notre employeur comme un gage de loyauté.",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", true);
						this.Contract.setState("Return");
						return 0;
					}

				},
				{
					Text = "Notre employeur devra nous payer un supplément pour les obtenir.",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", true);
						this.Flags.set("IsExtorting", true);
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CompromisingPapers2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{Vous retournez chez %employer% et brandissez les papiers. Il semble presque instantanément reconnaître un sceau sur l\'un des parchemins.%SPEECH_ON%Qu\'est-ce que... qu\'est-ce que c\'est que ça?%SPEECH_OFF%Baissant les papiers, et sur le point d\'expliquer, l\'homme fait une tentative, essayant de les arracher de vos mains. Il échoue alors que vous reculez. Il se redresse, semblant corriger une perte de contenance.%SPEECH_ON%D\'accord mercenaire. Je vois où ça en est. Combien en veux-tu de plus?%SPEECH_OFF%Avec les portes fermées, vous négociez un accord. | %employer% vous accueille à votre retour, se retournant avec deux chopes de vin à la main, mais son sourire s\'efface rapidement.%SPEECH_ON%C\'est quoi ça dans ta main? Où as-tu eu ça?%SPEECH_OFF%Vous rangez l\'un des papiers compromettants et hochez la tête, répondant.%SPEECH_ON%Je pense que tu sais exactement d\'où je l\'ai eu. Et je pense que tu sais exactement où ça va nous mener. Maintenant... discutons d\'affaires, d\'accord?%SPEECH_OFF%L\'homme boit une des chopes, puis l\'autre.%SPEECH_ON%Ouais. D\'accord. Ferme la porte, veux-tu?%SPEECH_OFF% | Vous entrez dans la pièce de %employer% et jetez les papiers compromettants sur son bureau. Il les regarde puis rit.%SPEECH_ON%Quelle erreur!%SPEECH_OFF%Il froisse les papiers et les fourre sous sa table. Vous riez en retour et récupérez un autre ensemble de parchemins.%SPEECH_ON%Tu me prends pour un idiot?%SPEECH_OFF%L\'homme reprend rapidement ses notes fourrées et les fixe. Il réalise que vous n\'avez mis qu\'une page dedans, le reste n\'étant que des espaces vierges. En souriant, vous énoncez les règles du jeu.%SPEECH_ON%Maintenant que je sais à quel point ces papiers sont importants pour toi, parlons affaires pour que TOUS puissent te retourner, d\'accord?%SPEECH_OFF%L\'homme prend un siège solennel et hoche la tête. Il récupère une bourse personnelle de couronnes et la pose sur son bureau avant de faire signe vers l\'entrée.%SPEECH_ON%S\'il te plaît, ferme la porte.%SPEECH_OFF% | Lorsque vous revenez, %employer% remarque immédiatement le sceau sur les papiers que vous avez apportés. Il a quelques gardes dans sa chambre, mais les presse rapidement de partir, leur disant de chasser les lapins de ses jardins. Il ferme la porte et se tourne vers vous.%SPEECH_ON%Je vois que j\'ai été découvert.%SPEECH_OFF%Vous hochez la tête. L\'homme se lèche les lèvres et hoche la tête en retour.%SPEECH_ON%D\'accord alors. Rien de ce qui est écrit sur ces papiers ne peut sortir de cette pièce. Combien veux-tu?%SPEECH_OFF%Vous enjambez le rebord de sa table et prenez place, mettant les papiers à côté de vous et joignant vos mains. En souriant, vous répondez.%SPEECH_ON%Tout vaut ce que l\'acheteur est prêt à payer, n\'est-ce pas, noble homme?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une belle journée de paie enfin.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail * 2, "Extorted Money");
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
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() * 2 + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "CompromisingPapers3",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{Vous retournez chez %employer% et il se tourne vers vous, semblant en colère.%SPEECH_ON%Tu sais que les gens parlent de ce que tu as fait, n\'est-ce pas?%SPEECH_OFF%Souriant, vous brandissez les papiers compromettants.%SPEECH_ON%Préférerais-tu qu\'ils parlent de ça à la place?%SPEECH_OFF%L\'homme presque hoquette avant de se calmer dans son fauteuil.%SPEECH_ON%D\'accord, est-ce que tu me fais chanter?%SPEECH_OFF%Vous posez les papiers sur sa table et secouez la main.%SPEECH_ON%J\'y ai pensé, mais je préférerais ne pas mordre la main qui nourrit juste parce qu\'elle tient quelque chose de savoureux cette fois-ci.%SPEECH_OFF% | %employer% vous fait signe d\'entrer dans sa chambre.%SPEECH_ON%Les gens du peuple parlent de toi. Certaines personnes de ce convoi ont survécu et, entre deux souffles, elles ont jugé bon de parler de ce qu\'elles ont vécu.%SPEECH_OFF%Vous hochez la tête et convenez.%SPEECH_ON%C\'est tout à fait compréhensible.%SPEECH_OFF%L\'homme grogne et pointe du doigt, mais vous pointez les papiers compromettants devant son visage. Il se fige dans un silence plutôt tendu.%SPEECH_ON%Je... je vois... Tu veux plus d\'argent, c\'est ça?%SPEECH_OFF%Vous lui lancez les papiers.%SPEECH_ON%Non. Tu oublies l\'un de mes défauts, et j\'oublie l\'un des tiens. C\'est assez juste, non?%SPEECH_OFF%L\'homme fourre précipitamment les papiers dans sa veste et hoche la tête. | Vous trouvez %employer% occupé à son jardin. Quelques gardes se tiennent à distance, et vous imaginez qu\'un des quelques paysans qui traînent n\'est vraiment qu\'un garde déguisé.%SPEECH_ON%Mercenaire ! C\'est bon de te voir, sauf pour une petite chose.%SPEECH_OFF%Il vous fait signe de vous approcher et baisse la voix.%SPEECH_ON%Tu as laissé s\'échapper quelques-uns de ces gens du convoi. Je ne me souviens pas que cela faisait partie de l\'accord.%SPEECH_OFF%Vous brandissez les papiers compromettants.%SPEECH_ON%Je ne me souviens pas non plus que cela faisait partie de l\'accord.%SPEECH_OFF%%employer% vous dévisage, puis se compose pour que ses gardes ne soient pas suspects.%SPEECH_ON%D\'accord, je prends ça, et j\'oublie toute cette affaire de laisser des gens vivants qui devraient être morts, d\'accord?%SPEECH_OFF%Vous remettez les papiers.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Procured compromising papers");
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
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous retournez chez %employer% avec des nouvelles de votre succès. Il vous accueille chaleureusement - une bourse lourde de couronnes.%SPEECH_ON%Bon travail, mercenaire. Avez-vous, euh, vu quelque chose d\'autre là-bas?%SPEECH_OFF%C\'est une question étrange, mais vous ne la poursuivez pas. Vous dites à l\'homme que tout s\'est déroulé comme le montrent les résultats. Il hoche la tête et vous remercie rapidement avant de retourner à son travail. | %employer% est debout près d\'une fenêtre lorsque vous revenez. Il boit dans une coupe de vin, le faisant tournoyer dans la coupe et dans sa bouche.%SPEECH_ON%Mes petits oiseaux me disent que le convoi a été détruit. Les chansons qu\'ils chantent, sont-elles vraies?%SPEECH_OFF%Vous hochez la tête et lui racontez les nouvelles. Il vous remet un coffre de couronnes, vous remerciant pour vos services avant de retourner à la fenêtre. Vous apercevez un sourire ironique sur le côté de son visage juste avant de partir. | %employer% caresse un chien en revenant. Sa main tremble à travers le pelage.%SPEECH_ON%Je suppose que le convoi est détruit?%SPEECH_OFF%Vous lui racontez les détails. Il hoche la tête, mais sa main caressante s\'arrête.%SPEECH_ON%Avez-vous par hasard... trouvé quelque chose d\'intéressant?%SPEECH_OFF%Vous y réfléchissez, mais ne trouvez rien d\'extraordinaire. L\'homme sourit et retourne caresser son chien.%SPEECH_ON%Merci pour vos services, mercenaire.%SPEECH_OFF% | %employer% écrit lorsque vous entrez dans sa chambre. Il laisse tomber la plume en hâte et se lève.%SPEECH_ON%Alors c\'est détruit, hein? Le convoi, je veux dire.%SPEECH_OFF%Vous rapportez les résultats de vos \'services.\' Il rit et bat des mains ensemble.%SPEECH_ON%Excellent ! Très excellent, mercenaire ! Vous n\'avez aucune idée de ce que votre travail a fait pour moi aujourd\'hui. Bien sûr, votre paiement, comme convenu...%SPEECH_OFF%Il vous remet une bourse de %reward_completion% couronnes. Tout y est, mais vous vous demandez pourquoi l\'homme était si excité par quelque chose d\'apparemment ordinaire... avez-vous manqué quelque chose? | %employer% parle à son conseil lorsque vous revenez. Il les chasse. C\'est un spectacle étrange - voir ces personnages puissants céder la place à un mercenaire hétéroclite. Vous vous tenez un peu plus droit en rapportant la nouvelle de la destruction du convoi.%SPEECH_ON%Merci, mercenaire. Ce sont le genre de nouvelles que j\'attendais. Et votre paiement, bien sûr...%SPEECH_OFF%Il pousse un coffre en bois sur son bureau et le pousse vers vous. Il est assez lourd pour laisser une marque.%SPEECH_ON%%reward_completion% couronnes, comme convenu.%SPEECH_OFF%Vous êtes curieux de savoir pourquoi le noble excuse son conseil pour accueillir un mercenaire, mais décidez de ne pas vous attarder là-dessus.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Destroyed a caravan");
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
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Vous retournez trouver %employer% assis à son bureau, les mains jointes devant lui, les pouces pratiquement enfoncés dans son front. Ses mains tombent en avant quand il commence à parler.%SPEECH_ON%Vous les avez laissés vivre...%SPEECH_OFF%Vous levez un doigt et plaidez votre cause : tous n\'ont pas survécu.%SPEECH_ON%Par la puissance infinie des anciens dieux, pourquoi diable vous ai-je engagé ?%SPEECH_OFF%Il fait une pause, puis hausse les épaules.%SPEECH_ON%D\'accord, je vous donnerai la moitié de ce que nous avions convenu. Vous avez quand même détruit le convoi...%SPEECH_OFF% | %employer% vous accueille à votre retour avec les pieds sur son bureau, le bas de ses chaussures boueuses vous accueillant avec une goutte de boue.%SPEECH_ON%Alors, mercenaire, expliquez-moi ce que c\'était que de vous engager?%SPEECH_OFF%Il lève une main comme pour dire, \'allez-y.\' Vous déclarez que vous avez été engagé pour détruire un convoi et ne laisser aucun survivant. L\'homme lève un doigt.%SPEECH_ON%Répétez cette dernière partie.%SPEECH_OFF%Vous le faites. L\'homme sourit, satisfait de lui-même, mais ensuite le sourire se gâte à votre échec.%SPEECH_ON%D\'accord, vous n\'avez pas fait ce que j\'ai demandé. C\'est bien. Vous avez quand même fait... une partie de ce que je suppose. Le convoi est détruit...%SPEECH_OFF%Il hausse les épaules et vous lance une bourse. C\'est la moitié de ce que vous étiez dû. Vous pensez qu\'il vaut mieux que rien. | %employer% parle à ses gardes lorsque vous revenez. Il les écarte, bien qu\'un reste juste à l\'extérieur du couloir, ses yeux presque enfoncés dans sa tête pour vous surveiller de temps en temps. Vous tirez l\'une des chaises de %employer%, mais il vous dit de rester debout.%SPEECH_ON%Ça sera bref. Vous n\'avez pas fait tout ce que je demandais, mercenaire. Les gens parlent, parlent de vous. Comment parlent-ils de vous si je vous ai demandé de tuer tous les témoins ? Un peu curieux, non ? Je suppose que c\'est parce que vous n\'avez pas tué tous ces témoins, ce qui signifie que vous n\'avez pas fait ce que je demandais.%SPEECH_OFF%Il fait une pause, se frottant deux phalanges dans le front.%SPEECH_ON%D\'accord, voici ce que je vais faire. Je vous donnerai la moitié de ce que nous avions convenu. La moitié pour vous pour avoir détruit le convoi, la moitié pour moi parce que je dois payer pour l\'étouffement. J\'espère que cela vous convient.%SPEECH_OFF%Le garde regarde fixement. Vous hochez la tête et prenez le paiement. | %employer% vous fait signe d\'entrer. Il est debout avec un scribe prêt à tisser une histoire. Votre employeur croise les bras.%SPEECH_ON%Les gens parlent de ce que vous avez fait...%SPEECH_OFF%L\'homme fait signe au scribe qui, étonnamment, ne commence pas à écrire.%SPEECH_ON%J\'ai dû faire quelques paiements pour garder les lèvres scellées, vous comprenez? Donc cela signifie que vous ne recevez que la moitié de ce que nous avions convenu.%SPEECH_OFF%Le vieux scribe sourit. Vous remarquez une bague à son doigt. Elle semble fraîchement frappée. %employer% fronce presque les sourcils, mais le scribe n\'écrit rien, alors vous prenez cela comme un bon signe. Vous prenez votre salaire et prenez congé. | Un groupe d\'hommes souriants quitte la chambre de %employer% lorsque vous arrivez. Il vous demande de fermer la porte derrière vous, puis l\'ouvre immédiatement.%SPEECH_ON%Reconnaissez-vous ces visages? Ce sont les hommes qui ont découvert ce que vous avez fait. Savez-vous combien de couronnes il a fallu pour qu\'ils gardent leurs lèvres scellées ? Savez-vous d\'où viennent ces couronnes ?%SPEECH_OFF%Vous haussez les épaules. L\'homme continue.%SPEECH_ON%Votre salaire, bien sûr. Vous ne recevez que la moitié. Comprenez-vous pourquoi ?%SPEECH_OFF%Vous hochez la tête. Les affaires sont les affaires. En tournant les talons, %employer% vous rattrape.%SPEECH_ON%Et n\'osez même pas penser à tuer l\'un de ces hommes pour récupérer l\'autre moitié de votre salaire, mercenaire !%SPEECH_OFF%Diantre.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Ça aurait pu être pire...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to destroy a caravan without letting anyone escape");
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
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() / 2 + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Vous retournez trouver %employer% assis à son bureau, les coudes sur son bord, les avant-bras levés, les pouces pratiquement enfoncés dans son front. Ses mains tombent en avant quand il commence à parler.%SPEECH_ON%Vous les avez laissés vivre...%SPEECH_OFF%Vous levez un doigt et plaidez votre cause : tous n\'ont pas survécu.%SPEECH_ON%Par la puissance infinie des anciens dieux, pourquoi diable vous ai-je engagé ?%SPEECH_OFF%Il fait une pause, puis éclate de colère.%SPEECH_ON%Comme si je m\'en foutais ? Vous en avez laissé assez vivants pour que ce soit le sujet de conversation dans ce village maudit. Sortez de ma vue avant que je ne demande à l\'un de mes gardes de vous éliminer.%SPEECH_OFF% | Les semelles des pieds de %employer% accueillent votre retour, ses jambes sur son bureau. Vous remarquez qu\'il y a du sang sur ses bottes.%SPEECH_ON%Alors, mercenaire, expliquez-moi ce que c\'était que de vous engager?%SPEECH_OFF%Il jette une main comme pour dire, \'allez-y.\' Vous déclarez que vous avez été engagé pour détruire un convoi et ne laisser aucun survivant. L\'homme lève un doigt.%SPEECH_ON%Répétez cette dernière partie.%SPEECH_OFF%Vous le faites. L\'homme sourit, satisfait de lui-même.%SPEECH_ON%D\'accord, vous n\'avez pas fait ce que j\'ai demandé. Alors, qu\'est-ce que vous faites ici ? Dois-je demander à l\'un de mes gardes de sortir son épée et de vous transpercer avec, ou allez-vous vous excuser volontairement ? Parce que vous et moi n\'avons plus affaire ensemble.%SPEECH_OFF% | %employer% parle à ses gardes lorsque vous revenez. Il écarte quelques-uns tout en ordonnant au plus grand de rester en place. Il vous observe du regard lorsque vous entrez. Vous tirez l\'une des chaises de %employer%, mais il vous dit de rester debout.%SPEECH_ON%Ce sera bref. Vous n\'avez pas fait tout ce que je demandais, mercenaire. Les gens parlent, parlent de vous. Comment parlent-ils de vous si je vous ai demandé de tuer tous les témoins ? Un peu curieux, non ? Dernière fois que j\'ai vérifié, un témoin mort ne parle pas du tout, ce qui me laisse penser que ces témoins ont été bien laissés en vie. Curieux en effet, car ce n\'est pas ce pour quoi je vous payais. Maintenant, avant que je ne demande à mon collègue garde de sortir son épée et de vous transpercer avec, pourquoi ne vous retourneriez-vous pas tout de suite et ne sortiriez-vous pas de ma vue ?%SPEECH_OFF% | %employer% vous fait signe d\'entrer. Il est debout avec un scribe prêt à tisser une histoire. Votre employeur croise les bras.%SPEECH_ON%Les gens parlent de ce que vous avez fait...%SPEECH_OFF%L\'homme fait signe au scribe qui, étonnamment, ne commence pas à écrire.%SPEECH_ON%J\'ai dû faire quelques paiements pour garder les lèvres scellées, vous comprenez? Donc cela signifie que vous ne recevez que la moitié de ce que nous avions convenu.%SPEECH_OFF%Le vieux scribe sourit. Vous remarquez une bague à son doigt. Elle semble fraîchement frappée. %employer% fronce presque les sourcils, mais le scribe n\'écrit rien, alors vous prenez cela pour un bon signe. Vous prenez votre salaire et prenez congé. | Un groupe d\'hommes souriants quitte la chambre de %employer% lorsque vous arrivez. Il vous demande de fermer la porte derrière vous, mais pas avant qu\'un garde n\'entre. Lui et %employer% échangent un signe de tête et un regard, et vous refermez la porte. Votre employeur parle franchement.%SPEECH_ON%Reconnaissez-vous ces gens qui viennent de sortir d\'ici ? Ce sont les hommes qui ont découvert ce que vous avez fait. Savez-vous combien de couronnes il a fallu pour qu\'ils gardent leurs lèvres scellées ? Savez-vous d\'où viennent ces couronnes ?%SPEECH_OFF%Vous haussez les épaules. L\'homme continue.%SPEECH_ON%Votre salaire, bien sûr. Pour garder toutes leurs gueules closes, j\'ai dû payer une jolie somme en effet.%SPEECH_OFF%Vous hochez la tête. Les affaires sont les affaires et, dans ce cas, vous n\'en recevrez aucune. En tournant les talons, %employer% vous rattrape.%SPEECH_ON%Et n\'osez même pas penser à tuer l\'un de ces hommes pour récupérer votre salaire, mercenaire !%SPEECH_OFF%Diantre.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Maudite soit cette mission !",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to destroy a caravan without letting anyone escape");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure3",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_75.png[/img]{En attendant le convoi, un couple de voyageurs remonte d\'où le convoi devrait aller. Ils commentent en détail un chariot qui est sans aucun doute celui que vous auriez dû traquer. Aucun intérêt de retourner voir %employer%. | Les rumeurs sur la route laissent entendre que le convoi que vous auriez dû traquer vous a échappé et a atteint sa destination. La compagnie ne devrait pas s\'embêter à retourner voir %employer%.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Maudite soit cette mission !",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to destroy a caravan");
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
			"bribe",
			this.m.Flags.get("Bribe1")
		]);
		_vars.push([
			"bribe2",
			this.m.Flags.get("Bribe2")
		]);
		_vars.push([
			"start",
			this.World.getEntityByID(this.m.Flags.get("InterceptStart")).getName()
		]);
		_vars.push([
			"dest",
			this.World.getEntityByID(this.m.Flags.get("InterceptDest")).getName()
		]);
		_vars.push([
			"swordmaster",
			this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
		]);
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

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.World.FactionManager.isGreaterEvil())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
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

		this.contract.onDeserialize(_in);
	}

});


this.return_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.return_item";
		this.m.Name = "Retourner Objet";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 400 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local items = [
			"Collection de Pièces Rares",
			"Bâton de Cérémonie",
			"Idole de la Fertilité",
			"Talisman en Or",
			"Tome de Connaissance des Arcanes",
			"Coffre",
			"Statuette Démoniaque",
			"Crâne de Cristal"
		];
		local r = this.Math.rand(0, items.len() - 1);
		this.m.Flags.set("Item", items[r]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Suivez les traces près de %townname%",
					"Ramener %item% à %townname%"
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
					if (this.Contract.getDifficultyMult() >= 0.95)
					{
						this.Flags.set("IsNecromancer", true);
					}
				}
				else if (r <= 30)
				{
					this.Flags.set("IsCounterOffer", true);
					this.Flags.set("Bribe", this.Contract.beautifyNumber(this.Contract.m.Payment.getOnCompletion() * this.Math.rand(100, 300) * 0.01));
				}
				else
				{
					this.Flags.set("IsBandits", true);
				}

				this.Flags.set("StartDay", this.World.getTime().Days);
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
					this.Const.World.TerrainType.Mountains
				]);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Thieves", false, this.Const.World.Spawn.BanditRaiders, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Un groupe de voleurs et de bandits.");
				party.setFootprintType(this.Const.World.FootprintsType.Brigands);
				party.setAttackableByAI(false);
				party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Brigands, 0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_bandits_0" + this.Math.rand(1, 6));
				local c = party.getController();
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Suivez les traces %direction% de %townname%",
					"Ramener %item% à %townname%"
				];

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					if (this.Flags.get("IsCounterOffer"))
					{
						this.Contract.setScreen("CounterOffer1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("BattleDone");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
				else if (this.World.getTime().Days - this.Flags.get("StartDay") >= 3 && this.Contract.m.Target.isHiddenToPlayer())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					if (this.Flags.get("IsNecromancer"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
						this.Contract.setScreen("Necromancer");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
						this.Contract.setScreen("Bandits");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Ramener %item% à %townname%"
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% marche de long en large en expliquant ce qui le dérange.%SPEECH_ON%Il y a eu un acte de vol audacieux ! Les méprisables brigands ont volé mon %itemLower% qui a une valeur incommensurable pour moi. Je vous implore de traquer ces voleurs et de me rendre cet objet.%SPEECH_OFF%Il baisse la voix pour insister.%SPEECH_ON%Non seulement vous serez payé généreusement, mais vous rassurerez également les esprits inquiets des bonnes gens de %townname% !%SPEECH_OFF% | %employer% est en train de lire un de ses nombreux parchemins. Il le jette avec colère sur une pile d\'autres.%SPEECH_ON%Les habitants de %townname% sont légitimement furieux. Savez-vous qu\'un brigand, peut-être de mèche avec d\'autres vagabonds, a réussi à nous dérober notre %itemLower% ? Cet artefact a une valeur incommensurable pour moi ! Et... pour le peuple, bien sûr.%SPEECH_OFF%Vous haussez les épaules.%SPEECH_ON%Et vous voulez que je le récupère pour vous ?%SPEECH_OFF%L\'homme vous pointe du doigt.%SPEECH_ON%Précisément, mercenaire intelligent ! C\'est exactement ce que je veux que vous fassiez. Suivez les traces du voleur et retournez l\'objet qui revient de droit à m... la ville !%SPEECH_OFF% | %employer% fait tourner une pomme dans sa main. Il semble frustré par celle-ci, presque comme s\'il souhaitait qu\'elle soit autre chose, comme un bibelot de valeur ou peut-être simplement un fruit plus savoureux.%SPEECH_ON%Avez-vous déjà perdu quelque chose que vous aimiez ?%SPEECH_OFF%Vous haussez les épaules et répondez.%SPEECH_ON%Il y avait cette fille...%SPEECH_OFF%L\'homme secoue la tête.%SPEECH_ON%Non, pas une femme. Plus important. Parce que c\'est le cas ! Des voleurs ont volé  %itemLower%. Je ne sais pas comment ils ont réussi à passer mes gardes. Mais je sais que si je vous mets sur leur piste, je récupérerai ce qui me revient de droit. N\'est-ce pas ? Ou ai-je été induit en erreur quant à la qualité de vos services ?%SPEECH_OFF% | Un chien ronfle aux pieds de %employer%. Il se penche en avant pour caresser doucement le chien derrière les oreilles.%SPEECH_ON%J\'ai entendu dire que vous aviez le nez pour trouver des gens, mercenaire. Pour... résoudre les problèmes.%SPEECH_OFF%Vous acquiescez. C\'est vrai, après tout.%SPEECH_ON%Bien... bien... J\'ai une tâche pour vous. Une tâche simple. Un objet de grande valeur pour moi a été volé, %itemLower%. J\'ai besoin que vous retrouviez ceux qui l\'ont volé, que vous les tuiez, évidemment, et que vous rameniez l\'objet.%SPEECH_OFF% | Un oiseau est perché sur la fenêtre de %employer%. L\'homme, assis, le montre du doigt.%SPEECH_ON%Je me demande si c\'est comme ça qu\'ils sont entrés. Les brigands, je veux dire. Je pense qu\'ils ont dû se faufiler par une fenêtre et ressortir aussitôt. C\'est comme ça qu\'ils sont partis avec %itemLower%.%SPEECH_OFF%L\'homme se lève lentement et traverse la pièce à grands pas. Il s\'accroupit, prêt à bondir sur l\'oiseau, mais la créature se sauve avant que l\'homme ne puisse broncher.%SPEECH_ON%Merde.%SPEECH_OFF%Il retourne à son siège, s\'essuyant les mains comme s\'il avait transpiré pendant sa tentative d\'embuscade aviaire.%SPEECH_ON%Ma tâche est simple, mercenaire. Ramenez-moi mes biens. Tue les brigands, aussi, si ça ne vous dérange pas.%SPEECH_OFF% | La poussière recouvre la table de %employer%, mais il y a un endroit étrangement plus propre que le reste. Il y fait un geste.%SPEECH_ON%C\'est là que se trouvait %itemLower%. Comme vous pouvez le constater, l\'objet n\'est plus là.%SPEECH_OFF%Vous acquiescez. Il semble bien que l\'objet ait disparu.%SPEECH_ON%Les voleurs qui l\'ont pris devraient être faciles à traquer. Ce sont de bons penseurs la nuit, ces brigands, mais ils font beaucoup d\'erreurs le jour. Empreintes de pas, couronnes mal dépensées... vous devriez être capable de les retrouver facilement.%SPEECH_OFF%Il vous regarde d\'un œil sévère.%SPEECH_ON%Vous comprenez, mercenaire ? Je veux que vous récupériez ma propriété. Je veux qu\'elle soit placée là où elle doit être. Et... Je veux que ces voleurs soient morts dans la boue.%SPEECH_OFF%}",
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
			ID = "Bandits",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Brigands ! Comme l\'avait pensé votre employeur. Ils ont l\'air effrayés, comprenant sans doute que la colère bien payée de %employer% est sur le point de s\'abattre sur eux. | Ah, les voleurs sont tout à fait humains - une simple équipe de vagabonds et de brigands. Ils s\'arment alors que vous ordonnez à vos hommes d\'attaquer. | Vous surprenez un groupe de brigands en train de trimballer les biens de votre employeur. Ils semblent choqués que vous les ayez trouvés ici et vous ne perdez pas de temps à essayer de parlementer - ils s\'arment et vous ordonnez à %companyname% de charger.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux Armes!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Les brigands sont là, comme prévu, mais ils remettent %itemLower% à un homme aux vêtements sombres et en lambeaux. Votre présence, sans surprise, met un terme à la transaction et tant les brigands que le personnage macabre prennent les armes. | Vous surprenez des brigands en train d\'échanger la propriété de %employer% à ce qui semble être un nécromancien ! Peut-être qu\'il le voulait pour jeter une sorte de sort vicieux sur la maison. D\'un certain point de vue, l\'idée ne semble pas si mauvaise... mais, l\'homme vous paie pour une raison. Chargez ! | La propriété de %employer% est vendue par des brigands à un homme pâle en noir ! Il vous regarde avant tout le monde, ses yeux noirs et perçants se posent sur votre compagnie en un instant.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux Armes!",
					function getResult()
					{
						this.Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = this.Const.World.Spawn.Troops.Necromancer
						});
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CounterOffer1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Vous nettoyez le sang de votre épée et allez récupérer l\'objet. Alors que vous vous penchez pour le ramasser, vous apercevez un homme qui vous observe au loin. Il s\'avance, ses deux mains jointes par des manches longues.%SPEECH_ON%Je vois que vous avez tué les hommes de mon maître.%SPEECH_OFF%En rengainant votre épée, vous faites un signe de tête à l\'homme. Il continue.%SPEECH_ON%Mon maître a payé cher pour cet artefact. Il semble que ceux qu\'il a payés ne soient plus redevables, alors je peux peut-être vous parler directement. Je vous donnerai %bribe% couronnes pour l\'objet.%SPEECH_OFF%C\'est... une bonne somme d\'argent. Cependant, %employer% ne sera pas content si vous décidez d\'accepter... | Après la bataille, un homme émerge d\'une ligne d\'arbres, en frappant ses mains ensemble.%SPEECH_ON%J\'ai payé ces hommes un grand nombre de couronnes, mais il semble que j\'aurais dû vous payer. Et maintenant que tous ces brigands sont morts, je peux !%SPEECH_OFF%Vous dites à l\'homme d\'en venir au fait avant de le passer à l\'épée. Il fait un geste vers l\'artefact.%SPEECH_ON%Je vais vous payer %bribe% couronnes pour l\'objet. C\'est ce que je devais à ces voleurs, plus un peu plus. Qu\'en dites-vous ?%SPEECH_OFF%%employer% ne va pas apprécier votre trahison, mais c\'est une bonne somme d\'argent... | La bataille terminée, vous ramassez %itemLower% et l\'examinez. Cela valait-il vraiment la peine de sacrifier la vie de tant de personnes ?%SPEECH_ON%Je sais ce que vous pensez, mercenaire.%SPEECH_OFF%La voix vous interrompt. Vous tirez votre épée et la dirigez vers un étranger qui semble être apparu de nulle part.%SPEECH_ON%Tu te dis, et si quelqu\'un payait cher pour voler cet artefact ? Et si ce quelqu\'un me payait une bonne somme d\'argent ? Peut-être... plus que l\'homme qui vous a payé pour le récupérer en premier lieu.%SPEECH_OFF%Vous baissez votre arme et hochez la tête.%SPEECH_ON%Une pensée intéressante.%SPEECH_OFF%L\'homme sourit.%SPEECH_ON%%bribe% couronnes. C\'est le prix que je vous donnerai pour ça. C\'était la part des voleurs, plus un supplément. Un accord des plus équitable. Bien sûr, votre employeur sera très mécontent, mais... ce n\'est pas à moi de décider.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je sais reconnaître une bonne affaire quand j\'en vois une. Donnez-moi les couronnes.",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						return "CounterOffer2";
					}

				},
				{
					Text = "Nous sommes payés pour le rendre, et c\'est ce que nous ferons.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CounterOffer2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_76.png[/img]Vous lui remettez %itemLower% et l\'étranger vous glisse une sacoche très lourde et très tombante. L\'affaire est conclue. On peut supposer que votre employeur ne sera pas content.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bon salaire.",
					function getResult()
					{
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Non retour du bien volé " + this.Flags.get("Item"));
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
			ID = "BattleDone",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{La bataille terminée, vous récupérez %itemLower% des griffes décharnées de vos ennemis et vous vous préparez à retournez voir %employer%. Il sera sûrement heureux de voir votre succès ! | Ceux qui ont volé %itemLower% sont morts, et heureusement vous avez pu trouver l\'objet lui-même. %employer% sera très heureux de votre travail ici. | Vous avez trouvé les responsables du vol de %itemLower% et les avez passés au fil de l\'épée. Maintenant, il ne te reste plus qu\'à remettre %itemLower% entre les mains de %employer% et obtenir votre récompense ! | La bataille est terminée et %itemLower% a été facile à trouver parmi les cadavres de vos ennemis. Vous devriez probablement le rendre à %employer% pour votre juste récompense !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Allons chercher notre paye.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% vous prend %itemLower% et le serre dans ses bras comme s\'il avait récupéré un enfant perdu. Ses yeux deviennent un peu larmoyants rien qu\'en regardant son artefact.%SPEECH_ON%Merci, mercenaire. Ça signifie beaucoup pour moi... Je veux dire, euh, la ville. Vous avez notre gratitude !%SPEECH_OFF%Il s\'arrête quand vous le fixez. Ses yeux se dirigent vers un coin de la pièce.%SPEECH_ON%Notre... gratitude, mercenaire...%SPEECH_OFF%Un grand coffre en bois est ouvert par un garde. Vous comptez les couronnes et vous partez. | Quand vous retournez voir %employer%, il joue avec un oiseau dans une cage.%SPEECH_ON%Ah, le retour du mercenaire... et ?%SPEECH_OFF%Vous montrez l\'artefact et le posez sur son bureau. Il le prend, le tourne, hoche la tête, puis le range.%SPEECH_ON%Excellent. Et pour vos problèmes...%SPEECH_OFF%Il fait signe de la main vers un coffre en bois rempli de couronnes. | %employer% repose ses jambes sur deux chiens, chacun s\'étant évanoui sur l\'autre.%SPEECH_ON%Ces bêtes pourraient m\'arracher la gorge, et pourtant... regardez-les. Comment est-ce possible ? Je ne les ai même pas entraînés. Quelqu\'un d\'autre l\'a fait. Je suis un étranger pour eux et pourtant ils sont là.%SPEECH_OFF%Vous placez l\'artefact sur la table de l\'homme et le faites glisser. Il se penche en avant, le prend, puis le place sous son bureau. Quand sa main revient, il a une sacoche en main. Il la jette par-dessus.%SPEECH_ON%Comme promis. Bon travail, mercenaire.%SPEECH_OFF% | Lorsque vous entrez dans le bureau de %employer%, il y a une foule de gardes qui l\'entourent. Pendant une seconde, vous pensez être tombé sur un coup d\'État, mais les hommes s\'en vont, laissant derrière eux des dés et des cartes. %employer% vous fait signe d\'entrer.%SPEECH_ON%Entrez, entrez. Je viens de perdre un bon nombre de couronnes, mercenaire. Peut-être que vous avez apporté quelque chose pour aider à soulager mes douleurs... ?%SPEECH_OFF%Vous sortez %itemLower% et le tenez dans votre main. L\'homme le prend avec précaution.%SPEECH_ON%Bien... très bien... votre paye, bien sûr, est ici.%SPEECH_OFF%Il remet une sacoche de couronnes avant de se retourner sur sa chaise. Il semble trop absorbé par l\'artefact pour dire quoi que ce soit d\'autre. | %employer% sourit en vous voyant entrer.%SPEECH_ON%Mercenaire, mercenaire, me ferez-vous part de votre succès ?%SPEECH_OFF%Vous sortez l\'artefact et le posez sur sa table.%SPEECH_ON%Bien sûr.%SPEECH_OFF%L\'homme fait un bond en avant sur sa chaise et prend l\'objet. Il se retourne vers vous, se rassure pour retrouver son calme.%SPEECH_ON%Bien. Vous avez bien fait. Très bien. %reward_completion% couronnes, comme promis.%SPEECH_OFF%Il vous remet un sac de pièces.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Objet volé retourné " + this.Flags.get("Item"));
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
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_75.png[/img]{Vous vous abaissez, laissant un peu de terre passer entre vos doigts. Mais ce n\'est que de la terre - il n\'y a aucune trace de pas qui ait traversé son chemin. En fait, vous n\'avez pas vu d\'empreintes depuis un bon moment. %randombrother% vous rejoint, accroupi et haussant les épaules.%SPEECH_ON%Monsieur, je pense que nous les avons perdus.%SPEECH_OFF%Vous acquiescez. Ça ne va pas faire plaisir à %employer%, mais c\'est comme ça. | Vous suivez la piste de %itemLower% volé depuis un bon moment maintenant, mais les pistes se sont taries. Les roturiers que vous croisez ne savent rien, et la terre ne montre aucune trace de pas qui puisse être suivie. A toutes fins utiles, %itemLower% a disparu. %employer% ne sera pas content. | Une empreinte laissée assez longtemps est vite piétinée par une autre. Et une autre. Et une autre. Vous avez passé tellement de temps à rattraper les voleurs de %itemLower% que les chemins du monde, toujours occupés, ont couvert leurs traces. Vous n\'avez aucun espoir de les retrouver maintenant et %employer% sera très mécontent. | Les traces des voleurs de %itemLower% se sont taries. Les dernières traces de pas que vous avez suivies vous ont mené à une ferme, et ils n\'avaient pas l\'air d\'être des voleurs, et ils n\'en connaissaient pas non plus. %employer%  ne sera pas ravi de la perte de ses biens, mais il n\'y a pas grand chose que vous puissiez faire maintenant.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Au diable ce contrat !",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "N\'a pas réussi à retourner l\'objet volé " + this.Flags.get("Item"));
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
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
		_vars.push([
			"item",
			this.m.Flags.get("Item")
		]);
		_vars.push([
			"itemLower",
			this.m.Flags.get("Item").tolower()
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
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


this.hunting_schrats_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_schrats";
		this.m.Name = "Bois Hantés";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Chassez ce qui tue les gens dans les bois autour de " + this.Contract.m.Home.getName()
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
					this.Flags.set("IsDirewolves", true);
				}
				else if (r <= 25)
				{
					this.Flags.set("IsGlade", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsWoodcutter", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local x = this.Math.max(3, playerTile.SquareCoords.X - 11);
				local x_max = this.Math.min(mapSize.X - 3, playerTile.SquareCoords.X + 11);
				local y = this.Math.max(3, playerTile.SquareCoords.Y - 11);
				local y_max = this.Math.min(mapSize.Y - 3, playerTile.SquareCoords.Y + 11);
				local numWoods = 0;

				while (x <= x_max)
				{
					while (y <= y_max)
					{
						local tile = this.World.getTileSquare(x, y);

						if (tile.Type == this.Const.World.TerrainType.Forest || tile.Type == this.Const.World.TerrainType.LeaveForest || tile.Type == this.Const.World.TerrainType.AutumnForest)
						{
							numWoods = ++numWoods;
						}

						y = ++y;
					}

					x = ++x;
				}

				local tile = this.Contract.getTileToSpawnLocation(playerTile, numWoods >= 12 ? 6 : 3, 11, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Schrats", false, this.Const.World.Spawn.Schrats, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Une créature d'écorce et de bois, se fondant entre les arbres et marchant lentement, ses racines creusant le sol.");
				party.setFootprintType(this.Const.World.FootprintsType.Schrats);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 2; i = ++i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 7, disallowedTerrain);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Schrats, 0.75);
					}
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(5);
				roam.setMaxRange(10);
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.SnowyForest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
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
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					this.Contract.setScreen("Victory");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					local tileType = this.World.State.getPlayer().getTile().Type;

					if (tileType == this.Const.World.TerrainType.Forest || tileType == this.Const.World.TerrainType.LeaveForest || tileType == this.Const.World.TerrainType.AutumnForest)
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);

					if (this.Flags.get("IsDirewolves"))
					{
						this.Contract.setScreen("Direwolves");
					}
					else
					{
						this.Contract.setScreen("Encounter");
					}

					this.World.Contracts.showActiveContract();
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
					"Retournez à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_62.png[/img]{Vous trouvez le panneau de ville jonché de notes écrites dans de la ferraille bon marché ou même sur des feuilles et maintenues là par le plus rouillé des clous. %employer% s\'approche de vous.%SPEECH_ON%Nous avons attendu un homme de votre genre, mercenaire. Des gens continuent à disparaître dans les bois et je n\'ai aucun moyen de les récupérer. J\'ai entendu des histoires d\'arbres qui se déplacent et tuent les bûcherons qui taillent dans leurs troncs, mais qui sait si c\'est vrai. J\'ai besoin de votre compagnie pour aller dans les bois et trouver ce qui cause ce carnage. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% fait rouler un morceau d\'écorce entre ses doigts comme une pièce de monnaie. Il soupire et la jette par-dessus sa table.%SPEECH_ON%J\'ai entendu des histoires de bûcherons et de colporteurs disparus dans les bois. Certains disent que les arbres s\'animent pour se venger, mais ça me semble être des foutaises. Quoi qu\'il en soit, une somme d\'argent a été préparée pour aider à résoudre ce problème et je suis prêt à la donner à qui s\'en chargera. Qu\'en dites-vous, mercenaire, êtes-vous intéressé par la recherche des monstres qui hantent cette ville ?%SPEECH_OFF% | Il y a un tas de sciure sur le bureau de %employer% et ses yeux fixent intensément le monticule. Il vous fait signe d\'entrer sans briser son regard, et parle tout de même.%SPEECH_ON%Les bûcherons locaux signalent que des hommes disparaissent dans les bois. Ils disent que les arbres sont les coupables, quelque chose à propos de monstres faits de bois et de racines. Une partie de moi pense qu\'ils cachent un meurtre et ne veulent pas l\'avouer, mais peut-être que les histoires effrayantes sont vraies. Quoi qu\'il en soit, j\'ai des pièces pour y mettre fin et vous êtes l\'homme de la situation, non ?%SPEECH_OFF% | En entrant dans le bureau de %employer%, votre pied s\'accroche à une latte de bois coupé. Elle bascule et tombe à plat, le tronc rond et son écorce se dressant devant vous. Le maire frappe dans ses mains.%SPEECH_ON%Donc il n\'a pas bougé ! Ah, vous vous demandez probablement de quoi je parle. Tenez.%SPEECH_OFF%Il vous jette un dessin de ce qui ressemble à un arbre avec des bras. Il poursuit .%SPEECH_ON%J\'ai entendu des bruits des couloirs disant que les arbres prenaient vie. J\'ai même un ami de confiance qui travaille comme bûcheron qui m\'a dit, sans détour, qu\'une bête spirituelle dans les arbres avait pris le bois et les racines et les utilisait comme armes. Quoi qu\'il en soit, j\'ai besoin d\'une équipe de tueurs pour le trouver. Est-ce que vous et votre compagnie êtes prêts pour cette tâche ?%SPEECH_OFF% | %employer% est trouvé assis sur un tronc d\'arbre alors qu\'il est entouré de paysans. Après quelques minutes, il jette ses mains en l\'air.%SPEECH_ON%Vous voyez ! Il n\'y a pas de problème ! C\'est un arbre ! Un arbre, vous voyez ?%SPEECH_OFF%Les paysans ne sont pas convaincus et parlent de monstres dans la forêt qui ont la forme de la forêt elle-même. En soupirant, %employer% vous tend la main.%SPEECH_ON%Bien, nous allons engager des mercenaires ? Est-ce que ça convient à tout le monde ? Qu\'en dites-vous, mercenaire ? Nous avons de l\'argent à donner et des arbres meurtriers à chasser. Ça vous convient ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Intéressé pour sûr. | Parlons salaire. | Parlons des couronnes. | Cela va vous coûter cher. | Une chasse sauvage à travers la forêt, alors ? Comptez sur moi. | %companyname% peut aider, pour le bon prix.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne ressemble pas à notre type de travail. | Je ne veux pas mener les hommes sur une fausse piste à travers les bois. | Je ne pense pas. | Je dis non. Les hommes préfèrent les ennemis fait de chair et de sang.}",
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
			ID = "Banter",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_25.png[/img]{La compagnie est de plus en plus sur les nerfs, comme le serait \'importe quelle compagnie dans une forêt en chassant des arbres meurtriers. Au moindre craquement de branche, les hommes dégainent leurs épées et l\'un d\'entre eux hurle lorsqu\'une feuille tombée tombe dans sa nuque. Votre ennemi marque déjà des victoires sans même avoir à faire quoi que ce soit ! | La forêt rend les hommes inquiets. Vous leur dites de se ressaisir car l\'ennemi est là, d\'une manière ou d\'une autre, et il ne sert à rien d\'avoir peur de ce qui est certain. C\'est vous qu\'il faut craindre, %companyname%, et ces arbres meurtriers regretteront que vous ne soyez pas de simples bûcherons quand vous en aurez fini avec eux ! | %randombrother% soulève son arme sur ses épaules et titube en balançant ses bras de façon spectaculaire. Il jauge le feuillage de la forêt.%SPEECH_ON%Hey cap\', que diriez-vous de démolir un de ces arbres et d\'appeler ça n travail bien fait ! Donnons-leur un tas de bois coupé et du paillis et personne ne verra la différence quand tout sera dit et raconté. S\'ils posent des questions, disons-leur que l\'écorce a du mordant !%SPEECH_OFF%Les hommes rient et vous dites au mercenaire que vous allez prendre son idée en considération.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Regardez où vous mettez les pieds.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_107.png[/img]{Alors que vous êtes en train d\'observer le paysage, %randombrother% crie que quelque chose bouge au loin. Lorsque vous arrivez à ses côtés, il pointe un doigt dans le feuillage et tire son épée. Un grand arbre se dirige vers vous, marchant d\'un côté à l\'autre comme un vieil homme dans les couloirs d\'une bibliothèque. Vous tirez votre propre épée et ordonnez aux hommes de se mettre en formation. | %randombrother% est assis sur un arbre tombé quand il se lève soudainement en hurlant et en attrapant son arme. Vous regardez pour voir l\'arbre lui-même s\'élever dans les airs, des mottes de terre pleuvant en dessous et un grand fossé humide laissé comme s\'il avait été couché là depuis des lustres. Il s\'appuie sur ses frères plus sains comme un ivrogne sur l\'épaule d\'un ami. Lentement, il tourne autour de son corps, une paire d\'yeux verts s\'allume quelque part au fond de son tronc, et ses branches pointues tournent avec lui, s\'étalant largement avec leurs ombres tombant sur la compagnie comme une toile. Vous saisissez votre épée et ordonnez aux hommes de se mettre en formation.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chargez !",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Direwolves",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_118.png[/img]{Vous apercevez des paires d\'yeux verts qui brillent au loin. Il s\'agit sans doute des schrats eux-mêmes, et vous ordonnez à vos hommes de grimper vers eux sans faire de bruit. Au sommet d\'une colline, vous découvrez que le tronc d\'un arbre est entouré de loups-garous. Ils sont accroupis sous l\'arbre comme des chevaliers jurant fidélité. Votre arrivée n\'est pas passée inaperçue car le schrat se penche en avant avec un chant qui semble ancien. Les créatures à ses racines grognent et se tournent comme si on leur ordonnait. Vous ne savez pas trop quoi penser d\'une telle allégeance arboricole, mais %companyname% les brisera quoi qu\'il arrive.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chargez !",
					function getResult()
					{
						this.Contract.addUnitsToEntity(this.Contract.m.Target, this.Const.World.Spawn.Direwolves, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_121.png[/img]{Les schrats sont abattus, leurs restes arboricoles ne ressemblant plus qu\'à des arbres ordinaires. Vous sculptez des trophées et des preuves pour les remener à %employer%. | Vous regardez un arbre abattu, puis un schrat abattu. Vous ne voyez presque aucune différence entre les deux, ce qui vous fait réfléchir à tous ces arbres soi-disant morts sur lesquels vous avez sauté toute votre vie. N\'étant pas du genre à vous attarder sur de tels sujets, vous ordonnez à la compagnie de prendre des trophées comme preuve de la bataille et vous vous préparez à retourner voir %employer%. | Les schrats sont abattus, chacun drapé contre le reste du feuillage de la forêt, comme des bagarreurs se reposant entre deux rounds. Vous passez sous les racines de l\'un d\'entre eux et l\'examinez attentivement, mais il ne semble pas différent des autres arbres. Vous ordonnez à la compagnie de prendre les trophées qu\'elle peut pour les montrer à %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "C\'est terminé.",
					function getResult()
					{
						if (this.Flags.get("IsGlade") && this.World.Assets.getStash().hasEmptySlot())
						{
							return "Glade";
						}
						else if (this.Flags.get("IsWoodcutter") && this.World.Assets.getStash().hasEmptySlot())
						{
							return "DeadWoodcutter";
						}
						else
						{
							return 0;
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Glade",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_121.png[/img]{Alors que vous quittez le champ de bataille, %randombrother% remarque que les environs ont l\'air plutôt mûrs. et prêts à être récupérés. Vous vous retournez pour voir qu\'il a effectivement raison : une belle récolte d\'arbres a servi d\'hôte aux schrats, vraisemblablement choisis pour une bonne raison. Et si les schrats l\'ont pris pour un bon foyer, cela signifie sûrement que le bois est très bon. Vous ordonnez aux hommes d\'utiliser cette clairière de qualité et d\'abattre autant d\'arbres que le temps et l\'énergie le permettent. Le bois récolté est vraiment très bon.\n\n Il commence à pleuvoir lorsque vous quittez la scierie improvisée.}",
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
			],
			function start()
			{
				local item = this.new("scripts/items/trade/quality_wood_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/trade/quality_wood_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "DeadWoodcutter",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_121.png[/img]{Au moment où vous partez, une lueur attire votre attention. Vous vous retournez et arrivez sur le tronc d\'un des schrats. Une hache est encastrée dans le bois. La mousse a depuis longtemps envahi le manche, mais le métal de l\'outil est intact, sans la moindre trace de rouille. En grattant la mousse, vous découvrez des bouts de doigts en bois, toujours en pleine prise. Le traçage des doigts se termine au niveau du tronc d\'arbre où le poignet devient une veine de bois. Vous la suivez jusqu\'à un visage de bois à la gueule tordue, comme un visage de cire brune fondue par le temps. L\'armature d\'un casque se tord autour du visage et là, une armoirie de plaque en dessous qui vous fait penser à un réservoir de chasseur de cerfs.\n\nVous secouez la tête et récupérez la hache, la libérant et jetant les doigts de bois de son manche. Le visage difforme observe fixement votre vol, son regard étant préservé dans dans la mort. Vous ne vous attardez pas sur cette vision et retournez à la compagnie avec la hache.}",
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
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/fighting_axe");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/greataxe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez a " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_62.png[/img]{Vous trouvez %employer% en train de sculpter un jouet dans du bois. Il souffle sur les copeaux de son bureau et fait tomber la sciure de ses doigts. Il pose le jouet sur ses jambes, en forme de chevalier qui a mangé trop de bonbons, mais il tombe aussitôt. En soupirant, il se tourne vers vous pour demander de l\'aide. Vous tirez la tête du schrat dans la pièce et la laissez se balancer d\'avant en arrière sur le sol jusqu\'à ce qu\'elle repose sur l\'une de ses cornes. Le maire acquiesce.%SPEECH_ON%Bien joué, mercenaire.%SPEECH_OFF%Il va chercher la récompense promise. | %employer% est choqué de votre retour, et choqué par la dépouille du schrat que vous avez apportée sur le pas de sa porte. Il la regarde, toujours incrédule quant à sa provenance. Comme un chat qui tripote les ailes tondues d\'un insecte, il fouille le tas avec son pied.%SPEECH_ON%Je n\'avais pas imaginé que vous pourriez les rapporter, mais je suis damné si vous n\'avez pas trouvé et tué ces saloperies d\'arbres. Eh bien, je vais chercher votre récompense.%SPEECH_OFF%Il vous apporte les pièces promises. | %employer% est en train d\'exécuter une sculpture sur le bras d\'une chaise en bois quand vous le trouvez. Il lève les yeux à votre arrivée et vous lui présentez les restes d\'un schrat. L\'homme se lève et prend un morceau, il vient s\'asseoir sur sa chaise pour bien voir, mais sa chaise explose sous son cul et fait claquer les planches contre le sol avec un énorme fracas, comme si son dessein initial était de faire une grande cacophonie. %employer% jette ses outils dans un excès de colère.%SPEECH_ON%Par les dieux, je ferais mieux de ne pas me transformer en sauvage et de les menacer. Je suppose que c\'est en faisant cela que je me suis retrouvé dans cet état en premier lieu.%SPEECH_OFF%Vous acquiescez, affirmant qu\'il n\'est pas sage de mettre en colère les anciens dieux. Vous suggérez également qu\'il est imprudent de laisser un mercenaire ne pas être payé pour son travail. Le maire se lève d\'un bond et va chercher une sacoche de pièces en courant.%SPEECH_ON%Bien sûr, mercenaire ! Vous n\'avez pas besoin de me faire la leçon sur ce sujet !%SPEECH_OFF% | Vous trouver %employer% sous un bosquet d\'arbres. Il a les mains sur son ventre et regarde le ciel. Un sourire traverse son visage et il pointe un nuage vers le haut, comme si quelqu\'un devait être à côté de lui pour témoigner, mais il est tout seul et ne dit rien. Vous jetez un morceau de schrat à ses pieds et lui demandez s\'il a votre paiement. Il se retourne et vous présente une sacoche que vous n\'aviez pas vu jusqu\'à présent.%SPEECH_ON% Des bûcherons vous ont vu vous battre avec eux et m\'ont raconté l\'histoire. Je ne pensais pas que les schtrats étaient réels. Les arbres mortels semblent être une superstition pour les enfants, mais je suppose que j\'ai encore des choses à apprendre. Bon travail, mercenaire.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of living trees");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/disappearing_villagers_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
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


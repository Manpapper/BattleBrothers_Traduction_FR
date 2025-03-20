this.hunting_sand_golems_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_sandgolems";
		this.m.Name = "Sables Mouvants";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 850 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Chassez ce qui tue les gens dans le désert autour de " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10 && this.Contract.getDifficultyMult() >= 1.15)
				{
					this.Flags.set("IsEarthquake", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Desert)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 8, 12, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Ifrits", false, this.Const.World.Spawn.SandGolems, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.setDescription("Des créatures de pierre vivante façonnées par la chaleur torride et le soleil brûlant du sud.");
				party.setFootprintType(this.Const.World.FootprintsType.SandGolems);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 1; i = ++i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, disallowedTerrain);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.SandGolems, 0.75);
					}
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(8);
				roam.setMaxRange(12);
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Desert, true);
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

					if (tileType == this.Const.World.TerrainType.Desert)
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsEarthquake"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Earthquake");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
					}
				}
				else if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% lève la tête et semble vous regarder par de haut. C\'est un ricanement puissant, mais il vous fait entrer. Le Vizir frappe dans ses mains et un serviteur vient à vous avec un parchemin, le déplie et lit.%SPEECH_ON%Des Ifrits ont été repérés dans les sables. Un mercenaire - c\'est-à-dire vous, voyageur - est....%SPEECH_OFF%Le Vizir frappe à nouveau dans ses mains.%SPEECH_ON%Ça pourrait être lui, serviteur. Ça POURRAIT être lui. Faites attention à vos mots.%SPEECH_OFF%Vous savez, le serviteur veut dire qu\'il n\'a pas écrit le parchemin, mais il le garde pour lui. Il termine le parchemin.%SPEECH_ON%...est d\'être récompensé pour ramener les sables brûlants à leur état naturel. L\'anéantissement de ces monstres sera compensé par %reward% couronnes.%SPEECH_OFF%Le rouleau se relève, le serviteur l\'attrape sur les côtés, et il disparaît à nouveau de la scène. Vous voyez à nouveau le Vizir, mais il ne porte plus attention dû au fait qu\'une esclave lui donne du raisin. | Un Vizir du nom de %employer% vous salue, bien que toute la grâce de la réunion soit entièrement investie dans le côté bureaucratique de la discussion.%SPEECH_ON%Mercenaire, les Ifrits rôdent dans les sables. Nous avons fait appel à vos services pour y remédier. Si vous n\'acceptez pas la compensation de %reward% couronnes, alors nous en convoquerons un autre à votre place.%SPEECH_OFF% | Vous entrez dans une pièce pour trouver un certain nombre de vizirs enterrés sous les corps de filles esclaves. Il y a beaucoup de rires et de jeux charnel, mais surtout personne ne semble remarquer votre présence. À l\'exception d\'un homme âgé qui s\'approche en traînant les pieds et s\'incline.%SPEECH_ON%Mercenaire, le Vizir %employer% a convoqué un mercenaire pour la tâche de chasser les Ifrits.%SPEECH_OFF%Le vieil homme jette un coup d\'œil, puis se redresse. La prochaine fois qu\'il parle, il est dépourvu de toute absurdité.%SPEECH_ON%Ce sont de grands bâtards sablonneux, et ils déchirent la campagne. Je vous préviens qu\'ils ne sont pas à prendre à la légère, alors ne laissez pas tout ce spectacle  et l\'or vous tromper en vous attaquant à quelque chose que vous ne devriez pas. %reward% couronnes sont en jeu si vous acceptez.%SPEECH_OFF%Se redressant et se raclant la gorge, le vieil homme demande à voix haute.%SPEECH_ON%Acceptez-vous votre assignation ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Je suis intéressé, continuez. | Traquer un tel ennemi n\'est pas donné. | This is going to cost you. | Chasser un mirage dans le désert. Qu\'est-ce que l\'on ne pourrait pas aimer. | %companyname% peut aider, pour le bon prix.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne ressemble pas à notre type de travail. | Je ne veux pas mener mes hommes à la chasse aux chimères dans le désert. | Je ne pense pas. | Je dis non. Les hommes préfèrent les ennemis de chair et de sang.}",
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
			Text = "[img]gfx/ui/events/event_161.png[/img]{En traquant les mystérieux Ifrits, vous rencontrez une vieille femme qui a des pieds comme du cuir. Elle s\'incline à votre apparition.%SPEECH_ON%Ah, esclaves de l\'argent, ce sont les Ifrits que vous cherchez, non ? Bien sûr. Je peux le voir sur vos visages.%SPEECH_OFF%Elle fait une pause et indique les dunes vers lesquelles vous vous dirigez.%SPEECH_ON%Nous sommes de ces terres, vous comprenez ? Nous ne faisons qu\'un avec elles, et lorsque nous nous bannissons, nous nous faisons du mal et nous sommes cruels les uns envers les autres, les sables prennent le parti de ceux qui ont été lésés. Ne craignez pas le monstre, mais la raison pour laquelle il a été créé, car cette raison imprègne ces sables, et dans ce raisonnement, vous ne tuerez qu\'un seul monstre, mais ne détruirez pas les raisons qui le font renaître éternellement.%SPEECH_OFF% | Vous tombez sur un puits dans le désert. Un homme vous offre quelques seaux de rafraîchissement, en faisant remarquer que l\'eau en dessous est inépuisable. Avec pas une seule ferme en vue, vous avez des raisons de croire qu\'il y a assez d\'eau en dessous pour étancher votre soif pour toujours. L\'homme semble sentir que vous avez un autre but dans ces lieux.%SPEECH_ON%Je suppose que ce sont les Ifrits que vous cherchez, n\'est-ce pas ?%SPEECH_OFF%En hochant la tête, vous lui demandez comment il le savait. Il sourit.%SPEECH_ON%Parce que je les ai vus, et ce qu\'ils ont fait, et je pensais qu\'il ne faudrait pas longtemps avant qu\'une armée professionnelle ou un esclave de la couronne ne vienne régler leurs différends. L\'Ifrit est un monstre de vengeance, et il ne succombera qu\'à ce qui l\'a poussé hors de la terre : la cruauté.%SPEECH_OFF%En terminant votre boisson, vous remerciez l\'étranger pour ses paroles et continuez votre chemin. | Quelques cadavres dans les sables. Certains ont glissé à mi-chemin d\'une dune. Un autre repose à la base, un autre loin de la base. Apparemment jetés dans cette direction. Les corps découverts par les sables suggèrent une certaine récurrence dans les morts. Il semble que ce qui a attaqué les gens les a pulvérisés avec une force incroyable puis a passé un bref moment à mutiler ce qui restait, sablant la chair jusqu\'à l\'os par endroits. Les Ifrits doivent être proches...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Faites attention où vous mettez les pieds.",
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
			Text = "[img]gfx/ui/events/event_153.png[/img]{Au premier regard, il s\'agit d\'un mirage. Le désert se déplace et s\'estompe au loin, et pour les personnes inconscientes ou épuisées, ces vues se modifient et changent pour devenir ce que l\'on souhaite qu\'elles soient. C\'est lorsque l\'Ifrit se retourne, déchire un corps humain en deux et balance les morceaux à travers le sable que l\'on réalise que ce n\'est pas du tout une monstruosité imaginaire. C\'est une créature infernale, un nuage de sable qui tourne avec des pierres qui se déplacent pour lui donner la forme de ce que pourrait être un homme. Et lorsqu\'il se penche en avant, vous réalisez qu\'il partage la disposition d\'un homme envers les étrangers armés sur son territoire : la rage meurtrière. | Les dunes de sable devant vous glissent de haut en bas, les sables s\'enroulant vers vous comme un drap qu\'on tire d\'un lit. Mais une pierre apparaît, puis une autre et une autre, et quand la première pierre s\'élève, vous réalisez que c\'est un Ifrit. Un grognement se fait entendre, un mugissement profond qui crépite avec le fracas des vents de sable. L\'Ifrit prend la forme inclinée et disjointe d\'un homme, des pierres pour les os et du sable pour la chair, et il charge. | Vous trouvez l\'Ifrit tenant un bras distendu vers la terre. Le sable s\'échappe du bras et les grains pressent un corps mort dans le désert, la force arrachant les vêtements, puis poivrant la chair, puis le dépouillant entièrement jusqu\'à l\'os et quand l\'Ifrit a terminé, il se tourne vers vous et grogne férocement.}",
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
			ID = "Earthquake",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_160.png[/img]{Lorsque vous atteignez le sommet d\'une dune de sable, celle-ci s\'étend immédiatement loin de vos pieds. Vous vous sentez descendre et rouler avant que la terre ne vous avale entièrement. En dévalant la pente, vous constatez que les dunes adjacentes reculent également, et dans votre ventre, vous tremblez, non pas de peur, mais de la terre elle-même qui tremble violemment. Quand c\'est fini, vous vous relevez et stabilisez vos pieds. Les Ifrits viennent se placer au bord du cratère et vous regardent de haut. Ils vous crient dessus, leur férocité sifflante s\'entrechoquant avec le bruit du sable qui se cristallise. Vous êtes encerclés ! | Vous vous arrêtez et soupirez. Le désert semble s\'étendre à l\'infini, et au moment même où vous pensez cela, vous constatez que la vue se rétrécit. Il vous faut un moment pour réaliser que le sol tremble et que vous êtes aspiré vers le bas par le sable qui se déplace. Vous roulez pour échapper au danger et vous vous retrouvez à dévaler la pente de sable. En bas, vous sautez rapidement sur vos pieds et dégainez votre arme pour faire face à ce que vous savez déjà être là : les Ifrits. Ils se tiennent au bord des dunes, vous regardant fixement comme s\'ils avaient piégé un rat. Leurs corps sont des nuages de sable avec des pierres flottantes pour donner une sorte de forme statique de ce qui pourrait être un homme. Ils grognent et descendent vers vous !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_160.png[/img]{La bataille est terminée, mais les Ifrits ne partent pas complètement. Les sables qui ont fait que leurs corps bouillonnent, et les pierres qui ont structuré leurs corps se transforment et tremblent avec colère. Vous pouvez entendre le sifflement, non pas d\'une quelconque monstruosité, mais ce qui est clairement un son humain. Ils sifflent, le son arrive à vos oreilles. Vous vous retournez mais ne trouvez rien. Ils sifflent à nouveau derrière vous, et cette fois-ci, lorsque vous vous retournez, le bruit a disparu, le sable est immobile et les pierres sont en terre comme elles devraient l\'être. Les bêtes sont tuées, et peut-être ce qui les a habitées, aussi. Il est temps de retournez voir %employer%. | Les Ifrits sont tués, mais les corps semblent seulement servir de réceptacles pour quelque chose de bien plus sinistre. Vous apercevez des esprits s\'élevant vers l\'horizon, mais peut-être est-ce simplement le désert lui-même qui vous joue des tours. Il n\'y a rien à ajouter, sauf pour dire que la nature bestiale des Ifrits a été vaincue et %employer% doit vous payer pour cela seulement.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "C\'est fait.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{Vous essayez d\'entrer dans le bureau de %employer%, mais un garde vous en empêche. En haussant un peu les sourcils, vous dites à l\'homme que le Vizir vous attend. Le garde vous dévisage.%SPEECH_ON%Il vous attend, il ne souhaite pas vous voir. Ce sont deux choses différentes, Mercenaire. Les éclaireurs ont confirmé vos actions dans le désert. Voici votre paie, comme convenu. Maintenant, partez. J\'ai dit, partez !%SPEECH_OFF%Le garde tape du pied et tous les gardes postés dans le couloir tapent du pied et vous font face. Vous n\'êtes pas un génie, mais vous avez le sentiment qu\'il est probablement temps de partir. | L\'employeur vous regarde du haut d\'un trône fait d\'oreillers et de femmes. Des femmes esclaves, à en juger par leurs chaînes, mais c\'est peut-être leur truc. Les visages tristes disent le contraire. Le Vizir parle, mais c\'est presque comme si c\'était un spectacle pour tous ceux qui écoutent et que vous ne faisiez que jouer un rôle.%SPEECH_ON%Mercenaire, mes petits éperviers m\'ont parlé de vos exploits. Les Ifrits ont été mis au repos et leur sorcellerie ne sera plus une menace ! Tel est le pouvoir de mon or. C\'est une tâche sur laquelle nous nous sommes mis d\'accord, et pour cela, %reward% couronnes en récompense.%SPEECH_OFF%Alors qu\'un serviteur vous tend une bourse de pièces, le Vizir agite dédaigneusement ses doigts vers vous.%SPEECH_ON%Maintenant, foutez le camp d\'ici.%SPEECH_OFF% | Vous trouvez %employer% qui tourne un sablier dans un sens et dans l\'autre. Le sable esr séparé de part égale dans chaque partie du sablier. Tout le long du mur, des serviteurs ont la tête baissée. Sur le mur adjacent se trouve une rangée de coussins sur lesquels sont assis des femmes pimpantes  dont les cheveux sont entretenus par des femmes enchaînées. Le vizir fait tourner le sablier. Il s\'accroupit derrière lui, les yeux fixés de part et d\'autre du verre, les pupilles fixant l\'intérieur. Vous remarquez finalement que le sable à l\'intérieur ne bougent pas comme ils le devraient, mais qu\'il tourne rageusement.%SPEECH_ON%Les Ifrits ont été éliminés, mes faucons me l\'ont dit. Mercenaire, vous avez fait votre travail comme vous avez été appelé à le faire, et pour cela vous allez recevoir %reward% couronnes. J\'espère que votre temps dans les déserts vous a récompensé non seulement avec l\'expérience du combat et de la guerre, mais vous a aussi gratifié de la notion de contemplation.%SPEECH_OFF%Vous n\'êtes pas sûr de ce que cet homme veut dire. Il tire le sablier vers le haut et commence à l\'incliner de nouveau d\'un côté à l\'autre. Le sable s\'agite en rebondissant d\'un côté à l\'autre. Un serviteur vous tend une bourse de pièces et vous ne pourriez pas quitter la pièce plus vite. | Vous retournez voir %employer% pour trouver le Vizir tête baissé sur un canapé. Plusieurs vieillards lui font des massages dans le dos ou lui frottent les pieds. De l\'autre côté de la pièce, une femme s\'évente. Elle est entièrement nue et ses yeux ne quittent jamais ceux du Vizir, ni lui les siens. L\'homme parle presque comme si vous n\'étiez même pas dans la pièce.%SPEECH_ON%Serviteurs, remettez à ce mercenaire la bourse violette avec le fil noir. Mercenaire, vous vous êtes bien débrouillé avec les esprits des sables, ces soi-disant Ifrits. C\'est mon or qui vous a conduit dans ces déserts, et mon or qui vous a récompensé, alors faites savoir aux scribes que c\'est mon or qui a réglé cette affaire, et que l\'outil, ce mercenaire, a été payé équitablement.%SPEECH_OFF%Un serviteur vous enfonce un sac violet dans les bras. Le Vizir gémit quand un vieil homme lui plante un coude dans la raie des fesses.%SPEECH_ON%Dois-je vous dire de partir, Mercenaire ?%SPEECH_OFF% | Un vieil homme sans sourcils vous salue et vous arrête juste devant la porte de %employer%. Il vous pousse un sac dans les bras.%SPEECH_ON%Il y a %reward% couronnes là-dedans, comme le Vizir l\'a décidé.%SPEECH_OFF%L\'homme regarde autour de lui pour trouver des auditeurs et semble acquiescer lorsque vous voyez que vous êtes la seule personne à portée de voix.%SPEECH_ON%Les Ifrits ne sont pas seulement des démons, ce sont des esprits blessés, et vous les avez libérés. Mais ils reviendront probablement, parce que des hommes comme %employer% n\'ont rien à offrir à ce monde à part une cascade d\'or, et ils oublient que sous cette cascade beaucoup sont écrasés ou noyés.%SPEECH_OFF%Vous n\'êtes pas sûr de ce qu\'il veut dire, mais un garde s\'approche mettant fin à la conversation et le vieil homme vous gifle.%SPEECH_ON%Partez, Mercenaire ! Prenez votre paie et quittez ma vue !%SPEECH_OFF% | C\'est une troupe de chats qui vous accueille dans le bureau de %employer%. Vous apercevez à peine le Vizir de l\'autre côté d\'une grille avec une foule de spectateurs tout aussi amusés.\n\n Vous regardez en bas et voyez que les chats transportent un morceau de bois avec un sac dessus. Vous levez les yeux. Les silhouettes retiennent leur souffle. En soupirant, vous vous penchez et ramassez le sac. Un voyeur éclate et applaudit, mais il est accueilli par un silence sévère. Leur tâche terminée, les chats se laissent tomber et s\'étalent sur le carrelage, somnolant, se toilettant ou tripotant les ombres qui scintillent dans les rayons du soleil. Vous êtes presque sûr que %reward% couronnes sont dans le sac, mais ne voulant pas passer une seconde de plus dans la pièce, vous sortez pour compter.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Rid the city of Ifrits");
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
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/mirage_sightings_situation"));
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


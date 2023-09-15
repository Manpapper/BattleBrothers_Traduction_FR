this.barbarian_king_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Threat = null,
		LastHelpTime = 0.0,
		IsPlayerAttacking = false,
		IsEscortUpdated = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(90, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.barbarian_king";
		this.m.Name = "Le Roi Barbare";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 1700 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Chassez le Roi Barbare et ses généraux",
					"Il a été aperçu pour la dernière dans la région %region%, %direction% de vous"
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
				local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians);
				local nearest_base = f.getNearestSettlement(this.World.State.getPlayer().getTile());
				local party = f.spawnEntity(nearest_base.getTile(), "Barbarian King", false, this.Const.World.Spawn.Barbarians, 125 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Une puissante armée de tribus barbares, unies par un roi barbare autoproclamé.");
				party.getSprite("body").setBrush("figure_wildman_04");
				party.setVisibilityMult(2.0);
				this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.BarbarianKing, 100);
				this.Contract.m.Destination = this.WeakTableRef(party);
				party.getLoot().Money = this.Math.rand(150, 250);
				party.getLoot().ArmorParts = this.Math.rand(10, 30);
				party.getLoot().Medicine = this.Math.rand(3, 6);
				party.getLoot().Ammo = this.Math.rand(10, 30);
				party.addToInventory("supplies/roots_and_berries_item");
				party.addToInventory("supplies/dried_fruits_item");
				party.addToInventory("supplies/pickled_mushrooms_item");
				party.getSprite("banner").setBrush(nearest_base.getBanner());
				party.setAttackableByAI(false);
				local c = party.getController();
				local patrol = this.new("scripts/ai/world/orders/patrol_order");
				patrol.setWaitTime(20.0);
				c.addOrder(patrol);
				this.Contract.m.UnitsSpawned.push(party.getID());
				this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(10, 40);
				this.Flags.set("HelpReceived", 0);
				local r = this.Math.rand(1, 100);

				if (r <= 15)
				{
					this.Flags.set("IsAGreaterThreat", true);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives.clear();
				this.Contract.m.BulletpointsObjectives = [
					"Chassez le Roi Barbare et ses généraux",
					"Ses généraux ont été aperçu pour la dernière fois aux alentours de %region%, %terrain% direction %direction% de vous, à proximité %nearest_town%"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithKing.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setState("Return");
				}
				else if (!this.Contract.isPlayerNear(this.Contract.m.Destination, 600) && this.Flags.get("HelpReceived") < 4 && this.Time.getVirtualTimeF() >= this.Contract.m.LastHelpTime + 70.0)
				{
					this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(0, 30);
					this.Contract.setScreen("Directions");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Contract.isPlayerNear(this.Contract.m.Destination, 600) && this.Flags.get("HelpReceived") == 4)
				{
					this.Contract.setScreen("GiveUp");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithKing( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!_dest.isInCombat() && !this.Flags.get("IsKingEncountered"))
				{
					this.Flags.set("IsKingEncountered", true);

					if (this.Flags.get("IsAGreaterThreat"))
					{
						this.Contract.setScreen("AGreaterThreat1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Approach");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					this.Flags.set("IsAGreaterThreat", false);
					_dest.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.Music = this.Const.Music.BarbarianTracks;
					this.World.Contracts.startScriptedCombat(properties, this.Contract.m.IsPlayerAttacking, true, true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_GreaterThreat",
			function start()
			{
				this.Contract.m.BulletpointsObjectives.clear();
				this.Contract.m.BulletpointsObjectives = [
					"Voyager avec le Roi Barbare pour faire fasse aux menaces ensemble"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.setFaction(2);
					this.World.State.setEscortedEntity(this.Contract.m.Destination);
				}
			}

			function update()
			{
				if (this.Flags.get("IsContractFailed"))
				{
					if (this.Contract.m.Threat != null && !this.Contract.m.Threat.isNull())
					{
						this.Contract.m.Threat.getController().clearOrders();
					}

					if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
					{
						this.Contract.m.Destination.getController().clearOrders();
						this.Contract.m.Destination.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getID());
					}

					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Company broke a contract");
					this.World.Contracts.finishActiveContract(true);
					return;
				}

				if (this.Contract.m.Threat == null || this.Contract.m.Threat.isNull() || !this.Contract.m.Threat.isAlive())
				{
					this.Contract.setScreen("AGreaterThreat5");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					if (!this.Contract.m.IsEscortUpdated)
					{
						this.World.State.setEscortedEntity(this.Contract.m.Destination);
						this.Contract.m.IsEscortUpdated = true;
					}

					this.World.State.setCampingAllowed(false);
					this.World.State.getPlayer().setPos(this.Contract.m.Destination.getPos());
					this.World.State.getPlayer().setVisible(false);
					this.World.Assets.setUseProvisions(false);
					this.World.getCamera().moveTo(this.World.State.getPlayer());

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(this.Const.World.SpeedSettings.FastMult);
					}

					this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.FastMult;
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Threat))
				{
					this.Contract.setScreen("AGreaterThreat4");
					this.World.Contracts.showActiveContract();
				}
			}

			function end()
			{
				this.World.State.setCampingAllowed(true);
				this.World.State.setEscortedEntity(null);
				this.World.State.getPlayer().setVisible(true);
				this.World.Assets.setUseProvisions(true);

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(1.0);
				}

				this.World.State.m.LastWorldSpeedMult = 1.0;
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsContractFailed", true);
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
					if (this.Flags.get("IsAGreaterThreat"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% fait tourner une fine couronne autour de son doigt. C\'est un morceau de métal bon marché, mais c\'est sans doute une couronne qui vient de quelque part. Il vous regarde de haut en bas, tandis que l\'étain passe et repasse sur ses doigt.%SPEECH_ON% Je crois que j\'aurais dû le voir venir. Les hommes cherchent le pouvoir, et ceux qui sont taillés dans le bois barbare ne sont pas différents.%SPEECH_OFF%Il laisse la couronne glisser jusqu\'à ses jointures où elle pend mollement.%SPEECH_ON%Les barbares direction %direction% dans la région de %region% s\'unissent sous un soi-disant roi. Un sauvage si fort et si méchant qu\'il menace de constituer une horde et après ça, eh bien, je pense qu\'il voudra étendre son royaume au sud. J\'ai besoin que vous alliez dans cette région, que vous trouviez cet homme et que vous l\'abattiez.%SPEECH_OFF% | L\'un des serviteurs de %employer% vous amène dans un jardin où vous trouvez l\'homme s\'occupant d\'un plant de tomates. Il le taille à l\'aide d\'une cisailles et salue de la tête son propre travail. Il parle à bâtons rompus.%SPEECH_ON% Mes éclaireurs me disent qu\'un sauvage du nord dans la %region% est en train de rassembler une armée. Un rassemblement de débiles ne sort pas trop de l\'ordinaire pour ces primitifs, mais je crois que l\'un d\'eux s\'est proclamé roi. Et les rois, eh bien, ils veulent être suzerains de toujours plus de terres. Ils veulent ce que tout les autres ont. Ce que j\'ai...%SPEECH_OFF% L\'homme fait une pause et vous fait un signe de tête.%SPEECH_ON% J\'ai besoin que vous alliez dans la région de %region%, que vous trouviez ce soi-disant roi sauvage, et que vous le supprimiez. Ce ne sera pas facile, mais vous serez très bien payé.%SPEECH_OFF%.| %employer% est entouré de ses lieutenants. Ils vous regardent en ricanant, mais %employer% ignore leurs jugements et fait le sien. %SPEECH_ON%Ah, mercenaire, je crois qu\'un homme de votre trempe est exactement ce dont j\'ai besoin. Un barbare dans la %region% s\'est autoproclamé roi. Il porte même une sorte de couronne, probablement en os et en bois, mais c\'est la forme et le but qui comptent. Pas seulement pour lui, mais pour nous. Nous ne pouvons pas le laisser vivre. J\'ai besoin que vous trouviez ce primitif et que vous l\'éliminiez avant qu\'il ne rassemble une armée trop importante et que mes lieutenants ne puissent s\'en occuper. %SPEECH_OFF% | %employer% vous accueille avec une chope de bière. Lui-même déguste un gobelet de vin.%SPEECH_ON%IJe vous ai fait venir car il y a un certain primitif dans la région de %region% qu\'il faut tuer. Il se dit roi, suzerain des sauvages. Bien que je ne respecte pas du tout son autorité royale, je sais reconnaître une menace naissante quand j\'en vois une. Je ne peux pas attendre que ce barbare réunisse les hordes de villageois et rassemble une armée. J\'ai besoin de vous pour le trouver et le tuer. Ce ne sera pas facile, mais tu seras bien payé.%SPEECH_OFF%Vous vous demandez maintenant s\'il ne vous glisse pas de la bière pour vous amadouer et vous faire accepter cette tâche insensée. | %employer% tient une paire de bois de cerf dont la couronne est toujours à la base. Lorsqu\'il la pose sur son bureau, elle se tient debout, comme si elle était toujours attachée à son propriétaire.%SPEECH_ON%Le bruit court qu\'un sauvage de la %region% rassemble une armée. Il se proclame roi et s\'il peut rallier ces sauvages à sa bannière, cela fera sans doute de lui un puissant fils de pute. Ca veut aussi dire qu\'on risque de se retrouver dans la merde très bientôt si on ne s\'occupe pas de lui.%SPEECH_OFF% L\'homme renverse les bois et ils tombent sur leurs pointes avec des craquements secs.%SPEECH_ON% Alors c\'est pour ça que tu es là mercenaire. J\'ai besoin que tu trouves ce barbare et que tu en finisses avec lui avant qu\'il ne se fasse des idées sur ce qu\'est ou n\'est pas être suzerain. .%SPEECH_OFF% | %employer% est assis sur sa chaise, les lèvres pincées. Il manipule une dague, dont la pointe creuse une entaille dans son bureau. %SPEECH_ON% Mes éclaireurs direction %direction% ont commencé à disparaître il y a quelques temps. Et puis les survivants ont afflué et avec eux des histoires d\'un barbare qui s\'est proclamé roi de la %region%. Dois-je vous expliquer quel est le problème d\'un sauvage qui se proclame chef d\'une horde de primitifs ? %SPEECH_OFF%  Vous lui dites que vous imaginez que cela l\'empêche de dormir la nuit. %employer% sourit. %SPEECH_ON% Oui, c\'est vrai. Donc j\'ai besoin de quelqu\'un comme toi, un honnête soldat, charmant et civilisé. J\'ai besoin que tu ailles trouver ce soi-disant roi et que tu le tues avant qu\'il n\'ait fait se rallier tous ces abrutis à sa bannière..%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{De combien de Couronnes parlent-on ici? | Ce n\'est pas une tâche facile que vous demander. | Je pourrais être persuadé pour un bon prix. | Pour une tâche pareil la paie à intérêt à être en conséquence.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nous ne nous engageons pas dans une guerre. | Ce n\'est pas le genre de travail que nous recherchons. | Je ne veux pas risquer la compagnie contre un ennemi tel que celui-ci.}",
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
			ID = "Directions",
			Title = "Sur la route...",
			Text = "{[img]gfx/ui/events/event_59.png[/img]Une foule de réfugiés passe devant la compagnie. Les rumeurs courent que le roi barbare est à %distance% direction %direction%. Beaucoup de gens sur la route viennent de %nearest_town% et ne semblent pas avoir envie d\'attendre qu\'une marée de sauvages s\'abatte sur eux. | [img]gfx/ui/events/event_41.png[/img]Un commerçant avec une charrette vide croise la route de la compagnie. Bien qu\'il n\'ait rien à colporter, il déclare que les routes sont agitées par les rumeurs d\'un sauvage qui se fait appeler roi. Il affirme que le barbare se trouve quelque part dans la direction %direction% d\'où vous vous trouvez, autour de la %region%. Il regarde le trajet de votre périple avec un hochement de tête. %SPEECH_ON%Si vous tenez à aller par là, eh bien, donnez à ces bâtards primitifs toute la douleur qu\'ils méritent. %SPEECH_OFF%. | [img]gfx/ui/events/event_94.png[/img]Un homme à moitié nu est trouvé assis en tailleur sur le bord de la route. Il déclare qu\'un primitif et son armée ont brûlé sa ferme, maltraité les femmes et tué tous ses gars.%SPEECH_ON% J\'ai survécu en me cachant dans un tas de broussailles avec mes mains sur la bouche.%SPEECH_OFF% L\'homme s\'essuie le nez.%SPEECH_ON% Je vous ai vu avec vos armes. Si vous cherchez ce barbare, je peux vous dire qu\'il semblait se diriger en direction %direction% d\'ici, en bas %terrain% %distance% vers %region%. %SPEECH_OFF% | [img]gfx/ui/events/event_94.png[/img]Vous trouvez les restes brûlés d\'un petit hameau. Quelques survivants s\'y attardent, leurs silhouettes se mêlent à la fumée qui s\'échappe de leurs maisons en ruines. L\'un d\'entre eux déclare qu\'un homme se targuant d\'être un roi est venu et a tué tout le monde avant de prendre la direction %direction%. | [img]gfx/ui/events/event_60.png[/img]Vous avez croisé un certain nombre de charrettes retournées ou de chariots en feu. Toutes sont vides, et leurs marchandises ont disparu, il ne reste que les cadavres de leurs propriétaires. Quelques enfants sont en train de fouiller dans les décombres d\'une de ces charrettes. Quand vous leur demandez qui a fait ça, un garçon effronté prend la parole.%SPEECH_ON% Des sauvages du nord, mais ils vont dans la %direction% maintenant. Je les ai vus. Ils sont %terrain%, %distance% je parie.%SPEECH_OFF% Il se cure le nez.%SPEECH_ON%  C\'est des tueurs, au fait. Ils ressemblent un peu à votre genre, mais en plus grand. Probablement plus forts.%SPEECH_OFF%. | [img]gfx/ui/events/event_76.png[/img]Un éclaireur de %employer% vous rencontre sur la route. Il rapporte que le roi barbare a été aperçu aux alentours de %region% à la direction %direction% %terrain%. Il est à %distance%. Vous demandez à l\'éclaireur s\'il se joindra à vous pour le combat ce qui fit rire l\'homme.%SPEECH_ON%Non monsieur, je vais très bien. Je cours partout, je vois des choses et je les rapporte. Entre temps, je baise une ou deux putes. C\'est une bonne vie et je n\'ai pas envie de périr comme un mercenaire!%SPEECH_OFF% C\'est entendu. | [img]gfx/ui/events/event_132.png[/img]%randombrother% les repère en premier. Les signes d\'une escarmouche, des cadavres calcinés, des empreintes de pas effacées et des traces de chariots, si nombreuses qu\'il est clair qu\'une armée est passée par ici.%SPEECH_ON%On dirait qu\'ils se dirigé vers la direction %direction% après la bataille, capitaine.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous sommes sur sa piste.",
					function getResult()
					{
						this.Flags.increment("HelpReceived", 1);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "GiveUp",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Il n\'y a plus de doute maintenant. Avec tous les signes que vous avez rencontrés, et tous les rapports que les gens vous ont donnés, vous savez enfin exactement où le Roi barbare et son armée se dirigent. La seule chose qui reste à faire est de l\'affronter.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous devrions nous hâter.",
					function getResult()
					{
						this.Flags.increment("HelpReceived", 1);
						this.Contract.m.Destination.setVisibleInFogOfWar(true);
						this.World.getCamera().moveTo(this.Contract.m.Destination);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Approach",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_135.png[/img]{Le roi barbare arrive sur le terrain avec son armée de combattants, un groupe de scélérats démesurés, de guerriers bruyants, d\'esclaves craintifs et de femmes criardes. C\'est l\'armée d\'un homme qui a exploité la terre jusqu\'à la moindre ressource, jusqu\'au moindre petit bénéfice, et qui exploitera la civilisation de la même façon aussi sûrement qu\'une simple boule de neige peut devenir une avalanche. Vous préparez les hommes pour la bataille. |La troupe du Roi Barbare traverse le pays sans aucun entraînement ni même un semblant de structure. Mais vous savez qu\'avec un simple geste de sa main de sauvage, il peut envoyer sur ses ennemis une horde de tueurs qui ont commis suffisamment de carnages pour surmonter tout manque de cohésion. Vous préparez les hommes pour la bataille. | La bande de sauvages est comme un cauchemar, elle se dessine à l\'horizon comme des migrants venus de tous les coins de la terre, vêtus non pas d\'un uniforme ou d\'une armure, mais de la parodie des tenues de ceux qu\'ils ont conquis. Des guerriers aux robes de mariée enroulées autour de leurs bras, de longs manteaux de couleur royale ornant des hommes sans statut, certains portant des côtes d\'os s\'entrechoquant comme s\'ils avaient eu les dernières part du pillage. Ils n\'étaient que des fermiers de l\'horreur, les villageois leur récolte, et la guerre une moisson pour toutes les saisons. \n\nVous secouez la tête à cette vue et préparez les hommes au combat. }",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithKing(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Victoire",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{Le roi barbare est mort. Bien qu\'il se soit affublé d\'un titre royal, il repose parmi les morts comme n\'importe quel autre membre de son peuple. Ce n\'est qu\'un sauvage. Un primitif. Avec un corps un peu plus robuste et quelques accoutrements issus de ses guerres, pillages et ravages. Peu d\'autres choses le distinguent. Vous maintenez sa tête contre le sol avec votre botte, puis vous lui entaillez le cou avec votre épée, la tête se détache de ses épaules. %randombrother% prend la lourde tête et la jette dans un sac. Vous ordonnez aux hommes de récupérer ce qu\'ils peuvent avant de vous préparer a retourner voir  %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Les %companyname% l\'a emporté! | Victoire!}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_136.png[/img]{Vous trouvez le roi barbare, mais un pourparler est organisé. Le roi barbare et un ancien traversent le champ pour vous rencontrer personnellement. En dépit de votre bon sens, vous allez les voir. Le roi barbare parle et l\'aîné traduit.%SPEECH_ON% Nous ne sommes pas ici pour conquérir, mais pour vaincre le Grand Malin.%SPEECH_OFF%Suspectant une erreur de traduction, vous leur demandez d\'expliquer. Le Roi et l\'aîné continuent.%SPEECH_ON%La mort a quitté cette terre, et en son absence un homme tué se perd entre les mondes et ressuscite. Une horde d\'indésirables, les morts-vivants, est en marche. Nous ne sommes pas ici pour vous ou vos seigneurs. Si vous nous aidez à les détruire, nous quitterons le pays et ne troublerons plus votre peuple. Seulement les Morts-Vivants.%SPEECH_OFF%%randombrother% se penche et murmure.%SPEECH_ON% On pourrait les rejoindre, bien sûr, mais on pourrait aussi les attaquer maintenant. Ils ne sont clairement pas au complet et quoi qu\'ils disent ici, le fait est qu\'ils ont ravagé les terres de toute façon, parce que ce sont des sauvageons primitifs, monsieur, et le viol et le pillage sont tout ce qu\'ils ont dans le sang.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous allons les attaquer et débarrasser le nord de ce soi-disant roi.",
					function getResult()
					{
						return "AGreaterThreat2";
					}

				},
				{
					Text = "Nous nous joindrons à eux pour marcher contre le Malin.",
					function getResult()
					{
						return "AGreaterThreat3";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_136.png[/img]{Vous crachez et pointez du doigt l\'aîné.%SPEECH_ON% Nous sommes passés devant des maisons brûlées, des femmes violées et des hommes massacrés pour vous retrouver dans votre triste sort, et maintenant vous voulez vous allier ? Nous ne sommes pas des alliés. Nous ne sommes pas des amis. Dites à votre soi-disant Roi de prier n\'importe quel dieu de merde que vous... %SPEECH_OFF%L\'ancien lève la main et parle avec le roi dans leur langue maternelle. Les deux hommes acquiescent, se tournent et partent. Vous dites à votre homme de retourner à la ligne de bataille et de se préparer pour le combat à venir.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous au combat.",
					function getResult()
					{
						this.Flags.set("IsAGreaterThreat", false);
						this.Contract.getActiveState().onCombatWithKing(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat3",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_136.png[/img]{Vous faites un signe de tête vers l\'ancien.%SPEECH_ON%D\'accord, nous allons coopérer avec vous pour faire face à cette plus grande menace.%SPEECH_OFF%L\'ancien sourit, se frotte les pouces et dit quelques phrases dans sa langue maternelle. Le roi barbare se frappe la poitrine avec son poing, puis vous frappe l\'épaule avec celui-ci, avant de lever la main vers le ciel. En riant, l\'ancien explique : %SPEECH_ON% Nous combattons donc ensemble, mais si nous tombons, nous ne nous battrons pas à vos côtés en tant que mort-vivant. Si nous sommes tués, le Roi trouvera la la faucheuse lui même et lui offrira sa tête.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous à marcher.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.World.State.getPlayer().getTile();
				local nearest_undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(playerTile);
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_undead.getFaction()).spawnEntity(tile, "The Untoward", false, this.Const.World.Spawn.UndeadArmy, 260 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush(nearest_undead.getBanner());
				party.setDescription("Une légion de morts-vivants, revenus réclamer aux vivants ce qui autrefois leur appartenait.");
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Threat = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(99999);
				c.addOrder(wait);
				this.Contract.m.Destination.setFaction(2);
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				c = this.Contract.m.Destination.getController();
				c.clearOrders();
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(party.getTile());
				c.addOrder(move);
				this.Contract.setState("Running_GreaterThreat");
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat4",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Les sauvages ne mentaient pas : les anciens ont mis sur pied une armée. C\'est une armée de gueules décomposées et d\'armures rouillées, une foule de créatures gémissantes sur lesquelles la lumière tombe et s\'évanouit instantanément. C\'est assurément une armée des ténèbres. Si vous ou les barbares la combattez seuls, vous perdrez à coup sûr, mais ensemble, vous avez peut-être une chance...!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous au combat.",
					function getResult()
					{
						this.World.Contracts.showCombatDialog(false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat5",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_136.png[/img]{Les morts anciens ont été tués jusqu\'au dernier. Alors que vos hommes et les primitifs récupèrent sur le champs de bataille, le roi barbare et l\'ancien viennent vous voir. Le grand guerrier hoche la tête et grogne, et l\'ancien traduit. %SPEECH_ON% Il dit que vous avez fait du bon, très bon travail, et qu\'il aimerait que des hommes comme vous et votre compagnie se battent à ses côtés, mais il comprend que cela ne puisse pas arriver. Nous sommes dans un labyrinthe de plusieurs mondes et dans ce labyrinthe nous demeurerons tous, perdus, entendant parfois les hurlements des uns et des autres, sans jamais avoir assez de temps pour nous connaître. Il vous remercie. Et il vous souhaite bonne chance.%SPEECH_OFF%Vous vous tournez vers l\'aîné et lui demandez s\'il a compris tout cela à partir d\'un simple grognement. L\'ancien sourit. %SPEECH_ON% Un grognement, oui, et une amitié de toute une vie. Bon voyage mercenaire.%SPEECH_OFF%L\'ancien te tend un casque à cornes, celui-là même que le Roi Barbare portait parfois. Il ne dit rien, il se frappe la poitrine et montre le ciel, comme s\'il n\'y avait que ça..}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Adieu, roi.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.Contract.m.Destination.isAlive())
				{
					this.Contract.m.Destination.die();
					this.Contract.m.Destination = null;
				}

				local item = this.new("scripts/items/helmets/barbarians/heavy_horned_plate_helmet");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%employer% prend la tête du Roi barbare et la fait rouler hors du sac. Elle tombe librement, renversant un plateau de gobelets qui s\'éparpillent et s\'entrechoquent. Même dans la mort, le sauvage est un pourvoyeur de chaos.%SPEECH_ON% Merci, mercenaire. %SPEECH_OFF% Votre employeur dit, en acquiesçant pour lui-même, alors qu\'il redresse la tête et l\'incline sur son cou.%SPEECH_ON% C\'est un affreux bâtard, n\'est-ce pas ? Regardez ces dents. Regardez les ! Il y a des trous dans ces dents. Absolument dégoûtant.%SPEECH_OFF% Vous dites à l\'homme de vous payer et il le fait comme convenu. Mais il continue à secouer la tête et il montre ses propres dents et imite le fait de les curer.%SPEECH_ON% Comment on nettoie des dents comme ça ? Avec une corde?%SPEECH_OFF% En haussant les épaules, vous partez, sans prendre la peine de dire à %employer% que la première chose que vos hommes ont fait de cette tête perdue est de lui arracher son or avec un couteau.|Vous jetez la tête du Roi Barbare sur la table de l\'employeur. Il la regarde, puis vous regarde.%SPEECH_ON%C\'est la plus grosse tête que j\'ai jamais vue.%SPEECH_OFF%En acquiesçant, vous demandez votre salaire et on vous le remet en bonne et due forme. Votre employeur commence à repousser le visage du sauvage, comme s\'il s\'agissait d\'un sorcier cherchant à voler ses secrets.%SPEECH_ON%Je parie que c\'est de là que viennent les contes d\'ogres, hein ? un enfant voit cette chose hideuse et voilà, son imagination s\'enflamme, et ainsi nait un véritable monstre.%SPEECH_OFF%Si seulement les choses étaient aussi simples.| Même sans son corps massif, la tête du roi barbare fait sensation lorsqu\'on la montre à %employer%. Une foule de nobles et de serviteurs s\'extasient devant sa taille. Un homme en robe noire s\'empresse de vous payer ce qui vous est dû. Le %employer% lui-même ramasse la tête et la balance dans les airs pour la soupeser.%SPEECH_ON%Par les vieux dieux, elle est vraiment lourde ! Oy %randomname%.%SPEECH_OFF%Un serviteur s\'avance. Votre employeur sourit.%SPEECH_ON%Allez me chercher une pique. Nous allons hisser cette épouvante tête haute dans les cieux. %SPEECH_OFF Un passage approprié pour un sauvage.| Quelques instants à peine après avoir donné à %employer% la tête du roi barbare, elle est utilisée comme un jouet. Des enfants de nobles la font rouler sur le sol de pierre, la tête du sauvage renversant des murs de gobelets et des forteresses de plateaux de repas. Un chien aboie en suivant la tête dans tous les sens. L\'employeur vous tape sur l\'épaule. %SPEECH_ON% Travail remarquable, mercenaire. C\'est vrai. Mes éclaireurs m\'ont dit que c\'était un sacré combat, que vous étiez presque un sauvage vous-même. Mais je suppose que c\'est ce qu\'il fallait faire, non ? Un sauvage pour combattre un sauvage ? Un esprit d\'une telle puissance ne peut être contenu par nos manières civilisées!%SPEECH_OFF%Un des enfants donne un coup de pied au visage du Roi, lui cassant la mâchoire et celle-ci lui entaillant le pied avec ses dents. Le gamin crie à l\'aide et, peut-être pour défendre son maître, le chien se pose sur la tête et commence à la traîner par le lambeau du cou. L\'employeur sourit à nouveau.%SPEECH_ON%Votre paie vous attend dehors. Elle est complète, comme promis.%SPEECH_OFF%. | Un homme en armure de chevalier vous arrache la tête du roi barbare. Vous tirez immédiatement votre épée, mais %employer% intervient pour mettre fin à tout début de violence.%SPEECH_ON%Oy, mercenaire, tout va bien. Ton salaire, comme promis.%SPEECH_OFF%L\'homme te tend une sacoche de couronnes, mais derrière lui vous voyez que la tête est confiée à un homme en cape noire. Vous acquiescez et demandez ce qu\'ils ont l\'intention d\'en faire. Employeur% sourit. %SPEECH_ON%Franchement, des bières m\'attendent, mercenaire, et j\'ai bien soif. %SPEECH_OFF%L\'homme passe rapidement devant vous. Vous ne voyez pas de bière ou de boisson, il se contente de suivre l\'homme au manteau. | %employer% fixe la tête du Roi Barbare comme un chat fixerait méchamment tout ce qui n\'est pas lui même. %SPEECH_ON%Intéressant. Je pense que je vais la faire empailler et la mettre sur ma cheminée. %SPEECH_OFF%Parlant un peu à tort et à travers, vous rappelez à votre employeur que c\'est la tête d\'un homme à laquelle il fait référence. %employer% hausse les épaules.%SPEECH_ON%Et alors ? C\'est une monstruosité. Il ne peut y avoir de coexistence entre le civilisé et le sauvage. Et en m\'en occupant correctement, je vais rappeler cette réalité. Et vous, qu\'allez-vous faire ? Me conseiller à nouveau ? %SPEECH_OFF% En serrant les lèvres, vous demandez votre salaire. L\'homme montre le coin. %SPEECH_ON% Dans la sacoche, là. Tu as bien travaillé mercenaire, mais ne me parle plus jamais de cette façon. Bonne journée. %SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Bien mérité.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Killed a self-proclaimed barbarian king");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%employer% vous accueille à contrecœur. Vous savez que j\'ai des éclaireurs et des espions partout, n\'est-ce pas ? En levant vos mains vides, vous lui dites que vous n\'aviez pas l\'intention de mentir. Le \"roi barbare\" ne dérangera plus ces terres. Votre employeur tapote ses index l\'un contre l\'autre plusieurs fois puis hoche la tête. %SPEECH_ON%Votre honnêteté est rafraîchissante, bien que je doive avouer qu\'il est assez malheureux que cet homme et sa bande vivent encore. Cela dit, tous les rapports suggèrent qu\'ils s\'en vont, donc je suppose que votre travail est accompli malgré tout, grosse tête de païen ou pas. Votre salaire, comme convenu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Bien mérité.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Resolved the threat of a self-proclaimed barbarian king");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && this.m.Destination.isAlive())
		{
			local distance = this.World.State.getPlayer().getTile().getDistanceTo(this.m.Destination.getTile());
			distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
			local region = this.World.State.getRegion(this.m.Destination.getTile().Region);
			local settlements = this.World.EntityManager.getSettlements();
			local nearest;
			local nearest_dist = 9999;

			foreach( s in settlements )
			{
				local d = s.getTile().getDistanceTo(this.m.Destination.getTile());

				if (d < nearest_dist)
				{
					nearest = s;
					nearest_dist = d;
				}
			}

			_vars.push([
				"region",
				region.Name
			]);
			_vars.push([
				"nearest_town",
				nearest.getName()
			]);
			_vars.push([
				"distance",
				distance
			]);
			_vars.push([
				"direction",
				this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
			_vars.push([
				"terrain",
				this.Const.Strings.Terrain[this.m.Destination.getTile().Type]
			]);
		}
		else
		{
			local nearest_base = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(this.World.State.getPlayer().getTile());
			local region = this.World.State.getRegion(nearest_base.getTile().Region);
			_vars.push([
				"region",
				region.Name
			]);
			_vars.push([
				"nearest_town",
				""
			]);
			_vars.push([
				"distance",
				""
			]);
			_vars.push([
				"direction",
				this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(region.Center)]
			]);
			_vars.push([
				"terrain",
				this.Const.Strings.Terrain[region.Type]
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.State.setCampingAllowed(true);
			this.World.State.setEscortedEntity(null);
			this.World.State.getPlayer().setVisible(true);
			this.World.Assets.setUseProvisions(true);

			if (!this.World.State.isPaused())
			{
				this.World.setSpeedMult(1.0);
			}

			this.World.State.m.LastWorldSpeedMult = 1.0;
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onIsTileUsed( _tile )
	{
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

		if (this.m.Threat != null && !this.m.Threat.isNull())
		{
			_out.writeU32(this.m.Threat.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local obj = _in.readU32();

		if (obj != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(obj));
		}

		obj = _in.readU32();

		if (obj != 0)
		{
			this.m.Threat = this.WeakTableRef(this.World.getEntityByID(obj));
		}

		this.contract.onDeserialize(_in);
	}

});


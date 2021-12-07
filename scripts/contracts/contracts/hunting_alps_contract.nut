this.hunting_alps_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		SpawnAtTime = 0.0,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_alps";
		this.m.Name = "Mettre fin aux Cauchemars";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
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

		local names = [
			"alps",
			"voleurs de rêves",
			"vouleurs d\'âmes",
			"traqueurs de la nuit",
			"nachtmars",
			"aufhockers",
			"terreurs nocturnes",
			"rampants nocturnes"
		];
		this.m.Flags.set("enemyName", names[this.Math.rand(0, names.len() - 1)]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Finissez en avec les cauchemards hantant " + this.Contract.m.Home.getName() + " la nuit"
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

				if (r <= 25)
				{
					this.Flags.set("IsGoodNightsSleep", true);
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
			}

			function update()
			{
				if (this.World.getTime().IsDaytime)
				{
					this.Contract.m.SpawnAtTime = 0.0;
				}
				else if (this.Contract.m.SpawnAtTime == 0.0 && !this.World.getTime().IsDaytime)
				{
					this.Contract.m.SpawnAtTime = this.Time.getVirtualTimeF() + this.Math.rand(8, 18);
				}

				if (this.Flags.get("IsVictory"))
				{
					this.Contract.setScreen("Victory");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (this.Contract.m.Target == null && !this.World.getTime().IsDaytime && this.Contract.isPlayerNear(this.Contract.m.Home, 600) && this.Contract.m.SpawnAtTime > 0.0 && this.Time.getVirtualTimeF() >= this.Contract.m.SpawnAtTime)
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsBanterShown") && this.World.getTime().IsDaytime && (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || this.Contract.m.Target.isHiddenToPlayer()) && this.Contract.isPlayerNear(this.Contract.m.Home, 600) && this.Time.getVirtualTimeF() - this.Flags.get("StartTime") >= 6.0 && this.Math.rand(1, 1000) <= 5)
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Alps")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Alps")
				{
					this.Contract.m.SpawnAtTime = -1.0;
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Vous trouver %employer% avec un oreiller à la main. Un homme à ses côtés est en train de toucher l\'oreiller avant de les porter à son nez. Il le renifle trois fois, puis secoue la tête avant de juger bon de le renifler à nouveau quand même. %employer% vous fait signe d\'entrer.%SPEECH_ON%Un paysan des environs rapporte qu\'un esprit étrange envahit son sommeil. Il a offert ses parures nocturnes comme preuve, mais nous ne savons pas quoi en faire.%SPEECH_OFF%Vous regardez l\'homme étrange qui est de nouveau plongé le nez dans les draps. Vous levez un sourcil et déclarez que vous pouvez enquêter sur cette affaire. %employer% acquiesce.%SPEECH_ON%C\'est précisément pourquoi je suis content que vous soyez là. Je veux que vous restiez dans le coin une nuit ou deux pour voir si quelque chose d\'effrayant sort la nuit. Je suis sûr que ce n\'est rien, mais je vous paierai quoi qu\'il arrive. Qu\'en dites-vous, cela vous intéresse-t-il ?%SPEECH_OFF%L\'homme étrange s\'agrippe presque à l\'oreiller et prend des respirations profondes comme s\'il s\'étouffait. Il demande s\'il peut garder l\'oreiller. | %employer% vous amène à son bureau où se trouvent des dessins éparpillés.%SPEECH_ON%Je ne distribue pas souvent mes papiers et mes stylos aux gens du coin, mais une poignée de familles ont demandé à ce qu\'ils dessinent ce qu\'ils avaient vu.%SPEECH_OFF%Vous jetez un coup d\'œil. Chaque page est différente, la plupart consistant en des figures de bâton dans des arrangements plutôt chaotiques. L\'un des dessins les plus artistiques représente une bête étrange, accroupie sur une personne et serrant sa tête comme si elle voulait la voler. L\'homme continue.%SPEECH_ON%Ça ressemble à des cauchemars ordinaires pour moi, mais j\'ai enquêté sur les maisons concernés et chaque famille avait l\'air très perturbée, comme si quelque chose se glissait dans leur sommeil. Je voudrais que vous restiez dans le coin, mercenaire, et que vous voyiez ce qui se passe. C\'est probablement juste des voyous, mais ça vaut le coup de jeter un oeil. Êtes-vous intéressé ?%SPEECH_OFF% | Vous trouvez %employer% en train d\'écouter un paysan raconter une histoire, mais en vous voyant, l\'homme suggère au paysan de vous la raconter à sa place. Il explique que lui et de nombreuses autres familles ont fait des rêves horribles ces derniers temps. Non seulement cela, mais des animaux domestiques ont disparu et certains enfants ont rapporté avoir été emmenés et avoir dû rentrer chez eux à pied en pleine nuit. %employer% acquiesce.%SPEECH_ON%Toute la ville est sur les dents à ce sujet, mercenaire. J\'ai entendu des histoires sur des %enemy%, des créatures macabres qui se régalent des rêves d\'autrui, mais je suis sûr que c\'est juste des enfants qui ne font rien de bon. Quoi qu\'il en soit, une enveloppe a été collectée et je suis prêt à la distribuer pour une protection plus appropriée. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% est assis à son bureau. Il soupire lourdement.%SPEECH_ON%Ces satanés paysans parlent sans cesse des %enemy%. J\'ai l\'impression d\'avoir une montagne de merde sur les épaules ces jours-ci, ou même une chaîne de montagnes !%SPEECH_OFF%L\'homme s\'assoit et se verse une chope de bière. Il la boit rapidement.%SPEECH_ON%Les mangeurs de rêves par-ci, les traqueurs de la nuit par-là, bah ! Absolument n\'importe quoi. Eh bien, ces idiots ont rassemblé un coffre de couronnes et sont prêts à le donner contre une certaine protection. Je veux que vous restiez dans les parages une nuit ou deux pour voir si ces supposés esprits sont réels ou si nous avons juste des farceurs sur les bras. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% a la tête dans les mains et se tourne d\'un côté à l\'autre. Vous demandez si vous devez revenir une autre fois. Il tape du poing sur la table.%SPEECH_ON%Non ! C\'est le moment idéal. Les habitants de la ville se plaignent de rêves étranges depuis des jours. Et la nuit dernière, un cauchemar m\'a envahi. Je ne peux même pas lui donner un sens. Je me tenais dans un champ de blé et j\'ai vu des ombres passer à travers les tiges. Mais ce n\'était pas seulement des ombres, elles aplatissaient le blé en passant et... eh bien, quand je me suis réveillé, j\'ai vu les jambes de quelque chose juste au moment où elles s\'enfuyaient par ma porte. Ce... ce que je veux dire par là c\'est que nous voudrions que vous restiez pour la nuit et voyez si quelque chose vient pour vous, aussi. Êtes-vous intéressé ?%SPEECH_OFF% | Vous trouvez %employer% en train de feuilleter un tome. La poussière voltige à chaque changement de page. Il parle sans lever les yeux.%SPEECH_ON%La ville a collecté des fonds pour vous permettre de passer la nuit ici.%SPEECH_OFF%En souriant, vous demandez s\'il y a un repas gratuit avec cette offre. L\'homme referme lentement le livre. Il vous regarde plutôt simplement, comme si vous n\'aviez rien dit du tout.%SPEECH_ON%On craint des monstres étranges, des choses qui se nourrissent de rêves. Je pensais que c\'était une superstition, mais elles sont venues à moi la nuit dernière et j\'ai regardé dans ses yeux. Je me suis réveillé dans le grenier en priant Davkul. Mais qu\'est-ce que c\'est, Davkul ? Mon Dieu, je ne sais pas ce qui se passe, mais j\'espère que vous accepterez cette offre. Restez une nuit ou deux et voyez si nous avons plus que des rumeurs à craindre par ici.%SPEECH_OFF% | %employer% est trouvé en train de faire tourner une petite babiole en bois entre son pouce et un doigt. Elle a la forme d\'un homme à cornes. Il la jette sur son bureau et lui fait un signe de tête.%SPEECH_ON%Le charpentier a fait ça. Il a dit qu\'elle lui a rendu visite dans la nuit. J\'ai demandé quand. Il a dit dans ses rêves, et qu\'elle était au pied de son lit quand il s\'est réveillé. Puis, aujourd\'hui, trois familles entières sont venues me voir pour me dire qu\'elles avaient vu la même chose et que tous leurs chiens avaient disparu. Pas trouvés. Juste disparus. Je ne sais pas ce qui se trame dans ces régions impies, mercenaire, mais je ne passerai pas une nuit de plus sans un peu d\'acier à nos côtés. Cela vous intéresse-t-il de protéger %townname% pour une nuit ou deux ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combien de couronnes pouvez-vous rassembler ? | Parlons salaire. | Parlons des couronnes. | On pourrait s\'en occuper. Pour le bon prix.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne ressemble pas à un travail de mercenaire. | Ça ne ressemble pas à notre type de travail. | Ce n\'est pas le genre de travail que nous recherchons.}",
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
			Title = "Près de %townname%...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Alors que vous passez le temps, un vieil homme descend le chemin. Sans aucune hésitation, il déclare que si ce sont les hommes pâles que vous cherchez, il vaut mieux attendre la nuit. %randombrother% demande ce qu\'il entend par \"hommes pâles\". Le vieil homme rit.%SPEECH_ON%En vérité, ils sont ni hommes ni pâles, mais je ne sais pas comment les définir autrement dans ce monde. Mes aînés les appelaient %enemy%, des monstres qui vous mettent de mauvaises idées et visions dans la tête et se nourrissent ensuite de la peur qui en résulte. Mais vous êtes robustes, vous vous en sortirez bien.%SPEECH_OFF%Il appuie sur sur nez avec une de ses mains et vous souhaite bonne chance. | Pendant que vous vérifiez votre carte et prenez connaissance du terrain, %randombrother% arrive avec une vieille femme à ses côtés. Elle a l\'air vieille comme un chêne et vous fait signe de descendre avec une main tremblante. Vous tendez l\'oreille et elle parle d\'un ton grossier.%SPEECH_ON%Ils viennent la nuit. Eux et leurs visions.%SPEECH_OFF%Elle lève un doigt.%SPEECH_ON%Seulement la nuit ! Ils vivent pour la corruption. Pas de la terre, mais de votre esprit. Ma mère les appelait %enemy%, ils créent des visions et de l\'irréel. Quand vous les trouverez, vous entendrez le sifflement de votre santé mentale qui vous échappe. Tenez bon et vous survivrez.%SPEECH_OFF% | %randombrother% vient à côtés. Il dit qu\'il a déjà entendu parler de ces bêtes.%SPEECH_ON%La vieille histoire de monstres à propos de choses qui squattent le rebord de votre fenêtre et vous regardent dormir, ou qui grimpent sur votre lit et ouvrent vos rêves pour les regarder. Certains disent que ce n\'est rien de tout ça. Ils disent qu\'ils peuvent vous avoir pendant que vous êtes éveillé, vous mettre des visions dans la tête pour voir des choses qui ne sont pas là.%SPEECH_OFF% | %randombrother% vient à vous avec un air pensif sur son visage. Il explique qu\'il y a longtemps, il a connu un homme qui a été pendu pour un meurtre. Il disait qu\'il avait découpé ses enfants en morceaux. Mais l\'accusé a déclaré qu\'il venait juste de dépecer les poulets. Il les a vus et a vu leurs plumes, il a dit qu\'ils n\'étaient rien si ce n\'est de la volaille. Il a dit que lorsqu\'il est revenu à lui et qu\'il a vu l\'atrocité devant lui, une bête a ricané depuis le rebord de sa fenêtre, accroupie là, ricanant comme un diablotin. Le mercenaire acquiesce.%SPEECH_ON%Quand ils ont pendu ce type, ils ont dit qu\'il a crié sur quelque chose et a couru du tabouret. Il a continué à courir, à cracher sa vengeance malgré la corde qui lui arrachait le cou jusqu\'aux oreilles.%SPEECH_OFF% | %randombrother% vient vous voir avec un rapport de reconnaissance. Il déclare que les locaux n\'ont pas vu de bête, mais qu\'ils ont vu des choses inhabituelles. Lorsque vous demandez une explication, le mercenaire hausse les épaules.%SPEECH_ON%Je ne pourrais pas le dire correctement, monsieur. Il me semble qu\'ils voient juste des choses. Des visions et autres choses du genre. Je n\'étais pas du genre à croire ces sornettes, mais ils étaient sérieux à ce sujet.%SPEECH_OFF% }",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Gardez les yeux ouverts. | Nous devons être prêts pour cela. | Restez éveillés, les gars.}",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "Près de %townname%...",
			Text = "[img]gfx/ui/events/event_102.png[/img]{%randombrother% se précipite à vos côtés.%SPEECH_ON%Quelque chose bouge vers là-bas.%SPEECH_OFF%Vous portez votre regard vers l\'endroit qui vous est montré. Quoi que ce soit, ça rampe plus que ça marche. Ça ressemble à un cerf sans peau qui marche à reculons et ses yeux laissent des traces noires derrière lui, comme s\'il voulait graver l\'horreur sur la terre. Vous dites aux hommes de prendre leurs armes. | En examinant votre carte à la lumière d\'une torche, vous voyez soudain une forme noire bondir dans l\'obscurité. C\'est un fouillis de membres qui rampent sur le sol, s\'agitant en avant à une vitesse inconvenante. Elle marche aussi bas qu\'un serpent, mais vous entendez le grognement étouffant de quelqu\'un qui meurt dans son sommeil. Vous ordonnez aux hommes de prendre les armes. | Une forme pâle rôde autour de la compagnie. Elle s\'accroupit dans les hautes herbes et fixe la compagnie. Finalement, vous vous avancez, tendez les bras et fermez les yeux. Immédiatement, %randombrother% crie.%SPEECH_ON%Chef, reculez ! Chef, oh par les dieux, il y en a d\'autres !%SPEECH_OFF%Vous ouvrez les yeux et hochez la tête. Enfin, ils sont là.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chargez !",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Alps";
						p.Entities = [];
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Alps, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_122.png[/img]{Les monstres sont tués. Vous prenez votre épée et tailladez le cou de l\'un d\'eux. La lame coupe avec une grande facilité et la tête tombe pour rouler sur l\'herbe. Ses orbites sont vides et concaves. Il n\'y a rien à l\'intérieur, pas de chair, pas de muscle. Peu importe. Vous dites aux hommes de se préparer pour retourner voir %employer%. | Les alps gisent dans l\'herbe et bien que vous sachiez que vous les avez vus blessés, leur chair semble avoir cicatrisé et ils semblent plus tués par votre détermination que par une arme. Vous prenez votre épée pour couper une tête, mais la lame glisse à travers la peau et l\'entaille ainsi formé sur le cou se referme de nouveau. Vous poignardez le corps à plusieurs reprises, tordant la lame pour empêcher la chair de se cicatriser. Les muscles essaient désespérément de cicatriser avant de laisser tomber. Ne sachant pas trop quoi en penser vous préférez ne pas y penser, vous mettez la tête dans un sac et dites aux hommes de se préparer à retourner voir %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Notre paie nous attends.",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% demande à voir les restes de l\'alp. Vous la sortez du sac. La chair a dégonflé et vous tenez la tête plus comme un cuir chevelu que comme un crâne. Le citadin la touche avec son doigt et la peau de l\'alp se tord comme une peau de serpent. Il demande s\'ils se sont bien battus. Vous haussez les épaules.%SPEECH_ON%Des créatures pénibles, certes, mais qui ne m\'empêchent pas de dormir.%SPEECH_OFF%L\'homme acquiesce à contrecœur.%SPEECH_ON%Bien. Eh bien, voici votre récompense comme promis. Et jetez cette horrible chose.%SPEECH_OFF% | Vous jetez la tête de l\'alp sur le bureau de %employer%. Elle tombe sur le bois jusqu\'à ce que sa gueule s\'ouvre, ses orbites vides regardant tristement le monde d\'en haut. %employer% prend un fer et plante le crâne dessus crâne avant de le suspendre dans les airs.%SPEECH_ON%Quelle chose affreuse. Je dois vous dire que de nombreuses personnes sont venues me voir il y a quelques heures pour me dire qu\'elles avaient eu des visions de champs baignés d\'une lumière glorieuse. Comme s\'ils avaient rêvé du renouveau du monde entier. Je ne sais pas si ces monstres ont disparu jusqu\'au dernier, mais il semble que le problème de %townname% a bien été résolu. Je veillerai à ce que vous obteniez votre récompense comme promis.%SPEECH_OFF% | %employer% vous retrouve dans sa chambre et se moque du sac à dos que vous avez apporté. Il secoue la tête en se versant un verre.%SPEECH_ON%Vous n\'avez pas besoin de me montrer le visage de cette chose immonde, mercenaire. Elle m\'a rendu visite il y a quelques heures, alors que j\'étais assis là à écrire des notes, une intrusion qui était un rêve, une vision de sa mort comme si son esprit avait été séparé du mien et que j\'étais forcé de le voir partir. Et dans son départ, je vous ai vu vous tenir là, l\'épée à la main, victorieux comme jamais.%SPEECH_OFF%Vous hochez la tête et lui demandez si vous étiez présentable. Il rit.%SPEECH_ON%Vous aviez l\'air d\'un tueur de mondes, certainement un tueur du monde de cette créature et, je dois le craindre, peut-être un peu du mien aussi. Volé, de façon permanente. Eh bien, peu importe, que je sois un homme entier ou un homme brisé, je vous ai promis une bonne paie et la voici.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Débarrasser la ville des cauchemars contre nature.");

						if (this.Flags.get("IsGoodNightsSleep"))
						{
							return "GoodNightsSleep";
						}
						else
						{
							this.World.Contracts.finishActiveContract();
							return 0;
						}
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
		this.m.Screens.push({
			ID = "GoodNightsSleep",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Vous pariez que les hommes ont gagné un bon repos et font une pause à %townname%. Les hommes font la sieste dans un sommeil si profond qu\'ils pourraient aussi bien être morts. Au réveil, les hommes s\'étirent et bâillent. Aucun d\'entre eux n\'a fait de rêve ou de cauchemar, la sieste n\'était qu\'un bref moment de répit, bien nécessaire d\'ailleurs.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je me sens revigoré !",
					function getResult()
					{
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(1.0, "Rafraîchi par une bonne nuit de sommeil");
						bro.getSkills().removeByID("effects.exhausted");
						bro.getSkills().removeByID("effects.drunk");
						bro.getSkills().removeByID("effects.hangover");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
		_vars.push([
			"enemy",
			this.m.Flags.get("enemyName")
		]);
		_vars.push([
			"enemyC",
			this.m.Flags.get("enemyName").toupper()
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/terrifying_nightmares_situation"));
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

		this.m.Flags.set("SpawnAtTime", this.m.SpawnAtTime);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		if (!this.m.Flags.has("StartTime"))
		{
			this.m.Flags.set("StartTime", 0);
		}

		this.contract.onDeserialize(_in);

		if (this.m.Flags.has("SpawnAtTime"))
		{
			this.m.SpawnAtTime = this.m.Flags.get("SpawnAtTime");
		}
	}

});


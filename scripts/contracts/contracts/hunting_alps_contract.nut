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
			"vouleurs d'âmes",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Vous trouver %employer% avec un oreiller à la main. Un homme à ses côtés est en train de toucher l'oreiller avant de les porter à son nez. Il le renifle trois fois, puis secoue la tête avant de juger bon de le renifler à nouveau quand même. %employer% vous fait signe d'entrer.%SPEECH_ON%Un paysan des environs rapporte qu'un esprit étrange envahit son sommeil. Il a offert ses parures nocturnes comme preuve, mais nous ne savons pas quoi en faire.%SPEECH_OFF%Vous regardez l'homme étrange qui est de nouveau plongé le nez dans les draps. Vous levez un sourcil et déclarez que vous pouvez enquêter sur cette affaire. %employer% acquiesce.%SPEECH_ON%C'est précisément pourquoi je suis content que vous soyez là. Je veux que vous restiez dans le coin une nuit ou deux pour voir si quelque chose d'effrayant sort la nuit. Je suis sûr que ce n'est rien, mais je vous paierai quoi qu'il arrive. Qu'en dites-vous, cela vous intéresse-t-il ?%SPEECH_OFF%L'homme étrange s'agrippe presque à l'oreiller et prend des respirations profondes comme s'il s'étouffait. Il demande s'il peut garder l'oreiller. | %employer% vous amène à son bureau où se trouvent des dessins éparpillés.%SPEECH_ON%Je ne distribue pas souvent mes papiers et mes stylos aux gens du coin, mais une poignée de familles ont demandé à ce qu'ils dessinent ce qu'ils avaient vu.%SPEECH_OFF%Vous jetez un coup d'œil. Chaque page est différente, la plupart consistant en des figures de bâton dans des arrangements plutôt chaotiques. L'un des dessins les plus artistiques représente une bête étrange, accroupie sur une personne et serrant sa tête comme si elle voulait la voler. L'homme continue.%SPEECH_ON%Ça ressemble à des cauchemars ordinaires pour moi, mais j'ai enquêté sur les maisons concernés et chaque famille avait l'air très perturbée, comme si quelque chose se glissait dans leur sommeil. Je voudrais que vous restiez dans le coin, mercenaire, et que vous voyiez ce qui se passe. C'est probablement juste des voyous, mais ça vaut le coup de jeter un oeil. Êtes-vous intéressé ?%SPEECH_OFF% | Vous trouvez %employer% en train d'écouter un paysan raconter une histoire, mais en vous voyant, l'homme suggère au paysan de vous la raconter à sa place. Il explique que lui et de nombreuses autres familles ont fait des rêves horribles ces derniers temps. Non seulement cela, mais des animaux domestiques ont disparu et certains enfants ont rapporté avoir été emmenés et avoir dû rentrer chez eux à pied en pleine nuit. %employer% acquiesce.%SPEECH_ON%Toute la ville est sur les dents à ce sujet, mercenaire. J'ai entendu des histoires sur des %enemy%, des créatures macabres qui se régalent des rêves d'autrui, mais je suis sûr que c'est juste des enfants qui ne font rien de bon. Quoi qu'il en soit, une enveloppe a été collectée et je suis prêt à la distribuer pour une protection plus appropriée. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% est assis à son bureau. Il soupire lourdement.%SPEECH_ON%Ces satanés paysans parlent sans cesse des %enemy%. J'ai l'impression d'avoir une montagne de merde sur les épaules ces jours-ci, ou même une chaîne de montagnes !%SPEECH_OFF%L'homme s'assoit et se verse une chope de bière. Il la boit rapidement.%SPEECH_ON%Les mangeurs de rêves par-ci, les traqueurs de la nuit par-là, bah ! Absolument n'importe quoi. Eh bien, ces idiots ont rassemblé un coffre de couronnes et sont prêts à le donner contre une certaine protection. Je veux que vous restiez dans les parages une nuit ou deux pour voir si ces supposés esprits sont réels ou si nous avons juste des farceurs sur les bras. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% a la tête dans les mains et se tourne d'un côté à l'autre. Vous demandez si vous devez revenir une autre fois. Il tape du poing sur la table.%SPEECH_ON%Non ! C'est le moment idéal. Les habitants de la ville se plaignent de rêves étranges depuis des jours. Et la nuit dernière, un cauchemar m'a envahi. Je ne peux même pas lui donner un sens. Je me tenais dans un champ de blé et j'ai vu des ombres passer à travers les tiges. Mais ce n'était pas seulement des ombres, elles aplatissaient le blé en passant et... eh bien, quand je me suis réveillé, j'ai vu les jambes de quelque chose juste au moment où elles s'enfuyaient par ma porte. Ce... ce que je veux dire par là c'est que nous voudrions que vous restiez pour la nuit et voyez si quelque chose vient pour vous, aussi. Êtes-vous intéressé ?%SPEECH_OFF% | Vous trouvez %employer% en train de feuilleter un tome. La poussière voltige à chaque changement de page. Il parle sans lever les yeux.%SPEECH_ON%La ville a collecté des fonds pour vous permettre de passer la nuit ici.%SPEECH_OFF%En souriant, vous demandez s'il y a un repas gratuit avec cette offre. L'homme referme lentement le livre. Il vous regarde plutôt simplement, comme si vous n'aviez rien dit du tout.%SPEECH_ON%On craint des monstres étranges, des choses qui se nourrissent de rêves. Je pensais que c'était une superstition, mais elles sont venues à moi la nuit dernière et j'ai regardé dans ses yeux. Je me suis réveillé dans le grenier en priant Davkul. Mais qu'est-ce que c'est, Davkul ? Mon Dieu, je ne sais pas ce qui se passe, mais j'espère que vous accepterez cette offre. Restez une nuit ou deux et voyez si nous avons plus que des rumeurs à craindre par ici.%SPEECH_OFF% | %employer% est trouvé en train de faire tourner une petite babiole en bois entre son pouce et un doigt. Elle a la forme d'un homme à cornes. Il la jette sur son bureau et lui fait un signe de tête.%SPEECH_ON%Le charpentier a fait ça. Il a dit qu'elle lui a rendu visite dans la nuit. J'ai demandé quand. Il a dit dans ses rêves, et qu'elle était au pied de son lit quand il s'est réveillé. Puis, aujourd'hui, trois familles entières sont venues me voir pour me dire qu'elles avaient vu la même chose et que tous leurs chiens avaient disparu. Pas trouvés. Juste disparus. Je ne sais pas ce qui se trame dans ces régions impies, mercenaire, mais je ne passerai pas une nuit de plus sans un peu d'acier à nos côtés. Cela vous intéresse-t-il de protéger %townname% pour une nuit ou deux ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combien de couronnes pouvez-vous rassembler ? | Parlons salaire. | Parlons des couronnes. | On pourrait s'en occuper. Pour le bon prix.}",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{As you pass the time, an old man comes down the path. Without any prompting, he states that if it is the pale men you seek then it is best you wait til night. %randombrother% asks what he means by pale men. The old man laughs.%SPEECH_ON%Truthfully, they is neither pale nor men, but I don\'t know how else to put them in this world. My elders called them %enemy%, monsters that put ill notions and visions in your head and then feed on the fear which crops. But yer a sturdy lot, ye\'ll do well.%SPEECH_OFF%He thumbs his nose and wishes you good luck. | While you\'re checking your map and getting a lay of the land, %randombrother% comes up with an elderly woman at his side. She\'s looks old as oak and waves you down with a trembling hand. You lend an ear and she speaks in a coarse tone.%SPEECH_ON%They come at night. Them and their visions.%SPEECH_OFF%She raises a finger.%SPEECH_ON%Only at night! They live for corruption. Not of the land, but of your mind. My mother called them %enemy%, givers of apparitions and the unreal. When you find them, you will hear the hissing of your sanity slipping away. Hold it tight and ye shall survive yet.%SPEECH_OFF% | %randombrother% comes to your side. He says that he\'s heard of these beasts before.%SPEECH_ON%Ye old monster tale about things which squat in your windowsill and watch you sleep, or they climb up on your bedrest and peel your dreams open and look in. Some say it ain\'t none of that. They say they can get ya while yer awake, put visions right in yer noggin to see things that ain\'t there.%SPEECH_OFF% | %randombrother% comes to you with a pensive look on his face. He explains that a long time ago he knew a man that\'d been hanged for a murder. Said he chopped his children to bits. But the accused stated he\'d just been butchering the chickens. Saw them and their feathers, said they was nothing if not fowl. He said when he came to and saw the atrocity before him that a beast snickered from his windowsill, squattin\' there giggling all smarmlike. The sellsword nods.%SPEECH_ON%When they hanged that fella they said he yelled out at something and ran off the stool. Said he kept running, said he kept spitting vengeance despite the rope ripping his neck up onto his ears.%SPEECH_OFF% | %randombrother% comes to you with a scouting report. He states that locals haven\'t seen any beast, but they have been seeing things in the unusual way. When you ask for an explanation, the sellsword shrugs.%SPEECH_ON%I couldn\'t put it rightly, sir. Seems to me they\'re just seeing things. Visions and the like. I ain\'t one to trust such nonsense, but they was earnest about the matter.%SPEECH_OFF% | As you pass the time, an old man comes down the path. Without any prompting, he states that if it is the pale men you seek then it is best you wait til night. %randombrother% asks what he means by pale men. The old man laughs.%SPEECH_ON%Truthfully, they is neither pale nor men, but I don\'t know how else to put them in this world. My elders called them alps, monsters that plant nightmares in your head and feed on the fears which crop.%SPEECH_OFF%He thumbs his nose and wishes you good luck. | While you\'re checking your map and getting a lay of the land, %randombrother% comes up with an elderly woman at his side. She\'s looks old as oak and waves you down with a trembling hand. You lend an ear and she speaks in a coarse tone.%SPEECH_ON%They come at night.%SPEECH_OFF%She raises a finger.%SPEECH_ON%Only at night! They live for corruption. Not of the land, but of your mind. My mother called them %enemy%. When you find them, you will hear the hissing of your sanity slipping away. Hold it tight.%SPEECH_OFF% | %randombrother% comes to your side. He says that he\'s heard of these beasts before.%SPEECH_ON%You hear whispers about them now and again. Things which squat in your windowsill and watch you sleep, or they climb up on your bedrest and peel your dreams open and look in. They call them alps and the way I understand it they only come out at night. If they exist at all, of course.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Keep your eyes peeled. | We need to be ready for this. | Stay awake, people.}",
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
			Text = "[img]gfx/ui/events/event_102.png[/img]{%randombrother% hurriedly comes to your side.%SPEECH_ON%Something\'s moving just yonder.%SPEECH_OFF%You take your eyes to the perimeter of the patrol. Whatever it is, it\'s not moving so much as slipping over the ground. It looks like a skinned deer pacing backwards and its eyes leave streams of jet black behind as though to etch horror itself over the earth. You tell the men to grab their weapons. | Assessing your map by a torchlight, you suddenly see a black shape bounding through the darkness. It is a mess of limbs cartwheeling over the earth, flailing forward with unseemly speed. It stalks as low as a snake, yet you hear the choking snarl of someone dying in their sleep. You order the men to arms. | A pale shape stalks the rim of the company\'s patrol. It crouches in the tall grass and stares at the company. Finally, you walk forward and hold your arms out and close your eyes. Immediately, %randombrother% calls out.%SPEECH_ON%Sir get back! Sir, oh by the gods there are more!%SPEECH_OFF%You open your eyes and nod. Finally, they\'ve come.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
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
			Text = "[img]gfx/ui/events/event_122.png[/img]{The monsters are slain. You take your sword and hack into one\'s neck. The blade cuts through with complete ease and the head lolls off into the grass. Its eyesockets are barren and concave. There\'s nothing inside, no flesh, no muscle. Whatever. You tell the men to get ready for a return march to %employer%. | The alps lay in the grass and though you know you saw them hurt, their flesh seems to have healed over and they seem more slain by your resilience than any weapon. You take your sword to saw a head off, only to find the blade slides right through the skin and the neckhole puckers closed. You stab the body a few times, twisting the blade to rend the flesh unmendable. Sinews slither briefly before coming to rest in the wound\'s hole. Not sure what to make of that, you shovel the head into a bag and tell the men ready a Retournez à %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Payment awaits.",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% asks to see the alp\'s remains. You take it out of the bag. The flesh has deflated and you hold the head more like a scalp than a skull. The townsman touches it with his finger and the alp skin twists away like snakeskin. He asks if they fought well. You shrug.%SPEECH_ON%Hardy creatures to be certain, but I won\'t lose sleep over them.%SPEECH_OFF%The man nods reluctantly.%SPEECH_ON%Right. Well, here is your reward as promised. And throw that awful thing away.%SPEECH_OFF% | You dump the alp\'s head onto %employer%\'s desk. It flops over the wood until its maw rests wide, its emptied eyesockets drooping sadly at the world above. %employer% takes a fire iron and fishes autour de skull before hanging its shapelessness in the air.%SPEECH_ON%What an awful thing this is. I should let you know that many folks came to me just hours ago stating they\'d visions of fields being bathed in a glorious light. Like they\'d dreamt the renewal of the world whole. So I don\'t know if every last one of these monsters is gone, but it seems %townname%\'s plight has been well taken care of. I\'ll see to it that you get your reward as promised.%SPEECH_OFF% | %employer% meets you in his room and laughs at the knapsack you\'ve brought. He shakes his head as he pours a drink.%SPEECH_ON%You need not show me that foul thing\'s face, sellsword. It visited me just hours ago, while I was sitting right there writing notes, an intrusion that was a dream, a sight of its death as though its spirit had been severed from mine and I was forced to see it go. And in its leaving I saw you standing there, sword in hand, victorious as all get out.%SPEECH_OFF%You nod and ask if you looked good. He laughs.%SPEECH_ON%You looked a slayer of worlds, certainly a slayer of that creature\'s world and, I must fear, perhaps a bit of mine as well. Stolen, permanently. Well, no matter, I as a man whole or a man sundered, I\'ve promised you a good pay and here it is.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A successful hunt.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of unnatural nightmares");

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
			Text = "[img]gfx/ui/events/event_33.png[/img]{You wager the men have earned themselves a good rest and take a break in %townname%. The men spend the nap in slumbers so deep they might as well be dead. Awaking, the men stretch and yawn. Not a one has a dream or nightmare to speak of, the snooze but a brief touch of oblivion, and a much needed one at that.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I feel refreshed!",
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
						bro.improveMood(1.0, "Refreshed from having a great night\'s sleep");
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


this.hunting_hexen_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_hexen";
		this.m.Name = "A Pact With Witches";
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

		this.m.Flags.set("ProtecteeName", this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Restez au alentours de %townname% et protegez le premier née de %employer%"
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
					this.Flags.set("IsSpiderQueen", true);
				}
				else if (r <= 40)
				{
					this.Flags.set("IsCurse", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsEnchantedVillager", true);
				}
				else if (r <= 55)
				{
					this.Flags.set("IsSinisterDeal", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				this.Flags.set("Delay", this.Math.rand(10, 30) * 1.0);
				local envoy = this.World.getGuestRoster().create("scripts/entity/tactical/humans/firstborn");
				envoy.setName(this.Flags.get("ProtecteeName"));
				envoy.setTitle("");
				envoy.setFaction(1);
				this.Flags.set("ProtecteeID", envoy.getID());
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Home != null && !this.Contract.m.Home.isNull())
				{
					this.Contract.m.Home.getSprite("selection").Visible = true;
				}

				this.World.State.setUseGuests(true);
			}

			function update()
			{
				if (!this.Contract.isPlayerNear(this.Contract.getHome(), 600))
				{
					this.Flags.set("IsFail2", true);
				}

				if (this.Flags.has("IsFail1") || this.World.getGuestRoster().getSize() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.has("IsFail2"))
				{
					this.Contract.setScreen("Failure2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.has("IsVictory"))
				{
					if (this.Flags.get("IsCurse"))
					{
						local bros = this.World.getPlayerRoster().getAll();
						local candidates = [];

						foreach( bro in bros )
						{
							if (bro.getSkills().hasSkill("trait.superstitious"))
							{
								candidates.push(bro);
							}
						}

						if (candidates.len() == 0)
						{
							this.Contract.setScreen("Success");
						}
						else
						{
							this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
							this.Contract.setScreen("Curse");
						}
					}
					else if (this.Flags.get("IsEnchantedVillager"))
					{
						this.Contract.setScreen("EnchantedVillager");
					}
					else
					{
						this.Contract.setScreen("Success");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("StartTime") + this.Flags.get("Delay") <= this.Time.getVirtualTimeF())
				{
					if (this.Flags.get("IsSpiderQueen"))
					{
						this.Contract.setScreen("SpiderQueen");
					}
					else if (this.Flags.get("IsSinisterDeal") && this.World.Assets.getStash().hasEmptySlot())
					{
						this.Contract.setScreen("SinisterDeal");
					}
					else
					{
						this.Contract.setScreen("Encounter");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsBanterShown") && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 6.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getID() == this.Flags.get("ProtecteeID"))
				{
					this.Flags.set("IsFail1", true);
					this.World.getGuestRoster().clear();
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (_actor.getID() == this.Flags.get("ProtecteeID"))
				{
					this.Flags.set("IsFail1", true);
					this.World.getGuestRoster().clear();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Hexen")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Hexen")
				{
					this.Flags.set("IsFail2", true);
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Vous trouvez %employer% avec une omoplate autour de son cou, bien que ses arrangements thaumaturgiques ordinaires aient été remplacés par de l'ail et des oignons. Il a des larmes aux yeux.%SPEECH_ON%Oh, mercenaire, je suis heureux de te voir ! S'il te plaît, assieds-toi.%SPEECH_OFF%Sous des guirlandes chargées d'herbes, vous venez vous asseoir devant l'homme. Vos yeux se rétrécissent et commencent à pleurer. Il continue.%SPEECH_ON%Regarde, cela va me faire passer pour le plus grand idiot que tu aies jamais rencontré, mais écoute. Il y a de nombreuses années, mon premier-né, %protectee%, est venu au monde vêtu de maladie. Désespéré, j'ai cherché l'aide de sorcières...%SPEECH_OFF%Vous levez la main. Vous lui demandez s'il a fait un pacte et s'ils sont là pour réclamer la dette. L'homme hoche la tête.%SPEECH_ON%Oui. Dix-huit ans, c'est ce qu'elles ont promis, et ce soir est son dix-huitième sur terre. Ce n'est pas une tâche simple, mercenaire. Ces femmes sont dangereuses au-delà de toute compréhension de l'acier, et je parie qu'elles seront d'autant plus infernales quand elles apprendront que je refuse de payer. Es-tu sûr de vouloir m'aider à protéger mon enfant ?%SPEECH_OFF%En essuyant vos yeux, vous évaluez les options... | %employer% est trouvé dans le coin de sa chambre. Il est contorsionné pour regarder par la fenêtre comme une marmotte hors de son terrier. Voyant votre ombre s'étendre sur lui, il saute et saisit sa poitrine. Son clin d'œil de lâcheté n'est pas une affaire drôle, cependant, et il vient à vous avec sincérité.%SPEECH_ON%Les sorcières ont jeté un sort à ma famille ! Enfin, ont jeté un sort à ma lignée. Enfin, plus précisément à mon premier-né, %protectee%. Il y a bien des lunes, j'ai eu du mal à... tu sais, avec la femme. J'ai demandé de l'aide aux sorcières et elles m'ont concocté quelque chose de convenable pour la chambre à coucher. Bien sûr, les sorcières étant ce qu'elles sont, elles sont maintenant de retour et demandent de prendre mon premier-né !%SPEECH_OFFVous êtes étonné que des sorcières puissent lui faire cela et exprimez votre sympathie. %employer% vous rabroue.%SPEECH_ON%Ce n'est pas une affaire de plaisanterie ! J'ai besoin de protection pour mon premier-né, es-tu prêt à aider à sauver %protectee% ou non ?%SPEECH_OFF% | Vous trouvez %employer% en train de feuilleter fébrilement des livres. C'est d'une manière qui suggère qu'il les a déjà étudiés auparavant et qu'il les recherche maintenant précipitamment pour trouver un indice manqué. Il n'y en a pas et il jette les tomes de sa table avec une explosion de colère. En vous voyant, il essuie son front et explique.%SPEECH_ON%J'ai cherché partout une réponse, mais il semble que je doive recourir à l'acier. Ce serait ton acier, mercenaire. Je vais être honnête avec toi. J'ai conclu des accords avec des sorcières il y a de nombreuses années pour protéger mon premier-né, %protectee%, d'une fièvre infernale. L'enfant a survécu, mais maintenant ces femmes horribles reviennent et réclament mon enfant comme paiement.%SPEECH_OFF%Vous hochez la tête. C'est presque aussi mauvais que les machinations de certains usuriers. Il continue, enfonçant un doigt dans le bureau.%SPEECH_ON%J'ai besoin de toi ici, mercenaire. J'ai besoin d'une épée pour protéger %protectee% toute la nuit, et pour tuer ces maudites sorcières afin que ma lignée puisse survivre au-delà de ce cauchemar. Es-tu prêt à aider ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Tu devras bien nous payer pour affronter cet ennemi. | Convaincs-moi que cela vaut le coup avec une bourse pleine de couronnes. | Je m'attends à être très bien payé pour combattre un ennemi comme celui-ci.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Il me semble que tu devrais honorer ton pacte. | Cela ne vaudra pas le risque. | Je préférerais ne pas impliquer la compagnie avec un ennemi comme celui-ci.}",
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{%randombrother% s'approche de toi. Il se nettoie l'oreille avec un auriculaire.%SPEECH_ON%Salut capitaine. T'as vu des filles coquines par ici ?%SPEECH_OFF%Entendant cela, %randombrother2% s'approche. Il se penche.%SPEECH_ON%Hé, de ce que j'ai entendu, ces sorcières sont plutôt belles, mais c'est comme ça qu'elles t'attrapent. Elles te trompent avec leurs charmes et puis elles dévorent ton âme.%SPEECH_OFF%En riant, %randombrother% essuie la cire sur la tenue de %randombrother2%.%SPEECH_ON%Elles devront aller à %randomtown% pour avoir mon âme, alors, car une autre femme les a devancées.%SPEECH_OFF% | Tu inspectes l'inventaire lorsque %randombrother% s'approche. Tu l'avais envoyé en reconnaissance et il a préparé un rapport.%SPEECH_ON%Monsieur, rien en vue pour le moment, mais j'ai discuté avec certains habitants. Selon eux, les sorcières font des pactes avec des gens ordinaires et échangent sur l'investissement des années plus tard, généralement avec un grand intérêt. Ils disent qu'elles peuvent te tromper en te faisant les voir comme des séductrices lubriques. Elles peuvent te conduire droit dans la tombe ! J'ai dit que cela me semblait être une foutaise.%SPEECH_OFF%Hochant la tête, tu demandes à l'homme ce qu'est une foutaise. Il rit.%SPEECH_ON%Sérieusement ? C'est une sorte de noix, monsieur.%SPEECH_OFF% | Les frères passent le temps, plaisantant sur les femmes et les sorcières, et s'il y a vraiment une différence significative entre les deux. %randombrother% tend la main.%SPEECH_ON%Maintenant, sérieusement, j'ai entendu des histoires sur ces femmes. Elles peuvent te jeter un sort pour te faire voir des choses. Elles te font signer des pactes de sang et si tu ne paies pas, elles te coupent les rotules et les utilisent pour la divination. En enfer, quand j'étais enfant, mon voisin a conclu un marché avec l'une d'elles, puis il a disparu. Plus tard, j'ai vu une femme mystérieuse se promener avec un crâne frais utilisé comme lanterne !%SPEECH_OFF%%randombrother2% hoche la tête attentivement.%SPEECH_ON%C'est incroyable, mais est-ce que quelqu'un sait ce qu'une sorcière fait ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = Restez concentrés, les gars.",
					function getResult()
					{
						if (this.Flags.get("StartTime") + this.Flags.get("Delay") - 3.0 <= this.Time.getVirtualTimeF())
						{
							this.Flags.set("Delay", this.Flags.get("Delay") + 5.0);
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SpiderQueen",
			Title = "Près de  %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{Une femme solitaire croise votre chemin et s'approche entre un écart d'arbres. Elle se promène avec ses cuisses glissant dedans et dehors d'une robe de soie. Sa peau est impeccable et ses yeux émeraude fixent entre des mèches de roux avec une luxure que vous n'avez pas vue depuis votre jeunesse. Vous savez que cette femme est une sorcière, car une telle perfection ne peut subsister dans ce monde et dans ces contrées, c'est comme mettre du maquillage pour aller à la tombe. Ce qu'elle a fait. Vous tirez votre épée et lui dites de faire face à son destin avec honneur. La peau de la sorcière se plisse pour révéler sa véritable forme sinistre, et elle glousse avec délice.%SPEECH_ON%Ah, pendant un moment, je vous avais, mais le coq s'affaisse, et la fierté revient. Vous avez des parfums si délicieux, mercenaire. Je veillerai à ce qu'ils vous préservent rien que pour moi.%SPEECH_OFF%Avant que vous ne puissiez demander ce qu'elle veut dire, les deux arbres entre lesquels elle se tient s'épanouissent avec l'étirement de pattes d'araignée. De grandes ampoules noires émergent de la broussaille et se précipitent vers la terre en dessous, les webknechts cliquetant leurs mandibules avec la faim de l'imago. Les mains de la sorcière montent et ses doigts dansent comme un marionnettiste commandant les nuages au-dessus.}",
			Image = "",
			List = [],
			Options = [
				{
					Text =  "Aux armes !",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Hexen";
						p.Entities = [];
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.Entities.push({
							ID = this.Const.EntityType.Spider,
							Variant = 0,
							Row = 1,
							Script = "scripts/entity/tactical/enemies/spider_bodyguard",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID(),
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.Spider,
							Variant = 0,
							Row = 1,
							Script = "scripts/entity/tactical/enemies/spider_bodyguard",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID(),
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.Hexe,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/hexe",
							Faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID(),
							function Callback( _e, _t )
							{
								_e.m.Name = "Spider Queen";
							}

						});
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Spiders, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SinisterDeal",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{%randombrother% siffle et bascule sa casquette devant les belles dames qui sont arrivées comme par enchantement pour séduire la compagnie. Vous retenez le mercenaire en arrière et avancez, mais avant que vous ne puissiez parler, l'une des femmes lève les mains et s'avance vers vous.%SPEECH_ON%Laisse-moi te montrer ma vraie nature, mercenaire.%SPEECH_OFF%Ses bras vont sur ses côtés et deviennent gris et se ratatinent comme une peau d'amande mouillée. Les cheveux autrefois brillants et soyeux tombent en longs brins ondulants jusqu'à ce que son crâne grotesque soit découvert, les dernières racines là tenant un assemblage aggloméré de moucherons et de poux comme des congrégations finales sur un monde mourant. Elle s'incline, son visage dirigé vers vous avec un sourire jaune coupé à travers.%SPEECH_ON%Nous avons un grand pouvoir, mercenaire, cela tu le vois sûrement. Je te propose un marché.%SPEECH_OFF%Elle sort une minuscule fiole dans chaque main, l'une portant une goutte de liquide vert, l'autre bleu. Elle sourit et les fait tournoyer entre ses doigts tout en parlant.%SPEECH_ON%Un breuvage pour le corps, ou pour l'esprit. Les hommes tueraient pour l'un ou l'autre. Je t'en offre un en échange de la vie du premier-né. Quelle valeur a la progéniture d'un étranger ? Tu en as abattu plus d'un, n'est-ce pas ? Écarte-toi, mercenaire, et laissez-nous avoir celui-ci. Ou affronte-nous, risque la vie de tes hommes, et la tienne, tout ça pour un marmot qui ne se souviendra pas de ton visage en temps voulu. C'est ton choix.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je ne céderai jamais ce garçon à vous, vieilles harpies. Aux armes !",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Hexen";
						p.Entities = [];
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HexenAndNoSpiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "Je désire une boisson pour le corps.",
					function getResult()
					{
						return "SinisterDealBodily";
					}

				},
				{
					Text = "Je désire une boisson pour l'esprit.",
					function getResult()
					{
						return "SinisterDealSpiritual";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SinisterDealBodily",
			Title = "près de %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{La sorcière sourit.%SPEECH_ON%Un homme n'est rien sans un corps apte à le manœuvrer à travers le monde. Te voilà, mercenaire. S'il te plaît, ne le gaspille pas.%SPEECH_OFF%Elle te lance la fiole. En vrillant dans l'air, elle cligne des spectres viridiens à travers la terre, chaque plongée de sa faible lumière faisant surgir une petite fleur de la boue non ensemencée. Tu attrapes le verre. Il vibre dans ta main, et la douleur de tes os s'éloigne lentement, comme si ton poing avait dormi tout ce temps et que tu ne le savais simplement pas. Quand tu lèves les yeux pour demander une explication, les sorcières sont déjà parties. Un cri solitaire est tout ce qui reste, s'élevant dans la grande distance mais sans moyen de savoir à quelle distance il est. Sans aucun doute, c'est la fin du premier-né de %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Trop bon marché pour refuser.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Betrayed " + this.Contract.getEmployer().getName() + " and struck a deal with witches");
						this.World.Contracts.finishActiveContract(true);
						return;
					}

				}
			],
			function start()
			{
				local item = this.new("scripts/items/special/bodily_reward_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "SinisterDealSpiritual",
			Title = "Near %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{D'un geste de la main et d'une secousse du poignet, la sorcière pousse la fiole verte le long de sa manche. La fiole bleue restante, elle te la tend.%SPEECH_ON%Un homme intelligent que tu es, mercenaire.%SPEECH_OFF%Elle renifle bruyamment, son gros nez se ratatinant dans l'envergure d'une larve avant de retomber lourdement.%SPEECH_ON%Je sens des hommes perspicaces dans ton sang, mercenaire. J'aurais presque envie d'avoir le sang pour moi-même.%SPEECH_OFF%Ses yeux te fixent comme un chat sur un criquet démembré, un criquet qui ose encore bouger. Mais ensuite son sourire revient, plus de gencives que de dents, plus de noir que de rose.%SPEECH_ON%Ah, eh bien, un marché est un marché. Te voilà.%SPEECH_OFF%Elle lance la fiole dans les airs et d'ici à ce que tu l'attrapes et que tu regardes en arrière, les sorcières sont parties. Tu entends le cri faible d'une torture horrifique, sa distance semblant à la fois proche et lointaine, et tu ne doutes guère qu'il s'agit de la fin du premier-né de %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Trop bon marché pour refuser.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "Betrayed " + this.Contract.getEmployer().getName() + " and struck a deal with witches");
						this.World.Contracts.finishActiveContract(true);
						return;
					}

				}
			],
			function start()
			{
				local item = this.new("scripts/items/special/spiritual_reward_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "près de %townname%",
			Text = "[img]gfx/ui/events/event_106.png[/img]{%randombrother% siffle et crie.%SPEECH_ON%Nous avons de la compagnie. Belle... magnifique compagnie...%SPEECH_OFF%Une femme au regard lubrique s'approche du groupe. Elle se pavane sur le sol avec facilité, un doigt jouant avec son oreille, l'autre pincant une pierre suspendue sur son décolleté bombé. Tu tapes sur l'épaule du mercenaire.%SPEECH_ON%Ce n'est pas une dame ordinaire.%SPEECH_OFF%Juste après que les mots aient quitté tes lèvres, les traits amples et jeunes de la femme se ratatinent en un gris modelé et ses cheveux luxuriants se flétrissent de son crâne et ce qu'il te reste est une sorcière, grimaçant avec rien d'autre que des intentions maléfiques. Aux armes ! Protégez %protectee% ! | Vous repérez une femme s'approchant du groupe. Elle porte du rouge vif et un collier se balance sur et entre ses seins opulents. C'est une vue assez spectaculaire, mais elle est sans défaut et une telle chose n'existe pas dans ce monde.\n\nVous tirez votre épée. La dame voit l'acier et vous regarde ensuite avec un sourire rusé. Des mèches de cheveux tombent de sa tête et ce qui reste se flétrit en mèches grises. Sa peau se contracte en vallées pâles et ses ongles poussent si longs qu'ils s'enroulent. Elle pointe un doigt vers vous et crie que personne n'empêchera la conclusion du pacte qu'elle a fait. Vous criez à la compagnie de vous assurer que %protectee% reste hors de danger. | Une femme est repérée s'approchant de la compagnie. Les mercenaires sont ensorcelés par sa beauté, mais vous savez mieux. Vous tirez votre épée et la faites claquer assez fort pour attirer la colère de cette prétendue dame. Elle ricane et ses lèvres se replient avec un sourire qui va d'une oreille à l'autre. Sa peau se resserre jusqu'à ce qu'elle se plisse et devienne d'un gris pâle. Elle rit et rit alors que ses cheveux tombent. La sorcière pointe un doigt vers vous.%SPEECH_ON%Ah, je sens ta lignée, mercenaire, mais cela n'a pas d'importance d'où tu viens. Le pacte doit être payé par le sang du premier-né et quiconque se mettra sur notre chemin saignera de même !%SPEECH_OFF%La compagnie se met en formation et tu dis à %protectee% de baisser la tête.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux Armes !",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Hexen";
						p.Entities = [];
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HexenAndNoSpiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Curse",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_124.png[/img]{Alors que vous entamez votre retour vers %employer%, vous trouvez %superstitious% fixant du regard une sorcière. Vous pouvez voir que les lèvres maudites de la femme bougent toujours, et vous vous précipitez vers elle. Elle parle en proférant des malédictions que vous interrompez d'un coup de talon. Des dents voltigent depuis ses gencives déchirées tandis qu'elle rit. Vous tirez votre épée et la plantez entre ses yeux, la mettant en repos une fois pour toutes. %superstitious% est pratiquement en train de trembler.%SPEECH_ON%Elle savait tout de moi ! Elle connaissait tout, capitaine ! Elle savait tout ! Elle savait quand je mourrais et comment !%SPEECH_OFF%Vous dites à l'homme d'ignorer chaque mot que la sorcière lui a dit. En hochant la tête, il rejoint la compagnie, mais son visage grimace avec des présages qui ne peuvent être ignorés.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "N'y pense même pas.",
					function getResult()
					{
						return "Success";
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				local effect = this.new("scripts/skills/effects_world/afraid_effect");
				this.Contract.m.Dude.getSkills().add(effect);
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = this.Contract.m.Dude.getName() + " is afraid"
				});
				this.Contract.m.Dude.worsenMood(1.5, "Was cursed by a witch");

				if (this.Contract.m.Dude.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "EnchantedVillager",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_124.png[/img]{Alors que les hommes se remettent de la bataille, un jeune paysan court à travers le champ en hurlant et poussant des cris de joie. Vous vous retournez pour le voir tomber devant une sorcière et tenir son corps hideux et parcheminé, le serrant entre ses bras en se balançant d'avant en arrière. En vous voyant, il crache des malédictions.%SPEECH_ON%Pourquoi avez-vous fait ça, hein ? Espèces de salauds, tous autant que vous êtes ! Elle était ma femme depuis une quinzaine de jours et maintenant je dois l'enterrer. Eh bien, je dis que prenez-moi avec elle ! Faites de votre pire, bande de sauvages ! Ce monde nous enterrera tous les deux, mon amour !%SPEECH_OFF%Vous haussez un sourcil. L'homme a dû être ensorcelé quelque temps avant votre arrivée, probablement un laquais des sorcières. Quoi que vous pensiez, quelques hommes sont un peu perturbés par la vue du garçon en deuil. Cependant, un mercenaire plus résistant avec un sourire narquois et la main sur son arme demande s'il doit accorder la requête du gamin. Vous secouez la tête et ordonnez aux hommes de reprendre leur formation.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Pauvre fou.",
					function getResult()
					{
						return "Success";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_124.png[/img]{La bataille terminée, %randombrother% vient à vos côtés. Il dit que %protectee% est mort pendant le combat. Il dit que ses globes oculaires sont partis ainsi que sa langue, que son visage ressemble à deux chiffons mouillés se repliant l'un sur l'autre. Aucun intérêt à retourner chez %employer% maintenant. | Vous regardez le cadavre de %protectee%. Les globes oculaires ont été arrachés et pendent sur ses joues comme des crabes humides. Son visage est étiré en un sourire, bien que ce qui l'a mis de cette manière n'ait pas dû être le moins du monde drôle. %randombrother% demande si la compagnie devrait retourner chez %employer% et vous secouez la tête. | Vous trouvez le premier-né de %employer% gisant au sol. Chaque articulation a été évidée ou tailladée, bien que le moment ou la manière dont cela s'est produit vous échappent. %randombrother% essaie de déplacer le corps, mais il se tord et claque comme une marionnette sans ficelles. Le mercenaire grimace et lance le cadavre au sol où il se replie dans un panier de sa propre cage thoracique, la tête en forme d'œuf dans le nid. Il n'y a plus aucune raison de retourner chez %employer% maintenant.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Merde, merde, merde !",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to protect " + this.Contract.getEmployer().getName() + "\'s firstborn son");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_16.png[/img]{%employer% vous payait pour protéger %protectee%. Il est difficile de protéger le premier-né lorsque vous quittez %townname% et l'abandonnez aux sorcières. N'essayez même pas de retourner chercher votre salaire. | Vous aviez pour mission de garder %protectee% en sécurité à %townname%, ou avez-vous oublié ? N'essayez même pas de retourner, le premier-né est sans aucun doute déjà mort ou, pire, pris par les sorcières pour quelque dessein néfaste.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Oh, zut.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to protect " + this.Contract.getEmployer().getName() + "\'s firstborn son");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% étreint %protectee%, tenant le premier-né fermement. Il vous regarde.%SPEECH_ON%Alors, c'est fait, toutes les sorcières sont mortes ?%SPEECH_OFF%Vous hochez la tête. Le citadin fait de même.%SPEECH_ON%Merci ! Merci, mercenaire !%SPEECH_OFF%Il vous montre une malle dans le coin de la pièce. Elle est pleine de votre paiement. | Vous ramenez %protectee% à %employer%. Le citadin et le premier-né s'étreignent comme la narration de deux rêves distincts d'une circonstance identique, se rapprochant lentement malgré les appels de la réalité. Finalement, ils se serrent l'un contre l'autre et s'arrêtent pour se regarder mutuellement pour s'assurer que tout est bien réel. Vous dites à %employer% que chaque sorcière est morte, mais qu'il devrait garder l'histoire pour lui. Il hoche la tête.%SPEECH_ON%Les esprits se nourrissent de l'hubris, je le sais bien, et je porterai cette histoire jusqu'à la tombe. Je vous remercie pour ce que vous avez fait aujourd'hui, mercenaire. Je vous remercie à une telle mesure que vous ne pourriez pas imaginer. J'ai qu'une seule façon d'exprimer ma gratitude.%SPEECH_OFF%Il vous apporte une bourse d'or. La vue du sac débordant de pièces fait naître un sourire chaleureux sur votre visage. | %protectee% court de votre côté et dans les bras de %employer%. Le citadin regarde par-dessus l'épaule de son premier-né.%SPEECH_ON%Alors, c'est fait, nous sommes libérés de la malédiction ?%SPEECH_OFF%Vous haussez les épaules et répondez.%SPEECH_ON%Vous êtes libres des sorcières.%SPEECH_OFF%Le citadin pince les lèvres et hoche la tête.%SPEECH_ON%Eh bien, c'est déjà bien. Votre paiement est là dans la bourse, autant que promis.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Tout s'est arrangé à la fin.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Protected " + this.Contract.getEmployer().getName() + "\'s firstborn son");
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
			"superstitious",
			this.m.Dude != null ? this.m.Dude.getName() : ""
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
		_vars.push([
			"protectee",
			this.m.Flags.get("ProtecteeName")
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/abducted_children_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Home.getSprite("selection").Visible = false;
			this.World.State.setUseGuests(true);
			this.World.getGuestRoster().clear();
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


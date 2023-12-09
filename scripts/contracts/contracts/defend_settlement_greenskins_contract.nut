this.defend_settlement_greenskins_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Reward = 0,
		Kidnapper = null,
		Militia = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_settlement_greenskins";
		this.m.Name = "Defend Settlement";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
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
					"Defendez %townname% et ses alentours contre les groupes de pillards"
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
				local nearestOrcs = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements());
				local nearestGoblins = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements());

				if (nearestOrcs.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(0, 6) <= nearestGoblins.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(0, 6))
				{
					this.Flags.set("IsOrcs", true);
				}
				else
				{
					this.Flags.set("IsGoblins", true);
				}

				if (this.Math.rand(1, 100) <= 25 && this.Contract.getDifficultyMult() >= 0.95)
				{
					this.Flags.set("IsMilitia", true);
				}

				local number = 1;

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					number = number + this.Math.rand(0, 1);
				}

				if (this.Contract.getDifficultyMult() >= 1.1)
				{
					number = number + 1;
				}

				local locations = this.Contract.m.Home.getAttachedLocations();
				local targets = [];

				foreach( l in locations )
				{
					if (l.isActive() && !l.isMilitary() && l.isUsable())
					{
						targets.push(l);
					}
				}

				number = this.Math.min(number, targets.len());
				this.Flags.set("ActiveLocations", targets.len());

				for( local i = 0; i != number; i = ++i )
				{
					local party;

					if (this.Flags.get("IsGoblins"))
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Goblins, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
					else
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Orcs, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}

					party.setAttackableByAI(false);
					local c = party.getController();
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
					local t = this.Math.rand(0, targets.len() - 1);

					if (i > 0)
					{
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(4.0 * i);
						c.addOrder(wait);
					}

					local move = this.new("scripts/ai/world/orders/move_order");
					move.setDestination(targets[t].getTile());
					c.addOrder(move);
					local raid = this.new("scripts/ai/world/orders/raid_order");
					raid.setTime(40.0);
					raid.setTargetTile(targets[t].getTile());
					c.addOrder(raid);
					targets.remove(t);
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);
			}

			function update()
			{
				if (this.Contract.m.UnitsSpawned.len() == 0 || this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyGone = true;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 1200.0)
						{
							isEnemyGone = false;
							break;
						}
					}

					if (isEnemyGone)
					{
						if (this.Flags.get("HadCombat"))
						{
							this.Contract.setScreen("ItsOver");
							this.World.Contracts.showActiveContract();
						}

						this.Contract.setState("Return");
						return;
					}
				}

				if (!this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyHere = false;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 700.0)
						{
							isEnemyHere = true;
							break;
						}
					}

					if (isEnemyHere)
					{
						this.Flags.set("IsEnemyHereDialogShown", true);

						foreach( id in this.Contract.m.UnitsSpawned )
						{
							local p = this.World.getEntityByID(id);

							if (p != null && p.isAlive())
							{
							}
						}

						if (this.Flags.get("IsGoblins"))
						{
							this.Contract.setScreen("GoblinsAttack");
						}
						else
						{
							this.Contract.setScreen("OrcsAttack");
						}

						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsKidnapping") && !this.Flags.get("IsKidnappingInProgress") && this.Contract.m.UnitsSpawned.len() == 1)
				{
					local p = this.World.getEntityByID(this.Contract.m.UnitsSpawned[0]);

					if (p != null && p.isAlive() && !p.isHiddenToPlayer() && !p.getController().hasOrders())
					{
						local c = p.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
						c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(true);
						this.Contract.m.Kidnapper = this.WeakTableRef(p);
						this.Flags.set("IsKidnappingInProgress", true);
						this.Flags.set("KidnappingTooLate", this.Time.getVirtualTimeF() + 60.0);
						this.Contract.setScreen("Kidnapping1");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Kidnapping");
					}
				}

				if (this.Flags.get("IsMilitia") && !this.Flags.get("IsMilitiaDialogShown"))
				{
					this.Flags.set("IsMilitiaDialogShown", true);
					this.Contract.setScreen("Militia1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

		});
		this.m.States.push({
			ID = "Kidnapping",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Sauvez les prisonniez qui sont enlevés",
					"Retournez à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Kidnapper == null || this.Contract.m.Kidnapper.isNull() || !this.Contract.m.Kidnapper.isAlive())
				{
					if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() <= 5.0)
					{
						this.Flags.set("IsKidnapping", false);
						this.Contract.setScreen("Kidnapping2");
					}
					else
					{
						this.Contract.setScreen("Kidnapping3");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (this.Contract.m.Kidnapper.isHiddenToPlayer() && this.Time.getVirtualTimeF() > this.Flags.get("KidnappingTooLate"))
				{
					this.Contract.setScreen("Kidnapping3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
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
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(true);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local locations = this.Contract.m.Home.getAttachedLocations();
					local numLocations = 0;

					foreach( l in locations )
					{
						if (l.isActive() && !l.isMilitary() && l.isUsable())
						{
							numLocations = ++numLocations;
						}
					}

					if (numLocations == 0 || this.Flags.get("ActiveLocations") - numLocations >= 2)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Failure2");
						}
						else
						{
							this.Contract.setScreen("Failure1");
						}
					}
					else if (this.Flags.get("ActiveLocations") - numLocations >= 1)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Success4");
						}
						else
						{
							this.Contract.setScreen("Success2");
						}
					}
					else if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
					{
						this.Contract.setScreen("Success3");
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{When you see %employer% he\'s got sweat pouring down his face and dabbing it with a nicely embroidered cloth that seems to achieve nothing in stemming the tide.%SPEECH_ON%Mercenary, it is oh so good  to see you! Please, please come in and listen to what I have to say.%SPEECH_OFF%You cautiously walk into the room and take a seat, glancing momentarily to make sure nobody was hiding behind the crook of the door or behind one of the bookshelves lining the walls. %employer% pushes a map across his table.%SPEECH_ON%See those green markings? Those are greenskin movements, tracked by my scouts. Sometimes they tell me by word, sometimes they don\'t tell me at all. Those scouts just... poof, disappear. It doesn\'t take a genius to know what really happened to them though, does it?%SPEECH_OFF%You ask what the man wants. He slams the map, his fist landing square on %townname%.%SPEECH_ON%Can you not see? They\'re coming this way and I need you to help defend us!%SPEECH_OFF% | %employer%\'s nervously picking his nails when you find him. He\'s got them down to nubs by this point, just flecks of skin and blood shaving away at this point.%SPEECH_ON%Thank you for coming, sellsword. I\'ll be frank with you, the greenskins are coming.%SPEECH_OFF%Using a hand for height measurements, you ask what sort of greenskin, the ones yeigh big, or the ones about hmmm, big. %employer% shrugs.%SPEECH_ON%I\'ve no idea. My scouts keep disappearing and the villagers that keep arriving aren\'t exactly the most accurate of witnesses to depend upon. All you need to know is that we need your help, because those greenskins are coming this way.%SPEECH_OFF% | %employer%\'s drunk and nestled deep into his chair. He thumbs toward an opened book on his table.%SPEECH_ON%Have you heard of the Battle of Many Names? It went down about ten years ago when the orcs came streaming into man\'s land, and when man fielded his armies and said, No.%SPEECH_OFF%You nod, knowing the battle well, and the war it helped end. The man continues.%SPEECH_ON%Unfortunately, we have reason to believe that they\'re coming back. Greenskins, don\'t know what type, don\'t know how tall or what sort, but this way they do indeed come.%SPEECH_OFF%He throws back the rest of his drink, swallowing as though it were to be the last thing that\'d go down his throat before an executioner removed his head.%SPEECH_ON%Will you stay here and protect us? For the right price, of course. I haven\'t forgotten your station yet.%SPEECH_OFF% | %employer%\'s by his window when you enter.%SPEECH_ON%You hear that?%SPEECH_OFF%A throng of people are practically baying in the streets, a mix of apathetic moans and outright horrified crying.%SPEECH_ON%That\'s what you hear when the greenskins are coming.%SPEECH_OFF%The man shutters the windows and turns to you.%SPEECH_ON%I know it\'s a lot to ask, but we do have money so I\'ll go ahead and ask anyway. Will you help protect %townname%?%SPEECH_OFF% | %employer%\'s fighting off a crowd when you find him.%SPEECH_ON%Everyone calm down! Just calm down!%SPEECH_OFF%Someone throws an onion, battering the man upside the head with a tearjerking rap of sour vegetable. Someone else quickly scurries to pick it up and take a bite. %employer% points you out in the crowd.%SPEECH_ON%Sellsword! I am so glad you came!%SPEECH_OFF%He fights through the crowd. He leans in close to your ear, yet still has to shout to be heard.%SPEECH_ON%We have money! We have what you need! Just help protect this town from the greenskins!%SPEECH_OFF% | %employer%\'s employees are rummaging about his room, collecting scrolls and books alike before hurrying off to who knows where. The man himself is simply sitting in his chair, occasionally drinking from a goblet while perusing a map. He waves you in.%SPEECH_ON%Take a seat. Don\'t mind my workers.%SPEECH_OFF%You do as asked, but it\'s hard to ignore the frenzy around you. %employer% sits back, tenting his fingers atop his belly.%SPEECH_ON%I\'m sure you\'ve noticed things are rather unusual around here. That\'s because a large band of greenskins have been spotted and they\'re heading this way, murdering and destroying all that stands before them. Obviously, I\'d like you to help defend %townname% before we all end up in some scribe\'s footnote, understand?%SPEECH_OFF% | You enter %employer%\'s abode and can\'t help but notice there\'s mud all over the floor and a squelched fire in his pit. Some of his workers hurry about with scrolls stuffed in their arms. You can barely even see their heads over all the paper. You see %employer% standing in the midst of the chaos, simply directing his employees to do this or that. When you walk up to him he simply nods.%SPEECH_ON%Greenskins are coming. What kind? I don\'t know. What I do know is what will happen if I can\'t help defend this town which is why we\'re doing a little bit of prep work here, understand?%SPEECH_OFF%You nod in return, but then ask what else he wants.%SPEECH_ON%Help us fight these greenskins, of course. There\'s plenty of money in it for you, obviously.%SPEECH_OFF% | Peasants have come to %employer%\'s abode. They\'re carrying armfuls of belongings, a litter of it trailing behind their every step, so urgent to flee they don\'t even bother picking up any of it. %employer% himself sees you through one of his window\'s and waves you to come in through a side door. When you sneak in, he simply plops down in his chair and pours you a drink.%SPEECH_ON%Greenskins are coming and I don\'t believe there are enough men on hand to defend %townname%. Obviously, I\'m willing to call on and pay for your services to help keep %townname% safe from this green menace.%SPEECH_OFF% | A man is standing outside %employer%\'s abode, two painted slabs of wood dressed over himself. On each board is written some prophetic doomsayer\'s tale. You ignore the man and enter the house. %employer% is standing there, laughing and shaking his head.%SPEECH_ON%That guy standing out there ain\'t wrong. My scouts have been reporting greenskins moving through the area for a while. I should have listened for how my scouts haven\'t said anything for a good week, presumably because those very same greenskins got their hands on them. Now I got the commonfolk coming to me with horror stories of what is going on out there, and how a large horde of those awful creatures are coming this way.%SPEECH_OFF%He turns to you, grinning, madness spinning in his grin.%SPEECH_ON%So what say you and I broker a deal and shut up that doomsayer\'s shrill crying? Will you help protect %townname%?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combien est prêt à payer %townname% pour leur sécurité? | Ça devrait valoir une bonne quantité de couronnes pour vous, non ? | Combattre les peaux-vertes ne sera pas bon marché.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{J'ai bien peur que cela ne vaille pas la peine pour la %companyname%. | Je vous souhaite bonne chance, mais nous ne participerons pas à cela.}",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							this.World.Contracts.removeContract(this.Contract);
							return 0;
						}
						else
						{
							return "Plea";
						}
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Plea",
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_43.png[/img]{En quittant %employer% avec un refus, vous croisez un homme qui rit et secoue la tête.%SPEECH_ON%Hé, les peaux-vertes ne sont pas par là, à moins, bien sûr, que cela ne fasse partie de votre plan, espèce de lâche.%SPEECH_OFF%Vous tirez votre épée, laissant son acier gratter le fourreau longtemps et bien. L'homme rit.%SPEECH_ON%Oh, et qu'allez-vous faire avec ça ? Me transpercer ? D'accord. Allez-y. Faites pire que les peaux-vertes, je vous mets au défi.%SPEECH_OFF%Une femme sort en courant, attrape l'homme et le ramène.%SPEECH_ON%Attrapez les enfants, d'accord ? Nous devons partir, maintenant !%SPEECH_OFF%Le couple s'éloigne en traînant les pieds, mais votre tête tourne toujours avec l'accusation de lâcheté du paysan. | Les paysans emballent déjà la route pour sortir de %townname%. Certains vous jettent un coup d'œil et l'un d'eux s'avance même, un vieil homme avec une canne.%SPEECH_ON%Voyez-vous, c'est ce que c'est dans le monde d'aujourd'hui ! Tous les hommes courageux sont morts, et il ne reste que des lâches comme ce prétendu épéiste ici.%SPEECH_OFF%%randombrother% s'avance, sortant son arme et semblant prêt à tuer.%SPEECH_ON%Vous osez insulter %companyname% ? Je vais avoir votre langue, puis votre tête, vieil homme !%SPEECH_OFF%Vous attrapez le mercenaire par l'épaule. La dernière chose dont ces gens ont besoin, c'est de la violence, mais l'homme a parlé fort et clair. Maintenant, vous vous demandez qui l'a entendu et qui survivra pour répandre le poids derrière ses paroles. | Une femme s'accroche à vous pendant que vous essayez de rejoindre la compagnie.%SPEECH_ON%Monsieur, s'il vous plaît ! Vous ne devez pas nous abandonner à ce sort ! Vous ne savez pas ce que les peaux-vertes vont nous faire !%SPEECH_OFF%Vous avez effectivement une très forte idée, mais vous la gardez pour vous. La femme tombe à genoux et agrippe vos chevilles. Vous parvenez à sortir de sa prise. Pendant un bref moment, elle se traîne après vous, piétinant dans la boue, puis s'arrête et se met à pleurer.%SPEECH_ON%Vous ne savez pas ce que c'est. Ça ne semble jamais s'améliorer pour nous. Pour moi.%SPEECH_OFF%Par les dieux, c'est pathétique, mais vous ressentez un peu de sympathie monter en vous. | En quittant %employer% avec le refus, un homme sort de chez lui. Il caresse un poulet et a des larmes dans les yeux.%SPEECH_ON%Monsieur, si vous restez, vous pouvez l'avoir.%SPEECH_OFF%Le paysan embrasse le poulet. Il cacarde sans réfléchir, ne reflétant pas exactement l'angoisse sur le visage de son propriétaire.%SPEECH_ON%Restez simplement et aidez à sauver cette ville. Vous pouvez l'avoir. Restez, s'il vous plaît.%SPEECH_OFF%Oh boy, est-ce vraiment ce que ça va devenir ? | Un homme très désordonné et très âgé s'avance vers vous.%SPEECH_ON%Alors, vous avez décidé de ne pas aider ? Je suppose que je ne peux pas blâmer ça.%SPEECH_OFF%Il étend un bras vers quelques paysans se tenant à proximité. Ils ont des caisses de marchandises avec eux, des affaires entassées qui vont des légumes moisis à un ou deux poulets, ou peut-être que ces deux poulets sont un seul agneau minuscule et bruyant.%SPEECH_ON%Ces gens aimeraient que vous restiez et les aidiez. Mais je comprends pourquoi vous ne le feriez pas. J'étais là à la Bataille de nombreux noms. Je sais ce que c'est que de combattre ces bêtes. Je ne vous blâmerai pas. Il faut un homme de grande mesure pour les affronter. C'est ainsi, c'est ainsi, monsieur, et je ne vous blâmerai pas, pas le moins du monde.%SPEECH_OFF%Il s'éloigne lentement et c'est alors que vous remarquez qu'une de ses jambes est remplacée par un pied en bois. Quelques enfants courent vers lui et il parle au groupe de paysans. Il vous regarde, puis les regarde, et secoue la tête. Vous pouvez presque sentir la tristesse et la déception vous submerger.}",
			Image = "",
			List = [],
			ShowEmployer = false,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Diable, nous ne pouvons pas laisser ces gens mourir. | D'accord, d'accord, nous ne quitterons pas %townname%. Parlons au moins du paiement.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Je suis sûr que vous vous en sortirez. Faites place. | Je ne vais pas risquer %companyname% pour sauver quelques paysans affamés.}",
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
			ID = "OrcsAttack",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_49.png[/img]Les peaux-vertes sont en vue ! Préparez-vous au combat et protégez la ville !",
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
			ID = "GoblinsAttack",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_48.png[/img]Les peaux-vertes sont en vue ! Préparez-vous au combat et protégez la ville !",
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
			ID = "ItsOver",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Les combats sont terminés. %employer% sera sans aucun doute ravi de vous revoir. | La bataille est terminée et les hommes se reposent dans un répit bienvenu. %employer% vous attendra en ville. | Avec la fin de la bataille, vous examinez les cadavres jonchant le champ. C'est une vue horrible, et pourtant, cela vous stimule étrangement. Les collines fantasmagoriques des morts ne font que vous rappeler la vitalité que vous n'avez pas encore cédée à ce monde horrible. Des personnes comme %employer% devraient venir voir ça, mais il ne le fera pas, alors c'est à vous d'aller le voir à la place. | Chair et os éparpillés sur le champ, à peine discernables d'un propriétaire à l'autre. Des vautours noirs survolent, des halos d'ombres en forme de chevron ondulant sur les morts, les oiseaux attendant que les pleureurs dégagent. %randombrother% vient à vos côtés et demande s'ils doivent commencer le retour vers %employer%. Vous quittez le champ de bataille derrière et faites signe de la tête. | Une sorte de ruine paisible est faite des morts. Comme si c'était leur état naturel, raidis et en perte permanente, et que toute leur vie n'était qu'un accès fugace à un accident finalement arrivé à sa fin. %randombrother% vient à vos côtés et vous demande si ça va. Vous n'en êtes pas sûr, pour être honnête, et répondez simplement qu'il est temps d'aller voir %employer%. | Des hommes difformes et des cadavres tordus jonchent le sol car la bataille ne donne aux morts aucune souveraineté sur la manière dont on parvient à un repos final. Les têtes sans corps semblent avoir la paix, car en bataille, aucun homme ou bête n'a le temps de vraiment couper un cou, cela ne se produit que par les coups de lame les plus rapides et les plus tranchants. Une partie de vous espère partir avec une telle finalité instantanée, mais une autre partie espère que vous aurez la chance d'emmener votre tueur avec vous.\n\n %randombrother% vient à vos côtés et demande des ordres. Vous détournez le regard du champ et dites à la %companyname% de se préparer à retourner à %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retournons à la mairie !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ItsOverDidNothing",
			Title = "Near %townname%",
			Text = "[img]gfx/ui/events/event_30.png[/img]La fumée emplit l'air, de la fumée et l'odeur caustique du bois qui brûle, des moyens de subsistance qui brûlent. Les habitants de %townname% ont mis tous leurs espoirs dans l'embauche de la %companyname%, une erreur fatale.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ça ne s'est pas déroulé comme prévu...",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia1",
			Title = "À %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Alors que vous vous préparez à défendre %townname%, la milice locale s'est rangée à vos côtés. Ils se soumettent à vos ordres, demandant seulement que vous les envoyiez là où vous pensez qu'ils sont le plus nécessaires. | Il semble que la milice locale ait rejoint la bataille ! Un groupe hétéroclite d'hommes, mais ils seront néanmoins utiles. Maintenant, la question est : où les envoyer ? | La milice de %townname% s'est jointe au combat ! Bien qu'il s'agisse d'un groupe mal équipé d'hommes armés de manière médiocre, ils sont impatients de défendre leur foyer. Ils se soumettent à votre commandement, faisant confiance à votre jugement pour les envoyer là où ils sont le plus nécessaires. | Vous n'êtes pas seul dans cette bataille ! La milice de %townname% s'est jointe à vous. Ils sont impatients de combattre et vous demandent où ils sont le plus nécessaires.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Alignez-vous, vous serez sous mon commandement.",
					function getResult()
					{
						return "Militia2";
					}

				},
				{
					Text = "Allez défendre la mairie de %townname%.",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), home.getName() + " Militia", false, this.Const.World.Spawn.Militia, home.getResources() * 0.7);
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("Brave men defending their homes with their lives. Farmers, craftsmen, artisans - but not one real soldier.");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(home.getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "Allez défendre la périphérie de %townname%.",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), home.getName() + " Militia", false, this.Const.World.Spawn.Militia, home.getResources() * 0.7);
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("Brave men defending their homes with their lives. Farmers, craftsmen, artisans - but not one real soldier.");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local locations = home.getAttachedLocations();
						local targets = [];

						foreach( l in locations )
						{
							if (l.isActive() && !l.isMilitary() && l.isUsable())
							{
								targets.push(l);
							}
						}

						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(targets[this.Math.rand(0, targets.len() - 1)].getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "Allez vous cacher quelque part et restez hors de notre chemin.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia2",
			Title = "À %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]Maintenant que vous avez décidé de prendre certains des habitants sous votre commandement, ils demandent comment ils devraient s'armer pour le combat à venir.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prenez des arcs, vous tirerez depuis l'arrière.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				},
				{
					Text =  "Prenez une épée et un bouclier, vous combattrez à l'avant.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				},
				{
					Text = "Armez-vous comme vous le souhaitez.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia;

							if (this.Math.rand(0, 1) == 0)
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							}
							else
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							}

							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MilitiaVolunteer",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]{La bataille terminée, l'un des miliciens qui a aidé à la défense vient à vous personnellement, se penchant bas et offrant son épée.%SPEECH_ON%Monsieur, mon temps avec la ville de %townname% est révolu. Mais l'habileté de la %companyname% est vraiment une vue étonnante. Si vous le permettez, monsieur, j'aimerais combattre à vos côtés avec vous et vos hommes.%SPEECH_OFF% | Avec la fin de la bataille, l'un des miliciens de %townname% déclare qu'il viendra volontiers combattre pour la %companyname%. En partie parce qu'il a été impressionné par le combat de la bande de mercenaires, et en partie parce qu'être enrôlé de force dans la défense de la ville n'est ni financièrement ni physiquement sain.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bienvenue dans la %companyname% !",
					function getResult()
					{
						return 0;
					}

				},
				{
					Text = "Ce n'est pas l'endroit pour vous.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping1",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Alors que vous surveillez les environs à la recherche des peaux-vertes, un paysan vient vous dire qu'un groupe de ces bêtes a attaqué à proximité et semble avoir emmené un bon nombre d'otages. Vous secouez la tête, incrédule. Comment les brutes ont-elles pu s'infiltrer et faire cela ? Le profane hoche également la tête.%SPEECH_ON%Je pensais que vous étiez censés nous aider. Pourquoi n'avez-vous rien fait ?%SPEECH_OFF%Vous demandez si les peaux-vertes ont beaucoup avancé. Le paysan hausse les épaules, mais pense qu'ils sont encore assez proches pour les rattraper. On dirait que vous avez encore une chance de récupérer ces pauvres gens avant que les dieux ne sachent ce qui leur arrive. | Un homme en haillons, portant une fourche cassée, court vers votre compagnie. Il s'effondre et gémit à vos pieds.%SPEECH_ON%Les peaux-vertes ont attaqué ! Oh, ils étaient exactement comme mon grand-père disait qu'ils étaient ! Et où étiez-vous ? Ils ont tué des gens... en ont brûlé quelques-uns... et... je pense qu'ils en ont mangé quelques-uns... oh, par les dieux. Mais ce n'est pas le pire ! Les peaux-vertes ont pris quelques malheureux en otage ! S'il vous plaît, allez les sauver !%SPEECH_OFF%Vous regardez %randombrother% et hochez la tête.%SPEECH_ON|Préparez les hommes. Nous devons poursuivre ces bêtes immondes avant qu'elles ne s'échappent complètement.%SPEECH_OFF% | Vous avez les yeux rivés sur l'horizon, à la recherche de tout signe ou son des abominables peaux-vertes. Soudain, %randombrother% vient à vous avec une femme à ses côtés. Il la pousse en avant et fait un signe de tête. Agrippant sa poitrine, elle sanglote et raconte une histoire sur la façon dont les peaux-vertes ont déjà attaqué, dévastant un hameau voisin. Elle explique qu'ils n'ont pas seulement tué des gens, mais ont plutôt pris quelques-uns en otage. Le mercenaire hoche la tête.%SPEECH_ON|On dirait qu'ils nous ont doublés, monsieur.%SPEECH_OFF%Vous n'avez plus qu'un choix maintenant - aller chercher ces gens. | Vous stationnez près de %townname%, attendant l'assaut des peaux-vertes. Vous pensiez que cela serait facile, mais l'arrivée soudaine d'un paysan enragé dit le contraire. Le paysan explique que les maudits pillards ont déjà attaqué un petit village dans l'arrière-pays. Ils ont massacré tout le monde qu'ils pouvaient, puis, leur soif de sang assouvie, se sont enfuis avec quelques hommes, femmes et enfants. Le paysan, soit ivre, soit en état de choc, marmonne ses supplications.%SPEECH_ON|Allez... allez les chercher, hein ?%SPEECH_OFF% | Quelques paysans en colère prennent les routes, se dirigeant vers vous dans un tourbillon de colère populaire.%SPEECH_ON|Je pensais qu'on vous payait pour nous protéger ! Où étiez-vous ?%SPEECH_OFF%Ils sont couverts de sang. Certains sont à moitié vêtus. Un homme porte un bras contre sa poitrine. Le membre manque d'une main. Vous demandez au groupe de quoi il s'agit. Une femme s'avance avec des enfants accroupis autour d'elle. Elle leur couvre les oreilles.%SPEECH_ON|De quoi parlons-nous ? Vous, maudits mercenaires ! Les peaux-vertes sont venues, qui d'autre ? Vous étiez censés nous protéger, mais vous deviez être trop occupés à vous masturber mutuellement et à salir le lit pour réaliser qu'ils avaient déjà glissé ! Nous avons réussi à nous échapper, mais ceux qui n'ont pas pu ont été pris en otage ! Savez-vous ce qui arrive à ceux qui sont pris par les peaux-vertes ? Parce que, bon, je veux dire, je ne le sais pas, mais je soupçonne que ce n'est pas des chansons et des tartes !\n\n Vous dites à la femme de la fermer avant que sa bouche ne commence à arracher des poulets que son corps ne peut pas manger.%SPEECH_ON|Nous allons les récupérer.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Allons-y !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Rangeant votre épée, vous ordonnez à %randombrother% d'aller libérer les prisonniers. Une litanie de paysans ébahis est libérée de lanières de cuir, de chaînes et de cages à chiens. Ils vous remercient pour votre arrivée opportune. Un gratte les blessures à ses poignets où se trouvaient les chaînes.%SPEECH_ON|Merci, vendeur d'épées.%SPEECH_OFF%Il fait un signe de tête vers une broche où un cadavre noir ratatiné pend au-dessus d'un feu éteint.%SPEECH_ON|Dommage que vous n'êtes pas arrivé à temps pour la sauver. Elle était vraiment belle. Maintenant, eh bien, regardez-la.%SPEECH_OFF%L'homme sourit ironiquement avant d'éclater en sanglots. | Les maudits peaux-vertes sont massacrés. Vous envoyez vos hommes pour aller secourir chaque paysan qu'ils peuvent trouver. Chacun vient ensemble, se serrant dans les bras et pleurant, fou de bonheur d'avoir survécu à cette expérience terrifiante. | Après avoir tué le dernier peau-verte, vous ordonnez à la compagnie d'aller libérer les otages. Chacun vient à vous à son tour, certains vous embrassant la main, d'autres vos pieds. Vous leur dites seulement de retourner à la salle de ville de %townname%, car vous vous y dirigerez aussi. | Ayant tué le dernier peau-verte, vous ordonnez aux hommes de libérer les otages. Ils sortent en titubant, complètement sous le choc alors qu'ils errent parmi les ruines de la bataille. Certains fouillent le campement des peaux-vertes. Vous regardez un {homme | femme} ramasser un tas d'os fumants et calcinés. Ils contemplent simplement les restes, les posent, puis se lèvent et marchent plus profondément dans les terres sauvages.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On dirait que c'est fini.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping3",
			Title = "Près de %townname%",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Malheureusement, les peaux-vertes ont réussi à s'échapper avec les otages. Que les dieux soient avec ces âmes désolées. | Vous n'avez pas pu le faire - vous n'avez pas pu sauver ces pauvres paysans. Maintenant, seuls les dieux savent ce qui leur arrivera. En fait, vous le savez aussi, mais vous ferez semblant de ne pas le savoir juste pour pouvoir dormir la nuit. | Malheureusement, les bêtes immondes ont réussi à s'échapper avec leur cargaison humaine. Ces pauvres gens vont maintenant devoir se débrouiller seuls. Cependant, les histoires que vous entendez vous disent qu'ils ne s'en sortiront pas bien du tout. | Les peaux-vertes ont réussi à s'enfuir avec leurs prisonniers à leurs côtés. Vous n'avez aucune idée de ce qui arrivera à ces gens maintenant, mais vous savez que ce n'est pas bon. Esclavage. Torture. Mort. Vous ne savez pas lequel est le pire. | Les peaux-vertes et leurs malheureux otages ont réussi à s'enfuir. Vous souhaitez le meilleur à ces gens, mais lorsque le vent s'engouffre, soufflant une chanson vide et raide, vous savez très bien qu'aucun vœu ou prière ne sauvera ces âmes désolées. | Eh bien, les peaux-vertes ont réussi à s'enfuir. La traînée d'os humains rongés et les tas de chair pelée en disent long sur votre échec. | Vous ramassez un morceau de vêtement pour découvrir qu'il reposait sur un tas d'os.%SPEECH_ON%Merde.%SPEECH_OFF%Il y a une traînée de restes de 'nourriture' s'éloignant du site. Les peaux-vertes ont réussi à s'échapper et les pauvres prisonniers ont disparu avec eux. | %randombrother% vous appelle. Lorsque vous vous tenez à côté de lui, il pointe un tas de merde par terre. Vous hausserez les épaules.%SPEECH_ON%Ouais. Ça sent mauvais. Quoi d'autre?%SPEECH_OFF%Il donne un coup de pied dans un morceau de blanc, soulevant ce qui semble être un os de la masse informe.%SPEECH_ON%C'est un os humain. Ces prisonniers ont été mangés, monsieur.%SPEECH_OFF%Vous regardez autour de l'herbe et voyez encore plus de restes. Des empreintes de pas s'éloignent du site, les peaux-vertes ayant clairement échappé à votre poursuite. Vous soupirez et dites aux hommes de se préparer à partir.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Ils n'aimeront pas ça à %townname%... | J'espère que ce sera une mort rapide pour eux.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% vous accueille avec une bourse de %reward% couronnes.%SPEECH_ON%Vous l'avez bien mérité, mercenaire, je dirais ça. Aucune partie de cette ville, enfin rien d'important, n'a été touchée.%SPEECH_OFF%Il fait une pause pendant que vous fixez le coffre. C'était difficile et mérité. Vous vous attendiez juste à plus. Parfois, la simplicité d'être mercenaire vous agace vraiment. | Vous trouvez %employer% en train de nourrir certains de ses chiens. Il en caresse un encore et encore pendant qu'il dévore.%SPEECH_ON%Je pensais vraiment devoir abandonner ça.%SPEECH_OFF%Il donne une dernière tape au clébard avant de vous regarder.%SPEECH_ON%Merci, mercenaire. Vous avez fait plus que simplement protéger cette ville, vous avez protégé un mode de vie. Sans vous, nous aurions tous soit tous mouru, soit pire, vécu pour voir l'horreur que demain aurait sûrement apportée.%SPEECH_OFF%Vous hochez la tête et avancez pour donner une tape à l'un des chiens, mais il vous regarde en grognant. %employer% rit.%SPEECH_ON%S'il vous plaît, pardonnez son ignorance.%SPEECH_OFF% | %employer% a une bande d'hommes et de femmes qui l'entourent. Lorsque vous entrez dans la pièce, ils se tournent vers vous d'un unisson presque effrayant. Ils vous fixent un moment avant de se lancer dans des célébrations et de se précipiter vers vous, étreintes et larmes à l'appui. Les repoussant, vous trouvez %employer% debout là avec une sacoche à la main.%SPEECH_ON%C'est pour avoir sauvé %townname%, mercenaire. Si je suis honnête, ce n'est pas aussi lourd que ça devrait l'être, mais c'est tout ce que nous avons.%SPEECH_OFF% | %employer% regarde par sa fenêtre lorsque vous Retournez à lui. Dehors, des miliciens courent partout et les habitants se serrent dans les bras.%SPEECH_ON%Aucun peau-verte n'est entré dans la place de la ville.%SPEECH_OFF%Il sourit en vous remettant une sacoche de marchandises.%SPEECH_ON%Vous avez dépassé les attentes aujourd'hui, mercenaire.%SPEECH_OFF% | Trouver %employer% n'était pas facile : toute la ville est en émoi de célébrations. Ils attrapent des poulets si vite que les oiseaux parviennent parfois à s'échapper, courant à moitié coqs et à moitié plumés le long des routes tandis que les enfants les poursuivent. %employer% parvient à vous surprendre au milieu des festivités.%SPEECH_ON%Il y a beaucoup de deuil à faire, mais nous le réservons pour demain. Aujourd'hui, nous célébrons la vie et vos actes, mercenaire.%SPEECH_OFF%L'homme remet une sacoche de biens et elle pèse dans votre main. | Vous trouvez %employer% en train de réorganiser une étagère de livres. Il semble réapprovisionner ses marchandises, comptant soigneusement et numérotant ses biens comme un commerçant. Il sursaute lorsque la porte claque derrière vous.%SPEECH_ON%Ah, mercenaire ! Vous m'avez fait peur là.%SPEECH_OFF%Il attrape un coffre sur l'une des étagères de livres et vous le tend.%SPEECH_ON%Je pensais prendre tous ces livres, tous ces parchemins, et m'enfuir. Maintenant, cependant, je n'aurai plus besoin de le faire et c'est tout grâce à vous.%SPEECH_OFF%Son sourire s'assombrit un instant.%SPEECH_ON%Tout le monde n'a pas eu la chance de voir ce jour, et votre victoire. Ce soir, je dois m'assurer que les défunts reçoivent une sépulture digne.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Le %companyname% saura bien utiliser cela. | Paiement pour une dure journée de travail.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Defended the town against greenskins");
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
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% a la tête entre ses mains. Vous pointez par la fenêtre.%SPEECH_ON%La ville est sauvée, pourquoi verser une larme, hein ?%SPEECH_OFF%Il relève les yeux vers vous.%SPEECH_ON%Ouais, la plupart des gens s'en sont sortis, je suppose que c'est vrai. Mais ça ne veut pas dire que les peaux-vertes n'ont pas déchiré une bonne partie de cette foutue ville.%SPEECH_OFF%Il pousse un coffre de biens à travers sa table avant de se frotter le front.%SPEECH_ON%Désolé d'être si sombre, mais je suis sûr que vous comprenez, mercenaire. Enfin, j'espère que vous comprenez.%SPEECH_OFF%Vous le faites, mais vous faites semblant de ne pas vous en soucier. | Vous trouvez %employer% derrière sa demeure. Il a une pelle en main et il renvoie quelques paysans. Il y a des monticules de terre fraîche ici et là.%SPEECH_ON%Vous êtes une vue pour les yeux endoloris, mercenaire.%SPEECH_OFF%Il s'appuie sur le manche de la pelle.%SPEECH_ON%Juste, euh, enterrer ceux qui n'ont pas survécu. Vous avez fait un foutu bon boulot, et je ne veux pas que vous pensiez le contraire, mais beaucoup de gens n'ont pas survécu. Je ne vous tiens pas du tout responsable, les peaux-vertes sont un adversaire redoutable et il ne serait pas sage de ma part de m'attendre à la perfection contre eux.%SPEECH_OFF%Vous hochez la tête et l'homme fait de même. Il ramasse une sacoche qui traînait parmi une pile de pelles boueuses. Elle laisse une traînée de boue en volant dans les airs. Vous l'attrapez et hochez de nouveau la tête avant de laisser l'homme à sa tâche. Vous pouvez entendre le schkk, schkk de sa pelle frappant la terre en vous éloignant. | %employer% étudie une carte lorsque vous revenez. Il met un doigt sur un endroit, puis utilise pratiquement ses mots pour guider le doigt le long.%SPEECH_ON%Cet endroit n'a pas survécu. Cette maison a été brûlée. Ces gens sont morts. Nous avons trouvé ces gens dans les bois. Je pense qu'ils essayaient de se cacher, mais ils venaient juste d'avoir un nouveau-né. Je suppose que c'est ce qui les a trahis.%SPEECH_OFF%Il se penche en avant, enroulant ses mains sur la table.%SPEECH_ON%Vous avez bien fait, mercenaire, mais tout le monde ne pouvait pas être sauvé. C'est ce que c'est, comme on dit, et je ne vous en tiendrai pas rigueur. Pas tant que moi et beaucoup d'autres respirerons encore.%SPEECH_OFF%Il vous lance une sacoche de couronnes. Vous la prenez et hochez la tête en retour. C'est ce que c'est, et ce que c'est, c'est un bon salaire. | Vous trouvez %employer% qui fait lentement défiler un long parchemin entre ses doigts. Il hoche la tête et fredonne pour lui-même.%SPEECH_ON%Savez-vous ce que c'est que de lire les noms des voisins morts ?%SPEECH_OFF%Vous le savez, mais ne vous embêtez pas à l'interrompre.%SPEECH_ON%C'est une sensation étrange. Je les connais, mais maintenant, je ne peux pas voir leur visage. Je reconnais juste leurs noms, comme des mots, pas plus extraordinaires que n'importe quel autre. Ce ne sont que des mots de vocabulaire maintenant. Des descriptions d'une mémoire, je suppose.%SPEECH_OFF%Il lève les yeux vers vous, puis jette le parchemin de côté pour vous chercher une sacoche de couronnes.%SPEECH_ON%Bon sang, je ne veux pas vous déranger comme ça, mercenaire. Voici votre récompense comme promis.%SPEECH_OFF% | %employer% dirige un homme avec un pinceau. Leur toile est un mélange de papier épais et de ce qui semble être du verre. Curieux, vous demandez ce qui se passe.%SPEECH_ON%J'érige la bataille. Je la mémorialise.%SPEECH_OFF%Il pointe un segment où un bâtiment brûle.%SPEECH_ON%Vous voyez ça ? Quand vous êtes parti combattre les peaux-vertes, ils ont brûlé cet endroit. Et celui-là aussi. Nous nous souviendrons de tout, de peur que nous n'oubliions.%SPEECH_OFF%L'homme vous donne une sacoche de couronnes avant de retourner rapidement à l'art. En regardant l'image, vous ne voyez pas votre compagnie nulle part dedans.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{C'est juste la moitié de ce que nous avons convenu ! | C'est ce que c'est...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Defended the town against greenskins");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% vous accueille à votre retour avec un coffre de %reward% couronnes.%SPEECH_ON%Vous l'avez bien mérité, mercenaire, je dois dire. Malheureusement, les peaux-vertes ont réussi à enlever quelques-uns des nôtres. Je retiens une partie de votre paiement pour aider à compenser ceux qui ont mis leur vie entre vos mains.%SPEECH_OFF%Il marque une pause pendant que vous fixez le coffre. Vous hochez la tête, comprenant la détresse des paysans, mais réalisant que toute argumentation ici ne servirait pas vos perspectives futures. | Vous trouvez %employer% en train de nourrir certains de ses chiens. Il caresse l'un d'eux encore et encore pendant qu'il dévore des restes de dîner.%SPEECH_ON%Je pensais vraiment devoir tout abandonner.%SPEECH_OFF%Il donne une dernière tape au chien avant de tourner les yeux vers vous.%SPEECH_ON%Mais tout le monde n'a pas survécu. Votre paiement est dans le coin, mais il sera moins que convenu. Je dois veiller au bien-être de ceux qui ont été enlevés, je suis sûr que vous comprenez pourquoi je prends ce paiement de vous.%SPEECH_OFF% | %employer% est entouré d'un groupe d'hommes et de femmes. Lorsque vous entrez dans la pièce, ils se tournent vers vous d'une manière étrangement unie. %employer% leur distribue des couronnes. Il vous parle pendant qu'il fait cela.%SPEECH_ON%Votre paiement est dehors avec l'un de mes gardes. Il sera léger, car j'en ai pris une partie pour aider à réconforter ceux qui ont été perdus dans la bataille.%SPEECH_OFF%Vous jetez un coup d'œil aux pauvres âmes qui traînent dans la pièce. Ils doivent être liés à ceux que les peaux-vertes ont kidnappés. | %employer% regarde par la fenêtre lorsque vous Retournez à lui. Dehors, des miliciens courent dans tous les sens et les habitants se serrent les uns contre les autres en se serrant dans les bras.%SPEECH_ON%La ville proprement dite a été épargnée, mais je dois regretter de vous dire qu'il y aura moins de monde à arpenter ses routes dans les jours à venir.%SPEECH_OFF%Il sourit en vous remettant un sac de couronnes qui semble un peu plus léger qu'il ne devrait l'être.%SPEECH_ON%Vous avez fait un travail exceptionnel aujourd'hui, mercenaire, mais tout le monde n'a pas pu être sauvé. Ceux qui ont été emmenés par les peaux-vertes ont laissé derrière eux des familles, et à ces familles va une partie de votre salaire. Je suis sûr que vous comprenez.%SPEECH_OFF% | Retrouver %employer% n'a pas été facile : toute la ville est en émoi de célébrations. Les habitants attrapent des poulets si vite que parfois les oiseaux parviennent à s'échapper, courant à moitié penchés et à moitié plume dans les rues tandis que les enfants les poursuivent gaiement. %employer% réussit à vous surprendre au milieu des festivités. L'homme vous remet un sac de biens qui pèse dans votre main.%SPEECH_ON%Tout le monde ne peut pas être aussi jovial, mercenaire. Ces âmes enlevées que vous n'avez pas pu sauver ? Elles ont laissé derrière elles des familles, et une partie de votre paiement va à ces familles. Je suis sûr que vous comprenez.%SPEECH_OFF% | Vous trouvez %employer% en train de réorganiser une étagère de livres. Il semble réapprovisionner ses marchandises, comptant soigneusement et numérotant ses biens comme un commerçant. Il sursaute lorsque la porte claque derrière vous.%SPEECH_ON%Ah, mercenaire ! Vous m'avez fait peur là.%SPEECH_OFF%Il prend un coffre sur l'une des étagères et vous le remet.%SPEECH_ON%J'avais prévu de prendre tous ces livres, tous ces parchemins, et de m'enfuir. Maintenant, cependant, je n'en aurai pas besoin, et c'est tout grâce à vous.%SPEECH_OFF%Son sourire s'assombrit un instant.%SPEECH_ON%Tout le monde n'a pas eu la chance de voir ce jour. Les habitants m'ont raconté ce qui s'est passé, que les peaux-vertes ont kidnappé certains des nôtres et que vous ne pouviez pas les sauver. Les décevoir est compréhensible, mais je vous le dis maintenant, j'ai pris une partie de votre salaire pour aider ces familles survivantes.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Ce n'est que la moitié de ce que nous avions convenu ! | C'est comme ça...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Defended the town against greenskins");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% vous accueille à votre retour avec un sac plus léger que prévu. Il s'explique.%SPEECH_ON%Les environs ont été presque entièrement détruits et un grand nombre de personnes ont été enlevées. Je suis désolé, mercenaire, mais j'avais besoin de l'argent pour aider cette ville à se remettre. Vous pouvez me menacer si vous le souhaitez, mais c'est comme ça.%SPEECH_OFF%Vous décidez d'accepter les pertes et de passer à autre chose. | Vous trouvez %employer% inspectant la ville. Quelques feux brûlent le long des limites, émettant de la fumée noire dans le ciel. Des paysans fatigués avancent le long des routes. Ils portent ce qu'ils peuvent, certains portant d'autres pour leurs blessures sont horribles. %employer% fait un signe de tête devant la scène.%SPEECH_ON%Beaucoup de destruction, mercenaire. Vous et moi savons que je vous payais pour sauver la ville entière et assurer la sécurité de ses habitants. Rien de tout cela ne s'est vraiment produit, mais au moins nous sommes encore en train de discuter, donc vous recevrez toujours une partie de la récompense, comme promis.%SPEECH_OFF%Il vous remet un sac de couronnes. Il est effectivement plus léger que ce qui avait été convenu, mais pour l'avenir, vous ne discutez pas. | %employer% est là, regardant par la fenêtre. Il a une plume et un parchemin dans chaque main, prenant des notes ici et là. Il parle sans vous regarder.%SPEECH_ON%Eh bien, nous sommes vivants et bien portants, c'est bien. Ce qui n'est pas bien, ce sont ces feux qui ravagent la périphérie de la ville, les terribles nouvelles selon lesquelles les peaux-vertes ont enlevé certains des nôtres.%SPEECH_OFF%Enfin, il interrompt brièvement son écriture pour se tourner et vous fixer du regard.%SPEECH_ON%Votre paiement est dans le couloir. C'est moins que ce à quoi vous vous attendiez. Si vous voulez en discuter, je suis tout ouïe, et ne le serai que pour ça.%SPEECH_OFF%Vous réalisez qu'il serait inutile de discuter du salaire et prenez simplement ce que vous avez gagné.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Ce n'est que la moitié de ce que nous avions convenu ! | C'est comme ça...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(0);
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Lorsque vous entrez dans la pièce de %employer%, il vous dit de fermer la porte derrière vous. Juste au moment où le verrou clique, l'homme vous assaille avec un flot d'obscénités que vous ne pourriez pas espérer suivre. Se calmant, sa voix - et son langage - reviennent à un certain niveau de normalité.%SPEECH_ON%Toutes nos périphéries ont été détruites. À quoi, exactement, pensiez-vous que je vous payais? Dégagez d'ici.%SPEECH_OFF% | %employer% enfonce des gobelets de vin en arrière lorsque vous entrez. Il y a le tumulte de paysans en colère hurlant à l'extérieur de sa fenêtre.%SPEECH_ON%Entendez-vous ça? Ils auront ma tête si je vous paie, mercenaire. Vous aviez un travail, un seul ! Protéger cette ville. Et vous n'avez pas pu le faire. Alors maintenant, vous pourriez faire une chose correcte et gratuite : dégagez de ma vue.%SPEECH_OFF% | %employer% serre les mains sur son bureau.%SPEECH_ON%À quoi, exactement, vous attendez-vous à obtenir ici? Je suis surpris que vous soyez revenu vers moi tout court. La moitié de la ville est en feu et l'autre moitié est déjà de la cendre. Je ne vous ai pas embauché pour produire de la fumée et de la désolation, mercenaire. Dégagez d'ici.%SPEECH_OFF% | Lorsque vous retournez vers %employer%, il tient une chope de bière. Sa main tremble. Son visage est rouge.%SPEECH_ON%Il me faut tout pour ne pas te lancer ça en pleine figure en ce moment.%SPEECH_OFF%Au cas où, l'homme finit la boisson d'un seul coup. Il la claque sur son bureau.%SPEECH_ON%Cette ville comptait sur vous pour les protéger. Au lieu de cela, les peaux-vertes ont envahi les limites comme si elles faisaient une foutue sortie de loisir ! Je ne suis pas là pour offrir aux peaux-vertes un bon vieux moment en détruisant ma ville, mercenaire. Dégagez de foutre d'ici !%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Maudits paysans ! | Nous aurions dû demander plus de paiement à l'avance... | Maudit soit !}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to defend the town against greenskins");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% est introuvable. Un de ses gardes s'approche de vous.%SPEECH_ON%Si vous cherchez mon patron, vous feriez bien de laisser tomber. La moitié de cette ville est détruite et il est là-bas en train d'essayer de réparer ça.%SPEECH_OFF%Vous demandez votre paiement. L'homme éclate d'un rire triste et brutal.%SPEECH_ON%Paiement ? Désolé, épée à vendre. Il ne vous payait pas pour échouer. Et cet argent retourne directement dans la ville, de toute façon.%SPEECH_OFF% | Vous fouillez les terres brûlantes de %townname% à la recherche de %employer%. Il est là, tirant des corps noirs d'une ruine fumante qui était autrefois une maison. Lâchant un cadavre calciné à ses pieds, il vous fixe presque à travers.%SPEECH_ON%Qu'est-ce que tu veux, mercenaire ? J'espère que ce n'est pas de l'argent, parce que ce truc ici n'est pas ce pour quoi je vous payais.%SPEECH_OFF% | %employer% est là, fixant par la fenêtre. L'horizon entier est en flammes, comme s'il y avait deux soleils pour se coucher sur ce monde. Il secoue la tête en vous voyant.%SPEECH_ON%Que diable faites-vous ici ? Avons-nous convenu de vous payer pour laisser la ville partir en cendres ? Je ne pense pas, mercenaire. Dégagez d'ici.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Maudits paysans ! | Nous aurions dû demander plus de paiement à l'avance... | Maudit soit !}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to defend the town against greenskins");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/greenskins_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;

			if (this.m.Kidnapper != null && !this.m.Kidnapper.isNull())
			{
				this.m.Kidnapper.getSprite("selection").Visible = false;
			}

			if (this.m.Militia != null && !this.m.Militia.isNull())
			{
				this.m.Militia.getController().clearOrders();
			}

			this.World.getGuestRoster().clear();
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
		local nearestOrcs = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements());
		local nearestGoblins = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements());

		if (nearestOrcs.getTile().getDistanceTo(this.m.Home.getTile()) > 20 && nearestGoblins.getTile().getDistanceTo(this.m.Home.getTile()) > 20)
		{
			return false;
		}

		local locations = this.m.Home.getAttachedLocations();

		foreach( l in locations )
		{
			if (l.isUsable() && l.isActive() && !l.isMilitary())
			{
				return true;
			}
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.m.Flags.set("KidnapperID", this.m.Kidnapper != null && !this.m.Kidnapper.isNull() ? this.m.Kidnapper.getID() : 0);
		this.m.Flags.set("MilitiaID", this.m.Militia != null && !this.m.Militia.isNull() ? this.m.Militia.getID() : 0);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
		this.m.Kidnapper = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("KidnapperID")));
		this.m.Militia = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("MilitiaID")));
	}

});


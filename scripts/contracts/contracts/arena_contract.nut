this.arena_contract <- this.inherit("scripts/contracts/contract", {
	m = {},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = 1.0;
		this.m.Type = "contract.arena";
		this.m.Name = "L\'arène";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.setup();
		this.contract.start();
	}

	function setup()
	{
		this.m.Flags.set("Number", 0);
		local pay = 550;

		if (this.m.Home.hasSituation("situation.bread_and_games"))
		{
			pay = pay + 100;
		}

		local twists = [];

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsSwordmaster",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 2,
				F = "IsSwordmasterChampion",
				P = 150
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsHedgeKnight",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 2,
				F = "IsExecutionerChampion",
				P = 150
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsDesertDevil",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 2,
				F = "IsDesertDevilChampion",
				P = 150
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 5)
		{
			twists.push({
				R = 5,
				F = "IsMercenaries",
				P = 0
			});
		}

		if (this.Const.DLC.Unhold && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 6)
		{
			twists.push({
				R = 5,
				F = "IsUnholds",
				P = 100
			});
		}

		if (this.Const.DLC.Lindwurm && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
		{
			twists.push({
				R = 5,
				F = "IsLindwurm",
				P = 200
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 3)
		{
			twists.push({
				R = 5,
				F = "IsSandGolems",
				P = 50
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 3)
		{
			twists.push({
				R = 15,
				F = "IsGladiators",
				P = 0
			});
		}

		if (this.Const.DLC.Wildmen && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 15)
		{
			twists.push({
				R = 5,
				F = "IsGladiatorChampion",
				P = 150
			});
		}

		if (this.Const.DLC.Unhold && this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") <= 5)
		{
			twists.push({
				R = 10,
				F = "IsSpiders",
				P = -75
			});
		}

		if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") <= 3)
		{
			twists.push({
				R = 10,
				F = "IsHyenas",
				P = 0
			});
		}
		else
		{
			twists.push({
				R = 10,
				F = "IsFrenziedHyenas",
				P = 0
			});
		}

		twists.push({
			R = 10,
			F = "IsGhouls",
			P = 0
		});
		twists.push({
			R = 15,
			F = "IsDesertRaiders",
			P = 0
		});
		twists.push({
			R = 10,
			F = "IsSerpents",
			P = 0
		});
		local maxR = 0;

		foreach( t in twists )
		{
			maxR = maxR + t.R;
		}

		local r = this.Math.rand(1, maxR);

		foreach( t in twists )
		{
			if (r <= t.R)
			{
				this.m.Flags.set(t.F, true);
				pay = pay + t.P;
			}
			else
			{
				r = r - t.R;
			}
		}

		this.m.Payment.Pool = pay * this.getPaymentMult() * this.getReputationToPaymentMult();
		this.m.Payment.Completion = 1.0;
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Equiper trois de vos hommes avec des colliers d\'arène",
					"Entrer dans l\'arène et commencer le combat",
					"Ce combat sera à mort et vous ne pourrez vous retraiter ou récuperer de butin après."
				];
				this.Contract.m.BulletpointsPayment = [
					"Gagnez " + this.Contract.m.Payment.getOnCompletion() + " Couronnes pour votre victoire"
				];

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					this.Contract.m.BulletpointsPayment.push("Gagnez une pièce d\'équipement de Gladiateur");
				}

				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.Flags.set("Day", this.World.getTime().Days);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Flags.get("IsVictory"))
				{
					this.Contract.setScreen("Success");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.World.getTime().Days > this.Flags.get("Day"))
				{
					this.Contract.setScreen("Failure2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.set("IsFailure", true);
				}
			}

		});
	}

	function createScreens()
	{
		this.m.Screens.push({
			ID = "Task",
			Title = "À l\'arène",
			Text = "",
			Image = "",
			List = [],
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Nous allons rendre le sable rouge de sang ! | Je veux entendre la foule scander nos noms ! | Nous allons les abattre comme des agneaux !}",
					function getResult()
					{
						return "Overview";
					}

				},
				{
					Text = "{Ce n\'est pas ce que j\'avais en tête. | Je vais m\'asseoir sur cette affaire. | Je vais attendre le prochain combat.}",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						return 0;
					}

				}
			],
			function start()
			{
				this.Text = "[img]gfx/ui/events/event_155.png[/img]Des dizaines d\'hommes se déplacent à l\'entrée de l\'arène. Certains se tiennent stoïquement, ne souhaitant pas donner le moindre indice sur leurs capacités. D\'autres, en revanche, se vantent et se vantent avec aplomb, soit sont sincèrement confiants dans leurs compétences martiales, d\'autres espèrent que leur bravoure masque toute faille dans leur jeu.\n\n";
				this.Text += "Un homme grisonnant, le maître de l\'arène, brandit un parchemin et le tapote avec un crochet en guise de main.";
				local baseDifficulty = 30;

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					baseDifficulty = baseDifficulty + 10;
				}

				baseDifficulty = baseDifficulty * this.Contract.getScaledDifficultyMult();

				if (this.Flags.get("IsSwordmaster"))
				{
					if (baseDifficulty < this.Const.World.Spawn.Troops.Swordmaster.Cost + this.Const.World.Spawn.Troops.BanditRaider.Cost)
					{
						this.Flags.set("Number", 0);
						this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre un Maître d\'Armes";
					}
					else
					{
						this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, baseDifficulty - this.Const.World.Spawn.Troops.Swordmaster.Cost, 2));
						this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre un Maître d\'Armes et %amount% pillards";
					}

					this.Text += "%SPEECH_ON%Ils ont mis une étoile à côté de son nom, la marque du doreur. Cela signifie que son chemin est doré. Ce que vous devez savoir, c\'est qu\'il est un maître d\'armes. Vous pouvez trouver un certain réconfort dans le fait qu\'il soit un homme âgé, mais vous ne seriez pas le premier à qui je le dis, compris ? Que votre chemin soit aussi doré, car celui de ce maître d\'armes l\'était certainement.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsHedgeKnight"))
				{
					if (baseDifficulty < this.Const.World.Spawn.Troops.HedgeKnight.Cost + this.Const.World.Spawn.Troops.BanditRaider.Cost)
					{
						this.Flags.set("Number", 0);
						this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre un Chevalier Errant";
					}
					else
					{
						this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, baseDifficulty - this.Const.World.Spawn.Troops.HedgeKnight.Cost, 2));
						this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre un Chevalier Errant et %amount% pillards";
					}

					this.Text += "%SPEECH_ON%Je crois que les gens du nord l\'appellent un \"chevalier de la haine\". C\'est peut-être une erreur. Ne dites pas aux autres maîtres de l\'arène que j\'ai dit ça à propos des ordures du nord, mais ce chevalier est l\'un des hommes les plus dangereux que j\'ai vu passer ici et si vous souhaitez que votre chemin continue d\'être doré, je vous suggère de faire des préparations minutieuses et de bien vous reposer avant le combat.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertDevil"))
				{
					if (baseDifficulty < this.Const.World.Spawn.Troops.DesertDevil.Cost + this.Const.World.Spawn.Troops.NomadOutlaw.Cost)
					{
						this.Flags.set("Number", 0);
						this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre un Danseur de Lames";
					}
					else
					{
						this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty - this.Const.World.Spawn.Troops.DesertDevil.Cost, 2));
						this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre un Danseur de Lames et %amount% nomades";
					}

					this.Text += "Le maître d\'arène brandit un parchemin et le tapote avec un crochet en guise de main.%SPEECH_ON%Un danseur de lame des tribus nomades est sur la liste. Il a peut-être l\'air un peu prétentieux, mais pour obtenir le titre de \"danseur de lames\", il faut être aussi habile avec les lames qu\'un oiseau l\'est avec le vent. L\'expertise en danse est facultative, mais ils sont tous plutôt bons à ça aussi.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSandGolems"))
				{
					this.Flags.set("Number", this.Math.max(3, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.SandGolem, baseDifficulty, 3)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% ifrits";
					this.Text += "%SPEECH_ON%Il n\'y a rien de nouveau parce que je crains les foudres du désert si j\'ose éclairer sa présence la plus féroce. Tu te bats contre %number% d\'Ifrits. Je ne sais pas comment ils ont réussi à les amener ici, je sais juste que c\'est l\'oeuvre des alchimistes. Si tu veux mon avis, je préfère que ce soit vous qui les combattiez que moi.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGhouls"))
				{
					local num = 0;

					if (baseDifficulty >= this.Const.World.Spawn.Troops.GhoulHIGH.Cost * 2)
					{
						num = num + 1;
						num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty - this.Const.World.Spawn.Troops.GhoulHIGH.Cost);
					}
					else
					{
						num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.GhoulLOW, baseDifficulty * 0.5);
						num = num + this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty * 0.5);
					}

					this.Flags.set("Number", num);
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% nachzehrers";
					this.Text += "%SPEECH_ON%Les alchimistes les appellent, eh bien, je ne peux même pas le prononcer. Ma langue ne peut tout simplement pas s\'adapter au mot, car il nécessite une lexicographie nordique spécialisée et je n\'ai pas le temps de réduire le verbiage nordique à une question futile de minutie mondaine. Est-ce que je ressemble à un phonéticien pour vous ? Appelons-les simplement les \"gnashslashers\". Ce sont des crétins macabres, ils sont %number%, et je les ai vus manger des hommes vivants, alors vous feriez mieux d\'espérer que le dompteur regarde - je ne pense pas qu\'il ait de la lumière pour vous dans le ventre d\'une de ces bêtes !%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsUnholds"))
				{
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Unhold, baseDifficulty));

					if (this.Flags.get("Number") == 1)
					{
						this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commener le combat contre un unhold";
					}
					else
					{
						this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% unholds";
					}

					this.Text += "%SPEECH_ON%Vous êtes contre %number% de ce que la racaille nordique appelle un\'unhold.\' Le Vizir paie un bon paquet de couronnes pour les faire venir ici et les masses adorent ces bâtards géants. Ils font du bon travail en écrasant les combattants et, à l\'occasion, en projetant un guerrier dans la foule. C\'est tout à fait merveilleux. Je crois même que certains d\'entre eux apprennent à apprécier cela au fur et à mesure qu\'ils restent ici, comme s\'ils apprenaient ce qui incite la foule à applaudir ou à se moquer. La brutalité, c\'est autre chose. Quoi qu\'il en soit, que le doreur veille sur vous.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertRaiders"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% nomades";
					this.Text += "%SPEECH_ON%Vos adversaires seront %number% bandits du désert récemment mis à la retraite. Et par retraités, je veux dire capturés par les hommes de loi du Vizir, bien sûr. Aucun bandit ne veut mettre les pieds ici, haghaghagh!%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGladiators"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% gladiateurs";
					this.Text += "%SPEECH_ON%Bien, heh, le doreur doit avoir le sens de l\'humour. Vous allez affronter %number% gladiateurs. Que votre chemin soit toujours doré, mais pour être honnête, c\'est ce que j\'ai dit aux gladiateurs. Et je le leur ai dit tous les jours. Vous comprenez ? Vous devez vous préparer au mieux de vos capacités.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSpiders"))
				{
					this.Flags.set("Number", this.Math.max(3, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Spider, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% webknechts";
					this.Text += "%SPEECH_ON%Ce n\'est pas un figuier, c\'est une araignée. Les alchimistes, bénis soient leurs cœurs érudits, les appellent webknechts, ce qui est un nom nordique stupide, en vérité ce sont des araignées. Malheureusement pour vous, une botte ne suffira pas cette fois-ci pour %number% d\'entre elles.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSerpents"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Serpent, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% serpents";
					this.Text += "%SPEECH_ON%Comment ça, tu ne comprends pas ? Huh, c\'est juste une ligne sinueuse ? Non. Regarde, ça c\'est la queue, et ça c\'est la tête. C\'est un serpent. Tu te bats contre %number% serpents. \'Serpents\' Les alchimistes aiment les appeler \"serpents\", mais si je voulais dessiner un serpent, je dessinerais juste un alchimiste haghaghagh!%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsHyenas"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Hyena, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% hyènes";
					this.Text += "%SPEECH_ON%Hyènes. Heeheehee. Les hyènes. %numberC% cabots ricanants, pour être exact. Bonne chance, et que le doreur veille sur vous.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsFrenziedHyenas"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.HyenaHIGH, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% hyènas frénétique";
					this.Text += "%SPEECH_ON%Hyènes. Heeheehee. Les hyènes. %numberC% cabots ricanants, pour être exact. Bonne chance, et que le doreur veille sur vous.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsLindwurm"))
				{
					this.Flags.set("Number", this.Math.min(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Lindwurm, baseDifficulty - 30)));

					if (this.Flags.get("Number") == 1)
					{
						this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commener le combat contre un lindwurm";
					}
					else
					{
						this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre deux lindwurms";
					}

					this.Text += "%SPEECH_ON%Votre adversaire est un... un... qu\'est-ce que c\'est ? Un ver ? Il est vert. Je n\'ai jamais vu un ver de cette couleur... Oh ! Un wyrm ! Non, attendez, un wurm ! Wurm ? Un lindwurm ! Je dois être honnête avec vous, je ne sais pas ce que c\'est, mais j\'imagine que nos chers entremetteurs ne vous feront pas combattre un ver ordinaire. Ou peut-être que si. Peut-être qu\'ils vous feront juste manger pour nous divertir. Peut-être que ce ne sont pas des entremetteurs, mais des faiseurs de goût ! Herghgheeagghheeehoogh. Ha.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsMercenaries"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% mercenaires";
					this.Text += "%SPEECH_ON%Des couronnes comme les vôtres sont descendues du nord. Là-haut, on les appelle des \'sellswords.\' Hagh! Quelle sorte de tentative de poésie est-ce là ? Ils ne savent pas que tous les hommes ne se servent pas d\'une épée ? Ils ne sont pas les plus brillants là-haut. C\'est pour ça que j\'aime le sud. Le soleil est brillant, et donc nous aussi.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGladiatorChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Gladiator.NameList) + (this.Const.World.Spawn.Troops.Gladiator.TitleList != null ? " " + this.Const.World.Spawn.Troops.Gladiator.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Gladiator.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %champion1% et %amount% gladiateurs";
					this.Text += "%SPEECH_ON%Vous reconnaissez ce visage? Ce n\'est pas pour rien que les artistes ont passé du temps sur cette brochure et qu\'ils l\'ont distribuée à tous les spectateurs assis dans ces fauteuils à l\'étage. C\'est %champion1%,l\'un des plus grands combattants de ce pays. Peut-être qu\'un jour, ils te feront un joli visage également, si le Vizir te trouve assez talentueux pour sauver, ce que tu as entre les deux oreilles, hegheghegh.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSwordmasterChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Swordmaster.NameList) + (this.Const.World.Spawn.Troops.Swordmaster.TitleList != null ? " " + this.Const.World.Spawn.Troops.Swordmaster.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Swordmaster.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %champion1% et %amount% mercenaires";
					this.Text += "%SPEECH_ON%Vous reconnaissez ce visage? Ce n\'est pas pour rien que les artistes ont passé du temps sur cette brochure et qu\'ils l\'ont distribuée à tous les spectateurs assis dans ces fauteuils à l\'étage. C\'est %champion1%,l\'un des plus grands combattants de ce pays. Peut-être qu\'un jour, ils te feront un joli visage également, si le Vizir te trouve assez talentueux pour sauver, ce que tu as entre les deux oreilles, hegheghegh.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsExecutionerChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Executioner.NameList) + (this.Const.World.Spawn.Troops.Executioner.TitleList != null ? " " + this.Const.World.Spawn.Troops.Executioner.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Executioner.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %champion1% and %amount% gladiateurs";
					this.Text += "%SPEECH_ON%Vous reconnaissez ce visage? Ce n\'est pas pour rien que les artistes ont passé du temps sur cette brochure et qu\'ils l\'ont distribuée à tous les spectateurs assis dans ces fauteuils à l\'étage. C\'est %champion1%,l\'un des plus grands combattants de ce pays. Peut-être qu\'un jour, ils te feront un joli visage également, si le Vizir te trouve assez talentueux pour sauver, ce que tu as entre les deux oreilles, hegheghegh.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertDevilChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.DesertDevil.NameList) + (this.Const.World.Spawn.Troops.DesertDevil.TitleList != null ? " " + this.Const.World.Spawn.Troops.DesertDevil.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.DesertDevil.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %champion1% and %amount% nomades";
					this.Text += "%SPEECH_ON%Vous reconnaissez ce visage? Ce n\'est pas pour rien que les artistes ont passé du temps sur cette brochure et qu\'ils l\'ont distribuée à tous les spectateurs assis dans ces fauteuils à l\'étage. C\'est %champion1%,l\'un des plus grands combattants de ce pays. Peut-être qu\'un jour, ils te feront un joli visage également, si le Vizir te trouve assez talentueux pour sauver, ce que tu as entre les deux oreilles, hegheghegh.%SPEECH_OFF%";
				}

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					this.Text += "Il marque une pause.%SPEECH_ON%Nous attendons des invités importants pour ce combat, alors tout est prévu pour que vous mourriez de façon sanglante cette fois-ci, compris ? Et si vous n\'y arrivez pas, faites en sorte que votre équipe élimine ses adversaires de la manière la plus spectaculaire qui soit pour plaire à la foule. Faites-le, et je vous remettrai une pièce d\'équipement de gladiateur en plus des couronnes.%SPEECH_OFF%";
				}

				this.Text += "Il montre d\'étranges colliers et continue.%SPEECH_ON%Quand vous serez prêts, mettez-les aux trois hommes qui se battront. Cela nous permettra de savoir qui emmener dans les fosses. Quiconque ne porte pas ces colliers ne sera pas autorisé à entrer, ni vous, ni le vizir, si j\'ose dire, même le doreur pourrait être refusé.%SPEECH_OFF%";
			}

		});
		this.m.Screens.push({
			ID = "Overview",
			Title = "Overview",
			Text = "Cette arène fonctionne comme cela. Acceptez-vous les conditions ?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "J\'accepte.",
					function getResult()
					{
						this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
						this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
						this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
						this.Contract.setState("Running");
						return 0;
					}

				},
				{
					Text = "Je vais devoir y réfléchir.",
					function getResult()
					{
						return 0;
					}

				}
			],
			ShowObjectives = true,
			ShowPayment = true,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}

		});
		this.m.Screens.push({
			ID = "Start",
			Title = "À l\'arène",
			Text = "[img]gfx/ui/events/event_155.png[/img]{Pendant que vous attendez votre tour, la soif de sang de la foule se faufile dans l\'obscurité, des nappes de poussière tombent d\'en haut, les piétinements sont tonitruants. Ils murmurent dans l\'attente et rugissent lors de la mise à mort. Le silence entre les batailles ne dure que quelques instants, et il est rompu lorsque la porte rouillée se soulève, les chaînes s\'entrechoquent et la foule s\'agite à nouveau. Vous sortez dans la lumière et votre cœur bat si fort qu\'il pourrait sûrement faire avancer un homme mort... | La foule de l\'arène est épaule contre épaule, la plupart étant complètement ivres. Ils crient et hurlent, leurs langues sont un mélange de langues locales et étrangères, mais l\'appel à leur soif de sang n\'a pas besoin d\'être formulé au-delà de leurs visages enragés et de leurs poings battants. Maintenant, les hommes de %companyname% vont rassasier ces fous furieux... | Les nettoyeurs se pressent dans l\'arène. Ils emportent les corps, ramassent ce qui en vaut la peine et lancent parfois un trophée dans la foule, provoquant ainsi une reproduction des batailles de l\'arène dans les tribunes. %companyname% fait désormais partie de cette affaire. | L\'arène attend, la foule s\'enflamme, et le tour de gloire de %companyname% est arrivé! | La foule est en ébullition lorsque les hommes de %companyname% s\'avancent dans la fosse sanglante. La foule est en ébullition lorsque les hommes de %companyname% s\'avancent dans la fosse sanglante. Malgré la soif de sang des gens, vous ne pouvez vous empêcher de ressentir une certaine fierté dans votre poitrine, sachant que c\'est votre compagnie qui est prête à faire le spectacle. | La porte se lève. On n\'entend rien d\'autre que le cliquetis des chaînes, le grincement des poulies et les grognements des esclaves au travail. Lorsque les hommes de %companyname% sortent des entrailles de l\'arène. Ils entendent le sable crisser sous leurs pieds jusqu\'à ce qu\'ils se retrouvent au centre de la fosse. Une voix étrange hurle depuis le haut du stade, dans une langue inconnue, mais les mots ne résonnent qu\'une seule fois avant que la foule n\'éclate en acclamations et en rugissements. Le moment est venu pour vos hommes de faire leurs preuves devant l\'œil attentif du peuple. | Les affaires de %companyname% est rarement fait sous les yeux de ceux qui préfèrent se tenir à l\'écart de cette violence. Mais dans l\'arène, le vulgaire attend avec avidité la mort et la souffrance, et il grogne de soif de sang lorsque vos hommes entrent dans les fosses, et rugit lorsque les vendeurs dégainent leurs armes et se préparent au combat. | L\'arène a la forme d\'un gouffre, dont le plafond a été arraché par les dieux, révélant la vanité, la soif de sang et la sauvagerie de l\'homme. Et ce sont les hommes qui sont là, hurlant et criant, et si les jets de sang les atteignent, ils se lavent le visage dans le sang et se sourient les uns aux autres comme s\'il s\'agissait d\'une plaisanterie. Ils se battent pour des trophées et se délectent de la douleur des autres. C\'est devant ces peuples que %companyname% L\'arène a la forme d\'un gouffre, dont le plafond a été arraché par les dieux, révélant la vanité, la soif de sang et la sauvagerie de l\'homme. Et ce sont les hommes qui sont là, hurlant et criant, et si les jets de sang les atteignent, ils se lavent le visage dans le sang et se sourient les uns aux autres comme s\'il s\'agissait d\'une plaisanterie. Ils se battent pour des trophées et se délectent de la douleur des autres. C\'est devant ces peuples que les %companyname% se battront, et c\'est pour eux qu\'ils s\'amuseront et s\'amuseront bien. |  La foule de l\'arène est un mélange de classes, de riches et de pauvres, car seuls les vizirs se répartissent en plusieurs postes. Brièvement unifiés, les habitants de %townname% se sont gracieusement rassemblés pour regarder des hommes et des monstres s\'assassiner les uns les autres. C\'est avec plaisir que %companyname%  cherche à faire sa part. | Des garçons assis sur les épaules de leurs pères, des jeunes filles jetant des fleurs aux gladiateurs, des femmes s\'éventant, des hommes se demandant s\'ils en sont capables. Ce sont les gens de l\'arène - et les autres sont tous complètement ivres et crient des bêtises. Vous espérez que %companyname% pourra contribuer au moins une heure ou deux à divertir ces fous. | La foule rugit lorsque les hommes de %companyname% entrent dans la fosse. Il serait stupide de confondre excitation et désir, car dès que les applaudissements se terminent, les chopes de bière vides et les tomates pourries s\'éparpillent, tandis que les spectateurs s\'esclaffent de plaisir. Vous vous demandez si les hommes de %companyname% sont vraiment mieux utilisés ici, mais vous pensez ensuite à l\'or et à la gloire à gagner, et au fait qu\'à la fin de la journée, ces bâtards dans les gradins rentreront chez eux dans leur vie de merde, et vous rentrerez chez vous dans votre vie de merde aussi, mais au moins vos poches seront un peu plus profondes.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Donnons à la foule une raison d\'applaudir !",
					function getResult()
					{
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.arena_floor";
						p.Music = this.Const.Music.ArenaTracks;
						p.Ambience[0] = this.Const.SoundAmbience.ArenaBack;
						p.Ambience[1] = this.Const.SoundAmbience.ArenaFront;
						p.AmbienceMinDelay[0] = 0;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsUsingSetPlayers = true;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = true;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = true;
						p.IsAutoAssigningBases = false;
						local bros = this.Contract.getBros();

						for( local i = 0; i < bros.len() && i < 3; i = ++i )
						{
							p.Players.push(bros[i]);
						}

						p.Entities = [];
						local baseDifficulty = 30;

						if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
						{
							baseDifficulty = baseDifficulty + 10;
						}

						baseDifficulty = baseDifficulty * this.Contract.getScaledDifficultyMult();

						if (this.Flags.get("IsSwordmaster"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Swordmaster);

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.BanditRaider);
							}
						}
						else if (this.Flags.get("IsHedgeKnight"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.HedgeKnight);

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.BanditRaider);
							}
						}
						else if (this.Flags.get("IsDesertDevil"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.DesertDevil);

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
							}
						}
						else if (this.Flags.get("IsSandGolems"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.SandGolem);
							}
						}
						else if (this.Flags.get("IsGhouls"))
						{
							if (baseDifficulty >= this.Const.World.Spawn.Troops.GhoulHIGH.Cost * 2)
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.GhoulHIGH);

								for( local i = 0; i < this.Flags.get("Number") - 1; i = ++i )
								{
									this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Ghoul);
								}
							}
							else
							{
								for( local i = 0; i < this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.GhoulLOW, baseDifficulty * 0.5); i = ++i )
								{
									this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.GhoulLOW);
								}

								for( local i = 0; i < this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Ghoul, baseDifficulty * 0.5); i = ++i )
								{
									this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Ghoul);
								}
							}
						}
						else if (this.Flags.get("IsUnholds"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Unhold);
							}
						}
						else if (this.Flags.get("IsDesertRaiders"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
							}
						}
						else if (this.Flags.get("IsGladiators"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
							}
						}
						else if (this.Flags.get("IsSpiders"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Spider);
							}
						}
						else if (this.Flags.get("IsSerpents"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Serpent);
							}
						}
						else if (this.Flags.get("IsHyenas"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Hyena);
							}
						}
						else if (this.Flags.get("IsFrenziedHyenas"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.HyenaHIGH);
							}
						}
						else if (this.Flags.get("IsLindwurm"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Lindwurm);
							}
						}
						else if (this.Flags.get("IsMercenaries"))
						{
							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Mercenary);
							}
						}
						else if (this.Flags.get("IsGladiatorChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
							}
						}
						else if (this.Flags.get("IsSwordmasterChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Swordmaster, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Mercenary);
							}
						}
						else if (this.Flags.get("IsExecutionerChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Executioner, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.Gladiator);
							}
						}
						else if (this.Flags.get("IsDesertDevilChampion"))
						{
							this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.DesertDevil, true, this.Flags.get("Champion1"));

							for( local i = 0; i < this.Flags.get("Number"); i = ++i )
							{
								this.Contract.addToCombat(p.Entities, this.Const.World.Spawn.Troops.NomadOutlaw);
							}
						}

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- this.Contract.getFaction();
						}

						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				},
				{
					Text = "On ne va pas faire ça. Je ne veux pas mourir !",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnArenaCancel);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À l\'arène",
			Text = "[img]gfx/ui/events/event_147.png[/img]{Le maître de cérémonie parle comme s\'il ne se souvenait pas de votre visage, mais il ne s\'en souvient probablement pas.%SPEECH_ON%Voici votre dû, n\'hésitez pas à revenir.%SPEECH_OFF%L\'arène sera fermée pour la journée, mais vous pourrez revenir dès demain. | Sans même lever la tête d\'un chiffon de papyrus, le maître de l\'arène vous lance une bourse de pièces.%SPEECH_ON%J\'ai entendu la foule, et voici donc vos couronnes. Puissiez-vous venir visiter les fosses à nouveau.%SPEECH_OFF%L\'arène sera fermée pour la journée, mais vous pourrez revenir dès demain. | Le maître de l\'arène vous attend.%SPEECH_ON%C\'était un très bon spectacle, mon gars. Ça ne me dérangerait pas le moins du monde que vous reveniez.%SPEECH_OFF%L\'arène sera fermée pour la journée, mais vous pourrez revenir dès demain.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "{Victoire! | N\'êtes vous pas assez divertis ? | On l\'a tué. | Un spectacle sanglant.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());

						if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
						{
							return "Gladiators";
						}
						else
						{
							this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
							this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);
							this.World.Statistics.getFlags().increment("ArenaRegularFightsWon", 1);
							this.World.Contracts.finishActiveContract();

							if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
							{
								this.updateAchievement("Gladiator", 1, 1);
							}

							return 0;
						}
					}

				}
			],
			function start()
			{
				local roster = this.World.getPlayerRoster().getAll();
				local n = 0;

				foreach( bro in roster )
				{
					local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

					if (item != null && item.getID() == "accessory.arena_collar")
					{
						local skill;
						bro.getFlags().increment("ArenaFightsWon", 1);
						bro.getFlags().increment("ArenaFights", 1);

						if (bro.getFlags().getAsInt("ArenaFightsWon") == 1)
						{
							skill = this.new("scripts/skills/traits/arena_pit_fighter_trait");
							bro.getSkills().add(skill);
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + " est maintenant " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}
						else if (bro.getFlags().getAsInt("ArenaFightsWon") == 5)
						{
							bro.getSkills().removeByID("trait.pit_fighter");
							skill = this.new("scripts/skills/traits/arena_fighter_trait");
							bro.getSkills().add(skill);
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + " est maintenant " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}
						else if (bro.getFlags().getAsInt("ArenaFightsWon") == 12)
						{
							bro.getSkills().removeByID("trait.arena_fighter");
							skill = this.new("scripts/skills/traits/arena_veteran_trait");
							bro.getSkills().add(skill);
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + " est maintenant " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}

						n = ++n;
					}

					if (n >= 3)
					{
						break;
					}
				}

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					local r;
					local a;
					local u;

					if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 5)
					{
						r = 1;
					}
					else if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 10)
					{
						r = 3;
					}
					else if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") == 15)
					{
						r = 2;
					}
					else
					{
						r = this.Math.rand(1, 3);
					}

					switch(r)
					{
					case 1:
						a = this.new("scripts/items/armor/oriental/gladiator_harness");
						u = this.new("scripts/items/armor_upgrades/light_gladiator_upgrade");
						a.setUpgrade(u);
						this.List.push({
							id = 12,
							icon = "ui/items/armor_upgrades/upgrade_24.png",
							text = "Vous recevez a " + a.getName()
						});
						break;

					case 2:
						a = this.new("scripts/items/armor/oriental/gladiator_harness");
						u = this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade");
						a.setUpgrade(u);
						this.List.push({
							id = 12,
							icon = "ui/items/armor_upgrades/upgrade_25.png",
							text = "Vous recevez a " + a.getName()
						});
						break;

					case 3:
						a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
						this.List.push({
							id = 12,
							icon = "ui/items/" + a.getIcon(),
							text = "Vous recevez a " + a.getName()
						});
						break;
					}

					this.World.Assets.getStash().makeEmptySlots(1);
					this.World.Assets.getStash().add(a);
				}
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "À l\'arène",
			Text = "[img]gfx/ui/events/event_147.png[/img]{Les hommes de %companyname% ont été vaincus, morts ou, peut-être pire, mutilés. Au moins, les foules sont heureuses. Dans les stands, toute démonstration, même celle qui se termine par une défaite, est une bonne démonstration.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Quel Désastre!",
					function getResult()
					{
						local roster = this.World.getPlayerRoster().getAll();
						local n = 0;

						foreach( bro in roster )
						{
							local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

							if (item != null && item.getID() == "accessory.arena_collar")
							{
								bro.getFlags().increment("ArenaFights", 1);
								n = ++n;
							}

							if (n >= 3)
							{
								break;
							}
						}

						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "À l\'arène",
			Text = "{[img]gfx/ui/events/event_155.png[/img]L\'heure de votre match d\'arène est arrivée et passée, mais vous ne vous y êtes pas présentés. Peut-être que quelque chose de plus important s\'est présenté, ou peut-être que vous vous êtes simplement cachés comme des lâches. Dans tous les cas, votre réputation en pâtira.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Mais...",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Collars",
			Title = "À l\'arène",
			Text = "{[img]gfx/ui/events/event_155.png[/img]L\'heure de votre match d\'arène a sonné, mais aucun de vos hommes ne porte le collier d\'arène et ils ne sont donc pas autorisés à entrer.\n\nVous devez décider qui va combattre en les équipant des colliers d\'arène qui vous ont été donnés, et le match commencera dès que vous serez de nouveau dans l\'arène.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Oh, c\'est vrai!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Gladiators",
			Title = "À l\'arène",
			Text = "{[img]gfx/ui/events/event_85.png[/img]Le combat terminé, vous trouvez quelques femmes qui se promènent vers vous et les gladiateurs. Elles sont pratiquement en pâmoison, les visages rougis, et les hommes s\'occupent particulièrement d\'elles. Un peu fatigué vous-même, vous demandez à l\'un des fans de vous aider à compter l\'inventaire. | [img]gfx/ui/events/event_147.png[/img]La bataille est terminée, mais une ombre traverse soudainement le sol. En un éclair, vous dégainez et fendez le ciel. Des pétales de fleurs arrosent votre corps scintillant et vous attrapez le reste du bouquet entre vos dents. Une femme se tient là, s\'éventant.%SPEECH_ON%Je me demandais pourquoi vous ne vous étiez pas battus.%SPEECH_OFF%Dit-elle. Vous rengainez votre lame et attachez le bouquet à votre ceinture. Vous lui dites que si vous vous battiez, ce ne sera pas du tout un \"combat\". La femme a les genoux fragiles et trouve du réconfort sur le sol. Avant de partir, vous lui dites de boire beaucoup d\'eau et de s\'étirer le matin. | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%Puis-je apprendre à me battre comme vous, les hommes ?%SPEECH_OFF%Les voix vous prennent au dépourvu et avant que vous ne le sachiez, vous avez votre lame à quelques centimètres du visage d\'un petit garçon. Ses yeux sont fermés, et il en ouvre lentement un. Vous rengainez l\'épée et riez.%SPEECH_ON%Non. Ce que je fais ne peut pas être appris.%SPEECH_OFF%Vous utilisez un peu de cendre et de sang du champ pour signer la chemise du gamin, puis vous partez. | %SPEECH_START%Êtes-vous... êtes-vous des gladiateurs ?%SPEECH_OFF%Vous regardez pour voir un garçon qui se tient là, l\'étonnement sur son visage. Il pleure presque, tellement il est content.%SPEECH_ON%Vous êtes incroyable!%SPEECH_OFF%Touchant les cheveux du garçon, vous lui dites merci et vous partez. | [img]gfx/ui/events/event_97.png[/img]%SPEECH_START%Comment êtes-vous devenu si bon ?%SPEECH_OFF%Vous vous retournez pour voir un garçon qui vous regarde nerveusement. En souriant, vous lui dites la vérité.%SPEECH_ON%Quand j\'avais ton âge, je tuais des hommes de mon âge.%SPEECH_OFF%En souriant, il demande si, en y travaillant, il peut être comme vous. Vous répondez en hochant la tête.%SPEECH_ON%Tu ne peux pas savoir avant d\'avoir essayé, petit. Maintenant, rentre à la maison.%SPEECH_OFF%Le garçon brandit un couteau à beurre et se retourne diaboliquement pour s\'enfuir en courant. C\'est un bon garçon.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "{Putain, on est bon. | On est les meilleurs.}",
					function getResult()
					{
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);
						this.World.Statistics.getFlags().increment("ArenaRegularFightsWon", 1);
						this.World.Contracts.finishActiveContract();

						if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
						{
							this.updateAchievement("Gladiator", 1, 1);
						}

						return 0;
					}

				}
			]
		});
	}

	function getBros()
	{
		local ret = [];
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.arena_collar")
			{
				ret.push(bro);
			}
		}

		return ret;
	}

	function getAmountToSpawn( _type, _resources, _min = 1, _max = 24 )
	{
		return this.Math.min(_max, this.Math.max(_min, _resources / _type.Cost));
	}

	function addToCombat( _list, _entityType, _champion = false, _name = "" )
	{
		local c = clone _entityType;

		if (c.Variant != 0 && _champion)
		{
			c.Variant = 1;
			c.Name <- _name;
		}
		else
		{
			c.Variant = 0;
		}

		_list.push(c);
	}

	function getScaledDifficultyMult()
	{
		local p = this.World.State.getPlayer().getStrength();
		p = p / this.World.getPlayerRoster().getSize();
		p = p * 12;
		local s = this.Math.maxf(0.75, 1.0 * this.Math.pow(0.01 * p, 0.95) + this.Math.minf(0.5, (this.World.getTime().Days + this.World.Statistics.getFlags().getAsInt("ArenaFightsWon")) * 0.01));
		local d = this.Math.minf(5.0, s);
		return d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
	}

	function getReputationToPaymentMult()
	{
		local r = this.Math.minf(4.0, this.Math.maxf(0.9, this.Math.pow(this.Math.maxf(0, 0.003 * this.World.Assets.getBusinessReputation() * 0.5 + this.getScaledDifficultyMult()), 0.35)));
		return r * this.Const.Difficulty.PaymentMult[this.World.Assets.getEconomicDifficulty()];
	}

	function setScreenForArena()
	{
		if (!this.m.IsActive)
		{
			return;
		}

		if (this.getBros().len() == 0)
		{
			this.setScreen("Collars");
		}
		else if (this.World.getTime().Days > this.m.Flags.get("Day"))
		{
			this.setScreen("Failure2");
		}
		else
		{
			this.setScreen("Start");
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"numberC",
			this.m.Flags.get("Number") < this.Const.Strings.AmountC.len() ? this.Const.Strings.AmountC[this.m.Flags.get("Number")] : this.Const.Strings.AmountC[this.m.Flags.get("Number")]
		]);
		_vars.push([
			"number",
			this.m.Flags.get("Number") < this.Const.Strings.Amount.len() ? this.Const.Strings.Amount[this.m.Flags.get("Number")] : this.Const.Strings.Amount[this.m.Flags.get("Number")]
		]);
		_vars.push([
			"amount",
			this.m.Flags.get("Number")
		]);
		_vars.push([
			"champion1",
			this.m.Flags.get("Champion1")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Home.getSprite("selection").Visible = false;
			this.m.Home.getBuilding("building.arena").refreshCooldown();
			local roster = this.World.getPlayerRoster().getAll();

			foreach( bro in roster )
			{
				local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

				if (item != null && item.getID() == "accessory.arena_collar")
				{
					bro.getItems().unequip(item);
				}
			}

			local items = this.World.Assets.getStash().getItems();

			foreach( i, item in items )
			{
				if (item != null && item.getID() == "accessory.arena_collar")
				{
					items[i] = null;
				}
			}
		}
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
	}

});


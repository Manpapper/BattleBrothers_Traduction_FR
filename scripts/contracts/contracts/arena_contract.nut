this.arena_contract <- this.inherit("scripts/contracts/contract", {
	m = {},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = 1.0;
		this.m.Type = "contract.arena";
		this.m.Name = "L'arène";
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
			Title = "À l'arène",
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
					Text = "{This isn\'t what I had in mind. | I\'ll sit this one out. | I\'ll wait for the next fight.}",
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

					this.Text += "%SPEECH_ON%You\'re against %number% of what the northern scum refer to as an \'unhold.\' The Vizier pays a proper pile of coin to get them here, and the masses love the giant bastards. They do a good job smashing fighters and, on occasion, heaving a warrior clear into the crowds. It\'s quite wonderful. I think some of the unholds even learn to enjoy it the longer they stay here, like they learn what spurs the mob to cheers and jeer. The brutality is something else. Anyway, may the Gilder watch over you.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertRaiders"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% nomades";
					this.Text += "%SPEECH_ON%Your opponents will be %number% recently retired desert bandits. And by retired, I mean taken by the Vizier\'s lawmen, of course. No bandit willingly steps foot in here, haghaghagh!%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGladiators"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% gladiateurs";
					this.Text += "%SPEECH_ON%Well, heh, the Gilder must have a sense of humor. You\'ll be facing %number% gladiators. May your path be ever Gilded, but to be honest, I said that to the gladiators. And I\'ve been saying it to them every day. Understand? You should prepare to the best of your abilities.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSpiders"))
				{
					this.Flags.set("Number", this.Math.max(3, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Spider, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% webknechts";
					this.Text += "%SPEECH_ON%That is not a fig tree, it\'s a spider. The alchemists, bless their learned hearts, call them webknechts which is a silly northern name, in truth they\'re spiders. Unfortunately for you a boot will not be sufficient this time around for %number% of them.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSerpents"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Serpent, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% serpents";
					this.Text += "%SPEECH_ON%What do you mean you don\'t understand? Huh, it\'s just a squiggly line? No. Look, this is its tail, and that\'s the head. It\'s a snake. You\'re fighting %number% snakes. \'Serpents\' the alchemists like to call them, but if I wanted to draw a serpent I\'d just draw an alchemist haghaghagh!%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsHyenas"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Hyena, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% hyènes";
					this.Text += "%SPEECH_ON%Hyenas. Heeheehee. Hyenas. %numberC% of the giggling mutts, to be exact. Good luck, and may the Gilder watch over you.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsFrenziedHyenas"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.HyenaHIGH, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% hyènas frénétique";
					this.Text += "%SPEECH_ON%Hyenas. Heeheehee. Hyenas. %numberC% of the giggling mutts, to be exact. Good luck, and may the Gilder watch over you.%SPEECH_OFF%";
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

					this.Text += "%SPEECH_ON%Your opponent is a... a... what is this? A worm? It\'s green. Never seen a worm that col- oh! A wyrm! No wait, \'wurm.\' Wurm? A lindwurm! I gots\'ta be honest with ya, I don\'t know what the hell this is, but I imagine our dear matchmakers won\'t be having you fightin\' a worm of the regular sort. Or maybe they is. Maybe they\'ll just have ye eat it for our entertainment. Maybe they ain\'t matchmakers, but tastemakers! Herghgheeagghheeehoogh. Ha.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsMercenaries"))
				{
					this.Flags.set("Number", this.Math.max(2, this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty)));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %amount% mercenaires";
					this.Text += "%SPEECH_ON%Crownlings like you have ventured down from the north. Up there, they call them \'sellswords.\' Hagh! What sort of attempt at poetry is that? Don\'t they know not every man even uses a sword? They ain\'t the brightest up there. That\'s why I like it in the south. The sun is bright, and thus so are we.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsGladiatorChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Gladiator.NameList) + (this.Const.World.Spawn.Troops.Gladiator.TitleList != null ? " " + this.Const.World.Spawn.Troops.Gladiator.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Gladiator.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %champion1% et %amount% gladiateurs";
					this.Text += "%SPEECH_ON%Recognize this face? There\'s a reason the artists spent time on this here pamphlet and then handed them out to every set of eyes settin\' in those seats upstairs. It\'s %champion1%, one of the greatest fighters in this land. Maybe some day they\'ll make yer face look so pretty, if the Vizier could ever find someone so talented to salvage, well, whatever ye got there between the ears, hegheghegh.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsSwordmasterChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Swordmaster.NameList) + (this.Const.World.Spawn.Troops.Swordmaster.TitleList != null ? " " + this.Const.World.Spawn.Troops.Swordmaster.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Swordmaster.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %champion1% et %amount% mercenaires";
					this.Text += "%SPEECH_ON%Recognize this face? There\'s a reason the artists spent time on this here pamphlet and then handed them out to every set of eyes settin\' in those seats upstairs. It\'s %champion1%, one of the greatest fighters in this land. Maybe some day they\'ll make yer face look so pretty, if the Vizier could ever find someone so talented to salvage, well, whatever ye got there between the ears, hegheghegh.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsExecutionerChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.Executioner.NameList) + (this.Const.World.Spawn.Troops.Executioner.TitleList != null ? " " + this.Const.World.Spawn.Troops.Executioner.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.Executioner.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %champion1% and %amount% gladiateurs";
					this.Text += "%SPEECH_ON%Recognize this face? There\'s a reason the artists spent time on this here pamphlet and then handed them out to every set of eyes settin\' in those seats upstairs. It\'s %champion1%, one of the greatest fighters in this land. Maybe some day they\'ll make yer face look so pretty, if the Vizier could ever find someone so talented to salvage, well, whatever ye got there between the ears, hegheghegh.%SPEECH_OFF%";
				}
				else if (this.Flags.get("IsDesertDevilChampion"))
				{
					this.Flags.set("Champion1", this.Const.World.Common.generateName(this.Const.World.Spawn.Troops.DesertDevil.NameList) + (this.Const.World.Spawn.Troops.DesertDevil.TitleList != null ? " " + this.Const.World.Spawn.Troops.DesertDevil.TitleList[this.Math.rand(0, this.Const.World.Spawn.Troops.DesertDevil.TitleList.len() - 1)] : ""));
					this.Flags.set("Number", this.Contract.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, baseDifficulty - this.Const.World.Spawn.Troops.Gladiator.Cost * 2, 2));
					this.Contract.m.BulletpointsObjectives[1] = "Entrer dans l\'arène de nouveau pour commencer le combat contre %champion1% and %amount% nomades";
					this.Text += "%SPEECH_ON%Recognize this face? There\'s a reason the artists spent time on this here pamphlet and then handed them out to every set of eyes settin\' in those seats upstairs. It\'s %champion1%, one of the greatest fighters in this land. Maybe some day they\'ll make yer face look so pretty, if the Vizier could ever find someone so talented to salvage, well, whatever ye got there between the ears, hegheghegh.%SPEECH_OFF%";
				}

				if (this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") > 0 && this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon") % 5 == 0)
				{
					this.Text += "He pauses.%SPEECH_ON%We expect important guests for this bout, so everything is set up for you to die proper bloody this time, got it? And if you can\'t do that, then have your lot dispatch their opponents in the most spectacular way to please the crowd. Do that, and I\'ll hand you a proper piece of gladiator gear ontop of the coin.%SPEECH_OFF%";
				}

				this.Text += "He points to some strange looking collars and continues.%SPEECH_ON%When you\'re ready, put these on the three men who\'ll be doing the fighting. This lets us know who to take into the pits. Anyone not wearing these will not be allowed in, not you, not the Vizier, dare I say even the Gilder may be turned down.%SPEECH_OFF%";
			}

		});
		this.m.Screens.push({
			ID = "Overview",
			Title = "Overview",
			Text = "Cette d'arène fonctionne comme cela. Acceptez-vous les conditions ?",
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
			Title = "À l'arène",
			Text = "[img]gfx/ui/events/event_155.png[/img]{As you wait your turn, the crowd\'s bloodlust crawls through the dark, sheets of dust falling from above, the stomps of feet thunderous. They murmur in anticipation, and roar at killings. The quiet between battles is mere moments, and this silence is snatched away as the rusted gate lurches upward, chains rankling, the crowd abuzz once more. You step out into the light and so thunderous is the noise against your heart it could surely yet spur a dead man forth... | The arena\'s crowd is shoulder to shoulder, most blathering drunk. They scream and shout, their languages a mix of local and foreign, though the appeal to their bloodlust needs little articulation beyond their maddened faces and pumping fists. Now, the %companyname%\'s men will satiate these mad fools... | Cleaners hurry about the arena. They drag away the bodies, collect what\'s worth collecting, and occasionally throw a trophy into the crowds, eliciting a moblike rendition of the arena\'s battles in the stands themselves. The %companyname% is now a part of this affair. | The arena awaits, the crowd alight, and the %companyname%\'s turn to gain glory is at hand! | The crowd booms as the %companyname%\'s men stride into its bloody pit. Despite the mindless bloodlust of the peoples, you can\'t help but feel a beat of pride in your chest, knowing that it is your company ready to put on a show. | The gate rises. Nothing is heard save the rattle of chains, the creak of pulleys, the grunts of slaves at work. When the men of the %companyname% step out of the arena\'s bowels they can hear the crunch of sand underfoot until they come to stand in the center of the pit. A strange voice screams from the tops of the stadium, some lost language beyond your knowing, but the words echo just once before the crowd erupts with cheers and roaring. Now is the time your men shall prove themselves before the watchful eye of the commoner. | The %companyname%\'s business is rarely done before the eyes of those who would prefer themselves distantly separated from such violence. But in the arena, the commoner greedily awaits death and suffering, and it growls with bloodlust as your men enter the pits, and roars as the sellswords draw their weapons and ready for battle. | The arena is shaped like the pit of some sore, its ceiling torn away by the gods, revealing the vanity, bloodlust, and savagery of man. And it is man there, yelling and screaming, and if the blood sprays hit them, they wash their faces in the gore and grin at one another as though it were a joke. They fight one another for trophies and relish in the pain of others. And it is before these peoples that the %companyname% will fight, and for them they shall entertain and entertain well. | The arena\'s crowd is a mash of classes, rich and poor, for only the Viziers separate themselves out into stations above all. Briefly unified, the peoples of %townname% have graciously come together to watch men and monsters murder one another. With pleasure, the %companyname% seeks to do its part. | Boys sitting on the shoulders of fathers, young girls throwing flowers to the gladiators, women fanning themselves, men wondering if they could do it. These are the peoples of the arena - and the rest are all drunk out of their gourd and screaming nonsense. You hope the %companyname% can contribute to at least an hour or two to entertaining this mad lot. | The crowd roars as the %companyname%\'s men step into the pit. One would be dumb to confuse excitement for desire, for as soon as the applause ends there is a smattering of empty beer mugs and rotten tomatoes and the general giggling delight of those watching the matter. You wonder if the %companyname%\'s men are really best spent here, but then think hard on the gold and glory to be won, and that at the end of the day these mongrels in the stands will go home to their shit lives, and you\'ll go home to your shit life as well, but at least your pockets will be a bit deeper.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s give the crowd something to cheer for!",
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
			Title = "À l'arène",
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
			Title = "À l'arène",
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
			Title = "À l'arène",
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
			Title = "À l'arène",
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
			Title = "À l'arène",
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


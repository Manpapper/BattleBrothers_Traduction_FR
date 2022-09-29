this.root_out_undead_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Objective1 = null,
		Objective2 = null,
		Target = null,
		Current = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.root_out_undead";
		this.m.Name = "Éradiquer les morts-vivants";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Origin == null)
		{
			this.setOrigin(this.World.State.getCurrentTown());
		}

		local nearest_undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(this.m.Origin.getTile());
		local nearest_zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getNearestSettlement(this.m.Origin.getTile());

		if (this.Math.rand(1, 100) <= 50)
		{
			this.m.Objective1 = this.WeakTableRef(nearest_undead);
			this.m.Objective2 = this.WeakTableRef(nearest_zombies);
		}
		else
		{
			this.m.Objective2 = this.WeakTableRef(nearest_undead);
			this.m.Objective1 = this.WeakTableRef(nearest_zombies);
		}

		this.m.Flags.set("Objective1Name", this.m.Objective1.getName());
		this.m.Flags.set("Objective2Name", this.m.Objective2.getName());
		this.m.Payment.Pool = 1500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
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
					"Détruisez %objective1%",
					"Détruisez %objective2%",
					"Retournez à %townname%"
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
				this.Contract.m.Objective1.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.setResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.clearTroops();
				this.Contract.addUnitsToEntity(this.Contract.m.Objective1, this.Contract.m.Objective1.getDefenderSpawnList(), 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.setDiscovered(true);

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Objective1.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Objective1.getLoot().clear();
				}

				this.World.uncoverFogOfWar(this.Contract.m.Objective1.getTile().Pos, 500.0);
				this.Contract.m.Objective2.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.setResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.clearTroops();
				this.Contract.addUnitsToEntity(this.Contract.m.Objective2, this.Contract.m.Objective2.getDefenderSpawnList(), 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.setDiscovered(true);

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Objective2.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Objective2.getLoot().clear();
				}

				this.World.uncoverFogOfWar(this.Contract.m.Objective2.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsNecromancers", true);
				}
				else if (r <= 25)
				{
					this.Flags.set("IsBandits", true);
				}

				this.Flags.set("ObjectivesDestroyed", 0);
				this.Flags.set("Objective1ID", this.Contract.m.Objective1.getID());
				this.Flags.set("Objective2ID", this.Contract.m.Objective2.getID());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [];

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull() && this.Contract.m.Target.isAlive())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("Tuez le nécromancien qui s\'enfuit");
				}

				if (this.Contract.m.Objective1 != null && !this.Contract.m.Objective1.isNull() && this.Contract.m.Objective1.isAlive())
				{
					this.Contract.m.Objective1.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("Détruisez %objective1%");
					this.Contract.m.Objective1.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
				}

				if (this.Contract.m.Objective2 != null && !this.Contract.m.Objective2.isNull() && this.Contract.m.Objective2.isAlive())
				{
					this.Contract.m.Objective2.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("Détruisez %objective2%");
					this.Contract.m.Objective2.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("ObjectiveDestroyed"))
				{
					this.Flags.set("ObjectiveDestroyed", false);

					if (this.Flags.get("IsBanditsCoop"))
					{
						this.Contract.setScreen("BanditsAftermathCoop");
					}
					else if (this.Flags.get("IsBandits3Way"))
					{
						this.Contract.setScreen("BanditsAftermath3Way");
					}
					else if (this.Flags.get("ObjectivesDestroyed") == 1)
					{
						this.Contract.setScreen("Aftermath1");
					}
					else
					{
						this.Contract.setScreen("Aftermath2");
					}

					this.World.Contracts.showActiveContract();
				}

				if (this.Flags.get("IsNecromancersSpawned"))
				{
					if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
					{
						this.Contract.setScreen("NecromancersAftermath");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Contract.m.Target.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) >= 9)
					{
						this.Contract.setScreen("NecromancersFail");
						this.World.Contracts.showActiveContract();
					}
				}

				if (!this.Flags.get("IsBandits") || this.Flags.get("ObjectivesDestroyed") != 0)
				{
					if (this.Contract.m.Objective1 != null && !this.Contract.m.Objective1.isNull() && !this.Contract.m.Objective1.getFlags().has("TriggeredContractDialog") && this.Contract.isPlayerNear(this.Contract.m.Objective1, 450))
					{
						this.Contract.m.Objective1.getFlags().add("TriggeredContractDialog");
						this.Contract.setScreen("UndeadRepository");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Contract.m.Objective2 != null && !this.Contract.m.Objective2.isNull() && !this.Contract.m.Objective2.getFlags().has("TriggeredContractDialog") && this.Contract.isPlayerNear(this.Contract.m.Objective2, 450))
					{
						this.Contract.m.Objective2.getFlags().add("TriggeredContractDialog");

						if (this.Flags.get("IsNecromancers"))
						{
							this.Flags.set("IsNecromancersSpawned", true);
							this.Contract.setScreen("Necromancers");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("UndeadRepository");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}

			function onCombatWithPlayer( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				this.Contract.m.Current = _dest;

				if (_dest != null && !_dest.getFlags().has("TriggeredContractDialog") && this.Flags.get("IsBandits") && this.Flags.get("ObjectivesDestroyed") == 0)
				{
					_dest.getFlags().add("TriggeredContractDialog");
					this.Contract.setScreen("Bandits");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					_dest.m.IsShowingDefenders = true;
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.EnemyBanners.push(_dest.getBanner());

					if (this.Flags.get("IsBandits") && this.Flags.get("ObjectivesDestroyed") == 0)
					{
						if (this.Flags.get("IsBanditsCoop"))
						{
							p.AllyBanners.push("banner_bandits_06");
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditRaiders, 90 * this.Contract.getScaledDifficultyMult(), this.Const.Faction.PlayerAnimals);
						}
						else
						{
							p.EnemyBanners.push("banner_bandits_06");
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditRaiders, 90 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						}
					}

					this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
				}
			}

			function onLocationDestroyed( _location )
			{
				if (_location.getID() == this.Flags.get("Objective1ID"))
				{
					this.Contract.m.Objective1 = null;
					this.Flags.set("ObjectiveDestroyed", true);
					this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
				}
				else if (_location.getID() == this.Flags.get("Objective2ID"))
				{
					this.Contract.m.Objective2 = null;
					this.Flags.set("ObjectiveDestroyed", true);
					this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Vous trouvez %employer% en train de rouler une carte et d\'en incliner l\'extrémité vers une bougie. Les flammes s\'élèvent rapidement et du papier noirci tombe dans le sillage du feu. Il vous fait signe d\'entrer.%SPEECH_ON%Les mauvaises cartes sont comme du poison pour une armée. Une bonne carte, par contre, c\'est de l\'or.%SPEECH_OFF%Le feu commençant à lui lécher les doigts, l\'homme laisse tomber le papier et le piétine. Il s\'assied et sort un autre parchemin qu\'il déroule sur l\'ensemble du bureau. C\'est, tout simplement, la plus belle carte que vous ayez jamais vue. %employer% utilise deux bâtons pour pointer deux endroits distincts.%SPEECH_ON%\"%objective1%\" et \"%objective2%\", deux noms intéressants. C\'est de là que mes espions disent que proviennent les morts-vivants. Enfin, la plupart de ces monstres, en tout cas. Allez vers les deux, mercenaire, et aidez à mettre fin à ces horreurs.%SPEECH_OFF% | Vous entrez dans le bureau de %employer%. Ses généraux ont le visage rouge, le revers cramoisi d\'une dispute qui a mal tourné. Le noble vous fait signe d\'entrer.%SPEECH_ON%Ah, un homme à qui j\'aimerais vraiment parler, enfin. Messieurs, laissez passer.%SPEECH_OFF%Sous un regard méprisant, vous traversez la mer de commandants hautains. %employer% vous glisse une carte. Deux endroits sont indiqués par des cercles et des têtes de mort grossièrement dessinées.%SPEECH_ON%Allez aux deux, mercenaire. \"%objective1%\" et \"%objective2%\". Mes scribes pensent qu\'ils sont indispensables pour les morts-vivants. Mes commandants ne sont pas d\'accord, mais pourquoi ne pas y jeter un oeil ? Maintenant, si vous voyez une de ces saloperies effrayantes, tuez-les, détruisez tous les trous d\'où elles sortent, et retournez me voir avec la brillante nouvelle de votre héroïsme. Marché conclu ?%SPEECH_OFF% | %employer% s\'occupe de son jardin. Les légumes sont devenus gris. Ses doigts retirent la cendre des vignes.%SPEECH_ON%Je suis attristé, mercenaire, par l\'état des choses, mais au moins ma putain de nourriture ne revient pas vivante pour me mordre le cul.%SPEECH_OFF%Vous riez et répondez.%SPEECH_ON%Donnez-lui du temps. Nous ne savons pas à quel point un légume peut être rancunier.%SPEECH_OFF%Le noble acquiesce sérieusement, comme si vous étiez un philosophe et non un plaisantin. Il vous lance une carte.%SPEECH_ON%Vous trouverez deux endroits marqués, \"%objective1%\"  et \"%objective2%\" . Apparemment, les deux sont des repaires de morts-vivants. Allez-y, tuez-les tous, et détruisez leurs maisons. Ou leurs tombes. Leurs fosses. Ou quoi que ce soit d\'autre.%SPEECH_OFF% | Vous croisez un paysan qui à l\'air triste, c\'est-à-dire un paysan ordinaire, sort du bureau de %employer% au moment où vous entrez. %employer% vous fait signe de vous rapprocher.%SPEECH_ON%Content que vous soyez là, mercenaire, parce que j\'ai une sacrée tâche pour vous. Mes éclaireurs m\'ont signalé deux endroits d\'un grand intérêt pour moi et les habitants de ces terres. Ils s\'agit de \"%objective1%\" et \"%objective2%\" et, apparemment, des morts-vivants proviennent des deux. Alors, que diriez-vous d\'aller là-bas et de le découvrir ? Et par découvrir, je veux dire tous les tuer si c\'est vrai et revenir avec les bonnes nouvelles.%SPEECH_OFF% | Vous trouvez %employer% en train de fixer un chat mort sur son bureau. La créature féline a une dague qui sort de sa poitrine et vous réalisez que le noble tient une autre lame à la main. Un garde se tient à côté, l\'épée déjà sortie, et un scribe près de lui avec une plume d\'oie et un parchemin. Vous traversez la pièce alors que tout le monde se détend lentement. Les lames sont rengainées, les stylos sont prêts à gribouiller. Le scribe s\'empresse d\'emmener le chat vers Dieu sait quelle destination. %employer% prend un siège.%SPEECH_ON%Salutations, mercenaire. Nous faisions une petite expérience. Nous ne croyions pas que les chats avaient vraiment neuf vies, mais dans ce nouveau monde d\'horreurs, ils pourraient en avoir deux. Et il s\'avère que non. Ils n\'en ont pas. Une seule est tout ce qu\'ils ont.%SPEECH_OFF%Le noble sort une carte et la pose sur son bureau. Il montre deux marques.%SPEECH_ON%\"%objective1%\", ici. Et \"%objective2%\" est ici. Allez aux deux. Si mes éclaireurs ont raison, vous y trouverez des morts-vivants. En grand nombre. Vous devez tout détruire là-bas et vous assurer que ces saletés de morts-vivants sont tuées dans l\'œuf.%SPEECH_OFF% | %employer% est debout avec un éclaireur épuisé à ses côtés. L\'éclaireur mange et boit à satiété, reconstituant ce qu\'il a perdu en sprintant à travers les terres. %employer% vous présente une carte grossièrement dessinée.%SPEECH_ON%\"%objective1%\" et \"%objective2%\". Nous, enfin, mon ami ici présent, pense que les morts-vivants proviennent de là-bas. De ces endroits surgissent toutes sortes de monstruosités. Allez-y, détruisez tout ce que vous voyez, et revenez en héros.%SPEECH_OFF%Vous haussez les épaules.%SPEECH_ON%La compagnie %companyname% préfère les couronnes aux accolades.%SPEECH_OFF% | %employer% vous accueille avec une carte.%SPEECH_ON%\"%objective1%\"  et \"%objective2%\", vous reconnaissez ces endroits ? Non, bien sûr que non. Mais je veux que vous alliez dans les deux, que vous éradiquiez le mal qui s\'y cache, et que vous reveniez. Une petite et simple escapade dans l\'antre des morts, non ?%SPEECH_OFF%Très bien. Qu\'est-ce qui pourrait mal se passer ? | %employer% vous demande si vous avez peur des morts-vivants. Vous haussez les épaules et répondez.%SPEECH_ON%J\'ai peur de mourir en regrettant de ne pas avoir fait tout ce que je voulais faire. C\'est à peu près tout ce que je crains. Ça et les chevaux.%SPEECH_OFF%Le noble rit.%SPEECH_ON%Très bien, d\'accord. Voici une carte. Vous verrez les marques \"%objective1%\" et \"%objective2%\". Mes éclaireurs pensent que ce sont les antres des  morts-vivants. C\'est logique puisque c\'est là qu\'on met nos morts en premier lieu. Allez aux deux, détruisez-les, et revenez ici pour votre paie. Assez simple, hein ?%SPEECH_OFF% | %employer% vous accueille à sa porte avec une carte à la main.%SPEECH_ON%\"%objective1%\" et \"%objective2%\", clairement marqués, vous voyez ? Bien sûr que vous voyez. Mes petits oiseaux disent que de grands maux se répandent dans les deux. Si c\'est vrai, alors j\'ai besoin d\'un homme sans peur, d\'une stature de tueur pour aller dans les deux et détruire tout ce qui s\'y trouve. Je crois que vous êtes un tel homme. L\'êtes-vous ?%SPEECH_OFF% | Vous voyez un homme bien équipé, mais au visage triste, quitter la chambre de %employer%. Lorsque vous entrez, le noble vous invite à vous rendre à son bureau pour consulter une carte.%SPEECH_ON%Vous n\'avez pas peur des morts, n\'est-ce pas ? Et des morts-vivants ? Non ? Parfait. \"%objective1%\" est là, et \"%objective2%\" est là. Allez aux deux, détruisez-les, et montrez à ce mécréant qui vient de passer cette porte ce qu\'un vrai homme peut faire.%SPEECH_OFF%Vous levez un doigt correcteur.%SPEECH_ON%Ce qu\'un vrai homme peut faire - pour le bon prix.%SPEECH_OFF% | %employer% vous accueille dans son bureau avec une drôle de question.%SPEECH_ON%Vous êtes déjà allé dans un cimetière, mercenaire ?%SPEECH_OFF%Avant que vous ne répondiez, l\'homme se verse un verre et en prend une gorgée, en tendant l\'autre main pour vous faire taire.%SPEECH_ON%Ce sont des choses curieuses. Contre nature, vraiment. Quelle sorte de créature prend ses morts et va sur une terre, une bonne terre en plus, et les enterre là ? Comme c\'est voyant. C\'est sans importance. Est-ce une surprise, alors, que les morts reviennent ? Peut-être qu\'ils nous hantent pour avoir brisé l\'ordre naturel.%SPEECH_OFF%L\'homme vous jette un parchemin sur lequel se trouve une carte bien dessinée. Deux endroits sont marqués.%SPEECH_ON%\"%objective1%\" et \"%objective2%\". J\'ai besoin que vous alliez aux deux, que vous les détruisiez, et que vous reveniez. Assez simple pour un homme de votre profession, non ?%SPEECH_OFF% | Vous trouvez %employer% qui secoue la tête en faisant travailler une plume d\'oie sur une carte.%SPEECH_ON%\"%objective1%\" et \"%objective2%\", deux petits trous à rats pas si loin d\'ici, ont besoin d\'être détruits. Bien sûr, ce sont les maisons des morts et, par conséquent, des morts-vivants. Ils ne nous ont pas laissé de répit et maintenant, eh bien, est-ce qu\'un de ces cadavres peut être mis au repos ? Qui sait. Mais tuez-les tous, compris ?%SPEECH_OFF% | %employer% se retrouve à s\'occuper de dizaines d\'oiseaux en cage. Certains volent autour de leur cage, se cognant contre les barreaux. Le noble ramasse un oiseau mort, les pattes raides dans l\'air. Il vous jette le corps.%SPEECH_ON%J\'ai une mission pour vous, mercenaire. \"%objective1%\" et \"%objective2%\", situés non loin d\'ici, doivent être détruits. Mes éclaireurs ont rapporté, grâce à ces petits oiseaux, que ces endroits abritent des morts-vivants, peut-être une source, ou une base d\'opérations, si jamais les cadavres pouvaient organiser une telle chose.%SPEECH_OFF%L\'homme commence à jeter des graines pour oiseaux dans les nids. Quelques oiseaux fixent la nourriture et choisissent de ne pas manger, n\'étant pas obligés de voler le plus grand cadeau que la nature puisse offrir. Les oiseaux aux ailes taillées, par contre, se régalent. %employer% se tourne vers vous, en tapant les résidus sur ses mains.%SPEECH_ON%Alors, on a un accord ?%SPEECH_OFF% | Vous trouvez %employer% entouré de ses gardes, les yeux rivés sur un cadavre au milieu de la pièce. Une odeur épouvantable vous accueille bien avant celle du noble. Un miasme se dégage du corps, d\'une teinte grise paresseuse, comme s\'il s\'agissait d\'un tas de cendres dans un couloir de ventilation.%SPEECH_ON%Mercenaire ! C\'est bon de vous avoir ici ! Ignorez cette agitation, si vous le pouvez. Nous avons eu un problème avec un garde qui s\'est suicidé et, eh bien, est revenu. Un plan compliqué d\'assassinat, peut-être ? Difficile à dire dans ce monde. Venez, j\'ai quelque chose pour vous.%SPEECH_OFF%Il vous fait signe d\'avancer, un parchemin dans une main tendue. Vous le prenez et déroulez une carte. L\'homme explique ce que c\'est.%SPEECH_ON%\"%objective1%\" et \"%objective2%\", si vous les reconnaissez, sont des foyers d\'où nous pensons que les morts-vivants sortent. J\'ai besoin d\'un homme de votre, eh, stature robuste pour aller là-bas et mettre fin à ces deux foyers. J\'espère que c\'est quelque chose qui vous intéresse.%SPEECH_OFF% | %employer% vous accueille dans son bureau, mais un garde vérifie votre gorge avec la lame d\'une arme de poing. Vous gardez votre calme alors que le noble ordonne rapidement à son homme de se retirer. Le noble s\'excuse.%SPEECH_ON%Désolé pour ce malheureux événement, mais les hommes sont sur les nerfs. L\'autre nuit, l\'un d\'entre eux est mort dans son sommeil et, eh bien, il est revenu. Une bête macabre et grondante qui a tué trois hommes avant même que quiconque ne sache ce qui se passait.%SPEECH_OFF%Vous vous frottez le menton, remarquant que vous aviez besoin d\'un bon rasage de toute façon. %employer% acquiesce avec un sourire.%SPEECH_ON%Mmm, c\'est ce que j\'aime chez vous, mercenaire. Toujours dans un bon esprit. Regardez cette carte que j\'ai. Vous voyez ces endroits ? La paysannerie les appelle \"%objective1%\" et \"%objective2%\". Nous avons des raisons de croire que les deux sont d\'incroyables sources alimentant les hordes de morts-vivants. J\'ai besoin d\'un homme de votre stature et de votre détermination pour aller là-bas et les détruire. Cela vous intéresse-t-il, mercenaire ?%SPEECH_OFF% | Vous trouvez %employer% adossé à sa chaise. Il vous lance une carte.%SPEECH_ON%Lisez-la, étudiez-la. Vous voyez \"%objective1%\" et \"%objective2%\" ? Mes espions pensent qu\'ils abritent d\'incroyables pouvoirs qui alimentent les morts-vivants. Je pense qu\'ils abritent juste beaucoup de cadavres pour que les morts-vivants puissent se réincarner. Quoi qu\'il en soit, j\'ai besoin que vous alliez aux deux, que vous les détruisiez tous les deux, et qu\'ensuite vous reveniez à moi. Ça vous intéresse ou pas ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Quel est le salaire ? | Ce qui m\'intéresse, c\'est le paiement.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | On est demandé autre part.}",
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
			ID = "UndeadRepository",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Une odeur familière commence à se répandre sur la compagnie. %randombrother% remarque qu\'on doit se rapprocher de notre cible. Vous lui faites remarquer qu\'il est un putain de génie et qu\'il devrait faire des inventions et des découvertes pour le bien de l\'humanité. Vous pouvez pratiquement entendre son silence par-dessus les rires de la compagnie. | Alors que vous vous approchez de votre objectif, il devient de plus en plus évident que les conclusions de %employer% sur la zone étaient correctes. La puanteur est indéniable : les morts qui se trouvaient dans cette zone sont revenus parcourir les terres. | Vous trouvez un cadavre emmêlé dans un buisson, ses mains couvertes de branches pédalant sans cesse vers l\'extérieur avec une sorte d\'indifférence mortelle. %randombrother% s\'approche, en gardant soigneusement ses distances, et lui plante une lame dans le crâne. Il se recule, nettoie son arme et remarque que la compagnie doit se rapprocher de ce que vous êtes venu détruire. | À en juger par l\'odeur envahissante des corps en putréfaction et les gaz qui en émanent, il ne fait guère de doute que %objective% est proche. | Vous trouvez la moitié d\'un homme rampant sur le sol. Il vous regarde fixement, gémissant sans réfléchir, indifférent à sa nouvelle existence mais désireux de mettre fin à la vôtre. D\'un coup de botte, vous enfoncez sa tête dans la boue. Ses grognements deviennent des gargouillis et vous lui enfoncez délicatement une dague par le trou de l\'oreille. %randombrother% regarde autour de lui.%SPEECH_ON%%objective% ne devrait plus être très loin maintenant.%SPEECH_OFF% | Votre destination est encore à peine en vue, mais les odeurs frappent le nez avec une férocité que vous espérez ne pas se voir reflétée par ce qui l\'habite. Vous devriez préparer les hommes pour la bataille à venir. | %randombrother% montre du doigt, en dehors du chemin, un groupe de cadavres éparpillés là dans ce qui semble être une série de morts des plus spectaculaires. Vous n\'avez aucune idée de ce qui s\'est passé, mais les corps sont morts depuis longtemps et pourtant il n\'y a aucun signe de mouches ou d\'autres animaux qui se soient posés sur eux. Vous informez les hommes que votre destination est proche et qu\'ils doivent se préparer au combat à venir. | La compagnie tombe sur un cadavre rampant aux mains et aux jambes attachées. L\'emprisonnement dans la vie n\'a pas pris fin avec la réanimation et vous faites donc ce qu\'un bourreau aurait dû faire il y a longtemps et vous enlevez la tête du wiederganger. %randombrother% vous demande si votre destination est proche et vous acquiescez. Elle l\'est certainement, et avec elle viendra une bataille à laquelle la compagnie %companyname% devrait se préparer. | Votre destination ne doit pas être bien loin si l\'on en croit l\'horrible odeur qui flotte sur la compagnie. Qu\'il s\'agisse de morts-vivants ou d\'un homme aux selles les plus pernicieuses, la compagnie %companyname% doit se préparer à combattre. | Les morts-vivants vous accueillent un par un, une succession de miettes de pain à éliminer qui mènent la compagnie %companyname% directement à sa cible. Préparez-vous à vous battre, car vous aurez bientôt le pain entier dans votre assiette. | Un vieil homme salue la compagnie et déclare que %objective% n\'est pas loin. Vous lui demandez ce qu\'il fait encore ici. Il hausse les épaules.%SPEECH_ON%Le fait d\'être vieux, quoi d\'autre ?%SPEECH_OFF% | %randombrother% renifle l\'air.%SPEECH_ON%Je connais le cul puant de %randombrother2% et ce n\'est pas lui.%SPEECH_OFF%Le mercenaire insulté hausse les épaules.%SPEECH_ON%Ce n\'est pas faute d\'avoir essayé, mais oui, je pense que tu as raison. On doit se rapprocher de %objective%.%SPEECH_OFF%Vous acquiescez et dites aux hommes de se préparer pour la bataille à venir. | Vous trouvez un cadavre rongé par les vers et avec des orbites abyssales qui se débat autour d\'un gros rocher. Il se traîne en grattant la pierre dans un effort sincère pour la tuer. %randombrother% décapite le wiederganger d\'un coup de lame, comme un homme tranchant un totem de beurre. Il fait un signe de tête vers le lointain.%SPEECH_ON%%objective% est proche%SPEECH_OFF%Si c\'est le cas, la compagnie %companyname% doit se préparer à la bataille.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous au pire !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Aftermath1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Le mal dans cet endroit a été détruit. Vous prenez une inspiration qui semble être la première depuis des années, comme si l\'air lui-même s\'était réchauffé à votre victoire. Il ne reste plus que %objective2% maintenant. | Alors que les derniers morts-vivants sont mis au repos, vous avez l\'impression que l\'air s\'éclaircit, comme un brouillard de fumée qui fait place à des arômes printaniers. Le changement rapide des odeurs signifie sans doute que vous avez nettoyé le mal qui habitait là. Maintenant, il faut nettoyer %objective2% et en finir avec ce contrat. | Le mal de cet endroit a été mis au repos. Votre prochaine cible vous attend. | Une fois l\'endroit horrible débarrassé du mal, il ne reste plus que %objective2% sur le contrat. | Alors que le dernier wiederganger est mis au repos, vous sentez un changement soudain dans l\'air. La propreté frappe vos poumons avec une clarté inattendue alors que vous vous trouvez dans un monde de boue et de fange. %randombrother% s\'essuie le front.%SPEECH_ON%Ça doit être la fin. En route pour %objective2%, maintenant ?%SPEECH_OFF% | Vous êtes entré dans un domaine du mal, mais avec le dernier wiederganger tué, vous voyez le monde autour de vous s\'éclairer et l\'odeur de la terre sous vos pieds revenir à l\'ordre naturel. Avec cet endroit mis au repos, il est temps de passer à %objective2%. | La victoire a été durement disputée. Des Wiedergangers et les bizarreries de morts-vivants plus anciens jonchent le sol. Vous espérez que %objective2% sera plus facile à gérer, mais vous en doutez. | Vous enjambez le cadavre d\'un ancien mort. Il est si différent de vous qu\'il pourrait aussi bien être étranger à toute vie que vous connaissez. Le crâne est mal formé, comme un ancêtre rétréci du vôtre, et l\'armure et les armes semblent étrangères à ce monde.\n\n Vous préparez les hommes pour le voyage vers %objective2%. | La terre est jonchée des cadavres en décomposition des morts-vivants. Vous enjambez leurs corps pour constater que le sol sous vos pieds redevient sain, comme si le sol se retournait de sa cachette, et l\'air lui-même est plus facile à respirer. Peut-être le mal a-t-il vraiment quitté les lieux ? Quoi qu\'il en soit, il est temps de passer à %objective2% et de lui donner le traitement amical de la compagnie %companyname%. | Une fois les derniers morts-vivants tués, vous regardez le champ de bataille. Les morts ne sont pas d\'une seule origine, à en juger par la variété de leurs vêtements et armures, mais ils ne sont pas non plus d\'une seule époque. Certains portent les armures des anciens et apportent avec eux une uniformité troublante dans leur effort de tuer.\n\n %randombrother% passe, déclarant que la compagnie est prête à passer à %objective2% dès que vous le serez.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Victoire ! | Et restez mort !}",
					function getResult()
					{
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Aftermath2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{%objective2% est en ruines, bien que de votre point de vue, il soit plus beau que jamais. C\'est probablement mieux de retourner voir %employer% maintenant et d\'obtenir votre récompense. | Vous avez donné à %objective2% une juste mesure corrective, le sortant des griffes des morts-vivants et le ramenant dans le monde des vivants. Vous voyez déjà l\'herbe et les arbres redevenir plus vivants, et une brise rafraîchissante arrive. Vous devriez informer %employer% de vos actions pour que vous puissiez aller chercher votre salaire. | Les ténèbres qui se trouvaient à %objective2% ont été détruits. Enfin, à l\'exception de ces cadavres sous les décombres. Il y a toujours un peu d\'obscurité, mais c\'est plus dû au manque de lumière qu\'à la présence du mal. Dans tous les cas, vous devriez aller dire à %employer% ce que vous avez accompli. | %objective2% est bien plus beau avec la compagnie %companyname% qui se tient victorieux sur ses ruines. De la façon dont vous le voyez, un peintre devrait aller faire une petite représentation de votre réussite. %randombrother% est particulièrement beau quand il écrase des crânes de wiedergangers avec ses bottes. Mais être payé par %employer% serait encore mieux. C\'est probablement mieux de retourner le voir. | %objective2% est détruit et avec lui, le mal a quitté ces terres. Espérons qu\'il soit parti pour de bon, mais il y a de fortes chances qu\'il soit simplement parti vers un autre lieu de faiblesse. En parlant de ça, vous feriez mieux de retourner chez %employer% pour votre paie. | %objective2% a été mis à plat et tout le mal qui l\'habitait a disparu. L\'air est plus léger, plus frais. %employer% devrait être heureux de vous voir et des résultats que vous avez à rapporter. | La compagnie %companyname% est victorieuse, les maux de %objective2% sont enterrés, ou peut-être chassés pour habiter un autre endroit. Une partie cynique de vous espère que c\'est le dernier cas, car dans ce cas, un autre noble voudra que vous le chassiez et vous aurez gagné un autre jour de paie. Alors que les pensées d\'une escroquerie circulaire maléfique envahissent votre tête, %randombrother% arrive et vous demande s\'il est temps de retournez voir %employer%. Vous acquiescez. Un pas après l\'autre. | %objective2% et tous ses habitants sinistres et cruels ont été tués. C\'est étrange de voir un champ de bataille jonché de morts qui vont de la fraîcheur du cadavre d\'un wiederganger à la carcasse poussiéreuse de l\'armure d\'un ancien. Les cadavres ont plus de diversité qu\'un magasin d\'antiquités.\n\n Une fois que la compagnie a fait son plein de butin, elle devrait retourner voir %employer% pour votre salaire. | Des wiedergangers et des anciens morts jonchent le sol. Des morts-vivants-morts, un étrange terme pour désigner le meurtre d\'un mal au-delà de votre mesure. Mais ils ont été tués, prouvant que les monstres peuvent être arrêtés. Vous préparez la compagnie retourner voir %employer% pour un salaire correct. | %objective2% est détruit, prouvant que même les morts réanimés ne peuvent éviter la destruction totale que la compagnie %companyname% apporte sur le champ de bataille. Une fois le mal éliminé, vous ressentez un sentiment de civilité et de retour à la nature. L\'air frappe votre nez avec une vivacité bienvenue. Au-dessus de vous, des oiseaux volent dans le ciel. Des petits aussi, pas seulement des buses à la recherche d\'un repas.\n\n Vous dites à la compagnie de piller ce qu\'elle peut et de se préparer à retourner voir %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Victoire ! | Il est temps de retourner à %townname%.}",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancers",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Vous apercevez des nécromanciens au loin. Il ne fait aucun doute que ces hommes sont responsables de la plupart des maux qui affligent ces terres. Vous ne pouvez pas les laisser s\'échapper ! | %randombrother% vient à vos côtés, la sueur coulant sur son visage.%SPEECH_ON%Monsieur, nous avons repéré des hommes mal intentionnés qui courent là-bas.%SPEECH_OFF%En prenant une lunette de visée, vous voyez, courant le long de l\'horizon comme des fourmis se déplaçant au sommet de leur monticule, un couple d\'hommes à la robe grise avec une brume de maladie derrière eux. Vous tapez sur l\'épaule du mercenaire.%SPEECH_ON%Bonne vue. Maintenant va dire aux hommes qu\'on a des nécromanciens à traquer.%SPEECH_OFF% | Vous prenez une lunette et observez les terres environnantes. Étonnamment, il y a une poignée de silhouettes qui courent au loin, et elles ne cessent de se retourner comme si vous étiez à leur poursuite. Vous étirez la lunette et obtenez une meilleure vue des silhouettes. Des vêtements sombres, des visages pâles, des barbes blanches, des poignards avec des gravures de culte... des nécromanciens ! Il faut les attraper et les tuer pour vraiment débarrasser cette terre du mal. | %randombrother% rapporte que deux hommes bizarres ont été aperçus en train de fuir la compagnie %companyname%. Vous haussez les épaules et lui dites qu\'il est tout à fait normal de fuir une bande de mercenaires. Il acquiesce, puis ajoute.%SPEECH_ON%Oui, bien sûr, mais ce sont des hommes grisonnants avec des capes noires et je suis sûr qu\'il y avait deux cadavres qui marchaient à côté d\'eux.%SPEECH_OFF%C\'est la description d\'un nécromancien s\'il y en a jamais eu une. La compagnie devrait les pourchasser avant qu\'ils ne s\'échappent ! | Pendant qu\'il regarde les cartes, %randombrother% vient faire un rapport de reconnaissance.%SPEECH_ON%On a un duo de nécromanciens, monsieur. Des vieillards, des armes étranges, des yeux brillants, des cadavres pour amis, la totale.%SPEECH_OFF%S\'il s\'agit vraiment de nécromanciens, ils sont très probablement responsables d\'une grande partie du mal qui règne sur ces terres et doivent être extirpés aussi vite que possible. | Nécromanciens ! Des hommes chantants, rampants, parcourant la terre sous le couvert de cadavres et autres \"amis\" qui leur tiennent compagnie. Il faut les traquer immédiatement ! | Nécromanciens ! Praticiens des arts sombres, ces hommes sont sans doute en partie responsables des maux qui infectent ces terres. Ils doivent être pourchassés et tués ! | %randombrother% vous tend une lunette. En la regardant, vous confirmez rapidement son rapport : il y a des nécromanciens là-bas, qui se pressent dans une vallée voisine et qui essaient sans doute d\'échapper à la compagnie %companyname%. Vous fermez la lunette et dites au mercenaire de préparer les hommes. Ces nécromanciens doivent être traqués et tués au plus vite !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Poursuivons-les !",
					function getResult()
					{
						local tile = this.Contract.m.Objective2.getTile();
						local banner = this.Contract.m.Objective2.getBanner();
						this.Contract.m.Objective2.die();
						this.Contract.m.Objective2 = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getNearestSettlement(playerTile);
						local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, "Necromancers", false, this.Const.World.Spawn.UndeadScourge, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getSprite("banner").setBrush(banner);
						party.setFootprintType(this.Const.World.FootprintsType.Undead);
						party.getSprite("body").setBrush("figure_necromancer_01");
						party.setSlowerAtNight(false);
						party.setUsingGlobalVision(false);
						party.setLooting(false);
						this.Const.World.Common.addTroop(party, {
							Type = this.Const.World.Spawn.Troops.Necromancer
						}, false);
						this.Const.World.Common.addTroop(party, {
							Type = this.Const.World.Spawn.Troops.Necromancer
						}, true);
						this.Contract.m.UnitsSpawned.push(party);
						this.Contract.m.Target = this.WeakTableRef(party);
						party.setAttackableByAI(true);
						party.setFootprintSizeOverride(0.75);
						local c = party.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
						local roam = this.new("scripts/ai/world/orders/roam_order");
						roam.setPivot(camp);
						roam.setMinRange(1);
						roam.setMaxRange(10);
						roam.setAllTerrainAvailable();
						roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
						roam.setTerrain(this.Const.World.TerrainType.Shore, false);
						roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
						c.addOrder(roam);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NecromancersFail",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_36.png[/img]{La piste des nécromanciens a disparu. Si seulement il y avait une force dans ce monde pour la faire revivre. | Vous n\'avez pas réussi à rattraper les nécromanciens. Vous n\'avez aucune idée d\'où ils sont partis, mais il y a peu de doutes qu\'ils aient emporté leur mal avec eux. | Comment ? Comment avez-vous laissé les nécromanciens s\'échapper ? Maintenant ils sont libres de se déchaîner et de répandre leur mal partout où ils vont.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Non, non, non!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Échec de la destruction des forteresses des morts-vivants.");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "NecromancersAftermath",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Les nécromanciens ont été détruits. Le mal qu\'ils avaient dans leur coeur a été, par la lame, mis à nu. Ils ne peuvent plus hanter ces terres. | Les nécromanciens gisaient morts, rejoignant finalement les cadavres dans lesquels ils avaient recruté leurs armées de manière si irresponsable. | Vous fixez un nécromancien, pour bien voir l\'homme qui ressuscite si cruellement les morts pour combattre en leur nom. Sa bouche est toujours mal formée, comme si elle était prête à prononcer une autre incantation maléfique. Heureusement, tout cela est terminé. Car cruel ou non, ce n\'est qu\'un homme. | Vous regardez le visage décharné et macabre d\'un nécromancien. %randombrother% s\'approche et crache, faisant atterrir un gros molard en plein sur la joue du cadavre.%SPEECH_ON%Qu\'ils aillent au diable, ils ne me font pas peur.%SPEECH_OFF%Vous acquiescez. Alors que le crachat coule sur le visage du nécromancien, vous voyez ses yeux devenir brièvement rouges. Vous pensez que c\'est mieux de ne pas en parler au mercenaire. | Les nécromanciens ont été tués, bien que la lumière dans leurs yeux soit étonnamment lente à disparaître. %randombrother% semble encore assez fier de la bataille.%SPEECH_ON%Regarde-les. Tous morts et en mauvais état.%SPEECH_OFF%Il se penche en avant, les mains sur les genoux, criant au visage d\'un cadavre comme s\'il s\'agissait d\'un sourd.%SPEECH_ON%Où sont tes amis morts maintenant ? Hmm ? Oh, c\'est vrai, tu es un homme mort maintenant ! Que c\'est dommage !%SPEECH_OFF%Vous dites à l\'homme de se calmer, de peur que ces magiciens de l\'ombre aient des pouvoirs d\'outre-tombe. | Les nécromanciens ont été tués. Sans surprise, un nécromancien mort ressemble beaucoup à un nécromancien normal. | Les nécromanciens ont été mis à terre et la mauvaise influence qu\'ils exerçaient sur ces terres s\'est éteinte. Nul doute que vous avez fait du bon travail en détruisant une grande partie du mal qui sévit sur ces terres.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Une chose de moins à laquelle se soucier.",
					function getResult()
					{
						this.Flags.set("IsNecromancers", false);
						this.Flags.set("IsNecromancersSpawned", false);
						this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
						this.Contract.m.Target = null;

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Bandits",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{En vous dirigeant vers %objective%, vous tombez sur un groupe de brigands. Ils se retournent et dégainent leurs armes, et la compagnie %companyname% fait de même. Vous tendez la main, le chef des vagabonds fait de même, coupant un peu la tension entre les deux parties. Le chef parle.%SPEECH_ON%Le butin est à nous, nous étions là les premiers et, si vous osez vous battre avec nous pour ça, nous serons là les derniers aussi !%SPEECH_OFF%On dirait qu\'ils veulent juste piller l\'endroit. Pour ce faire, il faudrait tuer beaucoup de wiedergangers, ce qui serait très utile. Peut-être pourriez-vous joindre vos forces ? Quoi que vous choisissiez, faites-le vite, car les morts-vivants sont là ! | Un groupe de brigands se prépare à attaquer %objective% ! Ils sortent leurs armes et menacent d\'attaquer, mais vous parlementez un moment, comprenant qu\'ils veulent juste piller le lieu. Peut-être que la compagnie %companyname% pourrait s\'allier à eux ? Ou alors, les tuez tous, morts-vivants et brigands, et prenez tout pour vous. | Alors que vous approchez de %objective%, vous tombez sur un groupe de brigands. Ils se préparent à attaquer, non pas la compagnie %companyname%, mais le lieu lui-même. Il semble qu\'ils ne cherchent qu\'à récupérer le butin qui s\'y trouve et qu\'ils vous combattront pour l\'obtenir. Vous pourriez peut-être vous joindre à eux, au prix d\'un éventuel butin, ou bien aller de l\'avant et massacrer tout ce qui bouge pour vous approprier l\'or et la gloire. Mais choisissez vite, car les morts-vivants sont là ! | Des brigands ! Un groupe d\'entre eux, bien armés et prêts à attaquer. Heureusement, ils cherchent à attaquer %objective% lui-même. Peut-être que la compagnie %companyname% pourrait se joindre à eux, mais il ne fait aucun doute que les brigands voudront une grande partie du butin qu\'il y a à trouver. L\'autre option est de tout tuer et de prendre le butin pour vous. Mais il faut faire vite, car les morts-vivants sont là ! | Vous tombez sur un groupe d\'hommes bien armés. Ils se tournent rapidement vers vous, armes dégainées. %randombrother% sort une lame et menace de tuer le premier homme qui bouge. Malgré la tension considérable, vous parvenez à vous calmer et à discuter avec le chef des brigands. Il vous explique qu\'ils sont là pour piller %objective% et prendre tout son butin. Vous pouvez faire équipe avec les voleurs ou, si vous voulez tout le butin, les tuer ainsi que les wiedergangers. | %randombrother% va pisser, mais s\'éloigne du buisson en sautant, à moitié en arrangeant son pantalon, à moitié en essayant de sortir une vraie arme. Un brigand émerge des broussailles, une lame déjà sortie, et bientôt un flot d\'entre eux sort en hurlant et en criant, la compagnie %companyname% faisant de même en retour. Leur chef sort, les mains levées, et demande à parler au chef.\n\n Au cours de vos discussions, vous apprenez qu\'il s\'agit d\'un groupe de vagabonds chasseurs de trésors qui cherchent à piller %objective%. Vous pouvez vous joindre à eux et combattre les morts-vivants ensemble, mais sinon ils vous combattront ainsi que les morts-vivants car ils ne sont pas venus ici pour partager leurs biens avec des mercenaires.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous partageons un objectif commun. Attaquons, ensemble !",
					function getResult()
					{
						this.Flags.set("IsBanditsCoop", true);
						this.Contract.m.Current.getLoot().clear();
						this.Contract.m.Current.setDropLoot(false);
						this.Contract.getActiveState().onCombatWithPlayer(this.Contract.m.Current, false);
						return 0;
					}

				},
				{
					Text = "Nous ne sommes pas là pour partager le butin. Rencontrez votre fin !",
					function getResult()
					{
						this.Flags.set("IsBandits3Way", true);
						this.Contract.getActiveState().onCombatWithPlayer(this.Contract.m.Current, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BanditsAftermathCoop",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Le mal dans cet endroit a été éradiqué. Après avoir partagé les marchandises avec les brigands, vous vous préparez à vous diriger vers %objective2%, en veillant à ne pas en parler aux voleurs. | Alors que les derniers morts-vivants sont mis au repos, vous avez l\'impression que l\'air s\'éclaircit, comme un brouillard de fumée qui fait place à des arômes printaniers. Le changement rapide des odeurs signifie sans doute que vous avez nettoyé le mal qui habitait là. Vous partagez le butin avec les brigands. Ils sont plutôt arrogants, prétendant que vous n\'auriez pas survécu s\'ils n\'avaient pas été là. Vous avez failli leur parler de %objective2%, mais cette flambée de fierté mal placée ruine toute chance de retravailler avec eux. | Le mal du lieu a été mis hors d\'état de nuire. %objective2% attend.\n\n Vous partagez le butin avec les brigands qui sont plus qu\'heureux de faire affaire avec vous. Ils ne le disent pas, mais il est évident qu\'ils auraient été massacrés jusqu\'au dernier si vous n\'aviez pas été là. | Une fois l\'horrible endroit débarrassé du mal, il ne reste plus que %objective2% sur le contrat. Quant aux brigands, ils prennent leur butin comme convenu. Ils demandent où vous allez et vous leur dites que ce ne sont pas leurs affaires. | Alors que le dernier wiederganger est mis au repos, vous sentez un changement soudain dans l\'air. La propreté frappe vos poumons avec une clarté inattendue alors que vous vous trouvez dans un monde de boue et de fange. %randombrother% s\'essuie le front.%SPEECH_ON%Ça devait être le dernier. En route pour %objective2%, maintenant ?%SPEECH_OFF%Quand un brigand s\'approche, vous dites au mercenaire de se taire. Mieux vaut ne pas informer ces salauds du prochain endroit. Bien qu\'ils aient pris une grande part du butin, ils n\'ont pas été d\'une grande aide dans le combat. | Vous êtes entré dans un domaine du mal, mais avec le dernier wiederganger tué, vous voyez le monde s\'éclaircir et l\'odeur de la terre sous vos pieds revenir à son état naturel. Avec cet endroit en paix, il est temps de passer à %objective2%.\n\n Le chef des brigands s\'approche. Il a un parchemin à la main et garde un œil sur le partage du butin.%SPEECH_ON%Content de travailler avec vous, mercenaire.%SPEECH_OFF%Vous lui dites que sa bande d\'idiots aurait couru à leur perte si vous n\'étiez pas arrivé. Il hausse les épaules.%SPEECH_ON%Personne n\'est parfait. A la prochaine fois, donc ?%SPEECH_OFF%Vous l\'ignorez pour aller rassembler les hommes. | La victoire a été durement disputée. Des Wiedergangers et des morts-vivants plus anciens jonchent le terrain. Les brigands avec lesquels vous avez fait équipe passent les restes au peigne fin, prenant leur part du butin comme convenu. Vous espérez que %objective2% sera plus facile à régler, mais vous en doutez. | Les brigands parcourent le champ et ramassent le butin que vous et leur chef avez convenu de partager. Vous dites à %randombrother% de préparer tranquillement les hommes pour la marche vers %objective2%. Il demande pourquoi en silence et vous lui répondez.%SPEECH_ON%Parce que la dernière chose dont nous avons besoin, c\'est que ces rats d\'acier inutiles se présentent dans une autre bataille et prennent du butin que nous savons tous deux qu\'ils n\'ont pas mérité.%SPEECH_OFF%Parce que la dernière chose dont nous avons besoin, c\'est que ces parasites inutiles apparaissent dans une autre bataille et prennent du butin que nous savons tous deux qu\'ils n\'ont pas mérité.%SPEECH_ON%Ah. Je dirais que vous m\'avez enlevé les mots de la bouche.%SPEECH_OFF% | Vous préparez les hommes pour la marche vers %objective2%.\n\n Le chef des brigands vient vers vous.%SPEECH_ON%C\'est bon de se battre avec vous. Dites, où allez-vous ensuite ? Plus de trésors à trouver, hein ?%SPEECH_OFF%Vous vous retournez et attrapez l\'homme par la chemise.%SPEECH_ON%Je pense que nous savons tous les deux qui d\'entre nous a tiré son poids dans ce combat. Maintenant, vous prenez votre butin et vous partez. C\'est ce que nous avions convenu. Si vous nous suivez, je ferai fondre tout ce que vous avez volé et je le verserai sur votre tête, compris ?%SPEECH_OFF%Il recule et hoche la tête avec anxiété, comme si vous alliez tenir votre promesse à l\'instant même. | Une fois les derniers morts-vivants tués, vous regardez le terrain. Les morts ne sont pas d\'une seule origine, à en juger par la variété de leurs vêtements et armures, mais ils ne sont pas non plus d\'une seule époque. Certains portent les armures des anciens et font preuve d\'une uniformité troublante dans leurs efforts pour tuer.\n\n %randombrother% passe, indiquant que la compagnie est prête à se rendre à %objective2% dès que vous le souhaitez. Le chef des brigands l\'interrompt.%SPEECH_ON%Eh bien, ça ne vous dérange pas que l\'on se serve le butin les premiers, n\'est-ce pas ?%SPEECH_OFF%Vous acquiescez. C\'est ce qui a été convenu.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Victoire !",
					function getResult()
					{
						this.Flags.set("IsBanditsCoop", false);

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BanditsAftermath3Way",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Vous trouvez le chef des brigands mort parmi les corps. Il a un air de regret sur le visage, plus que ce qui est habituel pour quelqu\'un qui a récemment décidé de son propre destin et qui a connu une fin tragique. Ah, c\'est triste. Vous rassemblez les hommes pour les préparer à marcher vers %objective2%. | Le chef des brigands gît sur le sol. La moitié de son visage a disparu, rapidement retrouvé dans la gueule d\'un wiederganger à proximité. Quel dommage. Bon, il est temps de se rendre à %objective2%. | Une fois les morts-vivants éliminés, ainsi que les brigands idiots qui pensaient pouvoir tenir tête à la compagnie %companyname%, il ne vous reste plus qu\'à vous occuper de %objective2%. | Les brigands ont mal choisi, combattant à la fois les morts-vivants et la compagnie %companyname%. Etonnamment, les choses ne se sont pas bien passées pour eux. Vous ordonnez aux hommes de ramasser tout le butin et de se préparer à la marche vers %objective2%. | Alors que les derniers morts-vivants sont mis au tapis, vous avez l\'impression que l\'air s\'éclaircit, comme un brouillard de fumée qui fait place à des arômes printaniers. Le changement rapide d\'odeurs signifie sans doute que vous avez nettoyé le mal qui habitait là. Malheureusement, le groupe de brigands morts qui a décidé de vous affronter va bientôt commencer à sentir. Tant pis. Maintenant, allons nettoyer %objective2% et en finir avec ce contrat. | Le mal de l\'endroit a été éliminé. Les brigands aussi, quels pauvres idiots. %objective2% nous attend. | Alors que le dernier wiederganger est tué, et le dernier voleur idiot à ses côtés, vous vous sentez revigorer. Une partie de ce sentiment est de montrer à ces brigands quel horrible chef ils avaient pour les faire tous tuer comme ça. L\'autre partie est sans doute le bon sentiment qu\'un mal qui s\'en va a laissé derrière lui. Il est temps d\'aller à %objective2%. | La victoire a été durement remportée. Les morts-vivants se sont bien battus. Les brigands sont morts comme les idiots qu\'ils étaient. Vous espérez que %objective2% sera plus facile à nettoyer, mais à moins qu\'il ne soit rempli de voleurs idiots au lieu de morts-vivants, vous en doutez. | Vous trouvez le chef des brigands étendu sur le cadavre d\'un wiederganger. %randombrother% s\'approche et rit. %SPEECH_ON%On dirait qu\'ils étaient faits pour être ensemble.%SPEECH_OFF%En riant, vous lui dites de préparer les hommes pour une marche vers %objective2%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ça leur apprendra.",
					function getResult()
					{
						this.Flags.set("IsBandits3Way", false);

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% vous accueille dans sa chambre avec des gobelets levés et des femmes qui applaudissent. C\'est un spectacle vivant pour un monde rempli de morts-vivants. Le noble très ivre vous remet des couronnes %reward_completion% et l\'un de ses gardes vous raccompagne. | Vous entrez dans le bureau de %employer% pour trouver l\'homme et une femme debout autour d\'une table. Un enfant très pâle est sur la table et ne bouge pas. La mère pleure en silence, son visage ne faisant que gémir. Vous rompez l\'ambiance sombre en signalant au noble que votre tâche est terminée. Il acquiesce.%SPEECH_ON%Je sais. Il y avait des rumeurs selon lesquelles, une fois que vous seriez revenu, il serait possible pour le mal éteint d\'insuffler une nouvelle vie aux terres. Les sols sont plus riches que jamais, mais les morts restent toujours morts. Ta paie est dans le coin, mercenaire.%SPEECH_OFF%Vous allez récupérer vos %reward_completion% couronnes. %employer% est toujours en train de consoler la femme quand vous partez. | Un garde vous emmène dans une des cachettes de %employer%, un endroit carré qui ressemble plus à une pièce qu\'à un lieu. Le noble a le nez plongé dans un parchemin, mais il se redresse en vous voyant.%SPEECH_ON%Mercenaire ! Je vous attendais ! Entrez, entrez.%SPEECH_OFF%Il met de côté les écrits et ramasse une sacoche sur le sol.%SPEECH_ON%%reward_completion% couronnes comme convenu. Il y a eu des rumeurs selon lesquelles le mal aurait quitté ces terres. Je n\'en suis pas si sûr, mais il y a peu de doute que votre victoire a assuré au moins un avantage dans cette guerre. Bon travail, mercenaire.%SPEECH_OFF% | %employer% vous fait signe d\'entrer dans son bureau d\'une main et vous tend un sac de couronnes de l\'autre.%SPEECH_ON%Vous n\'avez pas besoin de me faire un rapport, mercenaire, car mes oiseaux m\'ont déjà tout dit. Votre paiement, comme convenu.%SPEECH_OFF% | %employer% vous accueille chaleureusement, bien qu\'un scribe au visage d\'épervier se penche rageusement dans un coin comme si vous étiez un plus gros charognard venu le chasser d\'un repas. Vous rapportez ce que vous avez fait, mais le noble l\'ignore.%SPEECH_ON%Oh, mercenaire, je sais tout ce qui se passe dans ce pays. Vous avez bien mérité ces %reward_completion% couronnes.%SPEECH_OFF%Le scribe parle, faisant sursauter %employer%.%SPEECH_ON%En effet, les maux ont été anéantis et tout ce qui est bon peut se développer ! Maintenant, mercenaire, s\'il vous plaît partez. Nous avons des choses importantes à discuter ici.%SPEECH_OFF%Hmm, oui, bien sûr. Vous prenez votre paie et vous partez. | Vous trouvez %employer% dans les écuries. Les stalles sont vidées et il n\'y a pas de palefreniers dans les parages. En vous voyant, il vous serre rapidement la main.%SPEECH_ON%Je suis si heureux de vous voir, mercenaire. J\'ai déjà eu vent de votre succès. Vous avez libéré cette terre des chaînes du mal et lui avez redonné vie et vitalité. Pour l\'instant, en tout cas. Marchez vers ce garde là-bas et il vous conduira au trésorier pour les %reward_completion% couronnes qui vous sont dues.%SPEECH_OFF% | Vous trouvez %employer% debout sur une tombe fraîchement recouverte. Quelques soldats sont assis à proximité et se partagent une gourde en peau de chèvre. Le noble hausse les épaules.%SPEECH_ON%Le corps est resté dans la terre. Donc non seulement vous avez détruit les sources du mal, mercenaire, mais il est fort possible que vous en ayez carrément chassé une partie de ces terres. Par les dieux, je l\'espère. Votre paie est avec le trésorier. Il aura %reward_completion% couronnes pour vous comme promis.%SPEECH_OFF% | Vous trouvez %employer% en train de parler à un apothicaire. Le guérisseur a un chariot rempli d\'outils tranchants, dont certains sont plongés dans un bassin d\'eau rouge. En jetant un coup d\'œil au noble, vous voyez qu\'il vient de se faire recoudre un bras. Il vous fait signe d\'entrer.%SPEECH_ON%La chasse au sanglier qui a mal tourné, mercenaire.%SPEECH_OFF%Le guérisseur nettoie et s\'en va, disant au noble de ne pas bouger pendant une semaine.%SPEECH_ON%Ouais ouais, eh bien j\'ai des affaires à régler. La première étant vous, mercenaire. Votre paie est dans le coin, %reward_completion% couronnes comme promis. Qui sait si le fléau des morts-vivants a vraiment été chassé de ces terres, mais vous avez fait ce qu\'on vous demandait.%SPEECH_OFF% | %employer% est en train de parler à une femme quand vous entrez. Elle fait la déclaration la plus étrange que vous ayez entendue depuis longtemps.%SPEECH_ON%Mon petit garçon est resté dans le sol ! Il n\'est pas revenu ! Je suis si heureuse ! Il est resté mort !%SPEECH_OFF%Le noble lui tient les mains chaleureusement et fait un signe de tête vers vous.%SPEECH_ON%Et voici l\'homme chargé de chasser le mal de ces terres. Vous avez gagné ces %reward_completion% couronnes, mercenaire !%SPEECH_OFF% | Vous voyez %employer% jouer avec un chiot. Il gambade, pataugeant sur le sol de pierre lisse pour poursuivre un bâton. Le noble lance le bâton à vos pieds et le chiot saute dessus, s\'écrasant sur vos bottes.%SPEECH_ON%Ce chien n\'aurait pas bougé l\'autre jour, mais maintenant il n\'arrête pas de jouer. Si j\'étais joueur, je parierais que ça a quelque chose à voir avec vous et ces morts-vivants, mercenaire. Bon travail. Votre salaire est de %reward_completion% couronnes, comme promis, ou vous pouvez prendre le chiot.%SPEECH_OFF%Vous dites que vous allez prendre le chiot. Le noble recule avec surprise.%SPEECH_ON%Non, vous prendrez les couronnes. Le chiot reste avec moi.%SPEECH_OFF%Woof. | Vous entrez dans le bureau de %employer% pour trouver l\'homme regardant par la fenêtre. Il fait une remarque avec une certaine sincérité.%SPEECH_ON%Vivant. C\'est tellement vivant.%SPEECH_OFF%Il se retourne, révélant une sacoche à la main. Il s\'approche et vous la donne.%SPEECH_ON%%reward_completion% devrait être là-dedans. Bon travail avec les morts-vivants, mercenaire, et que vos services ici nous rapprochent un peu plus de la fin de ce mal.%SPEECH_OFF% | %employer% vous accueille avec un pichet de vin. Il a un goût métallique, mais vous ne faites pas de commentaires à ce sujet. Le noble se déplace d\'un pas alerte vers son bureau.%SPEECH_ON%Bon travail, mercenaire. Qui sait ce qu\'il serait advenu de ces terres s\'il n\'y avait pas eu des hommes comme vous. Je prie les vieux dieux qu\'un jour prochain, nous soyons complètement débarrassés de tout ce mal !%SPEECH_OFF% | Un garde vous rencontre devant la chambre de %employer%. Il vous jette un coup d\'œil, en particulier sur le badge de la compagnie %companyname% sur votre épaule.%SPEECH_ON%Ici, mercenaire. %employer% est très occupé, mais il m\'a dit de vous remercier.%SPEECH_OFF%On vous donne les %reward_completion% couronnes. | Un trésorier au teint pâle et lisse vous accueille dans les couloirs menant au bureau de %employer%. Il porte une sacoche de couronnes, qu\'il vous remet rapidement.%SPEECH_ON%Il y a votre paiement là-dedans, comme convenu. Mon seigneur est actuellement très occupé avec ses scribes pour mieux régler cet horrible problème de morts-vivants.%SPEECH_OFF% | Vous trouvez %employer% en train de se raser, une femme fatiguée et renfrognée lui tenant un miroir.%SPEECH_ON%Ooh, mercenaire. Aïe. Hé.%SPEECH_OFF%Il jette un rasoir dans une bassine d\'eau avant de se précipiter vers son bureau.%SPEECH_ON%Mes petits oiseaux m\'ont déjà raconté vos exploits. Non seulement cela, mais tout le monde semble s\'en porter mieux ! Les enfants rient à nouveau, le soleil brille, les récoltes sont soi-disant en pleine croissance ! Tout le monde est heureux !%SPEECH_OFF%La femme demande si elle peut poser le miroir. Le noble fait claquer ses doigts.%SPEECH_ON%Silence, toi. Tenez, mercenaire. %reward_completion% couronnes, comme convenu.%SPEECH_OFF% | Vous trouvez %employer% non pas dans son bureau, mais dans une pièce sombre éclairée par de maigres bougies. Dans cette pièce dégoulinante et détrempée, il y a un homme suspendu à des chaînes. À en juger par son visage, il semble qu\'il préférerait être suspendu à une corde. Le noble se tient debout, les bras derrière le dos, tandis qu\'une silhouette à la capuche noire passe un doigt indécis sur un plateau rempli lames. Vous toussez. %employer% se retourne.%SPEECH_ON%Ah oui, mercenaire ! Je vous attendais ! Tenez, %reward_completion% couronnes, comme promis. Espérons que les morts-vivants restent à l\'écart pour de bon cette fois-ci. Mais, quoi qu\'il arrive, vous avez accompli un travail immense en éliminant ce mal de ce monde.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Les forteresses des morts-vivants ont été détruites");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

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
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective1",
			this.m.Flags.get("Objective1Name")
		]);
		_vars.push([
			"objective2",
			this.m.Flags.get("Objective2Name")
		]);
		local distToObj1 = this.m.Objective1 != null && !this.m.Objective1.isNull() && this.m.Objective1.isAlive() ? this.m.Objective1.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) : 9999;
		local distToObj2 = this.m.Objective2 != null && !this.m.Objective2.isNull() && this.m.Objective2.isAlive() ? this.m.Objective2.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) : 9999;

		if (distToObj1 < distToObj2)
		{
			_vars.push([
				"objective",
				this.m.Flags.get("Objective1Name")
			]);
		}
		else
		{
			_vars.push([
				"objective",
				this.m.Flags.get("Objective2Name")
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Objective1 != null && !this.m.Objective1.isNull() && this.m.Objective1.isAlive())
			{
				this.m.Objective1.getSprite("selection").Visible = false;
				this.m.Objective1.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Objective2 != null && !this.m.Objective2.isNull() && this.m.Objective2.isAlive())
			{
				this.m.Objective2.getSprite("selection").Visible = false;
				this.m.Objective2.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Target != null && !this.m.Target.isNull() && this.m.Target.isAlive())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Current = null;
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return false;
		}

		if (this.m.IsStarted)
		{
			if (this.m.Objective1 == null || this.m.Objective1.isNull() || !this.m.Objective1.isAlive())
			{
				return false;
			}

			if (this.m.Objective2 == null || this.m.Objective2.isNull() || !this.m.Objective2.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			return true;
		}
	}

	function onSerialize( _out )
	{
		if (this.m.Objective1 != null && !this.m.Objective1.isNull())
		{
			_out.writeU32(this.m.Objective1.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Objective2 != null && !this.m.Objective2.isNull())
		{
			_out.writeU32(this.m.Objective2.getID());
		}
		else
		{
			_out.writeU32(0);
		}

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
		local obj1 = _in.readU32();

		if (obj1 != 0)
		{
			this.m.Objective1 = this.WeakTableRef(this.World.getEntityByID(obj1));
		}

		local obj2 = _in.readU32();

		if (obj2 != 0)
		{
			this.m.Objective2 = this.WeakTableRef(this.World.getEntityByID(obj2));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});


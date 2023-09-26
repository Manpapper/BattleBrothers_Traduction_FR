this.big_game_hunt_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Size = 0,
		Dude = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.big_game_hunt";
		this.m.Name = "Big Game Hunt";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
		this.m.MakeAllSpawnsResetOrdersOnceDiscovered = true;
		this.m.DifficultyMult = 1.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function setup()
	{
		local r = this.Math.rand(1, 100);

		if (r <= 40)
		{
			this.m.Size = 0;
			this.m.DifficultyMult = 0.75;
		}
		else if (r <= 75 || this.World.getTime().Days <= 30)
		{
			this.m.Size = 1;
			this.m.DifficultyMult = 1.0;
		}
		else
		{
			this.m.Size = 2;
			this.m.DifficultyMult = 1.2;
		}
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		local maximumHeads;
		local priceMult = 1.0;

		if (this.m.Size == 0)
		{
			local priceMult = 1.0;
			maximumHeads = [
				15,
				20,
				25,
				30
			];
		}
		else if (this.m.Size == 1)
		{
			local priceMult = 4.0;
			maximumHeads = [
				10,
				12,
				15,
				18,
				20
			];
		}
		else
		{
			local priceMult = 8.0;
			maximumHeads = [
				8,
				10,
				12,
				15
			];
		}

		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult() * priceMult;
		this.m.Payment.Count = 1.0;
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		local settlements = this.World.FactionManager.getFaction(this.m.Faction).getSettlements();
		local other_settlements = this.World.EntityManager.getSettlements();
		local regions = this.World.State.getRegions();
		local candidates_first = [];
		local candidates_second = [];

		foreach( i, r in regions )
		{
			local inSettlements = 0;
			local nearSettlements = 0;

			if (r.Type == this.Const.World.TerrainType.Snow || r.Type == this.Const.World.TerrainType.Mountains || r.Type == this.Const.World.TerrainType.Desert || r.Type == this.Const.World.TerrainType.Oasis)
			{
				continue;
			}

			if (!r.Center.IsDiscovered)
			{
				continue;
			}

			if (this.m.Size == 2 && r.Type != this.Const.World.TerrainType.Steppe && r.Type != this.Const.World.TerrainType.Forest && r.Type != this.Const.World.TerrainType.LeaveForest && r.Type != this.Const.World.TerrainType.AutumnForest)
			{
				continue;
			}

			if (r.Discovered < 0.5)
			{
				this.World.State.updateRegionDiscovery(r);
			}

			if (r.Discovered < 0.5)
			{
				continue;
			}

			foreach( s in settlements )
			{
				local t = s.getTile();

				if (t.Region == i + 1)
				{
					inSettlements = ++inSettlements;
				}
				else if (t.getDistanceTo(r.Center) <= 20)
				{
					local skip = false;

					foreach( o in other_settlements )
					{
						if (o.getFaction() == this.getFaction())
						{
							continue;
						}

						local ot = o.getTile();

						if (ot.Region == i + 1 || ot.getDistanceTo(r.Center) <= 10)
						{
							skip = true;
							break;
						}
					}

					if (!skip)
					{
						nearSettlements = ++nearSettlements;
					}
				}
			}

			if (nearSettlements > 0 && inSettlements == 0)
			{
				candidates_first.push(i + 1);
			}
			else if (inSettlements > 0 && inSettlements <= 1)
			{
				candidates_second.push(i + 1);
			}
		}

		local region;

		if (candidates_first.len() != 0)
		{
			region = candidates_first[this.Math.rand(0, candidates_first.len() - 1)];
		}
		else if (candidates_second.len() != 0)
		{
			region = candidates_second[this.Math.rand(0, candidates_second.len() - 1)];
		}
		else
		{
			region = settlements[this.Math.rand(0, settlements.len() - 1)].getTile().Region;
		}

		this.m.Flags.set("Region", region);
		this.m.Flags.set("HeadsCollected", 0);
		this.m.Flags.set("StartDay", 0);
		this.m.Flags.set("LastUpdateDay", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				this.Contract.m.BulletpointsObjectives.clear();

				if (this.Contract.m.Size == 0)
				{									if (this.Const.DLC.Desert)
					{
						this.Contract.m.BulletpointsObjectives.push("Chassez des Loups-Garous, des Webknechts, des Nachzehrers, des Hyènes et des Serpents");
					}
					else
					{
						this.Contract.m.BulletpointsObjectives.push("Chassez des Loups-Garous, des Webknechts et des Nachzehrers");
					}
					
				}
				else if (this.Contract.m.Size == 1)
				{
					this.Contract.m.BulletpointsObjectives.push("Chassez des Alps, des Unholds et des Hexen");
				}
				else
				{
					this.Contract.m.BulletpointsObjectives.push("Chassez des Schrats et des Lindwurms");
				}

				this.Contract.m.BulletpointsObjectives.push("Chassez aux alentours de %regiontype% region de %worldmapregion% et d\'autres régions");
				this.Contract.m.BulletpointsObjectives.push("Retournez à %townname% à tout moment pour être payés");

				if (this.Contract.m.Size == 0)
				{
					this.Contract.setScreen("TaskSmall");
				}
				else if (this.Contract.m.Size == 1)
				{
					this.Contract.setScreen("TaskMedium");
				}
				else
				{
					this.Contract.setScreen("TaskLarge");
				}
			}

			function end()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				local action = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getAction("send_beast_roamers_action");
				local options;

				if (this.Contract.m.Size == 0)
				{
					options = action.m.BeastsLow;
				}
				else if (this.Contract.m.Size == 1)
				{
					options = action.m.BeastsMedium;
				}
				else
				{
					options = action.m.BeastsHigh;
				}

				local nearTile = this.World.State.getRegion(this.Flags.get("Region")).Center;

				for( local i = 0; i < 3; i = ++i )
				{
					for( local tries = 0; tries++ < 1000;  )
					{
						if (options[this.Math.rand(0, options.len() - 1)](action, nearTile))
						{
							local party = action.getFaction().getUnits()[action.getFaction().getUnits().len() - 1];
							party.setAttackableByAI(false);
							this.Contract.m.UnitsSpawned.push(party.getID());
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(15.0);
							party.getController().addOrderInFront(wait);
							local footPrintsOrigin = this.Contract.getTileToSpawnLocation(nearTile, 4, 8);
							this.Const.World.Common.addFootprintsFromTo(footPrintsOrigin, party.getTile(), this.Const.BeastFootprints, party.getFootprintType(), party.getFootprintsSize(), 1.1);
							break;
						}
					}
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

				if (this.Contract.m.Size == 0)
				{
					if (this.Const.DLC.Desert)
					{
						this.Contract.m.BulletpointsObjectives.push("Chassez des Loups-Garous, des Webknechts, des Nachzehrers, des Hyènes et des serpents autour de %regiontype% région de %worldmapregion% (%killcount%/%maxcount%)");
					}
					else
					{
						this.Contract.m.BulletpointsObjectives.push("Chassez des Loups-Garous, des Webknechts et des Nachzehrers autour de %regiontype% région de %worldmapregion% (%killcount%/%maxcount%)");
					}
				}
				else if (this.Contract.m.Size == 1)
				{
					this.Contract.m.BulletpointsObjectives.push("Chassez des Alps, des Unholds et des Hexen autour de %regiontype% région de %worldmapregion% (%killcount%/%maxcount%)");
				}
				else
				{
					this.Contract.m.BulletpointsObjectives.push("Chassez des Schrats et des Lindwurms autour de %regiontype% région de %worldmapregion% (%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("Retournez à %townname% a n\'importe quel moment pour être payés");
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home) && this.Flags.get("HeadsCollected") != 0)
				{
					if (this.Contract.m.Size == 0)
					{
						this.Contract.setScreen("SuccessSmall");
					}
					else if (this.Contract.m.Size == 1)
					{
						this.Contract.setScreen("SuccessMedium");
					}
					else
					{
						this.Contract.setScreen("SuccessLarge");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_killer != null && _killer.getFaction() != this.Const.Faction.Player && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
				{
					return;
				}

				if (this.Flags.get("HeadsCollected") >= this.Contract.m.Payment.MaxCount)
				{
					return;
				}

				if (this.Contract.m.Size == 0)
				{
					if (_actor.getType() == this.Const.EntityType.Ghoul || _actor.getType() == this.Const.EntityType.Direwolf || _actor.getType() == this.Const.EntityType.Spider || _actor.getType() == this.Const.EntityType.Hyena || _actor.getType() == this.Const.EntityType.Serpent)
					{
						this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
					}
				}
				else if (this.Contract.m.Size == 1)
				{
					if (_actor.getType() == this.Const.EntityType.Alp || _actor.getType() == this.Const.EntityType.Unhold || _actor.getType() == this.Const.EntityType.UnholdFrost || _actor.getType() == this.Const.EntityType.UnholdBog || _actor.getType() == this.Const.EntityType.Hexe)
					{
						this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
					}
				}
				else if (_actor.getType() == this.Const.EntityType.Lindwurm && !this.isKindOf(_actor, "lindwurm_tail") || _actor.getType() == this.Const.EntityType.Schrat)
				{
					this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
				}
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationPerHead);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "TaskSmall",
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_63.png[/img]{Vous entrez dans la pièce de %employer%. L\'homme se tripote les doigts avec une plume de paon, agitant ses couleurs d\'un côté et repoussant la saleté de l\'autre. Il parle plutôt dédaigneusement de votre présence.%SPEECH_ON%Mes gardes m\'ont déjà informé que vous étiez intéressé par une chasse à la bête et j\'en suis très heureux. Le salaire sera versé par tête. Des bêtes plus petites, des webknechts, des mangeurs de cadavres, le genre de choses qui, j\'en suis sûr, ne vous dérange pas, mais que les habitants ont trop peur d\'affronter. Si vous êtes aussi bon dans votre travail que les gens semblent le dire, vous ne devriez pas hésiter à sauter sur cette offre. Débarrasser mes terres de tous ceci. Pour commencer, il y a eu des observations dans la région de %worldmapregion% %distance% %direction% d\'ici.%SPEECH_OFF% | %employer% vous accueille dans sa chambre. Il prend un parchemin que le crieur public vous a donné en vous promenant sur les marchés un peu plus tôt.%SPEECH_ON%Ah, Vous êtes ici pour la chasse à la bête, alors. Je pensais que vous étiez un divertissement de...%SPEECH_OFF%Il pince le côté de votre chemise et esquisse un sourire.%SPEECH_ON%Une autre sorte. Quoi qu\'il en soit, des bêtes ravagent la campagne et je vous paierai volontiers une somme rondelette pour vous en occuper. La rémunération se fera par tête, bien sûr, ce qui vous permettra de gagner beaucoup d\'argent si vous gardez votre lame bien éguisée. Si vous avez besoin d\'un endroit pour commencer votre chasse, Voyagez jusqu\'à la région de %worldmapregion% %distance% %direction% d\'ici. Vous y trouverez un tas de grands monstres à huit pattes et de monstres à fourrure. Tout ce qui peut effrayer un simple agriculteur n\'est pas trop effrayant pour vous, grand homme.%SPEECH_OFF% | Vous trouvez %employer% avec ses pieds sans bottes sur une table, une foule de femmes les retaillants. Ils retirent des morceaux de terre épaissie d\'entre ses orteils comme s\'il s\'agissait des rites de naissance d\'une monstruosité imaginaire. Vous vous raclez la gorge. L\'homme s\'éclaircit la gorge en signe de surprise.%SPEECH_ON%Ah oui, les mercenaires. J\'ai une tâche à vous confier si vous êtes intéressé.%SPEECH_OFF%Il jette dédaigneusement à vos pieds un parchemin qui mentionne un besoin de tuer des bêtes. Webknechts. Des loups affamés. Rien de bien effrayant. Une note sur la carte indique la région voisine de %worldmapregion% à la %direction%. L\'homme rote.%SPEECH_ON%Le salaire est par tête, j\'espère que ça vous va.%SPEECH_OFF% | Vous trouvez %employer% faisant tourner un couteau dans sa main. La séparation entre la poignée et l\'endroit où aurait dû se trouver la lame est clairement éclatée, ce qui témoigne de la fin décisive de l\'utilisation de l\'arme. L\'homme le jette sur sa table et fait tomber de la sciure de bois de ses mains.%SPEECH_ON%Des bêtes rôdent dans les parages et j\'ai besoin de quelqu\'un de votre trempe pour les tuer toutes. Qu\'en dites-vous ? La rémunération se fera à la tête. Toutes sortes de petites bêtes y causent des nuisances.%SPEECH_OFF% | %employer% vous accueille dans sa chambre. Sa table est couverte de parchemins, chacun avec des dessins d\'animaux et de bêtes, voire de monstres. Il mâchonne des baies et crache du jus en parlant.%SPEECH_ON%Les habitants de la région disent qu\'il se passe des choses abominables, mais aucun d\'entre eux ne veut me donner une description précise de ce qu\'est le problème. Quelque chose à propos de loups monstrueux ou de monstres à huit pattes. Je peux difficilement rester sans rien faire, c\'est pourquoi je fais appel à vos services. Rendez-vous au fief de %worldmapregion% %distance% %direction%. Si vous voyez des bêtes, tuez-les sur place et prenez leur tête. Je paierai au scalp.%SPEECH_OFF% | %employer% vous retrouve alors qu\'il est en réunion avec un groupe de fermiers. Il affirme que de prétendus monstres mettent l\'arrière-pays en pièces. Un fermier prend la parole.%SPEECH_ON%Des bêtes, des tas de bêtes. Des loups qui marchent sur leurs pattes arrière, des araignées yea de grosses choses mangeuses de cadavres qui puent l\'écume.%SPEECH_OFF%Le noble fait un signe de la main.%SPEECH_ON%Oui, oui, ça suffit. Mercenaires, j\'ai besoin que vous partiez à la chasse de ces créatures. Commencez par vous rendre dans la région de %worldmapregion% au %direction% d\'ici et veillez à ce que les bêtes qui se promènent soient abattues. Mais n\'oubliez pas de ramener leurs têtes, je vous paierai pour chacune d\'entre elles. Enfin, si vous êtes intéressé, bien sûr.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{De combien de Couronnes parlent-on ici? | Je pourrais être persuadé pour le bon prix. | Continuez. | Combien vaut la sureté de vos sujets pour vous?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{C\'est trop de marche à mon goût. | Nous n\'avons pas l\'intention de chasser les fantômes. %worldmapregion%. | Ce n\'est pas le genre de travail que nous recherchons.}",
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
		this.m.Screens.push({region %direction% of here and see if anything strange is afoot.
			ID = "TaskMedium",
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% est en train de feuilleter les pages d\'un ouvrage lorsque vous entrez. Il lève les yeux et vous fait signe de venir.%SPEECH_ON%Apporter une bougie.%SPEECH_OFF%Vous enlevez une torche du mur et le noble tend les mains en avant.%SPEECH_ON%J\'ai dit une bougie, pas une foutue torche ! Que voulez-vous faire, réduire en cendres tous les livres que j\'ai ? Restez où vous êtes. Ecoutez, les gens autour ont parlé de maux dont je n\'avais pas entendu parler depuis des années. Des monstres qui s\'attaquent à vos rêves, des géants si grands qu\'un homme pourrait tenir dans leur barbe, et le pire d\'entre eux, bien sûr, de belles femmes qui savent qu\'elles sont belles.%SPEECH_OFF%Vous n\'êtes pas sûr à propos de la dernière chose, mais vous ne le dites pas. Le noble poursuit en expliquant que vous devez tuer tous les crétins que vous trouverez dans son royaume. Il a été vue des choses à %worldmapregion% dans la %direction%, mais vous êtes libre de chasser les créatures à votre guise, où qu\'elles se cachent. | Vous trouvez %employer% en assemblée avec un certain nombre d\'hommes en cape noire. Ils vous demandent de venir, ce que vous faites à contrecœur. Le noble vous demande si vous connaissez des monstres comme les unholds, ou des créatures qui se nourrissent de rêves. Avant que vous ne puissiez répondre, il fait un signe de la main.%SPEECH_ON%Peu importe. J\'ai besoin d\'hommes armés pour passer au peigne fin la région %worldmapregion% region %direction% d\'ici et voir si quelque chose d\'étrange se prépare.  Si ce n\'est pas un humain avec un coeur qui bat, tuez-le. Prenez sa tête. Et revenez me voir. Je vous paierai généreusement pour chaque tête. S\'ils existent, bien sûr.%SPEECH_OFF% | %employer% pèse des parchemins dans ses deux mains, ne lisant ni l\'un ni l\'autre tandis qu\'il fixe un troisième sur son bureau. Finalement, il jette les deux parchemins et jette le dernier à la poubelle. Il vous regarde.%SPEECH_ON%La rumeur se répand que des monstres sont à l\'œuvre. Des hommes géants qui mangent du bétail et des enfants. On rapporte que des gens font des cauchemars et tuent leurs voisins à cause d\'eux. Et puis, on parle beaucoup d\'une belle femme dans la région. Je ne sais pas s\'il s\'agit d\'une créature immonde, mais une belle femme qui habite %worldmapregion% dans la %direction% d\'ici me semble être une source d\'ennuis.%SPEECH_OFF%Vous acquiescez. Une femme seule dans une région inconnue, c\'est certainement un problème pour quelqu\'un. Le noble écarte les bras.%SPEECH_ON%Voudriez-vous emmener vos hommes sur cette terre et trouver la frontière entre la vérité et la fiction ? Et si vous trouvez quelque chose qui glisse, qui siffle ou qui n\'est pas humain, tuez cette maudite chose et apportez-moi sa tête.%SPEECH_OFF% | Vous trouvez %employer% en train de feuilleter des livres avec une bougie si près de la page que la pénombre pâlit sur les bords du tome.C\'est comme si lui seul devait lire les textes. En vous voyant, il vous fait signe d\'avancer.%SPEECH_ON%Nous avons des rapports sur des événements étranges dans la région de %worldmapregion% à la %direction%. Les meurtres sont en hausse et je ne sais pas pourquoi. Et puis il y a des gens qui disparaissent purement et simplement. Ce n\'est jamais bon signe. Je ne sais pas si c\'est une secte ou une créature qui est responsable, mais j\'ai besoin d\'hommes armés pour aller sur ces terres et mettre les choses au clair. Si vous croisez de l\'acier avec quelque chose d\'étrange, apportez-moi sa tête, car je vous paierai très cher. %SPEECH_OFF% | %employer% se trouve en haut d\'une échelle, en train de fouiller dans l\'étagère la plus haute qu\'il possède. Il secoue la tête et vous fait signe d\'entrer.%SPEECH_ON%Je n\'ai pas la moindre idée de ce que je cherche.%SPEECH_OFF%Vous acquiescez et lui dites de rejoindre le club. L\'homme descend.%SPEECH_ON%Très drôle, mercenaire. Ecoutez, j\'ai eu vent d\'évènements dans la région de %worldmapregion% %distance% %direction% d\'ici. Il n\'y a pas beaucoup de gens qui vivent dans cette région, mais ceux qui y vivent parlent d\'horreurs absolues qui parcourent le pays. Des hommes géants, des esprits qui infestent leurs rêves, et j\'en passe. J\'ai besoin que vous preniez votre groupe d\'hommes et que vous fassiez taire ce qui "bouillonne", d\'accord ? Et apportez-moi les têtes de toutes les monstruosités inhumaines que vous trouverez. Je vous paierai bien pour chacune d\'entre elles.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{De combien de Couronnes parlent-on ici? | Je pourrais être persuadé pour le bon prix. | Continuez. | Combien vaut la sureté de vos sujets pour vous?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Cela fait trop de marche à mon goût. | Nous ne sommes pas prêts à chasser les fantômes dans %worldmapregion%. | Ce n\'est pas le genre de travail que nous recherchons.}",
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
			ID = "TaskLarge",
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% est assis à un bureau. Il n\'y a personne d\'autre dans la pièce. Il vous propose un siège que vous prenez. Il se penche en avant.%SPEECH_ON%Ma famille a une sorte de légende. Mon père a rencontré cette légende, ainsi que le père de mon père. Nous ne savons pas d\'où vient cette légende. Je m\'attendais à voir cette légende à mon époque et j\'ai l\'impression que c\'est le cas. Dans un rêve, la nuit dernière.%SPEECH_OFF%En entendant cela, vous êtes au bord de votre siège parce qu\'il y a un trou au milieu. Vous acquiescez et il continue.%SPEECH_ON%Voyagez jusqu\'à %worldmapregion% à %direction%. Je crois que les légendes sont vraies, qu\'une énorme bête erre sur ces terres. Peut-être même plus qu\'une seule ! Quoi qu\'il en soit, j\'ai besoin du plus expérimenté des mercenaires pour la débusquer. Apportez-moi des têtes et vous serez largement récompensés. Êtes-vous prêt ? %SPEECH_OFF% | Vous entrez dans la chambre de %employer%\. Il vous tend un parchemin sur lequel figure un alphabet que vous ne pouvez pas lire. Le noble affirme qu\'il s\'agit d\'un passage de légende. Il écarte les bras.%SPEECH_ON%Des bêtes de la taille d\'un arbre parcourent ces terres, je le crois. %direction% d\'ici se trouve la région de %worldmapregion%. Les paysans y parlent de monstruosités comme vous n\'en croiriez pas vos yeux. Mais j\'aimerais y croire. J\'aimerais en voir un de près, c\'est pourquoi je vous ai convoqué ici. Allez dans cet horrible territoire et veillez à ce que toute créature immonde soit tuée et que sa tête soit placée à mes pieds.%SPEECH_OFF% | %employer% vous accueille dans sa chambre puis passe directement aux choses sérieuses.%SPEECH_ON%J\'ai besoin que vous vous dirigiez %direction% vers la région de %worldmapregion%. J\'ai enregistré de nombreuses rumeurs concernant d\'énormes bêtes qui rôderaient dans cette région et je les crois sur parole. Des serpents de la taille d\'un arbre et des imitations d\'arbres également de la taille d\'un arbre ! Quoi qu\'il en soit, je veux que vous les tuiez et que vous m\'apportiez leurs têtes. Ou des écailles, des branches, peu importe. Je paierai pour chacun d\'entre eux. Cela vous intéresse-t-il ? %SPEECH_OFF% | %employer% vous tend un tome dont certaines pages sont écornées. Vous pensez qu\'il s\'agit là d\'un dangereux affront à un ouvrage qui est décidément rare, mais vous vous mordez la langue à ce sujet. Le noble vous demande si vous connaissez des géants, des dragons, des monstres marins, etc.Avant que vous ne puissiez répondre, %employer% pose son doigt sur la page ouverte du livre. Son doigt frappe le dessin d\'une bête plus grande qu\'un chêne, en partie parce qu\'elle ressemble à un chêne.%SPEECH_ON%Je pense qu\'ils existent. Je pense qu\'ils sont là-bas, dans la %région de la carte du monde% en ce moment même, à %direction% d\'ici. Mercenaire, je veux que tu te rendes là-bas et que tu tues toutes les créatures immondes que tu trouveras. Apportez-moi leurs têtes. Les dangers ne sont pas mesurables, mais les énormes récompenses le seront. Pensez-vous en être capable ? %SPEECH_OFF% | %employer% vous accueille avec le visage d\'un homme sur le point d\'envoyer quelqu\'un à une mort certaine. Il sourit quand même parce que ce n\'est pas sa mort.%SPEECH_ON%Ah, c\'est bon de voir un homme d\'épée. Comme je suis sûr que vous l\'avez entendu, des rumeurs circulent sur le fait que la région de %worldmapregion% est absolument pleine de bêtes immondes.%SPEECH_OFF%Vous n\'êtes pas sûr que ce soit le langage que vous utiliseriez, mais vous acquiescez tout de même. Le noble acquiesce en retour.%SPEECH_ON%IJ\'ai peu d\'hommes en qui j\'ai confiance dans ce monde et l\'un d\'entre eux a récemment rapporté avoir vu une créature d\'une énormité sans commune mesure, bien qu\'il l\'ait estimée aussi haute qu\'un arbre. Et un autre éclaireur a dit que des serpents de la taille d\'un dragon se promenaient dans les environs. Quoi qu\'il en soit, j\'ai besoin que vous voyagiez jusqu\'à la terre %direction% d\'ici et que vous tuiez ce qui la hante. D\'après les rapports, cela pourrait être la chose la plus dangereuse que vous ferez dans cette vie. Êtes-vous prêts ? Vos hommes sont-ils prêts ? Je n\'engagerai pas quelqu\'un qui hésite le moins du monde.%SPEECH_OFF%}  ",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{De combien de Couronnes parlent-on ici? | Ce n\'est pas une tâche facile à demander. | Je pourrais être persuadé pour le bon prix. | Pour une tâche pareil la paie à intérêt à bien payer. | Combien vaut la sureté de vos sujets pour vous?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Nous n\'avons pas l\'intention de chasser les fantômes vers %worldmapregion%. | Ce n\'est pas le genre de travail que nous recherchons. | Je ne veux pas risquer la compagnie contre un tel ennemi.}",
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
			ID = "SuccessSmall",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous revenez et vous jetez les têtes des bêtes sur le sol de %employer%\. Il lève les yeux de son bureau.%SPEECH_ON%Ce n\'était pas nécessaire. Donnez-lui son argent et faites venir un serviteur pour nettoyer ce bordel.%SPEECH_OFF% | %employer% accueille chaleureusement votre retour, même s\'il garde ses distances. Il regarde votre cargaison.%SPEECH_ON%Un retour en bonne et due forme, mercenaire. Je demanderai à l\'un de mes hommes de compter les têtes et de te payer selon notre accord. %SPEECH_OFF% | Les tueries sont présentées à l\'approbation de %employer%. Il acquiesce et vous fait signe de partir.%SPEECH_ON%J\'apprécie, mais je n\'ai pas besoin de regarder ces choses horribles un instant de plus. %SPEECH_OFF% | %employer% vous accueille et regarde votre marchandise.%SPEECH_ON%Absolument dégoûtant. Splendide ! Voici votre salaire, comme convenu.%SPEECH_OFF% | Vous montrez les têtes à %employer% qui les compte en remuant le doigt et en chuchotant des chiffres du bout des lèvres. Finalement, il se redresse.%SPEECH_ON%Je n\'ai pas le temps pour ces conneries. %randomname%, oui, toi le serviteur, viens ici, compte ces têtes et paie au mercenaire le montant convenu pour chacune d\'entre elles.%SPEECH_OFF% |  %employer% mange une pomme et s\'approche pour voir ce que vous avez ramené. Il regarde fixement la sacoche contenant des têtes de bêtes effroyables. Il prend une énorme bouchée de la pomme.%SPEECH_ON%Ehpressive rehsalts, sehswahrd.%SPEECH_OFF%Il mâche rapidement et avale d\'un trait.%SPEECH_ON%Voyez mon serviteur qui se tient là, sans rien faire, avec la bourse. Il va vous payer ce qui vous est dû.%SPEECH_OFF%Le noble jette la pomme à moitié mangée et va en chercher une autre. | %employer% est accompagné d\'un enfant lorsque vous entrez dans sa chambre. L\'enfant se précipite pour voir ce que vous avez apporté, puis se sauve en hurlant. Le noble acquiesce.%SPEECH_ON%Je suppose que cela signifie que vous avez trouvé ce pour quoi je vous ai payé. Mon serviteur %randomname% comptera les têtes et vous paiera ce qui vous est dû.%SPEECH_OFF% | Vous transportez les têtes dans la chambre de %employer%. Il hausse un sourcil.%SPEECH_ON%Tu as dû les traîner jusqu\'ici ? Regarde, tu as laissé une tache ! Pourquoi ne pas aller chercher un domestique, ils sont là pour ça. Par les dieux, l\'odeur est pire que les taches !%SPEECH_OFF%Le noble claque des doigts à un homme debout avec une bourse.%SPEECH_ON%%randomname%, compte les têtes et veille à ce que le mercenaire reçoive son salaire.%SPEECH_OFF% | Vous ouvrez le sac de têtes et vous les laissez en tas sur le sol de %employer%. Il se lève.%SPEECH_ON%Ce n\'est pas sur le tapis, n\'est-ce pas ? %SPEECH_OFF%Un serviteur se précipite et écarte les têtes d\'un coup de pied. Il secoue rapidement la tête pour dire non. Le noble acquiesce et s\'assoit lentement.%SPEECH_ON%Bien. Toi, %randomname%, tu te mets à compter et tu paies ton dû à ce mercenaire qui fout le bordel. Et au fait, mercenaire, vas-y mollo sur la présentation la prochaine fois, d\'accord ? %SPEECH_OFF% | Vous transportez une sacoche de scalps de bêtes et vous vous dirigez vers la chambre de %employer%\. Vous faites sauter le couvercle et commencez à le faire basculer vers l\'avant. Les yeux d\'un serviteur s\'écarquillent et il se précipite vers l\'avant, percutant la sacoche et la faisant basculer. Le couvercle se referme sur ses doigts et il étouffe un cri.%SPEECH_ON%Merci, mercenaire, mais le noble seigneur préférerait que nous comptions ces objets sans les répandre sur le sol. Je ferai le total et je vous paierai quand j\'aurai fini.%SPEECH_OFF% | %employer% examine votre travail.%SPEECH_ON%Impressionnant. Dégoûtant. Pas vous, les bêtes. Je veux dire que tu es un sale, mercenaire, mais ces bêtes immondes sont l\'antithèse de l\'hygiène.%SPEECH_OFF%Tu ne sais pas ce que ce mot veut dire, ni l\'autre d\'ailleurs. Vous lui demandez simplement de compter les têtes et de vous donner votre dû. | %employer% compte les têtes et se penche en arrière. Il hausse les épaules.%SPEECH_ON%Je pensais qu\'elles seraient plus effrayantes.%SPEECH_OFF%Tu précises qu\'elles ont un effet légèrement différent sur le courage d\'une personne lorsqu\'elles sont encore attachées aux torses des bêtes. Le noble hausse à nouveau les épaules.%SPEECH_ON%Je suppose que oui, mais ma mère a perdu sa tête à cause de la lame d\'un bourreau et elle avait l\'air d\'autant plus effrayante, installée dans ce panier, à regarder le monde.%SPEECH_OFF%On ne sait pas quoi répondre à ça. Tu demandes à l\'homme de te payer ce qu\'il te doit. | %employer% regarde les têtes de bêtes que vous avez déposées sur son sol. Un serviteur muni d\'un balai les compte une à une, soustrayant d\'une pile pour en ajouter à une autre. Lorsqu\'il a terminé ses comptes, il les rapporte et le noble hoche la tête.%SPEECH_ON%Bon travail, mercenaire. Le serviteur va chercher votre salaire.%SPEECH_OFF%L\'homme de basse naissance soupire et range son balai. | %employer% ouvre la sacoche de scalps et de crânes de bêtes. Il pince les lèvres, renifle et referme la sacoche. Le noble demande à l\'un de ses serviteurs de compter les restes et de vous payer conformément à l\'accord.%SPEECH_ON%Un bon travail, mercenaire. Les habitants de la ville me sont reconnaissants de t\'avoir payé pour t\'occuper de ça.%SPEECH_OFF% | %employer% siffle en regardant ta collection de crânes et de scalps.%SPEECH_ON%C\'est un sacré boulot. Pour un travail de cette nature, je devrais envisager de vous payer un supplément, ce qui n\'est pas le cas, mais l\'idée m\'a traversé l\'esprit et c\'est ce qui compte vraiment.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse réussie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Hunted beasts around " + this.World.State.getRegion(this.Flags.get("Region")).Name);
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "SuccessMedium",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous revenez et vous jetez les têtes des bêtes sur le sol de %employer%\. Il lève les yeux de son bureau.%SPEECH_ON%Ce n\'était pas nécessaire. Donnez-lui son argent et faites venir un serviteur pour nettoyer ce bordel.%SPEECH_OFF% | %employer% accueille chaleureusement votre retour, même s\'il garde ses distances. Il regarde votre cargaison.%SPEECH_ON%Un retour en bonne et due forme, mercenaire. Je demanderai à l\'un de mes hommes de compter les têtes et de te payer selon notre accord. %SPEECH_OFF% | Les tueries sont présentées à l\'approbation de %employer%. Il acquiesce et vous fait signe de partir.%SPEECH_ON%J\'apprécie, mais je n\'ai pas besoin de regarder ces choses horribles un instant de plus. %SPEECH_OFF% | %employer% vous accueille et regarde votre marchandise.%SPEECH_ON%Absolument dégoûtant. Splendide ! Voici votre salaire, comme convenu.%SPEECH_OFF% | Vous montrez les têtes à %employer% qui les compte en remuant le doigt et en chuchotant des chiffres du bout des lèvres. Finalement, il se redresse.%SPEECH_ON%Je n\'ai pas le temps pour ces conneries. %randomname%, oui, toi le serviteur, viens ici, compte ces têtes et paie au mercenaire le montant convenu pour chacune d\'entre elles.%SPEECH_OFF% |  %employer% mange une pomme et s\'approche pour voir ce que vous avez ramené. Il regarde fixement la sacoche contenant des têtes de bêtes effroyables. Il prend une énorme bouchée de la pomme.%SPEECH_ON%Ehpressive rehsalts, sehswahrd.%SPEECH_OFF%Il mâche rapidement et avale d\'un trait.%SPEECH_ON%Voyez mon serviteur qui se tient là, sans rien faire, avec la bourse. Il va vous payer ce qui vous est dû.%SPEECH_OFF%Le noble jette la pomme à moitié mangée et va en chercher une autre. | %employer% est accompagné d\'un enfant lorsque vous entrez dans sa chambre. L\'enfant se précipite pour voir ce que vous avez apporté, puis se sauve en hurlant. Le noble acquiesce.%SPEECH_ON%Je suppose que cela signifie que vous avez trouvé ce pour quoi je vous ai payé. Mon serviteur %randomname% comptera les têtes et vous paiera ce qui vous est dû.%SPEECH_OFF% | Vous transportez les têtes dans la chambre de %employer%. Il hausse un sourcil.%SPEECH_ON%Tu as dû les traîner jusqu\'ici ? Regarde, tu as laissé une tache ! Pourquoi ne pas aller chercher un domestique, ils sont là pour ça. Par les dieux, l\'odeur est pire que les taches !%SPEECH_OFF%Le noble claque des doigts à un homme debout avec une bourse.%SPEECH_ON%%randomname%, compte les têtes et veille à ce que le mercenaire reçoive son salaire.%SPEECH_OFF% | Vous ouvrez le sac de têtes et vous les laissez en tas sur le sol de %employer%. Il se lève.%SPEECH_ON%Ce n\'est pas sur le tapis, n\'est-ce pas ? %SPEECH_OFF%Un serviteur se précipite et écarte les têtes d\'un coup de pied. Il secoue rapidement la tête pour dire non. Le noble acquiesce et s\'assoit lentement.%SPEECH_ON%Bien. Toi, %randomname%, tu te mets à compter et tu paies ton dû à ce mercenaire qui fout le bordel. Et au fait, mercenaire, vas-y mollo sur la présentation la prochaine fois, d\'accord ? %SPEECH_OFF% | Vous transportez une sacoche de scalps de bêtes et vous vous dirigez vers la chambre de %employer%\. Vous faites sauter le couvercle et commencez à le faire basculer vers l\'avant. Les yeux d\'un serviteur s\'écarquillent et il se précipite vers l\'avant, percutant la sacoche et la faisant basculer. Le couvercle se referme sur ses doigts et il étouffe un cri.%SPEECH_ON%Merci, mercenaire, mais le noble seigneur préférerait que nous comptions ces objets sans les répandre sur le sol. Je ferai le total et je vous paierai quand j\'aurai fini.%SPEECH_OFF% | %employer% examine votre travail.%SPEECH_ON%Impressionnant. Dégoûtant. Pas vous, les bêtes. Je veux dire que tu es un sale, mercenaire, mais ces bêtes immondes sont l\'antithèse de l\'hygiène.%SPEECH_OFF%Tu ne sais pas ce que ce mot veut dire, ni l\'autre d\'ailleurs. Vous lui demandez simplement de compter les têtes et de vous donner votre dû. | %employer% compte les têtes et se penche en arrière. Il hausse les épaules.%SPEECH_ON%Je pensais qu\'elles seraient plus effrayantes.%SPEECH_OFF%Tu précises qu\'elles ont un effet légèrement différent sur le courage d\'une personne lorsqu\'elles sont encore attachées aux torses des bêtes. Le noble hausse à nouveau les épaules.%SPEECH_ON%Je suppose que oui, mais ma mère a perdu sa tête à cause de la lame d\'un bourreau et elle avait l\'air d\'autant plus effrayante, installée dans ce panier, à regarder le monde.%SPEECH_OFF%On ne sait pas quoi répondre à ça. Tu demandes à l\'homme de te payer ce qu\'il te doit. | %employer% regarde les têtes de bêtes que vous avez déposées sur son sol. Un serviteur muni d\'un balai les compte une à une, soustrayant d\'une pile pour en ajouter à une autre. Lorsqu\'il a terminé ses comptes, il les rapporte et le noble hoche la tête.%SPEECH_ON%Bon travail, mercenaire. Le serviteur va chercher votre salaire.%SPEECH_OFF%L\'homme de basse naissance soupire et range son balai. | %employer% ouvre la sacoche de scalps et de crânes de bêtes. Il pince les lèvres, renifle et referme la sacoche. Le noble demande à l\'un de ses serviteurs de compter les restes et de vous payer conformément à l\'accord.%SPEECH_ON%Un bon travail, mercenaire. Les habitants de la ville me sont reconnaissants de t\'avoir payé pour t\'occuper de ça.%SPEECH_OFF% | %employer% siffle en regardant ta collection de crânes et de scalps.%SPEECH_ON%C\'est un sacré boulot. Pour un travail de cette nature, je devrais envisager de vous payer un supplément, ce qui n\'est pas le cas, mais l\'idée m\'a traversé l\'esprit et c\'est ce qui compte vraiment.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse réussie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Hunted beasts around " + this.World.State.getRegion(this.Flags.get("Region")).Name);
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "SuccessLarge",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous transportez les restes de votre chasse dans la chambre de %employer%\. Il bondit en arrière comme si vous aviez maîtrisé la bête elle-même et l\'aviez chevauchée pour la conquérir. Se tenant la poitrine, le noble se recule.%SPEECH_ON%Par les dieux, mercenaire, si tu n\'étais pas si fou, tu aurais laissé ça dans la cour et tu serais allé me chercher pour que je descende.%SPEECH_OFF%En haussant les épaules, tu réclames ta paye. Il vous demande comment vous l\'avez tué. Vous Revenez sur la question de la solde. Le noble pince les lèvres.%SPEECH_ON%D\'accord. Serviteur ! Vous traînez les restes de la bête dans la cour et vous appelez %employer%. Il s\'approche de la fenêtre et regarde longuement en bas.%SPEECH_ON%Vraiment ou est-ce une blague ? %SPEECH_OFF%Soupirant, vous dégainez votre épée et la plongez dans un gros globe oculaire. Avec un bruit sec, il se dégonfle et projette une pellicule jaune sur la terre. Le noble siffle et fait claquer sa langue.%SPEECH_ON%Par les grands dieux, si vous ne l\'avez pas fait ! Je vais demander à un serviteur d\'aller vous chercher votre salaire à l\'instant même ! %SPEECH_OFF% | Vous mettez un âne à contribution et lui demandez d\'aider à tirer l\'abomination tuée jusqu\'à la ville. Il regarde son colis tordu et étrange d\'un coup de tête et d\'un regard muet. %employer% vous retrouve à l\'extérieur de son domaine. Il se tient à l\'écart des restes monstrueux, le menton dans le creux d\'un doigt et d\'un pouce.%SPEECH_ON%Incroyable. Je ne peux pas imaginer à quoi il ressemblait vivant et en train de se battre.%SPEECH_OFF%En hochant la tête, vous faites savoir à l\'homme qu\'il y en a sans doute d\'autres comme ça dans la nature et qu\'il devrait vous accompagner la prochaine fois que vous vous lancerez dans la chasse. Il secoue la tête.%SPEECH_ON%Je vais passer mon tour, mercenaire. Voici ta paye, et je t\'ordonne de rendre cet âne à son propriétaire.%SPEECH_OFF%Un fermier arrive à grands pas en s\'essuyant le front avec un chiffon.%SPEECH_ON%Ça s\'appelle un hinny et si tu voulais emprunter cette satanée chose, tu n\'avais qu\'à demander !%SPEECH_OFF% | Vous hachez les restes de la bête et les traînez par morceaux dans la chambre de %employer%. Il se met un linge sur le nez tandis que les cadavres s\'empilent.%SPEECH_ON%Les mythes sont donc vrais. Les bêtes sont réelles. %SPEECH_OFF%Quelques serviteurs recollent les morceaux, donnant une image difforme de la monstruosité qui se défait à chaque fois qu\'ils lâchent la main de la chair. Le noble acquiesce et claque des doigts.%SPEECH_ON%Donnez sa solde au mercenaire et allez chercher mes conseillers.%SPEECH_OFF% L\'un des %employeurs% se tient à l\'écart avec un burin, prêt à découper les restes de la bête. Il fait un grand sourire.%SPEECH_ON%Le nom de famille peut être mis à rude épreuve, et utilisé comme une hache ou une épée.%SPEECH_OFF%Vous dites à ces deux hommes qu\'ils ne toucheront pas à quoi que ce soit, tant qu\'ils ne vous paieront pas. Le noble sourit.%SPEECH_ON%Pas besoin d\'être agressif, mercenaire. J\'ai un serviteur qui va vous chercher votre solde à l\'instant même. Et si tu oses encore dire un mot sur ce ton, j\'aurai ta langue, tueur de monstres ou pas.%SPEECH_OFF%Tu fais preuve de patience, la main sur le pommeau et un compte à rebours dans la tête. Heureusement pour tout le monde, le serviteur arrive avant que le compte à rebours n\'atteigne zéro. | %employer% applaudit comme un enfant à la présentation des restes de la bête.%SPEECH_ON%Les histoires que l\'on racontera sur mes exploits seront grandioses. Je ferai des étagères et des poignées avec ces os, et je raconterai comment j\'ai récupéré les têtes monstrueuses.%SPEECH_OFF%Vous acquiescez. Ça a l\'air génial. Ce n\'est pas comme si les livres d\'histoire allaient enregistrer votre nom de toute façon. Vous demandez votre salaire. Acquiesçant et ne quittant pas la créature des yeux, %employer% claque des doigts.%SPEECH_ON%Serviteurs ! Apportez-lui son argent !%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse réussie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Hunted beasts around " + this.World.State.getRegion(this.Flags.get("Region")).Name);
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
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
		local dest = this.World.State.getRegion(this.m.Flags.get("Region")).Center;
		local distance = this.World.State.getPlayer().getTile().getDistanceTo(dest);
		distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
		_vars.push([
			"killcount",
			this.m.Flags.get("HeadsCollected")
		]);
		_vars.push([
			"noblehousename",
			this.World.FactionManager.getFaction(this.m.Faction).getNameOnly()
		]);
		_vars.push([
			"worldmapregion",
			this.World.State.getRegion(this.m.Flags.get("Region")).Name
		]);
		_vars.push([
			"direction",
			this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(dest)]
		]);
		_vars.push([
			"distance",
			distance
		]);
		_vars.push([
			"regiontype",
			this.Const.Strings.TerrainShort[this.World.State.getRegion(this.m.Flags.get("Region")).Type]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
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
		_out.writeU8(this.m.Size);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Size = _in.readU8();
		this.contract.onDeserialize(_in);
	}

});


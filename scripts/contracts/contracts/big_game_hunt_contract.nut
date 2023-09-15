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
			Text = "[img]gfx/ui/events/event_63.png[/img]{Vous entrez dans la pièce de %employer%. L\'homme se tripote les doigts avec une plume de paon, agitant ses couleurs d\'un côté et repoussant la saleté de l\'autre. Il parle plutôt dédaigneusement de votre présence.%SPEECH_ON%Mes gardes m\'ont déjà informé que vous étiez intéressé par une chasse à la bête et j\'en suis très heureux. Le salaire sera versé par tête. Des bêtes plus petites, des webknechts, des mangeurs de cadavres, le genre de choses qui, j\'en suis sûr, ne vous dérange pas, mais que les habitants ont trop peur d'affronter. Si vous êtes aussi bon dans votre travail que les gens semblent le dire, vous ne devriez pas hésiter à sauter sur cette offre. Débarrasser mes terres de tous ceci. Pour commencer, il y a eu des observations dans la région de %worldmapregion% %distance% %direction% d'ici.%SPEECH_OFF% | %employer% vous accueille dans sa chambre. Il prend un parchemin que le crieur public vous a donné en vous promenant sur les marchés un peu plus tôt.%SPEECH_ON%Ah, Vous êtes ici pour la chasse à la bête, alors. Je pensais que vous étiez un divertissement de...%SPEECH_OFF%Il pince le côté de votre chemise et esquisse un sourire.%SPEECH_ON%Une autre sorte. Quoi qu\'il en soit, des bêtes ravagent la campagne et je vous paierai volontiers une somme rondelette pour vous en occuper. La rémunération se fera par tête, bien sûr, ce qui vous permettra de gagner beaucoup d'argent si vous gardez votre lame bien éguisée. Si vous avez besoin d\'un endroit pour commencer votre chasse, Voyagez jusqu\'à la région de %worldmapregion% %distance% %direction% d\'ici. Vous y trouverez un tas de grands monstres à huit pattes et de monstres à fourrure. Tout ce qui peut effrayer un simple agriculteur n\'est pas trop effrayant pour vous, grand homme.%SPEECH_OFF% | Vous trouvez %employer% avec ses pieds sans bottes sur une table, une foule de femmes les retaillants. Ils retirent des morceaux de terre épaissie d\'entre ses orteils comme s\'il s\'agissait des rites de naissance d\'une monstruosité imaginaire. Vous vous raclez la gorge. L\'homme s\'éclaircit la gorge en signe de surprise.%SPEECH_ON%Ah oui, les mercenaires. J'ai une tâche à vous confier si vous êtes intéressé.%SPEECH_OFF%Il jette dédaigneusement à vos pieds un parchemin qui mentionne un besoin de tuer des bêtes. Webknechts. Des loups affamés. Rien de bien effrayant. Une note sur la carte indique la région voisine de %worldmapregion% à la %direction%. L\'homme rote.%SPEECH_ON%Le salaire est par tête, j'espère que ça vous va.%SPEECH_OFF% | Vous trouvez %employer% faisant tourner un couteau dans sa main. La séparation entre la poignée et l\'endroit où aurait dû se trouver la lame est clairement éclatée, ce qui témoigne de la fin décisive de l\'utilisation de l\'arme. L\'homme le jette sur sa table et fait tomber de la sciure de bois de ses mains.%SPEECH_ON%Des bêtes rôdent dans les parages et j\'ai besoin de quelqu\'un de votre trempe pour les tuer toutes. Qu\'en dites-vous ? La rémunération se fera à la tête. Toutes sortes de petites bêtes y causent des nuisances.%SPEECH_OFF% | %employer% vous accueille dans sa chambre. Sa table est couverte de parchemins, chacun avec des dessins d\'animaux et de bêtes, voire de monstres. Il mâchonne des baies et crache du jus en parlant.%SPEECH_ON%Les habitants de la région disent qu\'il se passe des choses abominables, mais aucun d'entre eux ne veut me donner une description précise de ce qu\'est le problème. Quelque chose à propos de loups monstrueux ou de monstres à huit pattes. Je peux difficilement rester sans rien faire, c\'est pourquoi je fais appel à vos services. Rendez-vous au fief de %worldmapregion% %distance% %direction%. Si vous voyez des bêtes, tuez-les sur place et prenez leur tête. Je paierai au scalp.%SPEECH_OFF% | %employer% vous retrouve alors qu\'il est en réunion avec un groupe de fermiers. Il affirme que de prétendus monstres mettent l\'arrière-pays en pièces. Un fermier prend la parole.%SPEECH_ON%Des bêtes, des tas de bêtes. Des loups qui marchent sur leurs pattes arrière, des araignées yea de grosses choses mangeuses de cadavres qui puent l'écume.%SPEECH_OFF%Le noble fait un signe de la main.%SPEECH_ON%Oui, oui, ça suffit. Mercenaires, j\'ai besoin que vous partiez à la chasse de ces créatures. Commencez par vous rendre dans la région de %worldmapregion% au %direction% d\'ici et veillez à ce que les bêtes qui se promènent soient abattues. Mais n\'oubliez pas de ramener leurs têtes, je vous paierai pour chacune d\'entre elles. Enfin, si vous êtes intéressé, bien sûr.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% est en train de feuilleter les pages d\'un ouvrage lorsque vous entrez. Il lève les yeux et vous fait signe de venir.%SPEECH_ON%Apporter une bougie.%SPEECH_OFF%Vous enlevez une torche du mur et le noble tend les mains en avant.%SPEECH_ON%J\'ai dit une bougie, pas une foutue torche ! Que voulez-vous faire, réduire en cendres tous les livres que j'ai ? Restez où vous êtes. Ecoutez, les gens autour ont parlé de maux dont je n\'avais pas entendu parler depuis des années. Des monstres qui s\'attaquent à vos rêves, des géants si grands qu\'un homme pourrait tenir dans leur barbe, et le pire d\'entre eux, bien sûr, de belles femmes qui savent qu\'elles sont belles.%SPEECH_OFF%Vous n\'êtes pas sûr à propos de la dernière chose, mais vous ne le dites pas. Le noble poursuit en expliquant que vous devez tuer tous les crétins que vous trouverez dans son royaume. Il a été vue des choses à %worldmapregion% dans la %direction%, mais vous êtes libre de chasser les créatures à votre guise, où qu'elles se cachent. | Vous trouvez %employer% en assemblée avec un certain nombre d\'hommes en cape noire. Ils vous demandent de venir, ce que vous faites à contrecœur. Le noble vous demande si vous connaissez des monstres comme les unholds, ou des créatures qui se nourrissent de rêves. Avant que vous ne puissiez répondre, il fait un signe de la main.%SPEECH_ON%Peu importe. J\'ai besoin d\'hommes armés pour passer au peigne fin la région %worldmapregion% region %direction% d'ici et voir si quelque chose d'étrange se prépare.  Si ce n\'est pas un humain avec un coeur qui bat, tuez-le. Prenez sa tête. Et revenez me voir. Je vous paierai généreusement pour chaque tête. S\'ils existent, bien sûr.%SPEECH_OFF% | %employer% pèse des parchemins dans ses deux mains, ne lisant ni l\'un ni l\'autre tandis qu\'il fixe un troisième sur son bureau. Finalement, il jette les deux parchemins et jette le dernier à la poubelle. Il vous regarde.%SPEECH_ON%La rumeur se répand que des monstres sont à l\'œuvre. Des hommes géants qui mangent du bétail et des enfants. On rapporte que des gens font des cauchemars et tuent leurs voisins à cause d\'eux. Et puis, on parle beaucoup d\'une belle femme dans la région. Je ne sais pas s\'il s\'agit d\'une créature immonde, mais une belle femme qui habite %worldmapregion% dans la %direction% d\'ici me semble être une source d\'ennuis.%SPEECH_OFF%Vous acquiescez. Une femme seule dans une région inconnue, c\'est certainement un problème pour quelqu\'un. Le noble écarte les bras.%SPEECH_ON%Voudriez-vous emmener vos hommes sur cette terre et trouver la frontière entre la vérité et la fiction ? Et si vous trouvez quelque chose qui glisse, qui siffle ou qui n\'est pas humain, tuez cette maudite chose et apportez-moi sa tête.%SPEECH_OFF% | Vous trouvez %employer% en train de feuilleter des livres avec une bougie si près de la page que la pénombre pâlit sur les bords du tome.C\'est comme si lui seul devait lire les textes. En vous voyant, il vous fait signe d\'avancer.%SPEECH_ON%Nous avons des rapports sur des événements étranges dans la région de %worldmapregion% à la %direction%. Les meurtres sont en hausse et je ne sais pas pourquoi. Et puis il y a des gens qui disparaissent purement et simplement. Ce n\'est jamais bon signe. Je ne sais pas si c\'est une secte ou une créature qui est responsable, mais j\'ai besoin d\'hommes armés pour aller sur ces terres et mettre les choses au clair. Si vous croisez de l\'acier avec quelque chose d\'étrange, apportez-moi sa tête, car je vous paierai très cher. %SPEECH_OFF% | %employer% se trouve en haut d\'une échelle, en train de fouiller dans l\'étagère la plus haute qu\'il possède. Il secoue la tête et vous fait signe d\'entrer.%SPEECH_ON%Je n\'ai pas la moindre idée de ce que je cherche.%SPEECH_OFF%Vous acquiescez et lui dites de rejoindre le club. L\'homme descend.%SPEECH_ON%Très drôle, mercenaire. Ecoutez, j\'ai eu vent d'évènements dans la région de %worldmapregion% %distance% %direction% d\'ici. Il n\'y a pas beaucoup de gens qui vivent dans cette région, mais ceux qui y vivent parlent d\'horreurs absolues qui parcourent le pays. Des hommes géants, des esprits qui infestent leurs rêves, et j\'en passe. J\'ai besoin que vous preniez votre groupe d\'hommes et que vous fassiez taire ce qui "bouillonne", d\'accord ? Et apportez-moi les têtes de toutes les monstruosités inhumaines que vous trouverez. Je vous paierai bien pour chacune d\'entre elles.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% est assis à un bureau. Il n\'y a personne d\'autre dans la pièce. Il vous propose un siège que vous prenez. Il se penche en avant.%SPEECH_ON%Ma famille a une sorte de légende. Mon père a rencontré cette légende, ainsi que le père de mon père. Nous ne savons pas d\'où vient cette légende. Je m\'attendais à voir cette légende à mon époque et j\'ai l'impression que c\'est le cas. Dans un rêve, la nuit dernière.%SPEECH_OFF%En entendant cela, vous êtes au bord de votre siège parce qu\'il y a un trou au milieu. Vous acquiescez et il continue.%SPEECH_ON%Voyagez jusqu\'à %worldmapregion% à %direction%. Je crois que les légendes sont vraies, qu\'une énorme bête erre sur ces terres. Peut-être même plus qu\'une seule ! Quoi qu\'il en soit, j\'ai besoin du plus expérimenté des mercenaires pour la débusquer. Apportez-moi des têtes et vous serez largement récompensés. Êtes-vous prêt ? %SPEECH_OFF% | Vous entrez dans la chambre de %employer%\. Il vous tend un parchemin sur lequel figure un alphabet que vous ne pouvez pas lire. Le noble affirme qu\'il s\'agit d'un passage de légende. Il écarte les bras.%SPEECH_ON%Des bêtes de la taille d\'un arbre parcourent ces terres, je le crois. %direction% d\'ici se trouve la région de %worldmapregion%. Les paysans y parlent de monstruosités comme vous n\'en croiriez pas vos yeux. Mais j\'aimerais y croire. J\'aimerais en voir un de près, c\'est pourquoi je vous ai convoqué ici. Allez dans cet horrible territoire et veillez à ce que toute créature immonde soit tuée et que sa tête soit placée à mes pieds.%SPEECH_OFF% | %employer% vous accueille dans sa chambre puis passe directement aux choses sérieuses.%SPEECH_ON%J\'ai besoin que vous vous dirigiez %direction% vers la région de %worldmapregion%. J\'ai enregistré de nombreuses rumeurs concernant d\'énormes bêtes qui rôderaient dans cette région et je les crois sur parole. Des serpents de la taille d\'un arbre et des imitations d\'arbres également de la taille d\'un arbre ! Quoi qu\'il en soit, je veux que vous les tuiez et que vous m\'apportiez leurs têtes. Ou des écailles, des branches, peu importe. Je paierai pour chacun d\'entre eux. Cela vous intéresse-t-il ? %SPEECH_OFF% | %employer% vous tend un tome dont certaines pages sont écornées. Vous pensez qu\'il s\'agit là d\'un dangereux affront à un ouvrage qui est décidément rare, mais vous vous mordez la langue à ce sujet. Le noble vous demande si vous connaissez des géants, des dragons, des monstres marins, etc.Avant que vous ne puissiez répondre, %employer% pose son doigt sur la page ouverte du livre. Son doigt frappe le dessin d\'une bête plus grande qu'un chêne, en partie parce qu\'elle ressemble à un chêne.%SPEECH_ON%Je pense qu\'ils existent. Je pense qu\'ils sont là-bas, dans la %région de la carte du monde% en ce moment même, à %direction% d\'ici. Mercenaire, je veux que tu te rendes là-bas et que tu tues toutes les créatures immondes que tu trouveras. Apportez-moi leurs têtes. Les dangers ne sont pas mesurables, mais les énormes récompenses le seront. Pensez-vous en être capable ? %SPEECH_OFF% | %employer% vous accueille avec le visage d\'un homme sur le point d\'envoyer quelqu\'un à une mort certaine. Il sourit quand même parce que ce n\'est pas sa mort.%SPEECH_ON%Ah, c\'est bon de voir un homme d\'épée. Comme je suis sûr que vous l\'avez entendu, des rumeurs circulent sur le fait que la région de %worldmapregion% est absolument pleine de bêtes immondes.%SPEECH_OFF%Vous n\'êtes pas sûr que ce soit le langage que vous utiliseriez, mais vous acquiescez tout de même. Le noble acquiesce en retour.%SPEECH_ON%IJ\'ai peu d\'hommes en qui j\'ai confiance dans ce monde et l\'un d\'entre eux a récemment rapporté avoir vu une créature d\'une énormité sans commune mesure, bien qu\'il l\'ait estimée aussi haute qu\'un arbre. Et un autre éclaireur a dit que des serpents de la taille d'un dragon se promenaient dans les environs. Quoi qu\'il en soit, j\'ai besoin que vous voyagiez jusqu\'à la terre %direction% d\'ici et que vous tuiez ce qui la hante. D\'après les rapports, cela pourrait être la chose la plus dangereuse que vous ferez dans cette vie. Êtes-vous prêts ? Vos hommes sont-ils prêts ? Je n\'engagerai pas quelqu\'un qui hésite le moins du monde.%SPEECH_OFF%}  ",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{You come back and dump the beastly heads onto %employer%\'s floor. He looks up from his desk.%SPEECH_ON%Well that was unwarranted. Fetch the man his money, and fetch a servant to clean this mess.%SPEECH_OFF% | %employer% welcomes your return, though he keeps his distance. He\'s staring at your cargo.%SPEECH_ON%A fitting return, sellsword. I\'ll have one of my men count the heads and pay you according to our agreement.%SPEECH_OFF% | The slayings are produced for %employer%\'s approval. He nods and waves you away.%SPEECH_ON%Appreciated, but I need not look at those ghastly things a moment longer. %randomname%, come hither and pay this sellsword his money.%SPEECH_OFF% | %employer% welcomes you back and looks over your wares.%SPEECH_ON%Absolutely disgusting. Splendid! Here is your pay, as agreed upon.%SPEECH_OFF% | You show the heads to %employer% who counts them with a wiggling finger and his lips whispering numbers. Finally, he straightens up.%SPEECH_ON%I don\'t have time for this shite. %randomname%, yes you servant, get over here and count these heads and pay the sellsword the agreed amount for each.%SPEECH_OFF% | %employer% is eating an apple as he walks over to see what you\'ve returned with. He stares into the satchel of ghastly beast heads. He takes a huge bite of the apple.%SPEECH_ON%Ehpressive rehsalts, sehswahrd.%SPEECH_OFF%He quickly chews and swallows in a big gulp.%SPEECH_ON%See my servant standing idly yonder with the purse. He\'ll pay out what you are owed.%SPEECH_OFF%The nobleman tosses the half-eaten apple and fetches himself another. | %employer% has a child with him when you enter his room. The kiddo rushes to see what you\'ve brought, then retreats in a screaming fit. The nobleman nods.%SPEECH_ON%Suppose that means you got what I paid you for. My servant %randomname% will count the heads and pay what you are owed.%SPEECH_OFF% | You lug the heads into %employer%\'s room. He raises an eyebrow.%SPEECH_ON%Did you have to drag those all the way in here? Look, you\'ve left a stain! Why didn\'t you just fetch a servant, that\'s what they\'re there for. By the old gods the smell is worse than the stains!%SPEECH_OFF%The nobleman snaps his fingers at a man standing with a purse.%SPEECH_ON%%randomname%, count the heads and see to it that the sellsword gets his pay.%SPEECH_OFF% | You unfurl the sack of heads and let them pile onto %employer%\'s floor. He stands up.%SPEECH_ON%That\'s not on the rug, is it?%SPEECH_OFF%A servant runs over and kicks the heads apart. He quickly shakes his head no. The nobleman nods and slowly sits down.%SPEECH_ON%Good. You there, %randomname%, get to counting and then pay this mess making sellsword his dues. And by the way, mercenary, take it easy on the presentation next time, alright?%SPEECH_OFF% | You lug a satchel of beast scalps and heads into %employer%\'s room. Popping the lid, you start to tip it forward. A servant\'s eyes go wide and he rushes forward, slamming into the satchel and tilting it back over. The lid clatters closed over his fingers and he chokes down a yelp.%SPEECH_ON%Thank you, mercenary, but the noble sir would prefer we count these without spilling them all over the floor. I will add up the totals and pay you once I am finished.%SPEECH_OFF% | %employer% reviews your handiwork.%SPEECH_ON%Impressive. Disgusting. Not you, the beasts. I mean you\'re a filthy sort, sellsword, but these foul beasts are the antithesis of hygiene.%SPEECH_OFF%You don\'t know what that word means, or the other one for that matter. You simply ask that he count the heads and give you what you\'re owed. | %employer% counts the heads and then leans backs. He shrugs.%SPEECH_ON%I thought they\'d be scarier.%SPEECH_OFF%You mention that they\'ve but a slightly different affect on one\'s courage when still attached to the beastly torsos. The nobleman shrugs again.%SPEECH_ON%I suppose so, but my mother lost her head to an executioner\'s blade and she looked all the scarier settin\' in that basket staring up at the world.%SPEECH_OFF%You don\'t know what to say to that. You ask the man to pay you what you\'re owed. | %employer% eyes the beastly heads you\'ve deposited upon his floor. A servant with a broom counts them one by one, subtracting from one pile to add to another. When he\'s finished the accounting he reports his numbers and the nobleman nods.%SPEECH_ON%Good work, sellsword. The servant will fetch your pay.%SPEECH_OFF%The lowborn sighs and puts the broom away. | %employer% opens the satchel of beastly scalps and skulls. He purses his lips, sniffs, and claps it back closed. The nobleman instructs one of his servants to count out the remains and pay you according to the agreement.%SPEECH_ON%A good job, sellsword. The townsfolk are grateful that I paid you to take care of this.%SPEECH_OFF% | %employer% whistles as he stares at your collection of skulls and scalps.%SPEECH_ON%That\'s a hell of a sigh if there ever was one. For work of this nasty nature I should consider paying you extra, which I won\'t, but the thought crossed my mind and that\'s what really counts.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{You come back and dump the beastly heads onto %employer%\'s floor. He looks up from his desk.%SPEECH_ON%Well that was unwarranted. Fetch the man his money, and fetch a servant to clean this mess.%SPEECH_OFF% | %employer% welcomes your return, though he keeps his distance. He\'s staring at your cargo.%SPEECH_ON%A fitting return, sellsword. I\'ll have one of my men count the heads and pay you according to our agreement.%SPEECH_OFF% | The slayings are produced for %employer%\'s approval. He nods and waves you away.%SPEECH_ON%Appreciated, but I need not look at those ghastly things a moment longer. %randomname%, come hither and pay this sellsword his money.%SPEECH_OFF% | %employer% welcomes you back and looks over your wares.%SPEECH_ON%Absolutely disgusting. Splendid! Here is your pay, as agreed upon.%SPEECH_OFF% | You show the heads to %employer% who counts them with a wiggling finger and his lips whispering numbers. Finally, he straightens up.%SPEECH_ON%I don\'t have time for this shite. %randomname%, yes you servant, get over here and count these heads and pay the sellsword the agreed amount for each.%SPEECH_OFF% | %employer% is eating an apple as he walks over to see what you\'ve returned with. He stares into the satchel of ghastly beast heads. He takes a huge bite of the apple.%SPEECH_ON%Ehpressive rehsalts, sehswahrd.%SPEECH_OFF%He quickly chews and swallows in a big gulp.%SPEECH_ON%See my servant standing idly yonder with the purse. He\'ll pay out what you are owed.%SPEECH_OFF%The nobleman tosses the half-eaten apple and fetches himself another. | %employer% has a child with him when you enter his room. The kiddo rushes to see what you\'ve brought, then retreats in a screaming fit. The nobleman nods.%SPEECH_ON%Suppose that means you got what I paid you for. My servant %randomname% will count the heads and pay what you are owed.%SPEECH_OFF% | You lug the heads into %employer%\'s room. He raises an eyebrow.%SPEECH_ON%Did you have to drag those all the way in here? Look, you\'ve left a stain! Why didn\'t you just fetch a servant, that\'s what they\'re there for. By the old gods the smell is worse than the stains!%SPEECH_OFF%The nobleman snaps his fingers at a man standing with a purse.%SPEECH_ON%%randomname%, count the heads and see to it that the sellsword gets his pay.%SPEECH_OFF% | You unfurl the sack of heads and let them pile onto %employer%\'s floor. He stands up.%SPEECH_ON%That\'s not on the rug, is it?%SPEECH_OFF%A servant runs over and kicks the heads apart. He quickly shakes his head no. The nobleman nods and slowly sits down.%SPEECH_ON%Good. You there, %randomname%, get to counting and then pay this mess making sellsword his dues. And by the way, mercenary, take it easy on the presentation next time, alright?%SPEECH_OFF% | You lug a satchel of beast scalps and heads into %employer%\'s room. Popping the lid, you start to tip it forward. A servant\'s eyes go wide and he rushes forward, slamming into the satchel and tilting it back over. The lid clatters closed over his fingers and he chokes down a yelp.%SPEECH_ON%Thank you, mercenary, but the noble sir would prefer we count these without spilling them all over the floor. I will add up the totals and pay you once I am finished.%SPEECH_OFF% | %employer% reviews your handiwork.%SPEECH_ON%Impressive. Disgusting. Not you, the beasts. I mean you\'re a filthy sort, sellsword, but these foul beasts are the antithesis of hygiene.%SPEECH_OFF%You don\'t know what that word means, or the other one for that matter. You simply ask that he count the heads and give you what you\'re owed. | %employer% counts the heads and then leans backs. He shrugs.%SPEECH_ON%I thought they\'d be scarier.%SPEECH_OFF%You mention that they\'ve but a slightly different affect on one\'s courage when still attached to the beastly torsos. The nobleman shrugs again.%SPEECH_ON%I suppose so, but my mother lost her head to an executioner\'s blade and she looked all the scarier settin\' in that basket staring up at the world.%SPEECH_OFF%You don\'t know what to say to that. You ask the man to pay you what you\'re owed. | %employer% eyes the beastly heads you\'ve deposited upon his floor. A servant with a broom counts them one by one, subtracting from one pile to add to another. When he\'s finished the accounting he reports his numbers and the nobleman nods.%SPEECH_ON%Good work, sellsword. The servant will fetch your pay.%SPEECH_OFF%The lowborn sighs and puts the broom away. | %employer% opens the satchel of beastly scalps and skulls. He purses his lips, sniffs, and claps it back closed. The nobleman instructs one of his servants to count out the remains and pay you according to the agreement.%SPEECH_ON%A good job, sellsword. The townsfolk are grateful that I paid you to take care of this.%SPEECH_OFF% | %employer% whistles as he stares at your collection of skulls and scalps.%SPEECH_ON%That\'s a hell of a sigh if there ever was one. For work of this nasty nature I should consider paying you extra, which I won\'t, but the thought crossed my mind and that\'s what really counts.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{You lug the remains of your hunt into %employer%\'s room. He jumps back as though you\'d mastered the beast itself and ridden it to conquer. Clutching his chest, the nobleman sets back down.%SPEECH_ON%By the old gods, sellsword, if you weren\'t such a fool you would have left that in the yard and fetched me to walk on down.%SPEECH_OFF%Shrugging, you ask about your pay. He asks how you killed it. You Retournez à the issue of pay. The nobleman purses his lips.%SPEECH_ON%Alright. Servant! Get this obstinate beastslayer his coin.%SPEECH_OFF% | You drag the beastly remains into the yard and call up to %employer%. He comes to the window and looks down for a long time.%SPEECH_ON%Real or are you having a joke?%SPEECH_OFF%Sighing, you unsheathe your sword and plunge it into a large eyeball. With a pop it deflates and spews a yellow film all over the dirt. The nobleman whistles and clucks his tongue.%SPEECH_ON%By the old gods if you haven\'t done it! I will have a servant fetch your pay right this moment!%SPEECH_OFF% | You draft a donkey into service and have it help pull the slain abhorrence into town. It regards its crooked and unworldly luggage with a flick of an ear and a mute stare. %employer% meets you outside his domain. He stands aside the monstrous remains with his chin in the nook of a finger and thumb.%SPEECH_ON%Incredible. I can\'t imagine what it looked alive and fighting.%SPEECH_OFF%Nodding, you let the man know that there are no doubt more like it out there and he should come along the next time you take up a hunt. He shakes his head.%SPEECH_ON%I shall pass on that offer, sellsword. Here is your pay, and I order you to give that donkey back to its owner.%SPEECH_OFF%A farmer strides up wiping his forehead with a cloth.%SPEECH_ON%It\'s called a hinny and if you wanted to borrow the damned thing you could have just asked!%SPEECH_OFF% | You chop up the beastly remains and drag them piecemeal into %employer%\'s room. He puts a cloth to his nose as the cadaver piles up.%SPEECH_ON%So the myths are true. The beasts are real.%SPEECH_OFF%A few servants put the chunks back together, giving a misshapen image of the monstrosity which slides apart every time they let their hands go of the flesh. The nobleman nods and snaps his fingers.%SPEECH_ON%Get the mercenary his pay and fetch my advisers.%SPEECH_OFF% | One of %employer%\'s stands aside with a burin, ready to chisel away into the beastly remains. He grins widely and wildly.%SPEECH_ON%The family name can be down the bone, and used as a helve for an axe of sword.%SPEECH_OFF%You tell both the men they aren\'t touching a damned thing lest they pay you. The nobleman grins.%SPEECH_ON%No need to be testy, mercenary. I have a servant fetching your pay this moment. And if you dare raise a word in that tone again I\'ll have your tongue, slayer of monsters or no.%SPEECH_OFF%You demonstrate patience with your hand to your pommel and a countdown in your head. Thankfully for everyone involved, the servant arrives before it hits zero. | %employer% claps like a child at the demonstration of the beastly remains.%SPEECH_ON%The stories told of my doings will be great. I shall make helves and handles out of these bones, and tell stories of how I claimed the monstrous heads.%SPEECH_OFF%You nod. Sounds great. Not like the history books were going to record your name anyway. You ask for your pay. Nodding and not taking his eyes off the creature, %employer% snaps his fingers.%SPEECH_ON%Servants! Get the man his coin!%SPEECH_OFF%}",
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

